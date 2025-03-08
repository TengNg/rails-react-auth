class CardsController < ProtectedController
  before_action :set_card, only: %i[show update destroy]

  # GET /cards
  def index
    @cards = current_user.cards

    render json: @cards
  end

  # GET /cards/1
  def show
    render json: @card
  end

  # POST /cards
  def create
    @card = current_user.cards.new(card_params)

    if @card.save
      render json: @card, status: :created, location: @card and return
    end

    render json: @card.errors, status: :unprocessable_entity
  end

  # PATCH/PUT /cards/1
  def update
    if @card.update(card_params)
      render json: @card and return
    end

    render json: @card.errors, status: :unprocessable_entity
  end

  # DELETE /cards/1
  def destroy
    @card.destroy!
  end

  private

  def set_card
    @card = current_user.cards.find_by(id: params[:id])

    head :not_found if @card.nil?
  end

  def card_params
    params.require(:card).permit(:title)
  end

  def current_user
    @user || User.new(id: @user_id)
  end
end
