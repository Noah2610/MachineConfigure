module MachineCertManager
  class CLI
    include Helpers::Message
    include CLIConstants

    def initialize
      Helpers::Message.error_no_stack_trace!
      @arguments = nil
    end

    # Parses given command-line arguments,
    # and sets proper settings.
    def run
      @arguments = ArgumentParser.get_arguments VALID_ARGUMENTS
      print_help     if (@arguments[:options][:help])
      print_version  if (@arguments[:options][:version])
      if    (@arguments[:keywords][:export])
        handle_export
      elsif (@arguments[:keywords][:import])
        handle_import
      else
        print_help
      end
    end

    private

      def print_help
        puts HELP_TEXT
        exit
      end

      def print_version
        puts "#{PROGRAM_NAME} v#{VERSION}"
        exit
      end

      def handle_export
        verify_options :name, :zipfile
        dm_name = @arguments[:options][:name]
        zipfile = @arguments[:options][:zipfile]
        exporter = Exporter.new dm_name
        exporter.export_to zipfile
      end

      def handle_import
        verify_options :zipfile
        zipfile = @arguments[:options][:zipfile]
        importer = Importer.new
        importer.import_from zipfile
      end

      def verify_options *option_names
        option_names.flatten.each do |option_name|
          unless (@arguments[:options][option_name])
            error(
              "Option `--#{VALID_ARGUMENTS[:double][option_name].first.first}' must be given."
            )
          end
        end
      end
  end
end
