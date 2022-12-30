# Sandip Sarker
#Watson healthcare data Exploration
#Data: Data has been downloaded from https://www.kaggle.com/datasets/jpmiller/employee-attrition-for-healthcare 
#I have cleaned the data in Excel and get it ready to use in MySQL.
#I have had a look at the insight and ask questions which are critical to make strategic decisions on employee turnover

#First Let's have a look at the whole dataset

SELECT 
    *
FROM
    Portfolio.project;
    
#How many employees left the organization and how many are staying?

SELECT 
    Attrition, COUNT(Attrition)
FROM
    Portfolio.project
GROUP BY Attrition;

-- 1477 are staying and 199 left the organization

#How many distinct job roles in the company?

SELECT DISTINCT
    jobrole
FROM
    portfolio.project;
    
-- 5 roles

#What percent of the total employees left the organization?

SELECT 
    (SELECT 
            COUNT(Attrition)
        FROM
            Portfolio.project
        WHERE
            Attrition = 'yes') / (SELECT 
            COUNT(EmployeeCount)
        FROM
            Portfolio.project) * 100 AS Attrition_Rate
            
-- Around 11.88% of the total employees left

#The details of employees with the age range between 35-40 along with 6 years and above work experience

SELECT 
*
FROM
    Portfolio.project
WHERE
    age BETWEEN 35 AND 40
        AND TotalWorkingYears > 6
ORDER BY age;

#What is the average age of the employees who left and who stays?

SELECT 
    ROUND(AVG(age), 2)
FROM
    portfolio.project
WHERE
    attrition = 'Yes';
    
SELECT 
    ROUND(AVG(age), 2)
FROM
    portfolio.project
WHERE
    attrition = 'No';

-- Left: 30.90, stays: 37.67
        
#Number of people left from different jobroles and departments

SELECT 
    jobrole, COUNT(jobrole) AS Count
FROM
    portfolio.project
WHERE
    attrition = 'Yes'
GROUP BY jobrole
ORDER BY count DESC;

-- Most employees left from the role 'Nurse'

SELECT 
    department, COUNT(department) AS Count
FROM
    portfolio.project
WHERE
    attrition = 'Yes'
GROUP BY department
ORDER BY count DESC;

-- Most employees left from 'Maternity' department

#Calculate the percentage of male and female who left the company

SELECT 
    (SELECT 
            COUNT(gender)
        FROM
            portfolio.project
        WHERE
            attrition = 'yes' AND gender = 'male') / (SELECT 
            COUNT(attrition)
        FROM
            portfolio.project
        WHERE
            attrition = 'yes') * 100 AS Male_Attrition;

SELECT 
    (SELECT 
            COUNT(gender)
        FROM
            portfolio.project
        WHERE
            attrition = 'yes' AND gender = 'female') / (SELECT 
            COUNT(attrition)
        FROM
            portfolio.project
        WHERE
            attrition = 'yes') * 100 AS Female_Attrition;
            
-- Male: 56.78 Female: 43.21
            
#Calculate the percentage of male and female who are staying the company

SELECT 
    (SELECT 
            COUNT(gender)
        FROM
            portfolio.project
        WHERE
            attrition = 'No' AND gender = 'female') / (SELECT 
            COUNT(attrition)
        FROM
            portfolio.project
        WHERE
            attrition = 'No') * 100 AS Female_Attrition;
	
SELECT 
    (SELECT 
            COUNT(gender)
        FROM
            portfolio.project
        WHERE
            attrition = 'No' AND gender = 'Male') / (SELECT 
            COUNT(attrition)
        FROM
            portfolio.project
        WHERE
            attrition = 'No') * 100 AS Male_Attrition;
            
-- Female: 40.08, Male: 59.91

#Calculate the average hourly rate of employees who left and who stays          

SELECT 
    AVG(hourlyrate)
FROM
    Portfolio.project
WHERE
    attrition = 'Yes';
    
SELECT 
    AVG(hourlyrate)
FROM
    Portfolio.project
WHERE
    attrition = 'No';

-- Left: 63.47 Stays: 65.74

#What is the maximun and minimum monthly income of each department who received less than 15% salary hike

SELECT 
    department, MAX(monthlyincome), MIN(monthlyincome)
FROM
    Portfolio.project
WHERE
    PercentSalaryHike < 15
GROUP BY department
ORDER BY MAX(monthlyincome) DESC;

#Calculate the average monthly income of employees who worked more than 5 years and whose educational background is medical and gender is male

SELECT 
    ROUND(AVG(monthlyincome), 2)
FROM
    Portfolio.project
WHERE
    YearsAtCompany > 5
        AND EducationField = 'Medical'
        AND Gender = 'Male';

-- 8437.16

#What is the average salary of each department who left?

SELECT 
    department,
    ROUND(AVG(monthlyincome), 2) AS Average_Monthly_Salary
FROM
    Portfolio.project
WHERE
    attrition = 'Yes'
GROUP BY department
order by Average_Monthly_Salary desc;

#Identify the number of male and female employees from each department who work overtime and didnt receive a promotion in 2 years

SELECT 
    gender, department, COUNT(employeeID)
FROM
    Portfolio.project
WHERE
    overtime = 'Yes'
        AND yearsincurrentrole = 2
GROUP BY gender , department;

#Find employees with maximum performance rating but have not received promotion for the last 5 years.

SELECT 
    *
FROM
    Portfolio.project
WHERE
    performancerating = (SELECT 
            MAX(performancerating)
        FROM
            Portfolio.project)
        AND YearsSinceLastPromotion >= 5
ORDER BY EmployeeID;

-- Total 54 employees with highest performance ratings but did not receive promotion

#List employees who are doing overtime but are given minimum salary hike and are more than 5 years with the company

SELECT 
    *
FROM
    Portfolio.project
WHERE
    overtime = 'Yes'
        AND PercentSalaryHike = (SELECT 
            MIN(percentsalaryhike)
        FROM
            portfolio.project)
        AND YearsAtCompany > 5
        order by employeeID;
        
-- 31 employees in total
        
#Also looking at people who are not doing overtime but received maximum salary hike

SELECT 
    *
FROM
    Portfolio.project
WHERE
    overtime = 'No'
        AND PercentSalaryHike = (SELECT 
            MAX(percentsalaryhike)
        FROM
            portfolio.project)
        AND YearsAtCompany < 5
ORDER BY employeeID;

-- total 5 people in this category

#list down the employees who are doing overtime and have highest level of job satisfaction with 5 years+ stay in the organization

SELECT DISTINCT
    employeeID,
    department,
    jobsatisfaction,
    Jobrole,
    YearsSinceLastPromotion
FROM
    Portfolio.project
WHERE
    overtime = 'Yes' AND jobsatisfaction = 4
        AND YearsSinceLastPromotion > 5
ORDER BY employeeID DESC;
    
-- 20 such employees
    
#We would like to know the agerage job satisfaction ratings among different marital status group

SELECT DISTINCT
    maritalstatus,
    ROUND(AVG(jobsatisfaction), 2) AS Avg_jobsatisfaction_MS
FROM
    Portfolio.project
GROUP BY MaritalStatus;

-- Highest: single Lowest: divorced

#we would like to know the average performance rating of the employess who left the organization and who are staying in the organization.

SELECT 
    ROUND(AVG(performancerating), 2) AS Average_Performance_Rating
FROM
    Portfolio.project
WHERE
    Attrition = 'Yes';

SELECT 
    ROUND(AVG(performancerating), 2) AS Average_Performance_Rating
FROM
    Portfolio.project
WHERE
    Attrition = 'No';

-- Left: 3.16 Stays: 3.15

#What is the average age of the employees who left the organization and stay in the organization in terms of different department.

SELECT 
    Department, ROUND(AVG(age), 2)
FROM
    Portfolio.project
WHERE
    Attrition = 'Yes'
GROUP BY Department;

SELECT 
    Department, ROUND(AVG(age), 2)
FROM
    Portfolio.project
WHERE
    Attrition = 'No'
GROUP BY Department;

-- Left: average 29 stays: average 37

#We would like to see the different satisfaction level of different roles in the organization

SELECT 
    jobrole,
    ROUND(AVG(jobsatisfaction), 2) AS average_satisfaction_level
FROM
    Portfolio.project
GROUP BY jobrole
order by average_satisfaction_level desc;

-- Higest: Admin, Lowest: others

#We would like to see the number of employees having in the current role for how many years

SELECT 
    Department,
    ROUND(AVG(yearsincurrentrole), 2) AS Avg_years_in_current_role
FROM
    Portfolio.project
GROUP BY department
order by Avg_years_in_current_role desc;

-- Highest: Neurology lowest: Maternity

#Finally we would like to see the relationship between total work experience and employee turnover

SELECT 
    EmployeeID,
    Department,
    jobrole,
    Totalworkingyears,
    YearsSincelastpromotion,
    Educationfield
FROM
    Portfolio.project
WHERE
    Attrition = 'Yes'
ORDER BY totalworkingyears desc;

#What are the profiles of the employees who are left and who stay

CREATE VIEW Employee_profile AS
    SELECT 
        *
    FROM
        Portfolio.project;
        
        
#Comments based on the above analysis

-- 1. 11.88% of the total emplyee left the organization
-- 2. Employees whose average age is nearly 30 tend to leave the organization.
-- 3. Most employees left from the job role Nurse category and Maternity department.
-- 4. Tendency to leave the organization is higher among males compared to females.
-- 5. Average hourly rate among employees who left and stays is nearly same.
-- 6. There are 54 employees with highest performance ratings and working for more than 5 years but still did not receive promotion. They should be taken care of.
-- 7. There are 31 employees doing overtime but received minimum salary hike. Dissatisfaction might be created among them if their salary is not increased.
-- 8. Admin department has the highest level of job satisfaction.
-- 9. Above all, there is a positive relationship between total work experience and employee turnover.







