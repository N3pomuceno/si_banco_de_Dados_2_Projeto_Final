-- Gatilho de jogadores menores que 16 anos não podem ser registrados
CREATE OR REPLACE FUNCTION verificacao_idade()
RETURNS TRIGGER AS $$
BEGIN
    IF (AGE(CURRENT_DATE, NEW.data_nasc) < INTERVAL '16 YEARS') THEN
        DELETE FROM tbl_empregado
        WHERE cpf = NEW.cpf;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_idade_jogador
AFTER INSERT ON tbl_empregado
FOR EACH ROW
EXECUTE FUNCTION verificacao_idade();

-- Gatilho que edições precisam ter 3 semanas de diferença entre elas para serem registradas.
CREATE OR REPLACE FUNCTION verificacao_diferenca_semanas()
RETURNS TRIGGER AS $$
DECLARE
    qtd_edicoes integer;
BEGIN
    SELECT COUNT(*) INTO qtd_edicoes
    FROM tbl_edicao
    WHERE abs(NEW.data_inicio - data_fim) < INTERVAL '21 DAYS';
    
    IF qtd_edicoes > 0 THEN
        RAISE EXCEPTION 'A nova edição precisa ter pelo menos 3 semanas de diferença em relação às edições existentes.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_diferenca_semanas
BEFORE INSERT ON tbl_edicao
FOR EACH ROW
EXECUTE FUNCTION verificacao_diferenca_semanas();
