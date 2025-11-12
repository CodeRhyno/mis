class Branch < ApplicationRecord
  belongs_to :circle
  has_many :users
  has_many :records

  validates :name, presence: true
  validates :code, uniqueness: true, allow_blank: true

  scope :active, -> { where(active: true) }
end
