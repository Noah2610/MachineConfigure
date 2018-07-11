module MachineCertManager
  module Helpers
    module Shared
      private

        # Returns the path to the docker-machine's <tt>'config.json'</tt> file,
        # but without the prefixed path leading to the DM_MACHINES_PATH.
        def get_config_json_path
          return nil  unless (@machine_name)
          config_json_path = remove_storage_path_from DM_MACHINES_PATH.join(@machine_name, 'config.json').to_path
        end

        # Returns the <tt>filepath</tt> without DM_STORAGE_PATH.
        def remove_storage_path_from filepath
          return filepath.to_s.sub("#{DM_STORAGE_PATH.to_path}/", '')
        end

        # Replaces any occurences of the user's
        # home directory path with HOME_REPLACE_STRING.
        def remove_home_in string
          return string.gsub(HOME, HOME_REPLACE_STRING)
        end

        # Replaces any occurences of HOME_REPLACE_STRING
        # with the user's home directory path.
        def insert_home_in string
          return string.gsub(HOME_REPLACE_STRING, HOME)
        end
    end
  end
end
