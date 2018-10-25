#!/usr/bin/env bash

echo "testing directory symlinks"
ls -1 /vagrant/b > expected.txt
ls -1 /vagrant/directory_link_non_admin > actual.txt

diff -y -s expected.txt actual.txt

echo "testing file symliks"
diff -y -s /vagrant/a/source_link_example_non_admin.txt /vagrant/b/content.txt