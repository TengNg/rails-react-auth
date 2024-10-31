class CardsController < ProtectedController
  before_action :set_card, only: %i[show update destroy]

  # GET /cards
  def index
    @cards = @user.cards
    render json: @cards
  end

  # GET /cards/1
  def show
    render json: @card
  end

  # POST /cards
  def create
    @card = @user.cards.new(card_params)

    if @card.save
      render json: @card, status: :created, location: @card
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /cards/1
  def update
    if @card.update(card_params)
      render json: @card
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  # DELETE /cards/1
  def destroy
    @card.destroy!
  end

  private

  def set_card
    @card = @user.cards.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:title)
  end
end
