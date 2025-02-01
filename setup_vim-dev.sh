#!/bin/bash
set -e  # Encerra o script imediatamente em caso de erro

# Cabeçalho informativo
echo "***********************************************************"
echo " CONFIGURADOR DE AMBIENTE DE DESENVOLVIMENTO VIM + COC.NVIM"
echo " Inclui:"
echo " - Plugins essenciais"
echo " - Nerd Fonts (Cascadia Mono)"
echo " - LSP para Python/Javascript"
echo "***********************************************************"
echo

# Verificar sistema
if ! command -v apt &> /dev/null; then
  echo "ERRO: Sistema não compatível (apenas Debian/Ubuntu/Kali)" >&2
  exit 1
fi

# Etapa 1: Atualização do sistema
echo "=== ATUALIZANDO SISTEMA ==="
sudo apt update && sudo apt upgrade -y

# Etapa 2: Instalar dependências
echo -e "\n=== INSTALANDO PACOTES ==="
sudo apt install -y vim git curl nodejs npm python3 python3-pip python3-venv pipx unzip

# Configurar pipx
python3 -m pipx ensurepath
export PATH="$PATH:$HOME/.local/bin"

# Etapa 3: Instalar Jedi Language Server
echo -e "\n=== CONFIGURANDO LSP (JEDI) ==="
python3 -m pipx install --force jedi-language-server

# Etapa 4: Instalar fontes
echo -e "\n=== INSTALANDO FONTES ==="
mkdir -p ~/.local/share/fonts
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CascadiaMono.zip -o /tmp/CascadiaMono.zip
unzip -o /tmp/CascadiaMono.zip -d ~/.local/share/fonts/
fc-cache -fv
rm /tmp/CascadiaMono.zip

# Etapa 5: Configurar Vim-Plug
echo -e "\n=== CONFIGURANDO VIM-PLUG ==="
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Etapa 6: Criar .vimrc
echo -e "\n=== CRIANDO CONFIGURAÇÃO DO VIM ==="
cat <<'EOL' > ~/.vimrc
" Configurações básicas
syntax on
set number relativenumber
set tabstop=2 shiftwidth=2 expandtab
set mouse=a clipboard=unnamedplus
set cursorline smartindent

" Gerenciador de plugins
call plug#begin('~/.vim/plugged')

Plug 'mhinz/vim-startify'                     " Tela inicial
Plug 'rafi/awesome-vim-colorschemes'          " Temas
Plug 'preservim/nerdtree'                     " Navegador de arquivos
Plug 'ryanoasis/vim-devicons'                 " Ícones
Plug 'vim-airline/vim-airline'                " Barra de status
Plug 'neoclide/coc.nvim', {'branch': 'release'} " LSP
Plug 'dense-analysis/ale'                     " Linting
Plug 'sheerun/vim-polyglot'                   " Suporte multi-linguagem

call plug#end()

" Aparência
colorscheme materialbox
let g:airline_powerline_fonts = 1
let g:airline_theme='base16_twilight'

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeShowHidden = 1

" Configuração do coc.nvim
source ~/.vim/coc.vimrc
EOL

# Etapa 7: Configuração do coc.nvim
echo -e "\n=== CONFIGURANDO COC.NVIM ==="
mkdir -p ~/.vim

# Arquivo coc.vimrc manual
cat <<'EOL' > ~/.vim/coc.vimrc
set hidden nobackup nowritebackup
set cmdheight=2 updatetime=300
set shortmess+=c signcolumn=yes

" Mapeamentos
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')
EOL

# Arquivo coc-settings.json
cat <<EOL > ~/.vim/coc-settings.json
{
  "languageserver": {
    "jedi": {
      "command": "jedi-language-server",
      "args": ["--stdio"],
      "filetypes": ["python"],
      "initializationOptions": {"markupKindPreferred": "markdown"}
    }
  }
}
EOL

# Etapa 8: Instalar plugins
echo -e "\n=== INSTALANDO PLUGINS ==="
vim -c "PlugInstall" -c "qall" > /dev/null

# Mensagem final
echo -e "\n\033[1;32mCONFIGURAÇÃO CONCLUÍDA!\033[0m"
echo "-----------------------------------------------"
echo "1. Configure a fonte 'CascadiaMono NF' no terminal"
echo "2. Comandos úteis:"
echo "   - Ctrl+n : NERDTree"
echo "   - gd     : Ir para definição"
echo "   - :CocInstall coc-pyright : Extensão Python"
echo "   - :PlugUpdate : Atualizar plugins"
echo "-----------------------------------------------"
