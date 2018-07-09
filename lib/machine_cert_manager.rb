require 'argument_parser'
require 'pathname'

module MachineCertManager
  root = Pathname.new(__FILE__).realpath.dirname

  DIR = {
    root: root,
    src:  root.join('lib/machine_cert_manager')
  }

  require DIR[:src].join 'version'
  require DIR[:src].join 'importer'
  require DIR[:src].join 'exporter'
  require DIR[:src].join 'cli'
end
