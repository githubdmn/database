## The Complete Guide to Understanding SuperTokens Sessions

Let me explain sessions in a way that will **stick in your memory** using analogies, visual flows, and simple rules.

---

## Part 1: The Restaurant Analogy 🍽️

Think of a session like **dining at a restaurant**:

| Concept | Restaurant Analogy | SuperTokens Reality |
|---------|-------------------|---------------------|
| **Sign Up** | Getting a loyalty card | Creating a user record |
| **Sign In** | Walking into the restaurant | Providing credentials |
| **Session** | Being seated at a table | A unique login instance |
| **Access Token** | Your fork (for eating) | Proves who you are for 1 hour |
| **Refresh Token** | Your coat check ticket | Gets you a new fork when yours is taken |
| **Session Handle** | Your table number | Identifies which "table" you're at |
| **Sign Out** | Leaving the restaurant | Ending the meal |
| **Multiple Sessions** | Same person at 3 different tables | Logged in on phone + laptop + tablet |

**The key insight:** One person (user) can have many tables (sessions), each with their own fork (access token) and coat check ticket (refresh token).

---

## Part 2: The Session Lifecycle Flow

Here's the complete journey of a session from birth to death:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SESSION LIFECYCLE                                    │
└─────────────────────────────────────────────────────────────────────────────┘

     BIRTH                      LIFE                        DEATH
      │                          │                            │
      ▼                          ▼                            ▼
┌─────────────┐          ┌─────────────┐              ┌─────────────┐
│  CREATE     │ ───────► │  VERIFY     │ ───────────► │  REVOKE     │
│  Session    │          │  Session    │              │  Session    │
└─────────────┘          └─────────────┘              └─────────────┘
      │                          │                            │
      │                          │                            │
      ▼                          ▼                            ▼
  User logs in            Every API call              User logs out
  after signup            checks this                 or admin removes
                                                      or token expires
```

### Detailed Flow with Time:

```
Timeline: ─────────────────────────────────────────────────────────────────►

Hour 0:    Hour 1-100:                              Hour 100+:
┌──────┐   ┌──────────────────────────────────┐    ┌──────────┐
│CREATE│   │ Every API call:                  │    │ SESSION  │
│      │   │ "Is this access token valid?"    │    │  DIES    │
└──────┘   └──────────────────────────────────┘    └──────────┘
    │                      │                             │
    │                      │                             │
    ▼                      ▼                             ▼
User signs in        Access token expires            Refresh token
gets tokens          at hour 1 → REFRESH             expires at
                     gets new tokens                 hour 100+
                     (session continues)
```

---

## Part 3: The Three States of a Session

A session can only be in **one of three states** at any time:

| State | What It Means | Can You Use It? |
|-------|---------------|-----------------|
| 🟢 **ACTIVE** | Session exists, tokens valid | ✅ Yes |
| 🟡 **EXPIRED** | Refresh token expired (after ~100 days) | ❌ No — must sign in again |
| 🔴 **REVOKED** | Manually terminated (sign out) | ❌ No — gone forever |

**Once a session is REVOKED or EXPIRED, it CANNOT come back to life.**

---

## Part 4: The Two-Token System (Most Important!)

This is the genius of SuperTokens. Two tokens with **different jobs**:

```
┌─────────────────────────────────────────────────────────────────┐
│                    ACCESS TOKEN (Short-term)                     │
├─────────────────────────────────────────────────────────────────┤
│  Lifetime: 1 hour                                                │
│  Job: Prove who you are for each API request                     │
│  Where: Sent in Authorization header                             │
│  What happens when expired? → Use refresh token to get a new one │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    REFRESH TOKEN (Long-term)                     │
├─────────────────────────────────────────────────────────────────┤
│  Lifetime: 100 days                                              │
│  Job: Get new access tokens when they expire                     │
│  Where: Also in Authorization header (for refresh endpoint)      │
│  What happens when expired? → User must sign in again            │
└─────────────────────────────────────────────────────────────────┘
```

### Why Two Tokens? The Security Reason:

| Attack Scenario | With 1 Token | With 2 Tokens |
|----------------|--------------|---------------|
| Token stolen | Attacker has access for 100 days! | Attacker has access for only 1 hour |
| After fix | User must change password | Refresh token invalidates, attacker locked out |

**The refresh token is kept more secure** (often in an HttpOnly cookie) while the access token can be less secure because it expires quickly.

---

## Part 5: The Refresh Dance (Most Common Flow)

Here's what happens 99% of the time in a production app:

```
User opens app after 2 hours
           │
           ▼
┌─────────────────────────────────────────┐
│  App tries to make an API request        │
│  with the OLD access token               │
└─────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Backend: "This token is EXPIRED"        │
│  Returns 401 Unauthorized                │
└─────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  App automatically calls /refresh        │
│  using the REFRESH token                 │
└─────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  SuperTokens:                            │
│  "Here's a BRAND NEW access token"       │
└─────────────────────────────────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  App retries the original request        │
│  with the NEW access token               │
│  ✅ SUCCESS!                              │
└─────────────────────────────────────────┘
```

**The user never knows any of this happened.** They just kept using the app.

---

## Part 6: The Three Ways to Kill a Session

```
┌─────────────────────────────────────────────────────────────────┐
│                     DEATH OF A SESSION                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. USER SIGNS OUT                                               │
│     POST /recipe/session/remove                                 │
│     → Session is REVOKED immediately                            │
│                                                                  │
│  2. REFRESH TOKEN EXPIRES                                        │
│     After ~100 days with no activity                            │
│     → Session is EXPIRED, user must sign in again               │
│                                                                  │
│  3. ADMIN FORCE REVOKE                                           │
│     "Log out from all devices" after password change            │
│     → All sessions REVOKED immediately                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Part 7: Multiple Sessions — The Mental Model

**The most confusing part made simple:**

```
USER: John (userId = "john123")
           │
           ├─── SESSION A (Laptop - Chrome)
           │    ├── handle: "abc-111"
           │    ├── access_token: "token-A"
           │    └── refresh_token: "refresh-A"
           │
           ├─── SESSION B (Phone - Safari)
           │    ├── handle: "abc-222"
           │    ├── access_token: "token-B"
           │    └── refresh_token: "refresh-B"
           │
           └─── SESSION C (Tablet - Chrome Incognito)
                ├── handle: "abc-333"
                ├── access_token: "token-C"
                └── refresh_token: "refresh-C"
```

**Key rules:**
- Each session is **completely independent**
- token-A cannot be used for session B
- Revoking session A does NOT affect B or C
- All three show John as the same user

---

## Part 8: Quick Reference — What Each Endpoint Does

| Endpoint | Action | Changes Session State? |
|----------|--------|----------------------|
| `POST /recipe/session` | Create new session | 🟢 Creates NEW session |
| `POST /recipe/session/verify` | Check if token is valid | No change |
| `POST /recipe/session/refresh` | Get new access token | 🔄 Extends session life |
| `POST /recipe/session/remove` with `userId` | Kill ALL user sessions | 🔴 Kills multiple sessions |
| `POST /recipe/session/remove` with `sessionHandle` | Kill ONE session | 🔴 Kills one session |

---

## Part 9: Memory Tricks

### The "House Key" Analogy:
- **Access Token** = Your house key (use it every time you enter)
- **Refresh Token** = Your ID at the locksmith (get a new key when you lose yours)
- **Session** = Your lease agreement (proves you live there)
- **Sign Out** = Moving out (lease terminated, keys don't work)

### The "Movie Theater" Analogy:
- **Access Token** = Today's ticket (valid only for today's show)
- **Refresh Token** = Season pass (get new tickets all year)
- **Session** = Your seat reservation (unique to this showing)
- **Multiple Sessions** = Watching same movie in 3 different theaters

---

## Part 10: The One-Page Summary

```
═══════════════════════════════════════════════════════════════════
                    SESSIONS IN 60 SECONDS
═══════════════════════════════════════════════════════════════════

WHAT IS A SESSION?
→ A unique login instance. One user can have many sessions.

THE TWO TOKENS:
→ Access Token  (lives 1 hour)  → For API requests
→ Refresh Token (lives 100 days) → To get new access tokens

THE FLOW:
1. Sign in → CREATE session → Get both tokens
2. Every API call → VERIFY access token
3. After 1 hour → REFRESH → Get new access token
4. User clicks "Sign Out" → REVOKE session

REMEMBER:
┌─────────────────────────────────────────────────────┐
│  ACCESS TOKEN = Short-term proof of identity        │
│  REFRESH TOKEN = Long-term key to get new proof     │
│  SESSION = The container that holds both            │
│  HANDLE = The unique ID of that container           │
└─────────────────────────────────────────────────────┘

MULTIPLE SESSIONS:
Same user + different devices/browsers = multiple sessions
Each session has its own tokens. They don't mix.

═══════════════════════════════════════════════════════════════════
```

---

## Part 11: Test Your Understanding

Answer these to check if you've got it:

1. **If a user signs in on Chrome and Firefox, how many sessions?** → 2 sessions
2. **If access token expires, does the session die?** → No, just refresh it
3. **If refresh token expires, does the session die?** → Yes, user must sign in again
4. **Can token from Chrome session work for Firefox session?** → No, completely separate
5. **What happens when you call `/session/remove` with userId?** → All sessions for that user are killed

---

