# frozen_string_literal: true

module ViewComponent
  module RenderingMonkeyPatch # :nodoc:
    def self.included(base)
      base.class_eval do
        alias_method_chain :render, :view_component
      end
    end

    def render(options = {}, args = {})
      render_with_view_component(options, args)
    end

    def render_with_view_component(options = {}, args = {})
      if options.respond_to?(:render_in)
        self.response_body = options.render_in(self.view_context)
      elsif respond_to?(:render_without_view_component)
        # support alias_method_chain (module included)
        render_without_view_component(options, args)
      else
        # support inheritance (module prepended)
        method(:render).super_method.call(options, args)
      end
    end
  end
end
