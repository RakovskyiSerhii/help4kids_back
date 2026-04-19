# Payment Gateway Integration Strategy - WayForPay

This document outlines the strategy for implementing WayForPay as the payment gateway for the help4kids platform. **Note: This assumes your WayForPay merchant profile is already completed and approved.**

## Overview

WayForPay is a payment gateway that supports:
- VISA & Mastercard cards
- Google Pay / Apple Pay
- Local payment methods (Privat24, etc.)
- Installment payments from Ukrainian banks
- QR payments
- Payment by invoice
- Recurring payments and subscriptions

**Key Features:**
- PCI DSS certified
- 3D Secure v2 support
- ~2% commission on successful payments
- Next-day settlement for funds
- Support for authorization-hold + settle model (AUTH + Settle flows)

## Integration Approach

### Phase 1: Hosted Checkout (Recommended for MVP)

**Why start here:**
- Fastest to implement
- Lowest PCI compliance burden
- WayForPay handles all sensitive card data
- Lower risk of security issues

**How it works:**
1. Backend creates payment request via WayForPay API
2. Frontend redirects user to WayForPay's hosted payment page OR embeds their widget
3. User completes payment on WayForPay's secure page
4. WayForPay sends webhook callback to our backend
5. User is redirected back to our site

### Phase 2: Direct API Integration (Future Enhancement)

For more control over UX and mobile app integration, we can later implement:
- Direct API calls to WayForPay
- Tokenization for saved cards
- Custom checkout UI (requires PCI compliance)

## Data Model

### Order Table (Existing)
- `id` - Primary key
- `user_id` - Foreign key to users
- `amount` - Total order amount
- `currency` - Currency code (UAH, USD, etc.)
- `status` - Order status enum: `pending`, `awaiting_payment`, `paid`, `failed`, `cancelled`, `refunded`
- `created_at`, `updated_at` - Timestamps

### Payment Table (New - to be created)
- `id` - Primary key
- `order_id` - Foreign key to orders (one order can have multiple payment attempts)
- `gateway` - Payment gateway identifier (`wayforpay`)
- `gateway_invoice_id` - WayForPay's `orderReference` / invoice ID
- `amount` - Payment amount
- `currency` - Payment currency
- `status` - Payment status: `initiated`, `processing`, `successful`, `failed`, `refunded`
- `raw_gateway_payload` - JSON field to store full webhook payload for debugging
- `created_at`, `updated_at` - Timestamps

**Relationship:** Order 1-to-many Payment (allows retries, partial payments, refunds)

## Payment Flow

### 1. Payment Initiation

**Endpoint:** `POST /api/orders/{id}/pay`

**Backend Process:**
1. Validate user owns the order
2. Verify user profile is completed
3. Check order is in `awaiting_payment` status
4. Create `Payment` record with `status = 'initiated'`
5. Build WayForPay payment request payload:
   ```
   {
     merchantAccount: <from config>,
     merchantDomainName: <your domain>,
     orderReference: <unique payment ID>,
     orderDate: <timestamp>,
     amount: <order.amount>,
     currency: <order.currency>,
     productName: [...],
     productPrice: [...],
     productCount: [...],
     returnUrl: <frontend success page URL>,
     serviceUrl: <backend webhook URL>
   }
   ```
6. Sign payload with WayForPay merchant secret key (HMAC)
7. Return redirect URL or form data to frontend

**Frontend Process:**
1. Call backend endpoint
2. Receive redirect URL or form data
3. Redirect user to WayForPay OR submit form
4. Show "Processing payment..." state

### 2. Webhook Handling (Critical)

**Endpoint:** `POST /api/payments/wayforpay/callback`

**Security Checks:**
1. Verify HMAC signature using merchant secret key
2. Validate `orderReference` exists in our database
3. Validate amount and currency match our records
4. Reject if any validation fails

**Processing Logic:**
1. Find `Payment` record by `gateway_invoice_id` (WayForPay's `orderReference`)
2. Map WayForPay status to internal status:
   - `Approved` → `Payment.status = 'successful'`, `Order.status = 'paid'`
   - `Declined`, `Expired`, `InProcessing` → `Payment.status = 'failed'` or `processing`
3. **Make webhook idempotent:** If already processed with same status, skip update
4. Store full webhook payload in `raw_gateway_payload` for debugging
5. Return success response to WayForPay (they will retry if we return error)

**Status Mapping:**
| WayForPay Status | Internal Payment Status | Order Status |
|-----------------|------------------------|--------------|
| Approved | successful | paid |
| Declined | failed | awaiting_payment |
| Expired | failed | awaiting_payment |
| InProcessing | processing | awaiting_payment |
| Refunded | refunded | refunded |

### 3. Return URL Handling

**Frontend Route:** `/payment-result?order_id={id}`

**Process:**
1. User redirected back from WayForPay
2. Frontend calls `GET /api/orders/{id}` to get current status from our DB
3. **Never trust query params** - always fetch from backend
4. Display appropriate UI:
   - Success: Show confirmation, next steps
   - Processing: Show spinner, poll backend (short interval, time-boxed)
   - Failed: Show error message, retry button

## Refunds & Cancellations

### Refund Flow

**Endpoint:** `POST /api/orders/{id}/refund` or `POST /api/payments/{id}/refund`

**Process:**
1. Validate business rules:
   - User has permission (admin/owner)
   - Refund is within allowed window
   - Amount is valid (full or partial)
2. Call WayForPay refund API with:
   - `orderReference` (original payment's `gateway_invoice_id`)
   - `amount` (refund amount)
   - `comment` (optional reason)
3. On success:
   - Create new `Payment` record with `status = 'refunded'` OR update existing
   - Update `Order.status = 'refunded'` (or track partial refunds separately)
4. Handle WayForPay refund webhooks (if supported) for reconciliation

## Security & Configuration

### Environment Variables

Store in `.env` or secure config:
```
WAYFORPAY_MERCHANT_ACCOUNT=<your merchant account>
WAYFORPAY_SECRET_KEY=<your secret key>
WAYFORPAY_API_URL=<production or sandbox URL>
WAYFORPAY_SERVICE_URL=<your webhook endpoint URL>
```

### Security Best Practices

1. **Webhook Validation:**
   - Always verify HMAC signature
   - Validate all critical fields (amount, currency, orderReference)
   - Reject requests from unknown IPs (if WayForPay provides IP whitelist)

2. **HTTPS Only:**
   - All payment-related endpoints must use HTTPS
   - Webhook endpoint must be HTTPS

3. **Logging:**
   - Log all payment creation requests/responses (without sensitive data)
   - Log all webhook payloads and processing results
   - Log all refund operations
   - Never log card numbers or CVV

4. **Error Handling:**
   - If gateway unreachable during payment creation: Don't create payment record, return user-friendly error
   - If webhook fails temporarily: Return 5xx so WayForPay retries (make processing idempotent)
   - If webhook fails permanently: Log for manual review

## Implementation Rollout Plan

### Stage 1: Sandbox Testing
- [ ] Set up WayForPay sandbox/test environment
- [ ] Implement payment creation endpoint
- [ ] Implement webhook handler with signature validation
- [ ] Implement return URL handler
- [ ] Test all scenarios:
  - [ ] Successful payment
  - [ ] Declined payment
  - [ ] User closes window mid-payment
  - [ ] Webhook retries / duplicate notifications
  - [ ] Refunds
  - [ ] 3D Secure flows

### Stage 2: Limited Production
- [ ] Switch to production WayForPay credentials
- [ ] Enable for internal test accounts only
- [ ] Monitor logs, webhook success rate, payment conversion
- [ ] Reconcile payments with WayForPay dashboard
- [ ] Test with real cards (small amounts)

### Stage 3: Full Rollout
- [ ] Enable for all users
- [ ] Set up monitoring dashboards:
  - [ ] Payment conversion rate (clicked "Pay" → "Paid")
  - [ ] Payment failure rate
  - [ ] Time from payment to webhook confirmation
  - [ ] Refund rate
- [ ] Set up alerts for:
  - [ ] High failure rate
  - [ ] Webhook processing errors
  - [ ] Payment gateway downtime

## Database Schema Changes

### New Payment Table

```sql
CREATE TABLE payments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  gateway VARCHAR(50) NOT NULL DEFAULT 'wayforpay',
  gateway_invoice_id VARCHAR(255) NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) NOT NULL,
  status ENUM('initiated', 'processing', 'successful', 'failed', 'refunded') NOT NULL,
  raw_gateway_payload JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  INDEX idx_gateway_invoice (gateway, gateway_invoice_id),
  INDEX idx_order_id (order_id),
  INDEX idx_status (status)
);
```

### Order Table Updates

Ensure `orders.status` enum includes all required values:
```sql
ALTER TABLE orders 
MODIFY COLUMN status ENUM(
  'pending', 
  'awaiting_payment', 
  'paid', 
  'failed', 
  'cancelled', 
  'refunded'
) NOT NULL;
```

## API Endpoints Summary

### Payment Initiation
- `POST /api/orders/{id}/pay` - Create payment and get redirect URL

### Webhooks
- `POST /api/payments/wayforpay/callback` - Receive payment status from WayForPay

### Refunds
- `POST /api/orders/{id}/refund` - Refund an order (admin only)
- `POST /api/payments/{id}/refund` - Refund a specific payment (admin only)

### Status Check
- `GET /api/orders/{id}` - Get order status (existing endpoint, will include payment info)

## Operational Considerations

### Customer Support
- Ensure support team can:
  - View payment status in admin panel
  - Process manual refunds
  - Handle payment disputes
  - Access payment logs for troubleshooting

### Reconciliation
- Daily reconciliation process:
  - Compare WayForPay dashboard with our database
  - Identify discrepancies
  - Handle missing webhooks manually if needed

### Currency Handling
- WayForPay supports multi-currency payments
- Payouts typically in UAH
- Be aware of FX risk and bank fees
- Consider currency conversion in pricing display

### Fallback Strategy
- Consider maintaining alternative payment provider for redundancy
- Or provide manual payment option (bank transfer) as fallback

## Testing Checklist

### Payment Flows
- [ ] Successful card payment
- [ ] Declined card payment
- [ ] 3D Secure authentication
- [ ] Google Pay / Apple Pay
- [ ] Local payment methods (Privat24, etc.)
- [ ] User abandons payment mid-flow
- [ ] Payment timeout / expiration

### Webhook Scenarios
- [ ] Successful payment webhook
- [ ] Failed payment webhook
- [ ] Duplicate webhook (idempotency)
- [ ] Webhook with invalid signature (should reject)
- [ ] Webhook with mismatched amount (should reject)
- [ ] Webhook retry after temporary failure

### Refund Scenarios
- [ ] Full refund
- [ ] Partial refund
- [ ] Refund of already refunded payment (should fail gracefully)
- [ ] Refund webhook handling (if supported)

### Edge Cases
- [ ] Payment created but webhook never arrives (manual reconciliation)
- [ ] Webhook arrives before user returns to site
- [ ] Multiple payment attempts for same order
- [ ] Payment amount mismatch between order and payment

## Resources

- WayForPay Developer Documentation: [wiki.wayforpay.com](https://wiki.wayforpay.com)
- WayForPay Main Site: [wayforpay.com](https://wayforpay.com)
- Support: Contact WayForPay support for API credentials and technical questions

## Notes

- This strategy assumes profile is already completed and approved
- Start with hosted checkout for speed and security
- Plan for direct API integration as future enhancement
- Always prioritize security: validate webhooks, use HTTPS, never log sensitive data
- Make all webhook processing idempotent to handle retries safely

