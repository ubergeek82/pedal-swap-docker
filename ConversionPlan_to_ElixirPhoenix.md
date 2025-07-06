# Detailed Phoenix/Elixir Conversion Plan

Based on comprehensive analysis of the current React/TypeScript codebase, here's the exact step-by-step process for converting the Pedal Swap PNW bike trading website to Phoenix/Elixir.

## Phase 1: Foundation Setup (Week 1)

### Day 1: Project Initialization
```bash
# 1. Create new Phoenix project
mix phx.new pedal_swap_pnw --live --database postgres

# 2. Setup version control
cd pedal_swap_pnw
git init
git add .
git commit -m "Initial Phoenix project"

# 3. Configure database
mix ecto.create
mix ecto.migrate
```

### Day 2: Database Schema Design
```elixir
# Create migrations and schemas
mix phx.gen.schema User users \
  name:string \
  email:string:unique \
  location:string \
  bio:text \
  interests:array:string \
  avatar_url:string \
  inserted_at:naive_datetime \
  updated_at:naive_datetime

mix phx.gen.schema Bike bikes \
  title:string \
  description:text \
  type:string \
  condition:string \
  price:decimal \
  location:string \
  photos:array:string \
  user_id:references:users \
  size:string \
  brand:string \
  model:string \
  year:integer \
  is_available:boolean \
  inserted_at:naive_datetime \
  updated_at:naive_datetime
```

### Day 3: Authentication System
```bash
# Install and configure authentication
mix phx.gen.auth Users User users --live

# Configure email settings
# Update config/dev.exs and config/prod.exs
```

### Day 4: Basic Project Structure
```elixir
# Create core LiveView modules
mkdir -p lib/pedal_swap_pnw_web/live
touch lib/pedal_swap_pnw_web/live/index_live.ex
touch lib/pedal_swap_pnw_web/live/catalog_live.ex
touch lib/pedal_swap_pnw_web/live/list_bike_live.ex
touch lib/pedal_swap_pnw_web/live/profile_live.ex

# Create component modules
mkdir -p lib/pedal_swap_pnw_web/components
touch lib/pedal_swap_pnw_web/components/navbar.ex
touch lib/pedal_swap_pnw_web/components/bike_card.ex
touch lib/pedal_swap_pnw_web/components/ui.ex
```

### Day 5: Tailwind CSS Setup
```bash
# Install and configure Tailwind
# Copy existing tailwind.config.js
# Copy existing CSS custom properties
# Update assets/css/app.css with design system
```

## Phase 2: Core Components (Week 2)

### Day 6-7: UI Component Library
```elixir
# Create Phoenix component equivalents
# lib/pedal_swap_pnw_web/components/ui.ex

defmodule PedalSwapPnwWeb.Components.UI do
  use Phoenix.Component
  
  # Button component (from Shadcn/ui Button)
  def button(assigns) do
    ~H"""
    <button class={[
      "inline-flex items-center justify-center rounded-md text-sm font-medium",
      "ring-offset-background transition-colors focus-visible:outline-none",
      "focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
      "disabled:pointer-events-none disabled:opacity-50",
      variant_class(@variant),
      size_class(@size),
      @class
    ]} {@rest}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end
  
  # Card component (from Shadcn/ui Card)
  def card(assigns) do
    ~H"""
    <div class={[
      "rounded-lg border bg-card text-card-foreground shadow-sm",
      @class
    ]} {@rest}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
  
  # Input component (from Shadcn/ui Input)
  def input(assigns) do
    ~H"""
    <input class={[
      "flex h-10 w-full rounded-md border border-input bg-background px-3 py-2",
      "text-sm ring-offset-background file:border-0 file:bg-transparent",
      "file:text-sm file:font-medium placeholder:text-muted-foreground",
      "focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring",
      "focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
      @class
    ]} {@rest} />
    """
  end
  
  # Continue with all other required components...
  # Select, Textarea, Badge, Avatar, etc.
end
```

### Day 8: Navigation Component
```elixir
# lib/pedal_swap_pnw_web/components/navbar.ex

defmodule PedalSwapPnwWeb.Components.Navbar do
  use Phoenix.Component
  import PedalSwapPnwWeb.Components.UI
  
  def navbar(assigns) do
    ~H"""
    <nav class="bg-white border-b border-gray-200">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex items-center">
            <.link navigate="/" class="flex items-center space-x-2">
              <svg class="h-8 w-8 text-green-600" fill="currentColor" viewBox="0 0 24 24">
                <!-- Mountain icon -->
              </svg>
              <span class="text-xl font-bold text-gray-900">Pedal Swap PNW</span>
            </.link>
          </div>
          
          <div class="hidden md:flex items-center space-x-8">
            <.link navigate="/catalog" class={nav_link_class(@current_page, "catalog")}>
              Browse Bikes
            </.link>
            <.link navigate="/list-bike" class={nav_link_class(@current_page, "list-bike")}>
              List a Bike
            </.link>
            <.link navigate="/profile" class={nav_link_class(@current_page, "profile")}>
              Profile
            </.link>
          </div>
          
          <!-- Mobile menu button -->
          <div class="md:hidden">
            <button phx-click="toggle_mobile_menu" class="text-gray-600 hover:text-gray-900">
              <svg class="h-6 w-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
              </svg>
            </button>
          </div>
        </div>
      </div>
      
      <!-- Mobile menu -->
      <div :if={@mobile_menu_open} class="md:hidden">
        <div class="px-2 pt-2 pb-3 space-y-1 sm:px-3">
          <.link navigate="/catalog" class="block px-3 py-2 text-base font-medium text-gray-700 hover:text-gray-900">
            Browse Bikes
          </.link>
          <!-- More mobile links -->
        </div>
      </div>
    </nav>
    """
  end
  
  defp nav_link_class(current_page, page) do
    base_class = "text-sm font-medium transition-colors hover:text-green-600"
    if current_page == page do
      base_class <> " text-green-600"
    else
      base_class <> " text-gray-700"
    end
  end
end
```

## Phase 3: Page Implementation (Week 2-3)

### Day 9: Index Page (Landing)
```elixir
# lib/pedal_swap_pnw_web/live/index_live.ex

defmodule PedalSwapPnwWeb.IndexLive do
  use PedalSwapPnwWeb, :live_view
  import PedalSwapPnwWeb.Components.UI
  import PedalSwapPnwWeb.Components.Navbar
  
  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_page: "home", mobile_menu_open: false)}
  end
  
  def handle_event("toggle_mobile_menu", _params, socket) do
    {:noreply, assign(socket, mobile_menu_open: not socket.assigns.mobile_menu_open)}
  end
  
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-green-50 to-blue-50">
      <.navbar current_page={@current_page} mobile_menu_open={@mobile_menu_open} />
      
      <!-- Hero Section -->
      <div class="relative overflow-hidden">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
          <div class="text-center">
            <h1 class="text-4xl tracking-tight font-extrabold text-gray-900 sm:text-6xl">
              <span class="block">Sustainable Cycling</span>
              <span class="block text-green-600">Community</span>
            </h1>
            <p class="mt-6 max-w-lg mx-auto text-xl text-gray-500">
              Trade bicycles with fellow Pacific Northwest cyclists. 
              Find your perfect ride while keeping bikes in motion.
            </p>
            <div class="mt-10 flex justify-center space-x-4">
              <.button class="bg-green-600 hover:bg-green-700 text-white px-8 py-3 text-lg">
                <.link navigate="/catalog">Browse Bikes</.link>
              </.button>
              <.button variant="outline" class="px-8 py-3 text-lg">
                <.link navigate="/list-bike">List Your Bike</.link>
              </.button>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Features Section -->
      <div class="py-16 bg-white">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            <div class="text-center">
              <div class="flex justify-center mb-4">
                <svg class="h-12 w-12 text-green-600" fill="currentColor" viewBox="0 0 24 24">
                  <!-- Mountain icon -->
                </svg>
              </div>
              <h3 class="text-lg font-semibold text-gray-900">Local Community</h3>
              <p class="mt-2 text-gray-600">Connect with cyclists in the Pacific Northwest</p>
            </div>
            
            <div class="text-center">
              <div class="flex justify-center mb-4">
                <svg class="h-12 w-12 text-green-600" fill="currentColor" viewBox="0 0 24 24">
                  <!-- Bike icon -->
                </svg>
              </div>
              <h3 class="text-lg font-semibold text-gray-900">Quality Bikes</h3>
              <p class="mt-2 text-gray-600">Find well-maintained bicycles from trusted sellers</p>
            </div>
            
            <div class="text-center">
              <div class="flex justify-center mb-4">
                <svg class="h-12 w-12 text-green-600" fill="currentColor" viewBox="0 0 24 24">
                  <!-- Search icon -->
                </svg>
              </div>
              <h3 class="text-lg font-semibold text-gray-900">Easy Discovery</h3>
              <p class="mt-2 text-gray-600">Search and filter to find exactly what you need</p>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
```

### Day 10-11: Catalog Page (Most Complex)
```elixir
# lib/pedal_swap_pnw_web/live/catalog_live.ex

defmodule PedalSwapPnwWeb.CatalogLive do
  use PedalSwapPnwWeb, :live_view
  import PedalSwapPnwWeb.Components.UI
  import PedalSwapPnwWeb.Components.Navbar
  alias PedalSwapPnw.Bikes
  
  def mount(_params, _session, socket) do
    bikes = Bikes.list_available_bikes()
    
    socket =
      socket
      |> assign(
        current_page: "catalog",
        mobile_menu_open: false,
        search_term: "",
        filter_type: "all",
        filter_condition: "all",
        filter_location: "all",
        bikes: bikes,
        filtered_bikes: bikes
      )
    
    {:ok, socket}
  end
  
  def handle_event("search", %{"search" => search_term}, socket) do
    socket = assign(socket, search_term: search_term)
    {:noreply, apply_filters(socket)}
  end
  
  def handle_event("filter", %{"filter" => %{"type" => type, "condition" => condition, "location" => location}}, socket) do
    socket =
      socket
      |> assign(filter_type: type, filter_condition: condition, filter_location: location)
    
    {:noreply, apply_filters(socket)}
  end
  
  def handle_event("clear_filters", _params, socket) do
    socket =
      socket
      |> assign(
        search_term: "",
        filter_type: "all",
        filter_condition: "all",
        filter_location: "all"
      )
    
    {:noreply, apply_filters(socket)}
  end
  
  defp apply_filters(socket) do
    %{
      bikes: bikes,
      search_term: search_term,
      filter_type: filter_type,
      filter_condition: filter_condition,
      filter_location: filter_location
    } = socket.assigns
    
    filtered_bikes =
      bikes
      |> filter_by_search(search_term)
      |> filter_by_type(filter_type)
      |> filter_by_condition(filter_condition)
      |> filter_by_location(filter_location)
    
    assign(socket, filtered_bikes: filtered_bikes)
  end
  
  defp filter_by_search(bikes, ""), do: bikes
  defp filter_by_search(bikes, search_term) do
    search_term = String.downcase(search_term)
    Enum.filter(bikes, fn bike ->
      String.contains?(String.downcase(bike.title), search_term) or
      String.contains?(String.downcase(bike.description), search_term) or
      String.contains?(String.downcase(bike.brand || ""), search_term)
    end)
  end
  
  defp filter_by_type(bikes, "all"), do: bikes
  defp filter_by_type(bikes, type), do: Enum.filter(bikes, &(&1.type == type))
  
  defp filter_by_condition(bikes, "all"), do: bikes
  defp filter_by_condition(bikes, condition), do: Enum.filter(bikes, &(&1.condition == condition))
  
  defp filter_by_location(bikes, "all"), do: bikes
  defp filter_by_location(bikes, location), do: Enum.filter(bikes, &(&1.location == location))
  
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">
      <.navbar current_page={@current_page} mobile_menu_open={@mobile_menu_open} />
      
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="mb-8">
          <h1 class="text-3xl font-bold text-gray-900">Browse Bikes</h1>
          <p class="mt-2 text-gray-600">Find your perfect ride from our community of cyclists</p>
        </div>
        
        <!-- Search and Filters -->
        <div class="mb-8 space-y-4">
          <!-- Search Bar -->
          <div class="relative">
            <.input
              type="text"
              placeholder="Search bikes..."
              value={@search_term}
              phx-change="search"
              name="search"
              class="pl-10"
            />
            <svg class="absolute left-3 top-3 h-4 w-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
            </svg>
          </div>
          
          <!-- Filters -->
          <form phx-change="filter" class="flex flex-wrap gap-4">
            <select name="filter[type]" class="border rounded-md px-3 py-2">
              <option value="all">All Types</option>
              <option value="Road" selected={@filter_type == "Road"}>Road</option>
              <option value="Mountain" selected={@filter_type == "Mountain"}>Mountain</option>
              <option value="Hybrid" selected={@filter_type == "Hybrid"}>Hybrid</option>
              <option value="Electric" selected={@filter_type == "Electric"}>Electric</option>
            </select>
            
            <select name="filter[condition]" class="border rounded-md px-3 py-2">
              <option value="all">All Conditions</option>
              <option value="Excellent" selected={@filter_condition == "Excellent"}>Excellent</option>
              <option value="Good" selected={@filter_condition == "Good"}>Good</option>
              <option value="Fair" selected={@filter_condition == "Fair"}>Fair</option>
            </select>
            
            <select name="filter[location]" class="border rounded-md px-3 py-2">
              <option value="all">All Locations</option>
              <option value="Seattle" selected={@filter_location == "Seattle"}>Seattle</option>
              <option value="Portland" selected={@filter_location == "Portland"}>Portland</option>
              <option value="Bellingham" selected={@filter_location == "Bellingham"}>Bellingham</option>
            </select>
            
            <.button type="button" phx-click="clear_filters" variant="outline">
              Clear Filters
            </.button>
          </form>
        </div>
        
        <!-- Results Count -->
        <div class="mb-4">
          <p class="text-sm text-gray-600">
            Showing <%= length(@filtered_bikes) %> of <%= length(@bikes) %> bikes
          </p>
        </div>
        
        <!-- Bike Grid -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <%= for bike <- @filtered_bikes do %>
            <.card class="overflow-hidden hover:shadow-lg transition-shadow">
              <div class="aspect-w-16 aspect-h-9">
                <img src={bike.photos |> List.first() || "/images/placeholder-bike.jpg"} 
                     alt={bike.title} 
                     class="w-full h-48 object-cover" />
              </div>
              <div class="p-4">
                <h3 class="font-semibold text-lg text-gray-900"><%= bike.title %></h3>
                <p class="text-green-600 font-bold text-xl">$<%= bike.price %></p>
                <p class="text-gray-600 text-sm mt-1"><%= bike.location %></p>
                <div class="mt-2 flex items-center space-x-2">
                  <.badge variant="secondary"><%= bike.type %></.badge>
                  <.badge variant="outline"><%= bike.condition %></.badge>
                </div>
                <p class="text-gray-700 text-sm mt-2 line-clamp-2"><%= bike.description %></p>
                <.button class="w-full mt-4">
                  View Details
                </.button>
              </div>
            </.card>
          <% end %>
        </div>
        
        <!-- Empty State -->
        <div :if={length(@filtered_bikes) == 0} class="text-center py-12">
          <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.172 16.172a4 4 0 015.656 0M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
          </svg>
          <h3 class="mt-2 text-sm font-medium text-gray-900">No bikes found</h3>
          <p class="mt-1 text-sm text-gray-500">Try adjusting your search or filters</p>
          <.button phx-click="clear_filters" class="mt-4">
            Clear all filters
          </.button>
        </div>
      </div>
    </div>
    """
  end
end
```

### Day 12-13: List Bike Form (Complex Form)
```elixir
# lib/pedal_swap_pnw_web/live/list_bike_live.ex

defmodule PedalSwapPnwWeb.ListBikeLive do
  use PedalSwapPnwWeb, :live_view
  import PedalSwapPnwWeb.Components.UI
  import PedalSwapPnwWeb.Components.Navbar
  alias PedalSwapPnw.Bikes
  alias PedalSwapPnw.Bikes.Bike
  
  def mount(_params, _session, socket) do
    changeset = Bikes.change_bike(%Bike{})
    
    socket =
      socket
      |> assign(
        current_page: "list-bike",
        mobile_menu_open: false,
        changeset: changeset,
        uploaded_files: []
      )
      |> allow_upload(:photos, accept: ~w(.jpg .jpeg .png), max_entries: 6)
    
    {:ok, socket}
  end
  
  def handle_event("validate", %{"bike" => bike_params}, socket) do
    changeset =
      %Bike{}
      |> Bikes.change_bike(bike_params)
      |> Map.put(:action, :validate)
    
    {:noreply, assign(socket, changeset: changeset)}
  end
  
  def handle_event("save", %{"bike" => bike_params}, socket) do
    # Process uploaded files
    uploaded_files = 
      consume_uploaded_entries(socket, :photos, fn %{path: path}, _entry ->
        # In real app, upload to S3 or similar
        # For now, copy to priv/static/uploads
        dest = Path.join([:code.priv_dir(:pedal_swap_pnw), "static", "uploads", Path.basename(path)])
        File.cp!(path, dest)
        {:ok, "/uploads/" <> Path.basename(path)}
      end)
    
    bike_params = Map.put(bike_params, "photos", uploaded_files)
    
    case Bikes.create_bike(bike_params) do
      {:ok, bike} ->
        {:noreply,
         socket
         |> put_flash(:info, "Bike listed successfully!")
         |> redirect(to: ~p"/catalog")}
      
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
  
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">
      <.navbar current_page={@current_page} mobile_menu_open={@mobile_menu_open} />
      
      <div class="max-w-2xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="mb-8">
          <h1 class="text-3xl font-bold text-gray-900">List Your Bike</h1>
          <p class="mt-2 text-gray-600">Share your bike with the community</p>
        </div>
        
        <.form for={@changeset} phx-change="validate" phx-submit="save" class="space-y-6">
          <!-- Basic Information -->
          <div class="bg-white p-6 rounded-lg shadow">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Basic Information</h2>
            
            <div class="grid grid-cols-1 gap-4">
              <div>
                <label class="block text-sm font-medium text-gray-700">Title</label>
                <.input
                  field={@changeset[:title]}
                  type="text"
                  placeholder="e.g., 2020 Trek Domane Road Bike"
                  class="mt-1"
                />
              </div>
              
              <div>
                <label class="block text-sm font-medium text-gray-700">Description</label>
                <textarea
                  field={@changeset[:description]}
                  rows="4"
                  placeholder="Describe your bike's condition, features, and any included accessories..."
                  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500"
                ></textarea>
              </div>
              
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700">Type</label>
                  <select field={@changeset[:type]} class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500">
                    <option value="">Select bike type</option>
                    <option value="Road">Road</option>
                    <option value="Mountain">Mountain</option>
                    <option value="Hybrid">Hybrid</option>
                    <option value="Electric">Electric</option>
                    <option value="BMX">BMX</option>
                    <option value="Cruiser">Cruiser</option>
                  </select>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700">Condition</label>
                  <select field={@changeset[:condition]} class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500">
                    <option value="">Select condition</option>
                    <option value="Excellent">Excellent</option>
                    <option value="Good">Good</option>
                    <option value="Fair">Fair</option>
                  </select>
                </div>
              </div>
              
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700">Price ($)</label>
                  <.input
                    field={@changeset[:price]}
                    type="number"
                    step="0.01"
                    placeholder="0.00"
                    class="mt-1"
                  />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700">Location</label>
                  <.input
                    field={@changeset[:location]}
                    type="text"
                    placeholder="e.g., Seattle, WA"
                    class="mt-1"
                  />
                </div>
              </div>
            </div>
          </div>
          
          <!-- Photos -->
          <div class="bg-white p-6 rounded-lg shadow">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Photos</h2>
            
            <div class="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center">
              <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path>
              </svg>
              <div class="mt-4">
                <label class="cursor-pointer">
                  <span class="text-sm font-medium text-green-600 hover:text-green-500">Upload photos</span>
                  <.live_file_input upload={@uploads.photos} class="sr-only" />
                </label>
                <p class="text-xs text-gray-500 mt-1">PNG, JPG up to 10MB each (max 6 photos)</p>
              </div>
            </div>
            
            <!-- Preview uploaded files -->
            <div class="mt-4 grid grid-cols-3 gap-4">
              <%= for entry <- @uploads.photos.entries do %>
                <div class="relative">
                  <.live_img_preview entry={entry} class="h-24 w-24 rounded-lg object-cover" />
                  <button
                    type="button"
                    phx-click="cancel-upload"
                    phx-value-ref={entry.ref}
                    class="absolute -top-2 -right-2 bg-red-500 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs hover:bg-red-600"
                  >
                    ×
                  </button>
                </div>
              <% end %>
            </div>
          </div>
          
          <!-- Bike Details -->
          <div class="bg-white p-6 rounded-lg shadow">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Bike Details</h2>
            
            <div class="grid grid-cols-1 gap-4">
              <div class="grid grid-cols-3 gap-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700">Brand</label>
                  <.input
                    field={@changeset[:brand]}
                    type="text"
                    placeholder="e.g., Trek"
                    class="mt-1"
                  />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700">Model</label>
                  <.input
                    field={@changeset[:model]}
                    type="text"
                    placeholder="e.g., Domane"
                    class="mt-1"
                  />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700">Year</label>
                  <.input
                    field={@changeset[:year]}
                    type="number"
                    placeholder="e.g., 2020"
                    class="mt-1"
                  />
                </div>
              </div>
              
              <div>
                <label class="block text-sm font-medium text-gray-700">Size</label>
                <.input
                  field={@changeset[:size]}
                  type="text"
                  placeholder="e.g., Medium, 56cm, Large"
                  class="mt-1"
                />
              </div>
            </div>
          </div>
          
          <!-- Trading Preferences -->
          <div class="bg-white p-6 rounded-lg shadow">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Trading Preferences</h2>
            
            <div class="space-y-4">
              <div class="flex items-center">
                <input
                  id="open-to-trades"
                  name="bike[open_to_trades]"
                  type="checkbox"
                  class="h-4 w-4 text-green-600 focus:ring-green-500 border-gray-300 rounded"
                />
                <label for="open-to-trades" class="ml-2 block text-sm text-gray-900">
                  I'm open to trading for another bike
                </label>
              </div>
              
              <div class="flex items-center">
                <input
                  id="delivery-available"
                  name="bike[delivery_available]"
                  type="checkbox"
                  class="h-4 w-4 text-green-600 focus:ring-green-500 border-gray-300 rounded"
                />
                <label for="delivery-available" class="ml-2 block text-sm text-gray-900">
                  I can deliver within 25 miles
                </label>
              </div>
            </div>
          </div>
          
          <!-- Submit Button -->
          <div class="flex justify-end">
            <.button type="submit" class="px-8 py-3 bg-green-600 hover:bg-green-700 text-white">
              List My Bike
            </.button>
          </div>
        </.form>
      </div>
    </div>
    """
  end
end
```

### Day 14: Profile Page
```elixir
# lib/pedal_swap_pnw_web/live/profile_live.ex

defmodule PedalSwapPnwWeb.ProfileLive do
  use PedalSwapPnwWeb, :live_view
  import PedalSwapPnwWeb.Components.UI
  import PedalSwapPnwWeb.Components.Navbar
  alias PedalSwapPnw.Users
  alias PedalSwapPnw.Bikes
  
  def mount(_params, _session, socket) do
    user = Users.get_user!(socket.assigns.current_user.id)
    user_bikes = Bikes.list_user_bikes(user.id)
    changeset = Users.change_user(user)
    
    socket =
      socket
      |> assign(
        current_page: "profile",
        mobile_menu_open: false,
        user: user,
        user_bikes: user_bikes,
        changeset: changeset,
        editing: false
      )
    
    {:ok, socket}
  end
  
  def handle_event("edit", _params, socket) do
    {:noreply, assign(socket, editing: true)}
  end
  
  def handle_event("cancel", _params, socket) do
    changeset = Users.change_user(socket.assigns.user)
    {:noreply, assign(socket, editing: false, changeset: changeset)}
  end
  
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Users.change_user(user_params)
      |> Map.put(:action, :validate)
    
    {:noreply, assign(socket, changeset: changeset)}
  end
  
  def handle_event("save", %{"user" => user_params}, socket) do
    case Users.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(user: user, editing: false)
         |> put_flash(:info, "Profile updated successfully!")}
      
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
  
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">
      <.navbar current_page={@current_page} mobile_menu_open={@mobile_menu_open} />
      
      <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div class="mb-8">
          <h1 class="text-3xl font-bold text-gray-900">My Profile</h1>
          <p class="mt-2 text-gray-600">Manage your account and bike listings</p>
        </div>
        
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
          <!-- Profile Information -->
          <div class="lg:col-span-2">
            <.card class="p-6">
              <div class="flex items-center justify-between mb-6">
                <h2 class="text-xl font-semibold text-gray-900">Profile Information</h2>
                <.button
                  :if={not @editing}
                  phx-click="edit"
                  variant="outline"
                  size="sm"
                >
                  Edit
                </.button>
              </div>
              
              <div :if={not @editing} class="space-y-4">
                <div class="flex items-center space-x-4">
                  <div class="h-16 w-16 rounded-full bg-green-100 flex items-center justify-center">
                    <span class="text-xl font-semibold text-green-600">
                      <%= String.first(@user.name) %>
                    </span>
                  </div>
                  <div>
                    <h3 class="text-lg font-medium text-gray-900"><%= @user.name %></h3>
                    <p class="text-gray-600"><%= @user.email %></p>
                  </div>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700">Location</label>
                  <p class="mt-1 text-gray-900"><%= @user.location || "Not specified" %></p>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700">Bio</label>
                  <p class="mt-1 text-gray-900"><%= @user.bio || "No bio provided" %></p>
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700">Interests</label>
                  <div class="mt-2 flex flex-wrap gap-2">
                    <%= for interest <- @user.interests || [] do %>
                      <.badge><%= interest %></.badge>
                    <% end %>
                  </div>
                </div>
              </div>
              
              <.form :if={@editing} for={@changeset} phx-change="validate" phx-submit="save" class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700">Name</label>
                  <.input
                    field={@changeset[:name]}
                    type="text"
                    class="mt-1"
                  />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700">Location</label>
                  <.input
                    field={@changeset[:location]}
                    type="text"
                    placeholder="e.g., Seattle, WA"
                    class="mt-1"
                  />
                </div>
                
                <div>
                  <label class="block text-sm font-medium text-gray-700">Bio</label>
                  <textarea
                    field={@changeset[:bio]}
                    rows="3"
                    placeholder="Tell us about yourself..."
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-green-500 focus:ring-green-500"
                  ></textarea>
                </div>
                
                <div class="flex justify-end space-x-3">
                  <.button phx-click="cancel" variant="outline" type="button">
                    Cancel
                  </.button>
                  <.button type="submit">
                    Save Changes
                  </.button>
                </div>
              </.form>
            </.card>
          </div>
          
          <!-- Stats -->
          <div class="space-y-6">
            <.card class="p-6">
              <h3 class="text-lg font-semibold text-gray-900 mb-4">Stats</h3>
              <div class="space-y-3">
                <div class="flex justify-between">
                  <span class="text-gray-600">Bikes Listed</span>
                  <span class="font-semibold"><%= length(@user_bikes) %></span>
                </div>
                <div class="flex justify-between">
                  <span class="text-gray-600">Member Since</span>
                  <span class="font-semibold">
                    <%= Calendar.strftime(@user.inserted_at, "%B %Y") %>
                  </span>
                </div>
              </div>
            </.card>
          </div>
        </div>
        
        <!-- My Bikes -->
        <div class="mt-8">
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-2xl font-semibold text-gray-900">My Bikes</h2>
            <.button>
              <.link navigate="/list-bike">List New Bike</.link>
            </.button>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <%= for bike <- @user_bikes do %>
              <.card class="overflow-hidden">
                <div class="aspect-w-16 aspect-h-9">
                  <img src={bike.photos |> List.first() || "/images/placeholder-bike.jpg"} 
                       alt={bike.title} 
                       class="w-full h-48 object-cover" />
                </div>
                <div class="p-4">
                  <h3 class="font-semibold text-lg text-gray-900"><%= bike.title %></h3>
                  <p class="text-green-600 font-bold text-xl">$<%= bike.price %></p>
                  <div class="mt-2 flex items-center space-x-2">
                    <.badge variant="secondary"><%= bike.type %></.badge>
                    <.badge variant="outline"><%= bike.condition %></.badge>
                  </div>
                  <div class="mt-4 flex space-x-2">
                    <.button size="sm" class="flex-1">
                      Edit
                    </.button>
                    <.button size="sm" variant="outline" class="flex-1">
                      Delete
                    </.button>
                  </div>
                </div>
              </.card>
            <% end %>
          </div>
          
          <div :if={length(@user_bikes) == 0} class="text-center py-12">
            <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
            </svg>
            <h3 class="mt-2 text-sm font-medium text-gray-900">No bikes listed</h3>
            <p class="mt-1 text-sm text-gray-500">Get started by listing your first bike</p>
            <.button class="mt-4">
              <.link navigate="/list-bike">List Your First Bike</.link>
            </.button>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
```

## Phase 4: Backend Logic (Week 3)

### Day 15: Context Modules
```elixir
# lib/pedal_swap_pnw/bikes.ex

defmodule PedalSwapPnw.Bikes do
  import Ecto.Query, warn: false
  alias PedalSwapPnw.Repo
  alias PedalSwapPnw.Bikes.Bike
  
  def list_bikes do
    Repo.all(Bike)
  end
  
  def list_available_bikes do
    Bike
    |> where([b], b.is_available == true)
    |> order_by([b], desc: b.inserted_at)
    |> Repo.all()
  end
  
  def list_user_bikes(user_id) do
    Bike
    |> where([b], b.user_id == ^user_id)
    |> order_by([b], desc: b.inserted_at)
    |> Repo.all()
  end
  
  def get_bike!(id), do: Repo.get!(Bike, id)
  
  def create_bike(attrs \\ %{}) do
    %Bike{}
    |> Bike.changeset(attrs)
    |> Repo.insert()
  end
  
  def update_bike(%Bike{} = bike, attrs) do
    bike
    |> Bike.changeset(attrs)
    |> Repo.update()
  end
  
  def delete_bike(%Bike{} = bike) do
    Repo.delete(bike)
  end
  
  def change_bike(%Bike{} = bike, attrs \\ %{}) do
    Bike.changeset(bike, attrs)
  end
end
```

### Day 16: Router Configuration
```elixir
# lib/pedal_swap_pnw_web/router.ex

defmodule PedalSwapPnwWeb.Router do
  use PedalSwapPnwWeb, :router
  
  import PedalSwapPnwWeb.UserAuth
  
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PedalSwapPnwWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end
  
  pipeline :api do
    plug :accepts, ["json"]
  end
  
  scope "/", PedalSwapPnwWeb do
    pipe_through :browser
    
    live "/", IndexLive
    live "/catalog", CatalogLive
    
    # Authentication routes
    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end
  
  # Protected routes
  scope "/", PedalSwapPnwWeb do
    pipe_through [:browser, :require_authenticated_user]
    
    live "/list-bike", ListBikeLive
    live "/profile", ProfileLive
    
    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end
  
  scope "/", PedalSwapPnwWeb do
    pipe_through [:browser]
    
    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :edit
    put "/users/confirm/:token", UserConfirmationController, :update
  end
end
```

## Phase 5: Polish and Testing (Week 4)

### Day 17-18: Image Upload and File Handling
```elixir
# Configure file uploads
# config/config.exs

config :pedal_swap_pnw,
  uploads_directory: Path.expand("../priv/static/uploads", __DIR__)

# lib/pedal_swap_pnw/upload.ex

defmodule PedalSwapPnw.Upload do
  @upload_dir Application.compile_env(:pedal_swap_pnw, :uploads_directory)
  
  def save_upload(upload, filename) do
    File.mkdir_p!(@upload_dir)
    dest_path = Path.join(@upload_dir, filename)
    File.cp!(upload.path, dest_path)
    {:ok, "/uploads/#{filename}"}
  end
  
  def delete_upload(filename) do
    Path.join(@upload_dir, filename)
    |> File.rm()
  end
end
```

### Day 19: Error Handling and Validation
```elixir
# Improve error handling in LiveViews
# Add comprehensive validation to schemas
# Add error pages and better UX
```

### Day 20: Testing and Deployment
```bash
# Run tests
mix test

# Setup deployment
# Configure production database
# Setup CI/CD pipeline
# Deploy to production
```

## Key Benefits of This Conversion

### 1. **Preserved Design System**
- All Tailwind CSS classes and styling remain identical
- Custom design system with HSL colors intact
- Responsive design patterns maintained

### 2. **Enhanced Backend**
- Robust database layer with Ecto schemas
- Built-in authentication and authorization
- Server-side validation with changesets
- Real-time capabilities with LiveView

### 3. **Improved Form Handling**
- Phoenix changesets provide better validation
- Server-side form processing
- Built-in CSRF protection
- Better error handling and display

### 4. **Better Performance**
- Server-side rendering for faster initial loads
- Reduced JavaScript bundle size
- Efficient real-time updates
- Better SEO with server-rendered content

### 5. **Simplified State Management**
- LiveView assigns replace complex React state
- Server-side state management
- Automatic state synchronization
- No need for external state management libraries

## Conversion Complexity: Medium (6/10)

**What's Preserved (40%):**
- ✅ All Tailwind CSS and design system
- ✅ Application structure and user flows
- ✅ Business logic and data models
- ✅ User experience patterns

**What's Rebuilt (60%):**
- ❌ All UI components (30+ Shadcn/ui components)
- ❌ React hooks and state management
- ❌ Client-side routing and navigation
- ❌ Form handling patterns
- ❌ Build system and tooling

**Estimated Timeline: 3-4 weeks for experienced Phoenix developer**

This conversion plan provides a comprehensive roadmap for transforming the React application into a modern, robust Phoenix LiveView application while preserving the excellent design system and user experience.