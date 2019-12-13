create table stats
(
	id int primary key auto_increment,
    month tinyint,
    product_id nvarchar(10),
    num int,
    sum_of_payment double
);

drop procedure if exists sp_getPrdctByYear;
delimiter //
create procedure sp_getPrdctByYear(in name1 nvarchar(30), in name2 nvarchar(30))
begin 
	declare done boolean default 0;
    declare v_id varchar(10);
    
    declare getPr cursor for
		select id from buteegdehuun
		where name in(name1, name2);
	
	declare continue handler for not found set done = 1;
	open getPr;
    fetch getPr into v_id;
    while done = 0 do
		
		insert into stats(month, product_id, num, sum_of_payment)
		select dd.mon, b.id, dd.quan, (dd.quan*b.price) from buteegdehuun as b
		join 
			(
			select za.buteegdehuun_id, za.zahialga_id,z.purchasedate, sum(za.quantity) as quan, month(z.purchasedate) as mon from zahialsanbuteegdehuun as za
			join zahialga as z 
			on z.id = za.zahialga_id
            where year(z.purchasedate) = year(now()) and za.buteegdehuun_id = v_id
			group by za.buteegdehuun_id, mon
			) as dd
		on b.id = dd.buteegdehuun_id
		order by mon;
        
        fetch getPr into v_id;

    end while;
    close getPr;
end//
delimiter ;

truncate table stats;

call sp_getPrdctByYear('Jemper', 'Rivalry crew');

select * from stats;



drop procedure if exists sp_total;
delimiter //
create procedure sp_total()
begin 
	declare done boolean default 0;
    declare v_id varchar(11);
    declare t int;
    declare h int;
    declare getId cursor for 
		select id from zahialga
        where month(zahialga.purchasedate) = 10;#month(now());
    open getId;
    
    while done=0 do
		fetch getId into v_id;
		
        select total into t from temp
        where id = v_id;
    
		select hurgeltiin_tulbur into h from hurgelt
        join zahialga
        on zahialga.id = hurgelt.zahialga_id
        where zahialga.id = v_id;
        
        update tulbur 
        set total_price = t+h
        where zahialga_id = v_id;
        
        select distinct(total_price) into t
        from tulbur
        where zahialga_id = v_id;
        
        select sum(paid) into h
        from tulbur
        where zahialga_id = v_id
        group by zahialga_id;
        
        if t - h>0 then
			select concat(v_id," дугаартай захиалга ",t-h," төгрөгийн үлдэгдэлтэй") as info;
		end if;
        
        
    end while;
    close getId;
end//
delimiter ;

call sp_total();

