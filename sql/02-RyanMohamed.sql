--SIMPLE QUERIES-----------------------------

-- 01 // Return the 100 fastest fully completed work orders.
-- Database // AdventureWorks2017

-- use AdventureWorks2017
-- select top 100 WorkOrderID as workorderid,
--     datediff(day, StartDate, EndDate) as dayselapsed
-- from Production.[WorkOrder]
-- where OrderQty = StockedQty
-- order by daysElapsed asc, workorderid asc

-- 02 // Return the alternate key and product name of 
--       unique products sold in internet sales.
-- Database // AdventureWorksDW2017

-- use AdventureWorksDW2017
-- select distinct I.ProductKey as productkey,
--     P.ProductAlternateKey as alternatekey,
--     P.EnglishProductName as productname
-- from dbo.[FactInternetSales] as I
--     inner join 
--     dbo.[DimProduct] as P
--     on I.ProductKey = P.ProductKey
-- order by productkey asc

-- 03 // Return the employee title responsible
--       for each order, ordered by freight price.
-- Database // NorthWinds2022TSQLV7

-- use Northwinds2022TSQLV7
-- select O.OrderId as orderid, 
--     E.EmployeeTitle as title,
--     O.Freight as freight
-- from Sales.[Order] as O
--     inner join
--     HumanResources.[Employee] as E
--     on O.EmployeeId = E.EmployeeId
-- order by freight desc

-- 04 // Return the 10 products in stock
--       with the largest sale margin.
-- Database // WideWorldImporters

-- use WideWorldImporters
-- select top 10 StockItemId as itemid,
--     StockItemName as itemname,
--     RecommendedRetailPrice - UnitPrice as margin
-- from Warehouse.StockItems
-- order by margin desc

-- 05 // Return the total sales price
--       for each make of cars sold in 2018.
-- Database // PrestigeCarsOriginal

-- use PrestigeCarsOriginal
-- select MakeName as makename,
--     ModelName as modelname,
--     SUM(SalePrice) as totalsaleprice,
--     COUNT(ModelName) as qtysold
-- from DataTransfer.[Sales2018]
-- group by makename, modelname
-- order by totalsaleprice desc


--MEDIUM QUERIES-----------------------------

-- 01 // Return all scraped products with the reason they were scrapped
-- Database // AdventureWorks2017
-- Tables // WorkOrder, ScrapReason, Product

-- use AdventureWorks2017;

-- with Scrapped as (
--     select ScrappedQty as qty,
--         ScrapReasonID as reasonid,
--         ProductID as productid
--     from Production.[WorkOrder]
--     where ScrappedQty > 0 
-- ),
-- ScrappedProducts as (
--     select S.productid, P.[Name] as productname, S.qty, S.reasonid
--     from Scrapped as S inner join Production.[Product] as P
--         on S.productid = P.ProductID
-- )
-- select productname, productid, qty, SR.[Name] as reason
-- from ScrappedProducts as SP inner join Production.[ScrapReason] as SR
--     on SP.reasonid = SR.ScrapReasonID

-- 02 // Return the highest total orders for each store (not including online orders)
-- Database // AdventureWorks2017
-- Tables // SalesOrderHeader, Customer

-- use AdventureWorks2017;
-- with StoreCustomerOrder as (
--     select distinct SalesOrderID as orderid, 
--         CustomerID as custid,
--         TotalDue as total
--     from Sales.[SalesOrderHeader]
--     where OnlineOrderFlag = 0
-- ),
-- StoreCustomerOrderDetail as (
--     select C.StoreID as storeid, orderid, custid, total
--     from StoreCustomerOrder as CO inner join Sales.[Customer] as C
--         on CO.custid = C.CustomerID
-- )
-- select storeid, max(total) as maxtotal
-- from StoreCustomerOrderDetail as OD
-- group by storeid
-- order by maxtotal desc


-- 03 // Get the average income for customers in each city
-- Database // AdventureWorksDW2017
-- Tables // DimCustomer, DimGeography

-- use AdventureWorksDW2017;

-- with CustomerDetail as (
--     select C.CustomerKey as custid, 
--         concat(C.FirstName, ' ', C.LastName) as custname,
--         C.YearlyIncome as income, 
--         G.City as city
--     from dbo.[DimCustomer] as C inner join dbo.[DimGeography] as G
--     on C.GeographyKey = G.GeographyKey
-- )
-- select city, avg(income) as avgincome
-- from CustomerDetail
-- group by city
-- order by avgincome asc

-- 04 // Get the total internet sales amongst all sales territories with the region
-- Database // AdventureWorksDW2017
-- Tables // FactInternetSales, DimSalesTerritory

-- use AdventureWorksDW2017; 

-- with TotalSales as (
--     select sum(SalesAmount) as totalamount,
--         SalesTerritoryKey as territorykey
--     from dbo.[FactInternetSales]
--     group by SalesTerritoryKey
-- )
-- select T.SalesTerritoryRegion as region, totalamount
-- from TotalSales as S inner join dbo.[DimSalesTerritory] as T
--     on S.territorykey = T.SalesTerritoryKey

-- 05 // Get the total price (including discount) for each individual order going to the UK
-- Database // NorthWinds2020TSQL7
-- Tables // Order, OrderDetail

-- use Northwinds2022TSQLV7;

-- with UKOrder as (
--     select OrderId as orderid
--     from Sales.[Order]
--     where ShipToCountry like 'UK'
-- ),
-- UKProductTotal as (
--     select O.orderid, 
--         (1 - OD.DiscountPercentage) * (OD.UnitPrice * OD.Quantity) as producttotal,
--         OD.ProductId as productid
--     from UKOrder as O inner join Sales.OrderDetail as OD
--         on O.orderid = OD.OrderId
-- )
-- select orderid, sum(producttotal) as total
-- from UKProductTotal
-- group by orderid
-- order by orderid asc

-- 06 // Get the cheapest (in-production / not discontinued) product sold by each supplier
--    // and it's description
-- Database // NorthWinds2020TSQL7
-- Tables // Product, Category, Supplier 

-- use Northwinds2022TSQLV7;
 
-- --table of each suppliers cheapeast price
-- with Cheapest as (
--     select min(P.UnitPrice) as price,
--         S.SupplierId as supplierid
--     from Production.[Product] as P inner join Production.[Supplier] as S
--         on P.SupplierId = S.SupplierId and P.Discontinued = 0
--     group by S.SupplierId
-- ),
-- --adding product name and category id to table from above
-- CheapestCategory as ( 
--     select P.ProductName as productname, 
--         price, C.supplierid, 
--         P.CategoryId as categoryid
--     from Cheapest as C inner join Production.[Product] as P
--         on C.price = P.UnitPrice and C.supplierid = P.SupplierId
-- )
-- --adding description to table from above
-- select supplierid, productname, price, 
--     C.[Description] as productdesrc
-- from CheapestCategory as CC inner join Production.[Category] as C
--     on CC.categoryid = C.CategoryId
-- order by supplierid asc

-- 07 // Get the total amount of customer invoices each month
-- Database // WideWorldImporters
-- Tables // CustomerTransactions, TransactionTypes

-- use WideWorldImporters;

-- with Invoices as (
--     select CT.CustomerID as custid,
--         CT.TransactionAmount as amount,
--         month(CT.TransactionDate) as transactionmonth
--     from Sales.[CustomerTransactions] as CT inner join [Application].[TransactionTypes] as TT
--         on CT.TransactionTypeID = TT.TransactionTypeID and TT.TransactionTypeName = 'Customer Invoice'
-- )
-- select transactionmonth, sum(amount) as totalinvoice
-- from Invoices
-- group by transactionmonth
-- order by transactionmonth

-- 08 // Rank each stock item by percentage of total stock 
-- Database // WideworldImportersDW
-- Tables // Stock Holding, Stock Item

use WideWorldImportersDW;

with ItemQty as (
    select SI.[Stock Item Key] as itemkey,
        SI.[Stock Item] as itemname,
        SH.[Quantity On Hand] as qty
    from Dimension.[Stock Item] as SI inner join Fact.[Stock Holding] as SH
        on SI.[Stock Item Key] = SH.[Stock Item Key]
)
select itemkey, itemname, qty, 
    concat(
        round(100 * qty / cast((select sum([Quantity On Hand]) from Fact.[Stock Holding]) as float), 3),
        '%') as total
from ItemQty
order by total desc