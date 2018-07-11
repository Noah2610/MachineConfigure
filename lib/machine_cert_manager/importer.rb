module MachineCertManager
  # The Importer takes a zip file,
  # processes the files,
  # and extracts them into the proper directories.
  class Importer
    include Helpers::Message
    include Helpers::Shared

    def initialize
      @contents     = nil
      @machine_name = nil
    end

    # Import given <tt>zip_file</tt>
    # as a new docker-machine.
    def import_from zip_file
      VALIDATOR.validate_zip_file_import zip_file
      @contents     = get_contents_from_zip zip_file
      @machine_name = @contents[MACHINE_NAME_FILENAME]
      @contents.delete MACHINE_NAME_FILENAME
      @dir = {
        machine: DM_MACHINES_PATH.join(@machine_name),
        certs:   DM_CERTS_PATH.join(@machine_name)
      }
      VALIDATOR.validate_directories_dont_exist *@dir.values
      config_json_path = get_config_json_path
      @contents[config_json_path] = insert_home_in @contents[config_json_path]
      write_contents
    end

    private

      # Reads the <tt>zip_file</tt> and returns
      # a Hash with each file's path as the key
      # and the file's content as the value.
      def get_contents_from_zip zip_file
        contents = {}
        Zip::File.open(zip_file) do |zip|
          zip.each_entry do |entry|
            entry.get_input_stream do |entryfile|
              contents[entry.name] = entryfile.read
            end
          end
        end
        return contents
      end

      # Write <tt>@contents</tt> to proper paths.
      def write_contents
        @contents.each do |relative_filepath, content|
          filepath = DM_STORAGE_PATH.join relative_filepath
          filedir  = filepath.dirname
          filedir.mkpath     unless (filedir.directory?)
          permission = 0644
          permission = 0600  if (filepath.basename.to_path == 'id_rsa')
          file = File.open filepath.to_path, ?w, permission
          file.write content
          file.close
        end
      end
  end
end
