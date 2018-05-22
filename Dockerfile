FROM gcr.io/google_appengine/ruby

ENV HOME=/slack
WORKDIR $HOME

RUN apt-get update
RUN apt-get install -y -q --no-install-recommends at supervisor

COPY Gemfile $HOME
RUN bundle install --without test

COPY ./lib $HOME/lib
COPY unicorn.conf $HOME
COPY config.ru $HOME
COPY .env $HOME

RUN mkdir -p tmp/pids log /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR $HOME
CMD ["/usr/bin/supervisord"]
