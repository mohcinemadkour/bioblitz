class Api::ProxyController < ApplicationController
  def show
    render :text => Net::HTTP.get(URI.parse(params[:url]))
  end
end