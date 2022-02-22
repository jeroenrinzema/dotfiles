local M = {}

M.setup_lsp = function(attach, capabilities)
    local lspconfig = require "lspconfig"
    lspconfig.gopls.setup{}
end

return M
