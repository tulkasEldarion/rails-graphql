FROM ruby:latest
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /graphql
WORKDIR /graphql
COPY Gemfile /graphql/Gemfile
COPY Gemfile.lock /graphql/Gemfile.lock
RUN bundle install
COPY . /graphql