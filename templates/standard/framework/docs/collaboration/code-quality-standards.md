# Code Quality Standards

**Version:** 1.0.0
**Last Updated:** 2025-12-22
**Audience:** All contributors (human and AI)

---

## Purpose

This guide defines coding standards, best practices, and quality expectations for this project. Following these standards ensures consistent, maintainable, and reliable code.

For quick reference, see [CLAUDE.md](../../../CLAUDE.md) for summaries.

---

## Table of Contents

1. [Clean Code Principles](#clean-code-principles)
2. [Code Organization](#code-organization)
3. [Naming Conventions](#naming-conventions)
4. [Function Design](#function-design)
5. [Error Handling](#error-handling)
6. [Comments and Documentation](#comments-and-documentation)
7. [Code Review Standards](#code-review-standards)

---

## Clean Code Principles

### DRY (Don't Repeat Yourself)

**Principle:** Don't duplicate code. If similar logic exists in two places, refactor into a shared function.

**When duplication is acceptable:**
- Coincidental similarity (happens to look similar now, but will diverge)
- Different domains (user validation vs API validation may look similar but serve different contexts)
- Performance-critical paths (sometimes duplication is faster than abstraction)

**Example - Bad (duplication):**
```javascript
// User registration
function registerUser(email, password) {
  if (!email || !email.includes('@')) {
    throw new Error('Invalid email');
  }
  if (!password || password.length < 8) {
    throw new Error('Password too short');
  }
  // ... registration logic
}

// Password reset
function resetPassword(email, newPassword) {
  if (!email || !email.includes('@')) {
    throw new Error('Invalid email');
  }
  if (!newPassword || newPassword.length < 8) {
    throw new Error('Password too short');
  }
  // ... reset logic
}
```

**Example - Good (extracted):**
```javascript
// Shared validation
function validateEmail(email) {
  if (!email || !email.includes('@')) {
    throw new Error('Invalid email');
  }
}

function validatePassword(password) {
  if (!password || password.length < 8) {
    throw new Error('Password too short');
  }
}

// User registration
function registerUser(email, password) {
  validateEmail(email);
  validatePassword(password);
  // ... registration logic
}

// Password reset
function resetPassword(email, newPassword) {
  validateEmail(email);
  validatePassword(newPassword);
  // ... reset logic
}
```

**When to refactor:**
- Third occurrence of similar code (rule of three)
- Logic is complex and error-prone to maintain in multiple places
- Business rule that applies consistently across contexts

### Single Responsibility Principle

**Principle:** Each function/module should have one clear purpose. Don't lump unrelated logic together.

**Example - Bad (multiple responsibilities):**
```javascript
function processOrder(order) {
  // Validate order
  if (!order.items || order.items.length === 0) {
    throw new Error('Order is empty');
  }

  // Calculate total
  let total = 0;
  for (const item of order.items) {
    total += item.price * item.quantity;
  }

  // Apply discount
  if (order.couponCode) {
    const discount = lookupCoupon(order.couponCode);
    total = total * (1 - discount);
  }

  // Send email
  sendEmail(order.email, `Your order total is $${total}`);

  // Save to database
  database.save('orders', { ...order, total });

  return total;
}
```

**Example - Good (single responsibilities):**
```javascript
function validateOrder(order) {
  if (!order.items || order.items.length === 0) {
    throw new Error('Order is empty');
  }
}

function calculateOrderTotal(order) {
  let total = 0;
  for (const item of order.items) {
    total += item.price * item.quantity;
  }
  return total;
}

function applyDiscount(total, couponCode) {
  if (!couponCode) return total;
  const discount = lookupCoupon(couponCode);
  return total * (1 - discount);
}

function processOrder(order) {
  validateOrder(order);
  let total = calculateOrderTotal(order);
  total = applyDiscount(total, order.couponCode);

  sendOrderConfirmation(order.email, total);
  saveOrder({ ...order, total });

  return total;
}
```

**Benefits:**
- Easier to test (each function tests one thing)
- Easier to understand (function name tells you what it does)
- Easier to reuse (calculate total elsewhere without order processing)
- Easier to modify (change discount logic without touching validation)

### Keep It Simple (KISS)

**Principle:** Prefer simple, straightforward solutions over clever or complex ones.

**Example - Bad (over-engineered):**
```javascript
// Generic abstract factory pattern for simple config
class ConfigurationFactory {
  createStrategy(type) {
    const strategies = {
      dev: () => new DevelopmentStrategy(),
      prod: () => new ProductionStrategy(),
      test: () => new TestStrategy()
    };
    return strategies[type]?.() ?? new DefaultStrategy();
  }
}

class DevelopmentStrategy {
  getConfig() {
    return { apiUrl: 'http://localhost:3000' };
  }
}
// ... more classes
```

**Example - Good (simple):**
```javascript
const config = {
  dev: { apiUrl: 'http://localhost:3000' },
  prod: { apiUrl: 'https://api.example.com' },
  test: { apiUrl: 'http://localhost:3001' }
};

function getConfig(env = 'dev') {
  return config[env] || config.dev;
}
```

**When complexity is justified:**
- Genuinely complex domain (financial calculations, algorithms)
- Performance requirements demand optimization
- Extensibility needed (plugin system, framework)
- Security requirements (encryption, authentication)

**Default to simple. Add complexity only when needed.**

---

## Code Organization

### File Structure

**Principle:** Organize files by feature, not by file type.

**Bad (organized by type):**
```
src/
├── controllers/
│   ├── userController.js
│   ├── orderController.js
│   └── productController.js
├── models/
│   ├── User.js
│   ├── Order.js
│   └── Product.js
├── views/
│   ├── users.html
│   ├── orders.html
│   └── products.html
└── utils/
    └── helpers.js
```

**Good (organized by feature):**
```
src/
├── users/
│   ├── UserController.js
│   ├── UserModel.js
│   ├── userView.html
│   └── userHelpers.js
├── orders/
│   ├── OrderController.js
│   ├── OrderModel.js
│   ├── orderView.html
│   └── orderHelpers.js
└── products/
    ├── ProductController.js
    ├── ProductModel.js
    ├── productView.html
    └── productHelpers.js
```

**Why:** Related code stays together. When working on "users" feature, all files are in one place.

### Module Size

**Guideline:**
- **Files:** 200-500 lines max (excluding tests)
- **Functions:** 50 lines max
- **Classes:** 300 lines max

**When file exceeds limit:** Extract related functionality into subfolder.

**Example:**
```
orders/
├── OrderController.js (350 lines)
├── validation/
│   ├── orderValidation.js
│   └── paymentValidation.js
└── processing/
    ├── calculateTotal.js
    └── applyDiscounts.js
```

---

## Naming Conventions

### General Principles

- **Be descriptive:** Name should explain what it does
- **Be consistent:** Use same patterns throughout codebase
- **Avoid abbreviations:** `user` not `usr`, `calculate` not `calc`
- **Use project conventions:** Follow language-specific standards

### Variables

**Use nouns or noun phrases:**

```javascript
// Good
const userEmail = 'user@example.com';
const orderTotal = 150.00;
const isAuthenticated = true;
const hasPermission = false;

// Bad
const data = 'user@example.com';  // Too generic
const tmp = 150.00;                // Meaningless
const flag = true;                 // What flag?
const x = false;                   // No context
```

**Boolean variables:**
- Prefix with `is`, `has`, `can`, `should`
- Examples: `isValid`, `hasAccess`, `canEdit`, `shouldRetry`

### Functions

**Use verbs or verb phrases:**

```javascript
// Good
function calculateTotal(items) { }
function validateEmail(email) { }
function sendConfirmation(user) { }
function getUserById(id) { }

// Bad
function total(items) { }          // Noun, not verb
function email(email) { }          // Ambiguous
function confirmation(user) { }    // What about confirmation?
function user(id) { }              // Too generic
```

**Function naming patterns:**
- `get` - Returns value (getUser, getTotal)
- `set` - Sets value (setTheme, setConfig)
- `is/has/can` - Returns boolean (isValid, hasAccess, canEdit)
- `calculate` - Performs calculation (calculateTotal, calculateTax)
- `validate` - Checks validity (validateEmail, validateOrder)
- `process` - Processes data (processPayment, processOrder)
- `handle` - Event handler (handleClick, handleSubmit)

### Constants

**Use UPPER_SNAKE_CASE for true constants:**

```javascript
// Good
const MAX_RETRY_ATTEMPTS = 3;
const API_BASE_URL = 'https://api.example.com';
const DEFAULT_TIMEOUT = 5000;

// Config objects use camelCase
const config = {
  maxRetries: 3,
  timeout: 5000
};
```

---

## Function Design

### Function Size

**Target:** ≤ 50 lines per function

**Why:**
- Fits on one screen (easier to understand)
- Easier to test
- Usually indicates single responsibility
- Easier to reuse

**When function exceeds 50 lines:**

1. **Extract helper functions:**
```javascript
// Before (80 lines)
function processOrder(order) {
  // 20 lines of validation
  // 30 lines of calculation
  // 20 lines of database operations
  // 10 lines of notification
}

// After (15 lines)
function processOrder(order) {
  validateOrder(order);
  const total = calculateOrderTotal(order);
  saveOrder(order, total);
  sendOrderNotifications(order, total);
  return total;
}
```

2. **Extract into class if related state:**
```javascript
class OrderProcessor {
  constructor(order) {
    this.order = order;
    this.total = 0;
  }

  process() {
    this.validate();
    this.calculateTotal();
    this.save();
    this.notify();
    return this.total;
  }

  validate() { /* ... */ }
  calculateTotal() { /* ... */ }
  save() { /* ... */ }
  notify() { /* ... */ }
}
```

### Function Parameters

**Guideline:** ≤ 3 parameters ideal, 5 maximum

**When > 3 parameters, use options object:**

```javascript
// Bad (many parameters)
function createUser(name, email, password, role, isActive, department, manager) {
  // ...
}

// Good (options object)
function createUser({ name, email, password, role, isActive, department, manager }) {
  // ...
}

// Usage is self-documenting
createUser({
  name: 'John Doe',
  email: 'john@example.com',
  password: 'secret',
  role: 'developer',
  isActive: true,
  department: 'Engineering',
  manager: 'Jane Smith'
});
```

**Benefits:**
- Order doesn't matter
- Optional parameters clear
- Self-documenting at call site

### Return Values

**Be consistent with return types:**

```javascript
// Bad (inconsistent returns)
function findUser(id) {
  const user = database.find(id);
  if (user) {
    return user;
  }
  return false;  // Mixing types!
}

// Good (consistent null for not found)
function findUser(id) {
  const user = database.find(id);
  return user || null;
}

// Also good (throw on not found if that's expected)
function findUser(id) {
  const user = database.find(id);
  if (!user) {
    throw new Error(`User ${id} not found`);
  }
  return user;
}
```

---

## Error Handling

### Fail Fast Principle

**Principle:** Validate inputs early. Throw errors for invalid input rather than proceeding with wrong assumptions.

```javascript
// Good (fail fast)
function divide(a, b) {
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new TypeError('Both arguments must be numbers');
  }
  if (b === 0) {
    throw new Error('Division by zero');
  }
  return a / b;
}

// Bad (proceeding with invalid input)
function divide(a, b) {
  return a / b;  // NaN or Infinity, hard to debug later
}
```

### Graceful Degradation

**Handle errors gracefully with user-friendly messages:**

```javascript
// Good
async function fetchUserProfile(userId) {
  try {
    const response = await api.get(`/users/${userId}`);
    return response.data;
  } catch (error) {
    if (error.status === 404) {
      throw new Error('User not found. Please check the user ID.');
    }
    if (error.status === 503) {
      throw new Error('Service temporarily unavailable. Please try again later.');
    }
    // Log technical details for debugging
    console.error('Failed to fetch user profile:', error);
    throw new Error('Unable to load user profile. Please try again.');
  }
}
```

### No Silent Failures

**Always surface errors - don't swallow them:**

```javascript
// Bad (silent failure)
function saveConfig(config) {
  try {
    fs.writeFileSync('config.json', JSON.stringify(config));
  } catch (error) {
    // Silently ignoring error!
  }
}

// Good (surface error)
function saveConfig(config) {
  try {
    fs.writeFileSync('config.json', JSON.stringify(config));
  } catch (error) {
    console.error('Failed to save config:', error);
    throw new Error(`Unable to save configuration: ${error.message}`);
  }
}

// Also good (return success/failure)
function saveConfig(config) {
  try {
    fs.writeFileSync('config.json', JSON.stringify(config));
    return { success: true };
  } catch (error) {
    console.error('Failed to save config:', error);
    return { success: false, error: error.message };
  }
}
```

### Logging

**Include helpful context in logs:**

```javascript
// Bad (no context)
console.log('Error');
console.log(error);

// Good (helpful context)
console.error('Failed to process order:', {
  orderId: order.id,
  userId: order.userId,
  error: error.message,
  stack: error.stack
});
```

**Log levels:**
- **ERROR:** Something failed, needs attention
- **WARN:** Something unexpected, but handled
- **INFO:** Normal operations, key milestones
- **DEBUG:** Detailed information for troubleshooting

**Avoid log spam:** Don't log in tight loops or high-frequency operations in production.

---

## Comments and Documentation

### When to Comment

**DO comment:**
- **Non-obvious logic:** Why this approach vs alternatives
- **Business rules:** "VAT is 20% for EU customers"
- **Workarounds:** "TODO: Remove after API v2 migration"
- **Complex algorithms:** Explain the approach
- **Public APIs:** Parameters, return values, examples

**DON'T comment:**
- **Self-explanatory code:** Code already says what it does
- **Redundant statements:** `i++; // increment i`
- **Commented-out code:** Delete it (git history preserves)
- **Obvious facts:** `return true; // returns true`

### Comment Quality

**Bad comments:**
```javascript
// Loop through items
for (const item of items) {
  // Get the price
  const price = item.price;
  // Add to total
  total += price;
}
```

**Good comments:**
```javascript
// Apply early-bird discount: 10% off for orders placed before 9 AM
if (order.timestamp.getHours() < 9) {
  total = total * 0.9;
}

// Workaround for API rate limit: batch requests in groups of 100
// TODO: Remove after API v2 supports bulk operations
for (let i = 0; i < users.length; i += 100) {
  const batch = users.slice(i, i + 100);
  await processBatch(batch);
}
```

### Function Documentation

**Document public APIs:**

```javascript
/**
 * Calculate invoice total including tax and discounts.
 *
 * Applies discounts before tax calculation.
 * Rounds to 2 decimal places.
 *
 * @param {number} subtotal - Pre-tax subtotal in dollars
 * @param {number} taxRate - Tax rate as decimal (0.08 = 8%)
 * @param {number} discountPercent - Discount as percentage (10 = 10% off)
 * @returns {number} Final total in dollars, rounded to 2 decimals
 * @throws {TypeError} If parameters are not numbers
 *
 * @example
 * calculateTotal(100, 0.08, 10)
 * // Returns 97.20
 * // Calculation: (100 - 10%) * (1 + 8%) = 90 * 1.08 = 97.20
 */
function calculateTotal(subtotal, taxRate, discountPercent) {
  if (typeof subtotal !== 'number' || typeof taxRate !== 'number' || typeof discountPercent !== 'number') {
    throw new TypeError('All parameters must be numbers');
  }

  const afterDiscount = subtotal * (1 - discountPercent / 100);
  const withTax = afterDiscount * (1 + taxRate);
  return Math.round(withTax * 100) / 100;
}
```

### TODO Comments

**Format:** `TODO: Description (optional: assigned, date)`

```javascript
// TODO: Add input validation
// TODO: Optimize for large datasets (John, 2025-12-30)
// TODO: Remove after migration to v2 API
```

**Track TODOs:** Regularly review and address or remove.

---

## Code Review Standards

### Self-Review Checklist

Before submitting code for review:

- [ ] Code follows project standards (this document)
- [ ] No commented-out code
- [ ] No debug console.log statements
- [ ] Meaningful variable and function names
- [ ] Functions ≤ 50 lines
- [ ] No code duplication (DRY)
- [ ] Error cases handled gracefully
- [ ] Edge cases considered
- [ ] Tests included (see [testing-strategy.md](testing-strategy.md))
- [ ] Documentation updated (README, API docs, etc.)

### Peer Review Checklist

**Functionality:**
- [ ] Code does what it's supposed to do
- [ ] Edge cases handled
- [ ] No obvious bugs
- [ ] Tests cover main scenarios

**Quality:**
- [ ] Follows coding standards
- [ ] No unnecessary complexity
- [ ] DRY principle followed
- [ ] Good naming conventions
- [ ] Appropriate comments

**Security:**
- [ ] Input validation present
- [ ] No SQL injection vulnerabilities
- [ ] No XSS vulnerabilities
- [ ] Secrets not hardcoded
- [ ] See [security-policy.md](security-policy.md)

**Performance:**
- [ ] No obvious performance issues
- [ ] Appropriate algorithms used
- [ ] Database queries optimized
- [ ] No N+1 query problems

**Maintainability:**
- [ ] Will be easy to modify later
- [ ] Clear intent
- [ ] Well-structured
- [ ] Appropriate documentation

### Providing Feedback

**Be constructive:**
- ✅ "Consider extracting this validation into a helper function for reusability"
- ❌ "This code is a mess"

**Be specific:**
- ✅ "Line 45: This query will be slow with >1000 users. Consider adding an index on email field."
- ❌ "Performance issues"

**Explain why:**
- ✅ "Using let here allows reassignment. Since this value never changes, const would prevent accidental modifications and communicate intent."
- ❌ "Use const instead"

**Distinguish must-fix from suggestions:**
- 🔴 **Required:** "This SQL injection vulnerability must be fixed before merging"
- 🟡 **Suggested:** "Consider renaming `data` to `userProfile` for clarity"

---

## PowerShell Standards

### Output for Programmatic Consumption

**Use `Write-Output` instead of `Write-Host` when output needs to be captured:**

```powershell
# Bad - Write-Host bypasses stdout, output not capturable
Write-Host "Processing complete: $result"

# Good - Write-Output writes to stdout, capturable by calling processes
Write-Output "Processing complete: $result"

# Also good - implicit output (equivalent to Write-Output)
"Processing complete: $result"
```

**When to use each:**
- `Write-Host` - Interactive display only (colored status messages, progress indicators)
- `Write-Output` - Data that may be captured, piped, or consumed by other tools

**Why this matters:** Scripts called by automation tools (Claude Code, CI/CD, etc.) need their output captured via stdout. `Write-Host` writes directly to the console and bypasses the output stream entirely.

### Unicode and UTF-8 Encoding

**Windows PowerShell 5.1 defaults to legacy OEM encoding (Code Page 437), not UTF-8.** This causes Unicode characters (arrows, emoji, non-ASCII text) to display incorrectly or be dropped.

**For scripts that output Unicode characters:**

```powershell
# At the start of your script, set UTF-8 output encoding
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# When reading files with Unicode content, specify encoding
$content = Get-Content -Path $file -Raw -Encoding UTF8
```

**Encoding contexts:**
- `[Console]::OutputEncoding` - Controls how PowerShell encodes output to the console/pipe
- `-Encoding UTF8` on `Get-Content`/`Set-Content` - Controls file read/write encoding
- `$OutputEncoding` - Controls encoding for piped output to native commands

**PowerShell versions:**
- Windows PowerShell 5.1: Defaults to OEM code page (legacy)
- PowerShell 7+: Defaults to UTF-8

**System-wide fix (Windows):** Enable "Beta: Use Unicode UTF-8 for worldwide language support" in Region settings. This affects all applications, so test thoroughly.

---

## References

- [CLAUDE.md](../../../CLAUDE.md) - Quick reference summaries
- [testing-strategy.md](testing-strategy.md) - Testing standards
- [security-policy.md](security-policy.md) - Security requirements
- [workflow-guide.md](workflow-guide.md) - Code review process

---

**Last Updated:** 2025-12-22
**Version:** 1.0.0
**Next Review:** After 10 projects use these standards
