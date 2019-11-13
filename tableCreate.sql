create database if not exists onlineShop default char set utf8;

create table if not exists hereglegch(
	id int not null,
    firstname nvarchar(30) not null,
    lastname nvarchar(30) not null,
    birthdate date not null,
    gender nvarchar(30) not null,
    phone decimal(8) not null,
    email varchar(45) not null,
    primary key(id));
    
create table if not exists duureg(
	id int not null,
    duureg nvarchar(20) not null,
    primary key(id));
    
create table if not exists hayag(
	id int not null,
    duureg_id int not null,
    horoo_id int not null,
    hot_id int not null,
    primary key(id),
    constraint fk_duureg_id
		foreign key(duureg_id)
        references duureg(id),
	constraint fk_hot_id 
		foreign key(hot_id)
        references hot(id),
	constraint fk_horoo_id
		foreign key(horoo_id)
        references horoo(id));
       
create table if not exists uildver(
	id int not null,
    ner nvarchar(45) ,
    logo BLOB,
    primary key(id));
    
create table if not exists buteegdehuun(
	id int not null,
    description text(200),
    b_name nvarchar(45),
    price int,
    uildverlegch_id int null,
    primary key(id),
    constraint fk_buteegdehuun_id
		foreign key(uildverlegch_id)
        references uildver(id));
        
create table if not exists butsaalt(
	id int not null,
    zahialga_id int not null,
    buteegdehuun_id int not null,
    reason nvarchar(50),
    butsaalt_date date,
    primary key(id),
    constraint fk_zahialga_id
		foreign key(zahialga_id)
        references zahilga(id),
	constraint fk_butsaalt_id
		foreign key(butsaalt_id)
		references butsaalt(id));
        
create table if not exists sags(
	id int not null,
    hereglegch_id int not null,
    buteegdehuun_id int not null,
    but_number int,
    primary key(id),
    constraint fk_hereglegch_id
		foreign key(hereglegch_id)
        references hereglegch(id),
	constraint fk_buteegdehuun_id
		foreign key(buteegdehuun_id)
		references buteegdehuun(id));

create table if not exists ajiltan(
	id int not null,
    firstname nvarchar(30) not null,
    lastname nvarchar(30) not null,
    phone decimal(8),
    gender nvarchar(2),
    primary key(id));
    
create table if not exists hurgelt(
	id int not null,
    zahialga_id int not null,
    ajiltan_id int not null,
    hur_date date,
    phone decimal(8),
    hur_status nvarchar(45),
    primary key(id),
    constraint fk_zahialga_id
		foreign key(zahialga_id)
        references zahialga(id),
	constraint fk_ajiltan_id
		foreign key(ajiltan_id)
		references ajiltan(id));
        
create table if not exists hungulult(
	id int not null,
    discount float not null,
    zahialga_id int not null,
    primary key(id),
    constraint fk_zahialga_id
		foreign key(zahialga_id)
        references zahialga(id));
        
create table if not exists tulbur(
	id int not null,
    tul_sum float null,
    zahialga_id int not null,
    primary key(id),
	constraint fk_zahialga_id
		foreign key(zahialga_id)
        references zahialga(id));

create table if not exists unelgee(
	id int not null,
    rating float,
	description text(200),
    buteegdehuun_id int not null,
    hereglegch_id int not null,
    primary key(id),
	constraint fk_hereglegch_id
		foreign key(hereglegch_id)
        references hereglegch(id),
	constraint fk_buteegdehuun_id
		foreign key(buteegdehuun_id)
        references buteegdehuun(id));
        
create table if not exists category(
	id int not null,
    cat_name nvarchar(30) not null,
    iamge blob,
    description text(200),
    primary key(id));
    
create table if not exists categoryButeegdehuun(
	buteegdehuun_id int not null,
    category_id int not null,
	constraint fk_buteegdehuun_id
		foreign key(buteegdehuun_id)
        references buteegdehuun(id),
	constraint fk_category_id
		foreign key(category_id)
        references category(id));
        
create table if not exists zurag(
	id int not null,
    images mediumblob,
    buteegdehuun_id int not null,
    primary key(id),
    constraint fk_buteegdehuun_id
		foreign key(buteegdehuun_id)
        references buteegdehuun(id));
        
create table if not exists zahialsanButeegdehuun(
	id int not null,
    zahialga_id int not null,
    buteegdehuun_id int not null,
    quantity int,
    primary key(id),
    constraint fk_zBut
		foreign key(zahialga_id)
        references zahialga(id),
	constraint fk_but
		foreign key(buteegdehuun_id)
        references buteegdehuun(id));
        
create table if not exists cause(
	id int not null,
    description nvarchar(45),
    primary key(id));
    
create table if not exists ajiltan_lavlah(
	id int not null,
    role nvarchar(45),
    primary key(id));
    
create table if not exists ungu(
	id int not null,
    color nvarchar(20),
    primary key(id));

create table if not exists material(
	id int not null,
    material nvarchar(20),
    primary key(id));
    
create table if not exists size(
	id int not null,
    size varchar(10),
    primary key(id));
        

        

    
        

