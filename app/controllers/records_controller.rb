class RecordsController < ApplicationController
  before_action :set_record, only: [:show, :edit, :update, :destroy, :verify, :object]

  def index
    @records = case current_user.role
               when 'admin'
                 Record.includes(:circle, :branch, :created_by).order(created_at: :desc)
               when 'circle_admin'
                 Record.where(circle: current_user.circle).includes(:branch, :created_by).order(created_at: :desc)
               when 'checker'
                 Record.where(branch: current_user.branch).includes(:created_by).order(created_at: :desc)
               when 'maker'
                 current_user.created_records.order(created_at: :desc)
               end
  end

  def show
  end

  def new
    @record = Record.new
    @circles = Circle.active
    @branches = Branch.active
    @permissions = Permission.all
  end

  def create
    @record = Record.new(record_params)
    @record.created_by = current_user

    if @record.save
      # Assign permissions
      if params[:permission_ids].present?
        params[:permission_ids].each do |permission_id|
          @record.record_permissions.create(permission_id: permission_id)
        end
      end

      # Handle file uploads
      if params[:documents].present?
        params[:documents].each do |file|
          document = @record.documents.build(
            file: file,
            uploaded_by: current_user
          )

          unless document.save
            flash[:alert] = "Error uploading #{file.original_filename}: #{document.errors.full_messages.join(', ')}"
          end
        end
      end

      redirect_to records_path, notice: 'Record created successfully'
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
    if @record.update(record_params)
      # Can only add new permissions, not remove existing ones
      if params[:permission_ids].present?
        params[:permission_ids].each do |permission_id|
          @record.record_permissions.find_or_create_by(permission_id: permission_id)
        end
      end

      # Handle new file uploads (can only add, not remove)
      if params[:documents].present?
        params[:documents].each do |file|
          document = @record.documents.build(
            file: file,
            uploaded_by: current_user
          )

          unless document.save
            flash[:alert] = "Error uploading #{file.original_filename}: #{document.errors.full_messages.join(', ')}"
          end
        end
      end

      redirect_to record_path(@record), notice: 'Record updated successfully'
    else
      @circles = Circle.active
      @branches = Branch.active
      @permissions = Permission.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @record.destroy
    redirect_to records_path, notice: 'Record deleted successfully'
  end

  def verify
    if current_user.checker?
      @record.update(
        verified: true,
        verified_by: current_user,
        verified_at: Time.current
      )
      redirect_to records_path, notice: 'Record verified successfully'
    else
      redirect_to records_path, alert: 'Access denied'
    end
  end

  def object
    if current_user.checker?
      @record.update(
        objected: true,
        objection_reason: params[:objection_reason]
      )
      redirect_to records_path, notice: 'Record objected'
    else
      redirect_to records_path, alert: 'Access denied'
    end
  end

  private

  def set_record
    @record = Record.find(params[:id])
  end

  def record_params
    params.require(:record).permit(:title, :description, :circle_id, :branch_id)
  end
end
