# 
# Copyright (c) 2012-2013 by Lifted Studios.  All Rights Reserved.
# 

require 'html/pipeline'
require 'open-uri'

module HTML
  class Pipeline
    # An `HTML::Pipeline` filter class that detects wiki-style links and converts them to HTML links.
    class WikiLinkFilter < Filter
      # Initializes a new instance of the `WikiLinkFilter` class.
      #
      # @param doc     Document to filter.
      # @param context Parameters for the filter.
      # @param result  Results extracted from the filter.
      def initialize(doc, context = nil, result = nil)
        super(doc, context, result)

        @base_url = '/'
        @space_replacement = '_'
        
        if context
          @base_url = context[:base_url] if context[:base_url]
          @space_replacement = context[:space_replacement] if context[:space_replacement]
        end

        if !@base_url.empty? && @base_url !~ /\/$/
          @base_url += '/'
        end
      end

      # Performs the translation and returns the updated text.
      # 
      # @return [String] Updated text with translated wiki links.
      def call
        html.gsub(/\[\[([^|]*)(\|(.*))?\]\]/) do
          link = $1
          desc = $3 ? $3 : $1

          "<a href=\"#{to_link link}\">#{to_description desc}</a>"
        end
      end

      private

      # Converts the given text into an appropriate link description.
      # 
      # @param text Proposed description text.
      # @return Updated text for use as a link description.
      def to_description(text)
        text.strip.gsub(/\s+/, ' ')
      end

      # Converts the given text into an appropriate link.
      # 
      # @param text Proposed link text.
      # @return Updated text to use as a link.
      def to_link(text)
        URI::encode(@base_url + text.strip.gsub(/\s+/, @space_replacement))
      end
    end
  end
end
