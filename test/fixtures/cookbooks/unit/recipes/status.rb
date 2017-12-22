include_recipe 'unit::status_dependencies'
pacifica_status 'default' do
  prefix '/var/www/html'
end
