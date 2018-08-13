
delimiter //
DROP PROCEDURE IF EXISTS sellanalysis;
create procedure sellanalysis(in id int,
out sum real,
out mean real,
out var real)
begin
declare movecount int;
declare newprice int;
declare done int default FALSE;
declare sellcursor cursor for
	select order_details.price from photographers , orders, order_details where photographers.phid=orders.phid and orders.orderID=order_details.orderID and photographers.phid=id and year(startime)=2017 and year(endtime)=2017;
declare continue handler for not found set done=TRUE;
	set mean=0;
	set var=0;
	set movecount=0;
	open sellcursor;
	sellloop:LOOP 
		fetch from sellcursor into newprice;
		if done then leave sellloop;
		else
		set mean=mean+newprice;
		set var=var+newprice*newprice;
		set movecount=movecount+1;		
		end if;
	end loop;
	close sellcursor;
	set sum=mean;
	set mean=mean/movecount;
	set var=var/movecount-mean*mean;
end //
delimiter ;


delimiter //
DROP function IF EXISTS expertph;
create function expertph(id int) returns varchar(100)
begin 
declare exphid varchar(100);
	set exphid=
	(select group_concat(phid) from (select phid from orders, order_details
	where orders.orderID=order_details.orderid and style in (select Favorite_style from customers where cusid=id)
	group by orders.phid
	having count(*)>=ALL(select count(*) from orders, order_details 
	where orders.orderID=order_details.orderid and style in (select Favorite_style from customers where cusid=id)
	group by orders.phid))expert);
return exphid; 
end //
delimiter ;



delimiter //
DROP function IF EXISTS expertcom;
create function expertcom(id int) returns varchar(100)
begin 
declare excomid varchar(100);
	set excomid=(select group_concat(comboid) from (select comboid from orders, order_details
	where orders.orderID=order_details.orderid and style in (select Favorite_style from customers where cusid=id)
	group by orders.comboid
	having count(*)>=ALL(select count(*) from orders, order_details 
	where orders.orderID=order_details.orderid and style in (select Favorite_style from customers where cusid=id)
	group by orders.comboid))expert);
return excomid; 
end //
delimiter ;



delimiter //
DROP PROCEDURE IF EXISTS changephlevel;
create procedure changephlevel(in pid int,in newlevel int) 
begin
update photographers set level=newlevel where phid=pid;
end //
delimiter ;


delimiter //
DROP PROCEDURE IF EXISTS addjustlevel;
create procedure addjustlevel() 
begin
	update photographers set level=2 where phid in (select phid from orders,order_details where orders.orderID=order_details.orderID group by orders.phid having count(*)>15);
	update photographers set level=3 where phid in (select phid from orders,order_details where orders.orderID=order_details.orderID group by orders.phid having count(*)>45);
end //
delimiter ;


delimiter //
DROP function IF EXISTS calcuprice;
create function calcuprice(newcus int(5), newph int(5),newcombo int(2)) returns int
begin
declare adprice int;
declare sumprice int;
declare alprice int;
declare cusschool varchar(50);
declare phschool varchar(50);
	set adprice= (select price from pricelist where comboid=newcombo and level in (select level from photographers where phid=newph));
	set sumprice= (select sum(price) from orders,order_details where orders.orderID=order_details.orderID and orders.cusid=newcus );
	if sumprice>=800 then set adprice= adprice*0.8;
	elseif sumprice>=600 and sumprice<800 then set adprice= adprice*0.85;
	elseif sumprice>=400 and sumprice<600 then set adprice= adprice*0.9;
	end if;
return alprice;
end //
delimiter ;


