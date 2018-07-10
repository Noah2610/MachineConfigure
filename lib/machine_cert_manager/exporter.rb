module MachineCertManager
  # The Exporter is responsible for finding all
  # necessary certificates for a given docker-machine,
  # and bundle them all into a single zip archive.
  class Exporter
    include Helpers::Message

    # Initialize with a docker-machine <tt>name</tt>.
    def initialize name
      @machine_name = name
      VALIDATOR.validate_machine_name name
      @dir = {
        machine: DM_MACHINES_PATH.join(@machine_name),
        certs:   DM_CERTS_PATH.join(@machine_name)
      }
      VALIDATOR.validate_directories @dir.values
      @contents = nil
    end

    # Export certificates for the machine.
    def export_to zip_file
      VALIDATOR.validate_zip_file_export zip_file
      files     = get_files
      @contents = get_contents_from_files(*files)
      config_json_path = remove_storage_path_from DM_MACHINES_PATH.join(@machine_name, 'config.json').to_path
      @contents[config_json_path] = replace_home_in @contents[config_json_path]
      write_zip_file_to zip_file
      message(
        "Successfully created zip archive",
        "  `#{zip_file.to_s}'",
        "with the keys and certificates from docker-machine",
        "  `#{@machine_name}'"
      )
    end

    private

      # Returns all necessary filepaths.
      def get_files
        return @dir.values.map do |dir|
          next get_files_recursively_from dir
        end .flatten
      end

      # Returns all filepaths from <tt>directory</tt>, recursively.
      def get_files_recursively_from directory
        dir = Pathname.new directory
        return dir.each_child.map do |file|
          next file.realpath.to_path            if (file.file?)
          next get_files_recursively_from file  if (file.directory?)
        end .flatten
      end

      # Reads contents from <tt>files</tt>, and returns
      # a Hash with the file's filepath as the key and
      # the file's content as the value.
      # The filepath key is the absolute path to the file,
      # but _without_ the DM_STORAGE_PATH.
      def get_contents_from_files *files
        return files.flatten.map do |filename|
          file    = Pathname.new filename
          content = file.read
          path    = remove_storage_path_from file.to_path
          next [path, content]
        end .to_h
      end

      # Returns the <tt>filepath</tt> without DM_STORAGE_PATH.
      def remove_storage_path_from filepath
        return filepath.to_s.sub("#{DM_STORAGE_PATH.to_path}/", '')
      end

      # Replaces any occurences of the user's
      # home directory path with HOME_REPLACE_STRING.
      def replace_home_in string
        return string.gsub(HOME, HOME_REPLACE_STRING)
      end

      # Write the processed <tt>@contents</tt> to
      # a zip archive using Zip.
      def write_zip_file_to zip_file
        Zip::File.open(zip_file, Zip::File::CREATE) do |zip|
          @contents.each do |filepath, content|
            zip.get_output_stream(filepath) do |zipfile|
              zipfile.write content
            end
          end
        end
      end
  end
end
