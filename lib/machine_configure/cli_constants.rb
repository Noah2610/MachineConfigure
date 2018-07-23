module MachineConfigure
  module CLIConstants
    # Hash containing all valid arguments,
    # which may be passed to the CLI.
    VALID_ARGUMENTS = {
      single: {
        help: [
          [?h],
          false
        ],
        version: [
          [?v],
          false
        ],
        name: [
          [?n],
          true
        ],
        zipfile: [
          [?z],
          true
        ]
      },
      double: {
        help: [
          ['help'],
          false
        ],
        version: [
          ['version'],
          false
        ],
        name: [
          ['name'],
          true
        ],
        zipfile: [
          ['zip'],
          true
        ]
      },
      keywords: {
        export: [['export', ?e], :INPUT, :INPUTS],
        import: [['import', ?i], :INPUTS]
      }
    }

    # The <tt>--help</tt> text.
    cli_name = DIR[:caller].basename
    HELP_TEXT = <<-END_HELP_TEXT
USAGE
  $ #{cli_name} [--help|--version]
  $ #{cli_name} export DOCKER_MACHINE_NAME [ZIP_FILE]
  $ #{cli_name} import ZIP_FILE

KEYWORDS
  export
    Export existing configuration files from
    the docker-machine instance DOCKER_MACHINE_NAME.
    Optionally, add a ZIP_FILE name.
  import
    Import an exported ZIP_FILE.

OPTIONS
  --help -h
    Print this text and exit.
  --version -v
    Print the current version number and exit.

EXAMPLES
  Export an existing docker-machine instance with the name "my_machine",
  to a new zip file "my_machine.zip":
    $ #{cli_name} export my_machine
  The same as above, but specify the output zip file name:
    $ #{cli_name} export my_machine my_machine_configs
  Import a new docker-machine instance from
  the zip file "my_machine_configs.zip":
    $ #{cli_name} import my_machine_configs.zip
    END_HELP_TEXT
  end
end
