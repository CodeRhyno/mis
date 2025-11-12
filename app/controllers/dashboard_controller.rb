class DashboardController < ApplicationController
  def index
    @user = current_user

    case @user.role
    when 'admin'
      @users_count = User.count
      @records_count = Record.count
      @circles_count = Circle.count
      @branches_count = Branch.count
    when 'circle_admin'
      @branches = @user.circle.branches
      @records_count = Record.where(circle: @user.circle).count
    when 'checker'
      @unverified_records = Record.where(branch: @user.branch, verified: false)
    when 'maker'
      @my_records = @user.created_records
    end
  end
end
