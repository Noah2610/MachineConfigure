require 'argument_parser'
require 'pathname'
require 'zip'

module MachineCertManager
  entry_file = Pathname.new(__FILE__).realpath
  root       = entry_file.dirname

  DIR = {
    entry:   entry_file,
    root:    root,
    src:     root.join('lib/machine_cert_manager'),
    helpers: root.join('lib/machine_cert_manager/helpers')
  }

  require DIR[:src].join     'version'
  require DIR[:helpers].join 'error'
  require DIR[:src].join     'validator'
  require DIR[:src].join     'importer'
  require DIR[:src].join     'exporter'
  require DIR[:src].join     'cli'

  Validator.new.validate
end
