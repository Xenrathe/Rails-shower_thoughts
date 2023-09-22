class ThoughtsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :authenticate_destroy, only: [:destroy]

  def index
    @thoughts = Thought.order(post_time: :desc)

    @selected_filter = params[:filter] || cookies[:selected_filter] || 'visible'
    cookies[:selected_filter] = @selected_filter

    # Show only UNHIDDEN thoughts only, except for master/admin
    if current_user.plumber_status != "Master"
      @thoughts = @thoughts.where.not(id: current_user.hidden_thoughts.pluck(:id))
    end

    # Show FAVORITE thoughts only
    @thoughts = @thoughts.where(id: current_user.favorite_thoughts.pluck(:id)) if @selected_filter == "favorite"
    # Show HIGHLIGHTED thoughts only
    @thoughts = @thoughts.where(highlight_mode: "true") if @selected_filter == "spotlight"
  end

  #def show
  #  @article = Article.find(params[:id])
  #end

  def new
    @thought = Thought.new
  end

  def create
    @thought = Thought.new(thought_params)
    @thought.user = current_user
    @thought.post_time = DateTime.current

    if @thought.save
      redirect_to thoughts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @thought = Thought.find(params[:id])
    @thought.destroy

    respond_to do |format|
      format.html { redirect_to thoughts_url, notice: 'Thought deleted.' }
      format.json { head :no_content }
    end
  end

  def hide
    @thought = Thought.find(params[:id])
    user_hidden_thought = current_user.user_hidden_thoughts.find_or_initialize_by(thought: @thought)

    if user_hidden_thought.new_record?
      user_hidden_thought.save
      render json: { status: 'hidden' }
    else
      user_hidden_thought.destroy
      render json: { status: 'unhidden' }
    end
  end

  def favorite
    @thought = Thought.find(params[:id])
    user_favorite_thought = current_user.user_favorite_thoughts.find_or_initialize_by(thought: @thought)

    if user_favorite_thought.new_record?
      user_favorite_thought.save
      render json: { status: 'favorited' }
    else
      user_favorite_thought.destroy
      render json: { status: 'unfavorited' }
    end
  end

  private

    def thought_params
      params.require(:thought).permit(:title, :content)
    end

    def authenticate_destroy
      @thought = Thought.find(params[:id])
      unless current_user && (current_user.plumber_status == 'Master' || @thought.user == current_user)
        flash[:alert] = "You do not have access to this page."
        redirect_to root_path
      end
    end
end