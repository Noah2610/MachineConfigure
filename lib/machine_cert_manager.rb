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

  # This string will be used as the filename for an
  # additional file, which will only have the machine name in it.
  MACHINE_NAME_FILENAME = 'MACHINE_NAME'

  # The path to the docker-machine storage directory.
  # <tt>$MACHINE_STORAGE_PATH</tt> or <tt>'~/.docker/machine'</tt>.
  DM_STORAGE_PATH = (ENV['MACHINE_STORAGE_PATH'] ? (
    Pathname.new(ENV['MACHINE_STORAGE_PATH'].chomp(?/)).realpath
  ) : (
    Pathname.new(File.join(HOME, '.docker/machine'))
  ))
  # The path to the docker-machine <tt>'machines'</tt> directory.
  DM_MACHINES_PATH = DM_STORAGE_PATH.join 'machines'
  # The path to the docker-machine <tt>'certs'</tt> directory.
  DM_CERTS_PATH = DM_STORAGE_PATH.join 'certs'

  require DIR[:src].join     'version'
  require DIR[:helpers].join 'shared'
  require DIR[:helpers].join 'message'
  require DIR[:src].join     'validator'
  require DIR[:src].join     'exporter'
  require DIR[:src].join     'importer'
  require DIR[:src].join     'cli'

  VALIDATOR = Validator.new
  VALIDATOR.validate_base_apps
end
