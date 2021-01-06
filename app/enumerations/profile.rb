# frozen_string_literal: true

class Profile < EnumerateIt::Base
  associate_values(
    admin: 1,
    client: 2
  )
end
