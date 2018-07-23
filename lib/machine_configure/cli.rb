module MachineConfigure
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
        puts "#{GEM_NAME} v#{VERSION}"
        exit
      end

      def handle_export
        verify_keywords_export
        dm_name = @arguments[:keywords][:export][1]
        zipfile = @arguments[:keywords][:export][2]
        zipfile = get_zipfile_from_name dm_name  unless (zipfile)
        exporter = Exporter.new dm_name
        exporter.export_to zipfile
      end

      def handle_import
        verify_keywords_import
        zipfile = @arguments[:keywords][:import][1]
        importer = Importer.new
        importer.import_from zipfile
      end

      def verify_options *option_names
        option_names.flatten.each do |option_name|
          error(
            "Option `--#{VALID_ARGUMENTS[:double][option_name].first.first}' must be given."
          )  unless (@arguments[:options][option_name])
        end
      end

      def verify_keywords_export
        error(
          "Missing argument DOCKER_MACHINE_NAME for #{VALID_ARGUMENTS[:keywords][:export].first.first}."
        )  unless (@arguments[:keywords][:export][1])
        verify_keyword_size_for :export
      end

      def verify_keywords_import
        error(
          "Missing argument ZIP_FILE for #{VALID_ARGUMENTS[:keywords][:import].first.first}.",
          "See --help for more information."
        )  unless (@arguments[:keywords][:import][1])
        verify_keyword_size_for :import
      end

      def verify_keyword_size_for keyword_name
        target_size = VALID_ARGUMENTS[:keywords][keyword_name].size
        given_size  = @arguments[:keywords][keyword_name].size
        if (given_size > target_size)
          extra_arguments = @arguments[:keywords][keyword_name][target_size .. -1]
          error(
            "Invalid argument#{extra_arguments.size > 1 ? ?s : ''} `#{extra_arguments.join(', ')}'"
          )
        end
      end

      def get_zipfile_from_name dm_name
        return "#{dm_name}.zip"
      end
  end
end
