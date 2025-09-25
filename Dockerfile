# Use Ruby
FROM ruby:3.4.5

# Install dependencies, curl and gnupg needed for yarn repo
RUN apt-get update -qq && apt-get install -y curl gnupg2

# add yarn if needed
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /usr/share/keyrings/yarn.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y nodejs yarn postgresql-client build-essential libpq-dev


# set base directory
WORKDIR /app

# copy gemfile and gemfile.lock for install gems
COPY Gemfile Gemfile.lock ./

# setup ruby gems
RUN bundle install && \
    bundle exec bootsnap precompile --gemfile

# copy other apps code

COPY . .

# open port 3000
EXPOSE 3000

# set ENV
ENV RAILS_ENV=development

# delete server.pip if exist; run rails server
CMD rm -f tmp/pids/server.pid && rails server -b 0.0.0.0
