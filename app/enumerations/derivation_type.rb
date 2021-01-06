# frozen_string_literal: true

class DerivationType < EnumerateIt::Base
  associate_values(
      #Shirts
      shirt_p: 1,
      shirt_m: 2,
      shirt_g: 3,
      shirt_gg: 4,
      shirt_eg: 5
  )
end
