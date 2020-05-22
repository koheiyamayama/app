FROM ruby:latest
RUN apt-get update && apt-get install -y locales
RUN locale-gen C.UTF-8 
ENV LANG C.UTF-8  
ENV LANGUAGE C.UTF-8
RUN gem install bundler
RUN mkdir /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
WORKDIR /app
RUN bundle install
COPY ./ /app/
CMD [ "ruby", "main.rb" ]
