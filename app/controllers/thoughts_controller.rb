class ThoughtsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :authenticate_destroy, only: [:destroy]
  before_action :authenticate_spotlight, only: [:spotlight]
  before_action :authenticate_shadow, only: [:shadow]

  def index
    @thoughts = Thought.order(post_time: :desc)

    @selected_filter = params[:filter] || cookies[:selected_filter] || 'visible'
    cookies[:selected_filter] = @selected_filter

    # If user isn't admin, show only posts by non-shadowbanned users
    # Shadowbanned users will still see their own posts, however
    # NOTE: A shadowbanned user could easily logout and note that their own post is not visible
    # Which would alert them to the shadowban and motivate creating a new account
    # This is a weakness of this system that could be partially ameloriated through using a more advanced fingerprint system
    if current_user
      if current_user.plumber_status != 'Master'
        @thoughts = @thoughts.includes(:user).where.not(users: { plumber_status: 'Shadow'}).or(Thought.where(user_id: current_user.id))
      end
    else
      @thoughts = @thoughts.includes(:user).where.not(users: { plumber_status: 'Shadow'})
    end

    # Show only UNHIDDEN thoughts only, except for master/admin
    if current_user && current_user.plumber_status != "Master"
      @thoughts = @thoughts.where.not(id: current_user.hidden_thoughts.pluck(:id))
    end

    # Show FAVORITE thoughts only
    if current_user
      @thoughts = @thoughts.where(id: current_user.favorite_thoughts.pluck(:id)) if @selected_filter == "favorite"
    end

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

    if (current_user.plumber_status = 'Master' || current_user.last_post_date.nil? || current_user.last_post_date < DateTime.current - 24.hours) && @thought.save
      current_user.update(last_post_date: DateTime.now)
      redirect_to thoughts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Users can destroy their own thoughts
  # Admin/Master plumbers can destroy any thought
  def destroy
    @thought = Thought.find(params[:id])
    @thought.destroy

    respond_to do |format|
      format.html { redirect_to thoughts_url, notice: 'Thought deleted.' }
      format.json { head :no_content }
    end
  end

  # Users can hide thoughts so they do not ever have to see them again
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

  # Users can favorite thoughts and then filter them later
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

  # Plumber can spotlight ONE thought (not their own, not already spotlit) before losing plumber status
  # Spotlit thoughts receive special styling to make them stand out
  def spotlight
    @thought = Thought.find(params[:id])

    if current_user && current_user.plumber_status == 'Plumber' && @thought.highlight_mode != 'true'
      if @thought.user_id != current_user.id
        @thought.update(highlight_mode: 'true')
        current_user.update(plumber_status: 'No')
        render json: { status: 'spotlighted' }
      else
        flash[:alert] = "You cannot spotlight your own thought."
        redirect_to root_path
      end
    elsif current_user && current_user.plumber_status == 'Master'
      if @thought.highlight_mode == 'true'
        @thought.update(highlight_mode: 'false')
        render json: { status: 'unspotlighted' }
      else
        @thought.update(highlight_mode: 'true')
        render json: { status: 'spotlighted' }
      end
    end
  end

  # Shadow bans a user, no one else can see their thoughts, but they will not know that
  def shadow
    @thought = Thought.find(params[:id])
    
    if current_user && current_user.plumber_status == 'Master'
      if @thought.user.plumber_status == 'Shadow'
        @thought.user.update(plumber_status: 'No')
        render json: { status: 'unshadowed'}
      else
        @thought.user.update(plumber_status: 'Shadow')
        render json: { status: 'shadowed'}
      end
    end
  end

  private

    def thought_params
      params.require(:thought).permit(:title, :content)
    end

    # Master/admin or owner of thought
    def authenticate_destroy
      @thought = Thought.find(params[:id])
      unless current_user && (current_user.plumber_status == 'Master' || @thought.user == current_user)
        flash[:alert] = "You can only delete your own thoughts."
        redirect_to root_path
      end
    end

    # Master/admin or plumber
    def authenticate_spotlight
      unless current_user && (current_user.plumber_status == 'Master' || current_user.plumber_status == 'Plumber')
        flash[:alert] = "Only plumbers can spotlight."
        redirect_to root_path
      end
    end

    # Master/admin only
    def authenticate_shadow
      unless current_user && current_user.plumber_status == 'Master'
        flash[:alert] = "Only admins can use this function."
        redirect_to root_path
      end
    end
end