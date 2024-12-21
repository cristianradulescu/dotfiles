-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMonoNL Nerd Font", { weight = "Medium" })
config.font_size = 14
config.line_height = 1.2
config.bold_brightens_ansi_colors = "BrightAndBold"

config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
    top = 0,
    bottom = 0,
    left = 0,
    right = 0
}

return config
