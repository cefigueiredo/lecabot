
# Lecabot - Interage com o chat da Twitch (já existe)
  - Vai receber comando `!play [spotify_song_link]`
    - Repassa para Jukebox o `spotify_song_link`
  - (?) Vai receber comando !play [nome da musica p buscar]
    - Repassa para Jukebox o nome da musica p buscar

# Jukebox - nome melhor a definir
  - Controla uma playlist adicionando musicas que vao tocar na live
  - Controla/Recebe status do player do Spotify
  - Recebe do Lecabot mensagem com url da musica p inserir na playlist
  - (?)Recebe do Lecabot mensagem com nome da musica p buscar e inserir na playlist

  * (?) Dependendo de viabilidade (Fremium - com pontos da live e/ou bits):
    - Usuarios consigam adicionar musica com prioridade (controlar ordem da playlist)
    - Usuarios consigam fazer hijack da playlist inteira por X minutos garantidos
      - X minutos garantidos significa:
        - por X minutos a playlist q ele escolher vai tocar
        - ninguem vai poder alterar prioridade durante os X minutos

# JukeboxWidget - widget no OBS que mostra a musica que está tocando atualmente
  - "Nome da musica - artista"
  - duracao da musica
  - @ do usuario do chat que adicionou a musica



## Organizacao:
```
- /lecalive
|
._ /apps
   |
   ._ /Lecabot
   |  |
   |  ._ Bot
   |  |
   |  ._ Jukebox
   |
   ._ /LecabotWeb
```













Legenda: 
  - interacao
  * interacao nao prioritaria
