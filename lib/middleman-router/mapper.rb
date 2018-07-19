class Mapper
  # A Resource class for a route. Basically just a way
  # to hold data for a route
  class Resource
    attr_accessor :name, :route_name, :path, :enabled

    def initialize(options={})
      @name       = options[:name]
      @route_name = options[:route_name]
      @path       = options[:path]
      @enabled    = options[:enabled]
    end

    def enabled?
      @enabled == true
    end
  end

  # Initialize the Mapper
  def initialize(set)
    @set = set
    @resources = []
  end

  # Route
  # Creates a new route and any child routes
  #
  # Usage: route :about_us, path: "about-us", as: "about"
  def route(*args, &block)
    resource = build_resource(args, @scope)

    if resource.enabled?
      @set.add_route(resource.route_name, resource.path)
    end

    # If a block is passed, then let's create routes
    # for each child route in the block
    #
    if block_given?
      previous_scope = @scope
      @scope = resource

      self.instance_exec(&block)

      @scope = previous_scope
    end
  end

  private

  # Create a Resource for the route
  def build_resource(args, scope=nil)
    options         = args.last.is_a?(::Hash) ? args.pop : {}
    options[:scope] = scope if scope
    enabled         = !(options[:index] == false)
    route           = args.first

    # Set the route attributes, name, path, etc
    name       = named(route, options)
    route_name = named_route(route, options)
    path       = url_route(route, options)

    # Create and return the route resource
    Resource.new(
      name:       name,
      route_name: route_name,
      path:       path,
      enabled:    enabled
    )
  end

  # Returns the named_route that can be access as a
  # global helper on the front-end
  def named_route(route_name, options={})
    label = named(route_name, options)
    # Return it as a underscored symbol
    "#{label}_path".underscore.to_sym
  end

  def named(route_name, options={})
    # User can override the name
    if options[:as]
      route_name = options[:as]
    end

    # If there is a parent/scope, then let's prepend
    # that route to the named_route
    if options[:scope]
      route_name = "#{route_name}_#{options[:scope].name}"
    end

    route_name
  end

  # Return the URL fro the route
  def url_route(route_name, options={})
    if options[:url]
      return options[:url]
    end

    # Ability to customize this
    if options[:path]
      if options[:path].empty?
        return "/"
      else
        path = options[:path]
      end
    else
      path = route_name
    end

    # Nest under a parent/scope route if required
    if options[:scope]
      path = "#{options[:scope].path}#{parameterize(path)}"
    else
      path = "/#{parameterize(path)}"
    end

    "#{path}/"
  end

  # Parameterize a string
  def parameterize(string)
    string = string.to_s

    # Turn unwanted chars into the separator.
    string.gsub!(/[^a-z0-9\-_]+/i, '-')
    string.downcase!

    string
  end
end
