/*
library management system (library details, books, category, customers, book availability) - saravanan
	
	1)list books by author and category.
	2)track books used by who.
	3)list user wise taken books. (how many books taken based on date range)
	4)search book and show availability date.
	5)pre order book
*/


-- database creation

create database library_management_system;
use library_management_system;

-- tables creation

create table author(
	author_id int not null,
    author_name varchar(25),
    nationality varchar(15),
    
    primary key (author_id)
);

create table book(
	book_id int not null,
    title varchar(50),
    author_id int not null,
    genre varchar(35),
    publication_year int,
    total_copies int,
    available_copies int,
    
    primary key (book_id),
    foreign key (author_id) references author (author_id)
);

create table users(
	user_id int,
    first_name varchar(25),
    last_name varchar(25),
    date_of_birth date,
    email varchar(40),
    
    primary key (user_id)
);

create table phone_number(
	phone_id int not null,
    user_id int not null,
    phone_number int,
    
    primary key (phone_id),
    foreign key (user_id) references users (user_id)
);

create table address(
	address_id int not null,
    user_id int not null,
    street varchar(35),
    city varchar(20),
    state varchar(15),
    postal_code int,
    
    primary key (address_id),
    foreign key (user_id) references users (user_id)
);

create table transactions(
	transaction_id int not null auto_increment,
    book_id int not null,
    user_id int not null,
    borrowed_date date,
    return_date date,
    transaction_status varchar(15),
    
    primary key (transaction_id),
    foreign key (book_id) references book (book_id),
    foreign key (user_id) references users (user_id)
);

-- records insertion
    
Insert into author (author_id, author_name, nationality) 
 values (1, 'Rowling', 'England') , 
		(2, 'George Martin', 'USA') ,
        (3, 'Vince Gilligan', 'USA') ,
        (4, 'Paul Scheuring', 'USA') ,
        (5, 'Carl chinn', 'England');
        
Insert into book (book_id, title, author_id, genre, publication_year, total_copies, available_copies)
 values (1, 'Harry Potter', 1, 'Fantasy', 1997, 10, 15) , 
		(2, 'Game of Thrones', 2, 'Fantasy', 1996, 5, 20) , 
		(3, 'Breaking Bad', 3, 'Crime Thriller', 2008, 8, 12) , 
        (4, 'Prison Break', 4, 'Dramatic Adventure', 2005, 3, 5) , 
        (5, 'Peaky Blinders', 5, 'Crime Thriller', 2014, 7, 10);
    
Insert into Users (user_id, first_name, last_name, date_of_birth, email)
 values (101, 'Godric', 'Gryffindor', '1980-07-31', 'harrypotter@hermoine.org') , 
		(102, 'John', 'Targaryen', '2011-04-17', 'johnsnow@ygritte.in') , 
		(103, 'Walter', 'Heisenberg', '2008-01-20', 'heisenberg@mathamphetamine.com') , 
        (104, 'Michael', 'Scofield', '2005-08-29', 'michaelscofield@sara.edu.in') , 
        (105, 'Thomas', 'Shelby', '2013-09-12', 'thomasshelby@grace.in');
        
Insert into phone_number (phone_id, user_id, phone_number) 
 values (1, 101, +1-555-123-4567) , 
		(2, 102, +1-555-987-6543) , 
		(3, 103, +1-555-876-5432) , 
		(4, 104, +1-555-555-5555) , 
		(5, 105, +1-555-111-2222) ,
        (6, 102, +1-555-987-6544) ;
        
Insert into address (address_id, user_id, street, city, state, postal_code) 
 values (201, 101,  '12 Picket Post Close', 'Bracknell', 'Berkshire', 122334) , 
		(202, 102,  'south of wall', 'Nights Watch', 'seven kingdom', 112234) , 
		(203, 103,  '3828 Piermont Dr', 'Albuquerque', 'New Mexico', 112334) , 
        (204, 104,  '333 N. Canal St', 'Chicago', 'Illinois', 112234) , 
        (205, 105,  'Arley Hall & Gardens', 'Northwich', 'Cheshire', 112233) ;
        
Insert into transactions (transaction_id, book_id, user_id, borrowed_date, return_date, transaction_status)
 values (301, 1, 101, '2023-11-10', '2023-12-17', 'Checked Out') , 
		(302, 2, 102, '2023-11-15', '2023-12-15', 'Checked Out') , 
        (303, 3, 103, '2023-12-01', '2024-01-01', 'Checked Out') , 
        (304, 4, 104, '2023-10-10', '2023-12-20', 'Checked Out') , 
        (305, 5, 105, '2023-11-01', '2023-12-01', 'Returned') ;
        

-- Queries

-- list books by author and category
select title, available_copies, genre from book where genre = "crime thriller";
select book.title, book.available_copies, book.genre from book
inner join author on book.author_id = author.author_id where author.author_name = "Vince gilligan";

-- track books used by who
select transactions.transaction_id, book.title as book_title,
 concat(users.first_name, ' ', users.last_name) as borrower_name,
 transactions.borrowed_date, transactions.return_date,
 transactions.transaction_status from transactions
 inner join book on transactions.book_id = book.book_id
 right join users on transactions.user_id = users.user_id;

-- list user wise taken books. (how many books taken based on date range)
select concat(users.first_name,' ',users.last_name) as User_name, book.title as Book_title, transactions.borrowed_date
 from book right join transactions on book.book_id = transactions.book_id
 left join users on transactions.user_id = users.user_id
 order by borrowed_date;

-- search book and show availability date
 select t.transaction_id, b.title as book_title,
  concat(u.first_name, ' ', u.last_name) as borrower_name,
  t.borrowed_date, t.return_date, t.transaction_status,
  case
	when b.available_copies > 0 then 'more copies available'
    else 'book will be available on' + 
		 (select t.return_date from transactions order by t.return_date limit 1)
  end as availability
  from transactions t inner join book b on t.book_id = b.book_id
  right join users u on t.user_id = u.user_id
  where b.title = 'Game of thrones';

-- pre order book
Insert into transactions (book_id, user_id, transaction_status)
 values ((select book_id from book where title = 'Breaking Bad'), 101, 'Pre Ordered');
