# Nuclei

## Overview
Nuclei is a fast, customizable vulnerability scanner based on templates.

## Installation
```bash
# Install nuclei
go install github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest

# Update templates
nuclei -update-templates
```

## Basic Usage

### Scan Single Target
```bash
nuclei -u http://target.com
```

### Scan Multiple Targets
```bash
nuclei -l targets.txt
```

### Save Results
```bash
nuclei -u http://target.com -o results.txt
```

## Templates

### Template Locations
```
~/.nuclei-templates/
/usr/share/nuclei/
```

### Update Templates
```bash
nuclei -update-templates
```

### List Templates
```bash
nuclei -tl
```

## Template Selection

### By Category
```bash
# CVE templates
nuclei -u http://target.com -t cves/

# Vulnerability templates
nuclei -u http://target.com -t vulnerabilities/

# Technology specific
nuclei -u http://target.com -t technologies/
```

### By Severity
```bash
# Critical only
nuclei -u http://target.com -severity critical

# Medium and above
nuclei -u http://target.com -severity medium,high,critical
```

## Advanced Options

### Rate Limiting
```bash
# Threads
nuclei -u http://target.com -t 10

# Requests per second
nuclei -u http://target.com -r 100
```

### Custom Templates
```bash
nuclei -u http://target.com -t custom-templates/
```

### Tags
```bash
nuclei -u http://target.com -tags cve,sql-injection
```

## Common Commands

### Full Scan
```bash
nuclei -u http://target.com -t all -o results.txt
```

### Fast Scan
```bash
nuclei -u http://target.com -t cves,technologies
```

### Custom Wordlist
```bash
nuclei -u http://target.com -no-strict-schema
```

## Tags
#nuclei #vulnerabilities #scanner #pentesting #security
