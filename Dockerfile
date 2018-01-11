FROM ruby:2.4.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /twgo_dl
WORKDIR /twgo_dl
COPY Gemfile /twgo_dl/Gemfile
COPY Gemfile.lock /twgo_dl/Gemfile.lock
RUN bundle install
COPY . /twgo_dl
