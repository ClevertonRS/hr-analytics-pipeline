WITH BaseRH AS (
    SELECT 
        Departamento,
        Status,
        CustoTurnover,
        MonthlyIncome
    FROM RH_Geral -- Nome fictício da sua tabela no banco
)
SELECT 
    Departamento,
    COUNT(*) AS Total_Colaboradores,
    SUM(CASE WHEN Status = 'Desligado' THEN 1 ELSE 0 END) AS Total_Desligados,
    ROUND(SUM(CASE WHEN Status = 'Desligado' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Taxa_Turnover_Perc,
    ROUND(AVG(MonthlyIncome), 2) AS Media_Salarial
FROM BaseRH
GROUP BY Departamento
ORDER BY Taxa_Turnover_Perc DESC;