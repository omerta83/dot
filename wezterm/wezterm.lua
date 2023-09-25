local wezterm = require("wezterm")
local keys = require("keys")
local colors = wezterm.color.get_builtin_schemes()['Tokyo Night']

wezterm.on('gui-startup', function(cmd)
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
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
    ["volta-shim"] = {
      { Foreground = { Color = colors.ansi[4] } },
      { Text = wezterm.nerdfonts.md_lightning_bolt_outline },
    },
    ["bun"] = {
      { Foreground = { Color = colors.ansi[4] } },
      { Text = wezterm.nerdfonts.fae_bread },
    },
    [""] = { -- if empty, set it to ssh
      { Text = wezterm.nerdfonts.md_ssh },
    }
  }

  local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")

  return wezterm.format(
    process_icons[process_name]
    or { { Foreground = { Color = colors.ansi[4] } }, { Text = string.format("[%s]", process_name) } }
  )
end

local function getCWD(tab)
  local current_dir = tab.active_pane.current_working_dir
  if current_dir == nil then
    return ""
  end

  local HOME_DIR = string.format("file://%s", os.getenv("HOME"))
  return current_dir == HOME_DIR and "~" or string.format("%s", string.gsub(current_dir.file_path, "(.*[/\\])(.*)", "%2"))
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
  -- font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" }),
  font = wezterm.font_with_fallback({
    {
      family = 'JetBrainsMono Nerd Font',
      weight = 'ExtraLight'
    }
  }),
  font_size = 16,
  freetype_load_flags = 'NO_HINTING',
  enable_wayland = false,
  term = 'wezterm',
  pane_focus_follows_mouse = false,
  warn_about_missing_glyphs = false,
  show_update_window = false,
  check_for_updates = false,
  cell_width = 1.1,
  line_height = 1.04,
  window_decorations = "RESIZE",
  window_close_confirmation = "NeverPrompt",
  audible_bell = "Disabled",
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 0,
  },
  inactive_pane_hsb = {
    saturation = 1.0,
    brightness = 0.85,
    -- brightness = 1.0,
  },
  enable_scroll_bar = false,
  tab_bar_at_bottom = true,
  use_fancy_tab_bar = false,
  show_new_tab_button_in_tab_bar = false,
  tab_max_width = 50,
  hide_tab_bar_if_only_one_tab = true,
  window_background_opacity = 1.0,
  disable_default_key_bindings = false,
  -- front_end = "WebGpu",
  colors = colors,
  -- color_scheme = 'rose-pine',
  keys = keys,
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
