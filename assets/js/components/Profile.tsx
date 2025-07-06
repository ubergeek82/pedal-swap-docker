import React from 'react';

const Profile: React.FC = () => {
  return (
    <div className="max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold text-gray-900 mb-8">Profile</h1>
      
      <div className="bg-white shadow-md rounded-lg p-6 mb-8">
        <h2 className="text-xl font-semibold mb-4">User Information</h2>
        <div className="grid md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-500">Email</label>
            <p className="text-gray-900">user@example.com</p>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-500">Username</label>
            <p className="text-gray-900">bike_rider</p>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-500">Location</label>
            <p className="text-gray-900">Portland, OR</p>
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-500">Preferred Size</label>
            <p className="text-gray-900">M</p>
          </div>
        </div>
      </div>

      <div className="grid md:grid-cols-2 gap-8">
        <div className="bg-white shadow-md rounded-lg p-6">
          <h2 className="text-xl font-semibold mb-4">My Bikes</h2>
          <p className="text-gray-600">You haven't listed any bikes yet.</p>
          <button className="mt-4 bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700 transition-colors">
            List a Bike
          </button>
        </div>

        <div className="bg-white shadow-md rounded-lg p-6">
          <h2 className="text-xl font-semibold mb-4">Trade History</h2>
          <p className="text-gray-600">No trades yet.</p>
          <button className="mt-4 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition-colors">
            Browse Bikes
          </button>
        </div>
      </div>
    </div>
  );
};

export default Profile;