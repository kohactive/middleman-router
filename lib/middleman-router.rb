require "middleman-core"

Middleman::Extensions.register(:router) do
  require "middleman-router/extension"
  Router
end
