/*

Cleaning Data in SQL Queries

*/

SELECT *
FROM dbo.NashvilleHousing;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format


ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate);




--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address Data
-- Two seperate rows with different UNIQUEIDs but same ParcelIDs have the same address. So we do a SELF JOIN and populate the null values with the data provided

SELECT *
FROM dbo.NashvilleHousing 
ORDER BY ParcelID;

SELECT NH1.ParcelID, NH1.PropertyAddress, NH2.ParcelID, NH2.PropertyAddress, ISNULL(NH1.PropertyAddress, NH2.PropertyAddress)
FROM dbo.NashvilleHousing AS NH1
JOIN dbo.NashvilleHousing AS NH2
ON NH1.ParcelID = NH2.ParcelID AND NH1.UniqueID != NH2.UniqueID
WHERE NH1.PropertyAddress IS NULL;

UPDATE NH1
SET PropertyAddress = ISNULL(NH1.PropertyAddress, NH2.PropertyAddress)
FROM dbo.NashvilleHousing AS NH1
JOIN dbo.NashvilleHousing AS NH2
ON NH1.ParcelID = NH2.ParcelID AND NH1.UniqueID != NH2.UniqueID
WHERE NH1.PropertyAddress IS NULL;


--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking Out PropertyAddress into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM dbo.NashvilleHousing;

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1) AS Address,
RIGHT(PropertyAddress, LEN(PropertyAddress) - CHARINDEX(',', PropertyAddress)) AS City
FROM dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = RIGHT(PropertyAddress, LEN(PropertyAddress) - CHARINDEX(',', PropertyAddress));


----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking Out OwnerAddress into Individual Columns (Address, City, State)

SELECT OwnerAddress
FROM dbo.NashvilleHousing;

SELECT PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS owner_address,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS owner_city,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS owner_state
FROM dbo.NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "SoldASVacant" field

SELECT DISTINCT(SoldASVacant), COUNT(SoldAsVacant)
FROM dbo.NashvilleHousing
GROUP BY SoldASVacant
ORDER BY 2;

SELECT SoldAsVacant,
       CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	        WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SoldAsVacant END
FROM dbo.NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant END;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates


WITH table_row_num AS (SELECT *,
       ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS row_num
FROM dbo.NashvilleHousing)

DELETE
FROM table_row_num
WHERE row_num > 1;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete Unused Columns

SELECT *
FROM dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;
      










