FROM gcr.io/google_appengine/ruby

ENV HOME=/slack
WORKDIR $HOME

RUN apt-get update
RUN apt-get install -y -q --no-install-recommends at

EXPOSE 8080

COPY Gemfile $HOME
RUN bundle install --without test

COPY ./lib $HOME/lib
COPY unicorn.conf $HOME
COPY config.ru $HOME
COPY .env $HOME
COPY entrypoint.sh /etc

RUN mkdir tmp tmp/pids log

WORKDIR $HOME
RUN chmod 755 /etc/entrypoint.sh
ENTRYPOINT /etc/entrypoint.sh

