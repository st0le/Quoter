class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorized_user, only: [:edit, :update, :destroy]
  # GET /quotes
  # GET /quotes.json
  def index
    @quotes = Quote.all.paginate(page: params[:page], per_page: 3)
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
  end

  # GET /quotes/new
  def new
    @quote = current_user.quotes.build
  end

  # GET /quotes/1/edit
  def edit
  end

  def upvote
    @quote = Quote.find(params[:id])
    @quote.upvote_by current_user
    redirect_to :back
  end

  def downvote
    @quote = Quote.find(params[:id])
    @quote.downvote_by current_user
    redirect_to :back
  end

  # POST /quotes
  # POST /quotes.json
  def create
    @quote = current_user.quotes.build(quote_params)

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: 'Quote was successfully created.' }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotes/1
  # PATCH/PUT /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to quotes_url, notice: 'Quote was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    def authorized_user
      @quote = current_user.quotes.find_by(id: params[:id])
      redirect_to quotes_path, notice: "Not authorized to edit this link" if @quote.nil?
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def quote_params
      params.require(:quote).permit(:author, :quote)
    end
end
