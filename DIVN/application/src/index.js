// index.js - Entry point for DIVN application

const home = require('./pages/Home/Home');

// Simulated React-like rendering (for now, without full React setup)
document.addEventListener('DOMContentLoaded', () => {
    const app = document.getElementById('app');
    app.innerHTML = home.render();

    // Bind methods to global scope for button onclick events
    window.home = home;
});

console.log("DIVN application initialized");
