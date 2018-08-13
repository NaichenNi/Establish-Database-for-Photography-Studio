#create tables
CREATE TABLE Customers
(cusid INT(5),
name VARCHAR(30),
gender ENUM('F','M'),
birth DATE,
school VARCHAR(50),
address VARCHAR(50),
phone VARCHAR(20),
wechat VARCHAR(30),
favorite_style VARCHAR(30),
PRIMARY KEY (cusid)
);
CREATE TABLE Photographers
(phid INT(5),
name VARCHAR(30),
gender ENUM('F','M'),
birth DATE,
school VARCHAR(50),
address VARCHAR(50),
phone VARCHAR(20),
wechat VARCHAR(30),
level INT(1),
PRIMARY KEY (phid)
);
CREATE TABLE Orders
(cusid INT(5),
phid INT(5),
comboid INT(2),
orderid INT(11),
PRIMARY KEY (orderid)
);
CREATE TABLE Order_details
(orderid INT(11),
price INT(4),
location VARCHAR(50),
starttime DATETIME,
endtime DATETIME,
score INT(2),
PRIMARY KEY (orderid)
);
CREATE TABLE Combos
(comboid INT(2),
comboname VARCHAR(30),
customernum varchar(10),
makeup ENUM('yes','no'),
costume ENUM('yes','no'),
props ENUM('yes','no'),
photonum int(2),
PRIMARY KEY (comboid)
);
CREATE TABLE Pricelist
(comboid INT(2),
level INT(1),
price INT(4),
PRIMARY KEY(comboid, level)
);

# add foreign key for table orders

alter table orders add foreign key (cusid) references customers (cusid);
alter table orders add foreign key (phid) references photographers (phid);
alter table orders add foreign key (comboid) references combos (comboid);

# add foreign key for table pricelist, so the attribute comboid, level are both primary key and foreign key

alter table pricelist add foreign key (comboid) references combos (comboid);
