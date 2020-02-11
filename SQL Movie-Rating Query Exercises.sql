The database schema:

Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.


Questions:

-- Q1 - Find the titles of all movies directed by Steven Spielberg.

select title
From Movie
where director = 'Steven Spielberg'

-- Q2 - Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

select distinct year
From Movie, Rating
Where Movie.mID = Rating.mID and stars > 3
order by year asc;

-- Q3 - Find the titles of all movies that have no ratings.

SELECT title
From Movie
    LEFT JOIN Rating ON Movie.mID = Rating.mID
        WHERE Rating.mID IS NULL

-- Q4 - Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.

Select distinct name
From Reviewer, Rating
Where Reviewer.rID = Rating.rID and Rating.ratingDate is null;

-- Q5 - Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.

select name, title, stars, ratingdate
from Movie M , Reviewer R, Rating Ra
where M.mID = Ra.mId and R.rId = Ra.rID
order by R.name, M.title, Ra.stars;

-- Q6 - For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.

Select name, title
from (select R1.rid, R1.mid
        from Rating R1, Rating R2
        where R1.rid = R2.rid and R1.mid = R2.mid and R1.ratingdate > R2.ratingdate and R1.stars > R2.stars) S, Reviewer, Movie
where Reviewer.rid = S.rid and Movie.mid = S.mid;

-- Q7 - For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.

select M.title, S.stars
from (select distinct R1.mid, R1.stars
        from Rating R1
        where not exists (select * from Rating R2 where R1.mid = R2.mid and R1.stars < R2.stars)) S, Movie M
Where S.mid= M.mid
order by M.title;

-- Q8 - For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.

select title, spread from 
    (select mId, max(stars) - min (stars) as spread
    from Rating
    Group by mId) S, Movie M
where M.mid = S.mid
order by spread desc, title asc;

-- Q9 - Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)

select avg(before.averaged) - avg(after.averaged)
from  (select distinct A.mid, averaged
        from (select mid, Avg(stars) as averaged
                from Rating
                Group by mid) A,    
             (select mid
                from Movie
                Where year < 1980) be
       where A.mid = be.mid) before,
       
(select distinct A.mid, averaged
from (select mid, Avg(stars) as averaged
        from Rating
        Group by mid) A,
      (select mid
          from Movie
          Where year > 1980) ae
where A.mid = ae.mid) after