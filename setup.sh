#!/usr/bin/env bash
# Setup script to link every file in place automagically

ln -s "$(pwd)/etc/insaned" /etc/insaned
ln -s "$(pwd)/etc/default/insaned" /etc/default/insaned
# Until jessie-backports gets systemd > 231, we can't use symlinks for systemd
# :( See https://github.com/systemd/systemd/pull/3806
# ln -s "$(pwd)/etc/systemd/system/insaned.service" /etc/systemd/system/insaned.service
cp etc/systemd/system/insaned.service /etc/systemd/system/insaned.service
ln -s "$(pwd)/usr/local/bin/insaned" /usr/local/bin/insaned
ln -s "$(pwd)/usr/local/bin/textcleaner" /usr/local/bin/textcleaner
