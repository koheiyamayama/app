FROM ruby:latest
RUN gem install bundler
RUN mkdir /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
WORKDIR /app
RUN bundle install
COPY ./ /app/
CMD [ "ruby", "main.rb" ]
