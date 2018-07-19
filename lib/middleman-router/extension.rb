# Require core library
require 'middleman-core'
require 'mapper'

# Extension namespace
class Router < ::Middleman::Extension
  option :routes_location, 'lib/routes'

  @app = nil

  def initialize(app, options_hash={}, &block)
    puts "loaded!"
    super

    @app = app
    require options.routes_location
  end

  def after_configuration
    # Do something
  end

  class << self
    def draw(&block)
      mapper = Mapper.new(self)
      mapper.instance_exec(&block)
      nil
    end

    def add_route(path_name, path_url)
      puts "#{path_name} => #{path_url}"
      define_singleton_method(path_name) do |*args|
        url(path_url, args.first)
      end

      self.expose_to_template << path_name
    end

    private

    def url(path, *args)
      options = args.first

      if options
        path = "#{path}?#{options.to_query}"
      end

      path
    end
  end
end
