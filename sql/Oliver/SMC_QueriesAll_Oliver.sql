

---------------------------------SIMPLE QUERIES

USE AdventureWorks2017;

SELECT Distinct top 5 name
FROM Production.WorkOrder as PW
    Inner join Production.Product as PP
    on pw.ProductID = pp.ProductID


GO
USE AdventureWorksDW2017;

SELECT * 
FROM dbo.DimProductSubcategory as dps
left join dbo.dimproduct as dp 
on dps.ProductSubcategoryKey = dp.ProductSubcategoryKey
ORDER by dps.productSubcategorykey asc


GO
USE Northwinds2022TSQLV7
   
SELECT O.orderid, E.EmployeeLastName
FROM HumanResources.Employee AS E
  INNER JOIN Sales.[Order] AS O
    ON E.EmployeeId = O.EmployeeId
WHERE E.EmployeeLastName LIKE N'C%';



GO
USE WideWorldImporters;

select DISTINCT TOP 100 sc.CustomerID, sc.TransactionAmount, sc.TransactionDate
from sales.CustomerTransactions as sc
INNER JOIN sales.Orders as so 
on sc.CustomerID = so.CustomerID
WHERE sc.TransactionAmount > 450
ORDER BY sc.TransactionAmount ASC




GO
USE PrestigeCarsOriginal;

Select cus.CustomerName, s.TotalSalePrice, s.SaleDate
from data.Customer as cus 
right join data.Sales as s
on cus.CustomerID = s.CustomerID









-------------------------------------MEDIUM QURIES





GO

USE AdventureWorks2017;

 WITH reverseCte AS(
    SELECT Distinct top 20 PP.Name as OrignalName, COUNT(*) as CountryAggregationCount
    FROM Production.WorkOrder as PW
        Inner join Production.Product as PP
        ON pw.ProductID = pp.ProductID
        WHERE PW.OrderQty > 3
        GROUP BY PP.Name
  
      )

SELECT OrignalName, CountryAggregationCount
FROM reverseCte




GO

USE AdventureWorks2017;

WITH reverseCte AS(
    SELECT Distinct top 10 PP.Name as reverseName, COUNT(*) as CountryAggregationCount
    FROM Production.WorkOrder as PW
        Inner join Production.Product as PP
        ON pw.ProductID = pp.ProductID
        WHERE PW.OrderQty > 3
        GROUP BY PP.Name
  
      )

SELECT REVERSE(reverseName), CountryAggregationCount
FROM reverseCte





GO
USE AdventureWorksDW2017;

WITH getProductSalesCTE AS(
    SELECT dp.EnglishProductName AS EPN, dp.DealerPrice AS DealerPrice, frs.SalesAmount AS SalesAmount
    FROM Dbo.DimProduct as dp
    LEFT OUTER JOIN Dbo.FactResellerSales as frs
    ON dp.ProductKey = frs.ProductKey
)

SELECT EPN, MAX(DealerPrice) as HighestDealerAggregate, SalesAmount
FROM getProductSalesCTE
GROUP BY EPN, SalesAmount
ORDER BY HighestDealerAggregate DESC





GO
USE AdventureWorksDW2017;

WITH getProductSalesCTE AS(
    SELECT Dp.EnglishProductName AS EPN, Dp.DealerPrice AS DealerPrice, frs.SalesAmount AS SalesAmount
    FROM Dbo.DimProduct AS Dp
    LEFT OUTER JOIN Dbo.FactResellerSales AS Frs
    ON Dp.ProductKey = frs.ProductKey
)

SELECT EPN, SUM(DealerPrice) AS HighestDealerAggregate, SalesAmount
FROM getProductSalesCTE
GROUP BY EPN, SalesAmount
HAVING SalesAmount > 10000
ORDER BY HighestDealerAggregate DESC









GO
USE Northwinds2022TSQLV7;

WITH YearlyCountCTE AS
(
  SELECT YEAR(orderdate) AS orderyear,
    COUNT(DISTINCT CustomerId) AS numcusts
  FROM Sales.[Order]
  GROUP BY YEAR(orderdate)
)
SELECT Cur.orderyear, 
  Cur.numcusts AS UniqueCurrentCustomers, Prv.numcusts AS UniquePreviousCustomers,
  Cur.numcusts - Prv.numcusts AS CustomerGrowth
FROM YearlyCountCTE AS Cur
  LEFT OUTER JOIN YearlyCountCTE AS Prv
    ON Cur.orderyear = Prv.orderyear + 1;
    
    
GO
USE Northwinds2022TSQLV7;

WITH YearlyCountCTE AS
(
  SELECT YEAR(orderdate) AS orderyear,
    COUNT(DISTINCT CustomerId) AS numcusts
  FROM Sales.[Order]
  GROUP BY YEAR(orderdate)
)
SELECT Cur.orderyear, 
  Cur.numcusts AS UniqueCurrentCustomers, Prv.numcusts AS UniquePreviousCustomers,
  Cur.numcusts - Prv.numcusts AS CustomerGrowth
FROM YearlyCountCTE AS Cur
  INNER JOIN YearlyCountCTE AS Prv
    ON Cur.orderyear = Prv.orderyear + 1;
    
    
    

GO
USE WideWorldImporters;

WITH FindCustomerNamesCTE AS (
SELECT TOP 100 COUNT(DISTINCT Cust.CustomerID) AS UniqueCustomerCount, Cust.AmountExcludingTax AS exTax, TaxAmount AS Taxed
FROM Sales.CustomerTransactions as CusT
GROUP BY AmountExcludingTax, TaxAmount
HAVING TaxAmount != 0.0

)

SELECT DISTINCT TOP 100 exTax, Taxed, UniqueCustomerCount
FROM FindCustomerNamesCTE AS Cus
INNER JOIN Sales.Orders AS Sales
ON CustomerID = Sales.CustomerID 




GO
USE PrestigeCarsOriginal;

WITH CustomerNameCountCTE AS (
Select cus.CustomerName as cn, Count(cus.CustomerName) as UniqueNameCount, s.TotalSalePrice as TotalSalePrice, s.SaleDate as SaleDate
from data.Customer as cus 
INNER JOIN data.Sales as s
on cus.CustomerID = s.CustomerID
GROUP BY Cus.CustomerName, S.TotalSalePrice, S.SaleDate

)


SELECT cn as CustomerName, UniqueNameCount, TotalSalePrice, SaleDate
FROM CustomerNameCountCTE










--------------------------------------COMPLEX

USE AdventureWorks2017;



GO 

--NO ACCESS TO USING FUNCTION AND COMPUTER COUDLNT INSTALL DOCKER
--DROP FUNCTION IF EXISTS udfReverseString;
--
--GO 
--
--CREATE FUNCTION udfReverseString(@OrigName VARCHAR(200))
--  RETURNS VARCHAR (2000)
--  BEGIN
--    return REVERSE(@OrigName);
--  END;
--
--GO

WITH originalCTE AS(
    SELECT Distinct PP.ProductID as Product, PP.Name as OriginalName, COUNT(*) as CountryAggregationCount
    FROM Production.WorkOrder as PW
        Inner join Production.Product as PP
        ON pw.ProductID = pp.ProductID
        WHERE PW.OrderQty > 3
        GROUP BY PP.ProductID, PP.Name
  
      )


SELECT DISTINCT TOP 20 OriginalName, REVERSE(OriginalName) as Reversed, CountryAggregationCount, PT.TransactionID
FROM originalCTE as oCTE
INNER JOIN Production.TransactionHistory as PT
ON  ProductID = PT.ProductID





GO

USE NORTHWINDS2022TSQLV7;


--NO ACCESS TO USING FUNCTION AND COMPUTER COUDLNT INSTALL DOCKER
--DROP FUNCTION IF EXISTS CustomerIDManipulator;
--
--GO  
--
--CREATE FUNCTION CustomerIDManipulator(@id INT)
--RETURNS INT 
--BEGIN
--  RETURN @id * 10
--
--END
--
--GO



WITH HR_CTE AS (
SELECT EmployeeCountry, COUNT(*) AS numlocations
FROM (SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM HumanResources.Employee
      UNION
      SELECT CustomerCountry, CustomerRegion, CustomerCity FROM Sales.Customer) AS U
 

GROUP BY EmployeeCountry
)


SELECT DISTINCT TOP 100 SO.CustomerId, EmployeeCountry, numlocations
FROM HR_CTE as HR
CROSS JOIN Sales.[Order] as SO
ORDER BY SO.CustomerId ASC 









GO

USE NORTHWINDS2022TSQLV7;


--NO ACCESS TO USING FUNCTION AND COMPUTER COUDLNT INSTALL DOCKER
--DROP FUNCTION IF EXISTS CustomerIDManipulator;
--
--GO  
--
--CREATE FUNCTION CustomerIDManipulator(@id INT)
--RETURNS INT 
--BEGIN
--  RETURN @id * 10
--
--END
--
--GO



WITH HR_CTE AS (
SELECT EmployeeCountry, COUNT(*) AS numlocations
FROM (SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM HumanResources.Employee
      UNION
      SELECT CustomerCountry, CustomerRegion, CustomerCity FROM Sales.Customer) AS U
 

GROUP BY EmployeeCountry
)


SELECT DISTINCT TOP 100 SO.CustomerId, EmployeeCountry, numlocations
FROM HR_CTE as HR
CROSS JOIN Sales.[Order] as SO
ORDER BY SO.CustomerId DESC 




GO


USE NORTHWINDS2022TSQLV7;

--NO ACCESS TO USING FUNCTION AND COMPUTER COUDLNT INSTALL DOCKER
--DROP FUNCTION IF EXISTS CustomerIDManipulator;
--
--GO  
--
--CREATE FUNCTION CustomerIDManipulator(@id INT)
--RETURNS INT 
--BEGIN
--  RETURN @id * 10
--
--END
--
--GO

WITH HR_CTE AS (
SELECT EmployeeCountry, COUNT(*) AS numlocations
FROM (SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM HumanResources.Employee
      UNION
      SELECT CustomerCountry, CustomerRegion, CustomerCity FROM Sales.Customer) AS U

GROUP BY EmployeeCountry
HAVING EmployeeCountry LIKE N'S%'

)


SELECT DISTINCT TOP 100 SO.CustomerId, EmployeeCountry, numlocations
FROM HR_CTE as HR
CROSS JOIN Sales.[Order] as SO
ORDER BY SO.CustomerId ASC 




GO

USE NORTHWINDS2022TSQLV7;

--NO ACCESS TO USING FUNCTION AND COMPUTER COUDLNT INSTALL DOCKER
--DROP FUNCTION IF EXISTS CustomerIDManipulator;
--
--GO  
--
--CREATE FUNCTION CustomerIDManipulator(@id INT)
--RETURNS INT 
--BEGIN
--  RETURN @id * 10
--
--END
--
--GO

WITH HR_CTE AS (
SELECT EmployeeCountry, COUNT(*) AS numlocations
FROM (SELECT EmployeeCountry, EmployeeRegion, EmployeeCity FROM HumanResources.Employee
      UNION
      SELECT CustomerCountry, CustomerRegion, CustomerCity FROM Sales.Customer) AS U

GROUP BY EmployeeCountry
HAVING EmployeeCountry LIKE N'S%P%'

)


SELECT DISTINCT TOP 100 SO.CustomerId, EmployeeCountry, numlocations
FROM HR_CTE as HR
CROSS JOIN Sales.[Order] as SO
ORDER BY SO.CustomerId ASC 



GO

USE WideWorldImporters;

WITH FindCustomerNamesCTE AS (
SELECT TOP 100 COUNT(DISTINCT Cust.CustomerID) AS UniqueCustomerCount, Cust.AmountExcludingTax AS exTax, TaxAmount AS Taxed
FROM Sales.CustomerTransactions as CusT
GROUP BY AmountExcludingTax, TaxAmount
HAVING TaxAmount != 0.0

)

SELECT DISTINCT TOP 100 exTax, Taxed, UniqueCustomerCount, ordLIne.TaxRate
FROM FindCustomerNamesCTE AS Cus
INNER JOIN Sales.Orders AS Sales
ON CustomerID = Sales.CustomerID 
CROSS JOIN Sales.OrderLines as ordLine
 




GO

USE PrestigeCarsOriginal;

WITH CustomerNameCountCTE AS (
Select cus.CustomerName as cn, Count(cus.CustomerName) as UniqueNameCount, s.TotalSalePrice as TotalSalePrice, s.SaleDate as SaleDate
from data.Customer as cus 
INNER JOIN data.Sales as s
on cus.CustomerID = s.CustomerID
GROUP BY Cus.CustomerName, S.TotalSalePrice, S.SaleDate

)


SELECT cn as CustomerName, ModName.ModelName , UniqueNameCount , TotalSalePrice, SaleDate
FROM CustomerNameCountCTE
CROSS JOIN Data.Model AS ModName



