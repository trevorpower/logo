require "prawn"
require "./solarized"

full_width = 210

def setup_font (width, text)
  font "./Inconsolata.ttf", :style => 'bold'
  font_size width / (text.size / 2 )
end

def calculate_unit_size (text)
  width_of(text) / text.size 
end


Prawn::Document.generate("hello.pdf", :page_size => [full_width + 20, full_width + 20], :margin => 10) do
  setup_font(full_width, "trevor")
  unit = calculate_unit_size("trevor")
  base_offset = font.descender + font.line_gap
  
  fill_color Solarized::Base2 
  fill_rectangle [0, 0], unit * 6, unit * -6
  
  fill_color Solarized::Base2
  fill_rectangle [0, unit * 3], unit * 6, unit * 2
  
  line_width 1
  stroke_color Solarized::Base3
  stroke do
    #(0..6).each { |i| vertical_line 0, unit * 6, :at => unit * i }
    #(0..6).each { |i| horizontal_line 0, unit * 6, :at => unit * i }
  end

  fill_color Solarized::Green
  fill_gradient [0, 0], unit, -unit, Solarized::Orange, Solarized::Green
  (0...6).each do |x|
    (1..6).each do |y|
      translate unit * x, unit * y do
      	rotate 90 do
        fill_gradient [unit * x, unit * y], unit, unit, Solarized::Orange, Solarized::Green
        fill_rectangle [1, 1], unit - 2, unit - 2
	end
      end
    end
  end

  fill_color Solarized::Orange
  draw_text "trevor", :at => [0, unit * 3 + base_offset]
  fill_color Solarized::Base1
  draw_text "power", :at => [0, unit + base_offset ]
  
  #fill_color Solarized::Base00
  fill_gradient [unit * 5, unit], unit, unit * -2, Solarized::Base00, Solarized::Base1
  fill_rectangle [unit * 5, unit], unit, unit * -2
end
