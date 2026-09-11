# Security IR Diagrams

**Part of:** [[00-Graph-Index]]

## SEO Poisoning Kill Chain

```mermaid
flowchart TD
    A["initial access"] --> B["persistence"]
    B --> C["cloaking"]
    C --> D["rewrite rules found"]
    D --> E["spam sitemap found"]
    E --> F["search index poisoned"]
```

Vectors: vulnerable plugin, brute force, malicious upload. Persistence via htaccess, PHP backdoor, cron job, DB hook. Cloaking shows gambling content to Googlebot only.

## IR Remediation Pipeline

```mermaid
flowchart LR
    A["snapshot"] --> B["integrity check"]
    B --> C["isolate site"]
    C --> D["clean core"]
    D --> E["harden"]
    E --> F["reindex"]
    F --> G["checklist done"]
```

## kurmamedia Case Verdict

```mermaid
graph TD
    T["kurmamedia site"] --> DNS["DNS active"]
    T --> HTTP["HTTP timeout"]
    T --> MAP["no sitemap"]
    DNS --> V["verdict suspended"]
    HTTP --> V
    MAP --> V
    V --> N["monitor site"]
```

Hosted on Hostinger Jakarta, DNS resolves but the server serves nothing. Likely suspended or taken down.

## Cybersecurity Toolkit Pipeline

```mermaid
flowchart LR
    A["recon"] --> B["scan"]
    B --> C["enum"]
    C --> D["vuln check"]
    D --> E["exploit"]
    E --> F["crack"]
```

Tools per stage: nmap and amass, masscan, dirsearch and ffuf, nikto and nuclei, metasploit and burpsuite, hashcat and john and sqlmap.

## Web Vuln Tool Web

```mermaid
graph TD
    BURP["Burp proxy"] --> FUZZ["Fuzz payloads"]
    DIR["Dirsearch enum"] --> FUZZ
    FUZZ --> VULN["vuln confirmed"]
    NUC["Nuclei templates"] --> VULN
    SQLI["manual SQLi"] --> SQLMAP["Sqlmap dump"]
    SQLMAP --> VULN
    VULN --> OWASP["Owasp report"]
```

Tags: #graph #security
