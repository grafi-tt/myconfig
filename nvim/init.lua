vim.api.nvim_create_augroup('VimRC', {})

-- ui
vim.opt.list = true
vim.opt.listchars = { tab = '>-', trail = '-', nbsp = '+', extends = '>', precedes = '<' }
vim.opt.number = true
vim.opt.scrolloff = 2
vim.opt.visualbell = true

-- edit
vim.keymap.set('n', '<ESC><ESC>', ':nohlsearch<CR>', { silent = true })
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0
vim.opt.tabstop = 4
-- input soft tab by S-tab
vim.keymap.set('i', '<S-Tab>', [[<C-R>=repeat(' ', &shiftwidth - (virtcol('.') - 1) % &shiftwidth)<CR>]])

-- space keymaps
vim.keymap.set('n', '<Space>s', '<C-Z>')
vim.keymap.set('n', '<Space>t', ':<C-U>split<CR>')
vim.keymap.set('n', '<Space>v', ':<C-U>vsplit<CR>')
vim.keymap.set('n', '<Space>h', '<C-W>h')
vim.keymap.set('n', '<Space>j', '<C-W>j')
vim.keymap.set('n', '<Space>k', '<C-W>k')
vim.keymap.set('n', '<Space>l', '<C-W>l')
vim.keymap.set('n', '<Space>H', '<C-W>H')
vim.keymap.set('n', '<Space>J', '<C-W>J')
vim.keymap.set('n', '<Space>K', '<C-W>K')
vim.keymap.set('n', '<Space>L', '<C-W>L')
vim.keymap.set('n', '<Space>r', '<C-W>r')
vim.keymap.set('n', '<Space>=', '<C-W>=')
vim.keymap.set('n', '<Space>>', '<C-W>>')
vim.keymap.set('n', '<Space><', '<C-W><')
vim.keymap.set('n', '<Space>+', '<C-W>+')
vim.keymap.set('n', '<Space>-', '<C-W>-')
-- leader (trying to change from ",")
vim.g.mapleader = "'"

-- packer
local packer_commit = 'ea0cc3c59f67c440c5ff0bbe4fb9420f4350b9a3'
local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local function setup_packer()
  require('packer').startup(function(use)
    use {'wbthomason/packer.nvim', commit = packer_commit}
    use {'Shatur/neovim-ayu', commit = '76dbf939b38e03ac5f9bd711ab3e434999f715c8'}
    use {'neovim/nvim-lspconfig', commit = 'e49b1e90c1781ce372013de3fa93a91ea29fc34a'}
    use {'jamessan/vim-gnupg', commit = 'f9b608f29003dfde6450931dc0f495a912973a88'}
    use {'gentoo/gentoo-syntax', commit = '865f01aa04434838f0ed1915734e2200759d925b'}
  end)
end
-- if packer not installed, define install command and bail out
if vim.fn.isdirectory(packer_path) == 0 then
  vim.api.nvim_create_user_command('PackerInstall', function(opts)
    local out = vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path})
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_err_writeln(out)
      return
    end
    out = vim.fn.system({'git', '--git-dir', packer_path .. '/.git', 'checkout', packer_commit})
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_err_writeln(out)
      return
    end
    vim.api.nvim_del_user_command('PackerInstall')
    vim.cmd.packadd('packer.nvim')
    vim.o.runtimepath = vim.o.runtimepath .. ',' .. packer_path
    setup_packer()
  end, { nargs = 0 })
  return
end

setup_packer()

-- clipboard
vim.opt.clipboard = {'unnamed' ,'unnamedplus'}

-- keep cursor position
vim.api.nvim_create_autocmd({'BufReadPost'}, {
  group = 'VimRC',
  pattern = {'*'},
  command = [[
      if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit' |
        execute "normal g`\"" |
      endif
  ]],
})

-- ayu colorscheme
local ayu_colors = require('ayu.colors')
local ayu = require('ayu')
ayu.setup {
  mirage = true,
  overrides = function() return {
    Normal = { fg = ayu_colors.fg, bg = 'None' },
    VertSplit = { fg = ayu_colors.guide_normal, bg = 'None' },
    FoldColumn = { bg = 'None' },
    SignColumn = { bg = 'None' },
    WhichKeyFloat = { bg = 'None' },
  } end,
}
ayu.colorscheme()

-- lsp
local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
  end
}
lspconfig.pyright.setup {
  root_dir = lspconfig.util.root_pattern('setup.py', 'pyrightconfig.json', '.git'),
}

local function toggle_diagnostic()
  if vim.b.enable_diagnostic then
    vim.api.nvim_echo({{'Disabling diagnostics...'}}, false, {})
    vim.schedule(function() vim.diagnostic.disable(0) end)
    vim.b.enable_diagnostic = false
  else
    vim.api.nvim_echo({{'Enabling diagnostics...'}}, false, {})
    vim.schedule(function() vim.diagnostic.enable(0) end)
    vim.b.enable_diagnostic = true
  end
end

-- global mappings from nvim-lspconfig example
vim.keymap.set('n', '<Leader>d', toggle_diagnostic)
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<Leader>l', vim.diagnostic.setloclist)
-- buffer local mappings from nvim-lspconfig example
-- modified to avoid conflicts
vim.api.nvim_create_autocmd({'LspAttach'}, {
  group = 'VimRC',
  callback = function(ev)
    if not vim.b.enable_diagnostic then
      vim.diagnostic.disable(0)
    end
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-K>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<Space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<Space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<Space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<Space>R', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<Space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<Leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
