The database schema:

Highschooler ( ID, name, grade )
English: There is a high school student with unique ID and a given first name in a certain grade.

Friend ( ID1, ID2 )
English: The student with ID1 is friends with the student with ID2. Friendship is mutual, so if (123, 456) is in the Friend table, so is (456, 123).

Likes ( ID1, ID2 )
English: The student with ID1 likes the student with ID2. Liking someone is not necessarily mutual, so if (123, 456) is in the Likes table, there is no guarantee that (456, 123) is also present.


Questions:

-- Q1 - It's time for the seniors to graduate. Remove all 12th graders from Highschooler.

delete from Highschooler
where grade = 12;

-- Q2 - If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.

delete from Likes
where id1 in (
    select ID1 from (
        select L1.ID1, L1.ID2
        from Friend, Likes L1
        where Friend.ID1 = L1.ID1 and Friend.ID2 = L1.ID2
        except
        select L1.ID1, L1.ID2
        from Likes L1, Likes L2
        where L1.ID1 = L2.ID2 and L1.ID2 = L2.ID1;

-- Q3 - For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C. Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a bit challenging; congratulations if you get it right.)

insert into Friend
select F1.ID1, F2.ID2
from Friend F1, Friend F2
where F1.ID2 = F2.ID1 and F1.ID1 <> F2.ID2
except
select * from Friend;

