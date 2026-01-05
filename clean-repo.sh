#!/bin/bash
# ============================================================
# Script: clean-repo.sh
# Compatibilidade: Linux e macOS
# Objetivo: limpar build/cache e sincronizar Git. Útil quando 
# forem realizadas alterações ao '.gitignore'.
# Feito com projetos mantidos pelo Android Studio em mente.
# ============================================================

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
RESET="\033[0m"

echo -e "${BLUE}==============================${RESET}"
echo -e "${BLUE}  LIMPEZA DE PROJETO ANDROID  ${RESET}"
echo -e "${BLUE}==============================${RESET}"
echo ""

echo -e "${YELLOW}ATENÇÃO:${RESET} Este script deve ser executado apenas se você ${RED}AINDA NÃO FEZ${RESET} alterações"
echo -e "nos arquivos do repositório clonado. Ele irá limpar caches e reavaliar o .gitignore,"
echo -e "podendo remover arquivos que não deveriam estar versionados."
echo ""
read -p "Deseja continuar? (s/N): " confirmacao

if [[ ! "$confirmacao" =~ ^[sS]$ ]]; then
    echo -e "${RED}Operação cancelada.${RESET}"
    exit 0
fi

echo ""
echo -e "${GREEN}Confirmado, iniciando limpeza...${RESET}"
echo ""

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "${RED}Este diretório não é um repositório Git.${RESET}"
    exit 1
fi

echo -e "${YELLOW}→ Limpando builds Gradle...${RESET}"
./gradlew clean >/dev/null 2>&1 && \
echo -e "${GREEN}Gradle clean concluído.${RESET}" || \
echo -e "${RED}Erro ao executar gradlew clean.${RESET}"

echo -e "${YELLOW}→ Removendo diretórios temporários e caches locais...${RESET}"

rm -rf \
    build/ \
    */build/ \
    .gradle/ \
    .cxx/ \
    .externalNativeBuild/ \
    captures/ \
    test-results/ \
    coverage/ \
    output.json \
    .navigation/ \
    *.log *.tmp *.temp *.bak *.old *.orig 2>/dev/null

rm -rf .idea/caches/ .idea/shelf/ .idea/workspace.xml .idea/tasks.xml \
       .idea/httpRequests .idea/navEditor.xml .idea/assetWizardSettings.xml 2>/dev/null

echo -e "${GREEN}Diretórios temporários removidos.${RESET}"

echo -e "${YELLOW}→ Atualizando rastreamento Git...${RESET}"
git rm -r --cached . >/dev/null 2>&1
git add . >/dev/null 2>&1

echo ""
read -p "Deseja criar um commit agora para registrar as alterações? (s/N): " commit_decisao

if [[ "$commit_decisao" =~ ^[sS]$ ]]; then
    echo ""
    read -p "Deseja inserir uma mensagem personalizada? (s/N): " msg_personalizada

    if [[ "$msg_personalizada" =~ ^[sS]$ ]]; then
        echo ""
        read -p "Digite sua mensagem de commit: " commit_msg
        [[ -z "$commit_msg" ]] && commit_msg="Limpeza: reavaliado .gitignore e removidos arquivos indevidos"
    else
        commit_msg="Limpeza: reavaliado .gitignore e removidos arquivos indevidos"
    fi

    echo -e "${YELLOW}→ Criando commit...${RESET}"
    git commit -m "$commit_msg" >/dev/null 2>&1
    echo -e "${GREEN}Commit criado com sucesso.${RESET}"
else
    echo -e "${YELLOW}Commit automático ignorado. Alterações estão apenas no stage.${RESET}"
fi

echo -e "${YELLOW}→ Limpando cache interno do Git...${RESET}"
git gc --prune=now >/dev/null 2>&1
git reflog expire --expire=now --all >/dev/null 2>&1
echo -e "${GREEN}✔ Cache interno do Git limpo.${RESET}"

echo ""
echo -e "${BLUE}======================${RESET}"
echo -e "${GREEN} Limpeza concluída!  ${RESET}"
echo -e "${BLUE}======================${RESET}"
git status -s

echo ""
echo -e "${YELLOW} Reabra o projeto no Android Studio e rode:${RESET}"
echo -e "   ${BLUE}File ▸ Sync Project with Gradle Files${RESET}"
echo ""
