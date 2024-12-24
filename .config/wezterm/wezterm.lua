local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"

config.command_palette_font_size = 14
config.command_palette_bg_color = "1e1e2e"
config.command_palette_fg_color = "bac2de"

config.font = wezterm.font("JetBrainsMonoNL Nerd Font", { weight = "Medium" })
config.font_size = 14
config.line_height = 1.2
config.bold_brightens_ansi_colors = "BrightAndBold"

config.window_padding = {
    top = 0,
    bottom = 0,
    left = 0,
    right = 0
}

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_max_width = 30

config.webgpu_power_preference = "HighPerformance"

return config
