require 'javascripto/package'

module Javascripto
  class File < Package

    # Define Constants
    JS = '.js' #extensions

    # File Repository
    @@files = {}
    @@path_lookup_cache = {}

    def self.js_root=(root)
      @@js_root = root
      @@load_path = ['lib', *Dir.glob(::File.join(@@js_root, "vendor/*")).map{|entry| "vendor/#{::File.basename(entry)}" } ]
    end

    attr_accessor :path, :package

    def initialize(path)
      @path = path
    end

    def file_dependencies
      if @file_dependencies
        return @file_dependencies
      end

      # Only scan up to 15 lines.
      lines = []
      ::File.open(@@js_root.join(@path + JS), "r") do |file|
        15.times do
          if line = file.gets
            lines << line
          else
            break
          end
        end
      end

      # Indentify required files
      required_files = lines.map do |line|
        match = /\s*^\/\/\s*require(.*)/.match(line)
        if match
          # Remove whitespace and break on comma for multiple files
          match.captures[0].strip.split(/\s*,\s*/)
        end
      end.flatten.compact.uniq

      @file_dependencies = required_files.map{ |required_file| File.get_file(required_file) }
    end

    # Return the file object instance.
    def self.get_file(file_path)

      # Expand the file path.
      file_path = expand_path(file_path)

      # Look for the file object.
      if @@files[file_path]
        return @@files[file_path]
      end

      # Otherwise create a new one.
      @@files[file_path] = File.new(file_path)
    end

    # Override Package Methods
    def package_files
      [self]
    end

    def package_name
      @path
    end

    def package_dependencies
      unless @package_dependencies
        @package_dependencies = []

        # For each file dependency
        file_dependencies.each do |dependency|
          # It it's not already in a package...
          unless dependency.package
            # ...Make it it's own package.
            dependency.package = dependency
          end
          # Add files_dependency package as a package dependency.
          @package_dependencies << dependency.package
        end
        # Remove duplicates.
        @package_dependencies.uniq!
      end
      @package_dependencies
    end

    private

    # Search load_path for file and return public path.
    def self.expand_path(file)
      if @@path_lookup_cache[file]
        return @@path_lookup_cache[file]
      end

      # Check Root.
      @@path_lookup_cache[file] = ::File.join(file) if @@js_root.join(file + JS).exist?
      return @@path_lookup_cache[file] if @@path_lookup_cache[file]

      # Search rest of load path.
      load_path.each do |path|
        @@path_lookup_cache[file] = ::File.join(path, file) if @@js_root.join(path, file + JS).exist?
        return @@path_lookup_cache[file] if @@path_lookup_cache[file]
      end

      raise ArgumentError.new "Could not find #{file + JS} in the load_path => #{load_path}."
    end

    def self.load_path
      @@load_path
    end

  end
end