class EmailRecord < ApplicationRecord
  belongs_to :shop
  scope :this_month, -> {where('sent > ?', Date.today.beginning_of_month)}
end
