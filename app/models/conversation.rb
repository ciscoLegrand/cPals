# frozen_string_literal: true

class Conversation < ApplicationRecord
  has_many :interactions, dependent: :destroy

  scope :today, -> { where(created_at: Date.today.all_day) }
  scope :yesterday, -> { where(created_at: Date.yesterday.all_day) }
  scope :last_7_days, -> { where(created_at: 7.days.ago.beginning_of_day..2.days.ago.end_of_day) }
  scope :last_30_days, -> { where(created_at: 30.days.ago.beginning_of_day..8.days.ago.end_of_day) }
  scope :older, -> { where(created_at: 5.years.ago.beginning_of_day..31.days.ago.beginning_of_day) }
end
