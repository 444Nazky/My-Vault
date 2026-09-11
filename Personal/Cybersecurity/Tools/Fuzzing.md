# Fuzzing

## Overview
Web application fuzzing techniques and tools for finding vulnerabilities.

## FFUF

### Basic Usage
```bash
# Fuzz directories
ffuf -w wordlist.txt -u http://target.com/FUZZ

# Virtual host discovery
ffuf -w wordlist.txt -u http://target.com -H "Host: FUZZ.target.com"

# Parameter fuzzing
ffuf -w wordlist.txt -u http://target.com/page?id=FUZZ
```

### Advanced Options
```bash
# Extensions
ffuf -w wordlist.txt -u http://target.com/FUZZ.php

# Match responses
ffuf -w wordlist.txt -u http://target.com/FUZZ -mc 200,204,301,302,307,401

# Filter by size
ffuf -w wordlist.txt -u http://target.com/FUZZ -fs 1234

# Threading
ffuf -w wordlist.txt -u http://target.com/FUZZ -t 50

# Save results
ffuf -w wordlist.txt -u http://target.com/FUZZ -o results.json -format json
```

## wfuzz

### Basic Usage
```bash
# Directory fuzzing
wfuzz -c -z file,wordlist.txt --hc 404 http://target.com/FUZZ

# Parameter fuzzing
wfuzz -c -z file,params.txt --hc 404 http://target.com/page.php?param=FUZZ
```

### Advanced
```bash
# POST fuzzing
wfuzz -c -z file,users.txt -d "username=FUZZ&password=test" http://target.com/login

# Headers
wfuzz -c -z file,wordlist.txt -H "X-Forwarded-Host: FUZZ.target.com" http://target.com/
```

## Gobuster

### Directory Mode
```bash
gobuster dir -u http://target.com -w /usr/share/wordlists/dirb/common.txt

# With extensions
gobuster dir -u http://target.com -w wordlist.txt -x php,html,js

# Threads
gobuster dir -u http://target.com -w wordlist.txt -t 50
```

### DNS Mode
```bash
gobuster dns -d target.com -w /usr/share/wordlists/subdomains.txt
```

### Virtual Host
```bash
gobuster vhost -u http://target.com -w subdomains.txt
```

## SQLMap Fuzzing

### Basic Fuzzing
```bash
sqlmap -u "http://target.com/page.php?id=1" --fingerprint

# Test all parameters
sqlmap -u "http://target.com/page.php" --data="param1=a&param2=b"
```

## Fuzzing Wordlists

### Web Directories
```
/usr/share/wordlists/dirb/common.txt
/usr/share/wordlists/dirbuster/
/usr/share/seclists/Discovery/Web-Content/
```

### Parameters
```
/usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt
```

## Tips

### Performance
- Use wordlists appropriate for target
- Adjust threading based on server
- Use proxy to throttle if needed

### Coverage
- Test multiple extensions
- Try case variations
- Include backup files

## Tags
 #pentesting #web
