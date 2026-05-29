
services:
  vikunja:
    image: vikunja/vikunja
    environment:
      VIKUNJA_SERVICE_PUBLICURL: http://172.16.6.3
      VIKUNJA_DATABASE_HOST: db
      VIKUNJA_DATABASE_TYPE: postgres
      VIKUNJA_DATABASE_USER: vikunja
      VIKUNJA_DATABASE_DATABASE: vikunja
      VIKUNJA_DATABASE_PASSWORD: [MDP]
      VIKUNJA_SERVICE_SECRET: a2bd705f44f2742047cc1fb4c88aebd1ca2e1800fae0d2c599748b4da336e1f0
    volumes:
      - ./files:/app/vikunja/files
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped

  db:
    image: postgres:18
    environment:
      POSTGRES_USER: vikunja
      POSTGRES_DB: vikunja
      POSTGRES_PASSWORD: [MDP]
    volumes:
      - ./db:/var/lib/postgresql/data
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -h localhost -U $$POSTGRES_USER"]
      interval: 2s
      start_period: 30s

  caddy:
    image: caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - vikunja
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - ./caddy-data:/data
