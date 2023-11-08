

select *
From NashvilleHousing..Nashvillehousing


-- Standardize Date Format

select saleDateconverted, convert(date, saleDate)
From NashvilleHousing..Nashvillehousing


update nashvilleHousing..NashvilleHousing
Set SaleDate = convert(date, saleDate)

Alter Table NashvilleHousing..NashvilleHousing
Add SaleDateConverted Date;

update nashvilleHousing..NashvilleHousing
Set SaleDateConverted = convert(date, saleDate)


--Populate Property Address Data

Select *
From NashvilleHousing..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
From NashvilleHousing..NashvilleHousing a
Join NashvilleHousing..NashvilleHousing b
	on a.parcelId = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null	


Update a
Set propertyAddress = isnull(a.propertyaddress, b.PropertyAddress)
From NashvilleHousing..NashvilleHousing a
Join NashvilleHousing..NashvilleHousing b
	on a.parcelId = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out Address into individual columns (address, city, state)

Select PropertyAddress
From NashvilleHousing..NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID'

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', propertyAddress)+1, len(propertyAddress)) as City 

From NashvilleHousing..NashvilleHousing

Alter Table NashvilleHousing..NashvilleHousing
Add PropertySplitAddress nvarchar(255);

update nashvilleHousing..NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', propertyAddress)-1)

Alter Table NashvilleHousing..NashvilleHousing
Add PropertySplitCity nvarchar(255);

update nashvilleHousing..NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', propertyAddress)+1, len(propertyAddress))

Select *
From NashvilleHousing..NashvilleHousing



Select OwnerAddress
From NashvilleHousing..NashvilleHousing


Select
Parsename(REPLACE(ownerAddress, ',', '.'),3)
, Parsename(REPLACE(ownerAddress, ',', '.'),2)
, Parsename(REPLACE(ownerAddress, ',', '.'),1)

From NashvilleHousing..NashvilleHousing


Alter Table NashvilleHousing..NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

update nashvilleHousing..NashvilleHousing
Set OwnerSplitAddress = Parsename(REPLACE(ownerAddress, ',', '.'),3)

Alter Table NashvilleHousing..NashvilleHousing
Add OwnerSplitCity nvarchar(255);

update nashvilleHousing..NashvilleHousing
Set OwnerSplitCity = Parsename(REPLACE(ownerAddress, ',', '.'),2)

Alter Table NashvilleHousing..NashvilleHousing
Add OwnerSplitState nvarchar(255);

update nashvilleHousing..NashvilleHousing
Set OwnerSplitState = Parsename(REPLACE(ownerAddress, ',', '.'),1)


Select*
From NashvilleHousing..NashvilleHousing


Select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing..NashvilleHousing
Group By SoldAsVacant
Order By 2


Select SoldAsVacant
, Case When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END
From NashvilleHousing..NashvilleHousing


Update NashvilleHousing..NashvilleHousing
SET SoldAsVacant = 
Case When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END


-- Remove Duplicates
WITH RowNumCTE AS(
select *,
	Row_number()Over(
	Partition By ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order BY
					UniqueID) row_num

From NashvilleHousing..NashvilleHousing
--Order By ParcelID
)
Select *
From RowNumCTE
Where Row_num > 1
--Order By PropertyAddress




-- Delete Unused Columns

Select *
From NashvilleHousing..NashvilleHousing


Alter Table NashvilleHousing..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table NashvilleHousing..NashvilleHousing
Drop Column SaleDate