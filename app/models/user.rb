class User < ApplicationRecord
  has_secure_password

  belongs_to :circle, optional: true
  belongs_to :branch, optional: true
  has_many :user_permissions, dependent: :destroy
  has_many :permissions, through: :user_permissions
  has_many :created_records, class_name: 'Record', foreign_key: 'created_by_id'
  has_many :verified_records, class_name: 'Record', foreign_key: 'verified_by_id'

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true, inclusion: { in: %w[admin circle_admin maker checker] }
  validates :first_name, :last_name, presence: true

  scope :active, -> { where(active: true, suspended: false) }
  scope :suspended, -> { where(suspended: true) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def admin?
    role == 'admin'
  end

  def circle_admin?
    role == 'circle_admin'
  end

  def maker?
    role == 'maker'
  end

  def checker?
    role == 'checker'
  end

  def can_access?
    active && !suspended
  end
end
