#!/bin/bash
# Automated Agent Validation - Validação automatizada de agentes
# Fixed version for GitHub Actions environment - uses repository-relative paths

set -e

# Detect if running in GitHub Actions environment
if [ -n "$GITHUB_WORKSPACE" ]; then
    # Running in GitHub Actions
    REPO_ROOT="$GITHUB_WORKSPACE"
    CLAUDE_DIR="$REPO_ROOT/.claude"
    AGENTS_DIR="$REPO_ROOT/.claude/agents"
    LOG_FILE="$REPO_ROOT/logs/agent-validation-$(date +%Y%m%d-%H%M%S).log"
    VALIDATION_RESULTS_DIR="$REPO_ROOT/validation-results"
else
    # Running locally - use current repository
    REPO_ROOT="$(pwd)"
    CLAUDE_DIR="$REPO_ROOT/.claude"
    AGENTS_DIR="$REPO_ROOT/.claude/agents"
    LOG_FILE="$REPO_ROOT/logs/agent-validation-$(date +%Y%m%d-%H%M%S).log"
    VALIDATION_RESULTS_DIR="$REPO_ROOT/validation-results"
fi

# Criar diretórios necessários
mkdir -p "$CLAUDE_DIR/logs" "$VALIDATION_RESULTS_DIR"

# Função para logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# Função para validar agente individual
validate_agent() {
    local agent_name="$1"
    local agent_file="$AGENTS_DIR/$agent_name"

    log "🧪 Validando agente: $agent_name"

    if [[ ! -f "$agent_file" ]]; then
        log "❌ Agente não encontrado: $agent_file"
        return 1
    fi

    # Verificar sintaxe básica do arquivo
    if file "$agent_file" | grep -q "text"; then
        log "✅ Sintaxe válida: $agent_name"

        # Verificar se é um arquivo Markdown válido
        if head -n 5 "$agent_file" | grep -q "^#\|^---"; then
            log "✅ Formato Markdown válido: $agent_name"
            return 0
        else
            log "⚠️  Possível problema de formato: $agent_name"
            return 1
        fi
    else
        log "❌ Arquivo inválido: $agent_name"
        return 1
    fi
}

# Início da validação
log "🔍 INICIANDO VALIDAÇÃO AUTOMATIZADA DE AGENTES"
log "📁 Diretório do repositório: $REPO_ROOT"
log "📁 Diretório de agentes: $AGENTS_DIR"
log "🏠 Ambiente GitHub Actions: ${GITHUB_WORKSPACE:+Sim}"
log ""

# Contadores de resultados
TOTAL_AGENTS=0
VALID_AGENTS=0
INVALID_AGENTS=0

# Verificar se o diretório de agentes existe
if [[ ! -d "$AGENTS_DIR" ]]; then
    log "❌ Diretório de agentes não encontrado: $AGENTS_DIR"
    exit 1
fi

# Descobrir agentes automaticamente
log "🔍 Descobrindo agentes no diretório: $AGENTS_DIR"
DISCOVERED_AGENTS=()
for agent_file in "$AGENTS_DIR"/*.md; do
    if [[ -f "$agent_file" ]]; then
        agent_name=$(basename "$agent_file")
        DISCOVERED_AGENTS+=("$agent_name")
        log "📁 Agente descoberto: $agent_name"
    fi
done

# Validar agentes descobertos
if [[ ${#DISCOVERED_AGENTS[@]} -gt 0 ]]; then
    log "🤖 VALIDANDO AGENTES DESCOBERTOS (${#DISCOVERED_AGENTS[@]} agentes)"
    for agent in "${DISCOVERED_AGENTS[@]}"; do
        if validate_agent "$agent"; then
            ((VALID_AGENTS++))
        else
            ((INVALID_AGENTS++))
        fi
        ((TOTAL_AGENTS++))
    done
else
    log "⚠️ Nenhum agente encontrado no diretório: $AGENTS_DIR"
    exit 1
fi

log ""

# Resumo final
log ""
log "🎯 RESUMO DA VALIDAÇÃO"
log "📁 Repositório: $REPO_ROOT"
log "📊 Agentes validados: $TOTAL_AGENTS"
log "✅ Agentes válidos: $VALID_AGENTS"
log "❌ Agentes inválidos: $INVALID_AGENTS"

# Calcular taxa de sucesso
if [[ $TOTAL_AGENTS -gt 0 ]]; then
    SUCCESS_RATE=$((VALID_AGENTS * 100 / TOTAL_AGENTS))
    log "📈 Taxa de sucesso: $SUCCESS_RATE%"
else
    SUCCESS_RATE=0
    log "📈 Taxa de sucesso: 0% (nenhum agente encontrado)"
fi

log ""
log "📝 Log completo salvo em: $LOG_FILE"

if [[ $INVALID_AGENTS -eq 0 && $TOTAL_AGENTS -gt 0 ]]; then
    log "🎉 TODOS OS AGENTES SÃO VÁLIDOS!"
    exit 0
elif [[ $TOTAL_AGENTS -eq 0 ]]; then
    log "⚠️ NENHUM AGENTE ENCONTRADO - Verifique a estrutura do diretório"
    exit 1
else
    log "⚠️  ALGUNS AGENTES SÃO INVÁLIDOS. Verifique os logs."
    exit 1
fi
