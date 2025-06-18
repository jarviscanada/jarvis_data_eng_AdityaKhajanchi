# SQL Self-Learning Project

- [Introduction](#Introduction)
- [Quick Start](#Quick-start)
- [Database Design](#Database-design)
- [Queries](#Queries)
  - [Modifying Data (DML)](#Section-1-modifying-data)
  - [Query Basics (DQL)](#Section-2-basics)
  - [Joins](#Section-3-joins)
  - [Aggregation & Window Functions](#Section-4-aggregate-functions)
  - [String Manipulation](#Section-5-string-manipulation)
## Introduction

This self-directed SQL learning project was designed to help me practice and deepen my understanding of essential SQL concepts, including Data Query Language (DQL), Data Definition Language (DDL), Data Manipulation Language (DML), joins, aggregate functions, subqueries, and window functions. 
The database used consists of three interrelated tables: members, facilities, and bookings. 
All queries were practiced on pgexercises.com, and the database was locally initialized using the ```clubdata.sql``` script for hands-on execution in a PostgreSQL Docker environment within the JRD.

## Quick Start
1. Start a PostgreSQL container in Docker
2. Initialize Database and load sample data from the ```clubdata.sql``` script file using the bash cmd

> [Clubdata.sql](https://raw.githubusercontent.com/jarviscanada/jarvis_data_eng_AdityaKhajanchi/f9d9d296cdeb59d266e0f4e29073ddf8a72fac20/sql/clubdata.sql)

```bash
# Modify this query for your database (e.g. database name, connection, etc) 
psql -U <username> -f clubdata.sql -d postgres -x -q
```

## Database Design

Table: ```cd.members``` (37 Rows)
```sql
CREATE TABLE cd.members(
memid INTEGER PRIMARY KEY,
surname VARCHAR(200),
firstname VARCHAR(200),
address VARCHAR(300),
zipcode INTEGER,
telephone VARCHAR(20),
recommendedby INTEGER,
joindate TIMESTAMP,
FOREIGN KEY (recommendedby) REFERENCES cd.members(memid)
);
```
Table: ```cd.facilities``` (8 Rows)
```sql
CREATE TABLE cd.facilities(
facid INTEGER PRIMARY KEY,
name VARCHAR(100),
membercost NUMERIC,
guestcost NUMERIC,
initialoutlay NUMERIC,
monthlymaintenance NUMERIC
);
```

Table: ```cd.bookings``` (4043 Rows)
```sql
CREATE TABLE cd.bookings(
bookid INTEGER PRIMARY KEY,
facid INTEGER,
memid INTEGER,
starttime TIMESTAMP,
slots INTEGER,
FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
FOREIGN KEY (memid) REFERENCES cd.members(memid)
);
```

## Queries

### SECTION 1: Modifying Data

```sql
/*
1. The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:
facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
*/
INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES (9, 'Spa' ,20, 30, 100000, 800);

/*
2. Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else:
Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
*/
INSERT INTO cd.facilities(
facid, name, membercost, guestcost, initialoutlay, monthlymaintenance
)
VALUES (
(SELECT max(facid) FROM cd.facilities)+1,'Spa',20,30,100000,800);

/*
3. We made a mistake when entering the data for the second tennis court.
The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.
*/
UPDATE cd.facilities SET initialoutlay=10000 WHERE facid=1;

/*
4. We want to alter the price of the second tennis court so that it costs 10% more than the first one.
Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.
*/
UPDATE cd.facilities
SET
membercost=(SELECT membercost*1.1 FROM cd.facilities WHERE facid=0),
guestcost=(SELECT guestcost*1.1 FROM cd.facilities WHERE facid=0)
WHERE facid=1;

/*
5. As part of a clearout of our database, we want to delete all bookings from the cd.bookings table.
How can we accomplish this?
*/
-- CODE COMMENTED BECAUSE IT WILL DELETE ALL RECORDS FROM CD.BOOKINGS
-- DELETE FROM CD.BOOKINGS;

/*
6. We want to remove member 37, who has never made a booking, from our database.
How can we achieve that?
*/
DELETE FROM CD.MEMBERS
WHERE memid=37;
```
### Section 2: Basics
```sql
/*
    7. How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost?
    Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.
 */
SELECT facid, name,membercost,monthlymaintenance
FROM cd.facilities
WHERE membercost > 0
AND membercost < (monthlymaintenance / 50);

/*
    8. How can you produce a list of all facilities with the word 'Tennis' in their name?
 */
SELECT * FROM cd.facilities WHERE LOWER(name) LIKE '%tennis%';

/*
    9. How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.
 */
SELECT * FROM cd.facilities WHERE facid IN (1,5);

/*
    10. How can you produce a list of members who joined after the start of September 2012?
    Return the memid, surname, firstname, and joindate of the members in question.
 */
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate > '2012-09-01%';

/*
    11. You, for some reason, want a combined list of all surnames and all facility names.
    Yes, this is a contrived example :-). Produce that list!
*/
SELECT SURNAME FROM CD.MEMBERS
UNION
SELECT NAME FROM CD.FACILITIES;
```
### Section 3: Joins
```sql
/*
    12. How can you produce a list of the start times for bookings by members named 'David Farrell'?
 */
SELECT b.starttime
FROM cd.bookings AS b
JOIN cd.members AS m ON b.memid = m.memid
WHERE LOWER(m.firstname) = 'david' AND LOWER(m.surname) = 'farrell';

/*
    13. How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'?
    Return a list of start time and facility name pairings, ordered by the time.
 */
SELECT b.starttime as Start, f.name as Name
FROM cd.bookings b
         JOIN cd.facilities f on b.facid=f.facid
WHERE LOWER(f.name) like 'tennis court%'
  AND b.starttime>='2012-09-21'
  AND b.starttime<'2012-09-22'
ORDER BY b.starttime;

/*
    14. How can you output a list of all members, including the individual who recommended them (if any)?
    Ensure that results are ordered by (surname, firstname).
 */
SELECT m1.firstname as memfname, m1.surname as memsname, m2.firstname as recfname, m2.surname recsname
FROM cd.members m1
JOIN cd.members m2 on m1.recommendedby=m2.memid
ORDER BY m1.surname, m1.firstname;

/*
    15. How can you output a list of all members who have recommended another member?
    Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).
 */
SELECT firstname, surname
FROM cd.members
WHERE memid IN (SELECT DISTINCT recommendedby FROM cd.members)
ORDER BY surname, firstname;

/*
    16. How can you output a list of all members, including the individual who recommended them (if any), without using any joins?
    Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.
 */

SELECT DISTINCT firstname || ' ' || surname as member,
    (SELECT firstname || ' ' || surname as recommender
    FROM cd.members r
    WHERE r.memid=m.recommendedby)
FROM cd.members m
ORDER BY member;
```
### Section 4: Aggregate Functions
```sql
/*
    17. Produce a count of the number of recommendations each member has made.
    Order by member ID.
 */
SELECT recommendedby, count(*)
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;

/*
    18. Produce a list of the total number of slots booked per facility.
    For now, just produce an output table consisting of facility id and slots, sorted by facility id.
 */
SELECT facid, SUM(slots)
FROM cd.bookings
GROUP BY facid
ORDER BY facid;

/*
    19. Produce a list of the total number of slots booked per facility in the month of September 2012.
    Produce an output table consisting of facility id and slots, sorted by the number of slots.
 */
SELECT facid, SUM(slots) AS total_slots
FROM cd.bookings
WHERE starttime >= '2012-09-01'
  AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY total_slots;

/*
    20. Produce a list of the total number of slots booked per facility per month in the year of 2012.
    Produce an output table consisting of facility id and slots, sorted by the id and month.
 */
SELECT facid, EXTRACT(MONTH FROM starttime) AS Month, SUM(slots) as "Total Slots"
FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime)=2012
GROUP BY facid, Month
ORDER BY facid, Month;

/*
    21. Find the total number of members (including guests) who have made at least one booking.
 */
SELECT COUNT(DISTINCT memid) AS COUNT
FROM cd.bookings;

/*
    22. Produce a list of each member name, id, and their first booking after September 1st 2012.
    Order by member ID.
 */
SELECT m.surname, m.firstname, m.memid, MIN(STARTTIME)
FROM cd.members m
JOIN cd.bookings b on m.memid=b.memid
WHERE starttime>'2012-09-01'
GROUP BY m.memid
ORDER BY m.memid;

/*
    23. Produce a list of member names, with each row containing the total member count.
    Order by join date, and include guest members.
 */
SELECT count(*) OVER () AS TOTAL, firstname, surname
FROM cd.members
ORDER BY joindate;


/*
    24. Produce a monotonically increasing numbered list of members (including guests), ordered by their date of joining.
    Remember that member IDs are not guaranteed to be sequential.
 */
SELECT ROW_NUMBER() OVER ( ORDER BY joindate ), firstname, surname
FROM cd.members;

/*
    25. Output the facility id that has the highest number of slots booked.
    Ensure that in the event of a tie, all tieing results get output.
 */
SELECT facid, total
FROM
    (SELECT facid,
            sum(slots) AS total,
            RANK() OVER
                (
                ORDER BY sum(slots) DESC) as RANK
     FROM cd.bookings GROUP BY facid ) AS cdb
WHERE RANK=1;
```

### Section 5: String Manipulation
```sql
/*
    26. Output the names of all members, formatted as 'Surname, Firstname'
 */
SELECT surname ||', '|| firstname AS Name
FROM cd.members;

/*
    27. You've noticed that the club's member table has telephone numbers with very inconsistent formatting.
    You'd like to find all the telephone numbers that contain parentheses, returning the member ID and telephone number sorted by member ID.
 */
SELECT memid, telephone
FROM cd.members
WHERE telephone ~ '[()]';

/*
    28. You'd like to produce a count of how many members you have whose surname starts with each letter of the alphabet.
    Sort by the letter, and don't worry about printing out a letter if the count is 0.
 */
SELECT SUBSTR(SURNAME,1,1) AS Letter, count(*)
FROM CD.MEMBERS
GROUP BY Letter
ORDER BY Letter;
```
