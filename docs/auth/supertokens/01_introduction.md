## What is a "Recipe" in SuperTokens?

A **Recipe** is SuperTokens' modular building block for authentication functionality. Think of it as a pluggable module that handles a specific authentication task. Each recipe provides:

- A complete set of APIs for that authentication method
- Database schema and storage logic
- Session management integration
- Frontend UI components (if using Pre-built UI)

### Common Recipes

| Recipe | What It Does |
|--------|--------------|
| **EmailPassword** | Email + password sign up, sign in, password reset, email verification |
| **ThirdParty** | Social login (Google, GitHub, Apple, etc.) via OIDC |
| **Passwordless** | Magic links, OTP codes via email or SMS |
| **Session** | Session creation, verification, refresh, revocation (can be used alone) |

Recipes can also be **combined**. For example, `ThirdPartyEmailPassword` is a built-in meta-recipe that lets users choose between email/password OR social login.

---

## The Complete Workflow: Sign Up → Sign In → Session

This is **not** well explained in the documentation because the SDKs abstract away the internal API calls. Here's what actually happens:

### Step 1: Sign Up (`POST /recipe/signup`)

**What it does:**
- Validates email format and password strength
- Hashes the password (bcrypt by default)
- Creates a user record in the database
- Returns the `user` object with the new user's ID

**What it does NOT do:**
- No session is created
- No tokens are generated

```json
// Response from /recipe/signup
{
    "status": "OK",
    "user": {
        "id": "e7eead49...",           // Primary user ID
        "emails": ["test@mail.com"],
        "timeJoined": 1780579920081,
        "loginMethods": [{
            "recipeId": "emailpassword",  // Which recipe created this
            "recipeUserId": "e7eead49..." // Recipe-specific ID
        }]
    }
}
```

### Step 2: Sign In (`POST /recipe/signin`)

**What it does:**
- Looks up user by email
- Verifies the password hash
- Returns the same user object

**What it does NOT do:**
- Still no session or tokens

**Why separate?** The same sign in API works for all recipes (email/password, social, passwordless), but sessions are handled by the Session recipe independently. This separation allows you to use your own custom authentication logic with SuperTokens' session management.

### Step 3: Create Session (`POST /recipe/session`)

**This is where tokens are actually created.**

The Session recipe's `createNewSession` function:
- Generates an `access_token` (short-lived, ~1 hour)
- Generates a `refresh_token` (long-lived, ~100 days)
- Stores session info in the `session_info` database table
- Returns both tokens

```json
// Response from /recipe/session
{
    "status": "OK",
    "accessToken": { "token": "eyJ...", "expiry": 1780585488000 },
    "refreshToken": { "token": "Rxax...", "expiry": 1789221888832 },
    "session": { "handle": "...", "userId": "..." }
}
```

---

## Why This Architecture? The Primary vs Recipe User ID Concept

This is the subtle but important piece. SuperTokens supports **account linking** (one user with multiple login methods).


### Two Types of User IDs

| ID Type | Purpose | Example |
|---------|---------|---------|
| **Primary User ID** (`user.id`) | The stable identifier for the user across all login methods. **Use this for associating data** (profiles, orders, etc.) | `e7eead49-...` |
| **Recipe User ID** (`recipeUserId`) | A unique ID for EACH login method. Changes when accounts are linked | Same value initially, changes if user links social login later |

### Example of Account Linking

1. User signs up with email/password → `recipeUserId = r1`, `primary userId = r1`
2. User later signs in with Google (same email) → creates `recipeUserId = r2`
3. With account linking enabled → `r2` links to `r1`, primary remains `r1`
4. The user's data stays attached to `r1` across both login methods

### Why Your Response Shows the Same Value for Both

In your fresh signup, there's only **one login method**. So:
- `user.id` = primary user ID = `e7eead49...`
- `recipeUserId` = the recipe-specific ID = `e7eead49...`

They match because there's nothing to link yet. If you later add Google login to the same email, you'd see different values.

---

## The Complete Sequence Diagram

```
┌─────────┐     ┌─────────────┐     ┌─────────────┐
│ Client  │     │ SuperTokens │     │  Database   │
│ (Bruno) │     │    Core     │     │ (Postgres)  │
└────┬────┘     └──────┬──────┘     └──────┬──────┘
     │                 │                   │
     │ 1. POST /recipe/signup              │
     │    (email + password)               │
     │─────────────────>│                  │
     │                  │  Create user     │
     │                  │─────────────────>│
     │                  │<─────────────────│
     │<─────────────────│                  │
     │    { user, status: "OK" }           │
     │                 │                   │
     │ 2. POST /recipe/signin               │
     │    (email + password)               │
     │─────────────────>│                  │
     │                  │  Verify password │
     │                  │─────────────────>│
     │                  │<─────────────────│
     │<─────────────────│                  │
     │    { user, status: "OK" }           │
     │                 │                   │
     │ 3. POST /recipe/session             │
     │    (userId from step 1 or 2)        │
     │─────────────────>│                  │
     │                  │  Create session  │
     │                  │  Store in       │
     │                  │  session_info   │
     │                  │─────────────────>│
     │                  │<─────────────────│
     │<─────────────────│                  │
     │    { accessToken, refreshToken,     │
     │      session: {...} }               │
     │                                      │
     │ 4. Use accessToken for future calls  │
     │    (Authorization: Bearer <token>)  │
     │─────────────────>│                  │
     │                  │  Verify token    │
     │                  │─────────────────>│
     │                  │<─────────────────│
     │<─────────────────│                  │
     │    { userId, session info }          │
```

---

## Why This Isn't in the Documentation

The documentation assumes you're using the SDKs. When you use a backend SDK (Node.js, Python, Go), it **automatically**:

1. Calls `/recipe/signup` or `/recipe/signin`
2. Takes the `userId` from the response
3. Immediately calls `/recipe/session` to create a session
4. Sets HTTP-only cookies on the response to your frontend

So developers never see these as separate steps. The SDK also manages token refresh automatically when the access token expires.

You're seeing the raw APIs because you're skipping the SDK, which is actually a great way to learn how it works under the hood
