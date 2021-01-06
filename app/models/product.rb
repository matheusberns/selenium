class Product < ApplicationRecord
  attr_accessor :skip_validation

  #Paranoia
  acts_as_paranoid

  # Concerns
  include ::ActiveInactive
  include ::ByCreated
  include ::Traceability

  # Uploader

  # Enumerate
  has_enumeration_for :derivation, with: ::DerivationType

  # Associations

  # Many-to-many associations

  # Scopes
  scope :all_fields, lambda {
    select("#{table_name}.*")
        .traceability
  }
  scope :by_name, ->(name) { where("UNACCENT(#{table_name}.name) ILIKE UNACCENT(:name)", name: "%#{name}%") }
  scope :by_derivation, ->(derivation) { where(derivation: derivation) }

  # Callbacks

  # Validations
  validates_presence_of :name, :code, :description, :price, :derivation, unless: :skip_validation
  validates_uniqueness_of :code, :name, unless: :skip_validation
  validates_length_of :name, maximum: 255, unless: :skip_validation
  validates_length_of :code, maximum: 255, unless: :skip_validation
end
