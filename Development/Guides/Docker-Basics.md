# Docker Basics Notes

Standalone note. No links in or out.

## Core Commands

```bash
docker ps -a
docker images
docker pull nginx:alpine
docker run -d -p 8080:80 --name web nginx:alpine
docker exec -it web sh
docker logs -f web
docker stop web && docker rm web
```

## Volumes and Networks

```bash
docker volume create data
docker run -v data:/data -v $(pwd):/app --network mynet img
docker network create mynet
```

- Named volumes survive container death, bind mounts mirror your code live.
- Containers on one user network reach each other by name.

## Compose File

```yaml
services:
  web:
    image: nginx:alpine
    ports: ["8080:80"]
    volumes: ["./html:/usr/share/nginx/html:ro"]
    restart: unless-stopped
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: secret
    volumes: ["pgdata:/var/lib/postgresql/data"]
volumes:
  pgdata:
```

```bash
docker compose up -d
docker compose logs -f
docker compose down
```

## Dockerfile Habits

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
USER node
CMD ["node", "server.js"]
```

- Pin versions, copy manifests first for layer cache, run as non-root.

## Cleanup

```bash
docker system df
docker system prune -f
docker volume prune -f
```

## Gotchas

- `latest` tag moves under you, pin digests in production.
- localhost inside a container is the container, use host.docker.internal for the host.
- Secrets via env files with tight perms, never baked into images.

## Tags
#note-docker-basics
