CREATE INDEX idx_jog_nome
ON tbl_jogador
USING HASH(nome_usuario);

CREATE INDEX idx_emp_nome
ON tbl_empresa
USING HASH(nome);

CREATE INDEX idx_jcomp_nome
ON tbl_jogo_comp
USING HASH(nome);