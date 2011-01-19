require 'javascripto/file'
require 'javascripto-rails/javascripto_helpers'

module Javascripto
  module Rails
    class Railtie < ::Rails::Railtie
      config.before_configuration do
        module ::Javascripto

          @@config = YAML.load_file(::Rails.root.join('config/javascripto.yml'))

          Javascripto::File.js_root = ::Rails.root.join('public/javascripts')

          package_config = @@config['packages'] || []
          # Auto require config in the first packages, if there is no package, create one with
          # just config. This will have the effect of making sure anything referenced in this file is
          # auto packaged in the first package as well as ensuring that config is always packaged first.

          if package_config.first
            package_config.first.each_value do |value|
              value.unshift 'config'
            end
          else
            package_config << {'defaults' => ['config']}
          end

          # Build Packages
          package_config.each do |config|
            name, files = config.first.to_a
            Package.new(name, files.map{ |file| File.get_file(file) })
          end
        end
      end
    end
  end
end
