#!/usr/bin/env bash
set -e

echo "[DOCS] Gerando documentação da API (Doxygen)..."
doxygen Doxyfile

echo "[DOCS] Atualizando docs/files_overview.md..."
DOC_FILE="docs/files_overview.md"

cat > "$DOC_FILE" << 'EOM'
# Visão geral dos arquivos

Esta página lista os arquivos principais do projeto.
A descrição detalhada de cada arquivo está na documentação gerada automaticamente (Doxygen) em `docs/api/html/index.html`.

| Arquivo | Descrição (resumida) |
|--------|------------------------|
EOM

# lista arquivos de código dentro de starter-stack
find starter-stack -type f \( -name "*.cpp" -o -name "*.hpp" -o -name "*.h" \) | sort | while read -r file; do
  echo "| \`$file\` | Ver comentário @file na documentação |" >> "$DOC_FILE"
done

echo "[DOCS] Documentação atualizada em docs/ e docs/api/"
