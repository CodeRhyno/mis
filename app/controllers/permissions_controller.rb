class PermissionsController < ApplicationController
  before_action :require_admin
  before_action :set_permission, only: [:show, :edit, :update, :destroy]

  def index
    @permissions = Permission.order(:title)
  end

  def show
  end

  def new
    @permission = Permission.new
  end

  def create
    @permission = Permission.new(permission_params)

    if @permission.save
      redirect_to permissions_path, notice: 'Permission created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @permission.update(permission_params)
      redirect_to permission_path(@permission), notice: 'Permission updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @permission.destroy
    redirect_to permissions_path, notice: 'Permission deleted successfully'
  end

  private

  def set_permission
    @permission = Permission.find(params[:id])
  end

  def permission_params
    params.require(:permission).permit(:title, :resource_type, :action, :description)
  end
end
