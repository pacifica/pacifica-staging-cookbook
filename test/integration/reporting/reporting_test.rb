# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe command(%q(/bin/bash -c 'cd /var/www/html; METADATA_PORT=tcp://127.0.0.1:8121 POLICY_PORT=tcp://127.0.0.1:8181 PHP_AUTH_USER=dmlb2001 CI_ENV=production php index.php group view')) do
  its(:exit_status) { should eq 0 }
end
