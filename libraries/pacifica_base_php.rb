# pacifica cookbook module
module PacificaCookbook
  # Pacifica base class with common properties and actions
  class PacificaBasePhp < Chef::Resource
    property :name, String, name_property: true
    property :full_name, String, default: lazy { "#{name}-#{resource_name.to_s.tr('_', '-')}" }
    property :prefix, String, default: lazy { "/var/www/#{full_name}" }
    property :git_opts, Hash, default: {}
    property :git_client_opts, Hash, default: {}
    property :ci_prod_configs, Hash, default: {}
    property :ci_test_configs, Hash, default: {}
    property :ci_dev_configs, Hash, default: {}

    default_action :create

    action :create do
      git_client new_resource.name.to_s do
        new_resource.git_client_opts.each do |attr, value|
          send(attr, value)
        end
      end

      # Clone the provided repository and include submodules
      git "Clone Website for #{new_resource.full_name}" do
        destination "#{Chef::Config[:file_cache_path]}/#{new_resource.full_name}"
        enable_submodules true
        notifies :run, "bash[Deploy Code for #{new_resource.full_name}]"
        new_resource.git_opts.each do |attr, value|
          send(attr, value)
        end
      end

      directory new_resource.prefix do
        recursive true
      end
      package 'tar'

      bash "Deploy Code for #{new_resource.full_name}" do
        cwd "#{Chef::Config[:file_cache_path]}/#{new_resource.full_name}"
        code <<-EOH
      git archive --format=tar HEAD | tar -C #{new_resource.prefix} -xf -
      for dir in `git submodule status | awk '{ print $2 }'` ; do
        pushd $dir
        git archive --format=tar HEAD | tar -C #{new_resource.prefix}/$dir -xf -
        popd
      done
      pushd #{new_resource.prefix}
      rm -f index.php
      cp websystem/index.php index.php
      popd
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
          file "File #{new_resource.full_name} #{directory} #{filename}" do
            path "#{new_resource.prefix}/application/config/#{directory}/#{filename}.php"
            content content
          end
        end
      end
    end
  end
end
