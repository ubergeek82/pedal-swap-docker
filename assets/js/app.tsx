import React from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import App from './components/App';

const container = document.getElementById('react-app');
if (container) {
  const root = createRoot(container);
  root.render(
    <Router>
      <App />
    </Router>
  );
} else {
  console.error('React container element not found');
}

console.log("Phoenix React app loaded");