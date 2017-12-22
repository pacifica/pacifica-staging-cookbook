# encoding: utf-8

# Inspec test for recipe pacifica::default

# The Inspec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec_reference.html

describe port(8000) do
  it { should be_listening }
end

describe command("curl -H 'Authorization: Basic ZG1sYjIwMDE6MTIzNA==' http://127.0.0.1:8000 | grep -q David") do
  its(:exit_status) { should eq 0 }
end
