require 'bundler/setup'
require 'fileutils'
require 'pathname'
require 'zip'

module MachineConfigure
  entry_file = Pathname.new(__FILE__).realpath
  root       = entry_file.dirname

  HOME = Dir.home.chomp ?/
  DIR = {
    caller:  Pathname.new($0).realpath,
    entry:   entry_file,
    root:    root,
    src:     root.join('machine_configure'),
    helpers: root.join('machine_configure/helpers')
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
  # The paths for the machines backup directories <em>(Created by this script.)</em>.
  DM_BACKUP_PATH          = DM_STORAGE_PATH.join("#{DIR[:caller].basename}.backup")
  DM_BACKUP_MACHINES_PATH = DM_BACKUP_PATH.join('machines')
  DM_BACKUP_CERTS_PATH    = DM_BACKUP_PATH.join('certs')

  require DIR[:src].join     'meta'
  require DIR[:root].join    'argument_parser'
  require DIR[:helpers].join 'shared'
  require DIR[:helpers].join 'message'
  require DIR[:src].join     'validator'
  require DIR[:src].join     'exporter'
  require DIR[:src].join     'importer'
  require DIR[:src].join     'cli_constants'
  require DIR[:src].join     'cli'

  VALIDATOR = Validator.new
  VALIDATOR.validate_base_apps
end
