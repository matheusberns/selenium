# frozen_string_literal: true

module ActiveInactive
  extend ActiveSupport::Concern

  included do
    scope :active, ->(active) { where(active: active) }

    def destroy
      run_callbacks(:destroy) do
        update_columns(active: false, deleted_at: DateTime.now)
      end
    end

    def restore
      if valid?
        update_columns(active: true, deleted_at: nil)
      else
        false
      end
    end
  end
end
