#!/bin/bash
set -e  # Encerra o script imediatamente em caso de erro

# Cabeçalho informativo
echo "***********************************************************"
echo " CONFIGURADOR DE AMBIENTE DE DESENVOLVIMENTO VIM + COC.NVIM"
echo " Este script irá detectar automaticamente a sua distribuição Linux"
echo " e configurar o ambiente de desenvolvimento com Vim e Coc.nvim."
echo " O processo inclui:"
echo " - Instalação automática das dependências conforme sua distribuição"
echo " - Configuração do Vim com plugins essenciais"
echo " - Instalação do LSP (Language Server Protocol) para Python/Javascript"
echo " - Fontes Nerd (Cascadia Mono)"
echo "***********************************************************"
echo

# Função para detectar a distribuição
detect_distro() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
  elif command -v lsb_release &> /dev/null; then
    DISTRO=$(lsb_release -s -d | awk '{print $1}')
  else
    echo "Distribuição desconhecida" >&2
    exit 1
  fi
  echo "Distribuição detectada: $DISTRO"
}

# Chamada para detectar a distribuição
detect_distro

# Função para instalar dependências conforme a distribuição
install_dependencies() {
  case "$DISTRO" in
    ubuntu|debian|kali)
      echo "Distribuição Debian/Ubuntu/Kali detectada."
      sudo apt update && sudo apt upgrade -y
      sudo apt install -y vim git curl nodejs npm python3 python3-pip unzip
      ;;
    arch)
      echo "Distribuição Arch Linux detectada."
      sudo pacman -Syu --noconfirm
      sudo pacman -S --noconfirm vim git curl nodejs npm python python-pip unzip
      sudo pacman -S --noconfirm python-pipx  # Instala pipx usando pacman
      ;;
    fedora)
      echo "Distribuição Fedora detectada."
      sudo dnf update -y
      sudo dnf install -y vim git curl nodejs npm python3 python3-pip unzip
      ;;
    *)
      echo "Distribuição não suportada ou desconhecida!" >&2
      exit 1
      ;;
  esac
}

# Instalar dependências
install_dependencies

# Instalar o pipx (caso ainda não tenha sido instalado com pacman/apt/dnf)
if ! command -v pipx &> /dev/null; then
  echo -e "\n=== INSTALANDO O PIPX ==="
  if [ "$DISTRO" == "arch" ]; then
    echo "pipx já instalado com pacman."
  elif [ "$DISTRO" == "ubuntu" ] || [ "$DISTRO" == "debian" ] || [ "$DISTRO" == "kali" ]; then
    sudo apt install -y python3-pipx
  else
    echo "Usando Python virtual para instalar pipx"
    python3 -m pip install --user pipx
    python3 -m pipx ensurepath
    export PATH="$PATH:$HOME/.local/bin"
  fi
fi

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
