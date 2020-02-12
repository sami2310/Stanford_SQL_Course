The database schema:

Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.


Questions:

-- Q1 - Find the names of all reviewers who rated Gone with the Wind.

select distinct name 
from Reviewer, Rating, Movie
Where Rating.mid = Movie.mid and  Rating.rid = Reviewer.rid and title = 'Gone with the Wind';


-- Q2 - For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.

select name , title , stars
from Movie M, Reviewer RE, Rating RA
Where Ra.rid = Re.rid and Ra.mid = M.mid and M .director  = Re.name;

-- Q3 - Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)

select name
from Reviewer
union
select title
from Movie
order by name;

-- Q4 - Find the titles of all movies not reviewed by Chris Jackson.

select title from Movie
where Movie.mID not in 
    (select M.mID
    from Movie M ,Reviewer Re, Rating Ra
    where Re.name = 'Chris Jackson' and Re.rid = Ra.rID and ra.mID=M.mID);

-- Q5 - For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.

select distinct r1.name as name1, r2.name as name2 from
    (select Reviewer.rid,mid,name
        from Reviewer join Rating on Reviewer.rid = Rating.rid) R1,
    (select Reviewer.rid,mid,name
        from Reviewer join Rating on Reviewer.rid = Rating.rid) R2
where r1.mid = r2.mid and r1.name < r2.name;

-- Q6 - For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.

select name, title, stars
from (select rid, mid, stars
        from rating
        where stars in (select min (stars)
                from Rating)) S,
      Reviewer Re, Movie M
where Re.rid = S.rid and S.mid = M.mid;

-- Q7 - List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.

select title, rates
from (select mid, avg(stars) as rates
        from Rating
        group by mid) averaged

join Movie on Movie.mid =averaged.mid
order by rates desc, title;

-- Q8 - Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)

select name 
from Reviewer
where Reviewer.rid in(
    select Rating.rid
    from Rating
    group by Rating.rid
    having count(stars) >= 3);

-- Q8 (extra challenge)-

select name
from Reviewer, (select Rating.rid, count(stars) as total
                from Rating
                group by Rating.rid) counts
where Reviewer.rid = counts.rid and counts.total >=3;

-- Q9 - Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title.

select title, director
from Movie M
where director in 
    (select director
    from Movie
    Group by director
    having count(*) >1)
    
order by director, title

-- Q10 - Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)


select title, A.mAverage
from (select mid, avg(stars) as average
        from Rating
        group by (mid)) R,
      (select max(average) as mAverage
        from (select avg(stars) as average
                from Rating
                group by (mid)) ) A,
      Movie M
                              
where R.average = A.mAverage and M.mid = R.mid

-- Q11 - Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)
(Here I tried something different using a join)

select title, avg(Rating.stars) Ravg
from Movie
join Rating
on (Movie.mid = Rating.mid)
group by Movie.mid
having Ravg is
        (select avg(stars) as average
        from Rating
        group by mid
        order by average asc limit 1)

-- Q12 - For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.

select director, title, max(stars)
from Movie
Join
Rating
on (Movie.mid = rating.mid)
where director is not null
group by director
