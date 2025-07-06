# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     SimpleApp.Repo.insert!(%SimpleApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias SimpleApp.Repo
alias SimpleApp.Accounts.User
alias SimpleApp.Bikes.Bike
alias SimpleApp.Trades.Trade

# Clear existing data
Repo.delete_all(Trade)
Repo.delete_all(Bike)
Repo.delete_all(User)

# Create sample users
users = [
  %{
    email: "alice@example.com",
    username: "alice_rider",
    password: "password123",
    display_name: "Alice Johnson",
    bio: "Mountain bike enthusiast from Portland",
    location: "Portland, OR",
    strava_id: "alice_strava",
    favorite_ride: "Forest Park Loop",
    preferred_size: "M",
    interested_in: ["mountain", "gravel"]
  },
  %{
    email: "bob@example.com",
    username: "bob_cycles",
    password: "password123",
    display_name: "Bob Wilson",
    bio: "Road cycling fanatic and bike mechanic",
    location: "Seattle, WA",
    strava_id: "bob_strava",
    favorite_ride: "Burke-Gilman Trail",
    preferred_size: "L",
    interested_in: ["road", "gravel"]
  },
  %{
    email: "charlie@example.com",
    username: "charlie_trail",
    password: "password123",
    display_name: "Charlie Brown",
    bio: "Gravel grinder and bike packer",
    location: "Bend, OR",
    strava_id: "charlie_strava",
    favorite_ride: "Cascade Cycling Classic",
    preferred_size: "M",
    interested_in: ["gravel", "mountain"]
  },
  %{
    email: "diana@example.com",
    username: "diana_wheels",
    password: "password123",
    display_name: "Diana Martinez",
    bio: "Weekend warrior and commuter cyclist",
    location: "Vancouver, BC",
    strava_id: "diana_strava",
    favorite_ride: "Seawall Loop",
    preferred_size: "S",
    interested_in: ["hybrid", "road"]
  }
]

created_users = Enum.map(users, fn user_attrs ->
  SimpleApp.Accounts.create_user(user_attrs)
  |> case do
    {:ok, user} -> user
    {:error, changeset} -> 
      IO.inspect(changeset.errors, label: "User creation error for #{user_attrs.email}")
      nil
  end
end)
|> Enum.filter(& &1)

IO.puts("Created #{length(created_users)} users")

# Create sample bikes
bikes = [
  # Alice's bikes
  %{
    title: "Trek Fuel EX 8 - Trail Ready",
    description: "Excellent condition Trek Fuel EX 8. Perfect for PNW trails. Recently serviced.",
    brand: "Trek",
    model: "Fuel EX 8",
    type: "mountain",
    size: "M",
    condition: "excellent",
    price: Decimal.new("2800"),
    year: 2022,
    components: "Shimano XT groupset, Fox Float DPS rear shock",
    wheelset: "Bontrager Line Comp 30",
    wheel_size: "29\"",
    tire_size: "29x2.4",
    images: ["trek_fuel_ex_1.jpg", "trek_fuel_ex_2.jpg"],
    user_id: Enum.at(created_users, 0).id
  },
  %{
    title: "Specialized Rockhopper - Entry Level MTB",
    description: "Great entry-level mountain bike. Some wear but mechanically sound.",
    brand: "Specialized",
    model: "Rockhopper",
    type: "mountain",
    size: "S",
    condition: "good",
    price: Decimal.new("800"),
    year: 2020,
    components: "Shimano Altus groupset",
    wheelset: "Alex rims",
    wheel_size: "29\"",
    tire_size: "29x2.3",
    images: ["specialized_rockhopper.jpg"],
    user_id: Enum.at(created_users, 0).id
  },
  
  # Bob's bikes
  %{
    title: "Canyon Ultimate CF SL - Road Racing",
    description: "Lightweight carbon road bike. Perfect for racing and long rides.",
    brand: "Canyon",
    model: "Ultimate CF SL",
    type: "road",
    size: "L",
    condition: "excellent",
    price: Decimal.new("3200"),
    year: 2023,
    components: "Shimano Ultegra Di2 electronic shifting",
    wheelset: "DT Swiss ARC 1100",
    wheel_size: "700c",
    tire_size: "700x25c",
    images: ["canyon_ultimate_1.jpg", "canyon_ultimate_2.jpg"],
    user_id: Enum.at(created_users, 1).id
  },
  %{
    title: "Giant Defy - Endurance Road",
    description: "Comfortable endurance road bike. Great for long distance rides.",
    brand: "Giant",
    model: "Defy Advanced",
    type: "road",
    size: "L",
    condition: "good",
    price: Decimal.new("1800"),
    year: 2021,
    components: "Shimano 105 groupset",
    wheelset: "Giant P-R2 Disc",
    wheel_size: "700c",
    tire_size: "700x28c",
    images: ["giant_defy.jpg"],
    user_id: Enum.at(created_users, 1).id
  },

  # Charlie's bikes
  %{
    title: "Salsa Cutthroat - Bikepacking Beast",
    description: "Drop bar mountain bike perfect for bikepacking adventures.",
    brand: "Salsa",
    model: "Cutthroat",
    type: "gravel",
    size: "M",
    condition: "excellent",
    price: Decimal.new("2400"),
    year: 2022,
    components: "SRAM GX Eagle 1x12 drivetrain",
    wheelset: "WTB ST i30",
    wheel_size: "29\"",
    tire_size: "29x2.4",
    images: ["salsa_cutthroat.jpg"],
    user_id: Enum.at(created_users, 2).id
  },
  %{
    title: "Surly Cross-Check - Steel is Real",
    description: "Versatile steel frame bike. Can handle road, gravel, and light touring.",
    brand: "Surly",
    model: "Cross-Check",
    type: "gravel",
    size: "M",
    condition: "good",
    price: Decimal.new("1200"),
    year: 2019,
    components: "Shimano Tiagra groupset",
    wheelset: "Velocity A23",
    wheel_size: "700c",
    tire_size: "700x35c",
    images: ["surly_crosscheck.jpg"],
    user_id: Enum.at(created_users, 2).id
  },

  # Diana's bikes
  %{
    title: "Cannondale Quick - City Commuter",
    description: "Reliable hybrid bike for city commuting and weekend rides.",
    brand: "Cannondale",
    model: "Quick 4",
    type: "hybrid",
    size: "S",
    condition: "good",
    price: Decimal.new("600"),
    year: 2020,
    components: "Shimano Acera components",
    wheelset: "Cannondale C4",
    wheel_size: "700c",
    tire_size: "700x35c",
    images: ["cannondale_quick.jpg"],
    user_id: Enum.at(created_users, 3).id
  }
]

created_bikes = Enum.map(bikes, fn bike_attrs ->
  SimpleApp.Bikes.create_bike(bike_attrs)
  |> case do
    {:ok, bike} -> bike
    {:error, changeset} -> 
      IO.inspect(changeset.errors, label: "Bike creation error for #{bike_attrs.title}")
      nil
  end
end)
|> Enum.filter(& &1)

IO.puts("Created #{length(created_bikes)} bikes")

# Create sample trades
trades = [
  %{
    initiator_id: Enum.at(created_users, 0).id,  # Alice
    recipient_id: Enum.at(created_users, 1).id,  # Bob
    bike_offered_id: Enum.at(created_bikes, 1).id,  # Alice's Specialized Rockhopper
    bike_requested_id: Enum.at(created_bikes, 3).id,  # Bob's Giant Defy
    status: "pending",
    message: "Hi Bob! I'm interested in your Giant Defy. I have a Specialized Rockhopper that might work for you. Let me know if you're interested!",
    initiator_notes: "Looking to get into road cycling"
  },
  %{
    initiator_id: Enum.at(created_users, 2).id,  # Charlie
    recipient_id: Enum.at(created_users, 0).id,  # Alice
    bike_offered_id: Enum.at(created_bikes, 5).id,  # Charlie's Surly Cross-Check
    bike_requested_id: Enum.at(created_bikes, 0).id,  # Alice's Trek Fuel EX
    status: "rejected",
    message: "Hey Alice, would you be interested in trading your Trek for my Surly? It's great for bikepacking.",
    recipient_notes: "Thanks for the offer, but I need to keep my mountain bike for local trails."
  },
  %{
    initiator_id: Enum.at(created_users, 3).id,  # Diana
    recipient_id: Enum.at(created_users, 2).id,  # Charlie
    bike_offered_id: Enum.at(created_bikes, 6).id,  # Diana's Cannondale Quick
    bike_requested_id: Enum.at(created_bikes, 4).id,  # Charlie's Salsa Cutthroat
    status: "accepted",
    message: "I love the look of your Salsa! Would you consider trading for my Cannondale?",
    initiator_notes: "Ready to try gravel riding",
    recipient_notes: "Sounds good! Your hybrid would be perfect for my girlfriend."
  }
]

created_trades = Enum.map(trades, fn trade_attrs ->
  SimpleApp.Trades.create_trade(trade_attrs)
  |> case do
    {:ok, trade} -> trade
    {:error, changeset} -> 
      IO.inspect(changeset.errors, label: "Trade creation error")
      nil
  end
end)
|> Enum.filter(& &1)

IO.puts("Created #{length(created_trades)} trades")

IO.puts("\n🚀 Seed data created successfully!")
IO.puts("Users: #{length(created_users)}")
IO.puts("Bikes: #{length(created_bikes)}")
IO.puts("Trades: #{length(created_trades)}")
IO.puts("\nYou can now test the API endpoints with real data!")