DECLARE @X INT
DECLARE @Y INT
DECLARE @Z INT

SET @X = 0
SET @Y = 0
SET @Z = 0

SELECT TOP(10) region.RegionName AS 'Имя региона', 
	s.ProductName AS 'Имя продукта', 
	s.productCount AS 'Объём Продаж', 
	s.productSum AS 'Сумма продаж',
	s.personCount AS 'Количество уникальных покупателей',
	s.id
FROM Region AS region
CROSS APPLY
	(SELECT TOP (1) p1.Id AS id, 
		p1.ProductName AS productName, 
		SUM (i.ProductCount) AS productCount, 
		SUM (i.ProductCount * p2.Price) AS productSum, 
		COUNT (DISTINCT i.PersonId)  AS personCount
	FROM Product p1
	INNER JOIN Price p2  ON
		p1.Id = p2.ProductId
	INNER JOIN OrderItem i ON 
		i.PriceId = p2.Id
	INNER JOIN Person p3 ON
		p3.Id = i.PersonId
	INNER JOIN Region r ON 
		r.Id = p3.RegionId
	WHERE
		r.Id = region.Id
	GROUP BY p1.Id, p1.ProductName
	HAVING SUM (i.ProductCount) >= @X
			AND SUM (i.ProductCount * p2.Price) >= @Y
			AND COUNT (DISTINCT i.PersonId) >= @Z
	ORDER BY SUM(i.ProductCount * p2.Price) DESC) AS s
ORDER BY region.RegionName;