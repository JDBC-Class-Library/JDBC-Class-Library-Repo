--EASY 1
--Proposition: Find out all products that have never been sold.
use AdventureWorks2017
select p.productid, p.Name
from production.product as p
	left outer join purchasing.purchaseOrderDetail as od
		on od.productid = p.productid
where od.PurchaseOrderID is null;

--MEDIUM 1 [Includes Subquery in WHERE and SQL functions: MAX, CAST]
--Proposition: What is the highest cost of purchased orders placed per each day? Which employee serviced these orders?
--purchaseorderheader is the summary of orders. purchaseorderdetails shows every item placed for each order. 
use AdventureWorks2017
select CAST (OrderDate AS DATE) as OrderDate, CAST (TotalDue AS NUMERIC (10,2)) as MaxOrderValue, EmployeeId
from Purchasing.PurchaseOrderHeader as O1
where TotalDue = (select MAX (O2.TotalDue)
				  from Purchasing.PurchaseOrderHeader as O2
				  where O2.OrderDate = O1.OrderDate)
order by OrderDate

--Trying the same query with Group By
use AdventureWorks2017
select CAST (OH.OrderDate AS DATE) as OrderDate
      , CAST (MAX(OH.TotalDue) AS NUMERIC (10,2)) as MaxOrderValue
from Purchasing.PurchaseOrderHeader as OH
group by orderDate
order by orderDate

--MEDIUM 2 [Includes subquery inside SELECT and SQL function:SUM]
--Proposition: Show percentage of each employee's order total as a ratio of the employee's total orders serviced. 
use AdventureWorks2017
select employeeId, PurchaseOrderId, TotalDue 
	   ,(100. * O1.TotalDue/(select sum(TotalDue)	
		                     from purchasing.PurchaseOrderHeader as O2
							 where O2.EmployeeID = O1.EmployeeID)
		) as PtyOfTotalEmployeeOrder
		, (select sum(TotalDue)	
		   from purchasing.PurchaseOrderHeader as O3
           where O3.EmployeeID = O1.EmployeeID)as employeeTotal
from purchasing.PurchaseOrderHeader as O1
Order by EmployeeId, PurchaseOrderID

--COMPLEX 1
--Proposition: Show percentage of each employee's order total as a ratio of the employee's total orders serviced. Also show percentage of the employee's order against all orders
use AdventureWorks2017
select employeeId, PurchaseOrderId, TotalDue 
	   ,  (100. * O1.TotalDue/(select sum(TotalDue)	
		                     from purchasing.PurchaseOrderHeader as O2
							 where O2.EmployeeID = O1.EmployeeID)
		  ) as PtyOfTotalEmployeeOrder
		, (select sum(TotalDue)	
		   from purchasing.PurchaseOrderHeader as O2
           where O2.EmployeeID = O1.EmployeeID)as employeeTotal
	    , sum(TotalDue) as SumOfAllOrdersCost
	    , (100. * (select sum(TotalDue)	
				  from purchasing.PurchaseOrderHeader as O2
				  where O2.EmployeeID = O1.EmployeeID)/sum(TotalDue)) as PtyOfTotalOrders
from purchasing.PurchaseOrderHeader as O1
group by PurchaseOrderID, EmployeeId
Order by PurchaseOrderID, EmployeeID

--MEDIUM 3 [Inner join, group by. SQL Function: coalesce, count] 
--Proposition: How many of each color have we sold?
use AdventureWorks2017
select coalesce (pp.color, 'No Color') as Color,
	   count(pod.receivedQty) as NumberOfProductsSold
from purchasing.PurchaseOrderDetail as pod
	 inner join Production.Product as pp
		on pod.ProductID = pp.ProductId
group by pp.color
order by pp.color;

--MEDIUM 4 [Inner join, group by, coalesce, count, and cast functions used]
--How much profit did we make from each color?
use AdventureWorks2017
select coalesce (pp.color, 'No Color') as Color,
	   count(pod.receivedQty) as NumberOfProductsSold,
	   cast(sum(pod.lineTotal) as numeric (10,2)) as TotalProfit
from purchasing.PurchaseOrderDetail as pod
	 inner join Production.Product as pp
		on pod.ProductID = pp.ProductId
group by pp.color
order by pp.color;

--EASY 2
--Proposition: List of customers and their names who live in Germany
use AdventureWorksDW2017
select c.CustomerKey, c.FirstName, c.LastName, g.EnglishCountryRegionName
from DimCustomer as c
	inner join DimGeography as g
		on g.GeographyKey = c.GeographyKey
where g.EnglishCountryRegionName = N'Germany'
order by CustomerKey;

--MEDIUM 7 [Use of CTE, Left outer join, multiple reference SQL Function: SUM]
--Proposition: Compare and contrast the total sales quota of year 2012 and 2013. 
use AdventureWorksDW2017;
WITH YearlyQuota AS
(
	select calendarYear, sum(SalesAmountQuota) as TotalQuota
	from FactSalesQuota
	group by CalendarYear
)

select cur.calendarYear as CurYear, cur.TotalQuota as CurTotalSalesQuota
	   ,prv.calendarYear as PrvYear, prv.TotalQuota as PrvTotalSalesQuota
	   ,cur.TotalQuota - prv.TotalQuota as Increase
	   
from YearlyQuota as cur
	left outer join YearlyQuota as prv
		on cur.CalendarYear = prv.CalendarYear + 1
order by cur.calendarYear;


--COMPLEX 2 [Multiple references of CTE. Composite joins. SQL function: SUM]
--Proposition: Compare and contrast the total sales quota of year 2012 and 2013 by quarters. 
use AdventureWorksDW2017;
with QuarterlyQuota AS
(
	select  CalendarYear, CalendarQuarter, sum (SalesAmountQuota) as TotalSalesAmountQuota
	from FactSalesQuota
	group by CalendarYear, CalendarQuarter
	
)

select cur.CalendarYear as curYear, cur.CalendarQuarter as curQuarter, cur.TotalSalesAmountQuota as CurTotalSalesQuota
	  , prv.CalendarYear as PrvYear, prv.CalendarQuarter as PrvQuater, prv.TotalSalesAmountQuota as PrvTotalSalesQuota
	  , cur.TotalSalesAmountQuota - prv.TotalSalesAmountQuota as QuotaIncrease
	  , 100.* (cur.TotalSalesAmountQuota - prv.TotalSalesAmountQuota)/prv.TotalSalesAmountQuota as PercentIncrease
from QuarterlyQuota AS cur
	 left outer join QuarterlyQuota AS prv
		on cur.CalendarYear = prv.CalendarYear +1
		and cur.CalendarQuarter = prv.CalendarQuarter -- composite join. Want to compare the year 2012 Q1 with year 2013 Q1, not 2012Q1 with 2013Q2
where cur.CalendarYear = N'2013'
order by curYear, curQuarter;


--COMPLEX 7
--Proposition
use AdventureWorksDW2017;
select * from dimCustomer;


--EASY 3 
--Proposition: Find the OrderID, OrderDate of the customers who are owners and sales agents whose CustomerRegion is not known.
use Northwinds2022TSQLV7
drop view if exists Utils.ownersAndAgents;
go
create VIEW Utils.ownersAndAgents
as

select CustomerId, CustomerContactTitle, CustomerCity, CustomerRegion, CustomerCountry
from sales.Customer
where CustomerContactTitle IN (N'Owner', N'Sales Agent');

go

use Northwinds2022TSQLV7
select o.customerid, o.orderdate, oa.customerRegion
from sales.[order] as o
	right outer join Utils.OwnersAndAgents as oa
		on  oa.customerId = o.customerId
where oa.customerRegion is null

--MEDIUM 8 [Inner join with VIEW, SQL Function: Row_Number(), coalesce, concat]
--Proposition: Give the owners and sales agents their own number. Replace the empty/null customer region with more information.
SELECT oa.CustomerContactTitle, oa.CustomerId
       , coalesce (oa.CustomerRegion, N'No Region')  as CustomerRegion
	   ,Row_Number() over (partition by oa.CustomerContactTitle order by oa.customerID) as rowNum
	   ,concat(oa.CustomerContactTitle,(Row_Number() over (partition by oa.CustomerContactTitle order by oa.customerID))) as newLabel
	   ,c.CustomerPostalCode
from Utils.ownersAndAgents as oa
inner join Sales.Customer as c
	on c.customerId = oa.customerId



--MEDIUM 5 [Uses OrderTotalByYear VIEW to calculate running total]
--Proposition: get the running total of orders by year
use Northwinds2022TSQLV7
drop VIEW if exists Sales.OrderTotalByYear;
go
create VIEW Sales.OrderTotalByYear
as

select year(orderDate) as [Year], sum(freight) as TotalFreightCost
from Sales.[Order]
group by year(orderDate)
go

select [year], TotalFreightCost
		, (select sum(O2.TotalFreightCost)
		   from Sales.OrderTotalByYear as O2
		   where O2.[year] <= O1.[year]
		   )as runningTotal
from Sales.OrderTotalByYear as O1
order by [year]

--MEDIUM 6 [Cross join with the dbo.Nums table, dateAdd function used]
--Proposition: In our company, we celebrate an employee's work anniversary for a week. Print out the list of 7 days we must celebrate each employee's work anniversay.

use Northwinds2022TSQLV7
select employeeid, hiredate
from humanresources.employee;

select employeeid, dateadd (day, d.n-1, dateadd(year, 1, e.HireDate)) as DateToCelebrate
from HumanResources.Employee e
	cross join dbo.Nums as d
where d.n <= 7
order by employeeid, DateToCelebrate;

--COMPLEX 5 [Use of Inline Table-Valued Function, CROSS APPLY, SQL or scalar function]
-- Find out the top 3 most expensive items each customer has every purchased.
use Northwinds2022TSQLV7;
drop function if exists dbo.TopPriceItems;
go
create function dbo.TopPriceItems
(
	@howManyItems as int,
	@customerId as int
)
returns table
as
	return
		select top (@howmanyitems) o.customerId, od.OrderId, od.ProductId, od.UnitPrice
		from Sales.OrderDetail as od
			inner join Sales.[Order] as o
				on o.orderId = od.orderId
		where o.customerId = @customerId
		order by unitPrice desc
go




use Northwinds2022TSQLV7;
SELECT c.customerId
	   , a.orderId, a.productid, a.unitPrice
	   , row_number() over(partition by c.customerId order by a.unitPrice DESC) as number
from sales.Customer as c
	cross apply dbo.TopPriceItems (3, c.customerId) as a
order by c.customerId, a.UnitPrice desc

--EASY 4
--Proposition: The recent hurricane has placed all air shipments on pause. Find a way to contact the customers whose orders require Air Freight and inform them of the delay.
use WideWorldImporters
select p.PurchaseOrderID, p.OrderDate, p.ContactPersonID 
	   ,d.DeliveryMethodName
from purchasing.PurchaseOrders as p
	inner join Application.DeliveryMethods as d
		on d.DeliveryMethodID = p.DeliveryMethodID
where d.DeliveryMethodName = N'Air Freight';

--COMPLEX 3 [inner join and left outer join. Custom Scalar function used.]
--Proposition: Get a list of supplierId, supplier name, delivery methodID, deliverymethodname. Include the suppliers with no delivery methodID. Create an updated column with the valid to with 5 years from the ValidFrom date.
use WideWorldImporters
go
create schema [MyFunc]
go

create function [MyFunc].[AddYears]
(
	@TheDate DATE,
	@NumOfYears INT
)
returns date
as
begin
	return dateadd (year, @NumOfYears, @TheDate)

end
go

use WideWorldImporters
select  distinct s.SupplierID, s.SupplierName, d.deliveryMethodID 
	    , d.DeliveryMethodName, d.validFrom, d.ValidTo, MyFunc.AddYears(d.ValidFrom, 5) AS updatedValidTo
	    , p.SupplierReference
from Purchasing.Suppliers as s
	 left outer join
		(Purchasing.PurchaseOrders as p
			inner join Application.DeliveryMethods as d
				on d.DeliveryMethodID = p.DeliveryMethodId)
	 on p.SupplierID = s.SupplierID

--COMPLEX 4 [3 tables joined. Group by. SQL Function: Count]
--Proposition: Find out which supplier and the delivery method that drive most number of orders. Include the suppliers who have not received any orders.
use WideWorldImporters
select  distinct s.SupplierID
	    , d.DeliveryMethodName
	    , count(p.PurchaseOrderID) as numOfOrders
from Purchasing.Suppliers as s
	 left outer join
		(Purchasing.PurchaseOrders as p
			inner join Application.DeliveryMethods as d
				on d.DeliveryMethodID = p.DeliveryMethodId)
	 on p.SupplierID = s.SupplierID
group by s.supplierID, d.DeliveryMethodName
order by numOfOrders desc




--EASY 5
--Proposition: Obtain first 200 orders and the stock items.
use WideWorldImportersDW
declare @topNumber as int = 200;

select top (@topNumber) o.[Order Key], O.[Stock Item Key], o.[Order Date Key], [Salesperson Key],
	   I.[Stock Item]
from fact.[order] as O
	inner join dimension.[Stock Item] as I
		on I.[Stock Item Key] = O.[Stock Item Key]
order by o.[Order Key];


