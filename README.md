Javascripto
============
Client-side Javascript Application Framework

Installation
-------------
The one-liner...

    gem install javascripto

### Setup for Rails

#### Gem Dependency
For integration with a rails application add javascripto-rails to your gem file and run `bundle install`.

    gem 'javascripto-rails'

#### View Setup
In your rails layout, add the following snippet to the head of the page.
    <% require_app_modules() %>

    <%# Render Packages %>
    <%- if required_packages.any? -%>
      <%- required_packages.each do |package| -%>
        <%- if package.cache -%>
          <%= javascript_include_tag package.package_files.map{ |file| file.resource_path }, :cache => package.package_name %>
        <%- else -%>
          <%= javascript_include_tag package.package_files.map{ |file| file.resource_path } %>
        <%- end -%>
      <%- end -%>
    <%- end -%>

    <%# Render Initializers %>
    <%- if app_modules.any? -%>
      <script type="text/javascript" charset="utf-8">
        <%- app_modules.each do |app_module| -%>
          $(app.<%=app_module-%>);
        <%- end -%>
      </script>
    <%- end -%>

#### Project Organization
Organize the files in your  directory as follows.
Create app, lib, and vendor folders as well as a config.js file in your `public/javascript` directory.

  * public
    * javascript
      * **app/** (_applications modules_)
      * **lib/** (_your libraries_)
      * **vendor/** (_external libraries, i.e. jQuery_)
        * **jquery**
          * **plugins/**
          * **jquery.js**
      * **config.js** (_configuration_)

**Note:** You probably also want to include rails.js. Javascripto uses the [jQuery javascript library](http://http://jquery.com/) so you might want to use this too as opposed to prototype or an alternative. You can use the [jquery-rails gem](https://github.com/rails/jquery-ujs) to get setup with it very quickly, but all you really need to to is to update the source of rails.js to work with jquery.

Paste the following in `config.js`

    // require jquery

    app = {
      config: {
        // You can put front-end configuration here.
      }
    };

Paste the following in `jquery.js`

    // use_remote_package http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js

#### Javascripto Configuration (Packages)

Create a javascripto.yml file in your rails app config folder and paste the following.

    packages:
      - defaults: []

Getting Started
----------------
**Note**: Ensure you've installed the gem and ran through project setup first.

### App Modules
A javascripto application is broken down by app modules. App modules allow you to associate specific pieces of javascript with partials or views in your application so that the coed is only invoked when the associated markup is rendered.

#### Declaring App Modules
Declare app modules by passing the app's name to the `app` helper method in your view.

erb

    <%- app 'status_update' -%>
    _Your app module's markup..._

haml

    - app 'status_update'
    _You app module's markup..._


#### Writing App Modules
Whenever you declare an app module in your views you need to create a corresponding file under `public/javascript/app`.

In the hypothetically named `status_update` app module you would create a file named `status_update.js` and insert the following content.

    app.status_update = function(){
      // Your app module code goes here...
    };

Now whenever the partial or view which declares the `status_update` app is rendered, `app.status_update()` will be included and invoked on the front-end. The invocation happens as soon as the DOM is ready, so you can get right into wiring up events and and other forms of DOM manipulation.


#### Requiring Files
Declare dependencies at the top of your javascript files with the require keyword.

    // require some_file

In this case, the framework will search the javascript load_path for a file name `some_file.js`. Dependencies will always be loaded first.

Any file required in config.js will be available for use anywhere in your application without the need to explicitly require it. This is good for including libraries that are used all over the place like jQuery or rails.js.

**Note**: make sure the casing you use to require a file matches the casing you used to name the file. Don't quote the name, so use `some_file` as opposed to `some_file.js`, and always make sure to provide a path that is relative to the `load_path` (see next section).

#### The Load Path
As note, whenever you require a javascript file the load path is searched. Keep in mind if a matching file can't be found an exception will be thrown.

The `load_path` includes the `public/javascript`, the `lib` and each `vendor` subdirectory and is search in that order.

#### Packages
In development all the required javascript files are sent to the client independently. This helps with debugging because line number references and file names will match source files. In production, it is ideal to stitch the files together and send them to the client as one big glob. This is where packages come in.

By default, if you don't declare any packages and file required in config.js or any of it's dependencies will be the only files included in the one and only package that will be created. To customize the packages to your needs modify the `javascripto.yml` in your rails config directory file. Here is an example.

Example:

    packages:
      - defaults:
        - app/status_update
        - app/profile
        - app/wall_posts
      - extras:
        - app/obscure_weighty_feature

In the example, two packages are created (`defaults` and `extras`).The `defaults` package will include `app/status.js`, `app/profile.js`, `app/wall_post.js` as well as all of there dependencies. It will also include config.js and any of it's dependencies because it is the first package your declare. The first package will always include `config.js`.

The `extras` package will include `app/obscure_weighty_feature.js` and any of it's dependencies not already included in `defaults`. If it does have dependancies which where packages in defaults, extras will always trigger defaults to be loaded first. In this basic example it would because all files in you application have an implicit dependency on `config.js` which could be packaged in defaults. When the files are stitched the name of the file will match the name of the package, therefore `dafulats` would become `deaults.js`

Please note that when referencing app modules in the package directory you need to include app/ before the file path. This is because app is not included in the load_path so in this case we provide a path relative to the root which is included in the load path.

Files that not included in a package will be sent independently.

#### Remote Packages
Remote packages allow you to serve and require a file from somewhere other then your application. This works nicely for using files on the [Google's CDN](http://code.google.com/apis/libraries/devguide.html) for example. To serve a remote file rather then your version, use the `use_remote_package` keyword in a javascript comment on the first line of the file that would otherwise be included.

Example: /vendor/jquery_ui/jquery.js

    // use_remote_package http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js

The `require` statement works with remote packages too. For example you can do the following to cause jquery-ui to be loaded from Google's CDN as well as ensure the jQuery source is loaded first.

Example /vendor/jquery_ui/jquery_ui.js

    // use_remote_package http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.8/jquery-ui.min.js
    // require jquery

Setting both of these files up like this would cause the following output.

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js" type="text/javascript"></script>
              <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.8/jquery-ui.min.js" type="text/javascript"></script>

**Note**: You may include anything else you want in this file but keep in mind it is not sent to the client.

License
-------
Copyright (c) 2010 Agora Games, released under the MIT license
