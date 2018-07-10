require 'argument_parser'
require 'pathname'
require 'zip'

require 'byebug'

module MachineCertManager
  entry_file = Pathname.new(__FILE__).realpath
  root       = entry_file.dirname

  HOME = Dir.home.chomp ?/
  DIR = {
    entry:   entry_file,
    root:    root,
    src:     root.join('machine_cert_manager'),
    helpers: root.join('machine_cert_manager/helpers')
  }

  # This constant will replace any occurences of
  # the user's home directory path in the
  # docker-machine's config.json file.
  HOME_REPLACE_STRING = '<REPLACE_WITH_HOME>'

  require DIR[:src].join     'version'
  require DIR[:helpers].join 'message'
  require DIR[:src].join     'validator'
  require DIR[:src].join     'importer'
  require DIR[:src].join     'exporter'
  require DIR[:src].join     'cli'

  VALIDATOR = Validator.new
  VALIDATOR.validate_base_apps
end
