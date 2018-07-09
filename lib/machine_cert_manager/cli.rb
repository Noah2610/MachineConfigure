module MachineCertManager
  class CLI
    # Hash containing all valid arguments,
    # which may be passed to the CLI.
    VALID_ARGUMENTS = {
      single:   {},
      double:   {},
      keywords: {}
    }

    def initialize
      @arguments = nil
    end

    # Parses given command-line arguments,
    # and sets proper settings.
    def run
      @arguments = ArgumentParser.get_arguments VALID_ARGUMENTS
    end
  end
end
