class Solarized
  Base03 = '002b36'
  Base02 = '073642'
  Base01 = '586e75'
  Base00 = '657b83'
  Base0 = '839496'
  Base1 = '93a1a1'
  Base2 = 'eee8d5'
  Base3 = 'fdf6e3'
  Yellow = 'b58900'
  Orange = 'cb4b16'
  Red = 'dc322f'
  Magenta = 'd33682'
  Violet = '6c71c4'
  Blue = '268bd2'
  Cyan = '2aa198'
  Green = '859900'
end

class String
  def to_rgb
    scan(/../).map {|color| color.to_i(16).to_f / 256}
  end
end
