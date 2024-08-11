# frozen_string_literal: true
RSpec.describe Decant::File do
  context 'when the file has frontmatter and content' do
    let(:contents) {
      <<~CONTENTS
        ---
        foo: bar
        ---
        Content
      CONTENTS
    }

    before do
      file('foo', contents)
    end

    it do
      file = described_class.new(file_path('foo'))

      expect(file.content).to eql("Content\n")
      expect(file.frontmatter).to eql({ foo: 'bar' })
      expect(file.frontmatter?).to be(true)
      expect(file.frontmatter?(:foo)).to be(true)
      expect(file.frontmatter?(:bar)).to be(false)
      expect(file.read).to eql(contents)
    end
  end

  context 'when the file has content and no frontmatter' do
    before do
      file('foo', 'Content')
    end

    it do
      file = described_class.new(file_path('foo'))

      expect(file.content).to eql('Content')
      expect(file.frontmatter).to be_nil
      expect(file.frontmatter?).to be(false)
      expect(file.frontmatter?(:foo)).to be(false)
      expect(file.read).to eql('Content')
    end
  end

  context 'with an empty file' do
    before do
      file('foo')
    end

    it do
      file = described_class.new(file_path('foo'))

      expect(file.content).to eql('')
      expect(file.frontmatter).to be_nil
      expect(file.frontmatter?).to be(false)
      expect(file.frontmatter?(:foo)).to be(false)
      expect(file.read).to eql('')
    end
  end
end
