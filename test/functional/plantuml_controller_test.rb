require File.expand_path('../../test_helper', __FILE__)

class PlantumlControllerTest < ActionController::TestCase
  def setup
    @request.session[:user_id] = 1
    Setting.default_language = 'en'
  end

  class PlantumlHelper
    def self.plantuml_file(name, extension)
      File.open(File.expand_path("../../fixtures/files/#{name}.#{extension}", __FILE__), mode='r')
    end
  end

  def test_convert_with_svg
    get :convert, content_type: 'svg', filename: 'plantuml_0c40679fe8cc7b2f654444c35ff1ab7ba53a28768f7f89b9c457d500b76f5590'
    assert_response :success
    assert_equal 'image/svg+xml', @response.content_type
  end

  def test_convert_with_png
    get :convert, content_type: 'png', filename: 'plantuml_0c40679fe8cc7b2f654444c35ff1ab7ba53a28768f7f89b9c457d500b76f5590'
    assert_response :success
    assert_equal 'image/png', @response.content_type
  end

  def test_convert_default_with_png
    get :convert, content_type: 'jpeg', filename: 'plantuml_0c40679fe8cc7b2f654444c35ff1ab7ba53a28768f7f89b9c457d500b76f5590'
    assert_response :success
    assert_equal 'image/png', @response.content_type
  end

end
