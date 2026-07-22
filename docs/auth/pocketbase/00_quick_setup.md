Here's a clean, production-ready `docker-compose.pocketbase.yml` for your local playground setup:

```yaml
services:
  pocketbase:
    image: ghcr.io/muchobien/pocketbase:latest
    container_name: pocketbase
    restart: unless-stopped
    environment:
      PB_HOST: 0.0.0.0
      PB_PORT: 8090
      # Auto-create admin user on first start (change these!)
      PB_ADMIN_EMAIL: admin@local.dev
      PB_ADMIN_PASSWORD: changeme123
      # Optional: settings encryption key (32 chars recommended)
      # ENCRYPTION: your-32-char-encryption-key-here!!
    ports:
      - "8090:8090"
    volumes:
      - ./pb_data:/pb_data
      - ./pb_public:/pb_public
      - ./pb_hooks:/pb_hooks
      - ./pb_migrations:/pb_migrations
    healthcheck:
      test: [ "CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:8090/api/health" ]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 30s
```

## Quick Start

```bash
# Create the compose file and directories
mkdir -p ~/pocketbase-playground && cd ~/pocketbase-playground
# Save the docker-compose.pocketbase.yml above

# Create directories (PocketBase needs them to exist)
mkdir -p pb_data pb_public pb_hooks pb_migrations

# Spin it up
docker compose -f docker-compose.pocketbase.yml up -d

# Check logs
docker compose -f docker-compose.pocketbase.yml logs -f
```

## Access Points

| URL                                | What            |
|------------------------------------|-----------------|
| `http://localhost:8090/_/`         | Admin Dashboard |
| `http://localhost:8090/api/`       | REST API        |
| `http://localhost:8090/api/health` | Health check    |

## Key Details

- **Image**: `ghcr.io/muchobien/pocketbase` is the most popular community-maintained image. PocketBase itself has no
  official Docker image yet.
- **Data persistence**: `./pb_data` stores the SQLite database + uploaded files. Don't delete this folder.
- **Auto-admin**: `PB_ADMIN_EMAIL` and `PB_ADMIN_PASSWORD` create the superuser automatically on first boot.
- **Volumes**:
    - `pb_data` — database & file storage (critical)
    - `pb_public` — static files served at root (`/`)
    - `pb_hooks` — JS app hooks
    - `pb_migrations` — schema migrations

## Useful Commands

```bash
# Stop
docker compose -f docker-compose.pocketbase.yml down

# Stop and wipe data (careful!)
docker compose -f docker-compose.pocketbase.yml down -v

# Update to latest image
docker compose -f docker-compose.pocketbase.yml pull
docker compose -f docker-compose.pocketbase.yml up -d

# Create superuser manually
docker compose -f docker-compose.pocketbase.yml exec pocketbase pocketbase superuser create

# Shell into container
docker compose -f docker-compose.pocketbase.yml exec pocketbase /bin/sh
```

## ⚠️ Change the Default Password!

Before you forget: edit the compose file and change `PB_ADMIN_PASSWORD` from `changeme123` to something real. The
auto-upsert will update it on next restart.
