import React from 'react';
import { Link } from 'react-router-dom';

const Home: React.FC = () => {
  return (
    <div className="text-center">
      <div className="max-w-4xl mx-auto">
        <h1 className="text-5xl font-bold text-gray-900 mb-6">
          Welcome to PedalSwap
        </h1>
        <p className="text-xl text-gray-600 mb-8">
          The Pacific Northwest's premier bike trading platform. Find your next ride or 
          trade the bike you've outgrown.
        </p>
        
        <div className="grid md:grid-cols-2 gap-8 mt-12">
          <div className="bg-white p-8 rounded-lg shadow-md">
            <h3 className="text-2xl font-semibold mb-4">Browse Bikes</h3>
            <p className="text-gray-600 mb-6">
              Discover amazing bikes from fellow cyclists across the PNW. 
              From mountain bikes to road bikes, find your perfect match.
            </p>
            <Link
              to="/browse"
              className="inline-block bg-blue-600 text-white px-6 py-3 rounded-lg hover:bg-blue-700 transition-colors"
            >
              Start Browsing
            </Link>
          </div>
          
          <div className="bg-white p-8 rounded-lg shadow-md">
            <h3 className="text-2xl font-semibold mb-4">List Your Bike</h3>
            <p className="text-gray-600 mb-6">
              Ready to trade? List your bike and connect with other cycling enthusiasts 
              looking for their next adventure.
            </p>
            <Link
              to="/list"
              className="inline-block bg-green-600 text-white px-6 py-3 rounded-lg hover:bg-green-700 transition-colors"
            >
              List Your Bike
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Home;