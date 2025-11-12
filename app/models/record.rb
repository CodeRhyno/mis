class Record < ApplicationRecord
  belongs_to :circle, optional: true
  belongs_to :branch, optional: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :verified_by, class_name: 'User', foreign_key: 'verified_by_id', optional: true

  has_many :documents, dependent: :destroy
  has_many :record_permissions, dependent: :destroy
  has_many :permissions, through: :record_permissions

  validates :title, presence: true

  scope :verified, -> { where(verified: true) }
  scope :unverified, -> { where(verified: false) }
  scope :objected, -> { where(objected: true) }
end
