# Web Enumeration Checklist

Standalone note. No links in or out. Authorized testing only.

## Map First

```bash
whatweb https://target
curl -sI https://target
dig +short target
```

- Record tech stack, headers, DNS, and certs before brute forcing anything.

## Directory Brute Force

```bash
ffuf -u https://target/FUZZ -w wordlist.txt -mc 200,301,302,401,403 -o out.json
gobuster dir -u https://target -w wordlist.txt -x php,txt,bak -o out.txt
```

- One fast pass with medium list, then targeted lists per tech found.
- Recurse into interesting dirs, not everything.

## Virtual Hosts and Params

```bash
ffuf -u http://target -H "Host: FUZZ.target" -w vhosts.txt -mc 200
ffuf -u "https://target/page?FUZZ=x" -w params.txt -mc 200 -fs 1234
```

- Filter by size on dynamic pages or every line matches.
- Check robots.txt, sitemap.xml, .well-known, and JS bundles for endpoints.

## API Surfaces

- Swagger at /swagger, /openapi.json, /api-docs.
- GraphQL at /graphql, introspect when enabled.
- Versioned paths: /v1, /v2, /api, /internal, /admin.

## Gotchas

- 403 is a finding, probe method override and path tricks within scope.
- Rate limit yourself on production, watch for WAF blocks.
- Save raw outputs, screenshots only summarize.


