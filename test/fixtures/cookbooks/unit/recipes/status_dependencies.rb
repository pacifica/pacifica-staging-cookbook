include_recipe 'unit::policy_dependencies'
mysql_bin = '/usr/bin/mysql'
execute 'Create Status Database' do
  command "#{mysql_bin} -e 'create database pacifica_status;'"
  not_if "#{mysql_bin} -e 'show databases;' | grep -q pacifica_status"
end
execute 'Grant/Create Status User' do
  command "#{mysql_bin} -e 'grant all on pacifica_status.* to status@'\\''localhost'\\'' identified by '\\''status'\\'';'"
  not_if "#{mysql_bin} -e 'select User from mysql.user;' | grep status"
end
