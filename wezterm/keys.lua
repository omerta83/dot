local wezterm = require "wezterm"

local direction_keys = {
  Left = 'h',
  Down = 'j',
  Up = 'k',
  Right = 'l',
  -- reverse lookup
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

return {
  { key = [[\]],     mods = "SUPER|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = [[-]],     mods = "SUPER|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = [[Space]], mods = "SUPER|SHIFT", action = wezterm.action.QuickSelect },
  -- Rename tab
  {
    key = "t",
    mods = "SUPER|SHIFT",
    action = wezterm.action.PromptInputLine {
      description = 'Enter new name for tab',
      action = wezterm.action_callback(function(window, _, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }
  },
  { key = "t", mods = "SUPER",       action = wezterm.action({ SpawnTab = "DefaultDomain" }) },
  { key = "w", mods = "SUPER",       action = wezterm.action({ CloseCurrentTab = { confirm = false } }) },
  { key = "q", mods = "SUPER|SHIFT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
  { key = "z", mods = "SUPER|SHIFT", action = wezterm.action.TogglePaneZoomState },
  { key = "h", mods = "SUPER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
  { key = "j", mods = "SUPER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
  { key = "k", mods = "SUPER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
  { key = "l", mods = "SUPER|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
  { key = "f", mods = "SUPER|SHIFT", action = wezterm.action.ToggleFullScreen },
  -- activate pane selection mode with numeric labels
  {
    key = '9',
    mods = 'CTRL',
    action = wezterm.action.PaneSelect {
      alphabet = '1234567890',
    },
  },
  -- show the pane selection mode, but have it swap the active and selected panes
  {
    key = '0',
    mods = 'CTRL',
    action = wezterm.action.PaneSelect {
      mode = 'SwapWithActive',
      alphabet = '1234567890',
    },
  },

  -- move between split panes
  split_nav('move', 'h'),
  split_nav('move', 'j'),
  split_nav('move', 'k'),
  split_nav('move', 'l'),
  -- resize panes
  split_nav('resize', 'h'),
  split_nav('resize', 'j'),
  split_nav('resize', 'k'),
  split_nav('resize', 'l'),

  { key = "[", mods = "SUPER",       action = wezterm.action({ ActivateTabRelative = -1 }) },
  { key = "]", mods = "SUPER",       action = wezterm.action({ ActivateTabRelative = 1 }) },
  { key = "<", mods = "SUPER|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
  { key = ">", mods = "SUPER|SHIFT", action = wezterm.action.MoveTabRelative(1) },
  { key = "x", mods = "SUPER|SHIFT", action = wezterm.action.ActivateCopyMode },
  { key = "1", mods = "SUPER",       action = wezterm.action({ ActivateTab = 0 }) },
  { key = "2", mods = "SUPER",       action = wezterm.action({ ActivateTab = 1 }) },
  { key = "3", mods = "SUPER",       action = wezterm.action({ ActivateTab = 2 }) },
  { key = "4", mods = "SUPER",       action = wezterm.action({ ActivateTab = 3 }) },
  { key = "5", mods = "SUPER",       action = wezterm.action({ ActivateTab = 4 }) },
  { key = "6", mods = "SUPER",       action = wezterm.action({ ActivateTab = 5 }) },
  { key = "7", mods = "SUPER",       action = wezterm.action({ ActivateTab = 6 }) },
  { key = "8", mods = "SUPER",       action = wezterm.action({ ActivateTab = 7 }) },
  { key = "9", mods = "SUPER",       action = wezterm.action({ ActivateTab = 8 }) },
  { key = "c", mods = "SUPER",       action = wezterm.action({ CopyTo = "Clipboard" }) },
  { key = "v", mods = "SUPER",       action = wezterm.action({ PasteFrom = "Clipboard" }) },
  { key = "=", mods = "SUPER",       action = wezterm.action.IncreaseFontSize },
  { key = "-", mods = "SUPER",       action = wezterm.action.DecreaseFontSize },
}
