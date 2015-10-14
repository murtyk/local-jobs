class FindersController < ApplicationController
  def search
    return unless search_params
    @finder = Finder.new(user_ip, user_browser)
    @finder.search search_params

    markers = @finder.markers
    markers.size
  end

  private

  def search_params
    return unless params[:q]
    params[:q]
  end

  def user_ip
    request.location.data['ip']
  end

  def user_browser
    request.env['HTTP_USER_AGENT']
  end
end
