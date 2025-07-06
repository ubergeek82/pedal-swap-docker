import React, { useState, useEffect } from 'react';

interface Bike {
  id: number;
  title: string;
  brand: string;
  model: string;
  type: string;
  year: number;
  size: string;
  condition: string;
  price: string;
  description: string;
  components?: string;
  wheelset?: string;
  wheel_size?: string;
  tire_size?: string;
  images: string[];
}

const BrowseBikes: React.FC = () => {
  const [bikes, setBikes] = useState<Bike[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetch('/api/bikes')
      .then(response => {
        if (!response.ok) {
          throw new Error('Failed to fetch bikes');
        }
        return response.json();
      })
      .then(data => {
        setBikes(data.data || []);
        setLoading(false);
      })
      .catch(err => {
        setError(err.message);
        setLoading(false);
      });
  }, []);

  if (loading) {
    return (
      <div className="text-center py-12">
        <div className="text-gray-600">Loading bikes...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="text-center py-12">
        <div className="text-red-600">Error: {error}</div>
      </div>
    );
  }

  return (
    <div>
      <h1 className="text-3xl font-bold text-gray-900 mb-8">Browse Bikes</h1>
      
      {bikes.length === 0 ? (
        <div className="text-center py-12">
          <div className="text-gray-600">No bikes available for trading.</div>
        </div>
      ) : (
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {bikes.map((bike) => (
            <div key={bike.id} className="bg-white rounded-lg shadow-md overflow-hidden">
              <div className="h-48 bg-gray-200 flex items-center justify-center">
                {bike.images && bike.images.length > 0 ? (
                  <img 
                    src={`/images/${bike.images[0]}`} 
                    alt={bike.title}
                    className="h-full w-full object-cover"
                    onError={(e) => {
                      e.currentTarget.style.display = 'none';
                      e.currentTarget.nextElementSibling?.classList.remove('hidden');
                    }}
                  />
                ) : null}
                <div className="text-gray-400 text-sm">No Image</div>
              </div>
              
              <div className="p-6">
                <h3 className="text-xl font-semibold mb-2">{bike.title}</h3>
                <div className="text-gray-600 mb-2">
                  {bike.year} {bike.brand} {bike.model}
                </div>
                <div className="flex justify-between items-center mb-3">
                  <span className="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded">
                    {bike.type}
                  </span>
                  <span className="text-lg font-bold text-green-600">
                    ${bike.price}
                  </span>
                </div>
                <div className="text-sm text-gray-600 mb-3">
                  Size: {bike.size} | Condition: {bike.condition}
                </div>
                <p className="text-gray-700 text-sm line-clamp-3">
                  {bike.description}
                </p>
                <button className="mt-4 w-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 transition-colors">
                  View Details
                </button>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default BrowseBikes;