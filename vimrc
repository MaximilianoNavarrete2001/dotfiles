
"-------------
" Mis plugins
"-------------
call plug#begin('~/.vim/plugged')

"Temas
Plug 'morhetz/gruvbox'

"NerdTree
Plug 'preservim/nerdtree' "Ver ficheros
Plug 'trusktr/seti.vim'

"Syntax
Plug 'tpope/vim-commentary'                     "Comentar gc visual gcc en nomrmal  
Plug 'jiangmiao/auto-pairs'                     "Cerrar automatico llaves
Plug 'Yggdroot/indentLine'                      "Ver identacion
Plug 'dense-analysis/ale'                       "Errores a timepo real
Plug 'neoclide/coc.nvim', {'branch': 'release'} "Autocompletado
Plug 'vim-scripts/bash-support.vim'             "Syntaxis para  Bash
Plug 'vim-python/python-syntax'                 "Syntaxis para python 
Plug 'farmergreg/vim-lastplace'                 "Ultima posicion

"Barra
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"Pantalla de inicio
Plug 'mhinz/vim-startify'
let g:startify_enable_number = 0
let g:startify_enable_special = 0

"Git
Plug 'tpope/vim-fugitive'      " Cliente Git dentro de Vim (:Git, :Gdiff, :Gblame...)
Plug 'airblade/vim-gitgutter'  " Muestra cambios (+ ~ -) en el margen
Plug 'junegunn/gv.vim'         " Historial de commits en una ventana bonita

call plug#end()

"--------------------
" Mis configuraciones
"---------------------

set number
set relativenumber

" Que los splits verticales se abran a la derecha y los horizontales abajo
set splitright
set splitbelow

"Tabulacion y identacion
set tabstop=4        " Muestra un tabulador como 4 espacios
set shiftwidth=4     " Indentación automática de 4 espacios
set expandtab        " Convierte tabuladores en espacios
set softtabstop=4    " Usa 4 espacios cuando presionas la tecla Tab

" Configuración de indentación automática
set autoindent       " Copia la indentación de la línea anterior
set smartindent      " Indenta automáticamente en bloques de código
set cindent          " Indentación adecuada para lenguajes estilo C/Java
set cinoptions=:0,j1,(0  " Ajuste fino de cindent para Java

" Configruacion para el plegado
set foldmethod=syntax
set foldenable 
set foldlevelstart=99

syntax on
set background=dark
colorscheme gruvbox

"Trasparencia
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE

"Tema de la barra
let g:airline_theme = 'wombat'
let g:airline#extensions#branch#enabled = 1    " Muestra la rama actual de Git
let g:airline_theme='gruvbox'
set laststatus=2

"-------------------
" Atajos de teclado
"-------------------

" Entra a modo insertar si el buffer es una terminal
function! s:TermInsert()
  if &buftype ==# 'terminal' && mode() !=# 't'
    call feedkeys('i', 'n')
  endif
endfunction

augroup TERM_AUTO_INSERT
  autocmd!
  autocmd BufEnter term://* call <SID>TermInsert()
  autocmd WinEnter term://* call <SID>TermInsert()
augroup END

" NORMAL mode → mover y si caes en terminal: insertar
nnoremap <C-h> <C-w>h:call <SID>TermInsert()<CR>
nnoremap <C-j> <C-w>j:call <SID>TermInsert()<CR>
nnoremap <C-k> <C-w>k:call <SID>TermInsert()<CR>
nnoremap <C-l> <C-w>l:call <SID>TermInsert()<CR>

" TERMINAL mode → salir, mover y si destino es terminal: insertar
tnoremap <C-h> <C-\><C-n><C-w>h:call <SID>TermInsert()<CR>
tnoremap <C-j> <C-\><C-n><C-w>j:call <SID>TermInsert()<CR>
tnoremap <C-k> <C-\><C-n><C-w>k:call <SID>TermInsert()<CR>
tnoremap <C-l> <C-\><C-n><C-w>l:call <SID>TermInsert()<CR>

"Abrir terminal
let g:startify_change_to_dir = 1
let g:NERDTreeChDirMode = 2
nnoremap <Space><Space> :lcd %:p:h<CR>:rightbelow vert terminal<CR>
"nnoremap <Space><Space> :rightbelow vert terminal<CR>

"Comentar
nnoremap <C-e> gcc
vnoremap <C-e> gc

"Abrir NerdTree
nmap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeQuitOnOpen = 1
autocmd FileType nerdtree nmap <buffer> <CR> 

"Mueve a la primera columna
nnoremap <A-1> <C-w>H
"Mueve a la última línea
nnoremap <A-2> <C-w>J
"Mueve a la primera línea
nnoremap <A-3> <C-w>K
"Mueve a última columna
nnoremap <A-4> <C-w>L

"Rota las ventanas en sentido contrario a las agujas del reloj
nnoremap r <C-w>r
"Rota las ventanas en el sentido de las agujas del reloj
nnoremap R <C-w>R

"Entrar a modo nomrmal
inoremap <C-q> <Esc>
vnoremap <C-q> <Esc>

" Copiar al portapapeles
vnoremap <C-c> :w !xclip -sel clip<CR><CR>

" Plegar
vnoremap zc :exec &foldlevel == 0 ? "set foldlevel == 99" : foldlevel=<CR> 

"------------
" Syntax ALE
"------------

" Habilitar Checkstyle para archivos Java
let g:ale_linters = {
    \ 'java': ['javac'],
\}

" Funcion para copiar
function! CopyToClipboard()
    if mode() ==# 'v'
        execute "normal! gv\"+y"
        call system("xclip -selection clipboard", @+)
        echo "Texto seleccionado copiado al portapapeles"
    else
        echo "Selecciona algo primero en modo visual"
    endif
endfunction

" Reconocer .asm como NASM
au BufNewFile,BufRead *.asm set filetype=nasm

"Compilar y eblazar NASM con :make
autocmd FileType nasm setlocal makeprg=nasm\ -f\ elf32\ %\ -o\ %<.o\ &&\ gcc\ -m32\ %<.o\ -o\ %<

"Mapear la tecla para ejecutar
nnoremap <F5> :!./%<<CR>

" ==================================================
" CONFIGURACIÓN PARA PYTHON (Max)
" ==================================================

" Ajustes de identación, formato y ejecución
augroup PYTHON_MAX
  autocmd!
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 expandtab
  autocmd FileType python setlocal colorcolumn=88 textwidth=0
  autocmd FileType python nnoremap <buffer> <F5> :w<CR>:!python %<CR>
augroup END

" ==================================================
" ALE - Análisis y corrección para Python
" ==================================================
let g:ale_linters = {
\   'python': ['flake8', 'pylint', 'mypy'],
\}

let g:ale_fixers = {
\   'python': ['black'],
\}

let g:ale_fix_on_save = 1
let g:ale_python_flake8_executable = 'flake8'
let g:ale_python_pylint_executable = 'pylint'
let g:ale_python_mypy_executable = 'mypy'
let g:ale_python_black_executable = 'black'
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'

" ==================================================
" COC - Autocompletado y análisis LSP
" ==================================================
" Instalar la extensión con :CocInstall coc-pyright
" Atajos útiles
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> K :call CocActionAsync('doHover')<CR>

" Desactiva texto virtual de ALE
let g:ale_virtualtext = 0
let g:ale_virtualtext_cursor = 0

" (Opcional) silencia docstring en Pylint si ALE usa Pylint
let g:ale_python_pylint_options = '--disable=C0114,C0115,C0116,C0301,W0611,W0612'
let g:ale_python_pycodestyle_options = '--ignore=E501'
let g:ale_python_flake8_options = '--ignore=E501'

" Desactivar flechas en modo normal
nnoremap <Up>    <Nop>
nnoremap <Down>  <Nop>
nnoremap <Left>  <Nop>
nnoremap <Right> <Nop>

" Desactivar flechas en modo visual
vnoremap <Up>    <Nop>
vnoremap <Down>  <Nop>
vnoremap <Left>  <Nop>
vnoremap <Right> <Nop>


" Menu
let g:startify_custom_header = [
\ '  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░',
\ '              V I M   ·   A R C H           ',
\ '  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░',
\ ' ',
\ '    Bienvenido, Max. ',
\ ' ',
\ '        "KEEP IT SIMPLE, STUPID."',
\ ' '
\ ]

hi StartifyHeader ctermfg=109
hi StartifyBracket ctermfg=245
hi StartifyNumber ctermfg=109
hi StartifyPath ctermfg=245
hi StartifySlash ctermfg=245
hi StartifyFile ctermfg=223

" 1) lista de CONFIGURACIÓN
function! s:startify_config()
  return [
        \ {'line': ' -> Scripts system', 'cmd': ':e ~/Script'},
        \ {'line': ' -> .vimrc',         'cmd': ':e ~/.vimrc'},
        \ {'line': ' -> i3 config',      'cmd': ':e ~/.config/i3/config'},
        \ ]
endfunction

" 2) lista de LENGUAJES
function! s:startify_langs()
  return [
        \ {'line': ' -> ASM',    'cmd': ':e ~/Programming/asm/'},
        \ {'line': ' -> Python', 'cmd': ':e ~/Programming/py/Course/'},
        \ {'line': ' -> Java',   'cmd': ':e ~/Programming/java/'},
        \ {'line': ' -> C',      'cmd': ':e ~/Programming/c/'},
        \ {'line': ' -> Bash',   'cmd': ':e ~/Programming/sh/'},
        \ ]
endfunction

" 3) ahora sí, las dos secciones separadas
let g:startify_lists = [
      \ { 'type': function('s:startify_config'), 'header': ['   🔧 Configuración'] },
      \ { 'type': function('s:startify_langs'),  'header': ['   💻 Lenguajes'] },
      \ ]


" Usa espacio como <leader> (atajos personalizados)
let mapleader = " "

" ---------- vim-fugitive ----------
" Estado de git, como 'git status'
nnoremap <leader>gs :Git<CR>

" Añadir y editar commit (abre pantalla de commit)
nnoremap <leader>gc :Git commit<CR>

" Push / pull rápido
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git pull<CR>

" Diff del archivo actual contra HEAD
nnoremap <leader>gd :Gdiffsplit<CR>

" Ver quién tocó cada línea
nnoremap <leader>gb :Git blame<CR>


" ---------- vim-gitgutter ----------
" Activa el plugin
let g:gitgutter_enabled = 1

" Signos en la columna izquierda
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '_'

" Navegar entre “hunks” (bloques de cambios)
nnoremap [h :GitGutterPrevHunk<CR>
nnoremap ]h :GitGutterNextHunk<CR>

" Stage / deshacer un hunk
nnoremap <leader>hs :GitGutterStageHunk<CR>
nnoremap <leader>hu :GitGutterUndoHunk<CR>


" ---------- gv.vim ----------
" Ver historial de commits del repo
nnoremap <leader>gv :GV<CR>


