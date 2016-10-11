module ReactWebpackRails
  module ReduxIntegration
    class ReduxStoreRenderer
      include ReactWebpackRails::ReduxIntegration::ViewHelpers
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::TextHelper

      attr_accessor :output_buffer

      def call(name, props, options)
        redux_store(name, props, options)
      end
    end
  end
end
