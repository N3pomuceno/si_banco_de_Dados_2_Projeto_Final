-- View 1 - partida com o nome dos jogadores, nome das equipes e a vencedor e a data 
CREATE OR REPLACE VIEW view_partidas_jogadores_equipes AS
SELECT par.id_partida, par.data_partida, jog.nome_usuario AS nome_jogador, eq1.nome AS nome_equipe1, eq2.nome AS nome_equipe2, par.vencedor as vencedor 
FROM tbl_partida par
INNER JOIN tbl_partida_jogador parjog ON parjog.id_partida = par.id_partida
INNER JOIN tbl_jogador jog ON jog.cpf = parjog.cpf
INNER JOIN tbl_equipe eq1 ON eq1.id_equipe = par.id_equipe1
INNER JOIN tbl_equipe eq2 ON eq2.id_equipe = par.id_equipe2;

-- View 2 - Todas edições de todos campeonatos de todos os jogos, com as datas de ínicio e fim
CREATE OR REPLACE VIEW view_edicoes_campeonatos_jogos AS
SELECT edi.id_edicao, cam.nome AS nome_campeonato, jog.nome AS nome_jogo, ed.data_inicio, ed.data_fim
FROM tbl_edicao edi
INNER JOIN tbl_campeonato cam ON cam.id_campeonato = ed.campeonato
INNER JOIN tbl_jogo_comp jog ON jog.id_jogo = cam.id_jogo;