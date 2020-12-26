class ProductIndexSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :code, :derivation, :description
end