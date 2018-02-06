module Indicator
  class Indicator < ApplicationRecord

    has_one :neo_pixel, dependent: :destroy
    accepts_nested_attributes_for :neo_pixel
  
    has_one :button, dependent: :destroy
    accepts_nested_attributes_for :button
  
    has_one :led, dependent: :destroy
    accepts_nested_attributes_for :led

    @@current_state = {}

    def self.current_state
      @@current_state
    end
    
    def self.current_state=(state)
      @@current_state = state
    end

    # STAFFING_LEVELS = {
    #   500 => 'Error',
    #   0 => 'Empty',
    #   1 => 'Inadequate',
    #   2 => 'Adequate',
    #   3 => 'Satisfied',
    #   4 => 'Full'
    # }

    LED_STAFFING_MAP = {
      'Error' => 1,
      'Empty' => 3,
      'Inadequate' => 7,
      'Adequate' => 11,
      'Satisfied' => 15,
      'Full' => 19
    }

    # { staffing_level_name: 'Adequate', staffing_level_number: 2}
    def self.update_state(new_state)
      indicator = Indicator.first
      indicator.set_state(new_state)
      indicator.save
    end
    
    def set_state(new_state)
      unless self.class.current_state == new_state
        np = self.neo_pixel
        self.class.current_state = new_state
        staffing_level_name = new_state['staffing_level_name']
        puts "settings state to: #{staffing_level_name}"
        unless staffing_level_name == 'Error'
          new_led = LED_STAFFING_MAP[staffing_level_name] || [0]
          np.animate_set_speedometer!(new_led)
        else
          np.set_error!
        end
      end
    end
    
  end
end