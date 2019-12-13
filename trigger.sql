#buteegdehuunii toog hasah

delimiter //
create trigger prodQuan
after insert 
	on zahialsanbuteegdehuun
for each row
begin
	declare b_id varchar(7);
    declare b_qu int;
    declare quan int;
    
    set b_id = new.buteegdehuun_id;
    set b_qu = new.quantity;
    select quantity into quan from buteegdehuun where id = b_id;
    
    IF (quan >= b_qu) then
    
		update buteegdehuun
        set quantity = quan - b_qu
        where id = b_id;
    end if;
end //
delimiter ;

INSERT INTO `onlineshop`.`zahialga` (`id`, `hayag_id`, `hereglegch_id`, `toot`) VALUES ('1912090001', '1', '190810005', '55-55');

INSERT INTO `onlineshop`.`zahialsanbuteegdehuun` (`id`, `zahialga_id`, `buteegdehuun_id`, `quantity`) VALUES ('1912090001', '1912090001', 'T190801', '10');

select * from buteegdehuun;


#buteegdehuun toog nemeh 
drop trigger prodQuanM;
delimiter //
create trigger prodQuanM
before delete on zahialga
for each row
begin
	declare b_id varchar(7);
    declare b_qu int;
    
    declare done int default 0;
    declare c_c cursor for select buteegdehuun_id, quantity from zahialsanbuteegdehuun
    where zahialga_id = old.id;
    declare continue handler for not found set done = 1;
    open c_c;
    fetch c_c into b_id, b_qu;
    while done = 0 do 
		
		
		update buteegdehuun
        set quantity = quantity+b_qu
        where id = b_id;
        fetch c_c into b_id, b_qu;
    end while;
		
    close c_c;
end //
delimiter ;

delete from zahialga where id = '1912090001';

select * from buteegdehuun;



#price log

create table PriceLog (
	product_id varchar(7),
    size varchar(10),
    color_id int,
    oldPrice int,
    newPrice int,
    logDate date,
    logUser varchar(25)
);

delimiter //
create trigger priceLg
before update 
	on buteegdehuun
for each row
begin 
	
    declare olPrice, nwPrice, color int;
    declare p_id varchar(7);
    declare sz varchar(10);
    set olPrice = old.price;
    set nwPrice = new.price;
    set p_id = new.id;
    select size.size into sz from buteegdehuun
    join size on buteegdehuun.size_id = size.id
    where buteegdehuun.id = p_id;
    select ungu.id into color from buteegdehuun
    join ungu on buteegdehuun.ungu_id = ungu.id
    where buteegdehuun.id = p_id;
    
    insert into PriceLog values
    (
    p_id, sz, color, olPrice, nwPrice, now(), current_user()
    );
end //
delimiter ; 

update buteegdehuun 
set price = 89000
where id = 'T190801';

select * from pricelog;







