# Use Ruby 3.3 (check latest version for Rails 7.2 compatibility)
FROM ruby:3.3-slim

# Install Rails dependencies
RUN apt-get update -qq && \
    apt-get install -y \ 
    build-essential \
    curl \
    git \
    libpq-dev \
    libyaml-dev \
    postgresql-client \
    cron \
    pkg-config && \  
    rm -rf /var/lib/apt/lists/*

# Install Node.js (required for Rails assets)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install Yarn
RUN npm install -g yarn

# Set working directory
WORKDIR /app

# Copy Gemfile first (even if Gemfile.lock is missing)
COPY Gemfile /app/Gemfile
RUN touch /app/Gemfile.lock

# Copy application code
COPY . .

# Install gems
# RUN bundle install

# Entrypoint script to wait for PostgreSQL
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose port 3000
EXPOSE 3000

# Start Rails server
CMD ["sh", "-c", "rm -f tmp/pids/server.pid && rails server -b 0.0.0.0"]
