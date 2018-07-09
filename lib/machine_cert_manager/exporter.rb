module MachineCertManager
  # The Exporter is responsible for finding all
  # necessary certificates for a given docker-machine,
  # and bundle them all into a single zip archive.
  class Exporter
    DM_STORAGE_PATH  = Pathname.new(File.join(Dir.home, '.docker/machine'))  # Pathname.new(ENV['MACHINE_STORAGE_PATH']).realpath
    DM_MACHINES_PATH = DM_STORAGE_PATH.join 'machines'
    DM_CERTS_PATH    = DM_STORAGE_PATH.join 'certs'

    # Initialize with a docker-machine <tt>name</tt>.
    def initialize name
      @machine_name = name
      VALIDATOR.validate_machine_name name
      @dir = {
        machine: DM_MACHINES_PATH.join(@machine_name),
        certs:   DM_CERTS_PATH.join(@machine_name)
      }
      VALIDATOR.validate_directories @dir.values
    end

    # Export certificates for the machine.
    def export
      files    = get_files
      contents = get_contents_from_files *files
    end

    private

      def get_files
        return @dir.values.map do |dir|
          next get_files_recursively_from dir
        end .flatten
      end

      def get_files_recursively_from directory
        dir = Pathname.new directory
        return dir.each_child.map do |file|
          next file.realpath.to_path            if (file.file?)
          next get_files_recursively_from file  if (file.directory?)
        end .flatten
      end

      def get_contents_from_files *files
        return files.flatten.map do |filename|
          file = Pathname.new filename
          next [file.to_path, file.read]
        end .to_h
      end
  end
end
