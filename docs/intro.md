### 1.2. Criar alguns docs iniciais

```bash
cat > docs/intro.md << 'EOF'
# Introdução

Este projeto contém o time da categoria RoboCup Soccer Simulation 2D da equipe Rinobot.

- O servidor (RCSSServer) simula o jogo.
- Cada jogador é um processo que se conecta ao servidor.
- O monitor (RCSSMonitor ou SoccerWindow2) exibe o jogo em tempo real.
