# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base_php'
  # installs and configures pacifica cart frontend wsgi
  class PacificaStatus < PacificaBasePhp
    resource_name :pacifica_status

    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/EMSL-MSC/pacifica-upload-status.git',
    }
    property :ci_prod_configs, Hash, default: {
      config: %q(
$config['log_threshold'] = 0;
$config['base_url'] = "http://localhost";
$config['local_timezone'] = "UTC";
      ),
      database: %q{
$db['default'] = array(
  'hostname' => "127.0.0.1",
  'username' => "status",
  'password' => "status",
  'database' => "pacifica_status",
  'dbdriver' => "mysqli",
  'dbprefix' => "",
  'pconnect' => TRUE,
  'db_debug' => FALSE,
  'cache_on' => TRUE,
  'cachedir' => "/tmp"
);
      },
    }
  end
end
