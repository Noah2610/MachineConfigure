# MachineCertManager
Export or import your docker-machine's configuration files,  
and share them with others.

## Table of Contents _(Generated)_
- [Description](#description)
- [Installation](#installation)
  - [Install manually](#install-manually)
- [Usage](#usage)
  - [Exporting](#exporting)
    - [Example](#example)
  - [Importing](#importing)
    - [Example](#example)
- [TODO](#todo)
- [License](#license)

## Description
This gem is heavily inspired by [machine-share][machine-share-site],  
a nodejs package, which does basically the same thing as this gem.  
I just had some minor inconveniences with it,  
so I decided I would write my own version in Ruby.

If you use [docker-machine][docker-machine-site], this might come in handy,  
if you ever want to share your remote docker-machine instance  
with a collegue or across multiple machines.

With this gem, you can export your configuration files for a specific  
docker-machine instance into a zip file. You can then share the created  
zip file with others / other computers and import it again.

## Installation
__ATTENTION:  
The gem is not yet available on rubygems.org, this is still a todo.__

Install from [rubygems][rubygems-site] with ...

```
$ gem install machine_cert_manager
```

### Install manually
If you want to install the gem manually from this repository directly,  
you'll need to:

- Clone the repository,
- install all dependencies,
- build the gem, and
- install it.

Here's a command to copy/paste, it does all of the above ...

```
git clone https://github.com/Noah2610/MachineCertManager.git && \
cd MachineCertManager && \
bundle install --with development && \
rake build && \
gems=($(ls pkg/machine_cert_manager-*)); \
gem install "${gems[-1]}"; \
unset gems
```

Once this completes, you should have the gem installed.  
You can try using it by executing `macema`.

## Usage
### Exporting
To export the configurations of an existing docker-machine instance,  
use the `export` keyword, pass the machine's name with `--name`,  
and the output zip file with `--zip`.
#### Example

```
$ macema export --name my_machine --zip my_machine_configs.zip
$ macema export -n     my_machine -z    my_machine_configs.zip
```

### Importing
To import a docker-machine's configuration files from a zip file,  
use the `import` keyword, and pass the target zip file with `--zip`.
#### Example

```
$ macema import --zip my_machine_configs.zip
$ macema import -z    my_machine_configs.zip
```

For all command-line options, see `--help`.

---

## TODO
See the [Trello Board][trello-site] for open tasks.

## License
The gem is available as open source under the terms of the [MIT License][mit-site].

[machine-share-site]:  https://github.com/bhurlow/machine-share
[docker-machine-site]: https://docs.docker.com/machine
[rubygems-site]:       https://rubygems.org/gems/machine_cert_manager
[trello-site]:         https://trello.com/b/ZVdArdrk
[mit-site]:            https://opensource.org/licenses/MIT
