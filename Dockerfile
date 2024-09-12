# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.1
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base
USER root

# Rails app lives here
WORKDIR /rails

RUN mkdir -p /rails/.bundle

# Set production environment
ENV BUNDLE_WITHOUT="development" \
    BUNDLE_PATH="/usr/local/bundle"

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config

# Install application gems, cleanup unnecessary gem files
COPY Gemfile Gemfile.lock ./

RUN bundle install --verbose && bundle update bootsnap && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .
COPY .env /app/.env


# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/


# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails /rails
USER rails:rails
RUN chmod -R u+rwx /rails


CMD ["bash", "-c", "rm -f tmp/pids/server.pid && ./bin/rails db:prepare && bundle exec rails s -b '0.0.0.0' -p 3000"]

EXPOSE 3000
