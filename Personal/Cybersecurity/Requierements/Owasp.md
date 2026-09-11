# OWASP Top 10

## Overview
The Open Web Application Security Project (OWASP) Top 10 is a standard awareness document for developers about the most critical security risks to web applications.

## OWASP Top 10 (2021)

### A01: Broken Access Control
- Unauthorized access to other users' accounts
- Viewing sensitive files
- Modifying data
- Changing access rights

### A02: Cryptographic Failures
- Sensitive data exposure
- Weak cryptographic algorithms
- Missing encryption
- Improper key management

### A03: Injection
- SQL injection
- NoSQL injection
- OS command injection
- LDAP injection

### A04: Insecure Design
- Missing rate limiting
- Broken business logic
- Credential stuffing
- No protection against bots

### A05: Security Misconfiguration
- Unnecessary features enabled
- Default credentials
- Error handling reveals stack traces
- Outdated systems

### A06: Vulnerable Components
- Outdated software
- Unsupported dependencies
- Unpatched vulnerabilities
- Using components from untrusted sources

### A07: Authentication Failures
- Credential stuffing
- Weak password policies
- Session fixation
- Missing multi-factor authentication

### A08: Software and Data Integrity Failures
- Insecure deserialization
- Auto-update without verification
- CI/CD pipeline vulnerabilities
- Reliance on untrusted CDNs

### A09: Security Logging Failures
- Logs not monitoring
- Warnings and errors not logged
- Suspicious activity not flagged
- No alerting

### A10: Server-Side Request Forgery (SSRF)
- Fetching remote resources without validation
- Accessing internal services
- Port scanning internal network

## Prevention

### General
- Use parameterized queries
- Implement proper access controls
- Use secure session management
- Keep software updated

### Cryptographic Failures
- Use strong encryption (AES-256)
- Secure key management
- Don't roll your own crypto

### Injection
- Input validation
- Parameterized queries
- Stored procedures
- Context-aware escaping

## Tags
 #pentesting #security #web
