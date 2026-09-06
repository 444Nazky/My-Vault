# Burp Suite

## Overview
Burp Suite is a comprehensive web application security testing platform.

## Installation

### Community Edition
```bash
# Download from PortSwigger
# Or install from AUR
paru -S burpsuite
```

### Start Burp Suite
```bash
burpsuite
```

## Proxy Configuration

### Browser Setup
1. Go to browser proxy settings
2. Set HTTP Proxy: 127.0.0.1
3. Set Port: 8080

### Proxy Options
```bash
# Intercept on/off
# Forward/Drop requests
# Action menu options
```

## Key Features

### Proxy (Intercept)
- Intercept requests/responses
- Modify data on-the-fly
- Forward or drop requests

### Target
- Site map
- Scope definition
- Issue tracking

### Intruder
- Custom attack patterns
- Payload positions
- Attack types

### Repeater
- Manual request editing
- Response analysis
- Request comparison

### Decoder
- Encode/decode data
- Hash generation
- Format conversion

## Common Uses

### Testing SQL Injection
1. Intercept request
2. Modify parameter: id=1' OR '1'='1
3. Forward to server
4. Analyze response

### Testing XSS
1. Find input field
2. Inject: <script>alert('XSS')</script>
3. Check if reflected

### Session Testing
1. Capture authenticated request
2. Test with modified cookies
3. Check for proper validation

## Tips

### Useful Shortcuts
- Ctrl+R: Send to Repeater
- Ctrl+I: Send to Intruder
- Ctrl+U: URL encode
- Ctrl+Shift+U: URL decode

### Best Practices
- Always test on authorized targets
- Use scope to limit testing
- Save your work frequently
- Review HTTP history

## Tags
#burpsuite #web #pentesting #proxy #security
