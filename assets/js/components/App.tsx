import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Home from './Home';
import BrowseBikes from './BrowseBikes';
import ListBike from './ListBike';
import Profile from './Profile';
import Navigation from './Navigation';

const App: React.FC = () => {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navigation />
      <main className="container mx-auto px-4 py-8">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/browse" element={<BrowseBikes />} />
          <Route path="/list" element={<ListBike />} />
          <Route path="/profile" element={<Profile />} />
        </Routes>
      </main>
    </div>
  );
};

export default App;