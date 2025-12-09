#!/usr/bin/env bash
set -e

if [ $# -lt 1 ]; then
  echo "Uso: $0 <nome_time_adversario> [seed]"
  exit 1
fi

OPPONENT_RAW="$1"
SEED="${2:-1}"

# Caminho do seu time (Pimentão-Verde)
MY_TEAM_PATH="$HOME/Desktop/simulation2d/simulationRep/starter-stack/Agent/src"
MY_TEAM_NAME="PimentaoVerde"

# Caminho base dos times da competição (ajuste se necessário)
OPP_BASE="$HOME/Downloads/bins_day1/bins_Day1"

# Pasta de saída dos logs
LOG_BASE="$HOME/Desktop/simulation2d/matches"
MATCH_DIR="$LOG_BASE/${OPPONENT_RAW}_seed${SEED}"
mkdir -p "$MATCH_DIR"

echo "[INFO] Iniciando partida: ${MY_TEAM_NAME} x ${OPPONENT_RAW} (seed=${SEED})"
echo "[INFO] Logs serão salvos em: ${MATCH_DIR}"

# Ajusta libs do HELIOS/rcsc do seu time
export LD_LIBRARY_PATH="$HOME/Desktop/simulation2d/simulationRep/starter-stack/Agent/Lib/lib:$HOME/Desktop/simulation2d/simulationRep/starter-stack/Lib/rcsc/.libs:$LD_LIBRARY_PATH"

# Garante que não há servidor/monitor velho
pkill rcssserver 2>/dev/null || true
pkill rcssmonitor 2>/dev/null || true

# Sobe o servidor em modo auto
rcssserver \
  server::auto_mode=1 \
  server::kick_off_wait=10 \
  player::random_seed=${SEED} \
  > "${MATCH_DIR}/server.log" 2>&1 &

SERVER_PID=$!

sleep 2

###########################
# Sobe o Pimentão-Verde  #
###########################
cd "$MY_TEAM_PATH"
./start.sh -t "$MY_TEAM_NAME" &

###########################
# Sobe o time adversário #
###########################

# Tenta encontrar o diretório do adversário ignorando maiúsculas/minúsculas
TEAM_DIR=$(find "$OPP_BASE" -maxdepth 1 -type d -iname "$OPPONENT_RAW" | head -n 1 || true)

if [ -z "$TEAM_DIR" ]; then
  echo "[ERRO] Não encontrei diretório para o adversário '$OPPONENT_RAW' dentro de $OPP_BASE"
  kill "$SERVER_PID"
  exit 1
fi

TEAM_BIN="$TEAM_DIR/bin"

if [ ! -d "$TEAM_BIN" ]; then
  echo "[ERRO] A pasta bin não existe em $TEAM_DIR"
  kill "$SERVER_PID"
  exit 1
fi

if [ ! -f "$TEAM_BIN/start.sh" ]; then
  echo "[ERRO] Não encontrei start.sh em $TEAM_BIN"
  echo "[DICA] Rode: ls \"$TEAM_BIN\" e veja qual binário usar, então ajuste este script."
  kill "$SERVER_PID"
  exit 1
fi

echo "[INFO] Time adversário encontrado em: $TEAM_DIR"
echo "[INFO] Usando $TEAM_BIN/start.sh"

# Muitas equipes empacotam as próprias libs em bin, então adicionamos ao LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$TEAM_BIN:$LD_LIBRARY_PATH"

(
  cd "$TEAM_BIN"
  chmod +x start.sh
  ./start.sh &
)

###########################
# Espera o final do jogo #
###########################

wait "$SERVER_PID" || true

# Copia o último .rcg
RCG_FILE=$(ls -t "$HOME/.rcssserver/log"/*.rcg 2>/dev/null | head -n 1 || true)

if [ -f "$RCG_FILE" ]; then
  cp "$RCG_FILE" "$MATCH_DIR/"
  echo "[INFO] Copiado log: $(basename "$RCG_FILE") para $MATCH_DIR"
else
  echo "[WARN] Nenhum arquivo .rcg encontrado em ~/.rcssserver/log"
fi

echo "[INFO] Partida finalizada."
