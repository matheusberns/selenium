# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :photo, :saved_photo, :clients_ids

  # Concerns
  include ::ActiveInactive
  include ::ByCreated
  include ::Traceability

  # Uploader
  has_one_attached :avatar

  # Enumerate
  has_enumeration_for :profile, with: ::Profile, create_helpers: { prefix: true }

  # Associations

  # Scopes
  scope :all_fields, lambda {
    select("#{table_name}.*")
      .includes(avatar_attachment: :blob)
      .traceability
  }
  scope :by_account_id, ->(account_id) { where(account_id: account_id) }
  scope :by_company_id, ->(company_id = nil) { where(company_id: company_id) }
  scope :by_email, ->(email) { where("UNACCENT(#{table_name}.email) ILIKE UNACCENT(:email)", email: "%#{email}%") }
  scope :by_name, ->(name) { where("UNACCENT(#{table_name}.name) ILIKE UNACCENT(:name)", name: "%#{name}%") }
  scope :by_profile, ->(profile) { where(profile: profile) }
  scope :by_password_expiry, ->(password_expiry) { where(password_expiry: password_expiry) }
  scope :by_one_day_to_expiry_password, lambda {
    # Select users with password changed in last twenty nine days
    date = Date.today - 29.days
    where("CAST(#{table_name}.password_changed_at AS DATE) = ?", date)
  }
  scope :by_expired_password, lambda {
    # Select users with password expired
    date = Date.today - 30.days
    where("CAST(#{table_name}.password_changed_at AS DATE) = ?", date)
  }

  # Callbacks
  before_save :update_password_changed_at
  before_save :remove_password_changed_at
  after_save :parse_photo
  after_save :set_user_clients, unless: -> { clients_ids.nil? }

  # Validations
  validates_presence_of :name, :email
  validates_uniqueness_of :email, scope: :account_id

  def as_json(_options = nil)
    AdminSerializer.new(User.all_fields.find(id)).serializable_hash[:data][:attributes]
  end

  def is_client
    profile == ::Profile::CLIENT
  end

  def is_admin
    profile == ::Profile::ADMIN
  end

  def update_password_changed_at
    self.password_changed_at = DateTime.now if password_expiry && password && password_confirmation
  end

  def remove_password_changed_at
    self.password_changed_at = nil unless password_expiry
  end

  private

  def set_user_clients
    clients_ids.each do |client_id|
      user_clients.find_or_create_by(client_id: client_id)
    end
    user_clients.where.not(client_id: clients_ids).destroy_all
  end

  def parse_photo
    unless saved_photo
      unless photo.nil? || photo[%r{(image/[a-z]{3,4})|(application/[a-z]{3,4})}] == ''
        self.saved_photo = true
        content_type = photo[%r{(image/[a-z]{3,4})|(application/[a-z]{3,4})}]
        content_type = content_type[%r{\b(?!.*/).*}]
        contents = photo.sub %r{data:((image|application)/.{3,}),}, ''
        decoded_data = Base64.decode64(contents)
        filename = 'photo_' + Time.zone.now.to_s + '.' + content_type
        File.open("#{Rails.root}/public/#{filename}", 'wb') do |f|
          f.write(decoded_data)
        end
        avatar.attach(io: File.open("#{Rails.root}/public/#{filename}"), filename: filename)
        FileUtils.rm("#{Rails.root}/public/#{filename}")
      end
    end
  end
end
