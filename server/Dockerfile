FROM ruby:3.4.1

# Install system dependencies
RUN apt-get update -qq && \
  apt-get install -y build-essential libpq-dev nodejs netcat-traditional

# Set working directory
WORKDIR /app

# Install Rails dependencies
COPY Gemfile Gemfile.lock ./

# Clear any existing bundle config
RUN rm -rf /usr/local/bundle/*

# Install bundler with specific version
RUN gem install bundler:2.6.2

# Add build arg for cache busting
ARG CACHEBUST=1
RUN echo "Cache bust: ${CACHEBUST}"

# Install dependencies
RUN bundle config set --local without 'development test' && \
  bundle install --jobs 4 --retry 3

# Copy the rest of the application
COPY . .

# Ensure correct permissions
RUN chmod +x bin/*

# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]
