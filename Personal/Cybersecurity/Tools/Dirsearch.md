# Dirsearch

## Overview
Dirsearch is a web path scanner for discovering directories and files on web servers.

## Installation
```bash
git clone https://github.com/maurosoria/dirsearch.git
cd dirsearch
pip install -r requirements.txt
```

## Basic Usage

### Simple Scan
```bash
python3 dirsearch.py -u http://target.com
```

### With Extensions
```bash
python3 dirsearch.py -u http://target.com -e php,html,js,asp,aspx
```

### With Wordlist
```bash
python3 dirsearch.py -u http://target.com -w /usr/share/wordlists/dirb/common.txt
```

## Common Options

### Recursion
```bash
# Enable recursion
python3 dirsearch.py -u http://target.com -r

# Set recursion depth
python3 dirsearch.py -u http://target.com -r -R 3
```

### Threads
```bash
# Increase threads
python3 dirsearch.py -u http://target.com -t 20
```

### Extensions
```bash
# Multiple extensions
-e php,html,js,asp,aspx,jsp

# All common extensions
-e php,php3,php4,php5,php7,phtml,html,htm,js,asp,aspx,jsp,cfm,cgi,pl,py
```

### Headers
```bash
# Custom header
python3 dirsearch.py -u http://target.com -H "Authorization: Bearer token"

# Multiple headers
-H "Cookie: session=xxx" -H "User-Agent: Custom"
```

### Output
```bash
# Save results
-o results.txt

# JSON output
-json-output=results.json
```

## Advanced Usage

### Filter Responses
```bash
# Filter by status code
-f # filter to show only found

# Exclude status codes
-x 404,500

# Only show 200 status
--exclude-status=404
```

### Authentication
```bash
# Basic auth
python3 dirsearch.py -u http://target.com --auth-type=basic --auth="user:pass"

# Bearer token
python3 dirsearch.py -u http://target.com -H "Authorization: Bearer token"
```

### Proxy
```bash
# Use proxy
python3 dirsearch.py -u http://target.com --proxy http://127.0.0.1:8080
```

## Wordlists

### Location
```
/usr/share/wordlists/
/usr/share/wordlists/dirb/
```

### Common Wordlists
- common.txt
- big.txt
- small.txt
- catala.txt
- spanish.txt

## Tags
#dirsearch #web #recon #scanner #pentesting
