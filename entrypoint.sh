systemctl start atd
systemctl enable atd
bundle exec unicorn -c unicorn.conf
tail -f /dev/null
