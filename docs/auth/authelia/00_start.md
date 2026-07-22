Authelia is fundamentally different from PocketBase (and the other IdPs like Zitadel/Logto). It is a **Forward
Authentication** server. It doesn't usually protect itself; it sits *behind* a reverse proxy (like Traefik, Nginx, or
Caddy) and intercepts requests to your other apps to check if you are logged in.

Because of this, testing Authelia locally can be tricky. To keep it "small" like we did with PocketBase, we are going to
set up Authelia in **Standalone/Portal Mode**. This allows us to access its login UI directly, set up 2FA, and see how
it handles users, without needing to configure a full reverse proxy right away.

Because your docker-compose.authelia.yml is going to reference the traefik_proxy network as an external network, that
network must already exist before you start Authelia. If you try to start Authelia first, Docker will throw a "network
not found" error.

Here is the deep dive.

### 1. Directory Structure

Create a new folder (e.g., `authelia-playground`) and create the following structure:

```text
authelia-playground/
├── docker-compose.authelia.yml
└── config/
    ├── configuration.yml
    └── users_database.yml
```

### 2. The Configuration Files

Authelia is strictly configured via YAML files.

**`config/configuration.yml`**
This is the main brain of Authelia. For our playground, we are using local SQLite for storage and a "filesystem
notifier" (which saves emails to a text file instead of sending them via SMTP).

```yaml
theme: 'dark'

server:
  host: '0.0.0.0'
  port: 9091

log:
  level: 'debug'

totp:
  issuer: 'localhost'

# We use a simple file for users in this playground
authentication_backend:
  file:
    path: /config/users_database.yml

# In production, this would be 'deny'. For the playground, we use 'bypass' 
# so we can actually access the UI without locking ourselves out.
access_control:
  default_policy: 'bypass'

session:
  name: 'authelia_session'
  # This must be a long random string in production
  secret: 'unsecure_session_secret_for_playground_only'
  expiration: '1h'
  inactivity: '5m'
  domain: 'localhost'

# Authelia needs a database to store 2FA secrets, session data, etc.
storage:
  local:
    path: /data/db.sqlite3

# Instead of an SMTP server, Authelia will write "emails" to this text file
notifier:
  filesystem:
    filename: /data/notification.txt
```

**`config/users_database.yml`**
This holds your users. **Crucial detail:** Authelia does *not* accept plain-text passwords. You must generate a hashed
password.

Open your terminal and run this command to generate an Argon2 hash for the password `"admin"`:

```bash
docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --password "admin"
```

Copy the output (it will look like `$argon2id$v=19$m=65536,t=3,p=4$...`) and paste it into the file below:

```yaml
users:
  admin:
    disabled: false
    displayname: "Playground Admin"
    # PASTE THE HASH FROM THE COMMAND ABOVE HERE:
    password: "$argon2id$v=19$m=65536,t=3,p=4$YOUR_HASH_HERE"
    email: admin@localhost
    groups:
      - admins
```

### 3. The `docker-compose.authelia.yml`

Now, tie it all together in your compose file:

```yaml
version: '3.8'

services:
  authelia:
    image: authelia/authelia:latest
    container_name: authelia
    restart: unless-stopped
    ports:
      - "9091:9091"
    volumes:
      # Mount the config folder
      - ./config:/config
      # Mount a data folder for the SQLite DB and notification text file
      - ./authelia_data:/data
    environment:
      # Tell Authelia where to find its config
      - X_AUTHELIA_CONFIG=/config/configuration.yml
```

### 4. Spinning it up

Start the container:

```bash
docker compose -f docker-compose.authelia.yml up -d
```

Check the logs to ensure it started without YAML syntax errors (Authelia is very strict about YAML indentation!):

```bash
docker compose -f docker-compose.authelia.yml logs -f
```

*You should see: `Listening on [::]:9091`*

### 5. Playground: Testing the Authelia Portal

Now for the fun part. Open your browser and go to: **`http://localhost:9091`**

1. **First Login:**
    * Username: `admin`
    * Password: `admin`
2. **Setup 2FA (Time-based One-Time Password):**
    * Authelia will immediately prompt you to set up 2FA.
    * It will show a QR code. Scan this with an authenticator app on your phone (like Google Authenticator, Authy, or
      1Password).
    * Enter the 6-digit code from your app to verify.
3. **The "Email" Magic:**
    * Because we used the filesystem notifier, Authelia doesn't have a real email server.
    * If you click "Need help?" or "Forgot Password" or need to register a new 2FA device, Authelia generates a link.
    * Open the file on your host machine: `authelia-playground/authelia_data/notification.txt`.
    * You will see the "emails" Authelia generated, complete with the registration/reset links! You can just copy those
      links and paste them into your browser.

### 6. The "Aha!" Moment: How Forward Auth Actually Works

Right now, you are just looking at Authelia's login screen. To understand what Authelia *actually* does, you need to
understand the **Forward Auth flow**.

In a real setup, the flow looks like this:

1. You go to `grafana.mydomain.com`.
2. Your Reverse Proxy (e.g., Traefik) intercepts the request.
3. Traefik pauses the request and sends a side-request to Authelia: *"Hey, is the user requesting `grafana` allowed
   in?"*
4. Authelia checks its database. If you aren't logged in, Authelia replies: *"No. Redirect them to my login page."*
5. Traefik redirects your browser to `auth.mydomain.com` (Authelia).
6. You log in, pass 2FA, and Authelia sets a secure cookie.
7. Authelia redirects you back to `grafana.mydomain.com`.
8. Traefik sees the Authelia cookie, asks Authelia again, Authelia says *"Yes, they are good"*, and Traefik finally lets
   the request through to Grafana.

**Next Steps for your Playground:**
Once you are comfortable with the Authelia container, the ultimate playground test is to add **Traefik** and a dummy app
like **`traefik/whoami`** to this compose file, and configure Traefik to use Authelia as its `forwardAuth` middleware.
You'll see the magic of SSO in real-time!
