module MachineCertManager
  # The Importer takes a zip file,
  # processes the files,
  # and extracts them into the proper directories.
  class Importer
    # Initialize with the path to a <tt>zip_file</tt>.
    def initialize zip_file
      VALIDATOR.validate_zip_file_import zip_file
      @zip_file = zip_file
    end

    def import
    end
  end
end
