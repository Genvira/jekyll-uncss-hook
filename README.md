# Jekyll::UncssHook

A Jekyll plugin that runs [uncss](https://github.com/uncss/uncss) to remove
unused CSS from stylesheets. It is based on [jekyll-uncss](https://github.com/episource/jekyll-uncss), but packaged as a gem.

## Installation

### Install Uncss

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install [uncss](https://github.com/uncss/uncss) such that it is on the path

```bash
npm install -g uncss
```

### Install gem

Install the gem and add to the application's Gemfile by executing:

```ruby
group :jekyll_plugins do
  # (...)

  gem "jekyll-uncss-hook",
    git: "https://github.com/Genvira/jekyll-uncss-hook"
end
```

Then add the plugin to your site's configuration file (`_config.yaml`):

```yaml
plugins:
  - (...)
  - jekyll-uncss hook
  - (...)
```

## Usage

Add an `uncss` option in `_config.yaml`:

```yaml
uncss:
  stylesheets:            # a list of stylesheets to be processed; mandatory
    - assets/css/main.css
  files:                  # html files to consider, globs are supported; default: **/*.html
    - "**/*.html"
    - "**/*.htm"
  ignore:                 # always keep rules for these selectors; default: none
    - ".is-loading"
    - "#titleBar"
  media:                  # additional media queries to consider; default: undefined
    - print
  timeout: 30             # how long to wait for the JS to be loaded in milliseconds; default: undefined
  banner: false           # should the output include a banner comment; default: undefined
```

The options are mostly the ones in [jekyll-uncss](https://github.com/episource/jekyll-uncss) with a few additional ones from [uncss](https://github.com/uncss/uncss), although they are untested. This plugin does not support compressing
CSS files (unlike [jekyll-uncss](https://github.com/episource/jekyll-uncss)),
and other plugins can be used for that.

## Development

<!--
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).
-->

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/jekyll-uncss-hook. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/jekyll-uncss-hook/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll::UncssHook project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/jekyll-uncss-hook/blob/main/CODE_OF_CONDUCT.md).
