# pacifica cookbook module
module PacificaCookbook
  # installs and configures pacifica ingest frontend wsgi
  class PacificaUploaderFrontend < PacificaBase
    resource_name :pacifica_uploaderfrontend
    property :name, String, name_property: true
    property :service_name, String, default: lazy { "#{name}-#{self.class.name.gsub(/^.*::/, '')}" }
    property :script_name, String, default: lazy { "#{service_name}" }
    property :config_name, Hash, default: lazy { "#{service_name}/UploaderConfig.json" }
    property :pip_install_opts, Hash, default: lazy {
      {
        command: "-m pip install -r #{prefix_dir}/#{service_name}/requirements.txt",
      }
    }
    property :service_opts, Hash, default: lazy {
      {
        directory: "#{prefix_dir}/#{service_name}",
        environment: {
          VOLUME_PATH: "#{prefix_dir}/#{service_name}/uploaderdata",
          BROKER_VHOST: '/uploader',
        },
      }
    }
    property :config_opts, Hash, default: {
      variables: {
        content: '{}'
      }
    }
    property :run_command, String, default: lazy { "python manage.py runserver 127.0.0.1:#{port}" }
    property :port, Integer, default: 8000
    property :git_opts, Hash, default: lazy {
      {
        repository: 'https://github.com/EMSL-MSC/pacifica-uploader.git',
        destination: "#{prefix_dir}/#{service_name}"
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
