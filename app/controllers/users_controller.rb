class UsersController < ApplicationController
  before_action :require_admin, except: [:show]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :suspend, :activate]

  def index
    @users = User.includes(:circle, :branch).order(created_at: :desc)
  end

  def show
  end

  def new
    @user = User.new
    @circles = Circle.active
    @branches = Branch.active
    @permissions = Permission.all
  end

  def create
    @user = User.new(user_params)
    @user.password = params[:user][:password]

    if @user.save
      # Assign permissions
      if params[:permission_ids].present?
        params[:permission_ids].each do |permission_id|
          @user.user_permissions.create(permission_id: permission_id)
        end
      end

      redirect_to users_path, notice: 'User created successfully'
    else
      @circles = Circle.active
      @branches = Branch.active
      @permissions = Permission.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @circles = Circle.active
    @branches = Branch.active
    @permissions = Permission.all
  end

  def update
    if @user.update(user_params)
      # Update permissions
      @user.user_permissions.destroy_all
      if params[:permission_ids].present?
        params[:permission_ids].each do |permission_id|
          @user.user_permissions.create(permission_id: permission_id)
        end
      end

      redirect_to user_path(@user), notice: 'User updated successfully'
    else
      @circles = Circle.active
      @branches = Branch.active
      @permissions = Permission.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User deleted successfully'
  end

  def suspend
    @user.update(suspended: true)
    redirect_to user_path(@user), notice: 'User suspended successfully'
  end

  def activate
    @user.update(suspended: false)
    redirect_to user_path(@user), notice: 'User activated successfully'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :role, :circle_id, :branch_id, :active)
  end
end
