/**
 * Hello World - Simple demonstration application
 * Part of the Standard Project Framework
 */

function greet(name = 'World') {
    return `Hello, ${name}!`;
}

function main() {
    console.log(greet());
    console.log(greet('Framework User'));
}

// Run if executed directly
if (require.main === module) {
    main();
}

module.exports = { greet };
