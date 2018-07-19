require "middleman-core"

Middleman::Extensions.register :router do
  require "middleman-router/extension"
  puts "loading router..."
  Router
end
