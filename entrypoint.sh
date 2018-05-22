systemctl start atd
systemctl enable atd
bundle exec unicorn -c unicorn.conf -D
tail -f /dev/null
