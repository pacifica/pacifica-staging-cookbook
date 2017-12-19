# pacifica cookbook module
module PacificaCookbook
  # installs and configures pacifica ingest backend celery
  class PacificaUploaderBackend < PacificaBase
    resource_name :pacifica_uploaderbackend
    property :name, String, name_property: true
    property :config_name, Hash, default: lazy { "#{name}/UploaderConfig.json" }
    property :pip_install_opts, Hash, default: lazy {
      {
        command: "-m pip install -r #{prefix_dir}/#{name}/requirements.txt"
      }
    }
    property :service_opts, Hash, default: lazy {
      {
        directory: "#{prefix_dir}/#{name}",
        environment: {
          VOLUME_PATH: "#{prefix_dir}/#{name}/uploaderdata",
          BROKER_VHOST: "/uploader",
        },
      }
    }
    property :config_opts, Hash, default: {
      variables: {
        content: '{}'
      }
    }
    property :run_command, String, default: 'python -m celery -A UploadServer worker -l info'
    property :git_opts, Hash, default: lazy {
      {
        repository: 'https://github.com/EMSL-MSC/pacifica-uploader.git',
        destination: "#{prefix_dir}/#{name}"
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
