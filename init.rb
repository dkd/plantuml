Redmine::Plugin.register :plantuml do
  name 'PlantUML plugin for Redmine'
  author 'Michael Skrynski'
  description 'This is a plugin for Redmine which renders PlantUML diagrams.'
  version '0.5.1'
  url 'https://github.com/dkd/plantuml'

  requires_redmine version: '2.6'..'4.1'

  settings(partial: 'settings/plantuml',
           default: { 'plantuml_binary' => {}, 'cache_seconds' => '0', 'allow_includes' => false })

  Redmine::WikiFormatting::Macros.register do
    desc <<EOF
      Render PlantUML image.
      <pre>
      {{plantuml(png)
      (Bob -> Alice : hello)
      }}
      </pre>

      Available options are:
      ** (png|svg)
EOF
    macro :plantuml do |obj, args, text|
      raise 'No PlantUML binary set.' if Setting.plugin_plantuml['plantuml_binary_default'].blank?
      raise 'No or bad arguments.' if args.size != 1
      frmt = PlantumlHelper.check_format(args.first)
      image = PlantumlHelper.plantuml(text, args.first)
      image_tag "/plantuml/#{frmt[:type]}/#{image}#{frmt[:ext]}"
    end
  end
  Redmine::WikiFormatting::Macros.register do
    desc <<EOF
      Render attached PlantUML file.

      {{plantuml_attach(diagram.pu)}}
      {{plantuml_attach(diagram.pu, format=png)}} -- with image format
      ** Available formt options are "png" or "svg"
EOF
    macro :plantuml_attach do |obj, args|
      raise 'No PlantUML binary set.' if Setting.plugin_plantuml['plantuml_binary_default'].blank?
      args, options = extract_macro_options(args, :format)
      filename = args.first
      raise 'Filename required' unless filename.present?
      frmt = PlantumlHelper.check_format(options[:format])
      if obj && obj.respond_to?(:attachments) && attachment = Attachment.latest_attach(obj.attachments, filename)
        image = PlantumlHelper.plantuml(File.read(attachment.diskfile), frmt[:type])
        image_tag "/plantuml/#{frmt[:type]}/#{image}#{frmt[:ext]}"
      else
        raise "Attachment #{filename} not found"
      end
    end
  end

end

Rails.configuration.to_prepare do
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks

  unless Redmine::WikiFormatting::Textile::Helper.included_modules.include? PlantumlHelperPatch
    Redmine::WikiFormatting::Textile::Helper.send(:include, PlantumlHelperPatch)
  end
end
