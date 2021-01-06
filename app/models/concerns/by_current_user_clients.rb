# frozen_string_literal: true

module ByCurrentUserClients
  extend ActiveSupport::Concern

  included do
    # Scopes
    scope :by_current_user_clients, lambda { |current_user|
      where("EXISTS(SELECT 1 FROM #{::UserClient.table_name} WHERE #{::UserClient.table_name}.client_id = #{table_name}.client_id "\
          "AND #{::UserClient.table_name}.user_id = :current_user_id "\
          "AND #{::UserClient.table_name}.active = TRUE)", current_user_id: current_user.id)
    }
  end
end
