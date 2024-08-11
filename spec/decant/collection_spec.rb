# frozen_string_literal: true
RSpec.describe Decant::Collection do
  describe '#dir=' do
    context 'when passed a String' do
      it 'is converted to a Pathname' do
        collection = described_class.new(dir: 'foo')
        expect(collection.dir).to be_a(Pathname)
      end
    end
  end

  describe '#entries' do
    subject { collection.entries }

    let(:collection) { described_class.new(dir: tmpdir, ext: ext) }

    context 'when #ext is defined' do
      let(:ext) { 'aa' }

      before do
        file('features/foo')
        file('features/foo.a')
        file('features/foo.aa')
        file('features/foo.aaa')
        file('features/foo.b')
        file('foo')
        file('foo.a')
        file('foo.aa')
        file('foo.aaa')
        file('foo.b')
        file('xyz/')
      end

      it 'only includes _files_ with the extension' do
        expect(subject).to contain_exactly(
          file_path('features/foo.aa'),
          file_path('foo.aa'),
        )
      end
    end

    context 'when #ext is not defined' do
      let(:ext) { nil }

      before do
        file('a/b.en')
        file('a/b/c/d.exe')
        file('dir/')
        file('foo.a')
        file('foo.b')
        file('noext')
      end

      it 'lists all nested _files_' do
        expect(subject).to contain_exactly(
          file_path('a/b.en'),
          file_path('a/b/c/d.exe'),
          file_path('foo.a'),
          file_path('foo.b'),
          file_path('noext'),
        )
      end
    end
  end

  describe '#ext=' do
    let(:collection) { described_class.new(dir: 'foo') }

    context 'when a leading dot is present' do
      it 'it remains' do
        collection.ext = '.foo'
        expect(collection.ext).to eql('.foo')
      end
    end

    context 'when a leading dot is not present' do
      it 'one is added' do
        collection.ext = 'foo'
        expect(collection.ext).to eql('.foo')
      end
    end

    context 'with nil' do
      it do
        collection.ext = 'foo'
        collection.ext = nil
        expect(collection.ext).to be_nil
      end
    end
  end

  describe '#find' do
    let(:collection) { described_class.new(dir: tmpdir, ext: ext) }

    before do
      file('a/b/c/d')
      file('a/b/c/d.md')
      file('a/b/c/d.txt')
      file('a/b/d')
      file('a/b/d.md')
      file('a/d.mdn')
      file('d')
      file('d.foo')
      file('d.md')
      file('e/')
    end

    context 'when #ext is defined' do
      let(:ext) { '.md' }

      it 'combines it with the supplied path and returns the file if it exists' do
        expect(collection.find('a')).to be_nil
        expect(collection.find('a/b/c/d')).to eql(file_path('a/b/c/d.md'))
        expect(collection.find('a/b/d')).to eql(file_path('a/b/d.md'))
        expect(collection.find('a/d')).to be_nil
        expect(collection.find('d')).to eql(file_path('d.md'))
        expect(collection.find('e')).to be_nil
        expect(collection.find('f')).to be_nil
      end
    end

    context 'when #ext is not defined' do
      let(:ext) { nil }

      it 'returns the file if it exists at the supplied path' do
        expect(collection.find('a')).to be_nil
        expect(collection.find('a/b/c/d')).to eql(file_path('a/b/c/d'))
        expect(collection.find('a/b/d')).to eql(file_path('a/b/d'))
        expect(collection.find('a/d')).to be_nil
        expect(collection.find('d')).to eql(file_path('d'))
        expect(collection.find('d.foo')).to eql(file_path('d.foo'))
        expect(collection.find('e')).to be_nil
        expect(collection.find('f')).to be_nil
      end
    end
  end

  describe '#glob' do
    let(:collection) { described_class.new(dir: tmpdir, ext: 'md') }

    before do
      file('a/b/c/d')
      file('a/b/c/d.md')
      file('a/b/c/d.txt')
      file('a/b/d')
      file('a/b/d.md')
      file('a/d.mdn')
      file('d')
      file('d.foo')
      file('d.md')
      file('de/')
    end

    it 'returns _files_ ignoring #ext and otherwise behaves like a standard Dir.glob' do
      expect(collection.glob('d')).to contain_exactly(
        file_path('d'),
      )
      expect(collection.glob('d.*')).to contain_exactly(
        file_path('d.foo'),
        file_path('d.md'),
      )
      expect(collection.glob('d*')).to contain_exactly(
        file_path('d'),
        file_path('d.foo'),
        file_path('d.md'),
      )
      expect(collection.glob('a/*/d*')).to contain_exactly(
        file_path('a/b/d'),
        file_path('a/b/d.md'),
      )
      expect(collection.glob('a/**/d*')).to contain_exactly(
        file_path('a/b/c/d'),
        file_path('a/b/c/d.md'),
        file_path('a/b/c/d.txt'),
        file_path('a/b/d'),
        file_path('a/b/d.md'),
        file_path('a/d.mdn'),
      )
      expect(collection.glob('**/d.md')).to contain_exactly(
        file_path('a/b/c/d.md'),
        file_path('a/b/d.md'),
        file_path('d.md'),
      )
      expect(collection.glob('**/d.md*')).to contain_exactly(
        file_path('a/b/c/d.md'),
        file_path('a/b/d.md'),
        file_path('a/d.mdn'),
        file_path('d.md'),
      )
      expect(collection.glob('a/b/**/*.{md,txt}')).to contain_exactly(
        file_path('a/b/c/d.md'),
        file_path('a/b/c/d.txt'),
        file_path('a/b/d.md'),
      )
    end
  end
end
