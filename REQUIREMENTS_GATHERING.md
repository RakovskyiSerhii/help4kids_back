# Requirements: Profile, Payments, Content & Videos

## Overview
This document collects and documents requirements for:
1. **User Profile Management**
2. **Payment Processing (WayForPay)**
3. **Buyable Content Management** (replaces "courses" - can be single video/webinar or multiple videos with materials)
4. **Video Content Management**

---

## ✅ CONFIRMED REQUIREMENTS

### 1. User Profile

**Fields needed:**
- ✅ Email (already exists)
- ✅ Name (firstName, lastName - already exists)
- ✅ Phone number (needs to be added)

**Features:**
- View own profile
- Edit own profile
- Simple profile - no extra fields needed for MVP

---

### 2. Payment Processing

**Payment Gateway:**
- ✅ WayForPay (WFP)

**Features needed:**
- Create payment for order
- Payment status tracking
- Payment callbacks/webhooks
- Payment history

---

### 3. Buyable Content (Naming Decision Needed)

**Current situation:**
- We have buyable content that can be:
  - Single long video (webinar)
  - Multiple videos with materials attached
- Current name "courses" doesn't fit well

**Naming options:**
1. **"Content"** - Simple, generic, works for both cases
2. **"Content Package"** - Descriptive, clear it's a package
3. **"Video Content"** - Specific to video-based content
4. **"Program"** - Sounds professional
5. **"Product"** - Simple, but might confuse with physical products
6. **"Learning Content"** - Clear but longer

**Recommendation:** Use **"Content"** or **"Content Package"** - simple and flexible.

**Content structure:**
- Can contain:
  - Single video (webinar case)
  - Multiple videos
  - Materials/files attached
- Has: title, description, price
- Is buyable/purchasable

---

### 4. Video Hosting

**Status:** Not decided yet
**Requirement:** Needs to be affordable

**Options to consider:**
- YouTube (free, but public/unlisted)
- Vimeo (paid, private videos)
- Cloudinary (video hosting)
- AWS S3 + CloudFront (self-managed)
- Bunny.net (affordable CDN)
- Self-hosted (cheapest but requires infrastructure)

**Questions:**
- Do videos need to be private/restricted?
- What's the budget range?
- Expected video file sizes?
- Expected number of videos?

---

## 📋 OPEN QUESTIONS

### Content Structure

**Questions:**
1. What should we call it? (see naming options above)
2. For single video case - is it just a video URL, or do we need more metadata?
3. For multiple videos case:
   - How are videos organized? (sequence/order?)
   - What kind of materials? (PDFs, documents, images?)
   - How are materials attached?
4. Do we need progress tracking? (for multi-video content)
5. Do we need completion tracking?

### Video Hosting

**Questions:**
1. Do videos need to be private/restricted to purchasers only?
2. What's the budget range for video hosting?
3. Expected video file sizes?
4. Expected number of videos initially?
5. Do we need video analytics (views, watch time)?

### Payment Flow

**Questions:**
1. When user purchases content - do they get immediate access?
2. Do we need refund functionality?
3. Any special payment scenarios? (discounts, coupons, etc.)

### Access Control

**Questions:**
1. After purchase - lifetime access or time-limited?
2. Can user re-watch videos?
3. Do we need download option for videos?

---

## Current State Analysis

### What Already Exists

**User Model:**
- Basic user fields (id, email, firstName, lastName, roleId, isVerified)
- Authentication system

**Content Model (currently called "Course"):**
- Basic fields (id, title, description, price, contentUrl)
- CourseService with CRUD operations
- `getPurchasedCourses` method exists
- **Note:** May need to rename to "Content" or "ContentPackage"

**Order Model:**
- Order creation and tracking
- Basic payment status (pending, paid, failed)
- OrderService with basic operations

**Payment:**
- Payment callback endpoint exists
- WayForPay integration strategy documented

---

## Next Steps

1. **Answer the questions above** to define requirements
2. **Prioritize features** (MVP vs. future enhancements)
3. **Define API endpoints** needed
4. **Design database schema** changes
5. **Plan implementation phases**

---

## Notes

- Add any additional requirements or constraints here
- Document any business rules or special cases
- Note any integrations with external services

