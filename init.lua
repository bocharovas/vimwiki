local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd('packadd packer.nvim')
  end
end
ensure_packer()

require('packer').startup(function()
  use 'vimwiki/vimwiki'
  use 'tbabej/taskwiki'
end)

vim.cmd('syntax on')  -- Включаем подсветку синтаксиса
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "index.md",  -- Это путь к файлу
  callback = function()
    local script_path = vim.fn.expand("$HOME") .. "/vimwiki/tasks.sh"
    -- Проверим, что скрипт существует, прежде чем запускать
    if vim.fn.filereadable(script_path) == 1 then
      print("Запускаем скрипт " .. script_path)
      vim.fn.system("bash " .. script_path)
    else
      print("Скрипт не найден: " .. script_path)
    end
  end
})
vim.o.number = true   -- Включаем нумерацию строк
vim.g.mapleader = ' '  -- Устанавливаем лидирующую клавишу как пробел

vim.g.vimwiki_list = {{
    path = os.getenv("HOME") .. "/vimwiki/",
    syntax = 'markdown',                  -- Синтаксис Markdown
    ext = '.md',                          -- Расширение файлов
    template_path = vim.fn.expand('~/vimwiki/templates/'),  -- Путь к шаблонам
    template_default = 'daily',           -- Шаблон по умолчанию
    template_ext = '.md'                  -- Расширение шаблонов
}}

vim.api.nvim_set_keymap('n', '<leader>ww', ':VimwikiIndex<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wt', ':VimwikiMakeDiaryNote<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ws', ':VimwikiUISelect<CR>', { noremap = true, silent = true })

vim.g.taskwiki_markdown = 1  -- Включение Markdown для задач
vim.g.taskwiki_update_on_write = 1  -- Автоматическая синхронизация с Taskwarrior
vim.g.taskwiki_split_cmd = 'botright vsplit'  -- Открывать список задач в вертикальном сплите
vim.g.taskwiki_date_format = '%Y-%m-%d'  -- Формат даты

vim.opt.number = true
vim.opt.relativenumber = true
vim.g.python3_host_prog = '/usr/bin/python3'
vim.g.vimwiki_global_ext = 0
