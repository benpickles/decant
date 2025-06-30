# CHANGELOG

## Version 0.4.0 - 2025-06-30

- Add `Content.glob` which uses its collection's glob method and returns instances of the class.

## Version 0.3.0 - 2024-11-19

- Add `Content#relative_path` which returns a file's relative path within its collection.

## Version 0.2.0 - 2024-10-13

- Add support for a content instance knowing its own `#slug` - its extension-less relative path within its collection:

  ```ruby
  Page = Decant.define(dir: 'content', ext: 'md')

  page = Page.find('features/slugs')
  page.path.expand_path # => "/Users/dave/my-website/content/features/slugs.md"
  page.slug             # => "features/slugs"
  ```
- `Collection` is no immutable and can no longer be changed after initialisation.

## Version 0.1.0 - 2024-08-11

- Initial release
