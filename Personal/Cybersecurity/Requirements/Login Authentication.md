# Login Authentication Security

## Overview
Security requirements and best practices for login authentication systems.

## Common Authentication Methods

### Single Factor
- Password only
- Biometric only
- Token only

### Multi-Factor (MFA)
- Password + SMS code
- Password + Email code
- Password + Authenticator app
- Password + Hardware token

## Common Vulnerabilities

### Brute Force
- No rate limiting
- Weak account lockout
- Predictable usernames

### Credential Stuffing
- Reused passwords
- Database leaks
- No breach detection

### Session Management
- Predictable session IDs
- Long session timeout
- No session invalidation

## Best Practices

### Password Policy
- Minimum 12 characters
- Mixed case, numbers, symbols
- No common passwords
- No password reuse

### Rate Limiting
```php
// Lock after 5 failed attempts
if ($failed_attempts >= 5) {
    lock_account($user_id);
}
```

### Secure Session
```php
// Regenerate session ID on login
session_regenerate_id(true);

// Set secure cookie
session_set_cookie_params([
    'lifetime' => 0,
    'secure' => true,
    'httponly' => true,
    'samesite' => 'Strict'
]);
```

## Authentication Flows

### Login Process
1. User submits credentials
2. Verify against database
3. Check for account lockout
4. Check for suspicious activity
5. Create session
6. Redirect to dashboard

### Password Reset
1. User requests reset
2. Generate reset token
3. Send email/SMS
4. User clicks link
5. Verify token
6. Allow password change

## Security Headers
```php
header('X-Frame-Options: DENY');
header('X-Content-Type-Options: nosniff');
header('X-XSS-Protection: 1; mode=block');
header('Strict-Transport-Security: max-age=31536000');
```

## Tags
 #security
