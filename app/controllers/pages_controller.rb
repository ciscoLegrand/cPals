class PagesController < ApplicationController
  def index
    client = OpenAI::Client.new
    response = client.models.list
    @models = response["data"]
  end
end
