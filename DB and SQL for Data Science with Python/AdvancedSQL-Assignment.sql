--Advanced SQL Assignment 
--Ex1 Q1
--Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.

SELECT A.NAME_OF_SCHOOL, A.COMMUNITY_AREA_NAME, 
A.AVERAGE_STUDENT_ATTENDANCE, B.HARDSHIP_INDEX
FROM CHICAGO_PUBLIC_SCHOOLS A LEFT OUTER JOIN CENSUS_DATA B 
ON A.COMMUNITY_AREA_NUMBER = B.COMMUNITY_AREA_NUMBER
WHERE B.HARDSHIP_INDEX = 98;

--Ex1 Q2

--Write and execute a SQL query to list all crimes that took place at a school.
-- Include case number, crime type and community name.

SELECT A.CASE_NUMBER, A.PRIMARY_TYPE,  A.LOCATION_DESCRIPTION, 
B.COMMUNITY_AREA_NAME
FROM CHICAGO_CRIME_DATA A LEFT OUTER JOIN CENSUS_DATA B
ON A.COMMUNITY_AREA_NUMBER = B.COMMUNITY_AREA_NUMBER
WHERE UPPER(A.LOCATION_DESCRIPTION) LIKE 'SCHOOL%'
OR UPPER(A.LOCATION_DESCRIPTION) LIKE '%SCHOOL';

-- Ex2 Q1

--Write and execute a SQL statement to create a view showing the columns listed in the following table,
-- with new column names as shown in the second column.
DROP VIEW SCHOOLS_VIEW;

CREATE VIEW SCHOOLS_VIEW AS SELECT 
NAME_OF_SCHOOL AS "School_Name",
"Safety_Icon" AS "Safety_Rating",
"Family_Involvement_Icon" AS	"Family_Rating",
"Environment_Icon" AS	"Environment_Rating",
"Instruction_Icon" AS	"Instruction_Rating",
"Leaders_Icon" AS	"Leaders_Rating",
"Teachers_Icon" AS	"Teachers_Rating"
FROM CHICAGO_PUBLIC_SCHOOLS;

SELECT * FROM SCHOOLS_VIEW;

SELECT "School_Name", "Leaders_Rating" FROM SCHOOLS_VIEW;

-- Creating a Stored PROCEDURE
-- Ex3 Q1|Q2|Q3|Q4 / EX4 Q1|Q2
--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE(IN IN_SCHOOL_ID INTEGER, IN IN_LEADER_SCORE INTEGER)
LANGUAGE SQL
MODIFIES SQL DATA
BEGIN
			UPDATE CHICAGO_PUBLIC_SCHOOLS 
			SET "Leaders_Score" = IN_LEADER_SCORE WHERE "School_ID" = IN_SCHOOL_ID;	
			
			IF IN_LEADER_SCORE > 0 AND IN_LEADER_SCORE <= 19 THEN
				UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET "Leaders_Icon" = 'Very Weak' WHERE "School_ID" = IN_SCHOOL_ID;		
				
			ELSEIF IN_LEADER_SCORE >= 20 AND IN_LEADER_SCORE <= 39 THEN
				UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET "Leaders_Icon" = 'Weak' WHERE "School_ID" = IN_SCHOOL_ID;		
				
			ELSEIF IN_LEADER_SCORE >= 40 AND IN_LEADER_SCORE <= 59 THEN
				UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET "Leaders_Icon"= 'Average'		WHERE "School_ID" = IN_SCHOOL_ID;
			
			ELSEIF IN_LEADER_SCORE >= 60 AND IN_LEADER_SCORE <= 79 THEN
				UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET "Leaders_Icon" = 'Strong'		WHERE "School_ID" = IN_SCHOOL_ID;		
				
			ELSEIF IN_LEADER_SCORE >= 80 AND IN_LEADER_SCORE <= 99 THEN
				UPDATE CHICAGO_PUBLIC_SCHOOLS
				SET "Leaders_Icon" = 'Very Strong'	WHERE "School_ID" = IN_SCHOOL_ID;
			ELSE 
				ROLLBACK WORK;
				
			COMMIT WORK;
			END IF;
END
@

