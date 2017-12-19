# pacifica cookbook module
module PacificaCookbook
  # installs and configures pacifica ingest backend celery
  class PacificaUploaderBackend < PacificaBase
    resource_name :pacifica_uploaderbackend
    property :name, String, name_property: true
    property :service_name, String, default: lazy { "#{name}-#{resource_name.to_s.gsub(/_/, '-')}" }
    property :script_name, String, default: lazy { "#{service_name}.sh" }
    property :config_name, Hash, default: lazy { "#{service_name}/UploaderConfig.json" }
    property :pip_install_opts, Hash, default: lazy {
      {
        command: "-m pip install -r #{prefix_dir}/#{service_name}/requirements.txt"
      }
    }
    property :service_opts, Hash, default: lazy {
      {
        directory: "#{prefix_dir}/#{service_name}",
        environment: {
          BROKER_VHOST: "/uploader",
        },
      }
    }
    property :config_opts, Hash, default: lazy {
      extend PacificaCookbook::PacificaHelpers::Base
      {
        variables: {
          content: uploader_default_config.to_json
	}
      }
    }
    property :run_command, String, default: 'python -m celery -A UploadServer worker -l info'
    property :git_opts, Hash, default: lazy {
      {
        repository: 'https://github.com/EMSL-MSC/pacifica-uploader.git',
        destination: "#{prefix_dir}/#{service_name}"
      }
    }
    property :script_opts, Hash, default: lazy {
      {
        content: <<-EOH
#!/bin/bash
. #{prefix_dir}/bin/activate
export LD_LIBRARY_PATH=/opt/chef/embedded/lib:/opt/rh/python27/root/usr/lib64
export LD_RUN_PATH=/opt/chef/embedded/lib:/opt/rh/python27/root/usr/lib64
python DatabaseCreate.py
exec #{run_command}
EOH
      }
    }
    default_action :create
    action :create do
      extend PacificaCookbook::PacificaHelpers::Base
      include_recipe 'chef-sugar'
      base_packages
      base_directory_resources
      base_git_client
      base_git_repository
      base_python_runtime
      base_python_virtualenv
      base_python_execute_requirements
      base_file
      base_config
      base_poise_service
      base_service
    end
  end
end
