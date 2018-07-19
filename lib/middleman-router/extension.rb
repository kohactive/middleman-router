# Require core library
require 'middleman-core'
require 'middleman-router/mapper'

# TODO
# -[ ] Auto reload the routes when they are updated
# -[ ] index: false should work
# -[ ] Refactor so "Router.path_name" is not required, only 'path_name'
# -[ ] Ability to print out all routes, e.g. `rake routes`
# -[ ] Ability to add "/" at the end of each route

# Extension namespace
class Router < ::Middleman::Extension
  option :routes_location, 'lib/routes'

  @app = nil

  def initialize(app, options_hash={}, &block)
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
