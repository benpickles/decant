# frozen_string_literal: true
RSpec.describe Decant::Content do
  describe '.all' do
    let(:klass) { Decant.define(dir: tmpdir, ext: ext) }

    before do
      file('foo.md')
      file('nested/dir/foo.txt')
      file('nested/dir/bar.md')
      file('x/y/z')
      file('x/y/z.md')
    end

    context 'when no #ext is defined' do
      let(:ext) { nil }

      it 'returns an array of klass instances for all nested files' do
        expect(klass.all).to contain_exactly(
          have_attributes(class: klass, path: file_path('foo.md')),
          have_attributes(class: klass, path: file_path('nested/dir/foo.txt')),
          have_attributes(class: klass, path: file_path('nested/dir/bar.md')),
          have_attributes(class: klass, path: file_path('x/y/z')),
          have_attributes(class: klass, path: file_path('x/y/z.md')),
        )
      end
    end

    context 'when #ext is defined' do
      let(:ext) { 'md' }

      it 'returns an array of klass instances for matching nested files' do
        expect(klass.all).to contain_exactly(
          have_attributes(class: klass, path: file_path('foo.md')),
          have_attributes(class: klass, path: file_path('nested/dir/bar.md')),
          have_attributes(class: klass, path: file_path('x/y/z.md')),
        )
      end
    end
  end

  describe '.find' do
    let(:klass) { Decant.define(dir: tmpdir) }

    context 'when the collection returns a path for the pattern' do
      it 'returns an instance of the klass for the path' do
        file('foo')
        instance = klass.find('foo')

        expect(instance).to be_a(klass)
        expect(instance.path).to eql(file_path('foo'))
      end
    end

    context 'when the collection returns nil' do
      it 'raises an error referencing the pattern/dir' do
        expect {
          klass.find('path/to/file.md')
        }.to raise_error(Decant::FileNotFound, %r{"path/to/file.md".+"#{tmpdir}"})
      end
    end
  end

  describe '.frontmatter - adding frontmatter convenience readers' do
    let(:klass) {
      Decant.define(dir: tmpdir) do
        frontmatter :title
      end
    }

    context 'when the file has frontmatter' do
      it 'returns the value for the key if it exists' do
        file('foo', "---\ntitle: foo\n---\ncontent")
        instance = klass.find('foo')
        expect(instance.title).to eql('foo')
      end

      it 'returns nil if the key does not exist' do
        file('foo', "---\n\n---\ncontent")
        instance = klass.find('foo')
        expect(instance.title).to be_nil
      end
    end

    context 'when the file does not have frontmatter' do
      it do
        file('foo', 'content')
        instance = klass.find('foo')
        expect(instance.title).to be_nil
      end
    end
  end

  describe '#slug' do
    let(:klass) { Decant.define(dir: tmpdir, ext: '.md') }

    it 'is the relative path within its collection excluding the extension' do
      file('foo/bar.md')
      instance = klass.find('foo/*')
      expect(instance.slug).to eql('foo/bar')
    end
  end
end
