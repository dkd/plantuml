require 'digest/sha2'

module PlantumlHelper
  ALLOWED_FORMATS = {
    'png' => { type: 'png', ext: '.png', content_type: 'image/png', inline: true },
    'svg' => { type: 'svg', ext: '.svg', content_type: 'image/svg+xml', inline: true }
  }.freeze

  def self.construct_cache_key(key)
    ['plantuml', Digest::SHA256.hexdigest(key.to_s)].join('_')
  end

  def self.check_format(frmt)
    ALLOWED_FORMATS.fetch(frmt, ALLOWED_FORMATS['png'])
  end

  def self.plantuml_file(name, extension)
    File.join(Rails.root, 'files', "#{name}#{extension}")
  end

  def self.plantuml(text, args)
    frmt = check_format(args)
    name = construct_cache_key(text)
    settings_binary = Setting.plugin_plantuml['plantuml_binary_default']
    if File.file?(plantuml_file(name, '.pu'))
      unless File.file?(plantuml_file(name, frmt[:ext]))
        `"#{settings_binary}" -charset UTF-8 -t"#{frmt[:type]}" "#{plantuml_file(name, '.pu')}"`
      end
    else
      File.open(plantuml_file(name, '.pu'), 'w') do |file|
        file.write "@startuml\n"
        file.write sanitize_plantuml(text) + "\n"
        file.write '@enduml'
      end
      `"#{settings_binary}" -charset UTF-8 -t"#{frmt[:type]}" "#{plantuml_file(name, '.pu')}"`
    end
    name
  end

  def self.sanitize_plantuml(text)
    return text if Setting.plugin_plantuml['allow_includes']
    text.gsub!(/!include.*$/, '')
    text
  end
end
