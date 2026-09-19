# Security IR Diagrams


## SEO Poisoning Kill Chain

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#EB5757', 'lineColor': '#EB5757'}}}%%
flowchart TD
 A["initial access"] --> B["persistence"]
 B --> C["cloaking"]
 C --> D["rewrite rules found"]
 D --> E["spam sitemap found"]
 E --> F["search index poisoned"]
 style A fill:#EB5757,stroke:#EB5757,color:#fff
 style B fill:#EB5757,stroke:#EB5757,color:#fff
 style C fill:#F2994A,stroke:#F2994A,color:#fff
 style D fill:#F2994A,stroke:#F2994A,color:#fff
 style E fill:#F2994A,stroke:#F2994A,color:#fff
 style F fill:#EB5757,stroke:#EB5757,color:#fff
```

## IR Remediation Pipeline

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#27AE60', 'lineColor': '#27AE60'}}}%%
flowchart LR
 A["snapshot"] --> B["integrity check"]
 B --> C["isolate site"]
 C --> D["clean core"]
 D --> E["harden"]
 E --> F["reindex"]
 F --> G["checklist done"]
 style A fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style G fill:#27AE60,stroke:#27AE60,color:#fff
 style D fill:#56CCF2,stroke:#56CCF2,color:#fff
 style E fill:#56CCF2,stroke:#56CCF2,color:#fff
```

## kurmamedia Case Verdict

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#EB5757', 'lineColor': '#EB5757'}}}%%
graph TD
 T["kurmamedia site"] --> DNS["DNS active"]
 T --> HTTP["HTTP timeout"]
 T --> MAP["no sitemap"]
 DNS --> V["verdict suspended"]
 HTTP --> V
 MAP --> V
 V --> N["monitor site"]
 style T fill:#F2C94C,stroke:#F2C94C,color:#000
 style V fill:#EB5757,stroke:#EB5757,color:#fff
 style N fill:#2D9CDB,stroke:#2D9CDB,color:#fff
```

## Cybersecurity Toolkit Pipeline

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#9B51E0', 'lineColor': '#9B51E0'}}}%%
flowchart LR
 A["recon"] --> B["scan"]
 B --> C["enum"]
 C --> D["vuln check"]
 D --> E["exploit"]
 E --> F["crack"]
 style A fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style B fill:#56CCF2,stroke:#56CCF2,color:#fff
 style C fill:#56CCF2,stroke:#56CCF2,color:#fff
 style D fill:#F2994A,stroke:#F2994A,color:#fff
 style E fill:#EB5757,stroke:#EB5757,color:#fff
 style F fill:#EB5757,stroke:#EB5757,color:#fff
```

## Web Vuln Tool Web

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#F2994A', 'lineColor': '#F2994A'}}}%%
graph TD
 BURP["Burp proxy"] --> FUZZ["Fuzz payloads"]
 DIR["Dirsearch enum"] --> FUZZ
 FUZZ --> VULN["vuln confirmed"]
 NUC["Nuclei templates"] --> VULN
 SQLI["manual SQLi"] --> SQLMAP["Sqlmap dump"]
 SQLMAP --> VULN
 VULN --> OWASP["Owasp report"]
 style BURP fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style FUZZ fill:#56CCF2,stroke:#56CCF2,color:#fff
 style VULN fill:#EB5757,stroke:#EB5757,color:#fff
 style NUC fill:#BB6BD9,stroke:#BB6BD9,color:#fff
 style SQLI fill:#F2C94C,stroke:#F2C94C,color:#000
 style SQLMAP fill:#56CCF2,stroke:#56CCF2,color:#fff
 style OWASP fill:#9B51E0,stroke:#9B51E0,color:#fff
```

## Nmap Scan Flow

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
flowchart TD
 TARGET["target picked"] --> DISC["host discovery"]
 DISC --> PORTS["port scan"]
 PORTS --> VER3["version detect"]
 VER3 --> VULN2["vuln scripts"]
 VULN2 --> REPORT["report"]
 style TARGET fill:#F2C94C,stroke:#F2C94C,color:#000
 style DISC fill:#56CCF2,stroke:#56CCF2,color:#fff
 style PORTS fill:#56CCF2,stroke:#56CCF2,color:#fff
 style VER3 fill:#56CCF2,stroke:#56CCF2,color:#fff
 style VULN2 fill:#EB5757,stroke:#EB5757,color:#fff
 style REPORT fill:#27AE60,stroke:#27AE60,color:#fff
```

## Password Attack Choice

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#F2C94C', 'lineColor': '#F2C94C'}}}%%
flowchart TD
 HASH["hash captured"] --> TYPEQ{"hash type"}
 TYPEQ -->|"fast"| HASHCAT["hashcat GPU"]
 TYPEQ -->|"slow"| JOHN["john CPU"]
 TYPEQ -->|"login"| HYDRA["hydra online"]
 style HASH fill:#EB5757,stroke:#EB5757,color:#fff
 style TYPEQ fill:#F2C94C,stroke:#F2C94C,color:#000
 style HASHCAT fill:#F2994A,stroke:#F2994A,color:#fff
 style JOHN fill:#56CCF2,stroke:#56CCF2,color:#fff
 style HYDRA fill:#56CCF2,stroke:#56CCF2,color:#fff
```

## Burp Intercept Flow

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
flowchart LR
 BROWSER["browser"] --> PROXY["burp proxy"]
 PROXY --> REQ["inspect request"]
 REQ --> REPLAY["repeater"]
 REPLAY --> FIND["finding"]
 style BROWSER fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style PROXY fill:#56CCF2,stroke:#56CCF2,color:#fff
 style REQ fill:#56CCF2,stroke:#56CCF2,color:#fff
 style REPLAY fill:#BB6BD9,stroke:#BB6BD9,color:#fff
 style FIND fill:#27AE60,stroke:#27AE60,color:#fff
```

## Tags
#note-security-ir-diagrams
