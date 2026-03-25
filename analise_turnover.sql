
-- 🎯 Análise de Turnover de Funcionários com SQL
-- Este projeto tem como objetivo analisar o turnover de funcionários, identificando padrões de desligamento, departamentos mais impactados e possíveis fatores relacionados, como satisfação, equilíbrio vida-trabalho e remuneração.
-- A base de dados contém informações de funcionários, incluindo:
-- •	Departamento
-- •	Nível do cargo
-- •	Status (Ativo/Desligado)
-- •	Salário mensal
-- •	Custo de turnover
-- •	Satisfação no trabalho
-- •	Equilíbrio vida pessoal/profissional
-- •	Percentual de aumento salarial

-- 📈  Principais Análises
-- 🔹  Taxa Geral de Turnover
SELECT
COUNT(*) AS total_registro,
SUM(CASE WHEN "Status" = 'Desligado' THEN 1 ELSE 0 END) AS Total_Desligados,
SUM(CASE WHEN "Status" = 'Desligado' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100 AS Taxa_Turnover
FROM funcionarios;
 


-- 🔹  Turnover por Departamento
SELECT
"Departamento",
SUM(CASE WHEN "Status" = 'Desligado' THEN 1 ELSE 0 END) AS Total_Desligado,
ROUND(SUM(CASE WHEN "Status" = 'Desligado' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS Taxa_Turnover_Perc,
ROUND(AVG("MonthlyIncome"), 2) as Media_Salarial
FROM funcionarios
GROUP BY "Departamento"
ORDER BY Taxa_Turnover_Perc DESC;
 
-- Identifica quais departamentos possuem maior taxa de desligamento, ajudando a priorizar ações de retenção.

-- 🔹  Impacto Financeiro do Turnover
SELECT
"Departamento",
"NivelCargo",
COUNT(CASE WHEN "Status" = 'Desligado' THEN 1 END) AS Total_desligado,
SUM("CustoTurnover") AS Prejuizo_Total,
ROUND(AVG("MonthlyIncome"), 2) AS Media_Salarial_Desligados
FROM funcionarios
GROUP BY "Departamento", "NivelCargo"
ORDER BY Prejuizo_Total DESC;
 
-- Essa análise mostra o impacto financeiro dos desligamentos, evidenciando quais áreas geram maior prejuízo para o negócio.

-- 🔹  Fatores de Satisfação
SELECT
"Status",
AVG("JobSatisfaction") AS Media_Satisfacao,
AVG("WorkLifeBalance") AS Media_Equilibrio_Vida,
AVG("PercentSalaryHike") AS Media_Aumento_Salarial
FROM funcionarios
GROUP BY "Status";
 
-- Compara funcionários ativos e desligados para identificar fatores que podem influenciar o turnover.
-- 🔹 Top 1 Cargo com Mais Desligamentos por Departamento
WITH calculo_base AS (
SELECT
"Departamento" as dep,
"NivelCargo" as cargo,
SUM(CASE WHEN "Status" = 'Desligado' THEN 1 ELSE 0 END) as conta_desligado
FROM funcionarios
GROUP BY "Departamento", "NivelCargo"
),
ranking as (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY dep ORDER BY conta_desligado DESC) AS contagem_seg
FROM calculo_base
)
SELECT
dep, cargo, conta_desligado
FROM ranking
WHERE contagem_seg = 1
ORDER BY conta_desligado DESC;
 
-- Identifica o cargo com maior número de desligamentos dentro de cada departamento, permitindo ações mais direcionadas.

-- Principais Conclusões
-- •	Existem departamentos com turnover significativamente mais alto
-- •	O custo de desligamento pode impactar diretamente o resultado financeiro
-- •	Funcionários desligados tendem a apresentar menor satisfação e equilíbrio vida-trabalho
-- •	Alguns cargos específicos concentram a maior parte das saídas
