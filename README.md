# Middleman Router

`middleman-router` is an extension of Middleman that provides an easy way to organize and manage all of your page routes.

## Install

Add this line to your application's Gemfile:

```
gem 'middleman-router'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install middleman-robots
```

Activate the plugin in the config.rb file

```
# config.rb
activate :router
```

By default, your routes should be stored in `lib/routes.rb` but you can customize the location if you'd like:

```
# config.rb
activate :router, routes_location: 'routes/routes'
```

## Defining Your Routes

In order to use Middlman Router, you need to setup your routes files.

```ruby
# lib/routes.rb
Router.draw do
  route :home, path: ""
  route :about
  route :contact

  route :services do
    route :strategy, path: "digital-strategy"
    route :design
    route :development, path: "web-development"
    route :search
  end

  route :careers, url: "https://external-link.jobboard.com"
end
```

## Using Routes

Once you've defined all of your routes in your routes file, you can easily call any named route by using the helper. If you have a named route of `route :about` then you can simply call:

```ruby
= link_to "About Us", Router.about_path
```

When the site is compiled, it will render the URL from your route. If you change a route within your routes file then there is no need to change the route helper declaration unless you change the named route (e.g. you changed `route :about` to `route :about_us`.

For nested routes, you'll need to use the parent named route as part of the path, e.g.:

```ruby
# lib/routes.rb
route :about do
  route :team
end

# html/erb file
= link_to "Team", Router.team_about_path
```

## Route Attributes

Defining a `route` is the base for creating a new route. There are a few options you can pass to `route` to customize it.

**name**
The name of the route is the only required attribute.

```ruby
route :about_us
```

This will create a route like `about_us` and point to the file `about_us.html`.

**path**
You can customize the file that a give route loads. This is useful if you prefer hypenated urls rather than snake case.

```ruby
route :about_us, path: "about-us"
```

This will look for a file `about-us.html` for the given route. You can point any route to whatever file or directory that you want.

```ruby
route :about_us, path: "about/about-company"
```
**url**
You can have routes that link to external endpoints, simple add the `url` attribute to your route:

```ruby
route :client_login, url: "https://link-to-external-site.com"
```

**Nested Paths**
You can easily nest paths by adding additional routes to a route block. For example:

```ruby
route :about do
  route :team
  route :history
  route :location
end
```

This will create the following routes:

- /about
- /about/team
- /about/history
- /about/location

You can continue to nest if you'd like.

```ruby
route :about do
  route :team do
    route :bob
    route :sally do
      route :bio
      route :experience
    end
  end
end
```

This will create the following routes:

- /about
- /about/team
- /about/team/bob
- /about/team/sally
- /about/team/sally/bio
- /about/team/sally/experience


**index**
If you want to nest pages but don't want an index route then you can exlude that from the route generation.

```ruby
route :service, index: false do
  route :design
  route :development
end
```

This will avoid trying to match the url `/services` to `services/index.html`. This is useful when you don't have index files for a subdirectory.


**query params**
You can pass query params to any route like you do with the rails router. Simple pass the query key and value as a hash to the route.

```ruby
= link_to "Contact Us", contact_path(ref: "work", location: "header")
#=> /contact?ref=work&location=header
```

## Things to note

One thing to note is that the index root needs to be setup like this:

```ruby
Router.draw do
  route :home, path: ""
end
```

Otherwise, it'll try to route `Router.home_path` to `home.html`.
