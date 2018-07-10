module MachineCertManager
  # This class should validate that dependencies are installed (docker-machine).
  class Validator
    include Helpers::Message
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

    # Check that the given <tt>zip_file</tt>
    # doesn't exist already but that the path leading
    # to the file does exist.
    def validate_zip_file_export zip_file
      path = File.dirname zip_file
      error(
        "The path to the zip file `#{path.to_path}' doesn't exist."
      )  unless (is_directory? path)
      ask_to_replace_file zip_file  if (is_file? zip_file)
    end

    # Similar to #validate_export_zip_file,
    # but don't prompt for overwriting, etc.
    # The zip file _has_ to exist in this case.
    def validate_zip_file_import zip_file
      error(
        "The zip file `#{zip_file.to_s}' doesn't exist or is a directory."
      )  unless (is_file? zip_file)
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
        return  if (is_directory? directory)
        error(
          "Directory `#{directory.to_s}' does not exist or is a file."
        )
      end

      def is_directory? directory
        return File.directory? directory
      end

      def is_file? file
        return File.file? file
      end

      def ask_to_replace_file file
        warning_print(
          "File `#{file.to_s}' already exists. What do you want to do?",
          "  Overwrite file? (Remove existing and create new archive.) [y]",
          "  Append content to existing archive? [a]",
          "  Do nothing, abort. [N]",
          "[y/a/N] "
        )
        answer = gets(1).strip.downcase
        case answer
        when ?y
          message "Overwriting archive `#{file.to_s}'"
          File.delete file
        when ?a
          message "Appending to archive `#{file.to_s}'"
        when ?n, ''
          message "Exiting."
          abort
        else
          ask_to_replace_file file
          return
        end
      end
  end
end
