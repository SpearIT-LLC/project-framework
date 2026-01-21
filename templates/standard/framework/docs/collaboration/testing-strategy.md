# Testing Strategy

**Audience:** All contributors (human and AI)
**Purpose:** Comprehensive testing guidance for all project levels
**Last Updated:** 2025-12-22

---

## Table of Contents

1. [Testing Philosophy](#testing-philosophy)
2. [Test-Driven Development (TDD)](#test-driven-development-tdd)
3. [Coverage Targets](#coverage-targets)
4. [Test Organization](#test-organization)
5. [Test Types](#test-types)
6. [Edge Case Testing](#edge-case-testing)
7. [Test Quality Standards](#test-quality-standards)
8. [Testing Best Practices](#testing-best-practices)
9. [Common Testing Patterns](#common-testing-patterns)

---

## Testing Philosophy

### Core Principles

**Tests Are Documentation:**
- Tests show how code should be used
- Tests capture expected behavior
- Tests document edge cases and limitations

**Tests Enable Confidence:**
- Tests allow refactoring without fear
- Tests catch regressions early
- Tests verify bug fixes stay fixed

**Tests Should Be Reliable:**
- Tests should pass/fail consistently
- Tests should not depend on external state
- Tests should not depend on execution order

### TDD Mindset

**For New Features:**
1. Write test for desired behavior (it should fail - "red")
2. Implement minimal code to make test pass ("green")
3. Refactor while keeping tests passing ("refactor")
4. Repeat for next requirement

**For Bug Fixes:**
1. Write test that reproduces the bug (should fail)
2. Fix the bug (test should pass)
3. Verify related functionality still works
4. Commit test + fix together

**Why TDD?**
- Forces clear requirements before coding
- Ensures testable design
- Provides immediate feedback
- Builds comprehensive test suite organically

---

## Test-Driven Development (TDD)

### The Red-Green-Refactor Cycle

```
[Write Failing Test]
        ↓
    (Red - test fails)
        ↓
[Write Minimal Code]
        ↓
    (Green - test passes)
        ↓
[Refactor Code]
        ↓
    (Tests still pass)
        ↓
[Repeat for next requirement]
```

### Example: TDD for calculateTotal Function

**Step 1: Write Failing Test (Red)**
```javascript
describe('calculateTotal', () => {
  test('should sum array of numbers', () => {
    expect(calculateTotal([1, 2, 3])).toBe(6);
  });
});

// Run test → FAILS (function doesn't exist yet)
```

**Step 2: Write Minimal Code (Green)**
```javascript
function calculateTotal(numbers) {
  return numbers.reduce((sum, n) => sum + n, 0);
}

// Run test → PASSES
```

**Step 3: Add Edge Case Test (Red)**
```javascript
test('should return 0 for empty array', () => {
  expect(calculateTotal([])).toBe(0);
});

// Run test → PASSES (reduce with initial value 0 handles this!)
```

**Step 4: Add Validation Test (Red)**
```javascript
test('should throw for invalid input', () => {
  expect(() => calculateTotal(null)).toThrow();
});

// Run test → FAILS (doesn't validate input)
```

**Step 5: Add Validation (Green)**
```javascript
function calculateTotal(numbers) {
  if (!Array.isArray(numbers)) {
    throw new TypeError('Expected array of numbers');
  }
  return numbers.reduce((sum, n) => sum + n, 0);
}

// Run test → PASSES
```

**Step 6: Refactor (if needed)**
```javascript
// Code is clean, no refactoring needed
// Tests still pass
```

### When NOT to Use TDD

**Skip TDD for:**
- Exploratory prototyping (spike solutions)
- Throwaway scripts (Minimal framework level)
- UI layout/styling experiments
- Initial research phase

**But:** Convert to TDD once you decide to keep the code!

---

## Coverage Targets

### By Component Type

**Critical Business Logic:** 90-100%
- Core algorithms
- Data transformations
- Business rule validation
- Financial calculations

**Service Layer:** 80-90%
- API handlers
- Database operations
- External integrations
- State management

**UI Components:** 60-80%
- User interactions
- Conditional rendering
- Props handling
- Event handlers

**Utilities:** 90-100%
- Pure functions
- Data formatting
- Validation helpers

**Configuration:** 0-20%
- Static config files
- Environment variables
- Build configurations

### Coverage Quality vs Quantity

**100% coverage doesn't mean perfect tests:**

```javascript
// Bad: 100% coverage, no value
function add(a, b) {
  return a + b;
}

test('add exists', () => {
  expect(add).toBeDefined(); // ✓ Covers function, tests nothing
});
```

```javascript
// Good: Tests actual behavior
test('add returns sum of two numbers', () => {
  expect(add(2, 3)).toBe(5);
  expect(add(-1, 1)).toBe(0);
  expect(add(0, 0)).toBe(0);
});
```

**Focus on:**
- Testing behavior, not implementation
- Testing edge cases, not just happy path
- Testing error conditions
- Testing integration points

---

## Test Organization

### File Structure

**Option 1: Co-located Tests (Recommended for Components)**
```
src/
├── components/
│   ├── Button/
│   │   ├── Button.tsx
│   │   ├── Button.test.tsx
│   │   └── Button.module.css
│   └── Header/
│       ├── Header.tsx
│       └── Header.test.tsx
```

**Option 2: Separate Test Directory (Recommended for Integration)**
```
src/
├── services/
│   ├── api.ts
│   └── database.ts
└── __tests__/
    ├── integration/
    │   ├── api.test.ts
    │   └── database.test.ts
    └── e2e/
        └── user-flow.test.ts
```

### Test File Naming

**Convention:**
- `ComponentName.test.ts` - Unit tests
- `feature-name.integration.test.ts` - Integration tests
- `workflow.e2e.test.ts` - End-to-end tests

**Why:** Clear distinction between test types, easy to run subsets

---

## Test Types

### Unit Tests

**Purpose:** Test individual functions/components in isolation

**Characteristics:**
- Fast (milliseconds)
- No external dependencies
- Mock all I/O (network, database, filesystem)
- Single responsibility focus

**Example:**
```javascript
// Unit test - tests validateEmail in isolation
describe('validateEmail', () => {
  test('should accept valid email', () => {
    expect(validateEmail('user@example.com')).toBe(true);
  });

  test('should reject email without @', () => {
    expect(validateEmail('userexample.com')).toBe(false);
  });

  test('should reject empty string', () => {
    expect(validateEmail('')).toBe(false);
  });

  test('should reject null', () => {
    expect(validateEmail(null)).toBe(false);
  });
});
```

### Integration Tests

**Purpose:** Test multiple components working together

**Characteristics:**
- Slower (seconds)
- May use test database
- Tests component interaction
- Verifies data flow

**Example:**
```javascript
// Integration test - tests UserService with Database
describe('UserService Integration', () => {
  let testDb;
  let userService;

  beforeEach(async () => {
    testDb = await createTestDatabase();
    userService = new UserService(testDb);
  });

  afterEach(async () => {
    await testDb.cleanup();
  });

  test('should create user and retrieve by email', async () => {
    // Create user
    const userId = await userService.createUser({
      email: 'test@example.com',
      name: 'Test User'
    });

    // Retrieve user
    const user = await userService.findByEmail('test@example.com');

    // Verify
    expect(user.id).toBe(userId);
    expect(user.name).toBe('Test User');
  });
});
```

### End-to-End (E2E) Tests

**Purpose:** Test complete user workflows through UI

**Characteristics:**
- Slowest (minutes)
- Uses real browser
- Tests entire system
- Simulates user behavior

**Example:**
```javascript
// E2E test - tests complete user registration flow
describe('User Registration Flow', () => {
  test('should register new user and login', async () => {
    // Navigate to registration
    await page.goto('http://localhost:3000/register');

    // Fill form
    await page.fill('[name="email"]', 'newuser@example.com');
    await page.fill('[name="password"]', 'SecurePass123!');
    await page.fill('[name="confirmPassword"]', 'SecurePass123!');

    // Submit
    await page.click('button[type="submit"]');

    // Verify redirect to dashboard
    await page.waitForURL('**/dashboard');

    // Verify welcome message
    const welcome = await page.textContent('.welcome-message');
    expect(welcome).toContain('Welcome, newuser@example.com');
  });
});
```

### Test Pyramid Strategy

```
        /\
       /  \  E2E Tests (Few - Slow, Brittle)
      /    \
     /------\ Integration Tests (Some - Medium Speed)
    /        \
   /----------\ Unit Tests (Many - Fast, Reliable)
  /____________\
```

**Recommended Distribution:**
- 70% Unit Tests
- 20% Integration Tests
- 10% E2E Tests

---

## Edge Case Testing

### Core Categories

**1. Empty or Null Inputs**
```javascript
test('handles empty array', () => {
  expect(calculateTotal([])).toBe(0);
});

test('handles null input', () => {
  expect(() => processUser(null)).toThrow('User cannot be null');
});

test('handles undefined input', () => {
  expect(() => formatName(undefined)).toThrow('Name is required');
});

test('handles empty string', () => {
  expect(validateUsername('')).toBe(false);
});
```

**2. Boundary Values (Max/Min)**
```javascript
test('handles maximum safe integer', () => {
  expect(incrementCounter(Number.MAX_SAFE_INTEGER)).toThrow('Counter overflow');
});

test('handles minimum safe integer', () => {
  expect(decrementCounter(Number.MIN_SAFE_INTEGER)).toThrow('Counter underflow');
});

test('handles very long text', () => {
  const longText = 'a'.repeat(10000);
  expect(truncateText(longText, 100)).toHaveLength(100);
});

test('handles single character', () => {
  expect(capitalize('a')).toBe('A');
});
```

**3. Invalid States**
```javascript
test('rejects end date before start date', () => {
  const start = new Date('2025-12-31');
  const end = new Date('2025-01-01');
  expect(() => createDateRange(start, end)).toThrow('End date must be after start date');
});

test('rejects negative quantity', () => {
  expect(() => createOrder({ quantity: -5 })).toThrow('Quantity must be positive');
});

test('rejects duplicate usernames', async () => {
  await createUser({ username: 'john' });
  await expect(createUser({ username: 'john' }))
    .rejects.toThrow('Username already exists');
});
```

**4. Concurrency Issues**
```javascript
test('handles concurrent updates to same resource', async () => {
  const counter = new Counter();

  // Simulate 100 concurrent increments
  const promises = Array(100).fill(null).map(() => counter.increment());
  await Promise.all(promises);

  // Should be exactly 100, not less due to race condition
  expect(counter.value).toBe(100);
});

test('prevents double-submit on form', async () => {
  const form = renderForm();

  // Submit twice rapidly
  const submit1 = form.submit();
  const submit2 = form.submit();

  await Promise.all([submit1, submit2]);

  // Should only create one record
  const records = await db.getAllRecords();
  expect(records).toHaveLength(1);
});
```

### Fail Fast Principle

**Good (Fail Fast):**
```javascript
function divide(a, b) {
  // Validate at entry
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new TypeError('Both arguments must be numbers');
  }
  if (b === 0) {
    throw new Error('Division by zero');
  }

  return a / b;
}

test('divide fails fast on invalid input', () => {
  expect(() => divide('5', 2)).toThrow(TypeError);
  expect(() => divide(10, 0)).toThrow('Division by zero');
});
```

**Bad (Fail Late):**
```javascript
function divide(a, b) {
  const result = a / b;

  // Validation after processing
  if (isNaN(result) || !isFinite(result)) {
    throw new Error('Invalid result');
  }

  return result;
}

// Why bad:
// - divide('5', 2) returns 2.5 (coerced '5' to 5)
// - divide(10, 0) returns Infinity (not caught)
// - Error doesn't explain what was wrong
```

### Edge Case Checklist

When implementing any function, ask:
- [ ] What if input is null/undefined?
- [ ] What if input is empty ([], '', {}, 0)?
- [ ] What if input is at max/min boundary?
- [ ] What if input is wrong type?
- [ ] What if input contains special characters?
- [ ] What if operation fails partway through?
- [ ] What if called multiple times concurrently?
- [ ] What if dependencies are unavailable?

**If edge case identified:**
- Handle in code (validation, error handling)
- OR flag with comment/TODO if acceptable to defer

**Prefer:** Fail fast on bad input rather than proceeding with wrong assumptions

---

## Test Quality Standards

### Good Tests Are FIRST

**Fast:**
- Run quickly (milliseconds for unit tests)
- Enable rapid feedback
- Don't wait for network/database in unit tests

**Independent:**
- Don't depend on other tests
- Can run in any order
- Don't share state

**Repeatable:**
- Same input → same output every time
- No dependency on current time/date
- No dependency on random values

**Self-Validating:**
- Clear pass/fail (no manual verification)
- Explicit assertions
- Meaningful error messages

**Timely:**
- Written at same time as code (TDD)
- Don't defer test writing
- Update tests when behavior changes

### Test Naming Convention

**Pattern:** `should [expected behavior] when [condition]`

**Good Examples:**
```javascript
test('should return user when email exists', () => { ... });
test('should throw error when email is invalid', () => { ... });
test('should format phone number with dashes', () => { ... });
test('should disable submit button when form is invalid', () => { ... });
```

**Bad Examples:**
```javascript
test('test1', () => { ... }); // ❌ No description
test('it works', () => { ... }); // ❌ Not specific
test('getUser', () => { ... }); // ❌ Describes implementation, not behavior
test('should do the right thing', () => { ... }); // ❌ Vague
```

### Assertion Quality

**One Logical Concept Per Test:**

```javascript
// Bad: Testing multiple unrelated things
test('user service', () => {
  expect(service.createUser()).toBeDefined();
  expect(service.deleteUser()).toBe(true);
  expect(service.listUsers()).toHaveLength(0);
});

// Good: Separate tests for each concept
test('should create user and return user object', () => {
  const user = service.createUser({ email: 'test@example.com' });
  expect(user).toBeDefined();
  expect(user.email).toBe('test@example.com');
});

test('should delete existing user', () => {
  const userId = service.createUser({ email: 'test@example.com' }).id;
  const result = service.deleteUser(userId);
  expect(result).toBe(true);
});
```

**Specific Assertions:**

```javascript
// Bad: Generic assertion
expect(result).toBeTruthy();

// Good: Specific assertion
expect(result.success).toBe(true);
expect(result.userId).toBeGreaterThan(0);

// Bad: Loose assertion
expect(user).toBeDefined();

// Good: Specific shape
expect(user).toEqual({
  id: expect.any(Number),
  email: 'test@example.com',
  createdAt: expect.any(Date)
});
```

---

## Testing Best Practices

### Arrange-Act-Assert Pattern (AAA)

```javascript
test('should calculate discount for premium members', () => {
  // Arrange: Set up test data and dependencies
  const member = {
    type: 'premium',
    yearsActive: 5
  };
  const cart = {
    items: [
      { price: 100 },
      { price: 50 }
    ]
  };

  // Act: Execute the function being tested
  const discount = calculateDiscount(member, cart);

  // Assert: Verify the result
  expect(discount).toBe(22.5); // 15% for premium + 7.5% for loyalty
});
```

### Mocking Dependencies

**When to Mock:**
- External APIs
- Database calls
- File system operations
- Current time/date
- Random number generation

**Example:**
```javascript
// Function being tested
async function getUserProfile(userId) {
  const user = await database.findUser(userId);
  const posts = await api.getUserPosts(userId);
  return {
    ...user,
    postCount: posts.length
  };
}

// Test with mocks
test('should combine user data with post count', async () => {
  // Arrange: Mock dependencies
  const mockDatabase = {
    findUser: jest.fn().mockResolvedValue({
      id: 1,
      name: 'John Doe'
    })
  };

  const mockApi = {
    getUserPosts: jest.fn().mockResolvedValue([
      { id: 1, title: 'Post 1' },
      { id: 2, title: 'Post 2' }
    ])
  };

  // Act: Call function with mocked dependencies
  const profile = await getUserProfile(1);

  // Assert: Verify behavior
  expect(profile).toEqual({
    id: 1,
    name: 'John Doe',
    postCount: 2
  });

  // Verify mocks were called correctly
  expect(mockDatabase.findUser).toHaveBeenCalledWith(1);
  expect(mockApi.getUserPosts).toHaveBeenCalledWith(1);
});
```

### Test Data Management

**Use Test Fixtures:**
```javascript
// fixtures/users.js
export const validUser = {
  email: 'valid@example.com',
  password: 'SecurePass123!',
  name: 'Test User'
};

export const invalidUsers = {
  noEmail: { password: 'SecurePass123!', name: 'Test User' },
  invalidEmail: { email: 'not-an-email', password: 'SecurePass123!', name: 'Test User' },
  shortPassword: { email: 'valid@example.com', password: '123', name: 'Test User' }
};

// In test
import { validUser, invalidUsers } from './fixtures/users';

test('should create user with valid data', () => {
  expect(() => createUser(validUser)).not.toThrow();
});

test('should reject user without email', () => {
  expect(() => createUser(invalidUsers.noEmail)).toThrow('Email required');
});
```

**Factory Functions:**
```javascript
// Factory for creating test users
function createTestUser(overrides = {}) {
  return {
    id: Math.random(),
    email: 'test@example.com',
    name: 'Test User',
    createdAt: new Date(),
    ...overrides
  };
}

// Usage
test('should update user email', () => {
  const user = createTestUser({ email: 'old@example.com' });
  updateEmail(user, 'new@example.com');
  expect(user.email).toBe('new@example.com');
});
```

### Setup and Teardown

```javascript
describe('UserService', () => {
  let database;
  let userService;

  // Runs before ALL tests in this describe block
  beforeAll(async () => {
    database = await createTestDatabase();
  });

  // Runs before EACH test
  beforeEach(() => {
    userService = new UserService(database);
  });

  // Runs after EACH test
  afterEach(async () => {
    await database.clearAllTables();
  });

  // Runs after ALL tests in this describe block
  afterAll(async () => {
    await database.disconnect();
  });

  test('should create user', async () => {
    // Test runs with fresh database and userService
    const user = await userService.createUser({ email: 'test@example.com' });
    expect(user.id).toBeDefined();
  });
});
```

---

## Common Testing Patterns

### Testing Async Code

```javascript
// Testing promises
test('should fetch user data', async () => {
  const user = await fetchUser(1);
  expect(user.name).toBe('John Doe');
});

// Testing promise rejection
test('should throw error for invalid user ID', async () => {
  await expect(fetchUser(-1)).rejects.toThrow('Invalid user ID');
});

// Testing callbacks
test('should call callback with result', (done) => {
  processData((error, result) => {
    expect(error).toBeNull();
    expect(result).toBe('success');
    done();
  });
});
```

### Testing Error Handling

```javascript
test('should throw specific error type', () => {
  expect(() => {
    validateAge(-5);
  }).toThrow(ValidationError);
});

test('should throw error with specific message', () => {
  expect(() => {
    validateAge(-5);
  }).toThrow('Age must be positive');
});

test('should throw error matching pattern', () => {
  expect(() => {
    validateAge(-5);
  }).toThrow(/Age must be/);
});
```

### Testing Side Effects

```javascript
test('should log error when validation fails', () => {
  const consoleSpy = jest.spyOn(console, 'error').mockImplementation();

  validateUser({ email: 'invalid' });

  expect(consoleSpy).toHaveBeenCalledWith(
    expect.stringContaining('Invalid email')
  );

  consoleSpy.mockRestore();
});

test('should call analytics when user created', () => {
  const analyticsSpy = jest.spyOn(analytics, 'track');

  createUser({ email: 'test@example.com' });

  expect(analyticsSpy).toHaveBeenCalledWith('user_created', {
    email: 'test@example.com'
  });
});
```

### Parameterized Tests

```javascript
// Test same logic with different inputs
describe('validateEmail', () => {
  const validEmails = [
    'user@example.com',
    'user.name@example.com',
    'user+tag@example.co.uk',
    'user123@example-domain.com'
  ];

  test.each(validEmails)('should accept valid email: %s', (email) => {
    expect(validateEmail(email)).toBe(true);
  });

  const invalidEmails = [
    ['no-at-sign.com', 'missing @ symbol'],
    ['@example.com', 'missing local part'],
    ['user@', 'missing domain'],
    ['user @example.com', 'contains space'],
    ['', 'empty string']
  ];

  test.each(invalidEmails)('should reject invalid email: %s (%s)', (email, reason) => {
    expect(validateEmail(email)).toBe(false);
  });
});
```

---

## Framework-Specific Guidance

### Minimal Framework
- Focus on critical paths only
- Manual testing acceptable for edge cases
- Document test approach in README

### Light Framework
- Unit tests for core functions
- Basic edge case coverage
- Integration tests for critical flows

### Standard Framework
- Comprehensive unit test coverage (80%+)
- Integration tests for all major features
- Documented edge case strategy
- CI/CD integration

### Standard Framework (optional features)
- 90%+ coverage with quality gates
- Full E2E test suite
- Performance/load testing
- Security testing
- Mutation testing

---

**Related Documentation:**
- [Code Quality Standards](code-quality-standards.md) - Error handling patterns
- [Workflow Guide](workflow-guide.md) - Development workflow phases

---

**Last Updated:** 2025-12-22
**Maintained By:** Framework Team
