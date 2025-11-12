class Permission < ApplicationRecord
  has_many :user_permissions, dependent: :destroy
  has_many :users, through: :user_permissions
  has_many :record_permissions, dependent: :destroy
  has_many :records, through: :record_permissions

  validates :title, presence: true
end
