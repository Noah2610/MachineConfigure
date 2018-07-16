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
        "Docker machine `#{name}' is not available."
      )  unless (docker_machine_exists? name)
    end

    # Check that the given <tt>name</tt>
    # does _not_ exist for docker-machine.
    def validate_no_machine_name name
      validate_app 'docker-machine'
      prompt_to_replace_docker_machine name  if (docker_machine_exists? name)
    end

    # Check that the given <tt>directories</tt> exist,
    # and are directories.
    def validate_directories *directories
      directories.flatten.each do |directory|
        validate_directory directory
      end
    end

    # Check that the given <tt>directories</tt> do *NOT* exist.
    def validate_directories_dont_exist *directories
      directories.flatten.each do |directory|
        validate_directory_doesnt_exist directory
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
      prompt_to_replace_file zip_file  if (is_file? zip_file)
    end

    # Similar to #validate_zip_file_export,
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

      def docker_machine_exists? name
        return system("docker-machine inspect #{name} &> /dev/null")
      end

      def validate_directory directory
        return  if (is_directory? directory)
        error(
          "Directory `#{directory.to_s}' does not exist or is a file."
        )
      end

      def validate_directory_doesnt_exist directory
        error(
          "Directory `#{directory.to_s}' already exists."
        )  if (is_directory?(directory) || is_file?(directory))
      end

      def is_directory? directory
        return File.directory? directory
      end

      def is_file? file
        return File.file? file
      end

      def prompt_to_replace_file file
        options = {
          overwrite: ?o,
          append:    ?a,
          nothing:   ?N
        }
        warning_print(
          "File `#{file.to_s}' already exists. What do you want to do?",
          "  Overwrite file? (Remove existing and create new archive.) [#{options[:overwrite]}]",
          "  Append content to existing archive? [#{options[:append]}]",
          "  Do nothing, abort. [#{options[:nothing]}]",
          "[#{options.values.join(?/)}] "
        )
        answer = STDIN.gets[0].strip.downcase
        case answer
        when options[:overwrite].downcase
          message "Overwriting archive `#{file.to_s}'."
          File.delete file
        when options[:append].downcase
          message "Appending to archive `#{file.to_s}'."
        when options[:nothing].downcase, ''
          message "Exiting."
          abort
        else
          prompt_to_replace_file file
          return
        end
      end

      def prompt_to_replace_docker_machine name
        options = {
          backup:    ?B,
          overwrite: ?o,
          nothing:   ?n
        }
        warning_print(
          "Docker machine `#{name}' already exists. What do you want to do?",
          "  Backup current configurations and create new one from import? [#{options[:backup]}]",
          "    (Backup to #{DM_BACKUP_PATH})",
          "  Overwrite existing files? [#{options[:overwrite]}]",
          "  Do nothing, abort. [#{options[:nothing]}]",
          "[#{options.values.join(?/)}] "
        )
        answer = STDIN.gets[0].strip.downcase
        case answer
        when options[:overwrite].downcase
          message "Overwriting existing configuration files for `#{name}'."
        when options[:backup].downcase, ''
          backup_docker_machine name
        when options[:nothing].downcase
          message "Exiting."
          abort
        else
          prompt_to_replace_docker_machine name
          return
        end
      end

      def backup_docker_machine name
        backup_name_date = "#{name}.#{Time.now.strftime('%Y-%m-%d')}"
        mk_backup_directories
        machine_path        = DM_MACHINES_PATH.join name
        cert_path           = DM_CERTS_PATH.join    name

        #backup_machine_path = DM_BACKUP_MACHINES_PATH.join backup_name_date
        #backup_cert_path    = DM_BACKUP_CERTS_PATH.join    backup_name_date

        backup_machine_path = backup_cert_path = nil
        backup_machine_path = get_backup_directory_for DM_BACKUP_MACHINES_PATH.join(backup_name_date)  if (machine_path.directory?)
        backup_cert_path    = get_backup_directory_for DM_BACKUP_CERTS_PATH.join(backup_name_date)     if (cert_path.directory?)

        msg = [ "Backing-up configuration files for `#{name}' to" ]
        msg << "  `#{backup_machine_path}'"  if (backup_machine_path)
        msg[-1] += ', and'                   if (backup_machine_path && backup_cert_path)
        msg << "  `#{backup_cert_path}'"     if (backup_cert_path)
        message msg
        FileUtils.mv machine_path, backup_machine_path  if (backup_machine_path)
        FileUtils.mv cert_path,    backup_cert_path     if (backup_cert_path)
      end

      def mk_backup_directories
        DM_BACKUP_MACHINES_PATH.mkpath  unless (DM_BACKUP_MACHINES_PATH.directory?)
        DM_BACKUP_CERTS_PATH.mkpath     unless (DM_BACKUP_CERTS_PATH.directory?)
      end

      def get_backup_directory_for base_backup_directory
        base_backup_directory = Pathname.new base_backup_directory  unless (base_backup_directory.is_a? Pathname)
        return base_backup_directory                                unless (base_backup_directory.directory?)
        base_backup_directory_tmp = base_backup_directory.dup
        counter = 0
        while (base_backup_directory_tmp.directory?)
          counter += 1
          base_backup_directory_tmp = Pathname.new "#{base_backup_directory.to_path}_#{counter}"
        end
        return base_backup_directory_tmp
      end
  end
end
