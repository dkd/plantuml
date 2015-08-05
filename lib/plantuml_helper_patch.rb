require_dependency 'redmine/wiki_formatting/textile/helper'

module PlantumlHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, HelperMethodsWikiExtensions)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      alias_method_chain :heads_for_wiki_formatter, :plantuml
    end
  end
end

module HelperMethodsWikiExtensions
  def heads_for_wiki_formatter_with_plantuml
    heads_for_wiki_formatter_without_plantuml
    return if ie6_or_ie7?

    unless @heads_for_wiki_plantuml_included
      content_for :header_tags do
        o = javascript_include_tag('plantuml.js', plugin: 'plantuml')
        o << stylesheet_link_tag('plantuml.css', plugin: 'plantuml')
        o.html_safe
      end
      @heads_for_wiki_plantuml_included = true
    end
  end

  private

  def ie6_or_ie7?
    useragent = request.env['HTTP_USER_AGENT'].to_s
    useragent.match(/IE[ ]+[67]./).nil?
  end
end
