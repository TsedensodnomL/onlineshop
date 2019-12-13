create user customer 
identified by 'customer';

create user operator 
identified by 'operator';

create user admin 
identified by 'admin';

#customer
grant select, insert, update, delete on hereglegch to customer;

grant select on buteegdehuun to customer;

grant select on butsaalt to customer;

grant select, insert, update, delete on sags to customer;

grant select, insert on tulbur to customer;

grant select, insert, update, delete on zahialga to customer; 

#admin
grant all on onlineshop.* to admin;

#operator
grant select, update, delete on ajiltan to operator;

grant all on buteegdehuun to operator;

grant all on category to operator;
grant all on cause to operator;
grant all on duureg to operator;
grant all on hayag to operator;
grant select on hereglegch to operator;
grant all on horoo to operator;
grant all on hot to operator;
grant all on hungulult to operator;
grant select, update on category to operator;
