FROM ruby:2.4.2
EXPOSE 6739
ENV LANG C.UTF-8

# 準備環境，youtube-dl套件安裝，gem bundleer
RUN \
  apt-get update -qq && \
  apt-get install -y build-essential libpq-dev nodejs libav-tools && \
  curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl && \
  gem install bundler
RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app
