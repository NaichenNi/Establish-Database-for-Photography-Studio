1、	--recommend the information of photographer for customers
SELECT Photographers.phid,Photographers.name, Photographers.gender, Photographers.phone,Order_details.style
FROM Photographers, Orders, Order_details
WHERE Photographers.phid=Orders.phid
AND Orders.orderid=Order_details.orderid
GROUP BY Photographers.name
HAVING Order_details.style="cosplay"
ORDER BY COUNT(Orders.orderid)
LIMIT 0,5
;

2、	--query customers' name who takes photograph top five
SELECT Customers.name
FROM Customers, Order_Details, Orders
WHERE Orders.orderid=Order_Details.orderid
AND Orders.cusid=Customers.cusid
GROUP BY Customers.name
ORDER BY COUNT(Orders.orderid)
LIMIT 0,5
;

3、	--query order number for every month
SELECT COUNT(orderid)
FROM Order_Details
WHERE YEAR(starttime)=2016
AND MONTH(starttime)=12
;


4、 --query the latest order information
SELECT *
FROM Order_Details
WHERE orderid >= ALL(
	SELECT orderid
	FROM Order_Details)
;

5、--query information of photographers who took this type of pic before
CREATE VIEW CosplayPhoto(PhotographerName, NumofShot,style) AS
	SELECT Photographers.name, COUNT(Order_details.orderid),Order_details.style
	FROM Order_details, Photographers, Orders
	WHERE Orders.phid=Photographers.phid
	AND Order_details.orderid=Orders.orderid
	GROUP BY Photographers.name
	HAVING Order_details.style="cosplay"
	;

SELECT * FROM CosplayPhoto;


