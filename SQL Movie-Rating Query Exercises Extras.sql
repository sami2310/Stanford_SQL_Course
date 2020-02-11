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
