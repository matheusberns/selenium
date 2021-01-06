# frozen_string_literal: true

module ByCreated
  extend ActiveSupport::Concern

  included do
    # Scopes
    scope :by_created_date, lambda { |start_date, end_date|
      start_date = Date.parse(start_date).strftime('%Y-%m-%d') if start_date
      end_date = Date.parse(end_date).strftime('%Y-%m-%d') if end_date

      if start_date && end_date
        where("#{table_name}.created_at >= :start_date and #{table_name}.created_at <= :end_date", start_date: start_date, end_date: end_date)
      elsif start_date
        where("#{table_name}.created_at >= :start_date", start_date: start_date)
      elsif end_date
        where("#{table_name}.created_at <= :end_date", end_date: end_date)
      end
    }
  end
end
