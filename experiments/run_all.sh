#!/usr/bin/env bash
set -e

# Lista dos times encontrados em bins_Day1
OPPONENTS=(
  aeteam
  cyrus
  fra-united
  helios2024
  itandroids
  mars
  oxsy
  r2d2
  robocin
  yushan2024
)

# Quantas seeds por adversário (pode aumentar depois)
SEEDS=(1 2 3)

for opp in "${OPPONENTS[@]}"; do
  for seed in "${SEEDS[@]}"; do
    echo "====================================================="
    echo " Rodando ${opp} (seed=${seed})"
    echo "====================================================="
    ./run_match.sh "$opp" "$seed"
    # Pequena pausa opcional entre jogos
    sleep 2
  done
done

echo "[INFO] Todos os jogos foram executados."
