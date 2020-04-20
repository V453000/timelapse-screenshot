data:extend{
  {
    type = "int-setting",
    name = "timelapse-screenshot-interval-ticks",
    setting_type = "startup",
    default_value = 25000,--1 factorio day--60*60*30,
    min_value = 1,
    order = "a"
  },
  {
    type = "double-setting",
    name = "timelapse-screenshot-zoom",
    setting_type = "startup",
    default_value = 0.25,
    order = "b"
  },
  {
    type = "int-setting",
    name = "timelapse-screenshot-max-resolution-x",
    setting_type = "startup",
    default_value = 4096,
    max_value = 16384,
    order = "c-a"
  },
  {
    type = "int-setting",
    name = "timelapse-screenshot-max-resolution-y",
    setting_type = "startup",
    default_value = 4096,
    max_value = 16384,
    order = "c-b"
  },
  {
    type = "int-setting",
    name = "timelapse-screenshot-max-tiles-x",
    setting_type = "startup",
    default_value = 0,
    order = "d-a"
  },
  {
    type = "int-setting",
    name = "timelapse-screenshot-max-tiles-y",
    setting_type = "startup",
    default_value = 0,
    order = "d-b"
  },
}