module Javascripto
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root ::File.expand_path("../templates", __FILE__)

      def generate
        copy_file         'config/javascripto.yml', 'config/javascripto.yml'
        directory         'public/javascripts'
        empty_directory   'public/javascripts/app'
        empty_directory   'public/javascripts/lib'
      end
    end
  end
end