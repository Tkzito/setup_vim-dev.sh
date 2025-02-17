Configuração Automática de Ambiente de Desenvolvimento no Vim
Este repositório contém um script Bash que automatiza a configuração de um ambiente de desenvolvimento no Vim. O script instala e configura plugins essenciais, a fonte CascadiaMono Nerd Font, e ajusta diversas configurações para tornar o Vim mais eficiente para programadores.

Funcionalidades
O script executa as seguintes tarefas:

1. Instalação de Pacotes Necessários
Atualiza o sistema e instala pacotes essenciais como Vim, Git, Curl, Node.js, Python, entre outros.
2. Instalação do Gerenciador de Plugins (vim-plug)
Baixa e instala o vim-plug, permitindo a fácil instalação e gerenciamento de plugins no Vim.
3. Instalação de Plugins do Vim
O script instala diversos plugins úteis para programação, incluindo:

NERDTree – Navegação de arquivos integrada ao Vim.
vim-airline – Barra de status personalizável.
coc.nvim – Autocompletar inteligente e suporte a LSP.
vim-startify – Tela inicial customizável.
vim-devicons – Ícones para arquivos no Vim.
ale – Ferramenta de linting para detectar erros no código.
E muitos outros!
4. Instalação da Nerd Font (CascadiaMono)
Baixa e instala a fonte CascadiaMono Nerd Font, que oferece melhor visualização de ícones e símbolos no terminal.
5. Configuração do coc.nvim
Ajusta o coc.nvim para fornecer autocompletar, linting, sugestões de código e refatoração.
Baseado no repositório vimrc do fberbert, oferecendo uma configuração robusta para o Vim.
Configuração padrão para Python (usando Jedi), mas facilmente adaptável para outras linguagens.
Pré-Requisitos
Para executar o script corretamente, é necessário:

Sistema operacional: Ubuntu ou outro baseado em Debian.
Privilégios de superusuário (sudo) para instalação de pacotes.
Como Usar
1. Clonar este repositório
Baixe o repositório para sua máquina local:

bash
Copiar
Editar
git clone https://github.com/Tkzito/setup_vim-dev.sh
cd repo-vim-setup
2. Tornar o script executável
Após o download, conceda permissão de execução ao script:

bash
Copiar
Editar
chmod +x setup_vim-dev.sh
3. Executar o script
Agora, basta rodar o script para iniciar a configuração:

bash
Copiar
Editar
./setup_vim-dev.sh
O script realizará automaticamente:
✔ Atualização do sistema e instalação de pacotes necessários.
✔ Configuração do vim-plug e instalação de plugins.
✔ Download e instalação da fonte CascadiaMono Nerd Font.
✔ Configuração do coc.nvim para suporte a autocompletar e linting.

Atenção: O script pode solicitar confirmação em algumas etapas. Apenas pressione Enter para continuar.

Agradecimentos
Gostaríamos de agradecer aos projetos que contribuíram para essa configuração:

vimrc do fberbert – Base para configuração do Vim e coc.nvim.
Nerd Fonts – Conjunto de fontes com ícones para melhorar a aparência do terminal.
Contribuição
Se você quiser contribuir com melhorias ou correções para o script, sinta-se à vontade para abrir uma issue ou enviar um pull request.

Licença
Este projeto está licenciado sob a MIT License, permitindo que qualquer pessoa use, modifique e distribua o código livremente, desde que seja mantida a atribuição ao autor original.
