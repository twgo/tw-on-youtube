# Base image:
FROM ruby:2.4.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs libav-tools && curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl
RUN gem install bundler


# Set an environment variable where the Rails app is installed to inside of Docker image:
ENV LANG C.UTF-8
ENV RAILS_ROOT /var/www/tw_on_youtube
RUN mkdir -p $RAILS_ROOT

# Set working directory, where the commands will be ran:
WORKDIR $RAILS_ROOT

# Gems:
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler
RUN bundle install

COPY config/puma.rb config/puma.rb

# Copy the main application.
COPY . .

EXPOSE 3000

# The default command that gets ran will be to start the Puma server.
# CMD bundle exec puma -C config/puma.rb
