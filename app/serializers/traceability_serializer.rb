# frozen_string_literal: true

class TraceabilitySerializer < BaseSerializer
  attribute :created_by do |object|
    {
      id: object.created_by_id,
      name: object.created_name
    }
  end

  attribute :updated_by do |object|
    {
      id: object.updated_by_id,
      name: object.updated_name
    }
  end
end
