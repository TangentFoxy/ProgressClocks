w, h = love.graphics.getDimensions!

support = love.graphics.getSupported!
for k,v in pairs support
  print k,v
-- well I was lied to...
-- assert support.canvas, "Your graphics card does not support canvases. Bug me to make a version that works without them please."
canvas = love.graphics.newCanvas 4000, 4000

love.graphics.setNewFont 24
love.graphics.setColor 0, 0, 0, 1
love.graphics.setBackgroundColor 1, 1, 1, 1
--love.graphics.setLineWidth 125

segments = 3

draw_clock = (opts) ->
  love.graphics.origin!
  love.graphics.translate opts.width / 2, opts.height / 2
  love.graphics.setLineWidth opts.line_width
  love.graphics.circle "line", 0, 0, opts.radius
  radians_per_segment = math.pi * 2 / segments
  for i = 1, segments
    angle = (i - 1) * radians_per_segment - math.pi / 2
    love.graphics.line 0, 0, math.cos(angle) * opts.radius, math.sin(angle) * opts.radius

love.draw = ->
  love.graphics.print "Segments #{segments} (Press +/- to change)\nThis image is just a preview. Press 'S' to save the result.", 1, 1

  draw_clock { width: w, height: h, line_width: 2, radius: math.min(w, h) / 2 * 0.8 }
  -- all of this will be lazily duplicated ... no fuck that I'm gonna do it right!
  -- radius = math.min(w, h) / 2 * 0.8
  -- love.graphics.circle "line", w / 2, h / 2, radius
  -- radians_per_segment = math.pi * 2 / segments
  -- for i = 1, segments
  --   angle = (i - 1) * radians_per_segment - math.pi / 2
  --   love.graphics.line w / 2, h / 2, w / 2 + math.cos(angle) * radius, h / 2 + math.sin(angle) * radius

love.keypressed = (key) ->
  switch key
    when "escape"
      love.event.quit!
    when "=" -- plus but without having to hold shift
      segments += 1
      if segments > 12
        segments = 12
    when "-"
      segments -= 1
      if segments < 3
        segments = 3
    when "s"
      love.graphics.setCanvas canvas
      love.graphics.clear 1, 1, 1, 1
      draw_clock { width: 4000, height: 4000, line_width: 100, radius: 1900 }
      love.graphics.setCanvas!
      image_data = canvas\newImageData!
      file_data = image_data\encode "png"
      data_string = file_data\getString!
      file_name = "#{love.filesystem.getSourceBaseDirectory!}/#{segments}-segments-#{os.time!}.png"
      -- file_name = "#{love.filesystem.getSourceBaseDirectory!}/#{segments}-segments.png" -- was used for batch processing
      file = io.open file_name, "wb"
      file\write data_string
      file\flush!
      file\close!

-- batch processing
-- for i = 3, 12
--   segments = i
--   love.keypressed "s"
--   love.event.quit!
