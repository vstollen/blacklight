# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Blacklight::Document::ActionComponent, type: :component do
  subject(:component) { described_class.new(document: document, action: action, **attr) }

  let(:action) { Blacklight::Configuration::ToolConfig.new(key: 'some_tool', name: 'some_tool', component: true) }
  let(:attr) { {} }
  let(:view_context) { controller.view_context }
  let(:render) do
    component.render_in(view_context)
  end

  let(:rendered) do
    Capybara::Node::Simple.new(render)
  end

  let(:document) do
    SolrDocument.new(
      id: 'x'
    )
  end

  before do
    # Every call to view_context returns a different object. This ensures it stays stable.
    allow(controller).to receive(:view_context).and_return(view_context)
  end

  it 'renders an action link' do
    # rubocop:disable RSpec/SubjectStub
    if Rails.version >= '6'
      allow(component).to receive(:some_tool_solr_document_path).with(document, only_path: true).and_return('/asdf')
    else
      allow(component).to receive(:some_tool_solr_document_path).with(document).and_return('/asdf')
    end
    # rubocop:enable RSpec/SubjectStub

    expect(rendered).to have_link 'Some tool', href: '/asdf'
  end

  context 'with a partial configured' do
    let(:action) { Blacklight::Configuration::ToolConfig.new(name: '', partial: '/some/tool') }

    it 'render the partial' do
      allow(view_context).to receive(:render).with(hash_including(partial: '/some/tool')).and_return('tool')

      expect(rendered).to have_content 'tool'
    end
  end
end
