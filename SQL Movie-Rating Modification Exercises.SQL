The database schema:

Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.

Questions:

-- Q1 - Add the reviewer Roger Ebert to your database, with an rID of 209.

INSERT into Reviewer values (209, 'Roger Ebert');

-- Q2 - Insert 5-star ratings by James Cameron for all movies in the database. Leave the review date as NULL.

insert into Rating
select R.rid,M.mid, 5 , null
from Reviewer R, Movie M
where R.name = 'James Cameron' ;

-- Q3 - For all movies that have an average rating of 4 stars or higher, add 25 to the release year. (Update the existing tuples; don't insert new tuples.)

update Movie
set year = year + 25
where Movie.mid in (select R.mid
                     from Rating R
                     group by R.mid
                     having avg(stars) >= 4);

-- Q4 - Remove all ratings where the movie's year is before 1970 or after 2000, and the rating is fewer than 4 stars.

delete from Rating
where  stars < 4 and mid in (select M.mid from Movie M where M.year < 1970 or M.year >2000);

