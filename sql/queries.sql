-- 1. The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values:
-- facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
INSERT INTO cd.facilities
    (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES (9, 'Spa' ,20, 30, 100000, 800);

-- 2. Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else:
-- Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
INSERT INTO cd.facilities(
    facid, name, membercost, guestcost, initialoutlay, monthlymaintenance
)
VALUES (
    (SELECT max(facid) FROM cd.facilities)+1,'Spa',20,30,100000,800);

-- 3. We made a mistake when entering the data for the second tennis court.
-- The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.
UPDATE cd.facilities SET initialoutlay=10000 WHERE facid=1;

-- 4. We want to alter the price of the second tennis court so that it costs 10% more than the first one.
-- Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.
UPDATE cd.facilities
SET
    membercost=(SELECT membercost*1.1 FROM cd.facilities WHERE facid=0),
    guestcost=(SELECT guestcost*1.1 FROM cd.facilities WHERE facid=0)
WHERE facid=1;

-- 5. As part of a clearout of our database, we want to delete all bookings from the cd.bookings table.
-- How can we accomplish this?
DELETE FROM CD.BOOKINGS;

-- 6. We want to remove member 37, who has never made a booking, from our database.
-- How can we achieve that?
DELETE FROM CD.MEMBERS
WHERE memid=37;