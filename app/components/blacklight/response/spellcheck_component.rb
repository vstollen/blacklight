# frozen_string_literal: true

module Blacklight
  module Response
    # Render spellcheck results for a search query
    class SpellcheckComponent < ViewComponent::Base
      # @param [Blacklight::Response] response
      # @param [Array<String>] options explicit spellcheck options to render
      def initialize(response:, options: nil)
        @response = response
        @options = options || @response&.spelling&.words
      end

      def link_to_query(query)
        @view_context.link_to_query(query)
      end

      def render?
        @options.any? && @view_context.should_show_spellcheck_suggestions?(@response)
      end
    end
  end
end
