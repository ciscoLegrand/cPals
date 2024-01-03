class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :railsnew, :contact]

  def index; end
  def chatia
    client = OpenAI::Client.new
    response = client.models.list
    @models = response["data"]
  end

  def railsnew; end

  def contact; end
end
