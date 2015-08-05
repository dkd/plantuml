module Plantuml
  module Hooks
    class ViewsLayoutsHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(_context)
        stylesheet_link_tag(:plantuml, plugin: 'plantuml')
      end

      def view_layouts_base_body_bottom(_context)
        javascript_include_tag(:plantuml, plugin: 'plantuml')
      end
    end
  end
end
