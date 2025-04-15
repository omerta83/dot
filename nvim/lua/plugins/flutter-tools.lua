return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    opts = {
      fvm = true,
      widget_guides = {
        enabled = true,
      },
      dev_log = {
        open_cmd = "10split",
        focus_on_open = false,
      },
      lsp = {
        color = {
          enabled = true,
          virtual_text_str = "󱓻",
        },
        settings = {
          completeFunctionCalls = true,
          analysisExcludedFolders = {
            vim.fn.expand '$HOME/.pub-cache',
            -- vim.fn.expand '$HOME/fvm/versions', -- flutter-tools should automatically exclude your SDK.
          },
        }
      }
    }
  },
}
