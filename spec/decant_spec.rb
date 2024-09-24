# frozen_string_literal: true
RSpec.describe Decant do
  describe '.define' do
    it 'sets up a new Content subclass with an associated Collection and exposes the class body to the block' do
      content = <<~CONTENT
        ---
        title: Welcome
        ---
        Hello
      CONTENT

      file 'foo.md', content

      klass = described_class.define(dir: tmpdir, ext: 'md') do
        frontmatter :title

        def shouty
          title.upcase
        end
      end

      item = klass.find('foo')

      expect(item).to be_a(klass)
      expect(item).to be_a(Decant::File)
      expect(item.content).to eql("Hello\n")
      expect(item.frontmatter).to eql({ title: 'Welcome' })
      expect(item.shouty).to eql('WELCOME')
      expect(item.title).to eql('Welcome')
    end
  end
end
