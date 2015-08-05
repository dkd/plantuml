class PlantumlController < ApplicationController
  unloadable

  def convert
    frmt = PlantumlHelper.check_format(params[:content_type])
    filename = params[:filename]
    send_file(File.join(Rails.root, 'files', "#{filename}#{frmt[:ext]}"), type: frmt[:content_type], disposition: frmt[:inline])
  end
end
