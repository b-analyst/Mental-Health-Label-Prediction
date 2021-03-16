/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT * FROM "Facilities" WHERE membercost > 0

/* facid = 0,1,4,5,6 */


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT(*) FROM "Facilities" WHERE membercost = 0

/* 4 facilities */

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenace FROM "facilities" WHERE membercost < 0.2 * monthlymaintenance

/* result:
facid   name             membercost  monthlymaintenance
0	Tennis Court 1	5.0	200
1	Tennis Court 2	5.0	200
2	Badminton Court	0.0	50
3	Table Tennis	0.0	10
4	Massage Room 1	9.9	3000
5	Massage Room 2	9.9	3000
6	Squash Court	3.5	80
7	Snooker Table	0.0	15
8	Pool Table	0.0	15
*/

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT * FROM "facilities" WHERE facid IN (1,5)


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT facid, monthlymaintenance,
	CASE WHEN monthlymaintenance > 100 THEN 'expensive'
		ELSE 'cheap' END AS cheap_or_expensive
FROM 'facilities'
	


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, surname FROM 'Members' WHERE joindate = (SELECT MAX(joindate) FROM Members)



/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT CONCAT(m.firstname, ' ', m.surname) AS member_name,
(SELECT f.name FROM Facilities f WHERE f.facid = b.facid) AS court_name
FROM members m JOIN Bookings b ON b.memid = m.memid WHERE b.facid IN (0,1)
ORDER BY 1


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT f.name, CONCAT(m.firstname, ' ',m.surname) AS member_name,
CASE WHEN b.memid = 0 THEN f.guestcost * b.slots
ELSE f.membercost * slots
END AS book_cost FROM Bookings b
JOIN Members m ON b.memid = m.memid
AND DATE(b.starttime) = '2012-09-14'
JOIN Facilities f ON b.facid = f.facid
HAVING book_cost > 30
ORDER BY 3 DESC


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT sub.f, sub.member_name sub.book_cost FROM (
SELECT facilities.name AS f, CONCAT(members.firstname, ' ',members.surname) AS member_name,
CASE WHEN bookings.memid = 0 THEN facilities.guestcost * b.slots
ELSE facilities.membercost * slots
END AS book_cost FROM Bookings b
JOIN Members m ON b.memid = m.memid
AND DATE(bookings.starttime) = '2012-09-14'
JOIN Facilities facilities ON bookings.facid = facilities.facid)sub
WHERE sub.book_cost > 30
ORDER BY 3 DESC


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT f.name AS fac_name, SUM(
CASE WHEN b.memid = 0 THEN f.guestcost * b.slots
ELSE f.membercost * b.slots END) AS revenue FROM Facilities f
JOIN Bookings b ON f.facid = book.facid
GROUP BY 1
HAVING revenure < 1000
ORDER BY 2
