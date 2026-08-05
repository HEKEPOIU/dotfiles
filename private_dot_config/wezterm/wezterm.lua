local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

config.color_scheme = 'Galaxy'
config.font = wezterm.font_with_fallback { '0xProto Nerd Font Mono' }
config.font_size = 12
config.window_background_opacity = 1.0

config.default_prog = { 'nu' }

config.initial_cols = 120
config.initial_rows = 28

config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 20
config.window_decorations = 'RESIZE'
config.window_padding = { left = 4, right = 4, top = 4, bottom = 0 }

wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():toggle_fullscreen()
end)

config.disable_default_key_bindings = true

config.keys = {
  -- clipboard
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
  { key = 'Insert', mods = 'CTRL', action = act.CopyTo 'PrimarySelection' },
  { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'PrimarySelection' },

  -- window / tab lifecycle
  { key = 'n', mods = 'CTRL|SHIFT', action = act.SpawnWindow },
  { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = true } },
  { key = 'q', mods = 'CTRL|SHIFT', action = act.QuitApplication },

  -- tab navigation
  { key = 'LeftArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },
  { key = 'l', mods = 'ALT', action = act.ActivateTabRelative(1) },
  { key = 'h', mods = 'ALT', action = act.ActivateTabRelative(-1) },
  { key = 'i', mods = 'ALT', action = act.MoveTabRelative(-1) },
  { key = 'o', mods = 'ALT', action = act.MoveTabRelative(1) },
  { key = 'phys:1', mods = 'CTRL|SHIFT', action = act.ActivateTab(0) },
  -- { key = 'phys:2', mods = 'CTRL|SHIFT', action = act.ActivateTab(1) },
  { key = '@', mods = 'CTRL|SHIFT', action = act.ActivateTab(1) },
  -- { key = '@', mods = 'CTRL', action = act.ActivateTab(1) },
  { key = 'phys:3', mods = 'CTRL|SHIFT', action = act.ActivateTab(2) },
  { key = 'phys:4', mods = 'CTRL|SHIFT', action = act.ActivateTab(3) },
  { key = 'phys:5', mods = 'CTRL|SHIFT', action = act.ActivateTab(4) },
  { key = 'phys:6', mods = 'CTRL|SHIFT', action = act.ActivateTab(5) },
  { key = 'phys:7', mods = 'CTRL|SHIFT', action = act.ActivateTab(6) },
  { key = 'phys:8', mods = 'CTRL|SHIFT', action = act.ActivateTab(7) },
  { key = 'phys:9', mods = 'CTRL|SHIFT', action = act.ActivateTab(-1) },

  -- splits
  { key = 'o', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'e', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'Enter', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'l', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'h', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'LeftArrow', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'CTRL|ALT', action = act.ActivatePaneDirection 'Down' },
  { key = 'LeftArrow', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Left', 3 } },
  { key = 'RightArrow', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Right', 3 } },
  { key = 'UpArrow', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Up', 3 } },
  { key = 'DownArrow', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Down', 3 } },
  { key = 'z', mods = 'CTRL|SHIFT', action = act.TogglePaneZoomState },

  -- font size
  { key = 'phys:Equal', mods = 'CTRL|SHIFT', action = act.IncreaseFontSize },
  { key = 'phys:Minus', mods = 'CTRL|SHIFT', action = act.DecreaseFontSize },
  { key = 'phys:0', mods = 'CTRL|SHIFT', action = act.ResetFontSize },

  -- scrolling
  { key = 'PageUp', mods = 'CTRL|SHIFT', action = act.ScrollByPage(-1) },
  { key = 'PageDown', mods = 'CTRL|SHIFT', action = act.ScrollByPage(1) },
  { key = 'Home', mods = 'CTRL|SHIFT', action = act.ScrollToTop },
  { key = 'End', mods = 'CTRL|SHIFT', action = act.ScrollToBottom },
  { key = 'UpArrow', mods = 'CTRL|SHIFT', action = act.ScrollByLine(-1) },
  { key = 'DownArrow', mods = 'CTRL|SHIFT', action = act.ScrollByLine(1) },

  -- misc
  { key = 'a', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },
  { key = 'f', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },
  { key = 'k', mods = 'CTRL|SHIFT', action = act.Multiple { act.ClearScrollback 'ScrollbackAndViewport', act.SendKey { key = 'L', mods = 'CTRL' } } },
  { key = 'j', mods = 'CTRL|SHIFT', action = act.QuickSelect },
  { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
  { key = ',', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },
  { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },
  { key = 'd', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },
}

return config
