# Frontend-Backend Alignment Plan

## 📊 Current Status Summary

### ✅ **FULLY IMPLEMENTED** (with path differences)

1. **Courses** ✅
   - Backend: `POST /api/courses`, `PUT /api/courses/course/{id}`, `DELETE /api/courses/course/{id}`
   - Frontend expects: `POST /api/courses/create`, `PUT /api/courses/{id}`, `DELETE /api/courses/{id}`
   - **Action**: Add route aliases or update paths

2. **Consultations** ✅
   - Backend: `POST /api/consultations`, `PUT /api/consultations/consultation/{id}`, `DELETE /api/consultations/consultation/{id}`
   - Frontend expects: `POST /api/consultations/create`, `PUT /api/consultations/{id}`, `DELETE /api/consultations/{id}`
   - **Action**: Add route aliases or update paths

3. **Articles** ✅
   - Backend: `POST /api/articles`, `PUT /api/articles/{id}`, `DELETE /api/articles/{id}`
   - Frontend expects: `POST /api/articles/create`, `PUT /api/articles/{id}`, `DELETE /api/articles/{id}`
   - **Action**: Add `/create` route alias

4. **Services** ✅ (Actually exists!)
   - Backend: `POST /api/services`, `PUT /api/services/{id}`, `DELETE /api/services/{id}`
   - Frontend expects: `POST /api/services/create`, `PUT /api/services/{id}`, `DELETE /api/services/{id}`
   - **Action**: Add `/create` route alias

### ❌ **MISSING**

1. **Staff UPDATE & DELETE** ❌
   - Backend: Only GET and CREATE exist
   - Frontend expects: `PUT /api/staff/{id}`, `DELETE /api/staff/{id}`
   - **Action**: Implement UPDATE and DELETE endpoints

2. **File Upload** ❌
   - Backend: No file upload endpoints
   - Frontend expects: `POST /api/upload/image`, `POST /api/upload/video`
   - **Action**: Implement file upload endpoints

### ⚠️ **NEEDS ENHANCEMENT**

1. **Validation Rules** - Need to match frontend requirements exactly
2. **Delete Business Logic** - Need order/appointment checks
3. **Response Formats** - DELETE should return 204, error format needs details array
4. **Featured Field** - Need to add to course/consultation creation

---

## 🎯 **IMPLEMENTATION PRIORITY**

### Priority 1: Path Alignment (Quick Fix)
- Add `/create` route aliases
- Fix path structures to match frontend

### Priority 2: Missing Features
- Staff UPDATE/DELETE
- File Upload

### Priority 3: Enhancements
- Enhanced validation
- Business logic checks
- Response format improvements

---

## 📝 **DETAILED FINDINGS**

### Services - Actually Complete! ✅
I found that Services CRUD is **already implemented**:
- ✅ `POST /api/services` (just needs `/create` alias)
- ✅ `PUT /api/services/{serviceId}` (matches!)
- ✅ `DELETE /api/services/{serviceId}` (matches!)

### Staff - Partially Complete
- ✅ `GET /api/staff` (exists)
- ✅ `GET /api/staff/by/{id}` (exists, but path is `/by/{id}`)
- ✅ `POST /api/staff/create` (exists)
- ❌ `PUT /api/staff/{id}` (MISSING)
- ❌ `DELETE /api/staff/{id}` (MISSING)

### Courses/Consultations - Path Mismatch
The functionality exists but paths don't match frontend expectations. We can either:
1. Add route aliases (recommended - less breaking)
2. Restructure routes to match exactly

---

## 💡 **RECOMMENDED APPROACH**

1. **Add route aliases** for `/create` endpoints (non-breaking)
2. **Implement missing Staff endpoints**
3. **Implement File Upload**
4. **Enhance validation and business logic**
5. **Update response formats**

Would you like me to proceed with implementing these fixes?

