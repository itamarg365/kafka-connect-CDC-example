CREATE TABLE customers (
	user_id serial PRIMARY KEY,
	username VARCHAR ( 50 ) UNIQUE NOT NULL,
	password VARCHAR ( 50 ) NOT NULL,
	email VARCHAR ( 255 ) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
    last_login TIMESTAMP 
);

insert into customers (username,password,email,created_on,last_login) 
 values ('itamar','pass1','itamar@gmail.com',current_timestamp,current_timestamp);

 insert into customers (username,password,email,created_on,last_login) 
 values ('user1','pass3','user1@gmail.com',current_timestamp,current_timestamp),
 		('user2','pass3','user2@gmail.com',current_timestamp,current_timestamp),
 		('david','pass4','user3@gmail.com',current_timestamp,current_timestamp);

update customers set password='newpass' where username='david';