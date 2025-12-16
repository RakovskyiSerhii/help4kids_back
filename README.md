# Help4Kids API

A REST API built with [Dart Frog](https://dartfrog.vgv.dev/) for managing educational services, consultations, courses, articles, and user orders.

## Features

- **JWT Authentication**: Secure token-based authentication
- **Role-Based Access Control**: Admin, God, and Customer roles
- **MySQL Database**: Persistent data storage
- **RESTful API**: Standard HTTP methods and status codes
- **Input Validation**: Comprehensive validation for all endpoints
- **Error Handling**: Standardized error responses
- **Docker Support**: Containerized deployment

## Prerequisites

- Dart SDK (3.0 or higher)
- MySQL database
- Docker (optional, for containerized deployment)

## Environment Variables

Create a `.env` file or set the following environment variables:

```bash
# Database Configuration
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=help4kids_db

# JWT Configuration
JWT_SECRET=your_secret_key_here
JWT_ISSUER=help4kids.com
JWT_EXPIRATION_HOURS=24

# Server Configuration
PORT=8080
```

**Important**: The `JWT_SECRET` is required and must be set. It should be a strong, random string.

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd help4kids
```

2. Install dependencies:
```bash
dart pub get
```

3. Set up your database:
   - Create a MySQL database named `help4kids_db` (or your preferred name)
   - Run your database migrations/schema setup

4. Configure environment variables (see above)

## Running the Server

### Development Mode

```bash
dart run bin/server.dart
```

Or using Dart Frog CLI:

```bash
dart_frog dev
```

The server will start on `http://localhost:8080` (or the port specified in `PORT` environment variable).

### Production Mode

```bash
dart run bin/server.dart
```

## API Endpoints

### Authentication

- `POST /api/auth/register` - Register a new user
- `POST /api/auth/login` - Login and receive JWT token
- `GET /api/auth/me` - Get current user profile (requires authentication)
- `POST /api/auth/change-password` - Change password (requires authentication)
- `GET /api/auth/verify_email?token=<token>` - Verify email address
- `POST /api/auth/resend_email` - Resend verification email

### Services

- `GET /api/services` - List all services (public)
- `GET /api/services/{serviceId}` - Get service details (public)
- `POST /api/services` - Create service (admin/god only)
- `PUT /api/services/{serviceId}` - Update service (admin/god only)
- `DELETE /api/services/{serviceId}` - Delete service (admin/god only)

### Courses

- `GET /api/courses` - List all courses (public)
- `GET /api/courses/course/{courseId}` - Get course details (public)
- `GET /api/courses/me` - Get purchased courses (requires authentication)
- `POST /api/courses` - Create course (admin/god only)
- `PUT /api/courses/course/{courseId}` - Update course (admin/god only)
- `DELETE /api/courses/course/{courseId}` - Delete course (admin/god only)

### Consultations

- `GET /api/consultations` - List all consultations (public)
- `GET /api/consultations/consultation/{consultationId}` - Get consultation details (public)
- `GET /api/consultations/me` - Get purchased consultations (requires authentication)
- `POST /api/consultations` - Create consultation (admin/god only)
- `PUT /api/consultations/consultation/{consultationId}` - Update consultation (admin/god only)
- `DELETE /api/consultations/consultation/{consultationId}` - Delete consultation (admin/god only)

### Articles

- `GET /api/articles` - List all articles (public)
- `GET /api/articles/{articleId}` - Get article details (public)
- `POST /api/articles/{articleId}/save` - Save/bookmark article (requires authentication)
- `POST /api/articles` - Create article (admin/god only)
- `PUT /api/articles/{articleId}` - Update article (admin/god only)
- `DELETE /api/articles/{articleId}` - Delete article (admin/god only)

### Orders

- `GET /api/orders` - Get user's orders (requires authentication)
- `GET /api/orders/me` - Get user's orders (requires authentication)
- `GET /api/orders/order/{orderId}` - Get order details (requires authentication)
- `POST /api/orders` - Create order (requires authentication)
- `POST /api/orders/confirm-payment` - Confirm payment
- `POST /api/orders/payment-callback` - Payment callback handler

### Users

- `GET /api/users` - List all users (admin/god only)
- `GET /api/users/{userId}` - Get user details (admin/god only)
- `PUT /api/users/{userId}` - Update user (admin/god only)
- `DELETE /api/users/{userId}` - Delete user (admin/god only)

### Staff

- `GET /api/staff` - List all staff (public)
- `GET /api/staff/by/{id}` - Get staff details (public)
- `POST /api/staff/create` - Create staff member (admin/god only)

### General Info

- `GET /api/general_info` - Get general information (units, contacts, finance info, etc.)

### Landing

- `GET /api/landing` - Get featured content for landing page

## Authentication

Most endpoints require JWT authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your_jwt_token>
```

### Example Login Request

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

Response:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Example Authenticated Request

```bash
curl -X GET http://localhost:8080/api/auth/me \
  -H "Authorization: Bearer <your_jwt_token>"
```

## Error Responses

All errors follow a standardized format:

```json
{
  "error": "Error message",
  "code": "ERROR_CODE"
}
```

Common error codes:
- `VALIDATION_ERROR` - Input validation failed
- `NOT_FOUND` - Resource not found
- `UNAUTHORIZED` - Authentication required
- `FORBIDDEN` - Insufficient permissions
- `CONFLICT` - Resource conflict (e.g., duplicate email)
- `BAD_REQUEST` - Invalid request
- `INTERNAL_ERROR` - Server error

## Running with Docker

1. Build the Docker image:
```bash
docker build -t help4kids-api .
```

2. Run the container:
```bash
docker run -it -p 8080:8080 \
  -e DB_HOST=host.docker.internal \
  -e DB_USER=root \
  -e DB_PASSWORD=your_password \
  -e DB_NAME=help4kids_db \
  -e JWT_SECRET=your_secret_key \
  help4kids-api
```

## Testing

Run tests with:
```bash
dart test
```

## Project Structure

```
help4kids/
├── lib/
│   ├── config/          # Configuration (AppConfig)
│   ├── constants/        # Constants (roles, service types, etc.)
│   ├── data/             # Database connection
│   ├── middleware/       # Authentication middleware
│   ├── models/           # Data models
│   ├── services/         # Business logic
│   └── utils/            # Utilities (errors, validation, helpers)
├── routes/
│   └── api/              # API route handlers
├── test/                 # Tests
└── bin/
    └── server.dart       # Server entry point
```

## Security Features

- ✅ SQL Injection Prevention: All queries use parameterized statements
- ✅ JWT Authentication: Secure token-based authentication
- ✅ Password Hashing: BCrypt password hashing
- ✅ Input Validation: Comprehensive validation on all inputs
- ✅ Role-Based Access Control: Admin, God, and Customer roles
- ✅ Environment Variables: Sensitive data stored in environment variables
- ✅ Error Handling: No sensitive information leaked in errors

## License

[Your License Here]

## Contributing

[Contributing Guidelines Here]
