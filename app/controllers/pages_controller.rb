class PagesController < ApplicationController
  def index

  end

  def chatia
    client = OpenAI::Client.new
    response = client.models.list
    @models = response["data"]
  end

  def railsnew; end
end
