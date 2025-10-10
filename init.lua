-- =========================================
-- Plugin Manager: lazy.nvim
-- =========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)




require("lazy").setup({
  "neovim/nvim-lspconfig",           -- LSP support
  "williamboman/mason.nvim",         -- Tool installer
  "williamboman/mason-lspconfig.nvim", -- LSP + Mason bridge
  "hrsh7th/nvim-cmp",                -- Autocompletion engine
  "hrsh7th/cmp-nvim-lsp",            -- LSP source for cmp
  "nvim-treesitter/nvim-treesitter", -- Syntax highlighting
})



-- =========================================
-- General Settings
-- =========================================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.g.mapleader = " "



-- =========================================
-- LSP Setup for C++ (clangd)
-- =========================================
require("mason").setup()
require("mason-lspconfig").setup()


local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.clangd.setup({
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--clang-tidy" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
  on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, silent = true }
    local keymap = vim.keymap.set
    keymap("n", "gd", vim.lsp.buf.definition, opts)
    keymap("n", "K", vim.lsp.buf.hover, opts)
    keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
    keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    keymap("n", "[d", vim.diagnostic.goto_prev, opts)
    keymap("n", "]d", vim.diagnostic.goto_next, opts)
  end,
})




-- =========================================
-- Autocompletion Setup
-- =========================================
local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
  },
})

