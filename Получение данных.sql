DECLARE @X INT
DECLARE @Y INT
DECLARE @Z INT

SET @X = 0
SET @Y = 0
SET @Z = 0

SELECT TOP(10) region.RegionName AS 'Region name', 
	s.ProductName AS 'Product name', 
	s.productCount AS 'Product count', 
	s.productSum AS 'Product sum',
	s.personCount AS 'Persons count',
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
