module ReactWebpackRails
  module ReduxIntegration
    module ViewHelpers
      def redux_store(name, raw_props = {}, options = {})
        props = serialize_props(raw_props)

        if server_side(options.delete(:server_side))
          NodeIntegrationRunner.new('redux-store', name: name, props: props).run
        end

        react_element('redux-store', { name: name, props: props }, options)
      end

      def redux_container(name, options = {})
        store_name = options.delete(:store_name)

        if server_side(options.delete(:server_side))
          result_string = NodeIntegrationRunner.new('redux-container', name: name, storeName: store_name).run
          react_element('redux-container', { name: name, storeName: store_name }, options) do
            result_string.html_safe
          end
        else
          react_element('redux-container', { name: name, storeName: store_name }, options)
        end
      end

      private

      def serialize_props(raw_props)
        props = raw_props.as_json
        return props unless Rails.application.config.react.camelize_props
        ReactWebpackRails::Services::CamelizeKeys.call(props)
      end
    end
  end
end
