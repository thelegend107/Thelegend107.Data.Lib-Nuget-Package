-- use database
USE [datawarehouse];
GO

-- Drop tables if exists
IF OBJECT_ID(N'dbo.Skill', N'U') IS NOT NULL  
   DROP TABLE [dbo].[Skill];
GO

IF OBJECT_ID(N'dbo.Certificate', N'U') IS NOT NULL  
   DROP TABLE [dbo].[Certificate];
GO

IF OBJECT_ID(N'dbo.Link', N'U') IS NOT NULL  
   DROP TABLE [dbo].[Link];
GO

IF OBJECT_ID(N'dbo.EducationItem', N'U') IS NOT NULL  
   DROP TABLE [dbo].[EducationItem];
GO

IF OBJECT_ID(N'dbo.Education', N'U') IS NOT NULL  
   DROP TABLE [dbo].[Education];
GO

IF OBJECT_ID(N'dbo.WorkExperienceItem', N'U') IS NOT NULL  
   DROP TABLE [dbo].[WorkExperienceItem];
GO

IF OBJECT_ID(N'dbo.WorkExperience', N'U') IS NOT NULL  
   DROP TABLE [dbo].[WorkExperience];
GO

IF OBJECT_ID(N'dbo.User', N'U') IS NOT NULL  
   DROP TABLE [dbo].[User];
GO

IF OBJECT_ID(N'dbo.Address', N'U') IS NOT NULL  
   DROP TABLE [dbo].[Address];
GO

IF OBJECT_ID(N'dbo.State', N'U') IS NOT NULL  
   DROP TABLE [dbo].[State];
GO

IF OBJECT_ID(N'dbo.Country', N'U') IS NOT NULL  
   DROP TABLE [dbo].[Country];
GO

IF OBJECT_ID(N'dbo.SubRegion', N'U') IS NOT NULL  
   DROP TABLE [dbo].[SubRegion];
GO

IF OBJECT_ID(N'dbo.Region', N'U') IS NOT NULL  
   DROP TABLE [dbo].[Region];
GO

-- Create tables
CREATE TABLE Region (
    Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_Region PRIMARY KEY CLUSTERED,
	Name NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE SubRegion (
	Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_SubRegion PRIMARY KEY CLUSTERED,
	RegionId INT CONSTRAINT fk_Region_SubRegion FOREIGN KEY REFERENCES [dbo].[Region](Id) ON DELETE CASCADE ON UPDATE CASCADE,
	Name NVARCHAR(50) NOT NULL
);
GO

CREATE TABLE Country (
	Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_Country PRIMARY KEY CLUSTERED,
	RegionId INT NULL CONSTRAINT fk_Region_Country FOREIGN KEY REFERENCES [dbo].[Region](Id),
	SubRegionId INT NULL CONSTRAINT fk_SubRegion_Country FOREIGN KEY REFERENCES [dbo].[SubRegion](Id) ON DELETE CASCADE ON UPDATE CASCADE,
	Name NVARCHAR(50) NOT NULL,
	NativeName NVARCHAR(100) NULL,
	ISO3 NVARCHAR(3) NOT NULL,
	ISO2 NVARCHAR(2) NOT NULL,
	NumericCode int NOT NULL,
	PhoneCode NVARCHAR(50) NOT NULL,
	Capital NVARCHAR(50) NULL,
	Currency NVARCHAR(50) NOT NULL,
	CurrencyName NVARCHAR(50) NOT NULL,
	CurrencySymbol NVARCHAR(50) NOT NULL,
	Tld NVARCHAR(50) NOT NULL,
	Latitude FLOAT NULL,
	Longitude FLOAT NULL,
	Emoji NVARCHAR(50)
);
GO

CREATE TABLE State (
	Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_State PRIMARY KEY CLUSTERED,
	CountryId INT NOT NULL CONSTRAINT fk_Country_State FOREIGN KEY REFERENCES [dbo].[Country](Id) ON DELETE CASCADE ON UPDATE CASCADE,
	StateCode NVARCHAR(50) NOT NULL,
	Name NVARCHAR(100) NOT NULL,
	Latitude FLOAT NULL,
	Longitude FLOAT NULL
);
GO

CREATE TABLE [dbo].[Address] (
    Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_Address PRIMARY KEY CLUSTERED,
    Address1 nvarchar(max) NOT NULL,
    Address2 nvarchar(max) NULL,
    City nvarchar(max) NULL,
    PostalCode nvarchar(max) NULL,
    StateId int not null CONSTRAINT fk_State_Address FOREIGN KEY REFERENCES [dbo].[State](Id) ON DELETE CASCADE ON UPDATE CASCADE,
    CountryId int not null CONSTRAINT fk_Country_Address FOREIGN KEY REFERENCES [dbo].[Country](Id)
);
GO

CREATE TABLE [dbo].[User](
    Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_User PRIMARY KEY CLUSTERED,
    AddressId INT NULL CONSTRAINT fk_Address_User FOREIGN KEY REFERENCES [dbo].[Address](Id),
	Title NVARCHAR(MAX) NOT NULL,
    FirstName NVARCHAR(MAX) NOT NULL,
    LastName NVARCHAR(MAX) NOT NULL,
    Email NVARCHAR(MAX) NOT NULL,
    PhoneNumber NVARCHAR(MAX) NULL,
    Description NVARCHAR(MAX) NULL
);
GO

CREATE TABLE [dbo].[Customer](
    Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_Customer PRIMARY KEY CLUSTERED,
    AddressId INT NULL CONSTRAINT fk_Address_Customer FOREIGN KEY (AddressId) REFERENCES [dbo].[Address](Id),
    Company NVARCHAR(25) NULL,
    FirstName NVARCHAR(25) NOT NULL,
    LastName NVARCHAR(25) NOT NULL,
    Email NVARCHAR(max) NOT NULL,
    PhoneNumber varchar(20) NULL,
    Password NVARCHAR(max) NOT NULL,
    IsAdmin bit NOT NULL DEFAULT 0
);

CREATE TABLE [dbo].[WorkExperience](
    Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_WorkExperience PRIMARY KEY CLUSTERED,
    UserId INT NOT NULL CONSTRAINT fk_User_WorkExperience FOREIGN KEY REFERENCES [dbo].[User](Id) ON DELETE CASCADE ON UPDATE CASCADE,
    AddressId INT NULL CONSTRAINT fk_Address_WorkExperience FOREIGN KEY REFERENCES [dbo].[Address](Id),
    Employer NVARCHAR(MAX) NOT NULL,
    Title NVARCHAR(MAX) NOT NULL,
    StartDate Date NOT NULL,
    EndDate Date NOT NULL,
    PayRate decimal(18, 0) NULL
);
GO

CREATE TABLE [dbo].[WorkExperienceItem](
    Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_WorkExperienceItem PRIMARY KEY CLUSTERED,
    WorkExperienceId INT NOT NULL CONSTRAINT fk_WorkExperience_WorkExperienceItem FOREIGN KEY REFERENCES [dbo].[WorkExperience](Id) ON DELETE CASCADE ON UPDATE CASCADE,
    Description NVARCHAR(MAX) NOT NULL
);
GO

CREATE TABLE [dbo].[Education](
    Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_Education PRIMARY KEY CLUSTERED,
    UserId INT NOT NULL CONSTRAINT fk_User_Education FOREIGN KEY REFERENCES [dbo].[User](Id) ON DELETE CASCADE ON UPDATE CASCADE,
    AddressId INT NULL CONSTRAINT fk_Address_Education FOREIGN KEY REFERENCES [dbo].[Address](Id),
    School NVARCHAR(MAX) NOT NULL,
    StartDate Date NOT NULL,
    EndDate Date NOT NULL,
    Grade NVARCHAR(MAX) NULL
);
GO

CREATE TABLE [dbo].[EducationItem](
    Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_EducationItem PRIMARY KEY CLUSTERED,
    EducationId INT NOT NULL CONSTRAINT fk_Education_EducationItem FOREIGN KEY REFERENCES [dbo].[Education](Id) ON DELETE CASCADE ON UPDATE CASCADE,
    Name NVARCHAR(MAX) NOT NULL
);
GO

CREATE TABLE [dbo].[Skill](
    Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_Skill PRIMARY KEY CLUSTERED,
    UserId INT NOT NULL CONSTRAINT fk_User_Skill FOREIGN KEY REFERENCES [dbo].[User](Id) ON DELETE CASCADE ON UPDATE CASCADE,
    Type NVARCHAR(MAX) NOT NULL,
    Name NVARCHAR(MAX) NOT NULL
);
GO

CREATE TABLE [dbo].[Certificate](
    Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_Certificate PRIMARY KEY CLUSTERED,
    UserId INT NOT NULL CONSTRAINT fk_User_Certificate FOREIGN KEY REFERENCES [dbo].[User](Id) ON DELETE CASCADE ON UPDATE CASCADE,
    Name NVARCHAR(MAX) NOT NULL,
    CertificateId NVARCHAR(MAX) NULL,
    URL NVARCHAR(MAX) NULL,
    IssuedBy NVARCHAR(MAX) NULL,
    IssueDate DATE NULL
);
GO

CREATE TABLE [dbo].[Link](
    Id INT IDENTITY(1, 1) NOT NULL CONSTRAINT pk_Link PRIMARY KEY CLUSTERED,
    UserId INT NOT NULL CONSTRAINT fk_User_Link FOREIGN KEY REFERENCES [dbo].[User](Id) ON DELETE CASCADE ON UPDATE CASCADE,
    Name NVARCHAR(MAX) NOT NULL,
    URL NVARCHAR(MAX) NOT NULL
);