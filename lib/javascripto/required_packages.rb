require 'enumerator'
require 'javascripto/file'

module Javascripto
  class RequiredPackages
    include Enumerable

    def initialize
      @required_packages = []
    end

    def each
      @required_packages.each { |package| yield package }
    end

    def add_files(*file_paths)
      # Make sure config.js is included as first dependency, but only when somthing else has been added.
      if @required_packages.empty?
        file_paths.unshift 'config'
      end

      file_paths.each do |file_path|
        # Resolve the file object from the path.
        file = File.get_file(file_path)
        # If the file is not a part of a package...
        unless file.package
          # ...set itself as the package.
          file.package = file
        end
        require_package file.package
      end
    end

    private

    def require_package(package, stack = [])
      # Skip if the package is already included.
      unless @required_packages.include? package
        # If not, Resolve dependcies and interveve?
        package.package_dependencies.each do |dependency|
          unless stack.length > 5
            require_package(dependency, stack << package)
            stack.pop
          else
            raise RuntimeError.new("Failed to resolve package dependecies before reaching recurison limit of 5. Stack: #{stack.map{ |item| item.package_name }} ")
          end
        end
        @required_packages << package
      end
    end

  end
end