module Indicator
  class Indicator < ApplicationRecord
    
      
        
          has_one :neo_pixel, dependent: :destroy
          accepts_nested_attributes_for :neo_pixel
        
          has_one :button, dependent: :destroy
          accepts_nested_attributes_for :button
        
          has_one :led, dependent: :destroy
          accepts_nested_attributes_for :led
        
      
    
  end
end