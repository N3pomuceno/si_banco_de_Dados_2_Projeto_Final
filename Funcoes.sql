-- Função para obter o número total de vitórias de uma equipe em todas as edições
CREATE OR REPLACE FUNCTION obter_numero_vitorias_equipe(
  equipe_id integer
)
RETURNS integer AS $$
DECLARE
  numero_vitorias integer;
BEGIN
  SELECT COUNT(*) INTO numero_vitorias
  FROM tbl_partida
  WHERE vencedor = equipe_id;
  
  RETURN numero_vitorias;
END;
$$ LANGUAGE plpgsql;


-- Função para calcular a média de idade dos jogadores de uma equipe
CREATE OR REPLACE FUNCTION calcular_media_idade_equipe(
  equipe_id integer
)
RETURNS numeric AS $$
DECLARE
  media_idade numeric;
BEGIN
  SELECT AVG(EXTRACT(YEAR FROM AGE(data_nasc))) INTO media_idade
  FROM tbl_jogador_equipe je
  INNER JOIN tbl_empregado emp ON emp.cpf = je.cpf
  WHERE je.id_equipe = equipe_id;
  
  RETURN media_idade;
END;
$$ LANGUAGE plpgsql;


-- Função para obter a lista de jogadores de uma equipe com base na nacionalidade
CREATE OR REPLACE FUNCTION obter_jogadores_por_nacionalidade(
  equipe_id integer,
  jogador_nacionalidade varchar
)
RETURNS TABLE (nome_jogador varchar) AS $$
BEGIN
  RETURN QUERY
  SELECT jog.nome_usuario
  FROM tbl_jogador jog
  INNER JOIN tbl_jogador_equipe je ON je.cpf = jog.cpf
  WHERE je.id_equipe = equipe_id AND jog.nacionalidade = jogador_nacionalidade;
END;
$$ LANGUAGE plpgsql;


-- Função para verificar se um jogador já participou de uma partida específica
CREATE OR REPLACE FUNCTION verificar_participacao_jogador(
  jogador_cpf varchar,
  partida_id integer
)
RETURNS boolean AS $$
DECLARE
  participacao boolean;
BEGIN
  SELECT EXISTS(
    SELECT 1
    FROM tbl_partida_jogador
    WHERE cpf = jogador_cpf AND id_partida = partida_id
  ) INTO participacao;
  
  RETURN participacao;
END;
$$ LANGUAGE plpgsql;


-- Função para calcular a premiação total de uma edição de campeonato
CREATE OR REPLACE FUNCTION calcular_premiacao_total_edicao(
  edicao_id integer
)
RETURNS integer AS $$
DECLARE
  premiacao_total integer;
BEGIN
  SELECT SUM(premiacao_primeiro + premiacao_segundo + premiacao_terceiro) INTO premiacao_total
  FROM tbl_edicao
  WHERE id_edicao = edicao_id;
  
  RETURN premiacao_total;
END;
$$ LANGUAGE plpgsql;