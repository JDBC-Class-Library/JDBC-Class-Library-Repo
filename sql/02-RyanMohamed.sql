-- SIMPLE QUERIES -----------------------------


-- 01 // Return the 100 fastest fully completed work orders.
-- Database // AdventureWorks2017

use AdventureWorks2017
select top 100
    WorkOrderID as workorderid,
    datediff(day, StartDate, EndDate) as dayselapsed
from Production.[WorkOrder]
where OrderQty = StockedQty
order by daysElapsed asc,
         workorderid asc

-- 02 // Return the alternate key and product name of 
--       unique products sold in internet sales.
-- Database // AdventureWorksDW2017

use AdventureWorksDW2017
select distinct
    I.ProductKey as productkey,
    P.ProductAlternateKey as alternatekey,
    P.EnglishProductName as productname
from dbo.[FactInternetSales] as I
    inner join dbo.[DimProduct] as P
        on I.ProductKey = P.ProductKey
order by productkey asc

-- 03 // Return the employee title responsible
--       for each order, ordered by freight price.
-- Database // NorthWinds2022TSQLV7

use Northwinds2022TSQLV7;

select O.OrderId as orderid,
       E.EmployeeTitle as title,
       O.Freight as freight
from Sales.[Order] as O
    inner join HumanResources.[Employee] as E
        on O.EmployeeId = E.EmployeeId
order by freight desc

-- for json path, root('OrderEmployeeTitle'), include_null_values

-- 04 // Return the 10 products in stock
--       with the largest sale margin.
-- Database // WideWorldImporters

use WideWorldImporters
select top 10
    StockItemId as itemid,
    StockItemName as itemname,
    RecommendedRetailPrice - UnitPrice as margin
from Warehouse.StockItems
order by margin desc

-- 05 // Return the total sales price
--       for each make of cars sold in 2018.
-- Database // PrestigeCarsOriginal

use PrestigeCarsOriginal
select MakeName as makename,
       ModelName as modelname,
       SUM(SalePrice) as totalsaleprice,
       COUNT(ModelName) as qtysold
from DataTransfer.[Sales2018]
group by makename,
         modelname
order by totalsaleprice desc
-- for json path, root('MakeTotalSalesPrice'), include_null_values

-- 05 CORRECTED // Return the total sales price
--       for each make of cars sold in 2018.
-- Database // PrestigeCarsOriginal

use PrestigeCarsOriginal
select MakeName as makename,
       SUM(SalePrice) as totalsaleprice
from DataTransfer.[Sales2018]
group by makename
order by totalsaleprice desc
for json path, root('MakeTotalSalesPrice'), include_null_values


-- MEDIUM QUERIES -----------------------------


-- 01 // Return all scrapped product names with the reason they were scrapped
-- Database // AdventureWorks2017
-- Tables // WorkOrder, ScrapReason, Product

use AdventureWorks2017;
with Scrapped
as (select ScrappedQty as qty,
           ScrapReasonID as reasonid,
           ProductID as productid
    from Production.[WorkOrder]
    where ScrappedQty > 0
   ),
     ScrappedProducts
as (select S.productid,
           P.[Name] as productname,
           S.qty,
           S.reasonid
    from Scrapped as S
        inner join Production.[Product] as P
            on S.productid = P.ProductID
   )
select productname,
       productid,
       qty,
       SR.[Name] as reason
from ScrappedProducts as SP
    inner join Production.[ScrapReason] as SR
        on SP.reasonid = SR.ScrapReasonID
order by qty desc
for json path, root('ScrappedProductReasons'), include_null_values

-- 01 CORRECTED // Return all scraped products with the reason they were scrapped
-- Database // AdventureWorks2017
-- Tables // WorkOrder, ScrapReason, Product

use AdventureWorks2017;
with ScrappedProducts
as (select P.[Name] as productname,
           O.ProductID as productid,
           O.ScrapReasonID as reasonid,
           O.ScrappedQty as qty
    from Production.[WorkOrder] as O
        inner join Production.[Product] as P
            on O.ProductID = P.ProductID
               AND O.ScrappedQty > 0
   )
select productname,
       productid,
       qty,
       SR.[Name] as reason
from ScrappedProducts as SP
    inner join Production.[ScrapReason] as SR
        on SP.reasonid = SR.ScrapReasonID
order by qty desc
for json path, root('ScrappedProductReasons'), include_null_values

-- 02 // Return the highest total orders for each store (not including online orders)
-- Database // AdventureWorks2017
-- Tables // SalesOrderHeader, Customer

use AdventureWorks2017;
with StoreCustomerOrder
as (select distinct
        SalesOrderID as orderid,
        CustomerID as custid,
        TotalDue as total
    from Sales.[SalesOrderHeader]
    where OnlineOrderFlag = 0
   ),
     StoreCustomerOrderDetail
as (select C.StoreID as storeid,
           orderid,
           custid,
           total
    from StoreCustomerOrder as CO
        inner join Sales.[Customer] as C
            on CO.custid = C.CustomerID
   )
select storeid,
       max(total) as maxtotal
from StoreCustomerOrderDetail as OD
group by storeid
order by maxtotal desc

-- 03 // Get the average income for customers in each city
-- Database // AdventureWorksDW2017
-- Tables // DimCustomer, DimGeography

use AdventureWorksDW2017;

with CustomerDetail
as (select C.CustomerKey as custid,
           concat(C.FirstName, ' ', C.LastName) as custname,
           C.YearlyIncome as income,
           G.City as city
    from dbo.[DimCustomer] as C
        inner join dbo.[DimGeography] as G
            on C.GeographyKey = G.GeographyKey
   )
select city,
       avg(income) as avgincome
from CustomerDetail
group by city
order by avgincome asc

-- 04 // Get the total internet sales amongst all sales territories with the region
-- Database // AdventureWorksDW2017
-- Tables // FactInternetSales, DimSalesTerritory

use AdventureWorksDW2017;

with TotalSales
as (select sum(SalesAmount) as totalamount,
           SalesTerritoryKey as territorykey
    from dbo.[FactInternetSales]
    group by SalesTerritoryKey
   )
select T.SalesTerritoryRegion as region,
       totalamount
from TotalSales as S
    inner join dbo.[DimSalesTerritory] as T
        on S.territorykey = T.SalesTerritoryKey

-- 05 // Get the total price (including discount) for each individual order going to the UK
-- Database // NorthWinds2020TSQL7
-- Tables // Order, OrderDetail

use Northwinds2022TSQLV7;

with UKOrder
as (select OrderId as orderid
    from Sales.[Order]
    where ShipToCountry like 'UK'
   ),
     UKProductTotal
as (select O.orderid,
           (1 - OD.DiscountPercentage) * (OD.UnitPrice * OD.Quantity) as producttotal,
           OD.ProductId as productid
    from UKOrder as O
        inner join Sales.OrderDetail as OD
            on O.orderid = OD.OrderId
   )
select orderid,
       cast(sum(producttotal) as money) as total
from UKProductTotal
group by orderid
order by total desc

-- 06 // Get the cheapest (in-production / not discontinued) product sold by each supplier
--    // and it's description
-- Database // NorthWinds2020TSQL7
-- Tables // Product, Category, Supplier 

use Northwinds2022TSQLV7;

--table of each suppliers cheapeast price
with Cheapest
as (select min(P.UnitPrice) as price,
           S.SupplierId as supplierid
    from Production.[Product] as P
        inner join Production.[Supplier] as S
            on P.SupplierId = S.SupplierId
               and P.Discontinued = 0
    group by S.SupplierId
   ),
     --adding product name and category id to table from above
     CheapestCategory
as (select P.ProductName as productname,
           price,
           C.supplierid,
           P.CategoryId as categoryid
    from Cheapest as C
        inner join Production.[Product] as P
            on C.price = P.UnitPrice
               and C.supplierid = P.SupplierId
   )
--adding description to table from above
select supplierid,
       productname,
       price,
       C.[Description] as productdesrc
from CheapestCategory as CC
    inner join Production.[Category] as C
        on CC.categoryid = C.CategoryId
order by supplierid asc

-- 07 // Get the total amount of customer invoices each month
-- Database // WideWorldImporters
-- Tables // CustomerTransactions, TransactionTypes

use WideWorldImporters;

with Invoices
as (select CT.CustomerID as custid,
           CT.TransactionAmount as amount,
           month(CT.TransactionDate) as transactionmonth
    from Sales.[CustomerTransactions] as CT
        inner join [Application].[TransactionTypes] as TT
            on CT.TransactionTypeID = TT.TransactionTypeID
               and TT.TransactionTypeName = 'Customer Invoice'
   )
select transactionmonth,
       sum(amount) as totalinvoice
from Invoices
group by transactionmonth
order by transactionmonth

-- 08 // Rank each stock item by percentage of total stock 
-- Database // WideworldImportersDW
-- Tables // Stock Holding, Stock Item

use WideWorldImportersDW;

with ItemQty
as (select SI.[Stock Item Key] as itemkey,
           SI.[Stock Item] as itemname,
           SH.[Quantity On Hand] as qty
    from Dimension.[Stock Item] as SI
        inner join Fact.[Stock Holding] as SH
            on SI.[Stock Item Key] = SH.[Stock Item Key]
   )
select itemkey,
       itemname,
       qty,
       concat(round(   100 * qty / cast(
                                   (
                                       select sum([Quantity On Hand]) from Fact.[Stock Holding]
                                   ) as float),
                       3
                   ),
              '%'
             ) as total
from ItemQty
order by total desc


-- COMPLEX QUERIES -----------------------------


-- 01 // Return the sales person responsible for the most expensive order in each state
-- Database // WideworldImportersDW
-- Tables // Employee, City, Order

use WideWorldImportersDW;

drop function if exists Dimension.stateMaxTotal
go

create function Dimension.stateMaxTotal (@state as varchar(50))
returns TABLE
as return
select distinct
    C.[State Province] as stateprovince,
    max(O.[Total Including Tax]) as maxtotal
from Fact.[Order] as O
    inner join Dimension.City as C
        on O.[City Key] = C.[City Key]
           and C.[State Province] = @state
group by C.[State Province]
go

with StateOrders
as (select [Order Key] as orderkey,
           C.[State Province] as stateprovince,
           O.[Total Including Tax] as total
    from Fact.[Order] as O
        inner join Dimension.City as C
            on O.[City Key] = C.[City Key]
   )
select *
from StateOrders

-- 02 // Return the states of customers who have placed an order
-- Database // WideworldImporters
-- Tables // Customers, State, City, Order

use WideWorldImporters;

drop view if exists Sales.OrderCustomers
go

create view Sales.OrderCustomers
as
select C.CustomerID as custid
from Sales.Customers as C
where C.CustomerID in (
                          select O.CustomerID
                          from Sales.[Orders] as O
                              inner join Sales.Customers as C
                                  on O.CustomerID = C.[CustomerID]
                      )
go

drop function if exists [Application].GetState
go

create function [Application].GetState (@custid as int)
returns TABLE
as return
select S.StateProvinceName as [state]
from Sales.Customers as C
    inner join [Application].Cities as CC
        on C.PostalCityID = CC.CityID
           AND C.CustomerID = @custid
    inner join [Application].StateProvinces as S
        on CC.StateProvinceID = S.StateProvinceID

go

select *
from Sales.OrderCustomers as OC
    cross apply [Application].[GetState](OC.custid)


-- 03 // Return the primary contacts full name and phone number 
--       for suppliers who had more than 5 transactions over $100000
-- Database // WideworldImporters
-- Tables // SupplierTransaction, Suppliers, People

use WideWorldImporters;

drop view if exists Sales.FiveTransactions
go

create view Sales.FiveTransactions
as
select SupplierID as supplierid,
       count(SupplierTransactionID) as transactions
from Purchasing.SupplierTransactions as ST
where TransactionAmount > 10000
group by SupplierID
go

select T.supplierid,
       P.FullName as contact,
       P.PhoneNumber as phone
from Sales.FiveTransactions as T
    left outer join Purchasing.Suppliers as S
        on T.supplierid = S.SupplierID
    left outer join [Application].People as P
        on S.PrimaryContactPersonID = P.PersonID

-- 04 // Return each customers 3 most recent recieved payments
-- Database // WideworldImportersDW
-- Tables // TransactionType, Transaction, Customer

use WideWorldImportersDW

drop function if exists Dimension.Get3RecentRecievedPayments
go

create function Dimension.Get3RecentRecievedPayments (@custid as int)
returns TABLE
as return
select top 3
    T.[Transaction Key] as transactionkey,
    T.[Customer Key] as custkey,
    T.[Date Key] as [date]
from Fact.[Transaction] as T
where T.[Customer Key] = @custid
      and T.[Transaction Type Key] IN (
                                          select TT.[Transaction Type Key]
                                          from Dimension.[Transaction Type] as TT
                                          where TT.[Transaction Type] = N'Customer Payment Received'
                                      )
order by T.[Date Key] desc
go

select C.Customer as [name],
       D.[date],
       D.transactionkey
from Dimension.Customer as C
    cross apply Dimension.Get3RecentRecievedPayments(C.[Customer Key]) as D

-- 04 CORRECTED // Return each customers 3 most recent recieved payments
-- Database // WideworldImportersDW
-- Tables // TransactionType, Transaction, Customer

use WideWorldImportersDW

drop function if exists Dimension.Get3RecentRecievedPayments
go

create function Dimension.Get3RecentRecievedPayments (@custid as int)
returns TABLE
as return
select top 3
    T.[Transaction Key] as transactionkey,
    TT.[Transaction Type] as [type],
    T.[Customer Key] as custkey,
    T.[Date Key] as [date]
from Fact.[Transaction] as T
    inner join Dimension.[Transaction Type] as TT
        on T.[Customer Key] = @custid
           and T.[Transaction Type Key] = TT.[Transaction Type Key]
           and TT.[Transaction Type] = N'Customer Payment Received'
order by T.[Date Key] desc
go

select C.Customer as [name],
       D.[date],
       D.transactionkey,
       D.[type]
from Dimension.Customer as C
    cross apply Dimension.Get3RecentRecievedPayments(C.[Customer Key]) as D
for json path, root('3RecentRecivedPayments'), include_null_values


-- 05 // Rank the orders for Northwest cities by number of cars
--       owned by the customer, using yearly income as a tiebreaker
-- Database // AdventureWorksDW2017
-- Tables // DimCustomer, FactInternetSales, DimSalesTerritory

use AdventureWorksDW2017

drop function if exists dbo.GetCarsAndIncome
go

create function dbo.GetCarsAndIncome (@custid as int)
returns TABLE
as return
select concat(FirstName, ' ', LastName) as [name],
       CustomerKey as custkey,
       YearlyIncome as yrincome,
       NumberCarsOwned as numcars
from dbo.DimCustomer as C
where CustomerKey = @custid
go

drop view if exists dbo.NorthwestInternetSales
go

create view dbo.NorthwestInternetSales
as
select distinct
    CustomerKey as custkey,
    SalesOrderNumber as salesordernum,
    SalesTerritoryKey as territorykey
from dbo.FactInternetSales
where SalesTerritoryKey =
(
    select T.SalesTerritoryKey
    from dbo.DimSalesTerritory as T
    where T.SalesTerritoryRegion = N'Northwest'
)
go

select CI.[name],
       NW.custkey,
       NW.salesordernum,
       CI.numcars,
       CI.yrincome,
       row_number() over (order by numcars desc, yrincome desc) as [rank]
from dbo.NorthwestInternetSales as NW
    cross apply dbo.GetCarsAndIncome(NW.custkey) as CI
for json path, root('NorthWestInternetSalesCars'), include_null_values

-- 06 // Assuming every applicable order used available discounts, 
--       find the price of the orders after the discount
-- Database // WideWorldImporters
-- Tables // StockItemStockGroups, OrderLines, Orders, SpecialDeals

use WideWorldImporters;

drop function if exists dbo.getStockGroups
go

create function dbo.getStockGroups (@stockid as int)
returns table
as return
select distinct
    StockGroupID as stockgroupid
from Warehouse.StockItemStockGroups
where StockItemID in (
                         select StockGroupID = @stockid
                     )
go


drop view if exists dbo.OrdersDuringSpecial
go

create view OrdersDuringSpecial
as
select distinct
    OL.OrderID as orderid,
    OL.StockItemID as stockitemid,
    OL.Quantity * OL.UnitPrice as total
from Sales.OrderLines as OL
where OL.OrderID in (
                        select O.OrderID
                        from Sales.Orders as O
                            inner join Sales.SpecialDeals as S
                                on O.OrderDate >= S.StartDate
                                   and O.OrderDate <= S.EndDate
                    )
go

select O.orderid,
       O.total,
       SD.DiscountPercentage as discount,
       (1 - (SD.DiscountPercentage / 100)) * O.total as discounttotal,
       SD.SpecialDealID as discountid,
       SG.stockgroupid
from dbo.OrdersDuringSpecial as O
    cross apply dbo.getStockGroups(stockitemid) as SG
    cross apply Sales.SpecialDeals as SD
where SG.stockgroupid in (
                             select StockGroupID from Sales.SpecialDeals
                         )
order by total desc


-- 07 // 
-- Database // 
-- Tables //