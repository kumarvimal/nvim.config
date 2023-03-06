-- Ref: https://github.com/VonHeikemen/lsp-zero.nvim
local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
  'tsserver',
  'rust_analyzer',
  'html',
  'cssls',
  'pylsp', -- https://github.com/python-lsp/python-lsp-server
  'lua_ls',
  'yamlls',
  'jsonls',
  'sqlls',
  'pyright'
})

-- Fix Undefined global 'vim'
lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        },
    }
})


function Current_project()
    local path = os.getenv( "HOME" ) .. '/.last_opened_project'
    -- scripts/sync_envrs.bsh ensure this file
    local f = assert(io.open(path, 'r'))
    local s = f:read("*all"):gsub("%s", "")
    f:close()
    return s
end

lsp.configure('pylsp', {
  on_attach = function(client, bufnr)
        print("pylsp loaded")
  end,
  settings = {
    configurationSources = "flake8",
    formatCommand = {"black"},
    plugins = {
        pycodestyle = {enabled = false},
        mccabe =      {enabled = true},
        pyflakes =    {enabled = false},
        autopep8 =    {enabled = true},
        pylint = {
            enabled = true,
            executable = "pylint",
            args = {'--rcfile' .. ' ' .. Current_project() .. '/pylintrc'}
        },
        flake8 =     { enabled = true},
        pyls_isort = { enabled = true },
        pylsp_mypy = { enabled = true },

    }
  }
})

lsp.setup()

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ["<C-Space>"] = cmp.mapping.complete(),
})

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
  mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
  vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
  vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
  vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
  vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

