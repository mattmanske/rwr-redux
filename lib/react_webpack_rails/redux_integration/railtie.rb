require 'react_webpack_rails/redux_integration/view_helpers'
require 'react_webpack_rails/redux_integration/redux_store_renderer'
require 'react_webpack_rails/redux_integration/redux_container_renderer'

module ReactWebpackRails
  module ReduxIntegration
    class Railtie < ::Rails::Railtie
      # Sensible defaults. Can be overridden in application.rb.

      # gem related config default:
      config.rwr = ActiveSupport::OrderedOptions.new
      config.rwr.node_server_host = 'http://localhost:8081/'

      # react integration related config default:
      config.react = ActiveSupport::OrderedOptions.new
      config.react.camelize_props = false
      config.react.server_side = false
      config.react.shared = {}

      initializer 'react_webpack_rails.redux_helpers.view_helpers' do
        ActionView::Base.send :include, ViewHelpers
      end

      initializer 'react_webpack_rails.add_redux_store_renderer' do
        ActionController::Renderers.add :redux_store do |name, options = {}|
          renderer = ReactWebpackRails::ReduxIntegration::ReduxStoreRenderer.new
          component_options = options.slice(:aria, :class, :data, :id, :tag, :server_side)
          props = options.reject(:props)

          html = renderer.call(name, props, component_options)
          render_options = options.merge(inline: html)

          render(render_options)
        end
      end

      initializer 'react_webpack_rails.add_redux_container_renderer' do
        ActionController::Renderers.add :redux_container do |name, options = {}|
          renderer = ReactWebpackRails::ReduxIntegration::ReduxContainerRenderer.new
          component_options = options.slice(:aria, :class, :data, :id, :tag, :server_side)

          html = renderer.call(name, component_options)
          render_options = options.merge(inline: html)

          render(render_options)
        end
      end

      initializer 'react_webpack_rails.add_redux_store_and_container_renderer' do
        ActionController::Renderers.add :redux_store_and_container do |container_name, options = {}|
          store = ReactWebpackRails::ReduxIntegration::ReduxStoreRenderer.new
          container = ReactWebpackRails::ReduxIntegration::ReduxContainerRenderer.new

          component_options = options.slice(:aria, :class, :data, :id, :tag, :server_side)
          store_name = options.reject(:store)
          props = options.reject(:props)

          store_html = store.call(store_name, props, component_options)
          container_html = container.call(container_name, component_options)

          render_options = options.merge(inline: store_html + container_html)
          render(render_options)
        end
      end
    end
  end
end
