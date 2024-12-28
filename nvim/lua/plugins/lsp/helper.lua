local mr = require 'mason-registry'

local M = {}

-- Install all packages on startup
-- Extracted from https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
M.mason_install = function(packages)
  local show = vim.schedule_wrap(function(msg)
    vim.notify(msg, vim.log.levels.INFO, { title = 'mason-tool-installer' })
  end)
  local show_error = vim.schedule_wrap(function(msg)
    vim.notify(msg, vim.log.levels.ERROR, { title = 'mason-tool-installer' })
  end)

  local installed_packages = {}
  local do_install = function(p, version, on_close)
    show(string.format('%s: installing', p.name))
    p:once('install:success', function()
      show(string.format('%s: successfully installed', p.name))
    end)
    p:once('install:failed', function()
      show_error(string.format('%s: failed to install', p.name))
    end)
    table.insert(installed_packages, p.name)
    p:install({ version = version }):once('closed', vim.schedule_wrap(on_close))
  end

  local completed = 0
  local total = vim.tbl_count(packages)
  local on_close = function()
    completed = completed + 1
    if completed >= total then
      local event = {
        pattern = 'MasonToolsUpdateCompleted',
      }
      if vim.fn.has 'nvim-0.8' == 1 then
        event.data = installed_packages
      end
      vim.api.nvim_exec_autocmds('User', event)
    end
  end

  local ensure_installed = function()
    for _, item in ipairs(packages or {}) do
      local name = item
      local p = mr.get_package(name)
      if p:is_installed() then
        vim.schedule(on_close)
      else
        do_install(p, nil, on_close)
      end
    end
  end

  if mr.refresh then
    mr.refresh(ensure_installed)
  else
    ensure_installed()
  end
end

return M
