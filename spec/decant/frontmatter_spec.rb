# frozen_string_literal: true
RSpec.describe Decant::Frontmatter do
  describe '.load' do
    let(:content) { parsed[1] }
    let(:frontmatter) { parsed[0] }
    let(:parsed) { described_class.load(input) }

    context 'with frontmatter and content' do
      let(:input) {
        <<~INPUT
          ---
          foo: bar
          ---
          Content
        INPUT
      }

      it do
        expect(frontmatter).to eql({ foo: 'bar' })
        expect(content).to eql("Content\n")
      end
    end

    context 'with frontmatter and content containing a triple dash (Markdown <hr>)' do
      let(:input) {
        <<~INPUT
          ---
          foo: bar
          ---
          Content
          ---
          More
        INPUT
      }

      it do
        expect(frontmatter).to eql({ foo: 'bar' })
        expect(content).to eql("Content\n---\nMore\n")
      end
    end

    context 'with frontmatter but no content' do
      let(:input) {
        <<~INPUT
          ---
          foo: bar
          ---
        INPUT
      }

      it do
        expect(frontmatter).to eql({ foo: 'bar' })
        expect(content).to eql('')
      end
    end

    context 'with frontmatter that is not a hash' do
      let(:input) {
        <<~INPUT
          ---
          - foo
          - bar
          ---
        INPUT
      }

      it 'is valid but not normally expected' do
        expect(frontmatter).to eql(['foo', 'bar'])
        expect(content).to eql('')
      end
    end

    context 'with empty frontmatter and content' do
      let(:input) {
        <<~INPUT
          ---
          ---
          Content
        INPUT
      }

      it do
        expect(frontmatter).to eql({})
        expect(content).to eql("Content\n")
      end
    end

    context 'with empty frontmatter and no content' do
      let(:input) { "---\n---" }

      it do
        expect(frontmatter).to eql({})
        expect(content).to eql('')
      end
    end

    context 'with no frontmatter and content' do
      let(:input) { 'Content' }

      it do
        expect(frontmatter).to be_nil
        expect(content).to eql(input)
      end
    end

    context 'with no frontmatter and content that starts with a triple-dash' do
      let(:input) { '--- Content' }

      it do
        expect(frontmatter).to be_nil
        expect(content).to eql(input)
      end
    end

    context 'with no frontmatter and content that contains many triple-dashed lines (Markdown <hr>)' do
      let(:input) {
        <<~INPUT
          Foo
          ---
          Bar
          ---
          Baz
        INPUT
      }

      it do
        expect(frontmatter).to be_nil
        expect(content).to eql(input)
      end
    end

    context 'with misformatted frontmatter (missing opening triple-dash)' do
      let(:input) {
        <<~INPUT
          foo: bar
          ---
          Content
        INPUT
      }

      it do
        expect(frontmatter).to be_nil
        expect(content).to eql(input)
      end
    end

    context 'with misformatted frontmatter (missing closing triple-dash)' do
      let(:input) {
        <<~INPUT
          ---
          foo: bar
        INPUT
      }

      it do
        expect(frontmatter).to be_nil
        expect(content).to eql(input)
      end
    end

    context 'with an empty input' do
      let(:input) { '' }

      it do
        expect(frontmatter).to be_nil
        expect(content).to eql(input)
      end
    end
  end
end
