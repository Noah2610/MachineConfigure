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
        export: [['export']],
        import: [['import']]
      }
    }

    # The <tt>--help</tt> text.
    cli_name = DIR[:caller].basename
    HELP_TEXT = <<-END_HELP_TEXT
    USAGE
      $ #{cli_name} [--help|--version]
      $ #{cli_name} export --name [DOCKER_MACHINE_NAME] --zip [ZIP_FILE]
      $ #{cli_name} import --zip [ZIP_FILE]

    KEYWORDS
      export
        Export existing configuration files from
        a --name DOCKER_MACHINE_NAME to a --zip ZIP_FILE.
      import
        Import an exported --zip ZIP_FILE.

    OPTIONS
      --help -h
        Print this text and exit.
      --version -v
        Print the current version number and exit.
      --name -n [DOCKER_MACHINE_NAME]
        The name of an existing docker-machine instance.
        Use this with `export'.
      --zip -z [ZIP_FILE]
        The filepath to a (not necessarily existing) zip archive file.
        Use this with both `export' and `import'.

    EXAMPLES
      Export an existing docker-machine instance with the name "my_machine",
      to a new zip file "my_machine_configs.zip":
        $ #{cli_name} export --name my_machine --zip my_machine_configs
      Import a new docker-machine instance from
      the zip file "my_machine_configs.zip":
        $ #{cli_name} import --zip my_machine_configs.zip
    END_HELP_TEXT
  end
end
