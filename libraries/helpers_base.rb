# Pacifica Cookbook Modules
module PacificaCookbook
  # Pacifica Cookbook Helpers
  module PacificaHelpers
    # Helpers to call within the base action
    module Base
      def base_git_repository
        git new_resource.name do
          git_opts.each do |attr, value|
            send(attr, value)
          end
        end
      end
    end
  end
end
