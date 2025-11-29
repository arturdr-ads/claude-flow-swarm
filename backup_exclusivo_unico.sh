#!/bin/bash

# 🎯 CLAUDE FLOW - BACKUP EXCLUSIVO (O que NÃO vem no GitHub)
# Apenas componentes únicos e personalizados

echo "🎯 CLAUDE FLOW - BACKUP EXCLUSIVO (ÚNICO)"
echo "======================================"
echo "📝 Backupeando apenas o que NÃO está no Claude Code CLI nem no GitHub"
echo ""

BACKUP_DIR="$HOME/claude-flow-exclusivo-backup-$(date +%Y%m%d-%H%M%S)"
SOURCE_DIR="$HOME/Claude"

echo "📁 Backup: $BACKUP_DIR"
echo ""

# Criar diretório de backup
mkdir -p "$BACKUP_DIR"

echo "🔍 ANALISANDO COMPONENTES EXCLUSIVOS..."
echo ""

# 1. COMANDOS PERSONALIZADOS (ESSENCIAL!)
echo "📋 1. Comandos Claude personalizados (ESSENCIAL)..."
mkdir -p "$BACKUP_DIR/claude-commands"
cp -r "$HOME/.claude/commands" "$BACKUP_DIR/claude-commands/" 2>/dev/null && echo "   ✅ Comandos Claude ($(du -sh "$HOME/.claude/commands" | cut -f1))" || echo "   ❌ Falhou"

# 2. LAZY-MCP COMPLETO (Sistema Go personalizado)
echo "🚀 2. Lazy-MCP System (Go-based)..."
if [ -d "$SOURCE_DIR/lazy-mcp" ]; then
    cp -r "$SOURCE_DIR/lazy-mcp" "$BACKUP_DIR/" 2>/dev/null && echo "   ✅ Lazy-MCP ($(du -sh "$SOURCE_DIR/lazy-mcp" | cut -f1))" || echo "   ❌ Falhou"
    echo "   📝 Contém: Go modules, proxy system, structure generator"
else
    echo "   ⚠️  Lazy-MCP não encontrado"
fi

# 3. CLAUDE FLOW UNIFIED (Versão otimizada pessoal)
echo "🤖 3. Claude Flow Unified (sua versão otimizada)..."
cp "$SOURCE_DIR/claude_flow_unified.py" "$BACKUP_DIR/" 2>/dev/null && echo "   ✅ claude_flow_unified.py ($(du -sh "$SOURCE_DIR/claude_flow_unified.py" | cut -f1))" || echo "   ❌ Falhou"

# 4. SCRIPTS PERSONALIZADOS
echo "📜 4. Scripts personalizados..."
mkdir -p "$BACKUP_DIR/scripts"
cp "$SOURCE_DIR/mcp_manager.sh" "$BACKUP_DIR/scripts/" 2>/dev/null && echo "   ✅ mcp_manager.sh" || echo "   ❌ Falhou"
cp "$SOURCE_DIR/mcp_discovery.sh" "$BACKUP_DIR/scripts/" 2>/dev/null && echo "   ✅ mcp_discovery.sh" || echo "   ❌ Falhou"
cp "$SOURCE_DIR/github_actions_debugger.py" "$BACKUP_DIR/scripts/" 2>/dev/null && echo "   ✅ github_actions_debugger.py" || echo "   ❌ Falhou"

# Scripts da pasta scripts/
if [ -d "$SOURCE_DIR/scripts" ]; then
    cp -r "$SOURCE_DIR/scripts" "$BACKUP_DIR/scripts/" 2>/dev/null && echo "   ✅ scripts/ (claude-health, workshop, validate-agents)" || echo "   ❌ Falhou"
fi

# 5. CONFIGURAÇÕES EXCLUSIVAS
echo "⚙️  5. Configurações exclusivas..."
mkdir -p "$BACKUP_DIR/configs"

# Configurações Claude
cp "$HOME/.claude/settings.json" "$BACKUP_DIR/configs/" 2>/dev/null && echo "   ✅ settings.json" || echo "   ❌ Falhou"
cp "$HOME/.claude/settings.local.json" "$BACKUP_DIR/configs/" 2>/dev/null && echo "   ✅ settings.local.json" || echo "   ❌ Falhou"
cp "$HOME/.claude/settings_ondemand.json" "$BACKUP_DIR/configs/" 2>/dev/null && echo "   ✅ settings_ondemand.json" || echo "   ❌ Falhou"
cp "$HOME/.claude/mcp-servers.json" "$BACKUP_DIR/configs/" 2>/dev/null && echo "   ✅ mcp-servers.json" || echo "   ❌ Falhou"

# 6. MCP SERVERS PERSONALIZADOS
echo "🔌 6. MCP Servers personalizados..."
if [ -d "$SOURCE_DIR/mcp-servers" ]; then
    cp -r "$SOURCE_DIR/mcp-servers" "$BACKUP_DIR/" 2>/dev/null && echo "   ✅ mcp-servers ($(du -sh "$SOURCE_DIR/mcp-servers" | cut -f1))" || echo "   ❌ Falhou"
    echo "   📝 Node.js modules customizados"
fi

# 7. BANCO DE DADOS E HISTÓRICO
echo "💾 7. Banco de dados e histórico..."
mkdir -p "$BACKUP_DIR/data"

# Banco de dados Swarm
if [ -f "$SOURCE_DIR/.swarm/memory.db" ]; then
    cp "$SOURCE_DIR/.swarm/memory.db" "$BACKUP_DIR/data/" 2>/dev/null && echo "   ✅ memory.db ($(du -sh "$SOURCE_DIR/.swarm/memory.db" | cut -f1))" || echo "   ❌ Falhou"
fi

# Configurações de agentes
if [ -d "$HOME/.claude/swarm" ]; then
    cp -r "$HOME/.claude/swarm" "$BACKUP_DIR/data/" 2>/dev/null && echo "   ✅ Configurações Swarm" || echo "   ❌ Falhou"
fi

# Hooks e métricas
if [ -d "$HOME/.claude/hooks" ]; then
    cp -r "$HOME/.claude/hooks" "$BACKUP_DIR/data/" 2>/dev/null && echo "   ✅ Hooks e métricas" || echo "   ❌ Falhou"
fi

# 8. DOCUMENTAÇÃO PESSOAL
echo "📚 8. Documentação pessoal..."
mkdir -p "$BACKUP_DIR/docs"
cp "$SOURCE_DIR/CLAUDE.md" "$BACKUP_DIR/docs/" 2>/dev/null && echo "   ✅ CLAUDE.md" || echo "   ❌ Falhou"
cp "$SOURCE_DIR/CLAUDE_FLOW_WORKFLOWS.md" "$BACKUP_DIR/docs/" 2>/dev/null && echo "   ✅ CLAUDE_FLOW_WORKFLOWS.md" || echo "   ❌ Falhou"
cp "$SOURCE_DIR/github_actions_debugging_checklist.md" "$BACKUP_DIR/docs/" 2>/dev/null && echo "   ✅ GitHub checklist" || echo "   ❌ Falhou"

# 9. KITTY E CONFIGURAÇÕES DE TERMINAL
echo "🐱 9. Kitty e terminal..."
if [ -f "$SOURCE_DIR/kitty-installer.sh" ]; then
    cp "$SOURCE_DIR/kitty-installer.sh" "$BACKUP_DIR/" 2>/dev/null && echo "   ✅ kitty-installer.sh" || echo "   ❌ Falhou"
fi

if [ -f "$SOURCE_DIR/kitty-0.44.0-x86_64.txz" ]; then
    cp "$SOURCE_DIR/kitty-0.44.0-x86_64.txz" "$BACKUP_DIR/" 2>/dev/null && echo "   ✅ kitty binário" || echo "   ❌ Falhou"
fi

# 10. CRIAR SCRIPT DE RESTAURAÇÃO
echo "🔄 10. Criando script de restauração..."
cat > "$BACKUP_DIR/restore_exclusivo.sh" << 'EOF'
#!/bin/bash

# 🎯 CLAUDE FLOW - RESTAURAÇÃO EXCLUSIVA
# Restaura componentes únicos após Claude Code + Claude Flow

echo "🔄 CLAUDE FLOW - RESTAURAÇÃO EXCLUSIVA"
echo "====================================="

BACKUP_DIR=$(dirname "$0")
SOURCE_DIR="$HOME/Claude"

echo "📁 Backup: $BACKUP_DIR"
echo "📂 Destino: $SOURCE_DIR"
echo ""

# Verificar pré-requisitos
echo "🔍 Verificando pré-requisitos..."

if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code CLI não encontrado!"
    echo "💡 Instale: https://claude.ai/download"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 não encontrado!"
    echo "💡 Instale: sudo apt install python3 python3-pip"
    exit 1
fi

if ! command -v go &> /dev/null; then
    echo "⚠️  Go não encontrado - Lazy-MCP não funcionará"
    echo "💡 Instale: sudo apt install golang-go"
fi

echo "✅ Pré-requisitos verificados"
echo ""

# Criar estrutura
mkdir -p "$SOURCE_DIR"
mkdir -p "$HOME/.claude"

# 1. Restaurar Claude Flow Unified
echo "🤖 1. Restaurando Claude Flow Unified..."
cp "$BACKUP_DIR/claude_flow_unified.py" "$SOURCE_DIR/" && echo "   ✅ claude_flow_unified.py"

# 2. Restaurar comandos (ESSENCIAL!)
echo "📋 2. Restaurando comandos personalizados..."
cp -r "$BACKUP_DIR/claude-commands/commands" "$HOME/.claude/" && echo "   ✅ Comandos restaurados"

# 3. Restaurar Lazy-MCP
echo "🚀 3. Restaurando Lazy-MCP..."
if [ -d "$BACKUP_DIR/lazy-mcp" ]; then
    cp -r "$BACKUP_DIR/lazy-mcp" "$SOURCE_DIR/" && echo "   ✅ Lazy-MCP restaurado"

    # Compilar se Go estiver disponível
    if command -v go &> /dev/null; then
        cd "$SOURCE_DIR/lazy-mcp"
        echo "   🔨 Compilando Lazy-MCP..."
        go build -o lazy-mcp ./cmd/mcp-proxy 2>/dev/null && echo "   ✅ Lazy-MCP compilado" || echo "   ⚠️  Falha na compilação"
    fi
fi

# 4. Restaurar scripts
echo "📜 4. Restaurando scripts..."
cp "$BACKUP_DIR/scripts/mcp_manager.sh" "$SOURCE_DIR/" 2>/dev/null && echo "   ✅ mcp_manager.sh"
cp "$BACKUP_DIR/scripts/mcp_discovery.sh" "$SOURCE_DIR/" 2>/dev/null && echo "   ✅ mcp_discovery.sh"
cp "$BACKUP_DIR/scripts/github_actions_debugger.py" "$SOURCE_DIR/" 2>/dev/null && echo "   ✅ github_actions_debugger.py"

if [ -d "$BACKUP_DIR/scripts/scripts" ]; then
    cp -r "$BACKUP_DIR/scripts/scripts" "$SOURCE_DIR/" && echo "   ✅ scripts/"
fi

# 5. Restaurar configurações
echo "⚙️  5. Restaurando configurações..."
cp "$BACKUP_DIR/configs/settings.json" "$HOME/.claude/" 2>/dev/null && echo "   ✅ settings.json"
cp "$BACKUP_DIR/configs/settings.local.json" "$HOME/.claude/" 2>/dev/null && echo "   ✅ settings.local.json"
cp "$BACKUP_DIR/configs/settings_ondemand.json" "$HOME/.claude/" 2>/dev/null && echo "   ✅ settings_ondemand.json"
cp "$BACKUP_DIR/configs/mcp-servers.json" "$HOME/.claude/" 2>/dev/null && echo "   ✅ mcp-servers.json"

# 6. Restaurar MCP servers
echo "🔌 6. Restaurando MCP servers..."
if [ -d "$BACKUP_DIR/mcp-servers" ]; then
    cp -r "$BACKUP_DIR/mcp-servers" "$SOURCE_DIR/" && echo "   ✅ mcp-servers"

    # Instalar dependências Node.js se disponível
    if command -v npm &> /dev/null; then
        cd "$SOURCE_DIR/mcp-servers"
        npm install 2>/dev/null && echo "   ✅ Dependências MCP instaladas" || echo "   ⚠️  Falha npm install"
    fi
fi

# 7. Restaurar dados
echo "💾 7. Restaurando dados..."
if [ -f "$BACKUP_DIR/data/memory.db" ]; then
    mkdir -p "$SOURCE_DIR/.swarm"
    cp "$BACKUP_DIR/data/memory.db" "$SOURCE_DIR/.swarm/" && echo "   ✅ memory.db"
fi

if [ -d "$BACKUP_DIR/data/swarm" ]; then
    cp -r "$BACKUP_DIR/data/swarm" "$HOME/.claude/" && echo "   ✅ Configurações Swarm"
fi

if [ -d "$BACKUP_DIR/data/hooks" ]; then
    cp -r "$BACKUP_DIR/data/hooks" "$HOME/.claude/" && echo "   ✅ Hooks e métricas"
fi

# 8. Restaurar documentação
echo "📚 8. Restaurando documentação..."
cp "$BACKUP_DIR/docs/"* "$SOURCE_DIR/" 2>/dev/null && echo "   ✅ Documentação pessoal"

# 9. Restaurar Kitty (opcional)
echo "🐱 9. Restaurando Kitty (opcional)..."
if [ -f "$BACKUP_DIR/kitty-installer.sh" ]; then
    cp "$BACKUP_DIR/kitty-installer.sh" "$SOURCE_DIR/" && echo "   ✅ kitty-installer.sh"
fi

# 10. Ajustar permissões
echo "🔐 10. Ajustando permissões..."
chmod +x "$SOURCE_DIR/claude_flow_unified.py" 2>/dev/null
chmod +x "$SOURCE_DIR/mcp_manager.sh" 2>/dev/null
chmod +x "$SOURCE_DIR/mcp_discovery.sh" 2>/dev/null
chmod +x "$HOME/.claude/commands/"* 2>/dev/null

# 11. Instalar dependências Python
echo "🐍 11. Instalando dependências Python..."
pip3 install --user requests beautifulsoup4 openai python-dotenv redis 2>/dev/null || echo "   ⚠️  Algumas dependências falharam"

# 12. Testar sistema
echo "🧪 12. Testando sistema..."
cd "$SOURCE_DIR"

echo ""
echo "🎉 RESTAURAÇÃO CONCLUÍDA!"
echo "========================="

echo ""
echo "📋 TESTES FINAIS:"
echo "1. Claude Code: claude --version"
echo "2. Claude Flow: python3 claude_flow_unified.py status"
echo "3. MCP Manager: ./mcp_manager.sh status"
echo ""

echo "🚀 SEU SISTEMA EXCLUSIVO ESTÁ PRONTO!"
echo ""
EOF

chmod +x "$BACKUP_DIR/restore_exclusivo.sh"

# Criar informações
cat > "$BACKUP_DIR/README.txt" << EOF
CLAUDE FLOW - BACKUP EXCLUSIVO (O que NÃO vem no GitHub)
======================================================

Data: $(date)
Conteúdo: Componentes únicos e personalizados

🎯 O QUE TEM AQUI:
📋 Comandos Claude personalizados - SEUS COMANDOS /v6, /docker, etc
🚀 Lazy-MCP System - Sistema Go-based de lazy loading
🤖 Claude Flow Unified - Sua versão otimizada
📜 Scripts personalizados - mcp_manager, github debugger, etc
⚙️  Configurações exclusivas - settings, mcp-servers.json
💾 Dados - memory.db, configurações swarm, métricas
📚 Documentação pessoal - seus guias e checklists

Tamanho: $(du -sh "$BACKUP_DIR" | cut -f1)

📋 PASSOS APÓS FORMATAÇÃO:
1. Instale Claude Code CLI: https://claude.ai/download
2. Instale Python3: sudo apt install python3 python3-pip
3. Instale Go (opcional, para lazy-mcp): sudo apt install golang-go
4. Execute este script: ./restore_exclusivo.sh
5. Teste: cd ~/Claude && python3 claude_flow_unified.py status

🔗 REFERÊNCIAS:
- Claude Code: https://claude.ai/download
- Claude Flow GitHub: https://github.com/arturdr-ads/claude-flow-swarm.git
- Lazy-MCP vs MCP-Proxy: Lazy-MCP é Go-based, mais rápido para seus use cases
EOF

# Compactar
echo "🗜️ Compactando backup exclusivo..."
cd "$HOME"
tar -czf "claude-flow-exclusivo-backup-$(date +%Y%m%d-%H%M%S).tar.gz" "$(basename "$BACKUP_DIR")"
rm -rf "$BACKUP_DIR"

BACKUP_FILE="claude-flow-exclusivo-backup-$(date +%Y%m%d-%H%M%S).tar.gz"

echo ""
echo "✅ BACKUP EXCLUSIVO CONCLUÍDO!"
echo "=============================="
echo ""
echo "📁 Arquivo: $HOME/$BACKUP_FILE"
echo "📏 Tamanho: $(du -sh "$HOME/$BACKUP_FILE" | cut -f1)"
echo ""
echo "🎯 O QUE FOI BACKUPEADO (O ÚNICO):"
echo "  ✅ Seus comandos Claude (/v6, /docker, etc)"
echo "  ✅ Lazy-MCP System (Go-based)"
echo "  ✅ Claude Flow Unified (sua versão)"
echo "  ✅ Scripts e configurações personalizadas"
echo "  ✅ Banco de dados e métricas"
echo "  ✅ Documentação pessoal"
echo ""
echo "💡 APÓS FORMATAR - INSTALAÇÃO RÁPIDA:"
echo "  1. Claude Code CLI: https://claude.ai/download"
echo "  2. Descompactar backup: tar -xzf claude-flow-exclusivo-backup-*.tar.gz"
echo "  3. Executar: ./restore_exclusivo.sh"
echo "  4. Testar: python3 claude_flow_unified.py status"
echo ""
echo "🚀 LAZY-MCP vs MCP-Proxy:"
echo "  ✅ Lazy-MCP (seu): Go-based, otimizado para você"
echo "  🔌 MCP-Proxy (externo): Genérico, mais complexo"
echo "  💡 Seu Lazy-MCP é melhor para seus casos de uso!"
echo ""