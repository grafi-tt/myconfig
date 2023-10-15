vim.api.nvim_create_augroup('VimRC', {})

-- ui
vim.opt.list = true
vim.opt.listchars = 'tab:>-,trail:-,nbsp:+,extends:>,precedes:<'
vim.opt.number = true
vim.opt.scrolloff = 2
vim.opt.visualbell = true

-- edit
vim.keymap.set('n', '<ESC><ESC>', ':nohlsearch<CR>')
vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0
vim.opt.tabstop = 4
-- input soft tab by S-tab
vim.keymap.set('i', '<S-Tab>', [[<C-R>=repeat(' ', &shiftwidth - (virtcol('.') - 1) % &shiftwidth)<CR>]])

-- space keymaps
vim.keymap.set('n', '<Space>s', ':<C-U>shell<CR>')
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

-- packer
local packer_commit = 'ea0cc3c59f67c440c5ff0bbe4fb9420f4350b9a3'
local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

local function setup_packer()
  require('packer').startup(function(use)
    use {'wbthomason/packer.nvim', commit = packer_commit}
    use {'Shatur/neovim-ayu', commit = '76dbf939b38e03ac5f9bd711ab3e434999f715c8'}
    use {'jamessan/vim-gnupg', commit = 'f9b608f29003dfde6450931dc0f495a912973a88'}
  end)
end

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
    setup_packer()
  end, { nargs = 0 })
  return
end

setup_packer()

-- ayu colorscheme
local colors = require('ayu.colors')
require('ayu').setup({
  mirage = true,
  overrides = function() return {
    Normal = { fg = colors.fg, bg = "None" },
    VertSplit = { fg = colors.guide_normal, bg = "None" },
    FoldColumn = { bg = "None" },
    SignColumn = { bg = "None" },
    WhichKeyFloat = { bg = "None" },
  } end,
})
require('ayu').colorscheme()

-- clipboard
vim.opt.clipboard = 'unnamed,unnamedplus'

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
