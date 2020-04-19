local timelapse_screenshot_interval_ticks = settings.startup['timelapse-screenshot-interval-ticks'].value

function time_format(time_int)
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

function move_entities(name_list, move_x, move_y, search_area)
  local logo_entities = game.surfaces['nauvis'].find_entities_filtered({area = search_area, name = name_list})
  for _, e in pairs(logo_entities) do
    e.teleport({e.position.x+move_x, e.position.y+move_y})
  end  
end

function timelapse_screenshot(tick)
  local seed = game.surfaces['nauvis'].map_gen_settings.seed
  game.print(seed)
  local arg_filename_base = 'seed'
  local arg_position = {20, -46}
  local tile_px = 32
  local chunk_tiles = 32
  local arg_zoom = 1
  local resolution_multiplier = 1/2

  if tick > 1 *60*60*60 then
    arg_zoom = 1/2
  end
  if tick > 9 *60*60*60 then
    arg_zoom = 1/4
  end
  if tick > 30 *60*60*60 then
    arg_zoom = 1/8
  end

  local arg_resolution = {16*resolution_multiplier*tile_px*chunk_tiles, 9*resolution_multiplier*tile_px*chunk_tiles}

  local timelapse_subfolder = 'test/'
  local arg_path = 'built-in-timelapse/' .. timelapse_subfolder .. arg_filename_base .. '_' .. time_format(tick) .. '.png'
  game.take_screenshot{path = arg_path, position = arg_position, resolution = arg_resolution, zoom = arg_zoom, render_tiles = true};
end


-- prepare
script.on_init(
  function()
    --move logo entities
    local logo_name_list =
    {
      'factorio-logo-0',
      'factorio-logo-1',
      'factorio-logo-2',
      'factorio-logo-3',
      'factorio-logo-4',
      'factorio-logo-5',
      'factorio-logo-6',
    }
    move_entities( logo_name_list, 0, 5, {left_top = {-15.5-1, -41.5-1}, right_bottom = {56.5+1, -41.5+1}} )
    -- change player colour
    for p, player in pairs(game.players) do
      player.color = { r = 0.869, g = 0.5, b = 0.130, a = 0.5 };
    end

    for s, surface in pairs(game.surfaces) do
      -- set day
      surface.daytime = 1;
      -- chart a minimum area
      surface.request_to_generate_chunks({0,0}, 9);
      surface.force_generate_chunk_requests();
    end

    for f, force in pairs(game.forces) do
      force.chart_all();
    end
  end
)

script.on_event(defines.events.on_player_joined_game,
  function()  
    -- change player colour
    for p, player in pairs(game.players) do
      player.color = { r = 0.869, g = 0.5, b = 0.130, a = 0.5 };
    end
  end
)

-- take screenshot
script.on_event(defines.events.on_tick,
  function()
    if timelapse_screenshot_interval_ticks > 0 then
      if game.tick % (timelapse_screenshot_interval_ticks) == 0 then
        timelapse_screenshot(game.tick)
      end
    end
  end
)