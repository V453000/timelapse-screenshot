local setting_timelapse_screenshot_interval_ticks = settings.startup['timelapse-screenshot-interval-ticks'].value
local setting_max_resolution_x = settings.startup['timelapse-screenshot-max-resolution-x'].value
local setting_max_resolution_y = settings.startup['timelapse-screenshot-max-resolution-y'].value

local function time_format(time_int)
  local hours_int = math.floor(time_int/60/60/60)
  local remaining_ticks_minutes = time_int - hours_int*60*60*60
  local minutes_int = math.floor(remaining_ticks_minutes/60/60)
  local remaining_ticks_seconds = remaining_ticks_minutes - minutes_int*60*60
  local seconds_int = math.floor(remaining_ticks_seconds/60)
  local remaining_ticks = remaining_ticks_seconds - seconds_int*60
  local ticks_int = math.floor(remaining_ticks)

  local hours_str = 'x'
  if hours_int < 10 then
    hours_str = '00' .. tostring(hours_int)
  elseif hours_int < 100 then
    hours_str = '0' .. tostring(hours_int)
  else
    hours_str = tostring(hours_int)
  end   

  local minutes_str = 'x'
  if minutes_int < 10 then
    minutes_str = '0' .. tostring(minutes_int)
  else
    minutes_str = tostring(minutes_int)
  end   

  local seconds_str = 'x'
  if seconds_int < 10 then
    seconds_str = '0' .. tostring(seconds_int)
  else
    seconds_str = tostring(seconds_int)
  end

  local ticks_str = 'x'
  if ticks_int < 10 then
    ticks_str = '0' .. tostring(ticks_int)
  else
    ticks_str = tostring(ticks_int)
  end
    
  local time_string = hours_str .. 'h_' .. minutes_str .. 'm_' .. seconds_str .. 's_' .. ticks_str ..'t'
  return time_string
end

local function get_surface_size_from_center(surface)
  local range_x = 0
  local range_y = 0

  for chunk in surface.get_chunks() do
    local chunk_x = math.abs(chunk.x)
    local chunk_y = math.abs(chunk.y)
    
    if chunk_x > range_x then
      range_x = math.abs(chunk.x)
    end
    if chunk_y > range_y then
      range_y = math.abs(chunk.y)
    end
  end

  local range = {}
  range.x = range_x
  range.y = range_y
  return range
end

local function timelapse_screenshot(tick)
  local surf = game.surfaces['nauvis']
  local seed = surf.map_gen_settings.seed
  local arg_filename_base = seed
  local arg_position = {0, 0}
  local arg_zoom = settings.startup['timelapse-screenshot-zoom'].value
  
  
  local tile_px = 32
  local chunk_tiles = 32
  local surface_size = get_surface_size_from_center(surf)
  local resolution_multiplier = 1 * arg_zoom

  local resolution_candidate_x = resolution_multiplier * tile_px * chunk_tiles * surface_size.x
  local resolution_candidate_y = resolution_multiplier * tile_px * chunk_tiles * surface_size.y

  if resolution_candidate_x > setting_max_resolution_x then
    local resolution_divider = math.ceil(resolution_candidate_x / setting_max_resolution_x)
    resolution_multiplier = resolution_multiplier / resolution_divider
  end
  if resolution_candidate_y > setting_max_resolution_y then
    local resolution_divider = math.ceil(resolution_candidate_x / setting_max_resolution_x)
    resolution_multiplier = resolution_multiplier / resolution_divider
  end

  local resolution_x = resolution_multiplier * tile_px * chunk_tiles * surface_size.x
  local resolution_y = resolution_multiplier * tile_px * chunk_tiles * surface_size.y

  local arg_resolution = { resolution_x, resolution_y }

  local timelapse_subfolder = seed .. '/'
  local arg_path = 'timelapse-screenshot/' .. timelapse_subfolder .. arg_filename_base .. '_' .. time_format(tick) .. '.png'
  game.take_screenshot{path = arg_path, position = arg_position, resolution = arg_resolution, zoom = arg_zoom, render_tiles = true};

  local data = {}
  data.resolution_multiplier = resolution_multiplier
  data.setting_max_resolution_x = setting_max_resolution_x
  data.setting_max_resolution_y = setting_max_resolution_y
  data.resolution_x = resolution_x
  data.resolution_y = resolution_y
  return data
end


-- take screenshot
script.on_event(defines.events.on_tick,
  function()
    if setting_timelapse_screenshot_interval_ticks > 0 then
      if game.tick % (setting_timelapse_screenshot_interval_ticks) == 0 then
        local data = timelapse_screenshot(game.tick)
        --log(serpent.block(data))
      end
    end
  end
)