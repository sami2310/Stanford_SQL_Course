The database schema:

Highschooler ( ID, name, grade )
English: There is a high school student with unique ID and a given first name in a certain grade.

Friend ( ID1, ID2 )
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).

Likes ( ID1, ID2 )
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present.


Questions:

-- Q1 - Find the names of all students who are friends with someone named Gabriel.

select H1.name
from Highschooler H1, Highschooler H2, Friend
where friend.id1 = H1.id and friend.id2 = H2.id and H2.name = 'Gabriel';

-- Q2 - For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.

select H1.name, H1.grade , H2.name, H2.grade
from Highschooler H1
join
Likes L 
on (H1.id = L.id1)
join
Highschooler H2
on (L.id2 = H2.id)
where h1.grade - h2.grade >= 2;

-- Q3 - For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.

select H1.name, H1.grade , H2.name, H2.grade
from Likes L1, Likes L2, Highschooler H1, Highschooler H2
where L1.id1 = L2.id2 and L1.id2 = L2.id1 and H1.id = L1.id1 and H2.id = L2.id1 and H1.name < H2.name;

-- Q4 - Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.

select name, grade
from 
Highschooler H left join likes L1 on (H.id = L1.id1) 
left join likes L2 on (H.id = L2.id2)
where L1.id1 is null and l2.id2 is null
order by grade, name;

-- Q5 - For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.

select H1.name, H1.grade, H2.name, H2.grade
from Likes L1 left join Likes L2 on (L1.id2 = L2.id1)
join Highschooler H1 on (L1.id1 = H1.id)
join Highschooler H2 on (L1.id2 = H2.id)
where l2.id2 is null;

-- Q6 - Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.

select H.name, H.grade
from Highschooler H
where H.id not in (
                    select H1.id
                    from highschooler H1 join Friend  F1 on (H1.id = F1.id1)
                    join Highschooler H2 on (H2.id = F1.id2)
                    where H1.grade <> H2.grade)
order by grade, name;

-- Q7 - For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.

select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade 
from Friend F1 , Friend F2, Highschooler H1, Highschooler H2, Highschooler H3,
(select L1.id1 as Aid, L1.id2 as Bid
    from Likes L1
    where L1.id2 not in (select F.id2
                     from Friend F where F.id1 = L1.id1)) Lovers
where F1.id2 = Lovers.Aid and F1.id1 = F2.id1 and F2.id2 = Lovers.Bid 
        and H1.id = Lovers.Aid and H2.id = Lovers.Bid and H3.id = F1.id1;

-- Q8 - Find the difference between the number of students in the school and the number of different first names.

select count(*) - count(distinct name)
from Highschooler;

-- Q9 - Find the name and grade of all students who are liked by more than one other student.

select name, grade
from Highschooler where id in
                        (select id2
                        from Likes        
                        group by id2
                        having count(*)>1);
