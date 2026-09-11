# Dirsearch Part 2 - Advanced Usage

## Overview
Advanced techniques and configurations for Dirsearch.

## Proxy Configuration

### Use Proxy
```bash
python3 dirsearch.py -u http://target.com --proxy http://127.0.0.1:8080
```

### Multiple Proxies
```bash
python3 dirsearch.py -u http://target.com --proxy-list proxies.txt
```

## Authentication

### Basic Auth
```bash
python3 dirsearch.py -u http://target.com --auth-type=basic --auth="user:password"
```

### Bearer Token
```bash
python3 dirsearch.py -u http://target.com -H "Authorization: Bearer token"
```

### Cookie Auth
```bash
python3 dirsearch.py -u http://target.com -H "Cookie: session=xxx"
```

## Advanced Scanning

### Scan with Headers
```bash
python3 dirsearch.py -u http://target.com -H "X-Forwarded-Host: evil.com"
```

### Delay Between Requests
```bash
python3 dirsearch.py -u http://target.com -d 1
```

### Random User Agents
```bash
python3 dirsearch.py -u http://target.com -random-agents
```

## Response Analysis

### Filter by Status Code
```bash
# Show only found
-f

# Exclude status codes
-x 404,500,502

# Include specific codes
-i 200,301,302
```

### Filter by Size
```bash
# Exclude by size
--exclude-size=0,1234

# Include by size
--include-size=1000-5000
```

## Wordlist Management

### Custom Wordlist
```bash
python3 dirsearch.py -u http://target.com -w /path/to/wordlist.txt
```

### Multiple Extensions
```bash
python3 dirsearch.py -u http://target.com -e php,php3,php4,php5,html,js
```

## Output Formats

### Save to File
```bash
# Text output
-o results.txt

# JSON output
-json-output=results.json
```

## Tags
 #pentesting #recon #web
