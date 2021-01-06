# frozen_string_literal: true

class BaseSerializer
  include FastJsonapi::ObjectSerializer
  attribute :id, :active, :uuid

  attribute :created_at do |object|
    I18n.localize object.created_at, format: :to_s
  end

  attribute :updated_at do |object|
    I18n.localize object.updated_at, format: :to_s
  end

  attribute :deleted_at do |object|
    I18n.localize object.deleted_at, format: :to_s if object.deleted_at
  end

  attribute :env_production do |_object|
    Rails.env.production?
  end
end
