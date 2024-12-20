# Decant

[![Ruby](https://github.com/benpickles/decant/actions/workflows/main.yml/badge.svg)](https://github.com/benpickles/decant/actions/workflows/main.yml)

A dependency-free frontmatter-aware framework-agnostic wrapper around a directory of static content.

## Installation

Add Decant to your application's Gemfile and run `bundle install`.

```ruby
gem 'decant'
```

## Usage

Define a Decant class pointing to a directory of files and add your own methods.

```ruby
Page = Decant.define(dir: '_pages', ext: 'md') do
  # Declare frontmatter convenience readers.
  frontmatter :title

  # Add custom methods - it's a standard Ruby class.
  def shouty
    "#{title.upcase}!!!"
  end
end
```

Given a file `_pages/about.md` with the following contents:

```markdown
---
title: About
stuff: nonsense
---
# About

More words.
```

You can fetch a `Page` instance by `.find`ing it by its extension-less path within the directory.

```ruby
about = Page.find('about')
about.content     # => "# About\n\nMore words.\n"
about.frontmatter # => {:title=>"About", :stuff=>"nonsense"}
about.title       # => "About"
about.shouty      # => "ABOUT!!!"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/benpickles/decant. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/benpickles/decant/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Decant project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/benpickles/decant/blob/main/CODE_OF_CONDUCT.md).
