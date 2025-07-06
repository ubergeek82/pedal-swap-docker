FROM elixir:latest

# Install build dependencies
RUN apt-get update && apt-get install -y build-essential git && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set build ENV
ENV MIX_ENV=dev

# Install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get

# Copy config files
COPY config/ config/


# Compile dependencies
RUN mix deps.compile

# Copy priv, lib, assets
COPY priv/ priv/
COPY lib/ lib/
COPY assets/ assets/

# Build assets (Tailwind only)
RUN mix assets.deploy

# Compile the project
RUN mix compile

# Set runtime ENV
ENV PHX_SERVER=true
ENV DATABASE_URL=postgresql://postgres:postgres@db:5432/simple_app_dev
ENV SECRET_KEY_BASE=dev-secret-key-base-that-is-at-least-64-bytes-long-for-development-use-only

EXPOSE 80

CMD ["mix", "phx.server"]