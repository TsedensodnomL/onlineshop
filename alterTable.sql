alter table buteegdehuun 
add column ungu_id int not null,
add column size_id int not null,
add column material_id int not null;

alter table ajiltan
add column ajiltan_lavlah_id int not null,
add foreign key(ajiltan_lavlah_id)
references ajiltan_lavlah(id);


alter table buteegdehuun
add foreign key(ungu_id)
	references ungu(id),
add foreign key(size_id)
	references size(id),
add foreign key(material_id)
	references material(id);
    
alter table butsaalt 
add column cause_id int not null,
add foreign key(cause_id)
	references cause(id);
    
alter table hungulult
add column start_date date,
add column end_date date;
    
    
    

