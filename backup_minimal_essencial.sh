#!/bin/bash

# 🎯 CLAUDE FLOW - BACKUP MÍNIMO ESSENCIAL
# Apenas o necessário para restaurar após formatar + Claude Code CLI

echo "🎯 CLAUDE FLOW - BACKUP MÍNIMO ESSENCIAL"
echo "====================================="

BACKUP_DIR="$HOME/claude-flow-minimal-backup-$(date +%Y%m%d-%H%M%S)"
SOURCE_DIR="$HOME/Claude"

echo "📁 Backup: $BACKUP_DIR"
echo "📂 Origem: $SOURCE_DIR"
echo ""

# Criar diretório de backup
mkdir -p "$BACKUP_DIR"

echo "📦 Fazendo backup dos componentes ESSENCIAIS..."
echo ""

# 1. ARQUIVO PRINCIPAL DO SISTEMA
echo "1️⃣  Sistema principal..."
cp "$SOURCE_DIR/claude_flow_unified.py" "$BACKUP_DIR/" 2>/dev/null && echo "✅ claude_flow_unified.py" || echo "❌ Falhou"

# 2. GERENCIADOR MCP
echo "2️⃣  Gerenciador MCP..."
cp "$SOURCE_DIR/mcp_manager.sh" "$BACKUP_DIR/" 2>/dev/null && echo "✅ mcp_manager.sh" || echo "❌ Falhou"

# 3. COMANDOS PERSONALIZADOS (ESSENCIAL!)
echo "3️⃣  Comandos personalizados..."
mkdir -p "$BACKUP_DIR/claude-commands"
cp -r "$HOME/.claude/commands" "$BACKUP_DIR/claude-commands/" 2>/dev/null && echo "✅ comandos Claude" || echo "❌ Falhou"

# 4. CONFIGURAÇÕES ESSENCIAIS
echo "4️⃣  Configurações essenciais..."
mkdir -p "$BACKUP_DIR/configs"
cp "$HOME/.claude/settings.json" "$BACKUP_DIR/configs/" 2>/dev/null && echo "✅ settings.json" || echo "❌ Falhou"

# 5. BANCO DE DADOS (SE TIVER DADOS IMPORTANTES)
echo "5️⃣  Banco de dados (se existir)..."
if [ -f "$SOURCE_DIR/.swarm/memory.db" ]; then
    mkdir -p "$BACKUP_DIR/swarm-data"
    cp "$SOURCE_DIR/.swarm/memory.db" "$BACKUP_DIR/swarm-data/" 2>/dev/null && echo "✅ memory.db" || echo "❌ Falhou"
    echo "   📊 Tamanho: $(du -sh "$SOURCE_DIR/.swarm/memory.db" | cut -f1)"
else
    echo "   ⚠️  Banco de dados não encontrado - será criado novo"
fi

# 6. SCRIPTS ADICIONAIS IMPORTANTES
echo "6️⃣  Scripts MCP..."
if [ -d "$SOURCE_DIR/lazy-mcp" ]; then
    cp -r "$SOURCE_DIR/lazy-mcp" "$BACKUP_DIR/" 2>/dev/null && echo "✅ lazy-mcp" || echo "❌ Falhou"
fi

if [ -f "$SOURCE_DIR/mcp_catalog.json" ]; then
    cp "$SOURCE_DIR/mcp_catalog.json" "$BACKUP_DIR/" 2>/dev/null && echo "✅ mcp_catalog.json" || echo "❌ Falhou"
fi

# 7. CRIAR SCRIPT DE RESTAURAÇÃO
echo "7️⃣  Criando script de restauração..."
cat > "$BACKUP_DIR/restore_minimal.sh" << 'EOF'
#!/bin/bash

# 🎯 CLAUDE FLOW - RESTAURAÇÃO MÍNIMA (Pós-Formatação)
# Assume que Claude Code CLI já está instalado

echo "🔄 CLAUDE FLOW - RESTAURAÇÃO MÍNIMA"
echo "=================================="

BACKUP_DIR=$(dirname "$0")
SOURCE_DIR="$HOME/Claude"

echo "📁 Backup: $BACKUP_DIR"
echo "📂 Destino: $SOURCE_DIR"
echo ""

# Verificar se Claude Code CLI está instalado
if ! command -v claude &> /dev/null; then
    echo "❌ Claude Code CLI não encontrado!"
    echo "💡 Instale primeiro: https://claude.ai/download"
    echo ""
    echo "📋 Como instalar Claude Code CLI:"
    echo "1. Acesse https://claude.ai/download"
    echo "2. Faça download do CLI"
    echo "3. Siga instruções de instalação"
    echo "4. Execute: claude --version"
    exit 1
fi

echo "✅ Claude Code CLI encontrado"
echo ""

# Criar estrutura de diretórios
mkdir -p "$SOURCE_DIR"
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.swarm"

# 1. Restaurar arquivos principais
echo "📦 1. Restaurando sistema principal..."
cp "$BACKUP_DIR/claude_flow_unified.py" "$SOURCE_DIR/" 2>/dev/null && echo "✅ claude_flow_unified.py"

# 2. Restaurar gerenciador MCP
echo "🔧 2. Restaurando gerenciador MCP..."
cp "$BACKUP_DIR/mcp_manager.sh" "$SOURCE_DIR/" 2>/dev/null && echo "✅ mcp_manager.sh"

# 3. Restaurar comandos (IMPORTANTE!)
echo "📋 3. Restaurando comandos personalizados..."
if [ -d "$BACKUP_DIR/claude-commands/commands" ]; then
    cp -r "$BACKUP_DIR/claude-commands/commands" "$HOME/.claude/" 2>/dev/null && echo "✅ comandos restaurados"
fi

# 4. Restaurar configurações
echo "⚙️  4. Restaurando configurações..."
cp "$BACKUP_DIR/configs/settings.json" "$HOME/.claude/" 2>/dev/null && echo "✅ settings.json"

# 5. Restaurar banco de dados (se existir)
echo "🗄️  5. Restaurando banco de dados (se existir)..."
if [ -f "$BACKUP_DIR/swarm-data/memory.db" ]; then
    mkdir -p "$SOURCE_DIR/.swarm"
    cp "$BACKUP_DIR/swarm-data/memory.db" "$SOURCE_DIR/.swarm/" 2>/dev/null && echo "✅ memory.db restaurado"
else
    echo "   📝 Banco de dados será criado novo"
fi

# 6. Restaurar scripts MCP
echo "🔌 6. Restaurando scripts MCP..."
cp "$BACKUP_DIR/lazy-mcp" "$SOURCE_DIR/" 2>/dev/null 2>&1 || echo "   ⚠️  lazy-mcp não encontrado"
cp "$BACKUP_DIR/mcp_catalog.json" "$SOURCE_DIR/" 2>/dev/null 2>&1 || echo "   ⚠️  mcp_catalog.json não encontrado"

# 7. Ajustar permissões
echo "🔐 7. Ajustando permissões..."
chmod +x "$SOURCE_DIR/claude_flow_unified.py" 2>/dev/null
chmod +x "$SOURCE_DIR/mcp_manager.sh" 2>/dev/null
chmod +x "$HOME/.claude/commands/"* 2>/dev/null

# 8. Verificar instalação do Python
echo "🐍 8. Verificando Python..."
if command -v python3 &> /dev/null; then
    echo "✅ Python3 encontrado"
else
    echo "❌ Python3 não encontrado - instalando..."
    sudo apt update && sudo apt install -y python3 python3-pip
fi

# 9. Instalar dependências Python
echo "📦 9. Instalando dependências..."
pip3 install --user requests beautifulsoup4 openai python-dotenv redis sqlite3 2>/dev/null || echo "   ⚠️  Algumas dependências podem falhar"

# 10. Clonar repositório (para manter histórico)
echo "📥 10. Clonando repositório GitHub..."
cd "$SOURCE_DIR"
if [ ! -d ".git" ]; then
    git clone https://github.com/arturdr-ads/claude-flow-swarm.git temp-repo 2>/dev/null
    if [ -d "temp-repo" ]; then
        cp -r temp-repo/.git .
        rm -rf temp-repo
        echo "✅ Repositório clonado"
    else
        echo "   ⚠️  Falha ao clonar repositório - sem internet?"
    fi
fi

echo ""
echo "🎉 RESTAURAÇÃO CONCLUÍDA!"
echo "========================"
echo ""
echo "📋 TESTES RÁPIDOS:"
echo "1. Testar Python: cd $SOURCE_DIR && python3 claude_flow_unified.py status"
echo "2. Testar MCP: cd $SOURCE_DIR && ./mcp_manager.sh status"
echo "3. Testar Claude Code: claude --version"
echo ""
echo "🚀 SEU CLAUDE FLOW ESTÁ PRONTO!"
echo ""
EOF

chmod +x "$BACKUP_DIR/restore_minimal.sh"

# 8. CRIAR INFORMAÇÕES DO BACKUP
cat > "$BACKUP_DIR/README.txt" << EOF
CLAUDE FLOW - BACKUP MÍNIMO ESSENCIAL
==================================

Data: $(date)
Tipo: Backup mínimo (apenas essencial)

Conteúdo:
📦 claude_flow_unified.py - Sistema principal
🔧 mcp_manager.sh - Gerenciador MCP
📋 commands/ - Seus comandos personalizados
⚙️  settings.json - Configurações
🗄️  memory.db (opcional) - Banco de dados

Tamanho: $(du -sh "$BACKUP_DIR" | cut -f1)

Como restaurar:
1. Instale Claude Code CLI primeiro
2. Execute: ./restore_minimal.sh
3. Teste o sistema

Claude Code CLI: https://claude.ai/download
EOF

# 9. Compactar
echo "🗜️  Compactando backup..."
cd "$HOME"
tar -czf "claude-flow-minimal-backup-$(date +%Y%m%d-%H%M%S).tar.gz" "$(basename "$BACKUP_DIR")"
rm -rf "$BACKUP_DIR"

BACKUP_FILE="claude-flow-minimal-backup-$(date +%Y%m%d-%H%M%S).tar.gz"

echo ""
echo "✅ BACKUP MÍNIMO CONCLUÍDO!"
echo "==========================="
echo ""
echo "📁 Arquivo: $HOME/$BACKUP_FILE"
echo "📏 Tamanho: $(du -sh "$HOME/$BACKUP_FILE" | cut -f1)"
echo ""
echo "📋 O QUE FOI BACKUPADO:"
echo "  ✅ Sistema principal (claude_flow_unified.py)"
echo "  ✅ Gerenciador MCP (mcp_manager.sh)"
echo "  ✅ Seus comandos personalizados"
echo "  ✅ Configurações essenciais"
echo "  ✅ Banco de dados (se existente)"
echo ""
echo "💡 APÓS FORMATAR - PASSOS:"
echo "  1. Instale Claude Code CLI: https://claude.ai/download"
echo "  2. Copie este backup para o novo sistema"
echo "  3. Descompacte: tar -xzf claude-flow-minimal-backup-*.tar.gz"
echo "  4. Execute: ./restore_minimal.sh"
echo "  5. Teste: cd ~/Claude && python3 claude_flow_unified.py status"
echo ""