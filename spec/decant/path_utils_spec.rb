# frozen_string_literal: true
RSpec.describe Decant::PathUtils do
  describe '.delete_ext_regexp' do
    context 'with a bunch of patterns' do
      it do
        expect(described_class.delete_ext_regexp('.md')).to eql(/\.md$/)
        expect(described_class.delete_ext_regexp('.erb.html')).to eql(/\.erb\.html$/)
        expect(described_class.delete_ext_regexp('.*')).to eql(/\.[^\.]+$/)
        expect(described_class.delete_ext_regexp('.{a,b}')).to eql(/\.(?:a|b)$/)
        expect(described_class.delete_ext_regexp('.{erb.html,txt}')).to eql(/\.(?:erb\.html|txt)$/)
      end
    end

    context 'with an unbalanced pattern' do
      it do
        expect {
          described_class.delete_ext_regexp('.{a')
        }.to raise_error(RegexpError)
      end
    end
  end
end
