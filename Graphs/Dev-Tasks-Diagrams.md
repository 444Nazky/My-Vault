# Dev Tasks Diagrams

**Part of:** [[00-Graph-Index]]

## Laravel CRUD MVC

```mermaid
flowchart LR
    R["routes"] --> C["controller"]
    C --> M["model"]
    M --> DB[("database")]
    C --> V["views"]
    VAL["validation"] --> C
    REL["relations"] --> M
```

Views render from controller data and link back to routes.

## E-Commerce PBO Error Map

```mermaid
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
```

## Nazkypedia UI Sessions

```mermaid
gantt
    dateFormat  YYYY-MM-DD
    title Nazkypedia UI Improvements
    section Session 1
    Global CSS Nav Components :done, 2026-08-01, 3d
    section Session 2
    Navbar Hero Responsive    :done, 2026-08-05, 3d
    section Session 3
    Cart Hamburger Mobile     :done, 2026-08-10, 3d
```

```mermaid
graph TD
    S1["Session one"] --> NAV["Navbar"]
    S1 --> HERO["Hero"]
    S1 --> FOOT["Footer"]
```

```mermaid
graph TD
    S2["Session two"] --> NAV2["Navbar polish"]
    S2 --> HERO2["Hero polish"]
```

```mermaid
graph TD
    S3["Session three"] --> CART["Cart"]
    S3 --> MOB["Mobile menu"]
    CART --> TEST["Testing"]
    MOB --> TEST
    TEST --> FUT["Future work"]
```

Each session restyles the shared Navbar and Hero components. Colors are Blue Teal Orange plus dark mode.

## React Native Taskmanager

```mermaid
flowchart TD
    A["create expo app"] --> B["start dev server"]
    B --> C["add navigation"]
    C --> D["task CRUD"]
    D --> E["persist storage"]
    E --> F["categories plus priority"]
    F --> G["animations"]
    G --> H["done"]
```

## VSCode Theme Bug Chain

```mermaid
flowchart TD
    A["bad theme plugin"] --> B["settings broken"]
    B --> C["theme renders wrong"]
    C --> D["snapshot extensions"]
    D --> E["manual fix"]
    E --> F["backup plan"]
    F --> G["prevention list"]
    G --> H["compat matrix"]
```

Cause was the APC Customize plugin writing bad alpha colors.

## Spreadsheets Auth Decision

```mermaid
flowchart TD
    A["need sheets API"] --> B{"server to server"}
    B -->|"yes"| C["service account"]
    B -->|"no"| D{"public read only"}
    D -->|"yes"| E["API key"]
    D -->|"no"| F["OAuth login"]
    F --> G["compare and throttle"]
```

## School P3 Build Order

```mermaid
flowchart LR
    A["spec"] --> B["database"]
    B --> C["auth"]
    C --> D["product CRUD"]
    D --> E["orders and API"]
    E --> F["frontend pages"]
    F --> G["docs"]
```

## Git Branch Flow

```mermaid
flowchart LR
    MAIN["main branch"] --> FEAT["feature branch"]
    FEAT --> COMMIT2["commit often"]
    COMMIT2 --> PUSH2["push and PR"]
    PUSH2 --> REVIEW["review"]
    REVIEW --> MERGE2["squash merge"]
```

## Eloquent Relation Map

```mermaid
graph TD
    USER2["users table"] --> POSTS2["has many posts"]
    POSTS2 --> BELONG2["belongs to user"]
    POSTS2 --> TAGREL["many to many tags"]
```

## Sheets OAuth Flow

```mermaid
flowchart LR
    APP3["Laravel app"] --> REDIR["redirect Google"]
    REDIR --> CONSENT["user consent"]
    CONSENT --> TOKEN["access token"]
    TOKEN --> SHEETS2["read sheets"]
```

Tags: #graph #development
