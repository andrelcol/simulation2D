### Arquitetura do Time Simulation 2D
A arquitetura é organizada em módulos principais:

Core do agente: ciclo de decisão, interpretação do estado do jogo, comunicação com o servidor.

Formações e estratégia global: posicionamento, sistemas táticos, regras ofensivas e defensivas.

Comportamentos individuais (behaviours):

ataque com bola;

movimentação sem bola;

cobertura defensiva;

passes e recepção;

finalização.

Goleiro: módulo com lógica específica para proteção da meta.

Bolas paradas: escanteios, faltas e saídas de bola.

Ferramentas internas: logging, análise de decisão, avaliação pós-jogo.

Detalhes por arquivo serão gerados automaticamente via Doxygen.
