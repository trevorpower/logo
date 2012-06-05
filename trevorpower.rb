require 'pango'
require 'cairo'
require './solarized'

class Drawing

  def initialize(width, height)
    @width = width
    @height = height
    create_context
  end

  def method_missing(method, *args, &block)
    if @context.respond_to?(method) then
      @context.send method, *args, &block
    else
      super
    end
  end

  def create_context()
    surface = Cairo::ImageSurface.new(@width,@height)
    @context = Cairo::Context.new(surface)
  end
  
  def self.this_filename_as_png
    File.basename(__FILE__,".rb") + ".png"
  end

  def self.png(width, height, &block)
    drawer = new(width,  height)
    drawer.instance_eval(&block)
    drawer.target.write_to_png(this_filename_as_png)
  end 

  def all
    rectangle 0, 0, @width, @height
  end

  def at(x, y)
    save
    move_to x, y
    yield
    restore
  end

  def rgb(color)
    if (color.respond_to? :to_rgb)
      color.to_rgb
    else
      color
    end
  end

  def fill(color)
    yield
    set_source_rgba rgb(color)
    @context.fill
  end

  def text(value)
    layout = create_pango_layout
    font_desc = Pango::FontDescription.new('Inconsolata 136')
    layout.context.font_description = font_desc 
    layout.text = value
    show_pango_layout layout 
  end
  
  def color(value)
    set_source_rgba rgb(value)
  end

  def scale(h, v)
    save
    @context.scale(h, v)
    yield
    restore
  end
end

def tile_color(x, y)
  case [x, y]
    when [7, 2] then Solarized::Blue
    else Solarized::Base2
  end
end

def color_for_tile(x, y)
  case [
      "        ",
      "       b",
    ][y][x]
    when '0' then Solarized::Base2
    when 'b' then Solarized::Blue
  end
end

def text_for_tile(x, y)
  [
    "trevor  ",
    "  power ",
  ][y][x]
end

def draw_tiles(h, v)
  tile_width = @width / h
  tile_height = @height / v
  (0...h).each do |x|
    (0...v).each do |y|
      save
      translate tile_width * x, tile_height * y
      @context.scale @width / (h * 100.0), @width / (h * 100.0)
      yield x, y
      restore
    end
  end 
end

Drawing.png(320, 160) do
  #fill(Solarized::Base3) { all }
  draw_tiles(8, 2) do |x, y|
    distance = Math.sqrt((3 - x)**2 + (3 - y)**2)
    puts "#{x}, #{y} - #{distance}"
    tile_color = color_for_tile(x,y)
    if (tile_color) then
      fill(tile_color) do
        rectangle 2, 2, 98, 198
      end
    end
    color Solarized::Orange
    at(5,0) { text text_for_tile(x,y) }
  end
end
