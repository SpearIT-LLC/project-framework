/**
 * Tests for Hello World application
 */

const { greet } = require('../src/hello-world');

describe('Hello World', () => {
    test('greets World by default', () => {
        expect(greet()).toBe('Hello, World!');
    });

    test('greets custom name', () => {
        expect(greet('Alice')).toBe('Hello, Alice!');
    });

    test('greets Framework User', () => {
        expect(greet('Framework User')).toBe('Hello, Framework User!');
    });
});
