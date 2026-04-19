-- Migration: Create payments table
-- This table stores payment records linked to orders

CREATE TABLE IF NOT EXISTS payments (
  id VARCHAR(36) PRIMARY KEY,
  order_id VARCHAR(36) NOT NULL,
  gateway VARCHAR(50) NOT NULL DEFAULT 'wayforpay',
  gateway_invoice_id VARCHAR(255) NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'UAH',
  status ENUM('initiated', 'processing', 'successful', 'failed', 'refunded') NOT NULL DEFAULT 'initiated',
  raw_gateway_payload JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  INDEX idx_gateway_invoice (gateway, gateway_invoice_id),
  INDEX idx_order_id (order_id),
  INDEX idx_status (status)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

