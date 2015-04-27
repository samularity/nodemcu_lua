--
-- * Converts an HSV color value to RGB. Conversion formula
-- * adapted from http://en.wikipedia.org/wiki/HSV_color_space.
-- * Assumes h, s, and v are contained in the set [0, 1] and
-- * returns r, g, and b in the set [0, 255].
-- *
-- * @param   Number  h       The hue
-- * @param   Number  s       The saturation
-- * @param   Number  v       The value
-- * @return  Array           The RGB representation
--
function hsvToRgb(h, s, v)
  local r, g, b

  local i = floor(h * 6);
  
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end
    print (r*255)
    print(g*255)
    print(b*255)
  return r * 255, g * 255, b * 255
end
function floor (int)
return int-(int%1)
end
