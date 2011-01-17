module Javascripto
  class Package

    attr_reader :package_name, :package_files, :package_dependencies

    def initialize(package_name, files)
      @package_name = package_name
      @package_files, @package_dependencies = [], []
      files.each do |file|
        add_file_and_dependencies(file)
      end
    end

    def add_file_and_dependencies(file, stack = [])
       # If the file is already contained in another package
      if file.package
        # ..add the other package as a dependency...
        @package_dependencies << file.package unless self == file.package
      else
        # ...otherwise, add this file and all of its unpackaged dependecies to this package.
        file.file_dependencies.each do |dependency|
          add_file_and_dependencies(dependency, stack << file)
        end
        @package_files << file
        file.package = self
      end
    end
  end
end
