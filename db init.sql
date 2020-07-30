CREATE TABLE customers (
	user_id serial PRIMARY KEY,
	username VARCHAR ( 50 ) UNIQUE NOT NULL,
	password VARCHAR ( 50 ) NOT NULL,
	email VARCHAR ( 255 ) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
    last_login TIMESTAMP 
);

insert into customers (username,password,email,created_on) \
 values ('itamar','pass1','itamar@gmail.com',current_timestamp,current_timestamp)