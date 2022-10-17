/*

--SIMPLE QUERIES

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


*/

