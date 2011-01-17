require 'yaml'
require 'javascripto/file'
require 'javascripto/package'
require 'javascripto/required_packages'

# Client-side Javascript Application Framework
module Javascripto

  @@config = YAML.load_file(::Rails.root.join('config/Javascripto.yml'))

  package_config = @@config['packages'] || []
  # Auto require lib/application in the first packages, if there is no package, create one with
  # just lib/application. This will have the effect of making sure anything referenced in this file is
  # auto packaged in the first package as well as ensuring that lib/application is always packaged first.
  if package_config.first
    package_config.first.each_value do |value|
      value.unshift 'lib/application'
    end
  else
    package_config << {'defaults' => ['lib/application']}
  end

  # Build Packages
  package_config.each do |config|
    name, files = config.first.to_a
    Package.new(name, files.map{ |file| File.get_file(file) })
  end

end
