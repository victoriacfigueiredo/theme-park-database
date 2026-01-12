-- CONSULTAS COM GROUP BY/HAVING
--Projetar os CPFs dos funcionários que trabalham em mais de 1 parque
SELECT T.CPF_FUNC, COUNT(*) AS QTD_PARQUE
FROM TRABALHA T
GROUP BY T.CPF_FUNC
HAVING COUNT(*) > 1;

-- Projetar as datas que houveram mais de 1 visitante no parque CNPJ 1113
SELECT V.DATA, COUNT(*) AS QTD_VISITANTE
FROM VISITA V
WHERE V.CNPJ = '1113'
GROUP BY V.DATA
HAVING COUNT(*) > 1


-- CONSULTAS COM JUNÇÃO INTERNA
-- Projetar por categoria os food truck que venderam mais de 1 item
SELECT F.CATEGORIA, COUNT(*) AS Itens_comprados
FROM FOOD_TRUCK F INNER JOIN COMPRA C ON (F.COD = C.COD)
GROUP BY F.CATEGORIA
HAVING COUNT(*) > 1;


-- Projetar nome e idade dos visitantes menores de idade que foram ao parque '1113'
SELECT V.NOME, V.IDADE
FROM VISITANTE V INNER JOIN VISITA V1 ON (V1.CPF_VISITANTE = V.CPF)
WHERE V.IDADE < 18 AND V1.CNPJ = '1113';

  
-- CONSULTA COM JUNÇÃO EXTERNA
-- Projetar os nomes dos visitantes que não compraram em nenhum food_truck
SELECT V.NOME
FROM VISITANTE V LEFT OUTER JOIN COMPRA C ON (V.CPF = C.CPF_VISITANTE)
WHERE C.CPF_VISITANTE IS NULL;


-- CONSULTA COM SEMI JUNÇÃO
-- Projetar o nome e as idades dos visitantes que participaram de atrações
SELECT V.NOME, V.IDADE
FROM VISITANTE V 
WHERE EXISTS (SELECT *
              FROM PARTICIPA P
              WHERE V.CPF = P.CPF_VISITANTE);


-- CONSULTA COM ANTI-JUNÇÃO
-- Projetar as categoria dos food_trucks que não venderam nenhum produto
SELECT F.CATEGORIA
FROM FOOD_TRUCK F
WHERE NOT EXISTS (SELECT *
    			  FROM COMPRA C
    			  WHERE C.COD = F.COD);


-- CONSULTAS COM SUBCONSULTAS DO TIPO ESCALAR
-- Projetar o nome do parque mais visitado
SELECT P.NOME, COUNT(*)
FROM VISITA V INNER JOIN PARQUE P ON (V.CNPJ = P.CNPJ)
GROUP BY P.NOME
HAVING COUNT(*) = (SELECT MAX(QTD_VISITANTES)
    			   FROM (SELECT COUNT(*) AS QTD_VISITANTES
    					 FROM VISITA V1
    					 GROUP BY V1.CNPJ));

--Projetar os CPFs, nomes e alturas dos visitantes que tem altura maior que a média dos visitantes
SELECT V.CPF, V.NOME, V.ALTURA
FROM VISITANTE V
WHERE V.ALTURA > (SELECT AVG(V1.ALTURA)
                  FROM VISITANTE V1);


-- SUBCONSULTA DO TIPO LINHA
-- listar os nomes e os cpfs do visitantes que tenham 
-- a mesma idade e a mesma altura do visitante com cpf = '1718'
SELECT V1.NOME, V1.CPF
FROM VISITANTE V1 
WHERE (V1.IDADE, V1.ALTURA) = (SELECT V2.IDADE, V2.ALTURA
    						  FROM VISITANTE V2
    						  WHERE V2.CPF = '1718');

--SUBCONSULTA DO TIPO TABELA
-- Projetar os nomes dos seguranças que trabalham em apenas 1 parque 
SELECT F.NOME
FROM FUNCIONARIO F
WHERE F.CPF IN (SELECT T.CPF_FUNC
    			FROM TRABALHA T
    			GROUP BY T.CPF_FUNC
    			HAVING COUNT(*) = 1) AND F.CARGO = 'SEGURANCA';


-- OPERAÇÕES DE CONJUNTOS
-- Projetar os nomes dos visitantes com mais de 15 anos que 
-- compraram em algum food_truck 
-- e participaram de atração
SELECT V.NOME
FROM VISITANTE V 
WHERE V.IDADE > 15 AND V.CPF IN (SELECT C.CPF_VISITANTE
    							 FROM COMPRA C)
INTERSECT 
SELECT V.NOME
FROM VISITANTE V
WHERE V.CPF IN (SELECT P.CPF_VISITANTE
    			FROM PARTICIPA P);


-- PROCEDIMENTO COM SQL EMBUTIDA E PARÂMETRO
--Projetar o nome de todos os visitantes que foram ao parque '1113' no ano de 2022

CREATE OR REPLACE PROCEDURE VISITANTES_POR_ANO(ANO VARCHAR, CNPJ VARCHAR) IS 
  CURSOR CUR_VISITANTES_PARQUE_NOME IS
  SELECT DISTINCT V.NOME
  FROM VISITANTE V INNER JOIN VISITA V2 ON (V.CPF = V2.CPF_VISITANTE)
  WHERE EXTRACT(YEAR FROM (V2.DATA)) = ANO AND V2.CNPJ = CNPJ;
BEGIN 
  DBMS_OUTPUT.PUT_LINE('Visitantes que foram ao parque '|| CNPJ ||' no ano de ' || ANO);
  FOR VISIT IN CUR_VISITANTES_PARQUE_NOME loop
    DBMS_OUTPUT.PUT_LINE(VISIT.NOME);
  END LOOP;
END;


-- FUNÇÃO COM SQL EMBUTIDA E PARÂMETRO
--Projetar nome do funcionário que fiscaliza determinada atração
CREATE OR REPLACE FUNCTION FUNC_FISCALIZA(TIPO_ATRACAO IN VARCHAR, PARQUE IN VARCHAR) RETURN VARCHAR IS
NOME_FUNCIONARIO VARCHAR(30);
  BEGIN 
  SELECT F.NOME INTO NOME_FUNCIONARIO
  FROM FUNCIONARIO F
  WHERE F.CPF = (SELECT A.CPF_FUNC
                 FROM ATRACAO A
                 WHERE A.TIPO = TIPO_ATRACAO AND A.CNPJ = PARQUE);
  RETURN NOME_FUNCIONARIO;
END;

-- quantidade de produtos comprados nos food_trucks por um visitante
CREATE OR REPLACE FUNCTION QTD_PRODUTO(CPF IN VARCHAR) RETURN NUMBER IS QT NUMBER;
BEGIN
	SELECT COUNT(*) INTO QT
	FROM COMPRA C 
	WHERE C.CPF_VISITANTE = CPF;
	RETURN QT;
END;
