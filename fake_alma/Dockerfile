FROM ruby:3.2

LABEL maintainer="mrio@umich.edu"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  vim

RUN gem install bundler


RUN mkdir -p /gems 


COPY Gemfile* /app/

ENV BUNDLE_PATH /gems

#Not that much of a secret

WORKDIR /app
RUN bundle install

COPY . /app


CMD ["bundle", "exec", "ruby", "fake_alma.rb", "-o", "0.0.0.0"]
