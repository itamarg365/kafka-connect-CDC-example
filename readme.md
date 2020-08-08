Kafka connect CDC example from Postgresql to ElasticSearch
===========================

*//add short description...*

Getting started
---------------

dependencies
* Docker
* Curl or any other tool for sending http requests


Usage 
------

Clone repo, cd into directory, and checkout appropriate branch.

###setup

From the kafka-connect-CDC-example directory:

```bash
$ docker-compose up -d
```
And  that is it! 
Wait a few minute and then you can check that all the services are up.

I recommends to enter the [Control Center](http://localhost:9021) and see that everithing is OK. it should look like this:

![control-img.png](/control-img.png)
> Note that the cluster mark as "Unhealthy" because it has less then 3 brokers.

Next let's verify that postgres and ES started fine.
For the ES use `$ curl http://localhost:9200`.

For postgres we will try to connect the DB using another container: 
```bash
$ docker run -it --network kafkaconnectcdcexample_default --name psql \
--link postgres:postgres --rm postgres sh -c 'psql -h postgres -U postgres -d cdc';

Password for user postgres:
```
Enter `postgres` as password.
```bash
psql (12.3 (Debian 12.3-1.pgdg100+1), server 11.8 (Debian 11.8-1.pgdg90+1))
Type "help" for help.

cdc=#
```
###create the Connectors
We going to have 2 connectors. One is a source who read from Postgres, the other one is a sink connector who insert the data into ES. To create them we will use curl:

Postgres source:
```bash
$ curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" -d @postgres-source.json http://localhost:8083/connectors;
```
And ES sink:
```bash
$ curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" -d @es-sink.json http://localhost:8083/connectors;
```

### try it out!
Finally we can try adding and editing records and see the changes in our ES. Let's connect to the Postgres cluster:
```bash
$ docker run -it --network kafkaconnectcdcexample_default --name psql \
--link postgres:postgres --rm postgres sh -c 'psql -h postgres -U postgres -d cdc';

Password for user postgres:
```
Enter `postgres` as password.
```bash
psql (12.3 (Debian 12.3-1.pgdg100+1), server 11.8 (Debian 11.8-1.pgdg90+1))
Type "help" for help.

cdc=#
```

next, create the table 'customers' and add some records:

```sql
CREATE TABLE customers (
	user_id serial PRIMARY KEY,
	username VARCHAR ( 50 ) UNIQUE NOT NULL,
	password VARCHAR ( 50 ) NOT NULL,
	email VARCHAR ( 255 ) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
    last_login TIMESTAMP 
);

insert into customers (username,password,email,created_on,last_login) 
values ('user1','pass3','user1@gmail.com',current_timestamp,current_timestamp),
	   ('user2','pass3','user2@gmail.com',current_timestamp,current_timestamp),
	   ('david','pass4','user3@gmail.com',current_timestamp,current_timestamp);
```

Now, we can see them in ES:
```bash
curl http://localhost:9200/dbserver.public.customers/_search?pretty
```
And if we change soome records:
```sql
update customers 
set password='newpass2' 
where username='david';

delete from customers 
where username='user1';
```

The records will be updated in our ES!


### Services list

| service        | address               |
|----------------|-----------------------|
| Control center | http://localhost:9021 |
| Kafka    | http://localhost:9092 |
| Zookeeper      | http://localhost:2181 |
| Kafka-Connect  | http://localhost:8083 |
| Postgres       | http://localhost:5432 |
| ElasticSearch  | http://localhost:9200 |