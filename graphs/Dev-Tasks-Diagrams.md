# Dev Tasks Diagrams


## Laravel CRUD MVC

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#56CCF2', 'lineColor': '#56CCF2'}}}%%
flowchart LR
 R["routes"] --> C["controller"]
 C --> M["model"]
 M --> DB[("database")]
 C --> V["views"]
 VAL["validation"] --> C
 REL["relations"] --> M
 style R fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style C fill:#56CCF2,stroke:#56CCF2,color:#fff
 style M fill:#9B51E0,stroke:#9B51E0,color:#fff
 style DB fill:#F2994A,stroke:#F2994A,color:#fff
 style V fill:#BB6BD9,stroke:#BB6BD9,color:#fff
```

## E-Commerce PBO Error Map

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#EB5757', 'lineColor': '#EB5757'}}}%%
flowchart TD
 A["fresh clone"] --> B{"autoload works"}
 B -->|"no"| E02["fix autoload"]
 B -->|"yes"| C{"app key set"}
 C -->|"no"| E03["generate app key"]
 C -->|"yes"| D{"mysqli present"}
 D -->|"no"| E04["install mysqli"]
 D -->|"yes"| E{"driver correct"}
 E -->|"no"| E05["fix driver"]
 E -->|"yes"| F{"db connects"}
 F -->|"no"| E06["fix env"]
 F -->|"yes"| G["migrate and seed"]
 G --> H["verify app"]
 style A fill:#F2C94C,stroke:#F2C94C,color:#000
 style B fill:#F2C94C,stroke:#F2C94C,color:#000
 style C fill:#F2C94C,stroke:#F2C94C,color:#000
 style D fill:#F2C94C,stroke:#F2C94C,color:#000
 style E fill:#F2C94C,stroke:#F2C94C,color:#000
 style F fill:#F2C94C,stroke:#F2C94C,color:#000
 style E02 fill:#EB5757,stroke:#EB5757,color:#fff
 style E03 fill:#EB5757,stroke:#EB5757,color:#fff
 style E04 fill:#EB5757,stroke:#EB5757,color:#fff
 style E05 fill:#EB5757,stroke:#EB5757,color:#fff
 style E06 fill:#EB5757,stroke:#EB5757,color:#fff
 style G fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style H fill:#27AE60,stroke:#27AE60,color:#fff
```

## Nazkypedia UI Sessions

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'secondaryColor': '#27AE60', 'tertiaryColor': '#F2C94C', 'lineColor': '#2D9CDB'}}}%%
gantt
 dateFormat YYYY-MM-DD
 title Nazkypedia UI Improvements
 section Session 1
 Global CSS Nav Components :done, 2026-08-01, 3d
 section Session 2
 Navbar Hero Responsive :done, 2026-08-05, 3d
 section Session 3
 Cart Hamburger Mobile :done, 2026-08-10, 3d
```

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#BB6BD9', 'lineColor': '#BB6BD9'}}}%%
graph TD
 S1["Session one"] -->|blue| NAV["Navbar"]
 S1 -->|blue| HERO["Hero"]
 S1 -->|blue| FOOT["Footer"]
 style S1 fill:#9B51E0,stroke:#9B51E0,color:#fff
 style NAV fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style HERO fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style FOOT fill:#2D9CDB,stroke:#2D9CDB,color:#fff
```

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
graph TD
 S2["Session two"] --> NAV2["Navbar polish"]
 S2 --> HERO2["Hero polish"]
 style S2 fill:#9B51E0,stroke:#9B51E0,color:#fff
 style NAV2 fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style HERO2 fill:#2D9CDB,stroke:#2D9CDB,color:#fff
```

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#F2994A', 'lineColor': '#F2994A'}}}%%
graph TD
 S3["Session three"] --> CART["Cart"]
 S3 --> MOB["Mobile menu"]
 CART --> TEST["Testing"]
 MOB --> TEST
 TEST --> FUT["Future work"]
 style S3 fill:#9B51E0,stroke:#9B51E0,color:#fff
 style CART fill:#F2994A,stroke:#F2994A,color:#fff
 style MOB fill:#F2994A,stroke:#F2994A,color:#fff
 style TEST fill:#F2C94C,stroke:#F2C94C,color:#000
 style FUT fill:#EB5757,stroke:#EB5757,color:#fff
```

## React Native Taskmanager

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#56CCF2', 'lineColor': '#56CCF2'}}}%%
flowchart TD
 A["create expo app"] --> B["start dev server"]
 B --> C["add navigation"]
 C --> D["task CRUD"]
 D --> E["persist storage"]
 E --> F["categories plus priority"]
 F --> G["animations"]
 G --> H["done"]
 style A fill:#F2C94C,stroke:#F2C94C,color:#000
 style D fill:#9B51E0,stroke:#9B51E0,color:#fff
 style G fill:#BB6BD9,stroke:#BB6BD9,color:#fff
 style H fill:#27AE60,stroke:#27AE60,color:#fff
```

## VSCode Theme Bug Chain

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#EB5757', 'lineColor': '#EB5757'}}}%%
flowchart TD
 A["bad theme plugin"] --> B["settings broken"]
 B --> C["theme renders wrong"]
 C --> D["snapshot extensions"]
 D --> E["manual fix"]
 E --> F["backup plan"]
 F --> G["prevention list"]
 G --> H["compat matrix"]
 style A fill:#EB5757,stroke:#EB5757,color:#fff
 style B fill:#EB5757,stroke:#EB5757,color:#fff
 style C fill:#F2994A,stroke:#F2994A,color:#fff
 style D fill:#F2994A,stroke:#F2994A,color:#fff
 style E fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style F fill:#56CCF2,stroke:#56CCF2,color:#fff
 style G fill:#27AE60,stroke:#27AE60,color:#fff
 style H fill:#27AE60,stroke:#27AE60,color:#fff
```

## Spreadsheets Auth Decision

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#56CCF2', 'lineColor': '#56CCF2'}}}%%
flowchart TD
 A["need sheets API"] --> B{"server to server"}
 B -->|"yes"| C["service account"]
 B -->|"no"| D{"public read only"}
 D -->|"yes"| E["API key"]
 D -->|"no"| F["OAuth login"]
 F --> G["compare and throttle"]
 style A fill:#F2C94C,stroke:#F2C94C,color:#000
 style B fill:#F2C94C,stroke:#F2C94C,color:#000
 style D fill:#F2C94C,stroke:#F2C94C,color:#000
 style C fill:#27AE60,stroke:#27AE60,color:#fff
 style E fill:#27AE60,stroke:#27AE60,color:#fff
 style F fill:#BB6BD9,stroke:#BB6BD9,color:#fff
 style G fill:#56CCF2,stroke:#56CCF2,color:#fff
```

## School P3 Build Order

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#56CCF2', 'lineColor': '#56CCF2'}}}%%
flowchart LR
 A["spec"] --> B["database"]
 B --> C["auth"]
 C --> D["product CRUD"]
 D --> E["orders and API"]
 E --> F["frontend pages"]
 F --> G["docs"]
 style A fill:#F2C94C,stroke:#F2C94C,color:#000
 style B fill:#9B51E0,stroke:#9B51E0,color:#fff
 style C fill:#9B51E0,stroke:#9B51E0,color:#fff
 style D fill:#56CCF2,stroke:#56CCF2,color:#fff
 style E fill:#56CCF2,stroke:#56CCF2,color:#fff
 style F fill:#BB6BD9,stroke:#BB6BD9,color:#fff
 style G fill:#2D9CDB,stroke:#2D9CDB,color:#fff
```

## Git Branch Flow

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
flowchart LR
 MAIN["main branch"] --> FEAT["feature branch"]
 FEAT --> COMMIT2["commit often"]
 COMMIT2 --> PUSH2["push and PR"]
 PUSH2 --> REVIEW["review"]
 REVIEW --> MERGE2["squash merge"]
 style MAIN fill:#27AE60,stroke:#27AE60,color:#fff
 style FEAT fill:#56CCF2,stroke:#56CCF2,color:#fff
 style COMMIT2 fill:#56CCF2,stroke:#56CCF2,color:#fff
 style PUSH2 fill:#56CCF2,stroke:#56CCF2,color:#fff
 style REVIEW fill:#F2C94C,stroke:#F2C94C,color:#000
 style MERGE2 fill:#2D9CDB,stroke:#2D9CDB,color:#fff
```

## Eloquent Relation Map

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#9B51E0', 'lineColor': '#9B51E0'}}}%%
graph TD
 USER2["users table"] --> POSTS2["has many posts"]
 POSTS2 --> BELONG2["belongs to user"]
 POSTS2 --> TAGREL["many to many tags"]
 style USER2 fill:#2D9CDB,stroke:#2D9CDB,color:#fff
 style POSTS2 fill:#9B51E0,stroke:#9B51E0,color:#fff
 style BELONG2 fill:#56CCF2,stroke:#56CCF2,color:#fff
 style TAGREL fill:#BB6BD9,stroke:#BB6BD9,color:#fff
```

## Sheets OAuth Flow

```mermaid
%%{init: {'theme': 'default', 'themeVariables': { 'primaryColor': '#2D9CDB', 'lineColor': '#2D9CDB'}}}%%
flowchart LR
 APP3["Laravel app"] --> REDIR["redirect Google"]
 REDIR --> CONSENT["user consent"]
 CONSENT --> TOKEN["access token"]
 TOKEN --> SHEETS2["read sheets"]
 style APP3 fill:#56CCF2,stroke:#56CCF2,color:#fff
 style REDIR fill:#F2994A,stroke:#F2994A,color:#fff
 style CONSENT fill:#BB6BD9,stroke:#BB6BD9,color:#fff
 style TOKEN fill:#27AE60,stroke:#27AE60,color:#fff
 style SHEETS2 fill:#2D9CDB,stroke:#2D9CDB,color:#fff
```

## Tags
#note-dev-tasks-diagrams
