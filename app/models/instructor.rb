class Instructor < ApplicationRecord
  # has_and_belongs_to_many :submissions
  validates :uid, presence: true
end
