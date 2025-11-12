class RecordPermission < ApplicationRecord
  belongs_to :record
  belongs_to :permission
end
