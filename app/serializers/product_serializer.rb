# frozen_string_literal: true

class ProductSerializer < TraceabilitySerializer
  attribute :name, :code, :description, :derivation, :price

  # attribute :example do |object|
  #   {
  #       id: object.attribute,
  #       name: object.another_attribute
  #   }
  # end
end
