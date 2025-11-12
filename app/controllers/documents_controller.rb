class DocumentsController < ApplicationController
  before_action :set_record, only: [:verify_upload]

  def download
    @document = Document.find(params[:id])

    if File.exist?(@document.file_path)
      send_file @document.file_path,
                filename: @document.filename,
                type: @document.content_type,
                disposition: 'attachment'
    else
      redirect_to record_path(@document.record), alert: 'File not found'
    end
  end

  def verify
    uploaded_file = params[:file]

    if uploaded_file.blank?
      redirect_to records_path, alert: 'Please select a file to verify'
      return
    end

    # Calculate hash of uploaded file
    hash = Digest::SHA256.file(uploaded_file.tempfile).hexdigest

    # Find matching document
    @document = Document.find_by(sha256_hash: hash)

    if @document
      @verification_result = {
        status: 'success',
        message: 'Document verified successfully!',
        document: @document,
        hash: hash
      }
    else
      @verification_result = {
        status: 'failed',
        message: 'Document not found in the system. This file has not been uploaded before or has been modified.',
        hash: hash
      }
    end

    render :verification_result
  end

  def verify_upload
    # Verify document during upload to check for duplicates
    uploaded_file = params[:file]

    if uploaded_file.present?
      hash = Digest::SHA256.file(uploaded_file.tempfile).hexdigest
      existing_doc = Document.find_by(sha256_hash: hash)

      if existing_doc
        render json: {
          exists: true,
          message: "This document already exists in record: #{existing_doc.record.title}",
          hash: hash
        }
      else
        render json: { exists: false, hash: hash }
      end
    else
      render json: { error: 'No file provided' }, status: :unprocessable_entity
    end
  end

  private

  def set_record
    @record = Record.find(params[:record_id]) if params[:record_id]
  end
end
