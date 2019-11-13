alter table zahialga modify purchasedate datetime default now();

insert into zahialga (id, hayag_id, hereglegch_id) values (1, 1, 1);

alter table zahialga drop foreign key fk_zahilalga_hereglegch1;

alter table zahialga 
add constraint fk_zahialga_hereglegch
foreign key (hereglegch_id)
references hereglegch(id)
on update cascade;

delete from zahialga where hereglegch_id = 1;

select * from zahialga;

select * from duureg;


alter table unelgee
alter column rating set default 5;

alter table hereglegch 
add constraint u_phone
	unique (phone);
    
alter table hereglegch
add constraint u_email
	unique (email);

alter table ajiltan 
add constraint a_phone 
	unique (phone);
    
alter table butsaalt drop foreign key fk_butsaalt_cause1;
    
alter table cause modify id int not null auto_increment;

alter table butsaalt modify cause_id int not null auto_increment;

alter table hayag modify hot_id int not null;

alter table duureg modify id int not null auto_increment;

alter table butsaalt
add constraint fk_butsaalt_cause1
foreign key (cause_id)
references cause(id)
on update cascade;

alter table hayag 
add constraint fk_hayag_hot
foreign key (hot_id)
references hot(id);

alter table hayag
add constraint fk_butsaalt_horoo
foreign key (horoo_id)
references horoo(id)
on update cascade;

alter table hayag
add constraint fk_butsaalt_duureg
foreign key (duureg_id)
references duureg(id)
on update cascade;


alter table categorybuteegdehuun
add constraint fk_categorybuteegdehuun_category
foreign key (category_id)
references category(id)
on update cascade;

alter table category modify id int not null auto_increment;

rename table ajlltan_lavlah to ajiltan_lavlah;

alter table ajiltan drop column ajlltan_lavlah_id;

alter table ajiltan_lavlah modify id varchar(1) not null;

alter table ajiltan add column ajiltan_lavlah_id varchar(1) not null,
add constraint fk_ajiltan_ajiltan_lavlah
foreign key (ajiltan_lavlah_id)
references ajiltan_lavlah(id)
on update cascade;

alter table ajiltan modify id varchar(9) not null;

alter table butsaalt modify ajiltan_id varchar(9) not null;

alter table butsaalt
add constraint fk_butsaalt_ajiltan
foreign key (ajiltan_id)
references ajiltan(id)
on update cascade;

alter table unelgee drop foreign key fk_unelgee_hereglegch;

alter table unelgee
add constraint fk_unelgee_hereglegch
foreign key (hereglegch_id)
references hereglegch(id)
on update cascade;

alter table butsaalt 
add constraint fk_butsaalt_cause
foreign key (cause_id) references cause(id)
on update cascade;

select *
from information_schema.table_constraints
where table_name='butsaalt';

delete from unelgee where id = 1;

insert into unelgee (id, text, buteegdehuun_id, hereglegch_id)
values(1, 'Муу бүтээгдэхүүн байна', 1, 1);

select * from unelgee;

alter table unelgee
modify id double not null;

alter table unelgee 
modify id int not null;

insert into hereglegch
values(2, "b", "suren", "1999-10-10", "Em", 95900501, "ltsedee@gmail.com");

select * from hereglegch;

update hereglegch
set id = 2
where id = 1;






