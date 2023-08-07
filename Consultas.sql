--1 - Média de kills de cada jogador na edição 'XX' em ordem decrescente;
select
	jog.nome_usuario,
	avg(parjog.num_kills) as “media Kills”
	from tbl_partida_jogador parjog
	inner join tbl_partida par
	on par.id_partida = parjog.id_partida
	inner join tbl_jogador jog
	on jog.cpf = parjog.cpf
	where par.id_edicao = XX
	group by jog.nome_usuario
	order by “media Kills” desc


--2 - Qual é o nome da equipe que ganhou o último jogo do campeonato na edição 'XX'?
select
	e.nome
	from tbl_partida p
	inner join tbl_equipe e
	on e.id_equipe = p.vencedor
	order by p.data_partida desc
	where p.id_edicao = XX 
	limit 1

--3 - Para determinado Jogador, contagem de MVP's na carreira dele.

select count (*) as "Contagem de mvps" from tbl_partida par
    inner join tbl_jogador jog
    on par.mvp = jog.cpf
   where jog.cpf = "X";
--onde X é o cpf do jogador escolhido.

--4 -Quantidade de participações das organizações em campeonatos?
select
	emp.nome,
count(ee.id_equipe)
	from tbl_equipe_edicao ee
	inner join tbl_edicao e
	on e.id_edicao = ee.id_edicao
	inner join tbl_equipe eq
	on eq.id_equipe = ee.id_equipe
	inner join tbl_empresa emp
	on emp.cnpj = eq.org
group by eq.org

--5 - Total de kills do jogador "XXX" numa edição de id Y, identificado pelo seu nick;
 select 
 	jog.nome,
    SUM(parjog.num_kills) as "Soma de Kills"
    from tbl_partida_jogador parjog
    inner join tbl_partida par
    on par.id_partida = parjog.id_partida
    inner join tbl_jogador jog
    on jog.cpf = parjog.cpf 
    where jog.nome = "X" and par.id_edicao = Y


--6 - Nick do mvp da partida "X";
select jog.nome_usuario as "Nome de usuário ou 'NICK'" from tbl_partida par
    inner join tbl_jogador jog
    on par.mvp = jog.cpf
   where par.id_partida = X;

onde X é o id da partida desejada

--7 - Quantos jogadores já se tornaram técnicos?
select count (*) as "Contagem de tecnicos q sao ex jogadores" from tbl_tecnico tec
    inner join tbl_jogador jog
    on tec.cpf = jog.cpf

--8 - Qual é o valor total que cada org recebe por patrocínio;
select
    emp.nome,
    SUM(orgpat.valor_patrocinio) AS total
    from tbl_organizacao_patrocinador orgpat
    inner join tbl_organizacao org
    on org.cnpj = orgpat.cnpj_org
    inner join tbl_empresa emp
    on emp.cnpj = org.cnpj
    group by emp.nome
    order by total desc


--9 - Qual é o telefone da empresa desenvolvedora que fez o jogo "XX"?

select
    emp.nome,
    tel.ddi,
    tel.ddd,
    tel.numero
    from tbl_jogo_comp comp
    inner join tbl_desenvolvedora dev
    on comp.desenvolvedora = dev.cnpj
    inner join tbl_empresa emp
    on emp.cnpj = dev.cnpj
    Inner join tbl_telefone tel
    on emp.cnpj = tel.cod_identificador_empresa
    where comp.nome = X
onde X é o nome do jogo

--10 - Média de salários de todos os jogadores de uma equipe XX

select 
	e.nome,
	avg(emp.salario)
	from tbl_jogador_equipe je
	inner join empregado emp
	on emp.cpf = je.cpf
	inner join tbl_equipe e
	on e.id_equipe = je.id_equipe
	where id_equipe = XX