class UserHiddenThought < ApplicationRecord
  belongs_to :user
  belongs_to :thought
end
