USE BigDataDWH;
GO

-- Schema creation
CREATE SCHEMA staging;
GO
CREATE SCHEMA dim;
GO
CREATE SCHEMA fact;
GO
CREATE SCHEMA etl;
GO

-- Dimension Table Creation
CREATE TABLE dim.location_dim_table (
    locationKey INT IDENTITY(1,1) PRIMARY KEY,
    city VARCHAR(100) NOT NULL,
    [state] VARCHAR(50) NOT NULL,
    zipCode VARCHAR(20) NOT NULL
);
GO

CREATE TABLE dim.block_dim_table (
    blockKey INT IDENTITY(1,1) PRIMARY KEY,
    latitude DECIMAL(10,6),
    longitude DECIMAL(10,6),
    blockName VARCHAR(100)
);
GO

CREATE TABLE dim.airport_dim_table (
    airportKey INT IDENTITY(1,1) PRIMARY KEY,
    isAirport VARCHAR(3)
);
GO

CREATE TABLE dim.route_dim_table (
    routeKey INT IDENTITY(1,1) PRIMARY KEY,
    routeOriginCity VARCHAR(50),
    routeDestCity VARCHAR(50),
    popularityIndex INT
);
GO

CREATE TABLE dim.payment_dim_table (
    paymentKey INT IDENTITY(1,1) PRIMARY KEY,
    paymentType VARCHAR(50),
    paymentTypeName VARCHAR(50)
);
GO

CREATE TABLE dim.ride_dim_table (
    rideTypeKey INT IDENTITY(1,1) PRIMARY KEY,
    rideOriginCity VARCHAR(50),
    rideDestCity VARCHAR(50),
    rideCategory VARCHAR(50),
    rideType VARCHAR(50)
);
GO

CREATE TABLE dim.time_dim_table (
    timeKey INT IDENTITY(1,1) PRIMARY KEY,
    [timestamp] DATETIME,
    [date] DATE,
    [time] TIME,
    dayOfWeek VARCHAR(10),
    [month] VARCHAR(10),
    holiday VARCHAR(3),
    [quarter] INT,
    [year] INT,
    [hour] INT,
    season VARCHAR(10)
);
GO

-- Fact Table Creation
CREATE TABLE fact.fact_table (
    trip_id INT IDENTITY(1,1) PRIMARY KEY,
    pickUpTimeKey INT,
    dropOffTimeKey INT,
    originLocationKey INT,
    destLocationKey INT,
    originBlockKey INT,
    destBlockKey INT,
    airportKey INT,
    rideKey INT,
    paymentKey INT,
    routeKey INT,
    baseFareAmount DECIMAL(10,2),
    tollAmount DECIMAL(10,2),
    extraFareAmount DECIMAL(10,2),
    surchargeAmount DECIMAL(5,2),
    gratuityAmount DECIMAL(5,2),
    mileage DECIMAL(10,2),
    duration INT,
    gratuityPercentage DECIMAL(29,13),
    profitPerMile DECIMAL(26,13),
    tripSatisfactionScore DECIMAL(23,13),
    surchargePercentage DECIMAL(29,13),
    FOREIGN KEY (pickUpTimeKey) REFERENCES dim.time_dim_table(timeKey),
    FOREIGN KEY (dropOffTimeKey) REFERENCES dim.time_dim_table(timeKey),
    FOREIGN KEY (originLocationKey) REFERENCES dim.location_dim_table(locationKey),
    FOREIGN KEY (destLocationKey) REFERENCES dim.location_dim_table(locationKey),
    FOREIGN KEY (originBlockKey) REFERENCES dim.block_dim_table(blockKey),
    FOREIGN KEY (destBlockKey) REFERENCES dim.block_dim_table(blockKey),
    FOREIGN KEY (airportKey) REFERENCES dim.airport_dim_table(airportKey),
    FOREIGN KEY (rideKey) REFERENCES dim.ride_dim_table(rideTypeKey),
    FOREIGN KEY (paymentKey) REFERENCES dim.payment_dim_table(paymentKey),
    FOREIGN KEY (routeKey) REFERENCES dim.route_dim_table(routeKey)
);
GO

-- Error Log Table Creation
CREATE TABLE etl.error_log (
    ErrorID INT IDENTITY(1,1) PRIMARY KEY,
    PackageName VARCHAR(100),
    TaskName VARCHAR(100),
    SourceColumn VARCHAR(100),
    ErrorDescription VARCHAR(500),
    ErrorCode VARCHAR(MAX),
    ErrorTime DATETIME DEFAULT GETDATE()
);
GO
