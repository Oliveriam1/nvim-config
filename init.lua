-- Auto-updates
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
  { "rose-pine/neovim", name = "rose-pine", priority = 1000 },
  { "catppuccin/nvim", name = "catppuccin" },
  { "folke/tokyonight.nvim" },
  { 
    "xiyaowong/transparent.nvim",
    lazy = false,
    config = function()
      require("transparent").setup({
        extra_groups = {
          "NormalFloat", 
          "FloatBorder", 
          "NvimTreeNormal", 
          "SignColumn", 
          "StatusLine",
          "StatusLineNC",
          "EndOfBuffer"
        },
      })
    end
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({ options = { theme = "rose-pine", icons_enabled = true } })
    end
  },
  { "nvim-tree/nvim-web-devicons" },

  { "nvim-tree/nvim-tree.lua", config = true },
  { 
    "nvim-telescope/telescope.nvim", 
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true 
  },

  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },

  { "lewis6991/gitsigns.nvim", config = true },
  { "windwp/nvim-autopairs", config = true },
  { "numToStr/Comment.nvim", config = true },
})

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

pcall(vim.cmd, "colorscheme rose-pine")

-- LSP
local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
local cmp_lsp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")

if mason_lsp_ok and cmp_lsp_ok then
  local servers = { "lua_ls", "clangd", "gopls", "html", "cssls", "ts_ls" }
  
  mason_lsp.setup({ ensure_installed = servers })
  local capabilities = cmp_lsp.default_capabilities()
  
  for _, server in ipairs(servers) do
    if vim.lsp.config then
      vim.lsp.config(server, {
        capabilities = capabilities,
      })
      vim.lsp.enable(server)
    end
  end
end

local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
  cmp.setup({
    snippet = {
      expand = function(args) require("luasnip").lsp_expand(args.body) end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping.select_next_item(),
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
    }),
  })
end

vim.cmd([[
  highlight Normal guibg=NONE ctermbg=NONE
  highlight NormalNC guibg=NONE ctermbg=NONE
  highlight SignColumn guibg=NONE ctermbg=NONE
  highlight StatusLine guibg=#5c1d24 guifg=#e0def4
  highlight StatusLineNC guibg=#421217 guifg=#908caa
  highlight LineNr guifg=#b4637a
  highlight CursorLineNr guifg=#ebbcba gui=bold
]])
