class LikesController < ApplicationController
  before_action :authenticate_user!


  def create
    puts "Hello!"
    @picture = Picture.find(params[:picture_id])
    @like = @picture.likes.build_with_user(like_params, current_user)

    respond_to do |format|
      if @like.save
        format.html { redirect_to pictures_path, notice: 'Like was successfully created.' }
        format.json { render :show, status: :created, location: @like }
      else
        format.html { render :new }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end
end
