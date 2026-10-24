set clipboard=unnamedplus
set number
set nocompatible                " Это Vim, а не vi из 1976-го
syntax on                       " Подсветка синтаксиса. Как в 90-х, только лучше.
filetype plugin indent on       " Определяем тип файла и отступы
set encoding=utf-8
set fileencoding=utf-8
set backspace=indent,eol,start  " Backspace работает как человек ожидает
set hidden                      " Буферы живут в фоне, не требуя :w перед переключением
set history=1000                " Помним команды
set autoread
set cursorline                  " Тонкая подсветка текущей строки
set colorcolumn=80              " Священные 80 символов. Как на перфокартах, только лучше.
set scrolloff=5                 " 5 строк контекста сверху и снизу
set sidescrolloff=5             " 5 колонок слева и справа
set noerrorbells                " Тишина. Никаких писков.
set visualbell t_vb=            " И даже мигания нет. Полная тишина.
set title                       " Заголовок терминала показывает файл
set shortmess+=I                " Не показываем заставку при старте
set noshowmode
set laststatus=2                " Всегда видим статусбар
set statusline=%f%m%r%h%w       " Файл, изменён, только чтение
set statusline+=%=              " Выравнивание вправо
set statusline+=[%{&ff}]        " Формат файла (unix/dos)
set statusline+=[%{&fenc}]      " Кодировка
set statusline+=[%l,%c]         " Строка, колонка
set statusline+=%p%%
set incsearch                   " Ищем по мере набора
set hlsearch                    " Подсвечиваем найденное
set ignorecase                  " Регистр не важен...
set smartcase                   " ...пока не введёшь заглавную
" Сброс подсветки поиска по двойному Esc
nnoremap <Esc><Esc> :nohlsearch<CR>
set autoindent
set smartindent
set tabstop=4                   " Таб = 4 пробела визуально
set shiftwidth=4                " Сдвиг при >> = 4 пробела
set softtabstop=4
set noexpandtab
set wildmenu                    " Автодополнение команд в стиле меню
set wildmode=longest:full,full  " Tab: сначала общее, потом список
set wildignore+=*.o,*.obj,*.pyc,*.swp,.git,node_modules,__pycache__
" --- Производительность ---
set lazyredraw                  " Не перерисовываем экран во время макросов
set ttyfast                     " Терминал быстрый (спасибо, foot!)

" --- Сплиты ---
set splitright                  " :vsplit открывает справа
set splitbelow
" --- Горячие клавиши: только нужное ---
" Быстрое сохранение и выход
nnoremap <C-s> :w<CR>
nnoremap <C-q> :q<CR>
" Навигация между сплитами без лишних нажатий
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" --- Чистота кода ---
" Подсвечиваем пробелы в конце строк красным
highlight ExtraWhitespace ctermbg=darkred guibg=darkred
match ExtraWhitespace /\s\+$/
" Удаляем мусорные пробелы при сохранении
autocmd BufWritePre * :%s/\s\+$//e

" --- Персистентное undo ---
" Отмена работает даже после закрытия файла
set undofile
set undodir=~/.vim/undodir
if !isdirectory(expand("~/.vim/undodir"))
    call mkdir(expand("~/.vim/undodir"), "p")
endif
" ============================================================
"  Языки: C, Assembly, Python
"  Минимализм 90-х: только встроенные механизмы.
" ============================================================

" --- C / C++ ---
" Классический отступ для C. Настраиваем стиль под 90-е:
" фигурные скобки на той же колонке, что и switch, отступы табами.
autocmd FileType c,cpp setlocal cindent
autocmd FileType c,cpp setlocal cinoptions=:0,l1,g0,t0,(0,u0,w1

" Компилятор по F5. Используем :make, чтобы ошибки падали в quickfix.
autocmd FileType c,cpp setlocal makeprg=gcc\ -Wall\ -Wextra\ -g\ -o\ %<\ %
autocmd FileType c,cpp setlocal errorformat=%f:%l:%c:\ %m,%f:%l:\ %m
autocmd FileType c,cpp nnoremap <buffer> <F5> :w<CR>:make<CR>

" Запуск готового бинаря по F6
autocmd FileType c,cpp nnoremap <buffer> <F6> :w<CR>:!./%<<CR>

" Поиск заголовочных файлов и переход к #include через gf
autocmd FileType c,cpp setlocal path+=/usr/include,/usr/local/include
autocmd FileType c,cpp setlocal include=^\s*#\s*include
autocmd FileType c,cpp setlocal suffixesadd=.c,.h

" --- Assembly ---
" В ассемблере табы — это святое. Никаких пробелов.
" Работает для NASM (.asm) и GAS (.s, .S)
autocmd FileType asm,nasm setlocal noexpandtab
autocmd FileType asm,nasm setlocal tabstop=8
autocmd FileType asm,nasm setlocal shiftwidth=8
autocmd FileType asm,nasm setlocal softtabstop=0
autocmd FileType asm,nasm setlocal commentstring=;\ %s

" --- Python ---
" PEP8 требует пробелы. 4 пробела, никаких табов.
autocmd FileType python setlocal expandtab
autocmd FileType python setlocal tabstop=4
autocmd FileType python setlocal shiftwidth=4
autocmd FileType python setlocal softtabstop=4
autocmd FileType python setlocal textwidth=79
autocmd FileType python setlocal colorcolumn=80

" --- Quickfix: навигация по ошибкам компиляции ---
" После нажатия F5 все ошибки от gcc попадают в список.
" Прыгаем по ним без набора команд.
nnoremap <C-n> :cnext<CR>
nnoremap <C-p> :cprev<CR>
nnoremap <C-l> :clist<CR>

" --- ctags: навигация по коду как в 90-х ---
" Генерируем файл тегов: ctags -R
" Ctrl+] — прыжок к определению функции/переменной
" Ctrl+t — вернуться обратно
set tags=./tags,tags;
nnoremap <C-]> :tag<CR>
nnoremap <C-t> :pop<CR>
