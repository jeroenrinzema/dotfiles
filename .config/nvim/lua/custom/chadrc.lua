local M = {}

M.options = {
  relativenumber = true,
}

local userPlugins = require "custom.plugins"

M.plugins = {
  install = userPlugins,
  options = {
   lspconfig = {
      setup_lspconf = "custom.plugins.lspconfig",
    },
  },
}

return M
