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

