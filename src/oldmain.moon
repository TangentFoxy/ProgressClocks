-- todo 4000x4000 image for printing, or nearest power of 2 if required
-- settings show in main window with preview, but renderning is just directly to screenshot

modes = love.window.getFullscreenModes(1)
table.sort modes, (a, b) -> a.width * a.height > b.width * b.height -- largest resolution available first
for mode in *modes
  print mode.width .. " " .. mode.height

width = modes[1].width / 2 -- divided by 2 because macOS is being shitty
height = modes[1].height / 2
love.window.setMode width, height--, { fullscreen: true, vsync: true } -- vsync as a cheap frame limit because I'm making this quickly

love.graphics.setBackgroundColor 1, 1, 1, 1
love.graphics.setColor 0, 0, 0, 1

love.draw = ->
  -- do drawing constantly, yes this is unoptimized as shit
  love.graphics.circle "line", width / 2, height / 2, math.min(width, height) / 2

love.keypressed = (key) ->
  if key == "escape"
    love.event.quit!



---

-- if key == 's'
--    fn = (image_data) ->
--      file_name = "#{love.filesystem.getSourceBaseDirectory!}/#{os.time!}.png"
--      file_data = image_data\encode 'png'
--      str = file_data\getString!
--      file = io.open file_name, "wb"
--      file\write str
--      file\flush!
--      file\close!
--    love.graphics.captureScreenshot fn
