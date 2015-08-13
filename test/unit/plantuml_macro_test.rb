require File.expand_path('../../test_helper', __FILE__)

class PlantumlMacroTest < ActionController::TestCase
  include ApplicationHelper
  include ActionView::Helpers::AssetTagHelper
  include ERB::Util

  def setup
    Setting.plugin_plantuml['plantuml_binary_default'] = '/usr/bin/plantuml'
  end

  def test_plantuml_macro_with_png
    text = <<-RAW
{{plantuml(png)
Bob -> Alice : hello
}}
RAW
    assert_include '/plantuml/png/plantuml_88358e9331985a8ad4ec566b38dfd68a2875ead47b187542e2bea02c670d50ff.png', textilizable(text)
  end

  def test_plantuml_macro_with_svg
    text = <<-RAW
{{plantuml(svg)
Bob -> Alice : hello
}}
RAW
    assert_include '/plantuml/svg/plantuml_88358e9331985a8ad4ec566b38dfd68a2875ead47b187542e2bea02c670d50ff.svg', textilizable(text)
  end

end
