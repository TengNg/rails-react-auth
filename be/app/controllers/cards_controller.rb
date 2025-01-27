class CardsController < ProtectedController
  before_action :set_card, only: %i[show update destroy]

  # GET /cards
  def index
    if @user
      @cards = @user.cards
    else
      @cards = Card.where(user_id: @user_id)
    end

    render json: @cards
  end

  # GET /cards/1
  def show
    render json: @card
  end

  # POST /cards
  def create
    if @user
      @card = @user.cards.new(card_params)
    else
      @card = Card.new(card_params.merge(user_id: @user_id))
    end

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
    if @user
      @card = @user.cards.find(params[:id])
      return
    end

    @card = Card.where(user_id: @user_id).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Card not found' }, status: :not_found
  end

  def card_params
    params.require(:card).permit(:title)
  end
end
