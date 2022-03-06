Here's the link to the project Dataset in case you want to flick through:
https://www.kaggle.com/tmthyjames/nashville-housing-data-1/data


--Data Cleaning	project:

--1.Taking a look at our data:
Select * from portfolioProject..NashvilleHousing



--2.Changing the format of the 'Saledate' from datetime to date:
alter table portfolioProject..NashvilleHousing
add Saledateconverted Date;
update portfolioProject..NashvilleHousing
set Saledateconverted = Convert(date,SaleDate)
select saledateConverted from PortfolioProject..NashvilleHousing



--3.Spliting the PropertyAddress column into 'Address' column and 'City':
--I'm chosing the hard way to showcase my skills. Then I'll go with the easier way.
Select 
PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',propertyAddress) - 1) Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',propertyAddress) +1 , len(propertyAddress)) City
from portfolioProject..NashvilleHousing

alter table portfolioProject..NashvilleHousing
add Address nvarchar(255)
update portfolioProject..NashvilleHousing
set Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',propertyAddress) - 1)

alter table portfolioProject..NashvilleHousing
add City nvarchar(255)
update portfolioProject..NashvilleHousing
set City = SUBSTRING(PropertyAddress, CHARINDEX(',',propertyAddress) +1 , len(propertyAddress))

select * from PortfolioProject..NashvilleHousing


--4.Populate the 'Address' column if it's null:

select a.ParcelID, b.ParcelID, a.Address, b.Address, Isnull(a.Address, B.Address) Populated
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.Address  is null

Update a
Set a.Address = Isnull(a.Address, B.Address)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.Address  is null

--5.Here's an easier way to do the same thing with "OwnerAddress":
select OwnerAddress, 
Parsename(replace(OwnerAddress, ',', '.'), 2) Address
,Parsename(replace(OwnerAddress, ',', '.'), 1) City
from portfolioProject..NashvilleHousing
where OwnerAddress is not null


--6.Changing Y and N to 'Yes' and 'No' in "SoldAsVacant" feild:
Update PortfolioProject..NashvilleHousing
Set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
						when SoldAsVacant = 'N' then 'No'
						else SoldAsVacant end



--7.Remove Duplicates:
With CTE6 as (Select *, ROW_NUMBER() over(partition by ParcelID, 
									  PropertyAddress, 
									  SaleDate, 
									  SalePrice, 
									  LegalReference 
									  order by uniqueID) Row_num
from PortfolioProject..NashvilleHousing)
Delete 
from CTE6
where Row_num > 1



--8.Delete columns:
Alter Table PortfolioProject..NashvilleHousing
Drop column LandUse, OwnerAddress, Taxdistrict, PropertyAddress, Saledate

Alter Table PortfolioProject..NashvilleHousing
Drop column LandUse


select * from portfolioProject..NashvilleHousing

--Thank you for your time!
