# frozen_string_literal: true

module Traceability
  extend ActiveSupport::Concern

  included do
    # Associations
    belongs_to :created_by, class_name: '::User', required: false, foreign_key: :created_by_id
    belongs_to :updated_by, class_name: '::User', required: false, foreign_key: :updated_by_id

    # Scopes
    scope :traceability, lambda {
      select('created_user.name created_name, updated_user.name updated_name')
        .joins("LEFT JOIN users created_user ON created_user.id = #{table_name}.created_by_id")
        .joins("LEFT JOIN users updated_user ON updated_user.id = #{table_name}.updated_by_id")
    }
  end
end
