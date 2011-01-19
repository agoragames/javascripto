require 'javascripto'

module Javascripto
  module Rails
    module JavascriptoHelper

      # Register ui componenets for intialization and ensure requires files
      # are included in packages delievered to client.
      def app(*app_modules)
        self.app_modules.push *app_modules
        self.app_modules.compact!
        self.app_modules.uniq!
      end

      # Include files to be loaded directly.
      def javascript(*files)
        add_files(*files)
      end

      # Call To include require app_modules files.
      def require_app_modules
        add_files(*app_modules.map{ |app_module| "app/#{app_module}" })
      end

      # All Required Packages.
      def required_packages
        @required_packages ||= Javascripto::RequiredPackages.new
      end

      # App modules that need to be invoked.
      def app_modules
        @app_modules ||= []
      end

      private

      def add_files(*files)
        required_packages.add_files(*files)
      end
    end
  end
end

module ApplicationHelper
  include Javascripto::Rails::JavascriptoHelper
end

