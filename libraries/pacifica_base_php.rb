# pacifica cookbook module
module PacificaCookbook
  # Pacifica base class with common properties and actions
  class PacificaBasePhp < ChefCompat::Resource
    property :name, String, name_property: true
    property :prefix, String, default: lazy { "/var/www/#{name}-#{resource_name.to_s.tr('_', '-')}" }
    property :git_opts, Hash, default: {}
    property :git_client_opts, Hash, default: {}
    property :ci_prod_configs, Hash, default: {}
    property :ci_test_configs, Hash, default: {}
    property :ci_dev_configs, Hash, default: {}

    default_action :create

    action :create do
      git_client new_resource.name.to_s do
        git_client_opts.each do |attr, value|
          send(attr, value)
        end
      end

      # Clone the provided repository and include submodules
      git "Clone Website for #{new_resource.name}" do
        destination "#{Chef::Config[:file_cache_path]}/#{new_resource.name}-#{resource_name.to_s.tr('_', '-')}"
        enable_submodules true
	notifies :run, "bash[Deploy Code for #{new_resource.name}]"
        git_opts.each do |attr, value|
          send(attr, value)
        end
      end

      directory new_resource.prefix do
        recursive true
      end
      package 'tar'

      bash "Deploy Code for #{new_resource.name}" do
        cwd "#{Chef::Config[:file_cache_path]}/#{new_resource.name}"
	code <<-EOH
	  git archive --format=tar HEAD | tar -C #{new_resource.prefix} -xf -
	  EOH
      end

      {
        'production' => new_resource.ci_prod_configs,
        'testing' => new_resource.ci_test_configs,
        'development' => new_resource.ci_dev_configs,
      }.each do |directory, configs|
        configs.each do |filename, content|
          content = <<-EOH
          <?php
          defined('BASEPATH') OR exit('No direct script access allowed');
          #{content}
          EOH
          file "File #{new_resource.name} #{directory} #{filename}" do
            path "#{new_resource.prefix}/application/config/#{directory}/#{filename}.php"
	    content content
          end
        end
      end
      include_recipe 'php'
      include_recipe 'php::module_pgsql'
      include_recipe 'php::module_mysql'
      include_recipe 'php::module_sqlite3'
      include_recipe 'php::module_gd'
    end
  end
end
