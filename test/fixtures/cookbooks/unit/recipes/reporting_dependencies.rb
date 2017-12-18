include_recipe 'unit::policy_dependencies'
mysql_bin = '/usr/bin/mysql'
execute 'Create Reporting Database' do
  command "#{mysql_bin} -e 'create database pacifica_reporting;'"
  not_if "#{mysql_bin} -e 'show databases;' | grep -q pacifica_reporting"
end
execute 'Grant/Create Reporting User' do
  command "#{mysql_bin} -e 'grant all on pacifica_reporting.* to reporting@'\\''localhost'\\'' identified by '\\''reporting'\\'';'"
  not_if "#{mysql_bin} -e 'select User from mysql.user;' | grep reporting"
end
