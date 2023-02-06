# SQL_Data_Cleaning

## Purpose
The purpose of this project is to clean the Nashville Housing Dataset using MS SQL.

## Data Source

[Click Here](https://github.com/Sukanya807/SQL_Data_Cleaning/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx) to download the Excel file.

## Tools Used

MS SQL Server Management Studio

## Data Cleaning

The following changes were made to the raw dataset to perform data cleaning for further use.

1. Standardize Date Format from TIMESTAMP

![](resources/question_1.png)

2. Replace NULL values with data using SELF JOINS

![](resources/question_2.png)

3. Breaking Out PropertyAddress into Individual Columns (Address, City, State) using SUBSTRING AND CHARINDEX

![](resources/question_3.png)

4. Breaking Out OwnerAddress into Individual Columns (Address, City, State) using PARSENAME

![](resources/question_4.png)

5. Change Y and N to Yes and No in "SoldASVacant" field using CASE statements

![](resources/question_5.png)

6. Remove Duplicates with cte

![](resources/question_6.png)

7. Delete Unused Columns

![](resources/question_7.png)
