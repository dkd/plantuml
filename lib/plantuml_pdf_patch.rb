# frozen_string_literal: true

module PlantumlPdfPatch
  require_dependency 'redmine/export/pdf'

  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethod)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      alias_method_chain :get_image_filename, :plantUml
    end
  end

  module InstanceMethod
    def get_image_filename_with_plantUml(attrname)
      return get_image_filename_without_plantUml(attrname) unless attrname =~ %r{^/plantuml/png/(\w+)\.png$}i

      PlantumlHelper.plantuml_file(Regexp.last_match[1], '.png')
    end
  end
end
