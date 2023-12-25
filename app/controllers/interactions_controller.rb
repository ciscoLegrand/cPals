class InteractionsController < ApplicationController
  before_action :set_interaction, only: %i[ show edit update destroy ]

  # GET /interactions
  def index
    @interactions = Interaction.all
  end

  # GET /interactions/1
  def show
  end

  # GET /interactions/new
  def new
    @interaction = Interaction.new
  end

  # GET /interactions/1/edit
  def edit
  end

  # POST /interactions
  def create
    @interaction = Interaction.new(interaction_params)

    if @interaction.save
      redirect_to @interaction, notice: "Interaction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /interactions/1
  def update
    if @interaction.update(interaction_params)
      redirect_to @interaction, notice: "Interaction was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /interactions/1
  def destroy
    @interaction.destroy!
    redirect_to interactions_url, notice: "Interaction was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interaction
      @interaction = Interaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def interaction_params
      params.require(:interaction).permit(:conversation_id, :question_text, :answer_text, :response_metadata, :model_used, :prompt_settings)
    end
end
