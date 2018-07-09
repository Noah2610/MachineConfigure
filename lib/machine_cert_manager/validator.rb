module MachineCertManager
  # This class should validate that dependencies are installed (docker-machine).
  class Validator
    include Helpers::Error
    # Default command-line apps,
    # which need to be available.
    BASE_APPS = [
      'docker-machine'
    ]

    def initialize
      @validated_apps = []
    end

    # Calls #validate_apps for BASE_APPS.
    def validate_base_apps
      validate_apps *BASE_APPS
    end

    # Check if given <tt>apps</tt> (or default BASE_APPS),
    # are available from the command-line.
    # Throw an error and exit if any aren't available.
    def validate_apps *apps
      apps.flatten.each do |appname|
        validate_app appname
      end
    end

    # Check that the given <tt>name</tt>
    # exists for docker-machine.
    def validate_machine_name name
      validate_app 'docker-machine'
      error(
        "Docker machine #{name} is not available."
      )  unless (system("docker-machine inspect #{name} &> /dev/null"))
    end

    # Check that the given <tt>directories</tt> exist,
    # and are directories.
    def validate_directories *directories
      directories.flatten.each do |directory|
        validate_directory directory
      end
    end

    private

      def validate_app appname
        return  if (@validated_apps.include? appname)
        if (app_available? appname)
          @validated_apps << appname
          return
        end
        error(
          "`#{appname}' is not available.",
          "Please make sure you have it installed."
        )
      end

      def app_available? name
        return system("which #{name} &> /dev/null")
      end

      def validate_directory directory
        return  if (valid_directory? directory)
        error(
          "Directory #{directory.to_s} does not exist or is a file."
        )
      end

      def valid_directory? directory
        return File.directory? directory
      end
  end
end
