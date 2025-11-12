class BranchesController < ApplicationController
  before_action :require_circle_admin
  before_action :set_branch, only: [ :show, :edit, :update, :destroy ]

  def index
    @branches = if current_user.admin?
                  Branch.includes(:circle).order(:name)
                else
                  current_user.circle.branches.order(:name)
                end
  end

  def show
  end

  def new
    @branch = Branch.new
    @circles = current_user.admin? ? Circle.active : [current_user.circle ]
  end

  def create
    @branch = Branch.new(branch_params)

    if @branch.save
      redirect_to branches_path, notice: 'Branch created successfully'
    else
      @circles = current_user.admin? ? Circle.active : [current_user.circle ]
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @circles = current_user.admin? ? Circle.active : [current_user.circle ]
  end

  def update
    if @branch.update(branch_params)
      redirect_to branch_path(@branch), notice: 'Branch updated successfully'
    else
      @circles = current_user.admin? ? Circle.active : [current_user.circle ]
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @branch.destroy
    redirect_to branches_path, notice: 'Branch deleted successfully'
  end

  private

  def set_branch
    @branch = Branch.find(params[:id])
  end

  def branch_params
    params.require(:branch).permit(:name, :code, :address, :circle_id, :active)
  end
end
