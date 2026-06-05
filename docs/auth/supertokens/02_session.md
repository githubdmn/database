

### 1. The Critical Flaw in "Stateless" Verification

You've been using `checkDatabase: false` (which is the default), meaning your session verification is **stateless**. This is extremely fast, but it has a major security trade-off .

- **The Problem:** When you revoke a session (like you did with `POST /recipe/session/remove`), the access token itself isn't magically destroyed. If `checkDatabase` is `false`, SuperTokens only checks the token's signature and expiration date. A revoked token will remain **valid** until it naturally expires .
- **The Fix:** For sensitive operations (like changing a password or making a payment), you can force a database check. You already discovered the `checkDatabase: true` field earlier. Use it on critical API routes to ensure an immediately revoked session cannot be used .

### 2. Access Tokens Are **NOT** Standard JWTs

This is a very common point of confusion. The `access_token` you've been using is not a standard JWT and cannot be verified by a generic JWT library .

| Feature | Standard JWT | SuperTokens Access Token |
| :--- | :--- | :--- |
| **Standard Claims** | Contains claims like `sub` (subject), `iss` (issuer), `exp` (expiration). | Does **not** contain standard claims like `sub` or `iss`. |
| **Verification** | Can be verified by any standard library using a public key. | Must be verified by SuperTokens SDK or Core API; generic libraries will fail . |
| **Primary Use** | Meant to be self-contained and used by external services. | Meant only for your backend's `verify` session function. |

SuperTokens *can* issue a separate, standard JWT alongside the session, but you have to explicitly enable that feature if you need to integrate with external services .

### 3. Cookie vs. Header: The Security Trade-off

You've been manually adding an `Authorization: Bearer` header. This is **header-based** session management. The alternative is **cookie-based**, where tokens are stored in `HttpOnly` cookies .

| Method | How It Works | Security Implication |
| :--- | :--- | :--- |
| **Header-Based** | Token is stored in browser's localStorage and sent via `Authorization` header. | Vulnerable to **XSS attacks**. If an attacker runs a script on your page, they can steal the token . |
| **Cookie-Based** | Token is stored in an `HttpOnly` cookie, inaccessible to JavaScript. | Immune to XSS token theft, but must be properly configured to protect against **CSRF attacks** . |

The Core API accepts both methods, but for a web app, cookie-based is the more secure, production-ready approach .

### 4. The "Anti-Csrf" Field You Kept Sending

You might have noticed a recurring field in your requests: `enableAntiCsrf` and `doAntiCsrfCheck`. This is directly related to the cookie-based method .

- If you use cookie-based sessions, you are vulnerable to Cross-Site Request Forgery (CSRF) attacks.
- To prevent this, SuperTokens uses an anti-CSRF token. This is a dynamic value that must be sent along with requests (e.g., in a custom header).
- When you set `enableAntiCsrf: false`, you are telling SuperTokens, "I am handling CSRF protection myself" or "I am not using cookies, so it's not relevant." Since you're using header-based auth, setting this to `false` is correct .

### 5. Dynamic Signing Keys (You Already Met This!)

The `useDynamicSigningKey` field you saw is a powerful security feature. By default, SuperTokens automatically rotates the private keys used to sign access tokens every 168 hours .

- **Dynamic (`true`):** The signing key changes periodically. A stolen key from 2 weeks ago is useless. This is the default and most secure mode.
- **Static (`false`):** The key never changes. This makes it easier to hard-code a public key for external verification, but it is less secure.

You changed this to `false` during your refresh tests. This creates a *static* key (`kid` starting with `s-`), which is useful for your learning but should be avoided in production unless you have a specific need .

### Summary & What to Explore Next

You've learned the essentials. To deepen your knowledge, you could explore these advanced topics:

- **Sharing Sessions Across Subdomains:** How to keep a user logged in across `app.example.com` and `dashboard.example.com` .
- **Anonymous Sessions:** Creating temporary sessions for users who aren't logged in (e.g., to track a shopping cart) and then transferring that data when they sign up .
- **Protecting Routes with MFA:** How to protect routes based on claims in the session's access token (e.g., "is MFA completed?") .

