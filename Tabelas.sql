CREATE TABLE tbl_endereco (
  cep varchar(8) NOT NULL,
  rua varchar(30) NOT NULL,
  bairro varchar(20) NOT NULL,
  numero integer,
  complemento varchar(50),
  cidade varchar(20) NOT NULL,
  estado varchar(20) NOT NULL,
  CONSTRAINT pk_endereco PRIMARY KEY (cep, numero)
);

CREATE TABLE tbl_plataforma (
  id_plat INTEGER CONSTRAINT pk_plataforma PRIMARY KEY,
  nome varchar(50) NOT NULL
);

CREATE TABLE tbl_empresa (
  cnpj varchar(14) PRIMARY KEY,
  nome varchar(50) NOT NULL,
  cep varchar(8) NOT NULL,
  numero integer,
  FOREIGN KEY (cep, numero) REFERENCES tbl_endereco (cep, numero)
);

CREATE TABLE tbl_organizacao (
  cnpj varchar(14) primary key NOT NULL,
  FOREIGN KEY (cnpj) REFERENCES tbl_empresa (cnpj)
);

CREATE TABLE tbl_patrocinadora (
  cnpj varchar(14) primary key NOT NULL,
  FOREIGN KEY (cnpj) REFERENCES tbl_empresa (cnpj)
);

CREATE TABLE tbl_desenvolvedora (
  cnpj varchar(14) Primary key NOT NULL,
  FOREIGN KEY (cnpj) REFERENCES tbl_empresa (cnpj)
);

CREATE TABLE tbl_empregado (
  cpf varchar(11) NOT NULL PRIMARY KEY,
  nome varchar(50) NOT NULL,
  data_nasc date NOT NULL,
  estado_civil varchar(50) NOT NULL,
  nacionalidade varchar(50) NOT NULL,
  salario money NOT NULL,
  cep varchar(8) NOT NULL,
  numero integer,
  FOREIGN KEY (cep, numero) REFERENCES tbl_endereco (cep,numero)
);

CREATE TABLE tbl_psicologo (
  cnp varchar(11) NOT NULL,
  cpf varchar (11) NOT NULL PRIMARY KEY,
  FOREIGN KEY (cpf) REFERENCES tbl_empregado(cpf)
);

CREATE TABLE tbl_telefone (
  ddd integer NOT NULL,
  ddi integer NOT NULL,
  numero integer NOT NULL,
  cod_identificador_empresa varchar(14),
  cod_identificador_empregado varchar (11),
  CONSTRAINT pk_tel PRIMARY KEY (ddd, ddi, numero),
  FOREIGN KEY (cod_identificador_empregado) REFERENCES tbl_empregado (cpf),
  FOREIGN KEY (cod_identificador_empresa) REFERENCES tbl_empresa(cnpj)
);

CREATE TABLE tbl_equipe (
  id_equipe SERIAL PRIMARY KEY,
  org varchar(14) NOT NULL,
  psicologo varchar(11) NOT NULL,
  nome varchar(50) NOT NULL,
  divisao integer NOT NULL,
  FOREIGN KEY (org) REFERENCES tbl_empresa (cnpj),
  FOREIGN KEY (psicologo) REFERENCES tbl_psicologo (cpf)
);

CREATE TABLE tbl_jogo_comp (
  id_jogo SERIAL PRIMARY KEY,
  desenvolvedora varchar(14) NOT NULL,
  id_plat integer NOT NULL,
  nome varchar(50) NOT NULL,
  data_lancamento date NOT NULL,
  versao varchar(10) NOT NULL,
  FOREIGN KEY (desenvolvedora) REFERENCES tbl_desenvolvedora(cnpj),
  FOREIGN KEY (id_plat) REFERENCES tbl_plataforma (id_plat)
);

CREATE TABLE tbl_jogador (
  cpf varchar(11) NOT NULL PRIMARY KEY,
  nome_usuario varchar(20) NOT NULL,
  equipe integer,
  FOREIGN KEY (equipe) REFERENCES tbl_equipe (id_equipe),
  FOREIGN KEY (cpf) REFERENCES tbl_empregado(cpf)
);

CREATE TABLE tbl_conta (
  id SERIAL NOT NULL,
  plataforma integer NOT NULL,
  jogador varchar(11) NOT NULL,
  email varchar(30) NOT NULL,
  nome varchar(50) NOT NULL,
  CONSTRAINT pk_conta PRIMARY KEY (id, plataforma),
  FOREIGN KEY (plataforma) REFERENCES tbl_plataforma (id_plat),
  FOREIGN KEY (jogador) REFERENCES tbl_jogador(cpf)
);

CREATE TABLE tbl_campeonato (
  id_campeonato SERIAL PRIMARY KEY,
  nome varchar(20) NOT NULL,
  id_jogo integer NOT NULL,
  FOREIGN KEY (id_jogo) REFERENCES tbl_jogo_comp (id_jogo)
);

CREATE TABLE tbl_edicao (
  id_edicao integer PRIMARY KEY,
  campeonato integer NOT NULL,
  data_inicio date NOT NULL,
  data_fim date NOT NULL,
  nome varchar(20) NOT NULL,
  premiacao_primeiro integer,
  premiacao_segundo integer,
  premiacao_terceiro integer,
  vencedor integer NOT NULL,
  FOREIGN KEY (campeonato) REFERENCES tbl_campeonato (id_campeonato),
  FOREIGN KEY (vencedor) REFERENCES tbl_equipe (id_equipe)
);

CREATE TABLE tbl_partida (
  id_partida SERIAL PRIMARY KEY,
  id_equipe1 integer NOT NULL,
  id_equipe2 integer NOT NULL,
  id_edicao integer NOT NULL,
  data_partida date NOT NULL,
  vencedor integer NOT NULL,
  servidor varchar(20) NOT NULL,
  mvp varchar(11) NOT NULL,
  FOREIGN KEY (id_equipe1) REFERENCES tbl_equipe (id_equipe),
  FOREIGN KEY (id_equipe2) REFERENCES tbl_equipe (id_equipe),
  FOREIGN KEY (id_edicao) REFERENCES tbl_edicao (id_edicao),
  FOREIGN KEY (mvp) REFERENCES tbl_jogador (cpf),
  FOREIGN KEY (vencedor) REFERENCES tbl_equipe (id_equipe),
  CONSTRAINT equipes_diferentes CHECK (id_equipe1 != id_equipe2),
  CONSTRAINT vencedor_na_partida CHECK (vencedor = id_equipe1 OR vencedor = id_equipe2)
);

CREATE TABLE tbl_edicao_equipe (
  id_equipe integer NOT NULL,
  id_edicao integer NOT NULL,
  FOREIGN KEY (id_edicao) REFERENCES tbl_edicao (id_edicao),
  FOREIGN KEY (id_equipe) REFERENCES tbl_equipe (id_equipe),
  CONSTRAINT pk_edicao_equipe PRIMARY KEY (id_equipe, id_edicao)
);

CREATE TABLE tbl_edicao_patrocinador (
  cnpj varchar(14) NOT NULL,
  id_edicao integer NOT NULL,
  valor_patrocinio integer NOT NULL,
  FOREIGN KEY (cnpj) REFERENCES tbl_patrocinadora (cnpj),
  FOREIGN KEY (id_edicao) REFERENCES tbl_edicao (id_edicao),
  CONSTRAINT pk_patro_edicao PRIMARY KEY (id_edicao, cnpj)
);

CREATE TABLE tbl_jogador_equipe (
  cpf varchar(11) NOT NULL,
  id_equipe integer NOT NULL,
  data_inicio date NOT NULL,
  data_fim date,
  FOREIGN KEY (cpf) REFERENCES tbl_jogador (cpf),
  FOREIGN KEY (id_equipe) REFERENCES tbl_equipe (id_equipe),
  CONSTRAINT pk_jogador_equipe PRIMARY KEY (cpf, id_equipe, data_inicio, data_fim),
  CONSTRAINT check_date CHECK (data_fim IS NULL OR data_fim > data_inicio)
);

CREATE TABLE tbl_partida_jogador (
  id_partida integer NOT NULL,
  cpf varchar(11) NOT NULL,
  num_kills integer NOT NULL,
  num_assists integer NOT NULL,
  num_deaths integer NOT NULL,
  FOREIGN KEY (id_partida) REFERENCES tbl_partida (id_partida),
  FOREIGN KEY (cpf) REFERENCES tbl_jogador (cpf),
  CONSTRAINT jogadores_uma_vez PRIMARY KEY (id_partida, cpf)
);

CREATE TABLE tbl_organizacao_patrocinador (
  cnpj_org varchar(14) NOT NULL,
  cnpj_pat varchar(14) NOT NULL,
  valor_patrocinio integer NOT NULL,
  FOREIGN KEY (cnpj_org) REFERENCES tbl_organizacao (cnpj),
  FOREIGN KEY (cnpj_pat) REFERENCES tbl_patrocinadora (cnpj),
  CONSTRAINT pk_empresas PRIMARY KEY(cnpj_org, cnpj_pat)
);