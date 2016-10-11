module ReactWebpackRails
  module ReduxIntegration
    class ReduxContainerRenderer
      include ReactWebpackRails::ReduxIntegration::ViewHelpers
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::TextHelper

      attr_accessor :output_buffer

      def call(name, options)
        redux_container(name, options)
      end
    end
  end
end
