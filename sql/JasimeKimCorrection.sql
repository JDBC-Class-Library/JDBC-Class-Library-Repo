use Northwinds2022TSQLV7
SELECT CustomerContactTitle, CustomerId
       , coalesce (CustomerRegion, N'No Region') as CustomerRegion
	   ,Row_Number() over (partition by CustomerContactTitle order by customerID) as rowNum
	   ,concat(CustomerContactTitle,(Row_Number() over (partition by CustomerContactTitle order by customerID))) as newLabel
	   ,CustomerPostalCode
FROM Sales.Customer
WHERE CustomerContactTitle IN (N'Owner', N'Sales Agent')
ORDER BY CustomerContactTitle
FOR JSON PATH, ROOT ('OwnersAndAgents'), INCLUDE_NULL_VALUES


use AdventureWorks2017
select employeeId, PurchaseOrderId, TotalDue 
	   ,  FORMAT((100. * O1.TotalDue/dbo.EmployeeTotalSales(O1.EmployeeId)),'P') as PtyOfTotalEmployeeOrder
		, FORMAT(dbo.EmployeeTotalSales(O1.EmployeeId),'C')as employeeTotal
	    , Format (100. * O1.TotalDue/ (SELECT SUM(O2.TotalDue) FROM purchasing.PurchaseOrderHeader as O2),'P') AS PtyOFAllTotal
		, FORMAT((SELECT SUM(O2.TotalDue) FROM purchasing.PurchaseOrderHeader as O2), 'C') AS allTotal
from purchasing.PurchaseOrderHeader as O1
Order BY EmployeeID,  PurchaseOrderID
FOR JSON PATH, ROOT ('EmployeeTotalSalesPTY'), INCLUDE_NULL_VALUES;

DROP FUNCTION IF EXISTS dbo.EmployeeTotalSales;
GO
CREATE FUNCTION dbo.EmployeeTotalSales
(
	@EmployeeId AS INT 
)
RETURNS MONEY 
AS
BEGIN 

		RETURN (SELECT SUM (TotalDue)
				   FROM Purchasing.PurchaseOrderHeader 
		          WHERE EmployeeId = @EmployeeId)
END 
GO


--COMPLEX 7 [Uses scalar function, correlated subquery, table expression]
--Proposition: Our company is having a special discount for families with children. The discount amount varies by the number of children. Show how much discount
--each family will receive.
use AdventureWorksDW2017;
GO
DROP FUNCTION IF EXISTS dbo.ChildrenDiscount;
GO
use AdventureWorksDW2017;
go
CREATE FUNCTION dbo.ChildrenDiscount
(
	@TotalChildren as int
)
RETURNS DECIMAL
AS
BEGIN
	DECLARE @Result DECIMAL;

	SELECT @Result = CASE 
						WHEN @TotalChildren > 5 THEN 25
						WHEN @totalChildren BETWEEN 2 AND 4 THEN 15
						WHEN @TotalChildren > 0 THEN 10
						ELSE 0
	
					END;

	RETURN @Result;
END;

use AdventureWorksDW2017;
WITH SalesTotalCTE AS 
(	SELECT  DISTINCT S1.CustomerKey,
		   (SELECT SUM(S2.SalesAmount)
			FROM dbo.FactInternetSales AS S2
			WHERE S2.CustomerKey = S1.CustomerKey
			AND S2.OrderDate = '20130503') AS TotalOfSalesPerCustomer
	FROM dbo.FactInternetSales AS S1
	WHERE S1.OrderDate = '20130503'

)

SELECT DISTINCT C.customerKey, C.TotalChildren, 
		dbo.ChildrenDiscount (C.TotalChildren) AS discountPty
		, FORMAT(S.TotalOfSalesPerCustomer, 'C') AS totalSalesOn20130503
		, FORMAT ((dbo.ChildrenDiscount (C.TotalChildren)/100 )* S.TotalOfSalesPerCustomer, 'C') AS discountedAmount
FROM SalesTotalCTE AS S
	INNER JOIN dbo.dimCustomer AS C
		ON C.CustomerKey = S.CustomerKey
ORDER BY C.customerKey
FOR JSON PATH, ROOT ('FamilyDiscount20130503'), include_null_values





