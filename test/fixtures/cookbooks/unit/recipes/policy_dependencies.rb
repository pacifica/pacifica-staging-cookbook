include_recipe 'pacifica-dependencies::pgsql_service'
include_recipe 'pacifica-dependencies::mysql_service'
include_recipe 'pacifica-dependencies::elasticsearch'
include_recipe 'pacifica-dependencies::metadatadb_setup'
pacifica_metadata 'default'
pacifica_policy 'default'

git "#{Chef::Config[:file_cache_path]}/pacifica-metadata" do
  repository 'https://github.com/pacifica/pacifica-metadata.git'
  action :sync
end

execute 'sleep 15'

execute 'Load Metadata Set' do
  environment LD_LIBRARY_PATH: '/opt/rh/python27/root/usr/lib64', LD_RUN_PATH: '/opt/rh/python27/root/usr/lib64'
  command '/opt/default/bin/python test_files/loadit.py'
  cwd "#{Chef::Config[:file_cache_path]}/pacifica-metadata"
  not_if 'curl localhost:8121/users | grep -q dmlb2001'
end
