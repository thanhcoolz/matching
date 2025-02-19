FROM ruby:3.4.1

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs netcat-traditional

# Set working directory
WORKDIR /app

# Install Rails dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application
COPY . .

# Add a script to be executed every time the container starts
RUN apt-get install -y dos2unix && \
    mkdir -p /app/bin

# Copy entrypoint script and set permissions
COPY --chmod=0755 bin/entrypoint /app/bin/
RUN dos2unix /app/bin/entrypoint
ENTRYPOINT ["/app/bin/entrypoint"]

# Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]
