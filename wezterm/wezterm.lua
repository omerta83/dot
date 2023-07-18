local wezterm = require("wezterm")
local colors, _ = wezterm.color.load_scheme("/Users/omerta/.config/wezterm/colors/tokyonight_night.toml")

local function isViProcess(pane)
  return pane:get_foreground_process_name():find("n?vim") ~= nil
end

local function conditionalActivatePane(window, pane, pane_direction, vim_direction)
  if isViProcess(pane) then
    window:perform_action(wezterm.action.SendKey({ key = vim_direction, mods = "CTRL" }), pane)
  else
    window:perform_action(wezterm.action.ActivatePaneDirection(pane_direction), pane)
  end
end

wezterm.on("ActivatePaneDirection-right", function(window, pane)
  conditionalActivatePane(window, pane, "Right", "l")
end)
wezterm.on("ActivatePaneDirection-left", function(window, pane)
  conditionalActivatePane(window, pane, "Left", "h")
end)
wezterm.on("ActivatePaneDirection-up", function(window, pane)
  conditionalActivatePane(window, pane, "Up", "k")
end)
wezterm.on("ActivatePaneDirection-down", function(window, pane)
  conditionalActivatePane(window, pane, "Down", "j")
end)

local function getProcess(tab)
  local process_icons = {
    ["colima"] = {
      { Foreground = { Color = colors.ansi[5] } },
      { Text = wezterm.nerdfonts.dev_docker },
    },
    ["docker"] = {
      { Foreground = { Color = colors.ansi[5] } },
      { Text = wezterm.nerdfonts.dev_docker },
    },
    ["docker-compose"] = {
      { Foreground = { Color = colors.ansi[5] } },
      { Text = wezterm.nerdfonts.dev_docker },
    },
    ["nvim"] = {
      { Foreground = { Color = colors.ansi[3] } },
      { Text = wezterm.nerdfonts.dev_vim },
    },
    ["vim"] = {
      { Foreground = { Color = colors.ansi[3] } },
      { Text = wezterm.nerdfonts.dev_vim },
    },
    ["node"] = {
      { Foreground = { Color = colors.ansi[3] } },
      { Text = wezterm.nerdfonts.mdi_hexagon_outline },
    },
    ["zsh"] = {
      { Foreground = { Color = colors.ansi[2] } },
      { Text = wezterm.nerdfonts.oct_terminal },
    },
    ["bash"] = {
      { Foreground = { Color = colors.ansi[2] } },
      { Text = wezterm.nerdfonts.cod_terminal_bash },
    },
    ["htop"] = {
      { Foreground = { Color = colors.ansi[4] } },
      { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
    },
    ["btop"] = {
      { Foreground = { Color = colors.ansi[4] } },
      { Text = wezterm.nerdfonts.mdi_chart_donut_variant },
    },
    ["cargo"] = {
      { Foreground = { Color = colors.ansi[6] } },
      { Text = wezterm.nerdfonts.dev_rust },
    },
    ["go"] = {
      { Foreground = { Color = colors.ansi[7] } },
      { Text = wezterm.nerdfonts.mdi_language_go },
    },
    ["lazydocker"] = {
      { Foreground = { Color = colors.ansi[5] } },
      { Text = wezterm.nerdfonts.dev_docker },
    },
    ["git"] = {
      { Foreground = { Color = colors.ansi[6] } },
      { Text = wezterm.nerdfonts.dev_git },
    },
    ["lazygit"] = {
      { Foreground = { Color = colors.ansi[6] } },
      { Text = wezterm.nerdfonts.dev_git },
    },
    ["lua"] = {
      { Foreground = { Color = colors.ansi[5] } },
      { Text = wezterm.nerdfonts.seti_lua },
    },
    ["ruby"] = {
      { Foreground = { Color = colors.ansi[2] } },
      { Text = wezterm.nerdfonts.oct_ruby },
    },
    ["python"] = {
      { Foreground = { Color = colors.ansi[4] } },
      { Text = wezterm.nerdfonts.dev_python },
    },
    ["wget"] = {
      { Foreground = { Color = colors.ansi[4] } },
      { Text = wezterm.nerdfonts.mdi_arrow_down_bold_box_outline },
    },
    ["curl"] = {
      { Foreground = { Color = colors.ansi[4] } },
      { Text = wezterm.nerdfonts.mdi_flattr },
    },
  }

  local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

  return wezterm.format(
    process_icons[process_name]
    or { { Foreground = { Color = colors.ansi[4] } }, { Text = string.format("[%s]", process_name) } }
  )
end

local function getCWD(tab)
  local current_dir = tab.active_pane.current_working_dir
  local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

  -- return current_dir == HOME_DIR and "  ~" or string.format("  %s", string.gsub(current_dir, "(.*[/\\])(.*)", "%2"))
  return current_dir == HOME_DIR and "~" or string.format("%s", string.gsub(current_dir, "(.*[/\\])(.*)", "%2"))
end

wezterm.on("format-tab-title", function(tab)
  local new_title = getCWD(tab)
  local title = tab.tab_title
  if title ~= nil and #title > 0 then
    new_title = title
  end
  return wezterm.format({
    { Attribute = { Intensity = "Half" } },
    { Text = string.format(" %s ", tab.tab_index + 1) },
    "ResetAttributes",
    { Text = getProcess(tab) },
    { Text = " " },
    { Text = new_title },
    -- { Foreground = { Color = colors.ansi[1] } },
    { Text = " " },
  })
end)

return {
  font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font",
  }),
  font_size = 16,
  freetype_load_flags = 'NO_HINTING',
  -- freetype_interpreter_version = 40,
  -- max_fps = 120,
  enable_wayland = false,
  term = 'wezterm',
  pane_focus_follows_mouse = false,
  warn_about_missing_glyphs = false,
  show_update_window = false,
  check_for_updates = false,
  cell_width = 1.1,
  line_height = 1.0,
  window_decorations = "RESIZE",
  window_close_confirmation = "NeverPrompt",
  audible_bell = "Disabled",
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 0,
  },
  initial_cols = 1100,
  initial_rows = 250,
  -- native_macos_fullscreen_mode = true,
  inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 0.85,
  },
  enable_scroll_bar = false,
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  tab_max_width = 50,
  hide_tab_bar_if_only_one_tab = true,
  window_background_opacity = 1.0,
  disable_default_key_bindings = false,
  front_end = "WebGpu",
  colors = colors,
  keys = {
    { key = [[\]],          mods = "SUPER|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
    { key = [[-]],          mods = "SUPER|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
    -- { mods = "CTRL",        key = [[Space]],      action = wezterm.action.QuickSelect },
    -- Rename tab
    {
      key = "t",
      mods = "SUPER|SHIFT", action = wezterm.action.PromptInputLine {
      description = 'Enter new name for tab',
        action = wezterm.action_callback(function(window, pane, line)
          -- line will be `nil` if they hit escape without entering anything
          -- An empty string if they just hit enter
          -- Or the actual line of text they wrote
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }
    },
    { key = "t",            mods = "SUPER",       action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
    { key = "w",            mods = "SUPER",       action = wezterm.action({ CloseCurrentTab = { confirm = false } }) },
    { key = "q",            mods = "SUPER|SHIFT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
    { key = "z",            mods = "SUPER|SHIFT", action = wezterm.action.TogglePaneZoomState },
    { key = "h",            mods = "SUPER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
    { key = "j",            mods = "SUPER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
    { key = "k",            mods = "SUPER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
    { key = "l",            mods = "SUPER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
    { key = "f",            mods = "SUPER|SHIFT", action = wezterm.action.ToggleFullScreen },

    -- compatible with vim's panel movement
    { key = "h",            mods = "CTRL",        action = wezterm.action.EmitEvent("ActivatePaneDirection-left") },
    { key = "j",            mods = "CTRL",        action = wezterm.action.EmitEvent("ActivatePaneDirection-down") },
    { key = "k",            mods = "CTRL",        action = wezterm.action.EmitEvent("ActivatePaneDirection-up") },
    { key = "l",            mods = "CTRL",        action = wezterm.action.EmitEvent("ActivatePaneDirection-right") },
    { key = "[",            mods = "SUPER",       action = wezterm.action({ ActivateTabRelative = -1 }) },
    { key = "]",            mods = "SUPER",       action = wezterm.action({ ActivateTabRelative = 1 }) },
    { key = "<",            mods = "SUPER|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
    { key = ">",            mods = "SUPER|SHIFT", action = wezterm.action.MoveTabRelative(1) },
    { key = "v",            mods = "SUPER|SHIFT", action = wezterm.action.ActivateCopyMode },
    { key = "1",            mods = "SUPER",       action = wezterm.action({ ActivateTab = 0 }) },
    { key = "2",            mods = "SUPER",       action = wezterm.action({ ActivateTab = 1 }) },
    { key = "3",            mods = "SUPER",       action = wezterm.action({ ActivateTab = 2 }) },
    { key = "4",            mods = "SUPER",       action = wezterm.action({ ActivateTab = 3 }) },
    { key = "5",            mods = "SUPER",       action = wezterm.action({ ActivateTab = 4 }) },
    { key = "6",            mods = "SUPER",       action = wezterm.action({ ActivateTab = 5 }) },
    { key = "7",            mods = "SUPER",       action = wezterm.action({ ActivateTab = 6 }) },
    { key = "8",            mods = "SUPER",       action = wezterm.action({ ActivateTab = 7 }) },
    { key = "9",            mods = "SUPER",       action = wezterm.action({ ActivateTab = 8 }) },
    { key = "c",            mods = "SUPER",       action = wezterm.action({ CopyTo = "Clipboard" }) },
    { key = "v",            mods = "SUPER",       action = wezterm.action({ PasteFrom = "Clipboard" }) },
    { key = "=",            mods = "SUPER",       action = wezterm.action.IncreaseFontSize },
    { key = "-",            mods = "SUPER",       action = wezterm.action.DecreaseFontSize },
  },
  hyperlink_rules = {
    {
      regex = "\\b\\w+://[\\w.-]+:[0-9]{2,15}\\S*\\b",
      format = "$0",
    },
    {
      regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
      format = "$0",
    },
    {
      regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
      format = "mailto:$0",
    },
    {
      regex = [[\bfile://\S*\b]],
      format = "$0",
    },
    {
      regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
      format = "$0",
    },
    {
      regex = [[\b[tT](\d+)\b]],
      format = "https://example.com/tasks/?t=$1",
    },
  },
}
