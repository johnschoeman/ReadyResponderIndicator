module Indicator
  class NeoPixel < ApplicationRecord
    # The method(s) that correspond to device interfaces are: pixel_0 pixel_1 pixel_2 pixel_3 pixel_4 pixel_5 pixel_6 pixel_7 pixel_8 pixel_9 pixel_10 pixel_11 pixel_12 pixel_13 pixel_14 pixel_15 pixel_16 pixel_17 pixel_18 pixel_19 pixel_20 pixel_21 pixel_22 pixel_23 pixel_24 pixel_25 pixel_26 pixel_27 pixel_28 pixel_29 pixel_30 pixel_31 pixel_32 pixel_33 pixel_34 pixel_35 pixel_36 pixel_37 pixel_38 pixel_39 pixel_40 pixel_41 pixel_42 pixel_43 pixel_44 pixel_45 pixel_46 pixel_47 pixel_48 pixel_49 pixel_50 pixel_51 pixel_52 pixel_53 pixel_54 pixel_55 pixel_56 pixel_57 pixel_58 pixel_59 pixel_60 pixel_61 pixel_62 pixel_63 pixel_64 pixel_65 pixel_66 pixel_67 pixel_68 pixel_69 pixel_70 pixel_71 pixel_72 pixel_73 pixel_74 pixel_75 pixel_76 pixel_77 pixel_78 pixel_79 pixel_80 pixel_81 pixel_82 pixel_83 pixel_84 pixel_85 pixel_86 pixel_87 pixel_88 pixel_89 pixel_90 pixel_91 pixel_92 pixel_93 pixel_94 pixel_95 pixel_96 pixel_97 pixel_98 pixel_99 pixel_100 pixel_101 pixel_102 pixel_103 pixel_104 pixel_105 pixel_106 pixel_107 pixel_108 pixel_109 pixel_110 pixel_111 pixel_112 pixel_113 pixel_114 pixel_115 pixel_116 pixel_117 pixel_118 pixel_119 pixel_120 pixel_121 pixel_122 pixel_123 pixel_124 pixel_125 pixel_126 pixel_127 pixel_128 pixel_129 pixel_130 pixel_131 pixel_132 pixel_133 pixel_134 pixel_135 pixel_136 pixel_137 pixel_138 pixel_139 pixel_140 pixel_141 pixel_142 pixel_143 pixel_144 pixel_145 pixel_146 pixel_147 pixel_148 pixel_149 pixel_150 pixel_151 pixel_152 pixel_153 pixel_154 pixel_155 pixel_156 pixel_157 pixel_158 pixel_159 pixel_160 pixel_161 pixel_162 pixel_163 pixel_164 pixel_165 pixel_166 pixel_167 pixel_168 pixel_169 pixel_170 pixel_171 pixel_172 pixel_173 pixel_174 pixel_175 pixel_176 pixel_177 pixel_178 pixel_179 pixel_180 pixel_181 pixel_182 pixel_183 pixel_184 pixel_185 pixel_186 pixel_187 pixel_188 pixel_189 pixel_190 pixel_191 pixel_192 pixel_193 pixel_194 pixel_195 pixel_196 pixel_197 pixel_198 pixel_199 pixel_200 pixel_201 pixel_202 pixel_203 pixel_204 pixel_205 pixel_206 pixel_207 pixel_208 pixel_209 pixel_210 pixel_211 pixel_212 pixel_213 pixel_214 pixel_215 pixel_216 pixel_217 pixel_218 pixel_219 pixel_220 pixel_221 pixel_222 pixel_223 pixel_224 pixel_225 pixel_226 pixel_227 pixel_228 pixel_229 pixel_230 pixel_231 pixel_232 pixel_233 pixel_234 pixel_235 pixel_236 pixel_237 pixel_238 pixel_239 pixel_240 pixel_241 pixel_242 pixel_243 pixel_244 pixel_245 pixel_246 pixel_247 pixel_248 pixel_249 pixel_250 pixel_251 pixel_252 pixel_253 pixel_254 pixel_255 pixels 
    
    belongs_to :indicator
    attr_accessor :skip_extract
    after_commit :extract, unless: :skip_extract
    after_commit :channel_push
    
    validates :pixel_0, :pixel_1, :pixel_2, :pixel_3, :pixel_4, :pixel_5, :pixel_6, :pixel_7, :pixel_8, :pixel_9, :pixel_10, :pixel_11, :pixel_12, :pixel_13, :pixel_14, :pixel_15, :pixel_16, :pixel_17, :pixel_18, :pixel_19, :pixel_20, :pixel_21, :pixel_22, :pixel_23, :pixel_24, :pixel_25, :pixel_26, :pixel_27, :pixel_28, :pixel_29, :pixel_30, :pixel_31, :pixel_32, inclusion: { in: 0..16777215 }
    validates :pixels, inclusion: { in: 0..256, message: "%{value} is not within the range 0..256" }

    NUM_PIXELS = 32
    MAX_PIXELS = 255
    NUM_LEDS = 24

    def self.generate_led_to_pixel_map(color)
      led_to_pixel_map = {}
      initial_count = {
        'red' => 1,
        'green' => 0,
        'blue' => 2,
      }
      pixel = color == 'green' ? -1 : 0
      count = initial_count[color]
      (0...NUM_LEDS).each do |led_idx|
        pixel += 1 if count % 3 == 0
        led_to_pixel_map[led_idx] = pixel
        pixel += 1
        count += 1
      end
      led_to_pixel_map
    end

    LED_TO_PIXEL_RED   = self.generate_led_to_pixel_map('red')   # == {0=>0, 1=>1, 2=>3, 3=>4, 4=>5, 5=>7, 6=>8, 7=>9, 8=>11, 9=>12, 10=>13, 11=>15, 12=>16, 13=>17, 14=>19, 15=>20, 16=>21, 17=>23, 18=>24, 19=>25, 20=>27, 21=>28, 22=>29, 23=>31} 
    LED_TO_PIXEL_GREEN = self.generate_led_to_pixel_map('green') # == {0=>0, 1=>1, 2=>2, 3=>4, 4=>5, 5=>6, 6=>8, 7=>9, 8=>10, 9=>12, 10=>13, 11=>14, 12=>16, 13=>17, 14=>18, 15=>20, 16=>21, 17=>22, 18=>24, 19=>25, 20=>26, 21=>28, 22=>29, 23=>30}
    LED_TO_PIXEL_BLUE  = self.generate_led_to_pixel_map('blue')  # == {0=>0, 1=>2, 2=>3, 3=>4, 4=>6, 5=>7, 6=>8, 7=>10, 8=>11, 9=>12, 10=>14, 11=>15, 12=>16, 13=>18, 14=>19, 15=>20, 16=>22, 17=>23, 18=>24, 19=>26, 20=>27, 21=>28, 22=>30, 23=>31}

    # LED COLORS
    LED_OFF    = { r: 0, g: 0, b: 0 }
    LED_RED    = { r: 1 }
    LED_YELLOW = { r: 2, g: 1 }
    LED_GREEN  = { g: 1 }
    LED_BLUE   = { b: 1 }

    # PIXEL COLORS
    PIXEL_OFF   = 0
    PIXEL_RED   = 1
    PIXEL_GREEN = 1 * 256
    PIXEL_BLUE  = 1 * 256 * 256
  
    def sync
      Apiotics.sync(self)
    end

    def set_pixel(pixel, value)
      raise 'pixel is undefined' unless pixel
      send("pixel_#{pixel}=", value)
    end

    def set_pixel!(pixel, value)
      set_pixel(pixel, value)
      save
    end

    def increment_pixel(pixel, value)
      old_value = send("pixel_#{pixel}")
      send("pixel_#{pixel}=", old_value + value)
    end

    def increment_pixel!(pixel, value)
      increment_pixel(pixel, value)
      save
    end

    def reset!
      3.times { flash_all_leds! }
    end

    def flash_all_leds!(color = LED_GREEN, timeout = 0.25)
      each_led { color }
      save
      sleep timeout
      each_pixel { PIXEL_OFF }
      save
    end

    # The neopixel ring can get into a wierd state, this will fix it.
    def reset_pixels!
      reset!
      pixels = MAX_PIXELS
      save
      reset!
      pixels = NUM_PIXELS
      save
      reset!
    end

    def clear!
      each_pixel { PIXEL_OFF }
      save
    end

    def each_pixel(&blk)
      raise 'block needed' unless block_given?
      (0...pixels).each { |pixel| set_pixel(pixel, blk.call(pixel)) }
      self
    end

    def each_led(&blk)
      raise 'block needed' unless block_given?
      (0...NUM_LEDS).each { |led| self.set_led(led, blk.call(led)) }
      self
    end

    def set_led_range(start_led = 0, stop_led = (NUM_LEDS - 1), &blk)
      raise 'block needed' unless block_given?
      (start_led..stop_led).each { |led| set_led(led, blk.call(led)) }
      self
    end

    def rgb(r,g,b)
      {r: r, g: g, b: b}
    end

    def set_led(led, color = LED_OFF)
      r = color[:r] || 0
      g = color[:g] || 0
      b = color[:b] || 0
      reset_pixels_for_led(led, r, g, b)
      increment_pixels_for_led(led, r, g, b)
    end

    def reset_pixels_for_led(led, r, g, b)
      set_pixel(LED_TO_PIXEL_RED[led], 0) unless g != 0 && !(r != 0)
      set_pixel(LED_TO_PIXEL_GREEN[led], 0) unless b != 0 && !(g != 0)
      set_pixel(LED_TO_PIXEL_BLUE[led], 0) unless r != 0 && !(b != 0)
    end

    def increment_pixels_for_led(led, r, g, b)
      red   = [PIXEL_BLUE, PIXEL_RED, PIXEL_OFF, PIXEL_GREEN]
      green = [PIXEL_GREEN, PIXEL_BLUE, PIXEL_RED, PIXEL_OFF]
      blue  = [PIXEL_RED, PIXEL_OFF, PIXEL_GREEN, PIXEL_BLUE]
      increment_pixel(LED_TO_PIXEL_RED[led], r * red[LED_TO_PIXEL_RED[led] % 4]) unless r == 0
      increment_pixel(LED_TO_PIXEL_GREEN[led], g * green[LED_TO_PIXEL_GREEN[led] % 4]) unless g == 0
      increment_pixel(LED_TO_PIXEL_BLUE[led], b * blue[LED_TO_PIXEL_BLUE[led] % 4]) unless b == 0
    end

    def set_led!(led, color = {})
      set_led(led, color)
      save
    end

    def animate_turn_on!(start_led = 0, stop_led = (NUM_LEDS - 1), timeout = 0.25, &blk)
      blk = Proc.new { LED_GREEN } unless block_given?
      (start_led..stop_led).each do |led|
        sleep timeout
        set_led!(led, blk.call(led))
      end
    end

    def animate_turn_off!(start_led = (NUM_LEDS - 1), stop_led = 0, timeout = 0.25)
      start_led.downto(stop_led + 1) do |led|
        sleep timeout
        set_led!(led)
      end
    end

    def speedometer_color(led)
      color = LED_GREEN
      color = LED_YELLOW if led < 12
      color = LED_RED if led < 8
      color
    end

    def set_speedometer!(stop_led)
      (0..stop_led).each do |led|
        set_led(led, speedometer_color(led))
      end
      save
    end

    def animate_set_speedometer!(led)
      animate_turn_off!(23, led)
      animate_turn_on!(0, led) { |led| speedometer_color(led) }      
    end

    def set_error!(&blk)
      blk = Proc.new { LED_BLUE } unless block_given?
      each_led { blk.call }
    end

    def set_smile!(color = LED_BLUE)
      set_led_range(6, 18) { color }
      set_led(2, color)
      set_led(21, color)
      save
    end

    def flash_smile!(times = 12, timeout = 0.25, &blk)
      blk = Proc.new { LED_BLUE } unless block_given?
      times.times do |i|
        set_smile!(blk.call(i))
        sleep timeout
        clear!
        sleep timeout
      end
    end

    def animate_smile!(color = LED_BLUE, timeout = 0.25)
      clear!
      center = NUM_LEDS / 2
      (0..5).each do |led|
        set_led(center + led, color)
        set_led(center - led - 1, color)
        save
        sleep timeout
      end

      set_led(21, color)
      set_led(2, color)
      save
    end

    def party!(timeout = 0.25)
      colors = [rgb(10,0,0), rgb(0,10,0), rgb(0,0,10)]
      12.times do
        sleep timeout
        each_led do |led|
          colors.sample
        end
        save
      end
    end

    def pinwheel!(times = 12, &blk)
      blk = Proc.new { PIXEL_RED } unless block_given?
      count = 0
      times.times do |i|
        sleep 0.25
        each_pixel { |led| led % 4 == count % 4 ? blk.call(i) : PIXEL_OFF}
        save
        count += 1
      end
      clear!
    end

    private
  
    def extract
      begin
        Apiotics::Extract.send(self)
      rescue => e
        puts e
      end
    end
    
    def channel_push
      if Apiotics.configuration.push == true
        interfaces = Hash.new
        puts self.previous_changes
        self.previous_changes.each do |k,v|
          if Apiotics::Extract.is_target(self, k)
            interfaces[k] = v[1].to_s
          end
        end
        interfaces.each do |k,v|
          ActionCable.server.broadcast "#{self.class.parent.to_s.underscore.downcase.gsub(" ", "_")}_channel",
            apiotics_instance: self.indicator.apiotics_instance,
            worker_name: self.class.parent.to_s.underscore.downcase.gsub(" ", "_"),
            model_name: self.class.name.demodulize.to_s.underscore.downcase.gsub(" ", "_"),
            interface: k,
            value: v
        end
      end
    end
  
  end
end