# Theme Park Database 🎡

<p align="center">
	<img src="./projeto_conceitual.png" alt="Projeto Conceitual" width="480" />
</p>

Este repositório contém um conjunto de scripts SQL para criar, povoar e consultar um esquema de banco de dados para parques temáticos. Os scripts foram escritos com sintaxe compatível com Oracle.

## Estrutura do repositório

- `aplicacao_sql/create.sql` - criação das tabelas e restrições (PKs/FKs/uniques).
- `aplicacao_sql/povoamento.sql` - comandos `INSERT` para povoar as tabelas com dados de exemplo.
- `aplicacao_sql/consultas.sql` - Conjunto de consultas SQL demonstrando operações (JOINs, GROUP BY/HAVING, subconsultas, procedures e functions).
- `slides.pdf` - Apresentação em PDF do projeto.
- `projeto_conceitual.png` - Diagrama do projeto conceitual.

## Visão geral do esquema

Principais tabelas:
- `FUNCIONARIO` (CPF PK) — empregados do parque, com referência a um chefe (self-FK).
- `VISITANTE` (CPF PK) — visitantes do parque (idade, altura).
- `PARQUE` (CNPJ PK) — parques temáticos.
- `ATRACAO` (CNPJ, NUM PK) — atrações do parque, com responsável (`CPF_FUNC`) para fiscalização.
- `FOOD_TRUCK` (COD PK) — food trucks e suas categorias.
- `TRABALHA` (CPF_FUNC, CNPJ, TURNO PK) — relação de funcionários que trabalham em cada parque.
- `VISITA` (CPF_VISITANTE, CNPJ, DATA PK) — registro de visitas.
- `TEM` (CPF_FUNC, CNPJ, COD PK) — qual funcionário atende qual food truck em qual parque.
- `PARTICIPA` (CPF_VISITANTE, CNPJ, NUM PK) — visitantes que participaram de atrações.
- `PREMIO` (ID PK) — prêmios dados por participação em atrações.
- `COMPRA` (CPF_VISITANTE, COD, NOTA_FISCAL PK) — compras feitas em food trucks.

As constraints implementam integridade referencial entre as entidades (FKs) e chaves primárias compostas quando necessário.
