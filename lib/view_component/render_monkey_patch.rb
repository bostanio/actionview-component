# frozen_string_literal: true

module ViewComponent
  module RenderMonkeyPatch # :nodoc:
    def self.included(base)
      # Protect from trying to augment modules that appear
      # as the result of adding other gems.
      return if base != ActionController::Base

      base.class_eval do
        alias_method_chain :render, :view_component
      end
    end

    def render(options = nil, *args, &block)
      render_with_view_component(options, *args, &block)
    end

    def render_with_view_component(options = nil, *args, &block)
      if options.respond_to?(:render_in)
        options.render_in(self, &block)
      elsif respond_to?(:render_without_view_component)
        # support alias_method_chain (module included)
        render_without_view_component(options, *args, &block)
      else
        # support inheritance (module prepended)
        method(:render).super_method.call(options, *args, &block)
      end
    end
  end
end
