# frozen_string_literal: true
module Blacklight::Searchable
  extend ActiveSupport::Concern

  included do
    # Which class to use for the search service. You can subclass SearchService if you
    # want to override any of the methods (e.g. SearchService#fetch)
    class_attribute :search_service_class
    self.search_service_class = Blacklight::SearchService
  end

  # @return [Blacklight::SearchService]
  def search_service
    search_service_class.new(config: blacklight_config, user_params: search_state.to_h, **search_service_context)
  end

  # @return [Hash] a hash of context information to pass through to the search service
  def search_service_context
    {}
  end

  # @return [Blacklight::SuggestSearch]
  def suggestions_service
    Blacklight::SuggestSearch.new(params, search_service.repository).suggestions
  end
end
