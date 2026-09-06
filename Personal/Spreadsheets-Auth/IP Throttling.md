# IP Throttling - Google Sheets API

Documentation for handling IP throttling when using Google Sheets API.

## Understanding Rate Limits

Google Sheets API has per-user and per-project limits:

| Limit Type | Default | Notes |
|------------|---------|-------|
| Read requests | 100/second | Per user |
| Write requests | 100/second | Per user |
| Concurrent requests | 30 | Per user |
| Project quota | Varies | Based on tier |

## IP-Based Throttling

Google tracks requests by IP address. If too many requests come from one IP, you may hit throttling errors.

## Error Codes

### 429 Too Many Requests

```json
{
  "error": {
    "code": 429,
    "message": "Quota exceeded for quota metric 'Read requests'",
    "status": "RESOURCE_EXHAUSTED"
  }
}
```

### 403 Forbidden (IP whitelist issues)

```json
{
  "error": {
    "code": 403,
    "message": "The request is missing a valid API key",
    "status": "PERMISSION_DENIED"
  }
}
```

## Mitigation Strategies

### 1. Exponential Backoff

Implement retry logic with exponential backoff:

```php
function retryWithBackoff($callback, $maxRetries = 3) {
    $retries = 0;
    while ($retries < $maxRetries) {
        try {
            return $callback();
        } catch (Google\Service\Exception $e) {
            if ($e->getCode() === 429 && $retries < $maxRetries) {
                $wait = pow(2, $retries) * 1000000; // 1s, 2s, 4s
                usleep($wait);
                $retries++;
            } else {
                throw $e;
            }
        }
    }
}
```

### 2. Request Batching

Batch multiple operations into single requests:

```php
$batch = $service->createBatch();
foreach ($cells as $cell) {
    $request = new Google\Service\Sheets\Request([
        'updateCells' => [
            'rows' => [$cell['data']],
            'fields' => 'userEnteredValue',
            'range' => $cell['range']
        ]
    ]);
    $batch->add($request, $cell['id']);
}
$batch->execute();
```

### 3. Request Delay

Add delays between requests:

```php
// Rate limit: 100 requests/second
$delayMs = 11; // Slightly over to be safe

foreach ($requests as $request) {
    executeRequest($request);
    usleep($delayMs * 1000);
}
```

### 4. Use Caching

Cache read results to reduce API calls:

```php
$cache = new Cache\FileCache('/tmp/sheets_cache');
$cacheKey = "sheet_{$spreadsheetId}_{$range}";

if ($cache->has($cacheKey)) {
    return $cache->get($cacheKey);
}

$data = $service->spreadsheets_values->get($spreadsheetId, $range);
$cache->set($cacheKey, $data, 300); // Cache 5 minutes
```

## Best Practices

1. **Batch operations** - Combine multiple updates into single requests
2. **Use exponential backoff** - Never retry immediately
3. **Cache reads** - Avoid re-fetching unchanged data
4. **Distribute load** - Avoid spike traffic
5. **Monitor quotas** - Track usage in Google Cloud Console

## Google Cloud Console

Check quota usage at:
https://console.cloud.google.com/apis/dashboard

## Related

- [[Google Sheets Login API Setup]]
- [[Laravel Eloquent Comparison]]

---

Tags: #google-sheets #api #throttling #rate-limit
