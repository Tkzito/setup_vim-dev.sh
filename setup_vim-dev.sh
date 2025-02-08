#!/bin/bash

echo "***********************************************************"
echo " CONFIGURADOR DE AMBIENTE DE DESENVOLVIMENTO VIM + COC.NVIM"
echo "***********************************************************"
echo "Este script automatiza a configuração do ambiente de desenvolvimento"
echo "para Vim com o plugin Coc.nvim, proporcionando uma experiência de"
echo "desenvolvimento completa com suporte a Language Server Protocol (LSP)"
echo "para linguagens como Python e JavaScript."
echo ""
echo "Ao executar este script, você estará configurando o ambiente com:"
echo "- Instalação automática das dependências conforme a distribuição Linux"
echo "- Configuração do Vim com os plugins essenciais para um fluxo de trabalho eficiente"
echo "- Instalação do LSP (Language Server Protocol) para Python e JavaScript"
echo "- Instalação das fontes Nerd, como Cascadia Mono, para uma melhor estética"
echo ""
echo "Distribuições suportadas: Ubuntu, Debian, Fedora, Manjaro, Arch"
echo ""
echo "A instalação será realizada de maneira adaptativa, detectando sua"
echo "distribuição Linux e instalando as dependências necessárias automaticamente."
echo "***********************************************************"

# Detecta a distribuição
distro=$(cat /etc/os-release | grep ^ID= | cut -d= -f2)

echo "Distribuição detectada: $distro"

# Instalar dependências de acordo com a distribuição
if [ "$distro" == "ubuntu" ] || [ "$distro" == "debian" ]; then
    sudo apt update
    sudo apt install -y vim nodejs npm curl git
elif [ "$distro" == "manjaro" ] || [ "$distro" == "arch" ]; then
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm vim nodejs npm curl git
elif [ "$distro" == "fedora" ]; then
    sudo dnf update -y
    sudo dnf install -y vim nodejs npm curl git
else
    echo "Distribuição não suportada ou desconhecida!"
    exit 1
fi

# Verificar se o vim-plug já está instalado
if [ ! -f ~/.vim/autoload/plug.vim ]; then
    echo "Instalando o Vim-Plug..."
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo "Vim-Plug já está instalado."
fi

# Configurar o Vim para usar o Coc.nvim e outros plugins essenciais
echo "Configurando o Vim..."
cat <<EOF > ~/.vimrc
" Vim básico com configurações e plugins essenciais

" Ativa o Vim-Plug
call plug#begin('~/.vim/plugged')

" Plugins essenciais
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/fzf.vim'

call plug#end()

" Configurações gerais do Vim
set number                  " Número das linhas
set relativenumber          " Número relativo das linhas
set tabstop=4               " Tamanho da tabulação
set shiftwidth=4            " Tamanho do recuo
set expandtab               " Usar espaços em vez de tabs
set smartindent             " Indentação inteligente
set incsearch               " Pesquisa incremental
set hlsearch                " Destacar resultados de pesquisa
set ignorecase              " Ignorar maiúsculas/minúsculas na pesquisa
set clipboard=unnamedplus   " Usar a área de transferência do sistema

" Configurações do Coc.nvim (LSP)
let g:coc_global_extensions = ['coc-python', 'coc-tsserver']

EOF

# Instalar os plugins do Vim
echo "Instalando plugins do Vim..."
vim +PlugInstall +qall

# Instalar as fontes Nerd (Cascadia Mono)
echo "Instalando fontes Nerd (Cascadia Mono)..."
git clone https://github.com/ryanoasis/nerd-fonts.git ~/.nerd-fonts
~/.nerd-fonts/install.sh

# Instalar o LSP para Python e JavaScript
echo "Instalando o LSP para Python e JavaScript..."
npm install -g pyright
npm install -g typescript typescript-language-server

# Finalizando
echo "***********************************************************"
echo "Configuração concluída!"
echo "O ambiente de desenvolvimento foi configurado com sucesso!"
echo "Agora você pode usar o Vim com o Coc.nvim para uma experiência de"
echo "desenvolvimento aprimorada com suporte a LSP para Python e JavaScript."
echo ""
echo "Para começar, basta rodar o comando 'vim' no terminal."
echo ""
echo "Agradecemos por utilizar este script! Aproveite sua jornada de"
echo "desenvolvimento com Vim e Coc.nvim."
