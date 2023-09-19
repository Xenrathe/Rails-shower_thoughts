class ThoughtsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  
  def index
    @thoughts = Thought.order(post_time: :desc)
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

  private

    def thought_params
      params.require(:thought).permit(:title, :content)
    end

end