delimiter //


create procedure getUserByPrchsSum(in price int , in date1 date, in date2 date)
begin 
	select * from hereglegch as h 
	where h.id in(
		select z.hereglegch_id from zahialga as z
		inner join 
			(select za.zahialga_id, sum(za.quantity*b.price) as Niit 
			 from zahialsanbuteegdehuun as za
			 inner join buteegdehuun as b 
			 on za.buteegdehuun_id = b.id
			 group by za.zahialga_id) as dd
		on z.id = dd.zahialga_id
		where z.purchasedate between date1 and date2
		group by z.hereglegch_id
		having sum(dd.Niit) > price
	);
end//

delimiter ;

delimiter //

create procedure getMostShippedZone()
begin 
	select du.duureg, dd.hurgelt from duureg as du
	join 
		(
		select h1.duureg_id, count(h1.id) as hurgelt from hayag as h1
		join zahialga as z1
		on z1.hayag_id = h1.id
		group by h1.duureg_id
		having hurgelt in
			(
			select max(inner1.maxHurgelt) as max from
				(
				select count(ha.id) as maxHurgelt from hayag as ha
				join zahialga as z
				on z.hayag_id = ha.id
				group by ha.duureg_id
				) as inner1
			)
		) as dd
	where du.id = dd.duureg_id ;
end //

create procedure getReturnRate(out rate float(99,2))
begin 

	select ((count(butsaalt.id)/z.zahialgaCount)*100) into rate from butsaalt,
		(
		select count(id) as zahialgaCount from zahialga
		where year(purchasedate)=year(now())    
		) as z
	where year(date)=year(now());

end//

delimiter ;

delimiter //

create procedure getPrdctQuanByMon()
begin 
	select b.id, b.name, dd.mon, dd.quan from buteegdehuun as b
	join 
		(
		select za.buteegdehuun_id, sum(za.quantity) as quan, month(z.purchasedate) as mon from zahialsanbuteegdehuun as za
		join zahialga as z 
		on z.id = za.zahialga_id
		group by za.buteegdehuun_id, mon
		) as dd
	on b.id = dd.buteegdehuun_id
	order by mon;
end//





create procedure getOtherPrdctFromUser(in product varchar(100))
begin 
	select b.name, inner2.too from buteegdehuun as b
	join 
		(
		select za.buteegdehuun_id, sum(za.quantity) as too from zahialsanbuteegdehuun as za
		where za.zahialga_id in
			(
			select z.id from zahialga as z
			join 
				(
				select z.hereglegch_id from zahialga as z
				where z.id in
					(
					select za.zahialga_id from buteegdehuun as b
					join zahialsanbuteegdehuun as za
					on b.id = za.buteegdehuun_id
					where b.name = product
					)
				) as inner1
			on z.hereglegch_id =  inner1.hereglegch_id
			)
		group by za.buteegdehuun_id
		) as inner2
	on b.id = inner2.buteegdehuun_id
	where not b.name=product;
end //

create procedure getProductByMonth(in mon varchar(2))
begin 
	select * from buteegdehuun
	where buteegdehuun.price < 
	(
	select b.price from buteegdehuun as b
	right join
		(
		select inner1.buteegdehuun_id, max(inner1.too) as maxtoo from
			(
			select za.buteegdehuun_id, sum(za.quantity) as too from zahialsanbuteegdehuun as za
			left join zahialga as z
			on za.zahialga_id = z.id
			where month(z.purchasedate)=mon 
			group by za.buteegdehuun_id
			) as inner1
		) as inner2
	on b.id = inner2.buteegdehuun_id
    );
end//

create procedure zones(in date1 date)
begin
	select hot.hot, duureg.duureg, horoo.horoo, inner2.toot from hot 
	join 
		(
		select hot_id, duureg_id, horoo_id, inner1.toot  from hayag
		right join 
			(
			select z.hayag_id, z.toot from zahialga as z 
			left join hurgelt as h
			on z.id = h.zahialga_id
			where h.id is null 
			union
			select z.hayag_id, z.toot from zahialga as z
			join hurgelt as h
			on z.id = h.zahialga_id
			where h.date not between z.purchasedate and date
			) as inner1
		on hayag.id = inner1.hayag_id
		) as inner2
	on hot.id = inner2.hot_id
	join duureg on duureg.id = inner2.duureg_id
	join horoo on  horoo.id = inner2. horoo_id;
end//



create procedure userPayment()
begin
	select h.id, h.phone, inner1.id, inner1.purchasedate, inner1.uldegdel
	from hereglegch as h
	join 
		(
		select distinct z.hereglegch_id, z.id, z.purchasedate, (t.total_price - tt.paid) as uldegdel 
		from tulbur as t
		join zahialga as z
		on t.zahialga_id = z.id
		join
			(
			select zahialga_id, sum(paid) as paid from tulbur 
			group by zahialga_id
			) as tt
		on tt.zahialga_id = z.id
		where t.paid < t.total_price or t.paid is null
		) as inner1
	on h.id = inner1.hereglegch_id;
end //





drop procedure if exists total_price;
delimiter //

create procedure total_price(in id varchar(11), out total decimal)
begin
			select if(d.purchasedate >= hungulult.start_date and d.purchasedate <= hungulult.end_date, 
				sum((b.price*hungulult.discount/100)*d.quantity), 
                sum(b.price*d.quantity)) into total 
                from buteegdehuun as b
				join 
					(
					select z.purchasedate, za.* from zahialga as z
					inner join zahialsanbuteegdehuun as za 
					on z.id = za.zahialga_id
					where za.zahialga_id = id
					) as d
				on b.id = d.buteegdehuun_id
				join hungulult 
				on b.id = hungulult.buteegdehuun_id;
	
end //

delimiter ;


call total_price('1909080001', @total);
select (@total);

select * from zahialsanbuteegdehuun;
select * from zahialga;

select * from hungulult;
select * from buteegdehuun;

drop procedure if exists product;
delimiter //

create procedure product(in pName varchar(10) , out pText varchar(30))
begin
    declare t int default 0;
		select sum(quantity) into t 
        from zahialsanbuteegdehuun
        join buteegdehuun 
        on buteegdehuun.id = zahialsanbuteegdehuun.buteegdehuun_id
        where buteegdehuun.name = pName;
			
		case 
			when t<10 then
				set pText = 'борлуулалт муутай бараа';
			when t>=10 and t<=50 then
				set pText = 'эрэлт дунд зэрэг';
			when t>50 then
				set pText = 'эрэлт их';
			else 
				set pText= 'байхгүй';
		end case;
end //

delimiter ;


call product('Jemper',@t);
select(@t);

drop procedure if exists delivery_price;
delimiter //
create procedure delivery_price()
begin 
	declare done boolean default 0;
	declare t int;
    declare p int;
    declare i varchar(11);
    
    declare getPrice cursor for
		select total, id from temp;
	
	declare continue handler for not found set done = 1;
	#call tmp();
	open getPrice;
    while done = 0 do
		#select done;
		fetch getPrice into t, i;
		
		if t>200000 then
			update hurgelt
			set hurgeltiin_tulbur = 0
			where zahialga_id = i;
		elseif t<200000 then
			select hayag.price into p from zahialga 
			join hayag 
			on zahialga.hayag_id = hayag.id
			where zahialga.id = i;
			update hurgelt 
			set hurgeltiin_tulbur = p
			where hurgelt.zahialga_id = i;
		end if;
    end while;
    close getPrice;
end//
delimiter ;

call delivery_price();

select * from hurgelt;

drop procedure if exists payment;
delimiter //
create procedure payment()
begin
	declare done boolean default 0;
	declare t int;
    declare p int;

    declare c float;

	select count(distinct(zahialga_id)) into t from tulbur;

	select count(distinct(q.uldegdel)) into p
	from
		(
		select total_price - sum(paid) as uldegdel
		from tulbur
		group by zahialga_id
		) as q
	where q.uldegdel > 30000;
    
    set c = p/t*100;
    select c;
end //
delimiter ;

call payment();

select * from tulbur;

drop procedure if exists tmp;
delimiter //
create procedure tmp()
begin
	declare t int;
    declare i varchar(11);
    declare done int default 0;
    declare c_t cursor for
    
    select if(d.purchasedate >= hungulult.start_date and d.purchasedate <= hungulult.end_date, 
				sum((b.price*(100-hungulult.discount)/100)*d.quantity), 
                sum(b.price*d.quantity)) as total, d.zahialga_id as id
                from buteegdehuun as b
				join 
					(
					select z.purchasedate, za.* from zahialga as z
					inner join zahialsanbuteegdehuun as za 
					on z.id = za.zahialga_id
					) as d
				on b.id = d.buteegdehuun_id
				left join hungulult 
				on b.id = hungulult.buteegdehuun_id
                group by d.zahialga_id;
	declare continue handler for not found set done = 1;
    open c_t;
    
    while done = 0 do
		fetch c_t into t, i;
        
        update tulbur 
        set total_price = t
		where zahialga_id = i;
	end while;
    close c_t;
                
end//
delimiter ;

call tmp;

select * from tulbur;


delimiter //

create procedure getOrders()
begin 
	select * from zahialga;
end//

delimiter ;

call getOrders();

drop procedure if exists getOrders;


delimiter //

create procedure getProductByMonth(in mon varchar(2))
begin 
	select * from buteegdehuun
	where buteegdehuun.price < 
	(
	select b.price from buteegdehuun as b
	right join
		(
		select inner1.buteegdehuun_id, max(inner1.too) as maxtoo from
			(
			select za.buteegdehuun_id, sum(za.quantity) as too from zahialsanbuteegdehuun as za
			left join zahialga as z
			on za.zahialga_id = z.id
			where month(z.purchasedate)=mon 
			group by za.buteegdehuun_id
			) as inner1
		) as inner2
	on b.id = inner2.buteegdehuun_id
    );
end//

delimiter ;

drop procedure getProductByMonth;

call getProductByMonth('10');



delimiter //

create procedure getReturnRate(out rate float(99,2))
begin 


select ((count(butsaalt.id)/z.zahialgaCount)*100) into rate from butsaalt,
	(
	select count(id) as zahialgaCount from zahialga
	where year(purchasedate)=year(now())    
    ) as z
where year(date)=year(now());

end//

delimiter ;

drop procedure getReturnRate;

call getReturnRate(@rate);
select @rate;



DELIMITER $$
 
CREATE PROCEDURE SetCounter(
    INOUT counter INT
)
BEGIN
	declare inc int;
    set inc = 1;
    SET counter = counter + inc;
    
    select counter;
END$$
 
DELIMITER ;



SET @counter = 1;

select @lol := 1;

CALL SetCounter(@counter); 
#scoping @counter





select z.id, b.name, b.price, za.quantity, h.start_date, h.end_date, h.discount, t.total_price, t.paid  from zahialga as z
join zahialsanbuteegdehuun as za
on z.id = za.zahialga_id
join buteegdehuun as b
on za.buteegdehuun_id = b.id
left join hungulult as h
on h.buteegdehuun_id = b.id
left join tulbur as t 
on t.zahialga_id = z.id
order by z.id;

select z.id, if(z.purchasedate>=h.start_date and z.purchasedate<=h.end_date ,sum(b.price*(100-h.discount)/100*za.quantity), sum(b.price*za.quantity)), t.total_price, sum(t.paid)  from zahialga as z
join zahialsanbuteegdehuun as za
on z.id = za.zahialga_id
join buteegdehuun as b
on za.buteegdehuun_id = b.id
left join hungulult as h
on h.buteegdehuun_id = b.id
left join tulbur as t 
on t.zahialga_id = z.id
group by z.id
order by z.id;





