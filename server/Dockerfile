FROM ruby:3.4.1

# Install system dependencies
RUN apt-get update -qq && \
  apt-get install -y build-essential libpq-dev nodejs netcat-traditional

# Set working directory
WORKDIR /app

# Install Rails dependencies
COPY Gemfile ./

# Add build arg for cache busting
ARG CACHEBUST=1
RUN echo "Cache bust: ${CACHEBUST}"
RUN bundle install --no-cache

# Copy the rest of the application
COPY . .

# Ensure correct permissions
RUN chmod +x bin/*

# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]
