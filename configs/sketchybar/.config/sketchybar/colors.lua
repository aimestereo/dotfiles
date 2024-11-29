-- https://github.com/khaneliman
local khaneliman_colors = {
  base = 0xff24273a,
  mantle = 0xff1e2030,
  crust = 0xff181926,
  text = 0xffcad3f5,
  subtext0 = 0xffb8c0e0,
  subtext1 = 0xffa5adcb,
  surface0 = 0xff363a4f,
  surface1 = 0xff494d64,
  surface2 = 0xff5b6078,
  overlay0 = 0xff6e738d,
  overlay1 = 0xff8087a2,
  overlay2 = 0xff939ab7,
  blue = 0xff8aadf4,
  lavender = 0xffb7bdf8,
  sapphire = 0xff7dc4e4,
  sky = 0xff91d7e3,
  teal = 0xff8bd5ca,
  green = 0xffa6da95,
  yellow = 0xffeed49f,
  peach = 0xfff5a97f,
  maroon = 0xffee99a0,
  red = 0xffed8796,
  mauve = 0xffc6a0f6,
  pink = 0xfff5bde6,
  flamingo = 0xfff0c6c6,
  rosewater = 0xfff4dbd6,
}

-- https://github.com/FelixKratz
local FelixKratz_colors = {
  black = 0xff181819,
  white = 0xffe2e2e3,
  red = 0xfffc5d7c,
  green = 0xff9ed072,
  blue = 0xff76cce0,
  yellow = 0xffe7c664,
  orange = 0xfff39660,
  magenta = 0xffb39df3,
  grey = 0xff7f8490,
  transparent = 0x00000000,

  bar = {
    bg = 0xf02c2e34,
    border = 0xff2c2e34,
  },
  popup = {
    bg = 0xc02c2e34,
    border = 0xff7f8490,
  },
  bg1 = 0xff363944,
  bg2 = 0xff414550,
}

-- I don't know much about colors, so just jumble everything for now
local colors = khaneliman_colors
local secondPalette = FelixKratz_colors

for k, v in pairs(secondPalette) do
  colors[k] = v
end

colors.with_alpha = function(color, alpha)
  if alpha > 1.0 or alpha < 0.0 then
    return color
  end

  return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

colors.inactive = colors.grey

colors.random_cat_color = {
  colors.blue,
  colors.lavender,
  colors.sapphire,
  colors.sky,
  colors.teal,
  colors.green,
  colors.yellow,
  colors.peach,
  colors.maroon,
  colors.red,
  colors.mauve,
  colors.pink,
  colors.flamingo,
  colors.rosewater,
}

colors.getRandomCatColor = function()
  return colors.random_cat_color[math.random(1, #colors.random_cat_color)]
end

return colors
