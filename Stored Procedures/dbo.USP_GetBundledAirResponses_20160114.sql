SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[USP_GetBundledAirResponses_20160114]
(  
   @airSubRequestKey int ,  
   @sortField varchar(50)='',  
   @airRequestTypeKey int ,      
   @pageNo int ,  
   @pageSize int ,  
   @airLines  varchar(200),  
   @price float ,  
   @NoOfSTOPs varchar (50)  ,  
   @SelectedResponseKey uniqueidentifier =null  ,  
   @SelectedResponseKeySecond uniqueidentifier =null  ,  
   @SelectedResponseKeyThird uniqueidentifier =null  ,  
   @SelectedResponseKeyFourth uniqueidentifier =null  ,  
   @minTakeOffDate Datetime ,  
   @maxTakeOffDate Datetime ,  
   @minLandingDate Datetime ,  
   @maxLandingDate Datetime ,  
   @drillDownLevel int = 0 ,  
   @gdssourcekey int = 0 ,  
   @SelectedFareType varchar(100) ='',   
   @superSetAirlines varchar(200)='',  
   @isIgnoreAirlineFilter bit = 0 ,     
   @isTotalPriceSort bit = 0 ,  
   @allowedOperatingAirlines varchar(400)=''    ,
   @excludeAirline varchar ( 500) = '',
   @excludedCountries varchar ( 500) = '',
   @siteKey int = 0
 )  
  AS   
 SET NOCOUNT ON   
 DECLARE @FirstRec INT  
 DECLARE @LastRec INT  
 DECLARE @isExcludeAirlinesPresent BIT = 0  ,@isExcludeCountryPresent BIT = 0 
 -- Initialize variables.  
 SET @FirstRec = (@pageNo  - 1) * @PageSize  
 SET @LastRec = (@pageNo  * @PageSize + 1)  
  
  -- print (cast(getdate() AS time))  
  
 DECLARE @airRequestKey AS int   
 SET @airRequestKey =( SELECT TOP 1 airRequestKey  FROM AirSubRequest WHERE airSubRequestKey = @airSubRequestKey )  
  
 DECLARE @airBundledRequest AS int   
 SET @airBundledRequest = (SELECT TOP 1 AirSubRequestKey FROM AirSubRequest WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex = -1 And groupKey = 1 )   
    
 DECLARE @airPublishedFareRequest AS int   
 SET @airPublishedFareRequest = (SELECT TOP 1 AirSubRequestKey FROM AirSubRequest WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex = -1 And groupKey = 2 )   
    
  /******/  
   
 DECLARE @AirSegments AS  TABLE    
 (  
 airSegmentKey uniqueidentifier ,  
 airResponseKey uniqueidentifier   ,  
 airLegNumber int NOT NULL,  
 airSegmentMarketingAirlineCode varchar(2)  ,  
 airSegmentOperatingAirlineCode varchar(2)  ,  
 airSegmentFlightNumber int  ,  
 airSegmentDuration time(7)  ,  
 airSegmentEquipment nvarchar(50)  ,  
 airSegmentMiles int  ,  
 airSegmentDepartureDate datetime  ,  
 airSegmentArrivalDate datetime  ,  
 airSegmentDepartureAirport varchar(50)  ,  
 airSegmentArrivalAirport varchar(50)  ,  
 airSegmentResBookDesigCode varchar(50)  ,  
 airSegmentDepartureOffset float  ,  
 airSegmentArrivalOffset float   ,  
 airSegmentSeatRemaining  int ,  
 airSegmentMarriageGrp char(10),  
 airFareBasisCode varchar(50) ,  
 airFareReferenceKey varchar(400),  
 airSegmentOperatingFlightNumber int ,  
 airsegmentCabin varchar (20) ,
 segmentOrder int,
 airSegmentOperatingAirlineCompanyShortName VARCHAR(100)
 )  
 
	 INSERT into @AirSegments ( airSegmentKey,airResponseKey,airLegNumber,airSegmentMarketingAirlineCode,airSegmentOperatingAirlineCode,airSegmentFlightNumber,airSegmentDuration,airSegmentEquipment,airSegmentMiles,airSegmentDepartureDate,airSegmentArrivalDate
	,airSegmentDepartureAirport,airSegmentArrivalAirport,airSegmentResBookDesigCode,airSegmentDepartureOffset,airSegmentArrivalOffset ,airSegmentSeatRemaining,airSegmentMarriageGrp ,airFareBasisCode ,airFareReferenceKey,airSegmentOperatingFlightNumber,airsegmentCabin ,segmentOrder,airSegmentOperatingAirlineCompanyShortName)  
	 (SELECT airSegmentKey,SEG.airResponseKey,airLegNumber,airSegmentMarketingAirlineCode,airSegmentOperatingAirlineCode,airSegmentFlightNumber,airSegmentDuration,(case when AircraftsLookup.AircraftName IS NULL then airSegmentEquipment else AircraftsLookup.AircraftName end) as airSegmentEquipment,airSegmentMiles,airSegmentDepartureDate,airSegmentArrivalDate,airSegmentDepartureAirport,airSegmentArrivalAirport,airSegmentResBookDesigCode,airSegmentDepartureOffset,airSegmentArrivalOffset ,airSegmentSeatRemaining,
	airSegmentMarriageGrp ,airFareBasisCode ,airFareReferenceKey,airSegmentOperatingFlightNumber,airsegmentCabin,segmentOrder,airSegmentOperatingAirlineCompanyShortName
	  From AirSegments seg INNER JOIN AirResponse  resp ON seg .airResponseKey = resp.airresponsekey    
	 INNER JOIN AirSubRequest sub on sub.airSubRequestKey = resp.airSubRequestKey   
	  LEFT OUTER JOIN AircraftsLookup on (seg.airSegmentEquipment = AircraftsLookup.SubTypeCode AND AircraftsLookup.SubTypeCode = AircraftsLookup.AircraftCode)  
	 WHERE  airRequestKey = @airRequestKey and (resp.airSubRequestKey  = @airBundledRequest   OR resp.airSubRequestKey =@airPublishedFareRequest)
	 AND ISNULL(resp.gdsSourceKey,2) =( Case WHEN @gdssourcekey = 0 THEN ISNULL(resp.gdsSourceKey ,2) ELSE @gdssourcekey END ) )  
	  
	  
	   /***code for date time offset ****/  
	 DECLARE @startAirPort AS varchar(100)   
	 DECLARE @endAirPort AS varchar(100)   
	 SELECT  @startAirPort=  airRequestDepartureAirport ,@endAirPort=airRequestArrivalAirport FROM AirSubRequest WHERE  airSubRequestKey = @airSubRequestKey   
	  
	 
	DECLARE @tempResponseToRemove AS table ( airresponsekey uniqueidentifier )   

	-- declare Tables
	DECLARE @tblAirlinesGroup AS TABLE ( marketingAirline varchar(10),operatingAirline varchar(10), groupKey int)
	DECLARE @tblSuperAirlines AS TABLE ( marketingAirline varchar(10))
	DECLARE @tblOperatingAirlines AS TABLE ( operatingAirline VARCHAR(10))
	DECLARE @tblExcludedAirlines AS TABLE ( excludeAirline VARCHAR(10))	  
	DECLARE @tblExcludedCountries AS TABLE ( excludeCountry VARCHAR(10))	  	  
	DECLARE @tblExcludedAirport AS TABLE ( excludeAirport VARCHAR(10))	  

	IF 	@superSetAirlines IS NOT NULL AND @superSetAirlines <> '' AND @allowedOperatingAirlines IS NOT NULL AND @allowedOperatingAirlines <> ''
	BEGIN
		-- insert data to airline tables
		INSERT @tblSuperAirlines (marketingAirline) SELECT * FROM vault .dbo.ufn_CSVToTable (@superSetAirlines)		
		INSERT @tblOperatingAirlines (operatingAirline) SELECT * FROM vault.dbo.ufn_CSVToTable (@allowedOperatingAirlines) 
		
		-- gourpkey 1: Add data to @tblAirlinesGroup(combination) table from @tblSuperAirlines and @tblOperatingAirlines
		INSERT INTO @tblAirlinesGroup(marketingAirline, operatingAirline, groupKey) 
		SELECT A.marketingAirline,b.operatingAirline, 1 from @tblSuperAirlines A 
		CROSS JOIN @tblOperatingAirlines B 	
		ORDER BY A.marketingAirline,B.operatingAirline	
		
		IF @airPublishedFareRequest > 0
		BEGIN
			-- gourpkey 2: Add data to @tblAirlinesGroup(combination) table @tblOperatingAirlines  
			INSERT INTO @tblAirlinesGroup(marketingAirline, operatingAirline, groupKey) 
			SELECT A.operatingAirline,b.operatingAirline, 2 from @tblOperatingAirlines A 
			CROSS JOIN @tblOperatingAirlines B 	
			ORDER BY A.operatingAirline,B.operatingAirline	
		END		
		
		---- Add data to @tblAirlinesGroup(combination) table from affiliate airlines
		IF @siteKey is not null AND @siteKey <> '' AND @siteKey > 0
		BEGIN 	
			IF (select COUNT(affiliateKey) from vault.dbo.affiliateAirlines where siteKey = @siteKey) > 0
			BEGIN			
				INSERT INTO @tblAirlinesGroup(marketingAirline, operatingAirline, groupKey) 			
				SELECT AFF.MarketingAirline, AFF.OperatingAirline, 1 
				FROM vault.dbo.affiliateAirlines AFF
				INNER JOIN @tblSuperAirlines S ON AFF.MarketingAirline = S.marketingAirline
				WHERE AFF.SiteKey = @siteKey
				
				IF @airPublishedFareRequest > 0 -- For GroupKey 2(Publish fares)
				BEGIN						
					INSERT INTO @tblAirlinesGroup(marketingAirline, operatingAirline, groupKey) 			
					SELECT AFF.MarketingAirline, AFF.OperatingAirline, 2 from vault.dbo.affiliateAirlines AFF
					WHERE AFF.SiteKey = @siteKey
				END
			END	
		END
					
		-- Add all responsekey to @tempResponseToRemove EXCEPT combinations from @tblAirlinesGroup table
		IF (SELECT COUNT(*) FROM @tblAirlinesGroup) > 0
		BEGIN
			INSERT @tempResponseToRemove (airresponsekey )
			(SELECT DISTINCT S.airresponsekey FROM AirSegments S WITH(NOLOCK) 
			INNER JOIN AirResponse AR WITH(NOLOCK)  ON S.airResponseKey = Ar.airResponseKey 
			INNER JOIN AirSubRequest SUB WITH(NOLOCK) ON Ar.airSubRequestKey = SUB.airSubRequestKey 		
			WHERE airRequestKey = @airRequestKey AND SUB.groupKey = 1
			AND S.airSegmentMarketingAirlineCode + S.airSegmentOperatingAirlineCode NOT IN 
			(SELECT AG.marketingAirline + AG.operatingAirline FROM @tblAirlinesGroup AG WHERE AG.groupKey = 1))
			
			IF @airPublishedFareRequest > 0 -- For GroupKey 2(Publish fares)
			BEGIN
				INSERT @tempResponseToRemove (airresponsekey )
				(SELECT DISTINCT S.airresponsekey FROM AirSegments S WITH(NOLOCK) 
				INNER JOIN AirResponse AR WITH(NOLOCK)  ON S.airResponseKey = Ar.airResponseKey 
				INNER JOIN AirSubRequest SUB WITH(NOLOCK) ON Ar.airSubRequestKey = SUB.airSubRequestKey 		
				WHERE airRequestKey = @airRequestKey AND SUB.groupKey = 2
				AND S.airSegmentMarketingAirlineCode + S.airSegmentOperatingAirlineCode NOT IN 
				(SELECT AG.marketingAirline + AG.operatingAirline FROM @tblAirlinesGroup AG WHERE AG.groupKey = 2))
			END			
		END
	END	

	-- Add responsekey to @tempResponseToRemove which contains excludes Airlines
	IF ( @excludeAirline  <> '' AND @excludeAirline IS NOT NULL )
	BEGIN 
		INSERT @tblExcludedAirlines (excludeAirline )   
		SELECT * FROM vault .dbo.ufn_CSVToTable (@excludeAirline)
		
		-- to exclude marketing airlines
		INSERT @tempResponseToRemove (airresponsekey )   
		(SELECT DISTINCT s.airResponseKey FROM AirSegments s WITH(NOLOCK) 
		INNER JOIN AirResponse resp WITH(NOLOCK) ON s.airResponseKey =resp.airResponseKey   
		INNER JOIN AirSubRequest subReq WITH(NOLOCK) ON resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey and airSegmentMarketingAirlineCode IN (SELECT * FROM @tblExcludedAirlines))

	  IF((SELECT COUNT(DISTINCT s.airResponseKey) FROM AirSegments s WITH(NOLOCK) 
	  INNER JOIN AirResponse resp WITH(NOLOCK) on s.airResponseKey =resp.airResponseKey   
	  INNER JOIN AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey =subReq.airSubRequestKey  
	  WHERE airRequestKey = @airRequestKey and airSegmentMarketingAirlineCode IN (SELECT * FROM @tblExcludedAirlines) )> 0 ) 
	  BEGIN
		SET @isExcludeAirlinesPresent =  1 
	  END 

		-- to exclude operating airlines
		INSERT @tempResponseToRemove (airresponsekey )   
		(SELECT DISTINCT s.airResponseKey FROM AirSegments s WITH(NOLOCK) 
		INNER JOIN AirResponse resp WITH(NOLOCK) ON s.airResponseKey =resp.airResponseKey   
		INNER JOIN AirSubRequest subReq WITH(NOLOCK) ON resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey and airSegmentOperatingAirlineCode in (SELECT * FROM @tblExcludedAirlines))

  		IF ( @isExcludeAirlinesPresent = 0 ) 
		BEGIN
			IF((SELECT COUNT(DISTINCT s.airResponseKey )FROM AirSegments s WITH(NOLOCK) 
		INNER JOIN AirResponse resp WITH(NOLOCK) ON s.airResponseKey =resp.airResponseKey   
		INNER JOIN AirSubRequest subReq WITH(NOLOCK) ON resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey and airSegmentOperatingAirlineCode in (SELECT * FROM @tblExcludedAirlines))>0) 
			BEGIN
				SET @isExcludeAirlinesPresent =  1 
			END 
		END
	END
	
	
	--Exclude Airport
	IF ( @excludedCountries  <> '' AND @excludedCountries IS NOT NULL )
	BEGIN 
	
		INSERT @tblExcludedCountries(excludeCountry)   
		SELECT * FROM vault .dbo.ufn_CSVToTable(@excludedCountries)
		
		INSERT @tblExcludedAirport(excludeAirport)
		SELECT AirportCode 
		FROM AirportLookup A
		INNER JOIN @tblExcludedCountries T ON A.CountryCode = T.excludeCountry
		
		-- to Exclude Airports
		INSERT @tempResponseToRemove (airresponsekey)   
		(SELECT DISTINCT s.airResponseKey FROM AirSegments s WITH(NOLOCK) 
		INNER JOIN AirResponse resp WITH(NOLOCK) on s.airResponseKey =resp.airResponseKey   
		INNER JOIN AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey 
		AND ((S.airSegmentDepartureAirport IN (SELECT * FROM @tblExcludedAirport)) OR (S.airSegmentArrivalAirport IN (SELECT * FROM @tblExcludedAirport))))
		
		IF((SELECT COUNT(DISTINCT s.airResponseKey) FROM AirSegments s WITH(NOLOCK) 
		INNER JOIN AirResponse resp WITH(NOLOCK) on s.airResponseKey =resp.airResponseKey   
		INNER JOIN AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey 
		AND ((S.airSegmentDepartureAirport IN (SELECT * FROM @tblExcludedAirport)) OR (S.airSegmentArrivalAirport IN (SELECT * FROM @tblExcludedAirport))))> 0 ) 
		BEGIN
			SET @isExcludeCountryPresent =  1 
		END 
    END
  
 ---CALCULATE DEPARTURE OFFSET     
 DECLARE @departureOffset AS float   
 SET @departureOffset =(  SELECT distinct  TOP 1  airSegmentDepartureOffset FROM AirSegments seg INNER JOIN AirResponse r ON seg.airResponseKey =r.airResponseKey  
  WHERE(  r.airSubRequestKey = @airSubRequestKey     )  AND airSegmentDepartureAirport= @startAirPort AND airSegmentDepartureOffset is not null  )  
 ---CALCULATE ARRIVAL OFFSET   
 DECLARE @arrivalOffset AS float   
 SET @arrivalOffset = (SELECT distinct TOP 1 airSegmentArrivalOffset  FROM AirSegments seg INNER JOIN AirResponse r ON seg.airResponseKey =r.airResponseKey  
 WHERE(  r.airSubRequestKey = @airSubRequestKey    )  AND airSegmentArrivalAirport=@endAirPort AND airSegmentArrivalOffset is not null )  
  
  
/****time offset logic ends here ***/  
  
/****logic for calculating price for higher legs *****/  
 DECLARE @airPriceForAnotherLeg AS FLOAT   
 DECLARE @airPriceTaxForAnotherLeg AS FLOAT   
 DECLARE @airPriceSeniorForAnotherLeg AS FLOAT   
 DECLARE @airPriceTaxSeniorForAnotherLeg AS FLOAT   
 DECLARE @airPriceChildrenForAnotherLeg AS FLOAT   
 DECLARE @airPriceTaxChildrenForAnotherLeg AS FLOAT   
 DECLARE @airPriceInfantForAnotherLeg AS FLOAT   
 DECLARE @airPriceTaxInfantForAnotherLeg AS FLOAT   
 DECLARE @airPriceTotalForAnotherLeg AS FLOAT   
 DECLARE @airPriceTaxTotalForAnotherLeg AS FLOAT   
 DECLARE @airPriceDisplayForAnotherLeg AS FLOAT   
 DECLARE @airPriceTaxDisplayForAnotherLeg AS FLOAT   
 DECLARE @airPriceYouthForAnotherLeg AS FLOAT   
 DECLARE @airPriceTaxYouthForAnotherLeg AS FLOAT
 
 DECLARE @tmpAirline  TABLE   
  (  
  airLineCode VARCHAR (200)   
  )  
    
	IF @NoOfSTOPs = '-1' /*****Default view WHEN no of sTOPs not SELECTed *********/  
	BEGIN   
		SET @NoOfSTOPs = '0,1,2'  
	END   

	DECLARE @noSTOPs AS table ( stops int  )  
	INSERT @noSTOPs (stops )  
	SELECT * FROM vault.dbo.ufn_CSVToTable (@NoOfSTOPs)  

	IF (SELECT gdsSourceKey  From AirResponse WHERE airResponseKey = @SELECTedResponseKey)  =  9    
	BEGIN   
		SET @airLines = (SELECT  DISTINCT TOP 1 airSegmentMarketingAirlineCode FROM AirSegments WHERE airResponseKey = @SELECTedResponseKey )  
	END   
	IF @airLines <> '' and @isIgnoreAirlineFilter <> 1    -- AND @airLines <> 'Multiple Airlines'  -- AND not exists(  SELECT @airLines WHERE @airLines like '%Multiple Airlines%')  
	BEGIN   
		INSERT into @tmpAirline(airlineCode)    SELECT * FROM vault.dbo.ufn_CSVToTable (@airLines )    
	END   
	ELSE       
	BEGIN   
		INSERT into @tmpAirline(airlineCode)  SELECT DISTINCT seg1.airSegmentMarketingAirlineCode FROM AirSegments seg1
		INNER JOIN AirResponse resp  ON seg1.airResponseKey = resp.airResponseKey WHERE 
		( resp.airSubRequestKey = @airSubRequestKey or resp .airSubRequestKey = @airBundledRequest   ) 
		
		INSERT into @tmpAirline(airlineCode)  SELECT DISTINCT seg1.airSegmentMarketingAirlineCode FROM AirSegments seg1
		INNER JOIN AirResponse resp  ON seg1.airResponseKey = resp.airResponseKey WHERE 
		(   resp .airSubRequestKey = @airPublishedFareRequest    ) 

		INSERT into @tmpAirline (airLineCode ) VALUES  ('Multiple Airlines')  
	END     

	DECLARE  @selectedDate AS DATETIME   
    
---creating TABLE variable for container for flitered result ..  
 DECLARE @airResponseResultset TABLE   
 (  
  airSegmentKey uniqueidentifier,  
  airResponseKey uniqueidentifier ,  
  airLegNumber int,  
  airSegmentMarketingAirlineCode varchar(10) ,  
  airSegmentFlightNumber varchar(50),   
  airSegmentDuration time ,   
  airSegmentEquipment varchar(50) ,   
  airSegmentMiles int  ,   
  airSegmentDepartureDate datetime  ,  
  airSegmentArrivalDate datetime ,   
  airSegmentDepartureAirport  varchar(50),    
  airSegmentArrivalAirport  varchar(50),        
  airPrice float ,  
  airPriceTax float ,  
  airPriceBaseSenior float,
  airPriceTaxSenior float,
  airPriceBaseChildren float,
  airPriceTaxChildren float,
  airPriceBaseInfant float,
  airPriceTaxInfant float,
  airPriceBaseYouth float,
  airPriceTaxYouth float,
  AirPriceBaseTotal float,
  AirPriceTaxTotal float,
  airPriceBaseDisplay float,
  airPriceTaxDisplay float,
  airRequestKey int,  
  gdsSourceKey int ,      
  MarketingAirlineName  varchar(50),  
  NoOfStops int ,  
  actualTakeOffDateForLeg datetime ,  
  actualLandingDateForLeg datetime ,  
  airSegmentOperatingAirlineCode varchar(10),  
  airSegmentResBookDesigCode varchar(3),  
  noofAirlines int ,  
  airlineName varchar(50),  
  airsegmentDepartureOffset float ,  
  airSegmentArrivalOffset float,  
  airSegmentSeatRemaining int ,  
  priceClassCommentsSuperSaver varchar(500),  
  priceClassCommentsEconSaver varchar(500),  
  priceClassCommentsFirstFlex varchar(500),  
  priceClassCommentsCorporate varchar(500),  
  priceClassCommentsEconFlex varchar(500),  
  priceClassCommentsEconUpgrade varchar(500),        
  airSuperSaverPrice float ,  
  airEconSaverPrice float ,  
  airFirstFlexPrice  float ,  
  airCorporatePrice  float ,  
  airEconFlexPrice float       ,  
  airEconUpgradePrice float ,  
  airClassSuperSaver   varchar (50) NULL,  
  airClassEconSaver    varchar (50) NULL,  
  airClassFirstFlex    varchar (50) NULL,  
  airClassCorporate    varchar (50) NULL,  
  airClassEconFlex    varchar (50) NULL,  
  airClassEconUpgrade   varchar (50) NULL,  
  airSuperSaverSeatRemaining   int  NULL,  
  airEconSaverSeatRemaining   int  NULL,  
  airFirstFlexSeatRemaining   int  NULL,  
  airCorporateSeatRemaining   int  NULL,  
  airEconFlexSeatRemaining   int  NULL,  
  airEconUpgradeSeatRemaining   int  NULL,  
  airSuperSaverFareReferenceKey   varchar (50) NULL,  
  airEconSaverFareReferenceKey   varchar (50) NULL,  
  airFirstFlexFareReferenceKey   varchar (50) NULL,  
  airCorporateFareReferenceKey   varchar (50) NULL,  
  airEconFlexFareReferenceKey   varchar (50) NULL,  
  airEconUpgradeFareReferenceKey   varchar (50) NULL,  
  airPriceClassSelected   varchar (50) NULL ,  
  otherLegPrice float ,  
  isRefundable bit ,  
  isbrandedFare bit ,  
  cabinClass varchar(20) ,  
  fareType varchar (20),segmentOrder int ,airsegmentCabin varchar (20),  
  totalCost float ,airSegmentOperatingFlightNumber int, otherlegtax float ,  
  isgeneratedBundle bit,
  airSegmentOperatingAirlineCompanyShortName VARCHAR(100)  
 )  
  
  
 print('uniquifying started ..')  
 print (cast(getdate() AS time))  
  
  
 DECLARE @tempOneWayResponses AS TABLE   
 (  
  airOneIdent int identity (1,1),  
  airOneResponsekey uniqueidentifier ,   
  airOnePriceBase float ,  
  airOnePriceTax float,  
  airOneBaseSenior float,
  airOneTaxSenior float,
  airOneBaseChildren float,
  airOneTaxChildren float,
  airOneBaseInfant float,
  airOneTaxInfant float,
  airOneBaseYouth float,
  airOneTaxYouth float,
  airOneBaseTotal float,
  airOneTaxTotal float,
  airOneBaseDisplay float,
  airOneTaxDisplay float,
  airSegmentFlightNumber varchar(100),  
  airSegmentMarketingAirlineCode varchar(100),  
  airsubRequestkey int   
  ,airLegConnections varchar(200),  
  airLegBookingClasses varchar(50),  
  otherLegPrice float ,  
  otherLegTax float  ,  
  cabinClass varchar(20) ,airlegnumber int   
 )  
    
	INSERT @tempOneWayResponses (airOneResponsekey,airOnePriceBase,airOneBaseSenior ,airOneTaxSenior, airOneBaseChildren ,airOneTaxChildren ,airOneBaseInfant, airOneTaxInfant,airOneBaseYouth, airOneTaxYouth, airOneBaseTotal, airOneTaxTotal, airOneBaseDisplay, airOneTaxDisplay,airSegmentFlightNumber,airSegmentMarketingAirlineCode,airsubRequestkey,airOnePriceTax   ,cabinClass ,otherLegPrice  ,airlegnumber   )  
	       
	SELECT resp.AirResponsekey, airPriceBase ,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth,airPriceTaxYouth,AirPriceBaseTotal,AirPriceTaxTotal,airPriceBaseDisplay,airPriceTaxDisplay,nresp.flightNumber ,nresp.airlines,nresp.airSubRequestKey,airPriceTax ,nresp.cabinclass,(case when @isTotalPriceSort = 0 then isnull(@airPriceForAnotherLeg,0)else ( isnull(@airPriceForAnotherLeg,0) + isnull(@airPriceTaxForAnotherLeg,0))  end),nresp.airLegNumber   
	FROM AirResponse resp  INNER JOIN NormalizedAirResponses nresp ON resp.airResponseKey = nresp .airresponsekey   
	inner join AirSubRequest sub on sub.airSubRequestKey =resp.airSubRequestKey where airRequestKey =@airRequestKey   
	AND ISNULL(resp.gdsSourceKey,2) =( CASE WHEN @gdssourcekey = 0 THEN ISNULL(resp.gdsSourceKey,2) ELSE @gdssourcekey END )    
	 
	--SELECT p1.airresponsekey ,airpricebase ,  
	--( SELECT flightNumber  + ',' FROM NormalizedAirResponses p2 WHERE p2.airresponsekey = p1.airresponsekey   
	--ORDER BY airLegNumber FOR XML PATH('') ) AS flightnumber ,  
	--( SELECT airlines   + ',' FROM NormalizedAirResponses p2 WHERE p2.airresponsekey = p1.airresponsekey   
	--ORDER BY airLegNumber FOR XML PATH('') ) AS airlines ,  
	--p1.airsubrequestkey ,airPriceTax ,p1.cabinclass ,(case when @isTotalPriceSort = 0 then isnull(@airPriceForAnotherLeg,0)else ( isnull(@airPriceForAnotherLeg,0) + isnull(@airPriceTaxForAnotherLeg,0))  end)   
	--FROM NormalizedAirResponses  p1 inner join AirResponse resp on p1.airresponsekey = resp.airResponseKey   
	--inner join AirSubRequest sub on sub.airSubRequestKey =resp.airSubRequestKey where airRequestKey =@airRequestKey    
	--AND ISNULL(resp.gdsSourceKey,2) =( CASE WHEN @gdssourcekey = 0 THEN ISNULL(resp.gdsSourceKey,2) ELSE @gdssourcekey END )    
	--GROUP BY p1.airresponsekey  ,airpricebase ,airPriceTax,p1.cabinClass ,p1.airsubrequestkey   

   
	DECLARE @noOfLegsForRequest AS int   
	SET @noOfLegsForRequest =( SELECT COUNT(*) FROM AirSubRequest WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex > 0 )   

	IF @gdssourcekey = 9   
	BEGIN  
		IF ( @airLines <> 'Multiple Airlines')  
		BEGIN   
			delete from @tempOneWayResponses where airOneResponsekey in (  
			select distinct seg.airResponseKey   FROM AirSegments seg INNER JOIN AirResponse  resp ON seg .airResponseKey = resp.airresponsekey   
			INNER JOIN AirSubRequest subrequest ON resp.airSubRequestKey = subrequest .airSubRequestKey 
			and seg.airSegmentMarketingAirlineCode not in (select * From @tmpAirline )   
			WHERE   airrequestKey = @airRequestKey    AND gdsSourceKey = @gdssourcekey)  
		END  
	END   
  
	 --DELETE @tempOneWayResponses  
	 --FROM @tempOneWayResponses t,  
	 --(  
	 -- SELECT min(airOnePriceBase) AS minPrice,MIN(airOneIdent )  AS minIdent,   airSegmentFlightNumber,airSegmentMarketingAirlineCode  ,isnull(cabinClass ,'') cabinClass  
	 -- FROM @tempOneWayResponses m  
	 -- GROUP BY   airSegmentFlightNumber,airSegmentMarketingAirlineCode   ,isnull(cabinClass ,'')  fffffffffff
	 -- having count(1) > 1  
	 --) AS derived  
	 --WHERE t.airSegmentFlightNumber = derived.airSegmentFlightNumber AND t.airSegmentMarketingAirlineCode =derived .airSegmentMarketingAirlineCode  AND isnull(t.cabinclass,'') =isnull(derived .cabinclass,'')   
	 --AND airOnePriceBase >= minPrice  AND airOneIdent > minIdent  
	  
	 -- print (cast(getdate() AS time))  
	 -- print('uniquifying ended ..')  
	   
	   

CREATE TABLE #normal
(
id int identity (1,1),
airresponsekey uniqueidentifier,
airsubrequestkey INT ,
leg1FlightNumber varchar(100), 
leg1Airlines varchar(100),
leg1Connection varchar(100),
leg2FlightNumber varchar(100), 
leg2Airlines varchar(100),
leg2Connection varchar(100),

leg3FlightNumber varchar(100), 
leg3Airlines varchar(100),
leg3Connection varchar(100),

leg4FlightNumber varchar(100), 
leg4Airlines varchar(100),
leg4Connection varchar(100),

leg5FlightNumber varchar(100), 
leg5Airlines varchar(100),
leg5Connection varchar(100),

leg6FlightNumber varchar(100), 
leg6Airlines varchar(100),
leg6Connection varchar(100),
airPriceTotal float

)
 INSERT INTO #normal (airresponsekey,airsubrequestkey,leg1flightnumber,leg1airlines,leg1Connection,airPriceTotal)

 SELECT n1.airresponsekey,n1.airsubrequestkey,n1.flightNumber , n1.airlines,n1.airLegConnections ,A.airpricebaseTotal + A.airpriceTaxTotal
 --,n3.flightNumber , n3.airlines,n3.airLegConnections 
 FROM NormalizedAirResponses N1 WITH (NOLOCK) INNER JOIN AirResponse A WITH (NOLOCK) on N1.airresponsekey = A.airresponsekey
WHERE (n1.airsubrequestkey =@airBundledRequest or n1.airSubrequestkey = @airPublishedFareRequest) and airlegnumber =1 
ORDER BY (A.airpricebaseTotal + A.airpriceTaxTotal) ASC , N1.airsubrequestkey,N1.airresponsekey
---Leg2
UPDATE  N SET leg2flightNUMBER = flightNumber , leg2Airlines = N1.airlines, leg2Connection = N1.airLegConnections FROM #normal N INNER JOIN NormalizedAirResponses N1 WITH (NOLOCK)ON N.airresponsekey = N1.airresponsekey AND N1.airlegnumber = 2 
UPDATE  N SET leg3flightNUMBER = flightNumber , leg3Airlines = N1.airlines, leg3Connection = N1.airLegConnections FROM #normal N INNER JOIN NormalizedAirResponses N1 WITH (NOLOCK) ON N.airresponsekey = N1.airresponsekey AND N1.airlegnumber = 3 
UPDATE  N SET leg4flightNUMBER = flightNumber , leg4Airlines = N1.airlines, leg4Connection = N1.airLegConnections FROM #normal N INNER JOIN NormalizedAirResponses N1 WITH (NOLOCK) ON N.airresponsekey = N1.airresponsekey AND N1.airlegnumber = 4 

UPDATE  N SET leg5flightNUMBER = flightNumber , leg5Airlines = N1.airlines, leg5Connection = N1.airLegConnections FROM #normal N INNER JOIN NormalizedAirResponses N1 WITH (NOLOCK) ON N.airresponsekey = N1.airresponsekey AND N1.airlegnumber = 5 
--leg6
UPDATE  N SET leg6flightNUMBER = flightNumber , leg6Airlines = N1.airlines, leg6Connection = N1.airLegConnections FROM #normal N INNER JOIN NormalizedAirResponses N1 WITH (NOLOCK) ON N.airresponsekey = N1.airresponsekey AND N1.airlegnumber = 6 



--SELECT count(*) FROM #normal 

--SELECT min(ID),max(ID), MIn(airPriceTotal),Max(airPriceTotal),count(*)COUNT1,  leg1FlightNumber,leg1Airlines,leg1Connection ,leg2FlightNumber,leg2Airlines,leg2Connection,leg3FlightNumber,leg3Airlines,leg3Connection ,leg4FlightNumber,leg4Airlines,leg4Connection,leg5FlightNumber,leg5Airlines,leg5Connection,leg6FlightNumber,leg6Airlines,leg6Connection FROM #normal 
--group by leg1FlightNumber,leg1Airlines,leg1Connection ,leg2FlightNumber,leg2Airlines,leg2Connection,leg3FlightNumber,leg3Airlines,leg3Connection ,leg4FlightNumber,leg4Airlines,leg4Connection,leg5FlightNumber,leg5Airlines,leg5Connection,leg6FlightNumber,leg6Airlines,leg6Connection
-- having count(*) > 1
 
 
DELETE FROM #Normal 
WHERE ID not in 
(
SELECT min(ID)  FROM #normal 
group by leg1FlightNumber,leg1Airlines,leg1Connection ,leg2FlightNumber,leg2Airlines,leg2Connection,leg3FlightNumber,leg3Airlines,leg3Connection ,leg4FlightNumber,leg4Airlines,leg4Connection,leg5FlightNumber,leg5Airlines,leg5Connection,leg6FlightNumber,leg6Airlines,leg6Connection
 )
 --SELECT COUNT(*) FROM #normal 

 
DECLARE @normalizedResultSet   AS TABLE   
(  
  airresponsekey uniqueidentifier ,  
  noOFStops int ,  
  airPriceBase float ,  
  gdssourcekey int ,  
  noOfAirlines int ,  
  takeoffdate datetime ,  
  landingdate datetime ,   
  airlineCode varchar(60),  
  airpriceTax float ,  
  airsubrequetkey int  ,cabinclass varchar(20),  
  otherlegPrice float ,otherlegtax float ,airlegnumber int   
 )   
  
	INSERT  @normalizedResultSet (airresponsekey ,airPriceBase,noOFStops ,noOfAirlines ,takeoffdate ,landingdate ,airlinecode ,gdssourcekey ,airpricetax ,airsubrequetkey ,cabinclass ,otherlegPrice,otherlegtax ,airlegnumber   )  
	(SELECT seg.airresponsekey,result.airOneBaseDisplay ,CASE WHEN COUNT(seg.airresponsekey )-1 > 1 THEN 1 ELSE  COUNT(seg.airresponsekey )-1 END ,COUNT(distinct seg.airSegmentMarketingAirlineCode ),MIN(airSegmentDepartureDate ) ,MAX(airSegmentArrivalDate ),  
	CASE WHEN COUNT(distinct seg.airSegmentMarketingAirlineCode ) > 1 THEN 'Multiple Airlines'  ELSE MIN(seg.airSegmentMarketingAirlineCode) END ,  
	resp.gdsSourceKey, result.airOneTaxDisplay ,result.airsubRequestkey ,result .cabinClass  ,otherLegPrice,otherLegTax  ,result.airlegnumber   
	FROM @tempOneWayResponses result  INNER JOIN 
	  
	AirResponse resp   ON resp.airResponseKey = result.airOneResponsekey   
	
	INNER JOIN  AirSegments seg   ON result .airOneResponsekey = seg.airResponseKey   
	INNER JOIN #normal N ON resp.airresponsekey = N.airresponsekey   
	GROUP BY seg.airResponseKey,result.airOneBaseDisplay ,gdssourcekey  ,result .airOneTaxDisplay , result.airsubRequestkey ,result.cabinClass ,result.otherlegprice,otherLegTax ,result.airlegnumber)  
    
	INSERT into @airResponseResultset (airSegmentKey , airResponseKey,airLegNumber,airSegmentMarketingAirlineCode,airSegmentFlightNumber,airSegmentDuration, airSegmentEquipment,airSegmentMiles,airSegmentDepartureDate,airSegmentArrivalDate ,airSegmentDepartureAirport,airSegmentArrivalAirport,airPrice,MarketingAirlineName,NoOfStops ,actualTakeOffDateForLeg,actualLandingDateForLeg ,airSegmentOperatingAirlineCode , airSegmentResBookDesigCode,noofAirlines ,airlineName , gdsSourceKey ,airPriceTax ,airRequestKey 
	, airsegmentDepartureOffset,airSegmentArrivalOffset ,airSegmentSeatRemaining,priceClassCommentsSuperSaver,priceClassCommentsEconSaver ,priceClassCommentsFirstFlex ,priceClassCommentsCorporate,priceClassCommentsEconFlex,priceClassCommentsEconUpgrade, airSuperSaverPrice ,airEconSaverPrice ,airFirstFlexPrice ,airCorporatePrice,airEconFlexPrice,airEconUpgradePrice ,airClassSuperSaver,airClassEconSaver,airClassFirstFlex,airClassCorporate,airClassEconFlex,airClassEconUpgrade,airSuperSaverSeatRemaining,airEconSaverSeatRemaining,airFirstFlexSeatRemaining,airCorporateSeatRemaining,airEconFlexSeatRemaining,airEconUpgradeSeatRemaining, airPriceClassSelected,otherLegPrice,isRefundable,isBrandedFare  ,cabinClass ,fareType,segmentOrder ,airsegmentCabin ,totalCost,
	airSegmentOperatingFlightNumber ,otherlegtax ,isgeneratedBundle,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,AirPriceBaseTotal,AirPriceTaxTotal,airPriceBaseDisplay, airPriceTaxDisplay,airSegmentOperatingAirlineCompanyShortName )  
	SELECT seg.airSegmentKey, seg.airResponseKey, seg.airLegNumber, seg. airSegmentMarketingAirlineCode ,seg. airSegmentFlightNumber, seg.airSegmentDuration , seg.airSegmentEquipment , seg.airSegmentMiles , seg.airSegmentDepartureDate , seg.airSegmentArrivalDate , seg.airSegmentDepartureAirport , seg.airSegmentArrivalAirport  ,normalized .airPriceBase      AS airPriceBase , airVendor.ShortName AS MarketingAirlineName ,noOFStops  ,  takeoffdate  , landingdate ,airSegmentOperatingAirlineCode , seg.airSegmentResBookDesigCode,noOfAirlines ,normalized .airlineCode , ISNULL(normalized.gdssourcekey,2) ,normalized.airpriceTax  ,airsubrequetkey ,airsegmentDepartureOffset,airSegmentArrivalOffset ,airSegmentSeatRemaining,priceClassCommentsSuperSaver ,priceClassCommentsEconSaver,
	priceClassCommentsFirstFlex ,priceClassCommentsCorporate,priceClassCommentsEconFlex,priceClassCommentsEconUpgrade,airSuperSaverPrice ,airEconSaverPrice ,airFirstFlexPrice ,airCorporatePrice ,airEconFlexPrice,airEconUpgradePrice,airClassSuperSaver,
	airClassEconSaver,airClassFirstFlex,airClassCorporate,airClassEconFlex,airClassEconUpgrade,airSuperSaverSeatRemaining,airEconSaverSeatRemaining,airFirstFlexSeatRemaining,airCorporateSeatRemaining,airEconFlexSeatRemaining,airEconUpgradeSeatRemaining, airPriceClassSelected ,   
	isnull (otherlegPrice,0)    ,refundable   ,isBrandedFare ,normalized .cabinclass ,fareType,segmentOrder ,seg.airsegmentCabin,(isnull(normalized.airPriceBase,0) + ISNULL (normalized.airpriceTax,0) ),seg.airSegmentOperatingFlightNumber,otherlegtax ,isGeneratedBundle,
	airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,AirPriceBaseTotal,AirPriceTaxTotal,airPriceBaseDisplay, airPriceTaxDisplay,seg.airSegmentOperatingAirlineCompanyShortName   
	FROM @AirSegments seg     
	INNER JOIN @normalizedResultSet normalized ON (seg.airresponsekey = normalized .airresponsekey  and seg.airLegNumber = normalized.airlegnumber  )  
	INNER JOIN AirResponse resp ON seg .airresponsekey = resp.airResponseKey   
	INNER JOIN @noStops nStop ON normalized .noOFStops = nStop .stops   
	INNER JOIN  AirVendorLookup airVendor   ON seg.airSegmentMarketingAirlineCode = airVendor  .AirlineCode    
	-- WHERE normalized.airPriceBase  <=    @price    
	--AND ( takeoffdate    BETWEEN @minTakeOffDate AND @maxTakeOffDate    )  
	--AND (  landingdate  BETWEEN @minLandingDate AND @maxLandingDate  )  
	---- print ( cast(getdate() AS time )  )  
	---- print('result')
	
 DECLARE @pagingResultSet Table   
 (  
  rowNum int IDENTITY(1,1) NOT NULL,     
  airResponseKey uniqueidentifier  ,  
  airlineName varchar(100),   
  airPrice float ,   
  actualTakeOffDateForLeg datetime   
  )   
  
	IF @sortField <> ''  
	BEGIN   
		INSERT into @pagingResultSet (airResponseKey,airPrice ,actualTakeOffDateForLeg ,airlineName    )  

		SELECT    air.airResponseKey ,MIN(airPriceBaseDisplay) ,MIN(actualTakeOffDateForLeg) , MIN(MarketingAirlineName)  FROM @airResponseResultset air   
		INNER JOIN @normalizedResultSet normalized ON air.airresponsekey = normalized .airresponsekey   
		INNER  JOIN @tmpAirline airline ON (normalized .airlineCode  = airline.airLineCode   )   
		GROUP BY air.airResponseKey,airlineName   order by   
		CASE WHEN @sortField  = 'Price'      THEN    ( case When @isTotalPriceSort = 0  then MIN( airPrice)  else MIN(totalCost ) END  )     END  ,    
		CASE WHEN @sortField  = 'Airline' THEN  MIN(MarketingAirlineName)         END   ,   
		CASE WHEN @sortField  ='Departure' THEN MIN( actualTakeOffDateForLeg) END   ,  
		--CASE WHEN @sortField ='Duration' THEN MIN(duration) END ,  
		CASE WHEN @sortField  ='' THEN MIN( airPrice)  END      
		---- print ( cast(getdate() AS time )  )  
	END   
	ELSE   
	BEGIN   
		INSERT into @pagingResultSet (airResponseKey,airPrice ,actualTakeOffDateForLeg ,airlineName    )  
		SELECT    air.airResponseKey ,MIN(airPriceBaseDisplay ) ,MIN(actualTakeOffDateForLeg) , MIN(MarketingAirlineName)  FROM @airResponseResultset air   
		INNER JOIN @normalizedResultSet normalized ON air.airresponsekey = normalized .airresponsekey   
		INNER  JOIN @tmpAirline airline ON (normalized .airlineCode  = airline.airLineCode   )   
		GROUP BY air.airResponseKey,airlineName   order by ( case When @isTotalPriceSort = 0  then MIN( airPrice)  else MIN(totalCost ) END),MIN(MarketingAirlineName) , min(normalized.noOFStops ),MIN( actualTakeOffDateForLeg) ,MIN( actualLandingDateForLeg )  
		-- print('page default')  
	END
	---- print ( cast(getdate() AS time )  )  
  
	IF ( @superSetAirlines is not null AND @superSetAirlines <> '' )  
	BEGIN   
		Delete P  
		FROM @pagingResultSet P  
		INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey  
	END   

	--Hemali
	 IF ( @excludeAirline  <> '' AND @excludeAirline IS NOT NULL )  
	 BEGIN     
	  Delete P    
	  FROM @pagingResultSet P    
	  INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey    
	  
	  Delete P    
      FROM @airResponseResultset P    
      INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey       
    
      Delete P    
      FROM @normalizedResultSet P    
      INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey        
	 END  
	 
	 IF ( @excludedCountries  <> '' AND @excludedCountries IS NOT NULL )
	 BEGIN
		Delete P    
		FROM @pagingResultSet P    
		INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey    
	  
		Delete P    
		FROM @airResponseResultset P    
		INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey       
    
		Delete P    
		FROM @normalizedResultSet P    
		INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey    
	 END
	   
	/**MAIN RESULTSET FOR LIST STARTS HERE**/  
 
	SELECT distinct    rowNum,air.*, airSegmentArrivalOffset,departureAirport .CityName AS DepartureAirPortCityName ,departureAirport.StateCode AS DepartureAirportStateCode ,departureAirport .AirportName AS DepartureAirportName , departureAirport.CountryCode
	AS DepartureAirportCountryCode,   
	arrivalAirport .CItyName AS ArrivalAirPortCityName ,arrivalAirport .StateCode AS ArrivalAirportStateCode , arrivalAirport .AirportName AS ArrivalAirportName ,arrivalAirport .CountryCode  AS ArrivalAirportCountryCode,  
	operatingAirline .ShortName AS OperatingAirlineName,isRefundable ,isbrandedFare,
	CD.CountryName AS DepartureAirportCountryName, CA.CountryName AS ArrivalAirportCountryName
	FROM @airResponseResultset air INNER JOIN @pagingResultSet  paging ON air.airResponseKey = paging.airResponseKey  
	LEFT OUTER JOIN AirVendorLookup operatingAirline    ON air .airSegmentOperatingAirlineCode = operatingAirline .AirlineCode   
	LEFT OUTER JOIN AirportLookup departureAirport   ON air .airSegmentDepartureAirport = departureAirport .AirportCode   
	LEFT OUTER JOIN AirportLookup arrivalAirport    ON air .airSegmentArrivalAirport =arrivalAirport .AirportCode   
	LEFT OUTER JOIN Vault..CountryLookup CD  WITH (NOLOCK)  ON departureAirport.CountryCode = CD.CountryCode
	LEFT OUTER JOIN Vault..CountryLookup CA WITH (NOLOCK)  ON arrivalAirport.CountryCode = CA.CountryCode
	order by rowNum ,airLegNumber ,segmentOrder, airSegmentDepartureDate  
	/**MAIN RESULTSET FOR LIST ENDS HERE**/  
	
	IF ( @superSetAirlines is not null AND @superSetAirlines <> '' )  
	BEGIN   
		Delete P  
		FROM @airResponseResultset P  
		INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey      
		Delete P  
		FROM @normalizedResultSet P  
		INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey     
	END   

	/****MIN-MAX PRICE FOR FILTERS ***/  
	SELECT (case when @isTotalPriceSort = 0 then MIN (airPriceBaseDisplay)  else MIN (totalCost ) end ) AS LowestPrice ,MAX(airPriceBaseDisplay ) AS HighestPrice FROM @airResponseResultset  result1   
	/****MIN-MAX PRICE FOR FILTERS END***/  
   
	/****TAKEOFF-LANDING TIME START****/  
	SELECT distinct  MIN (actualTakeOffDateForLeg ) AS MinDepartureTakeOffDate,  MAX (actualTakeOffDateForLeg) AS MaxDepartureTakeOffDate, MIN (actualLandingDateForLeg) AS MinDepartureLandingDate,  MAX (actualLandingDateForLeg) AS MaxDepartureLandingDate   
	FROM @airResponseResultset    
	/****TAKEOFF-LANDING TIME END****/  
   
	/* Stops for Slider START*/  
	SELECT distinct NoOfStops AS NoOfStops  FROM @airResponseResultset      
	/* Stops for Slider END*/  
  
	/******TOTAL RECORD COUNT FOUND START *********/  
    SELECT COUNT(*) AS [TotalCount] FROM @pagingResultSet   
	/******TOTAL RECORD COUNT FOUND END *********/   
	IF @airLines <> '' and @isIgnoreAirlineFilter = 1    
	BEGIN  
		delete from @tmpAirline    
		INSERT into @tmpAirline(airlineCode)    SELECT * FROM vault.dbo.ufn_CSVToTable (@airLines )    
	END  
	   
	/*** MATRIX LOGIC START HERE ***/  
	if ( SELECT COUNT (*) FROM @tmpAirline) > 1    
	BEGIN   
		SELECT (case when @isTotalPriceSort = 0 then MIN (airPriceBaseDisplay)  else MIN (totalCost ) end )AS LowestPrice ,ISNULL (ShortName,'Multiple Airlines')AS MarketingAirlineName ,airlineName AS airSegmentMarketingAirlineCode FROM @airResponseResultset air  
		INNER JOIN @normalizedResultSet n ON air.airResponseKey = n.airresponsekey   
		INNER JOIN @tmpAirline tmp ON n.airlineCode = tmp.airLineCode   
		LEFT OUTER JOIN AirVendorLookup vendor ON air.airlineName = vendor .AirlineCode   
		GROUP BY airlineName ,ShortName   
	END   
	ELSE   
	BEGIN    
		SELECT (case when @isTotalPriceSort = 0 then MIN (airPriceBaseDisplay)  else MIN (totalCost ) end )AS LowestPrice ,ISNULL (ShortName,'Multiple Airlines')AS MarketingAirlineName ,airlineName AS airSegmentMarketingAirlineCode FROM @airResponseResultset air  
		INNER JOIN @normalizedResultSet n ON air.airResponseKey = n.airresponsekey   
		LEFT OUTER JOIN AirVendorLookup vendor ON air.airlineName = vendor .AirlineCode   
		GROUP BY airlineName ,ShortName   
	END   
	print(@noOfLegsForRequest)  
	print(@noOfLegsForRequest)  
	DECLARE @markettingAirline AS varchar(100)  
	DECLARE @noOFDrillDownCount as int   

SELECT @isExcludeAirlinesPresent AS IsExcludeAirlinesAvailable
SELECT @isExcludeCountryPresent AS IsExcludeCountryAvailable
DROP TABLE #normal
 

GO
