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


      # All Required Packages.
      def required_packages
        @required_packages ||= Javascripto::RequiredPackages.new
      end

      # App modules that need to be invoked.
      def app_modules
        @app_modules ||= []
      end

      def javascripto_include

        # Require App Modules
        add_files(*app_modules.map{ |app_module| "app/#{app_module}" })

        content = []

        # Render Packages
        if required_packages.any?
          required_packages.each do |package|
            if package.cache
              content << javascript_include_tag(package.package_files.map{ |file| file.resource_path }, :cache => package.package_name)
            else
              content << javascript_include_tag(package.package_files.map{ |file| file.resource_path })
            end
          end
        end

        # Render Initializers
        if app_modules.any?
          content << content_tag('script', (app_modules.map{ |m| "\n  $(app.#{m});" } << "\n").join(),'type' => Mime::JS)
        end

        content.join("\n").html_safe
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

