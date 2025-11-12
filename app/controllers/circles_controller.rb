class CirclesController < ApplicationController
  before_action :require_admin
  before_action :set_circle, only: [:show, :edit, :update, :destroy]

  def index
    @circles = Circle.order(:name)
  end

  def show
  end

  def new
    @circle = Circle.new
  end

  def create
    @circle = Circle.new(circle_params)

    if @circle.save
      redirect_to circles_path, notice: 'Circle created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @circle.update(circle_params)
      redirect_to circle_path(@circle), notice: 'Circle updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @circle.destroy
    redirect_to circles_path, notice: 'Circle deleted successfully'
  end

  private

  def set_circle
    @circle = Circle.find(params[:id])
  end

  def circle_params
    params.require(:circle).permit(:name, :code, :description, :active)
  end
end
