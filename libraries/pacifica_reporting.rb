# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base_php'
  # installs and configures pacifica cart frontend wsgi
  class PacificaReporting < PacificaBasePhp
    resource_name :pacifica_reporting

    property :name, String, name_property: true
    property :git_opts, Hash, default: {
      repository: 'https://github.com/EMSL-MSC/pacifica-reporting.git',
    }
    property :ci_prod_configs, Hash, default: {
      config: %q(
      $config['log_threshold'] = 0;
      $config['base_url'] = "http://127.0.0.1";
      $config['local_timezone'] = "UTC";
      ),
      database: %q{
      $db['default'] = array(
        'hostname' => "127.0.0.1",
        'username' => "reporting",
        'password' => "reporting",
        'database' => "pacifica_reporting",
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
