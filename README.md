# morris-rails

> ##NOTE: Unmaintained! Please use [rails-assets-morrisjs](https://rails-assets.org/#/components/morrisjs) instead.

Adds [morris](https://github.com/oesmith/morris.js) to the Rails 3 asset pipeline.

## Install

### Bundler: `gem 'morris-rails'` in `group :assets`

### RubyGems: `gem install morris-rails`

### Setup

Add the default morris stylesheet to `app/assets/stylesheets/application.css`:

```css
//= require morris.core
```

Or, if using Less, you can use the `import` declaration to import the default morris stylesheet:

```less
@import 'morris.core';
```

Now you must add `require` statements to `app/assets/javascripts/application.js` for `morris` and it's dependencies:

> Note that `jquery` and `raphael/raphael` must be required before `morris`.

```js
//= require jquery
//= require raphael/raphael
//= require morris
```

Now, require which graphs you will be using:

```js
//= require morris.grid
//= require morris.hover
//= require morris.area
//= require morris.line
//= require morris.bar
//= require morris.donut
```

## Contributing

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Ryan Scott Lewis. See LICENSE for details.
