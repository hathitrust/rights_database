FROM ruby:3.1
ARG UNAME=app
ARG UID=1000
ARG GID=1000

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs

WORKDIR /usr/src/app
ENV BUNDLE_PATH /gems
COPY . /usr/src/app/
RUN gem install bundler
RUN bundle install
