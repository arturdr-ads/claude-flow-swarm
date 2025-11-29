#!/bin/bash

# 🚀 CLAUDE FLOW UNIFIED - SCRIPT DE BACKUP COMPLETO
# Backup completo antes da formatação do PC

echo "🔥 CLAUDE FLOW UNIFIED - BACKUP COMPLETO"
echo "======================================="

# Configurações
BACKUP_DIR="$HOME/claude-flow-backup-$(date +%Y%m%d-%H%M%S)"
SOURCE_DIR="$HOME/Claude"
GITHUB_REPO="https://github.com/arturdr-ads/claude-flow-swarm.git"

echo "📁 Diretório de backup: $BACKUP_DIR"
echo "📂 Diretório fonte: $SOURCE_DIR"
echo ""

# Criar diretório de backup
mkdir -p "$BACKUP_DIR"

echo "🔍 ANALISando estrutura para backup..."
echo ""

# 1. BACKUP DOS ARQUIVOS PRINCIPAIS DO PROJETO
echo "📦 1. Fazendo backup dos arquivos principais..."
mkdir -p "$BACKUP_DIR/project-core"

# Arquivos essenciais do projeto
cp "$SOURCE_DIR/claude_flow_unified.py" "$BACKUP_DIR/project-core/" 2>/dev/null || echo "⚠️  claude_flow_unified.py não encontrado"
cp "$SOURCE_DIR/CLAUDE.md" "$BACKUP_DIR/project-core/" 2>/dev/null || echo "⚠️  CLAUDE.md não encontrado"
cp "$SOURCE_DIR/README.md" "$BACKUP_DIR/project-core/" 2>/dev/null || echo "⚠️  README.md não encontrado"
cp "$SOURCE_DIR/mcp_manager.sh" "$BACKUP_DIR/project-core/" 2>/dev/null || echo "⚠️  mcp_manager.sh não encontrado"
cp "$SOURCE_DIR/mcp_catalog.json" "$BACKUP_DIR/project-core/" 2>/dev/null || echo "⚠️  mcp_catalog.json não encontrado"

# 2. BACKUP DOS COMANDOS PERSONALIZADOS
echo "📋 2. Fazendo backup dos comandos personalizados..."
mkdir -p "$BACKUP_DIR/claude-commands"
cp -r "$HOME/.claude/commands" "$BACKUP_DIR/claude-commands/" 2>/dev/null || echo "⚠️  Comandos Claude não encontrados"

# 3. BACKUP DAS CONFIGURAÇÕES
echo "⚙️  3. Fazendo backup das configurações..."
mkdir -p "$BACKUP_DIR/configs"

# Configurações do Claude
cp "$HOME/.claude/settings.json" "$BACKUP_DIR/configs/" 2>/dev/null || echo "⚠️  settings.json não encontrado"

# Configurações MCP se existirem
if [ -d "$HOME/mcp-servers" ]; then
    cp -r "$HOME/mcp-servers" "$BACKUP_DIR/configs/" 2>/dev/null
fi

# 4. BACKUP DO BANCO DE DADOS SWARM
echo "🗄️  4. Fazendo backup do banco de dados Swarm..."
mkdir -p "$BACKUP_DIR/swarm-data"

if [ -d "$HOME/.swarm" ]; then
    cp -r "$HOME/.swarm" "$BACKUP_DIR/swarm-data/" 2>/dev/null
    echo "✅ Banco de dados Swarm copiado"
else
    echo "⚠️  Diretório .swarm não encontrado"
fi

if [ -f "$SOURCE_DIR/.swarm/memory.db" ]; then
    cp "$SOURCE_DIR/.swarm/memory.db" "$BACKUP_DIR/swarm-data/" 2>/dev/null
    echo "✅ Banco de dados do projeto copiado"
fi

# 5. BACKUP DOS SCRIPTS ADICIONAIS
echo "📜 5. Fazendo backup dos scripts adicionais..."
mkdir -p "$BACKUP_DIR/scripts"

if [ -d "$SOURCE_DIR/scripts" ]; then
    cp -r "$SOURCE_DIR/scripts" "$BACKUP_DIR/scripts/" 2>/dev/null
fi

if [ -d "$SOURCE_DIR/lazy-mcp" ]; then
    cp -r "$SOURCE_DIR/lazy-mcp" "$BACKUP_DIR/scripts/" 2>/dev/null
fi

# 6. BACKUP DOS DOCUMENTOS IMPORTANTES
echo "📚 6. Fazendo backup dos documentos..."
mkdir -p "$BACKUP_DIR/docs"

cp "$SOURCE_DIR/CLAUDE_FLOW_WORKFLOWS.md" "$BACKUP_DIR/docs/" 2>/dev/null
cp "$SOURCE_DIR/CLAUDE_FLOW_WORKFLOW_GUIDE.md" "$BACKUP_DIR/docs/" 2>/dev/null
cp "$SOURCE_DIR/TERMINAL_RESEARCH_2025.md" "$BACKUP_DIR/docs/" 2>/dev/null
cp "$SOURCE_DIR/HONEST_TERMINAL_ANALYSIS.md" "$BACKUP_DIR/docs/" 2>/dev/null

# 7. CRIAR SCRIPT DE RESTAURAÇÃO
echo "🔄 7. Criando script de restauração..."
cat > "$BACKUP_DIR/restore.sh" << 'EOF'
#!/bin/bash

# 🚀 CLAUDE FLOW UNIFIED - SCRIPT DE RESTAURAÇÃO
# Restaura o backup após formatação

echo "🔄 CLAUDE FLOW UNIFIED - RESTAURAÇÃO"
echo "=================================="

BACKUP_DIR=$(dirname "$0")
SOURCE_DIR="$HOME/Claude"

echo "📁 Backup: $BACKUP_DIR"
echo "📂 Destino: $SOURCE_DIR"
echo ""

# Criar estrutura de diretórios
mkdir -p "$SOURCE_DIR"
mkdir -p "$HOME/.claude"

# 1. Restaurar arquivos principais
echo "📦 1. Restaurando arquivos principais..."
cp "$BACKUP_DIR/project-core/"* "$SOURCE_DIR/" 2>/dev/null

# 2. Restaurar comandos
echo "📋 2. Restaurando comandos personalizados..."
if [ -d "$BACKUP_DIR/claude-commands/commands" ]; then
    cp -r "$BACKUP_DIR/claude-commands/commands" "$HOME/.claude/"
fi

# 3. Restaurar configurações
echo "⚙️  3. Restaurando configurações..."
cp "$BACKUP_DIR/configs/settings.json" "$HOME/.claude/" 2>/dev/null

if [ -d "$BACKUP_DIR/configs/mcp-servers" ]; then
    cp -r "$BACKUP_DIR/configs/mcp-servers" "$HOME/"
fi

# 4. Restaurar banco de dados
echo "🗄️  4. Restaurando banco de dados..."
if [ -d "$BACKUP_DIR/swarm-data/.swarm" ]; then
    cp -r "$BACKUP_DIR/swarm-data/.swarm" "$HOME/"
fi

if [ -d "$BACKUP_DIR/swarm-data/swarm" ]; then
    mkdir -p "$SOURCE_DIR/.swarm"
    cp -r "$BACKUP_DIR/swarm-data/swarm"/* "$SOURCE_DIR/.swarm/" 2>/dev/null
fi

# 5. Restaurar scripts
echo "📜 5. Restaurando scripts..."
if [ -d "$BACKUP_DIR/scripts/scripts" ]; then
    cp -r "$BACKUP_DIR/scripts/scripts" "$SOURCE_DIR/"
fi

if [ -d "$BACKUP_DIR/scripts/lazy-mcp" ]; then
    cp -r "$BACKUP_DIR/scripts/lazy-mcp" "$SOURCE_DIR/"
fi

# 6. Restaurar documentos
echo "📚 6. Restaurando documentos..."
cp "$BACKUP_DIR/docs/"* "$SOURCE_DIR/" 2>/dev/null

# 7. Ajustar permissões
echo "🔐 7. Ajustando permissões..."
chmod +x "$SOURCE_DIR/claude_flow_unified.py" 2>/dev/null
chmod +x "$SOURCE_DIR/mcp_manager.sh" 2>/dev/null
chmod +x "$HOME/.claude/commands/"* 2>/dev/null

# 8. Clonar repositório Git
echo "📥 8. Clonando repositório GitHub..."
cd "$SOURCE_DIR"
if [ ! -d ".git" ]; then
    git clone https://github.com/arturdr-ads/claude-flow-swarm.git temp-repo
    cp -r temp-repo/.git .
    rm -rf temp-repo
fi

echo ""
echo "✅ RESTAURAÇÃO CONCLUÍDA!"
echo ""
echo "📋 PRÓXIMOS PASSOS:"
echo "1. cd $SOURCE_DIR"
echo "2. Testar: python3 claude_flow_unified.py status"
echo "3. Testar: ./mcp_manager.sh status"
echo ""
EOF

chmod +x "$BACKUP_DIR/restore.sh"

# 8. CRIAR INFO DO BACKUP
echo "📋 8. Criando informações do backup..."
cat > "$BACKUP_DIR/README.txt" << EOF
CLAUDE FLOW UNIFIED - BACKUP COMPLETO
====================================

Data do backup: $(date)
Diretório original: $SOURCE_DIR
Repositório GitHub: $GITHUB_REPO

Conteúdo do backup:
📦 project-core/ - Arquivos principais do sistema
📋 claude-commands/ - Comandos personalizados (.claude/commands)
⚙️  configs/ - Configurações e MCPs
🗄️  swarm-data/ - Banco de dados SQLite
📜 scripts/ - Scripts adicionais
📚 docs/ - Documentação importante

Como restaurar:
1. Após formatar, copie este backup para o HOME
2. Execute: ./restore.sh
3. Teste o sistema com os comandos mencionados

Tamanho total: $(du -sh "$BACKUP_DIR" | cut -f1)
EOF

# 9. COMPACTAR BACKUP
echo "🗜️  9. Compactando backup..."
cd "$HOME"
tar -czf "claude-flow-backup-$(date +%Y%m%d-%H%M%S).tar.gz" "$(basename "$BACKUP_DIR")"

# Limpar diretório não compactado
rm -rf "$BACKUP_DIR"

BACKUP_FILE="claude-flow-backup-$(date +%Y%m%d-%H%M%S).tar.gz"

echo ""
echo "✅ BACKUP CONCLUÍDO COM SUCESSO!"
echo "================================"
echo ""
echo "📁 Arquivo de backup: $HOME/$BACKUP_FILE"
echo "📏 Tamanho: $(du -sh "$HOME/$BACKUP_FILE" | cut -f1)"
echo ""
echo "📋 O QUE FOI BACKUPADO:"
echo "  ✅ Arquivos principais do projeto"
echo "  ✅ Comandos personalizados"
echo "  ✅ Configurações do Claude"
echo "  ✅ Banco de dados Swarm (se existente)"
echo "  ✅ Scripts MCP adicionais"
echo "  ✅ Documentação importante"
echo ""
echo "💡 INSTRUÇÕES APÓS FORMATAÇÃO:"
echo "  1. Copie o arquivo .tar.gz para o novo sistema"
echo "  2. Descompacte: tar -xzf claude-flow-backup-*.tar.gz"
echo "  3. Execute: ./restore.sh"
echo "  4. Teste: cd ~/Claude && python3 claude_flow_unified.py status"
echo ""
echo "🌐 REPOSITÓRIO GITHUB DISPONÍVEL:"
echo "  $GITHUB_REPO"
echo ""