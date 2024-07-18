# Project 1 Data Exploration


SELECT *
FROM household_income.ushouseholdincome;

SELECT *
FROM household_income.ushouseholdincome_statistics;

#When we are exploring the data we are trying to find trends, patterns, insights into the data.
#I'm noticing there's not date fields, so no time series data. So probably won't be looking for trends over time.

#We can look at some information at the state level through, like size of each state, average city size, etc. 
#We can also join to the statistics table and look at mean and median incomes

#Let's start with some simple stuff and work our way to the joining the tables.

#Let's select the columns we want to work with
SELECT State_Name, ALand, AWater
FROM household_income.ushouseholdincome;

#Let's look at the total size of each state and order it from smallest to largest
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM household_income.ushouseholdincome
GROUP BY State_Name
ORDER BY 2;

#Just glancing at these results they look pretty accurate. Texas being the largest

#Now let's say we just want to look at the top 10 largest states by land
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM household_income.ushouseholdincome
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

#Now let's do the same, but for water - these will be states that have a lot of lakes or rivers
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM household_income.ushouseholdincome
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;

#I expected Michigan, florida, minnesota to be in there - also Alaska, but I didn't expect Texas or North Carolina to be in the top 10 - interesting

#Now that's interesting, but this is primrily an income dataset. Let's join the tables together and look at that

SELECT *
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id;
    
#Now let's filter on the columns we want

SELECT u.State_Name, County, `Type`, `Primary`, Mean, Median
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id;


#First, let's look at just the state level the average mean and median
SELECT u.State_Name, AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY u.State_Name
order by 3;

#These are the lowest paid or at least have the lowest income in the US

SELECT u.State_Name, AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY u.State_Name
order by 3;

#Now We've just looked at the state level. We don't have to just use this. Let's look at it by type
#I don't know what primary is so let's add it in there

SELECT `Type`, `Primary`, AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY `Type`, `Primary`
order by 3;

#Actually let's just keep Type in there:

SELECT `Type`, AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY `Type`
order by 3;

#Woah, whatever a CDP is their median is dramatically higher.

#Let's also do a count of Type because that context matters...

SELECT `Type`,COUNT(`Type`), AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY `Type`
order by 4;

#See now this makes a huge difference. Honestly. Municipality is high, but only has 1 row in the entire dataset so that's super skewed.

#Now I am not using this professionaly, but we might want to filter some of these out.
#Let's have them have to have more than 100 rows of data to be used.

SELECT `Type`,COUNT(`Type`), AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY `Type`
HAVING COUNT(`Type`) > 100
order by 4;


#Now let's look at our data again

SELECT *
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id;

#The last thing I'm interested in is finding the cities with the highest and lowest median salary. I think that would be interesting.
SELECT u.State_Name, City, AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
HAVING AVG(Mean) IS NOT NULL
ORDER BY 3 ASC
LIMIT 10;


#In these cities the avg salary is only like 10k, 14k - that's super low

#Highest
SELECT u.State_Name, City, AVG(Mean), AVG(Median)
FROM household_income.ushouseholdincome u
JOIN household_income.ushouseholdincome_statistics us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY 3 DESC
LIMIT 10;

#One thing I'm noticing is some of the Medians are 300,000 which is odd. This is something I would dig into more in the data
#See if I need to clean this up, if it's accurate, etc.

#That's it though - we found some interesting insights just exploring the data.

#Usually when you get data in your job you'll have some type of direction or use for this data which will lead you
#To explore the data in a certain way, but here we were just kind of randomly exploring and seeing what we found



