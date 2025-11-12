class Document < ApplicationRecord
  belongs_to :record
  belongs_to :uploaded_by, class_name: 'User', foreign_key: 'uploaded_by_id'

  validates :filename, presence: true
  validates :sha256_hash, presence: true, uniqueness: true
  validate :validate_pdf_file

  before_validation :generate_sha256_hash, on: :create

  attr_accessor :file

  def self.verify_document(file)
    hash = Digest::SHA256.file(file.tempfile).hexdigest
    find_by(sha256_hash: hash)
  end

  def verify_integrity(file)
    new_hash = Digest::SHA256.file(file.tempfile).hexdigest
    new_hash == sha256_hash
  end

  private

  def validate_pdf_file
    if file.present?
      unless file.content_type == 'application/pdf'
        errors.add(:file, 'must be a PDF file')
      end

      if file.size > 10.megabytes
        errors.add(:file, 'size must be less than 10MB')
      end
    end
  end

  def generate_sha256_hash
    if file.present?
      self.sha256_hash = Digest::SHA256.file(file.tempfile).hexdigest
      self.filename = file.original_filename
      self.content_type = file.content_type
      self.file_size = file.size

      # Save file to storage
      save_file_to_storage
    end
  end

  def save_file_to_storage
    upload_dir = Rails.root.join('storage', 'documents', record_id.to_s)
    FileUtils.mkdir_p(upload_dir) unless Dir.exist?(upload_dir)

    filename_with_hash = "#{Time.now.to_i}_#{sha256_hash[0..8]}_#{file.original_filename}"
    file_path = upload_dir.join(filename_with_hash)

    File.open(file_path, 'wb') do |f|
      f.write(file.read)
    end

    self.file_path = file_path.to_s
  end
end
