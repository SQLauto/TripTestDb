SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

-- RT Leg 1 exec USP_GetAirResponses_FareLogix_TestAshima @airSubRequestKey=838566,@airRequestTypeKey=1,@SuperSetairLines=N'',@allowedOperatingAirlines=N'',@airLines=N'',@price=2147483647,@pageNo=0,@pageSize=30,@NoOfStops=N'-1',@drillDownLevel=N'0',@minTakeOffDate='2015-09-29 00:00:00',@maxTakeOffDate='2017-12-29 00:00:00',@minLandingDate='2015-09-29 00:00:00',@maxLandingDate='2017-12-29 00:00:00',@isIgnoreAirlineFilter=N'False',@isTotalPriceSort=N'True',@siteKey=49,@matrixView=1,@maxNoofstops=2
-- OW exec USP_GetAirResponses_FareLogix_TestAshima @airSubRequestKey=838569,@airRequestTypeKey=1,@SuperSetairLines=N'AA',@allowedOperatingAirlines=N'AA',@airLines=N'',@price=2147483647,@pageNo=0,@pageSize=30,@NoOfStops=N'-1',@drillDownLevel=N'0',@minTakeOffDate='2015-09-29 00:00:00',@maxTakeOffDate='2017-12-29 00:00:00',@minLandingDate='2015-09-29 00:00:00',@maxLandingDate='2017-12-29 00:00:00',@isIgnoreAirlineFilter=N'False',@isTotalPriceSort=N'True',@siteKey=49,@matrixView=1,@maxNoofstops=2

--exec USP_GetAirResponses_FareLogix_TestAshima @airSubRequestKey=839034,@airRequestTypeKey=1,@SuperSetairLines=N'',@allowedOperatingAirlines=N'',@airLines=N'',@price=2147483647,@pageNo=0,@pageSize=30,@NoOfStops=N'-1',@drillDownLevel=N'0',@minTakeOffDate='2015-09-30 00:00:00',@maxTakeOffDate='2017-12-30 00:00:00',@minLandingDate='2015-09-30 00:00:00',@maxLandingDate='2017-12-30 00:00:00',@isIgnoreAirlineFilter=N'False',@isTotalPriceSort=N'True',@siteKey=49,@matrixView=1,@maxNoofstops=2


	/*
	
exec USP_GetAirResponses_FareLogix @airSubRequestKey=634638,@airRequestTypeKey=1,@SuperSetairLines=N'',@allowedOperatingAirlines=N'',@airLines=N'',@price=2147483647,@pageNo=0,@pageSize=30,@NoOfStops=N'-1',@drillDownLevel=N'0',@gdsSourcekey=9,@minTakeOffDate='2014-11-20 00:00:00',@maxTakeOffDate='2017-02-20 00:00:00',@minLandingDate='2014-11-20 00:00:00',@maxLandingDate='2017-02-20 00:00:00',@isIgnoreAirlineFilter=N'False',@isTotalPriceSort=N'True',@siteKey=49,@matrixView=1,@maxNoofstops=1

exec USP_GetAirResponses_FareLogix @airSubRequestKey=634648,@airRequestTypeKey=2,@SuperSetairLines=N'',@allowedOperatingAirlines=N'',@airLines=N'',@price=2147483647,@pageNo=0,@pageSize=30,@NoOfStops=N'-1',@selectedResponseKey='AAE33875-97B4-4787-8E65-A9392B3E5C22',@drillDownLevel=N'0',@gdsSourcekey=9,@minTakeOffDate='2014-11-20 00:00:00',@maxTakeOffDate='2017-02-20 00:00:00',@minLandingDate='2014-11-20 00:00:00',@maxLandingDate='2017-02-20 00:00:00',@selectedFareType=N'',@isIgnoreAirlineFilter=N'False',@isTotalPriceSort=N'True',@siteKey=49,@matrixView=1,@maxNoofstops=1

exec USP_GetAirResponses_FareLogix @airSubRequestKey=634648,@airRequestTypeKey=2,@SuperSetairLines=N'',@allowedOperatingAirlines=N'',@airLines=N'',@price=2147483647,@pageNo=0,@pageSize=30,@NoOfStops=N'-1',@selectedResponseKey='E11AEE3B-85E6-4776-812D-0B8EB4CCF6C1',@drillDownLevel=N'0',@gdsSourcekey=9,@minTakeOffDate='2014-11-20 00:00:00',@maxTakeOffDate='2017-02-20 00:00:00',@minLandingDate='2014-11-20 00:00:00',@maxLandingDate='2017-02-20 00:00:00',@selectedFareType=N'Econ Flex',@isIgnoreAirlineFilter=N'False',@isTotalPriceSort=N'True',@siteKey=49,@matrixView=1,@maxNoofstops=1
	
	*/

   CREATE PROCEDURE [dbo].[USP_GetAirResponses_FareLogix_TestAshima_RefOrNonRef]
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
	@SelectedResponseKeyFifth uniqueidentifier =null  ,  
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
	@allowedOperatingAirlines varchar(500) =''  ,
	@excludeAirline varchar ( 500) = '',
	@excludedCountries varchar ( 500) = '',
	@siteKey int = 0,
	@matrixview  int = 0, ---0 for RT and 1 for legwise
	@MaxNoofstops INT = 1,
	@ForRefundable INT = 0
	)  
	AS   
	SET NOCOUNT ON   
	DECLARE @FirstRec INT  
	DECLARE @LastRec INT  
	DECLARE @isExcludeAirlinesPresent BIT = 0 , @isExcludeCountryPresent BIT = 0 
	-- Initialize variables.  
	--STEP1 -- get current page reecord indexes 
		SET @FirstRec = (@pageNo  - 1) * @PageSize  
		SET @LastRec = (@pageNo  * @PageSize + 1)  
	-- STEP2 -- Get other subrequest details from db based on @airSubRequestKey
	DECLARE @airRequestKey AS int  
	Declare @airRequestType AS int    
		SET @airRequestKey =( SELECT TOP 1 airRequestKey  FROM AirSubRequest WITH(NOLOCK) WHERE airSubRequestKey = @airSubRequestKey )  
		SET @airRequestType =( SELECT  airRequestTypeKey  FROM Airrequest WITH(NOLOCK) WHERE airRequestKey = @airRequestKey )  
	DECLARE @airBundledRequest AS int   
		SET @airBundledRequest = (SELECT TOP 1 AirSubRequestKey FROM AirSubRequest WITH(NOLOCK) WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex = -1 AND groupKey =1)   
	DECLARE @airPublishedFareRequest AS int   
	IF ( @airRequestType > 1) 
	BEGIN 
		SET @airPublishedFareRequest = (SELECT TOP 1 AirSubRequestKey FROM AirSubRequest WITH(NOLOCK) WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex = -1 AND groupKey =2)   
	END 
	ELSE 
	BEGIN 
		SET @airPublishedFareRequest = (SELECT TOP 1 AirSubRequestKey FROM AirSubRequest WITH(NOLOCK) WHERE airRequestKey = @airRequestKey  AND groupKey =2)   
	END 

	DECLARE @startAirPort AS varchar(100)   
	DECLARE @endAirPort AS varchar(100)   
	SELECT  @startAirPort=  airRequestDepartureAirport ,@endAirPort=airRequestArrivalAirport FROM AirSubRequest  WITH(NOLOCK) WHERE  airSubRequestKey = @airSubRequestKey   
	--CALCULATE DEPARTURE OFFSET AND Arrival offset     
	DECLARE @airResponseKey AS UNIQUEIDENTIFIER 
	DECLARE @departureOffset AS float
	DECLARE @arrivalOffset AS float  
	SET @airResponseKey = (SELECT Top 1 airresponsekey FROM AirResponse r WITH (NOLOCK)  WHERE  (r.airSubRequestKey = @airBundledRequest or  r.airSubRequestKey = @airSubRequestKey) AND 
	r.gdsSourceKey = 9 AND r.refundable = @ForRefundable)
 
 --SELECT @airResponseKey
 --RETURN
 
	SELECT TOP 1 @departureOffset =airSegmentDepartureOffset FROM AirSegments seg WITH (NOLOCK) WHERE airResponseKey = @airResponseKey and airLegNumber = @airRequestTypeKey  AND airSegmentDepartureAirport= @startAirPort AND airSegmentDepartureOffset is not null ORDER by segmentOrder ASC 
	SELECT TOP 1 @arrivalOffset = airSegmentArrivalOffset  FROM AirSegments seg WITH (NOLOCK) WHERE airResponseKey =@airResponseKey  AND airLegNumber = @airRequestTypeKey AND airSegmentArrivalAirport=@endAirPort AND airSegmentArrivalOffset is not null ORDER by segmentOrder DESC 


	/****time offset logic ends here ***/  
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
			WHERE airRequestKey = @airRequestKey AND SUB.groupKey = 1 AND
			AR.gdsSourceKey = 9 AND AR.refundable = @ForRefundable
			AND S.airSegmentMarketingAirlineCode + S.airSegmentOperatingAirlineCode NOT IN 
			(SELECT AG.marketingAirline + AG.operatingAirline FROM @tblAirlinesGroup AG WHERE AG.groupKey = 1))

			IF @airPublishedFareRequest > 0 -- For GroupKey 2(Publish fares)
			BEGIN
				INSERT @tempResponseToRemove (airresponsekey )
				(SELECT DISTINCT S.airresponsekey FROM AirSegments S WITH(NOLOCK) 
				INNER JOIN AirResponse AR WITH(NOLOCK)  ON S.airResponseKey = Ar.airResponseKey 
				INNER JOIN AirSubRequest SUB WITH(NOLOCK) ON Ar.airSubRequestKey = SUB.airSubRequestKey 		
				WHERE airRequestKey = @airRequestKey AND SUB.groupKey = 2 AND
				AR.gdsSourceKey = 9 AND AR.refundable = @ForRefundable
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
		INNER JOIN AirResponse resp WITH(NOLOCK) on s.airResponseKey =resp.airResponseKey   
		INNER JOIN AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey and 
		resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable AND
		airSegmentMarketingAirlineCode IN (SELECT * FROM @tblExcludedAirlines))
		
		IF((SELECT COUNT(DISTINCT s.airResponseKey) FROM AirSegments s WITH(NOLOCK) 
		INNER JOIN AirResponse resp WITH(NOLOCK) on s.airResponseKey =resp.airResponseKey   
		INNER JOIN AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey and
		resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable 
		and airSegmentMarketingAirlineCode IN (SELECT * FROM @tblExcludedAirlines) )> 0 ) 
		BEGIN
			SET @isExcludeAirlinesPresent =  1 
		END 
        
		-- to exclude operating airlines
		INSERT @tempResponseToRemove (airresponsekey )   
		(SELECT DISTINCT s.airResponseKey FROM AirSegments s WITH(NOLOCK) 
		INNER JOIN AirResponse resp WITH(NOLOCK) ON s.airResponseKey =resp.airResponseKey   
		INNER JOIN AirSubRequest subReq WITH(NOLOCK) ON resp.airSubRequestKey =subReq.airSubRequestKey 
		WHERE airRequestKey = @airRequestKey and
		resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable AND
		 airSegmentOperatingAirlineCode in (SELECT * FROM @tblExcludedAirlines))
		
		IF ( @isExcludeAirlinesPresent = 0 ) 
		BEGIN
			IF((SELECT COUNT(DISTINCT s.airResponseKey )FROM AirSegments s WITH(NOLOCK) 
		INNER JOIN AirResponse resp WITH(NOLOCK) ON s.airResponseKey =resp.airResponseKey   
		INNER JOIN AirSubRequest subReq WITH(NOLOCK) ON resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey and 
		resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable AND
		airSegmentOperatingAirlineCode in (SELECT * FROM @tblExcludedAirlines))>0) 
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
		FROM AirportLookup A WITH (NOLOCK)
		INNER JOIN @tblExcludedCountries T ON A.CountryCode = T.excludeCountry
		
		-- to Exclude Airports
		INSERT @tempResponseToRemove (airresponsekey)   
		(SELECT DISTINCT s.airResponseKey FROM AirSegments s WITH(NOLOCK) 
		INNER JOIN AirResponse resp WITH(NOLOCK) on s.airResponseKey =resp.airResponseKey   
		INNER JOIN AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey AND
		resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable 
		AND ((S.airSegmentDepartureAirport IN (SELECT * FROM @tblExcludedAirport)) OR (S.airSegmentArrivalAirport IN (SELECT * FROM @tblExcludedAirport))))
		
		IF((SELECT COUNT(DISTINCT s.airResponseKey) FROM AirSegments s WITH(NOLOCK) 
		INNER JOIN AirResponse resp WITH(NOLOCK) on s.airResponseKey =resp.airResponseKey   
		INNER JOIN AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey and
		resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable
		AND ((S.airSegmentDepartureAirport IN (SELECT * FROM @tblExcludedAirport)) OR (S.airSegmentArrivalAirport IN (SELECT * FROM @tblExcludedAirport))))> 0 ) 
		BEGIN
			SET @isExcludeCountryPresent =  1 
		END 
    END
	
	IF @airRequestType <> 1  -- if not oneWay request
	BEGIN
	-- Remove oneway reponses of southwest(NW) airline, if its not ONEWAY  ***Bug:7431 Display only RT repponses for southwest
		INSERT @tempResponseToRemove (airresponsekey )   
		(SELECT DISTINCT seg.airResponseKey from AirSegments seg WITH(NOLOCK) 
		INNER JOIN AirResponse resp ON seg.airResponseKey =resp.airResponseKey   
		INNER JOIN AirSubRequest subReq ON resp.airSubRequestKey =subReq.airSubRequestKey 
		WHERE airRequestKey = @airRequestKey and 
		resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable AND
		airSubRequestLegIndex <> -1 and seg.airSegmentMarketingAirlineCode = 'WN')
	END

	--SELECT * FROM @tempResponseToRemove
	--RETURN

	/****logic for calculating price for higher legs *****/  
	DECLARE @airPriceForAnotherLeg AS FLOAT   
	DECLARE @airPriceTaxForAnotherLeg AS FLOAT   
	DECLARE @airPriceSeniorForAnotherLeg AS FLOAT   
	DECLARE @airPriceTaxSeniorForAnotherLeg AS FLOAT   
	DECLARE @airPriceChildrenForAnotherLeg AS FLOAT   
	DECLARE @airPriceTaxChildrenForAnotherLeg AS FLOAT   
	DECLARE @airPriceInfantForAnotherLeg AS FLOAT   
	DECLARE @airPriceTaxInfantForAnotherLeg AS FLOAT
	DECLARE @airPriceYouthForAnotherLeg AS FLOAT   
	DECLARE @airPriceTaxYouthForAnotherLeg AS FLOAT
	DECLARE @airPriceTotalForAnotherLeg AS FLOAT   
	DECLARE @airPriceTaxTotalForAnotherLeg AS FLOAT   
	DECLARE @airPriceDisplayForAnotherLeg AS FLOAT   
	DECLARE @airPriceTaxDisplayForAnotherLeg AS FLOAT   
	DECLARE @anotherLegAirlines as varchar(50)
	DECLARE @anotherLegAirlinesCount AS INT
	
	DECLARE @airSuperSaverPriceForAnotherLeg AS FLOAT  = 0 
    DECLARE @airEconSaverPriceForAnotherLeg AS FLOAT  = 0 
	DECLARE @airEconFlexPriceForAnotherLeg AS FLOAT  = 0 
	DECLARE @airFirstFlexPriceForAnotherLeg AS FLOAT  = 0 
	DECLARE @airSuperSaverTaxForAnotherLeg AS FLOAT  = 0 
	DECLARE @airEconSaverTaxForAnotherLeg AS FLOAT  = 0 
	DECLARE @airEconFlexTaxForAnotherLeg AS FLOAT  = 0 
	DECLARE @airFirstFlexTaxForAnotherLeg AS FLOAT  = 0 

	DECLARE @tmpAirline  TABLE (airLineCode VARCHAR (200) )  

	IF @NoOfSTOPs = '-1' /*****Default view WHEN no of sTOPs not SELECTed *********/  
	BEGIN   
		SET @NoOfSTOPs = '0,1,2'  
	END   
	DECLARE @noSTOPs AS table ( stops int  )  
	INSERT @noSTOPs (stops )  
	SELECT * FROM vault.dbo.ufn_CSVToTable (@NoOfSTOPs)  
	
	--- Get filtered airlines in response
	IF @airLines <> '' and @isIgnoreAirlineFilter <> 1  
	BEGIN   
		INSERT into @tmpAirline(airlineCode)    SELECT * FROM vault.dbo.ufn_CSVToTable (@airLines )    
	END   
	ELSE       
	BEGIN   
		INSERT into @tmpAirline(airlineCode)  SELECT DISTINCT seg1.airSegmentMarketingAirlineCode FROM AirSegments seg1  WITH (NOLOCK) INNER JOIN AirResponse resp  WITH (NOLOCK) ON seg1.airResponseKey = resp.airResponseKey WHERE ( resp.airSubRequestKey = @airSubRequestKey or resp .airSubRequestKey = @airBundledRequest or resp .airSubRequestKey = @airPublishedFareRequest  ) and
		resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable
		INSERT into @tmpAirline (airLineCode ) VALUES  ('Multiple Airlines')  
	END     

	DECLARE  @selectedDate AS DATETIME   
	DECLARE @multiLegPrice AS TABLE   
	(  
	airPriceBase float ,  
	airPriceTax float,   
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
	airPriceTaxDisplay float,airresponsekey uniqueidentifier 
	)  
	IF ( @airRequestTypeKey = 1 )   
	BEGIN   
			IF ( @airLines = '' or @airLines = 'Multiple Airlines' )   
				BEGIN   
					INSERT @multiLegPrice (airPriceBase,airPriceTax,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth,airPriceTaxYouth,AirPriceBaseTotal,AirPriceTaxTotal,airPriceBaseDisplay,airPriceTaxDisplay,airresponsekey  )  
					select top 1 airPriceBAse,airPriceTax,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren ,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth ,airPriceTaxYouth ,AirPriceBaseTotal,AirPriceTaxTotal,airPriceBaseDisplay,airPriceTaxDisplay        ,airResponseKey 
					from airresponse  Resp WITH (NOLOCK)
					inner join AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey = subReq.airSubRequestKey   
					WHERE airRequestKey  = @airRequestKey  and airSubRequestLegIndex > 1 and 
					Resp.gdsSourceKey = 9 AND Resp.refundable = @ForRefundable
					and airResponseKey not in ( select airresponsekey  from @tempResponseToRemove )   
					order by Resp. AirSubRequestkey , (airPriceBase + airPriceTax)asc 
					
					-- Fare logix for finding min amount bucket wise
					
					    Select top 1 @airSuperSaverPriceForAnotherLeg = ISNULL(airSuperSaverPrice,0),@airSuperSaverTaxForAnotherLeg = ISNULL(airSuperSaverTax,0)
						from airresponse  Resp WITH (NOLOCK)
					    inner join AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey = subReq.airSubRequestKey   
					    WHERE airRequestKey  = @airRequestKey  and airSubRequestLegIndex > 1 
					    and Resp.gdsSourceKey = 9 AND Resp.refundable = @ForRefundable
					    and airResponseKey not in ( select airresponsekey  from @tempResponseToRemove )   
						AND airSuperSaverPrice is not null AND airSuperSaverPrice != 0
						AND airSuperSaverTax is not null AND airSuperSaverTax != 0
						order by (airSuperSaverPrice + airSuperSaverTax) asc

						--Select @airSuperSaverPriceForAnotherLeg,@airSuperSaverTaxForAnotherLeg

						Select top 1 @airEconSaverPriceForAnotherLeg = ISNULL(airEconSaverPrice,0),@airEconSaverTaxForAnotherLeg = ISNULL(airEconSaverTax,0)
						from airresponse  Resp WITH (NOLOCK)
					    inner join AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey = subReq.airSubRequestKey   
					    WHERE airRequestKey  = @airRequestKey  and airSubRequestLegIndex > 1 
					    and Resp.gdsSourceKey = 9 AND Resp.refundable = @ForRefundable
					    and airResponseKey not in ( select airresponsekey  from @tempResponseToRemove )   
						AND airEconSaverPrice is not null AND airEconSaverPrice != 0
						AND airEconSaverTax is not null AND airEconSaverTax != 0
						order by (airEconSaverPrice + airEconSaverTax) asc

						--Select @airEconSaverPriceForAnotherLeg,@airEconSaverTaxForAnotherLeg

						Select top 1 @airEconFlexPriceForAnotherLeg = ISNULL(airEconFlexPrice,0),@airEconFlexTaxForAnotherLeg = ISNULL(airEconFlexTax,0)
						from airresponse  Resp WITH (NOLOCK)
					    inner join AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey = subReq.airSubRequestKey   
					    WHERE airRequestKey  = @airRequestKey  and airSubRequestLegIndex > 1 
					    and Resp.gdsSourceKey = 9 AND Resp.refundable = @ForRefundable
					    and airResponseKey not in ( select airresponsekey  from @tempResponseToRemove ) 
						AND airEconFlexPrice is not null AND airEconFlexPrice != 0
						AND airEconFlexTax is not null AND airEconFlexTax != 0
						order by (airEconSaverPrice + airEconFlexTax) asc

						--Select @airEconFlexPriceForAnotherLeg,@airEconFlexTaxForAnotherLeg


						Select top 1 @airFirstFlexPriceForAnotherLeg = ISNULL(airFirstFlexPrice,0),@airFirstFlexTaxForAnotherLeg = ISNULL(airFirstFlexTax,0)
						from airresponse  Resp WITH (NOLOCK)
					    inner join AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey = subReq.airSubRequestKey   
					    WHERE airRequestKey  = @airRequestKey  and airSubRequestLegIndex > 1 
					    and Resp.gdsSourceKey = 9 AND Resp.refundable = @ForRefundable
					    and airResponseKey not in ( select airresponsekey  from @tempResponseToRemove ) 
						AND airFirstFlexPrice is not null AND airFirstFlexPrice != 0
						AND airFirstFlexTax is not null AND airFirstFlexTax != 0
						order by (airFirstFlexPrice + airFirstFlexTax) asc

						--Select @airFirstFlexPriceForAnotherLeg,@airFirstFlexTaxForAnotherLeg

				END   
				ELSE   
				BEGIN  
					INSERT @multiLegPrice (airPriceBase,airPriceTax,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth,airPriceTaxYouth,AirPriceBaseTotal,AirPriceTaxTotal ,airPriceBaseDisplay,airPriceTaxDisplay,airresponsekey )  
					SELECT  TOP 1    airpricebase ,airpricetax,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth,airPriceTaxYouth,AirPriceBaseTotal,AirPriceTaxTotal ,airPriceBaseDisplay,airPriceTaxDisplay,resp.airResponseKey 
					FROM AirResponse resp  WITH (NOLOCK)  
					inner join AirSubRequest subReq  WITH (NOLOCK)on resp.airSubRequestKey = subReq.airSubRequestKey   
					inner join AirSegments seg  WITH (NOLOCK)on resp.airResponseKey = seg.airResponseKey    
					inner join @tmpAirline air on seg .airSegmentMarketingAirlineCode = air.airLineCode   
					WHERE airRequestKey  = @airRequestKey   and airSubRequestLegIndex > 1  and  resp.gdsSourceKey = 9  and resp.refundable = @ForRefundable and resp.airResponseKey not in ( select airresponsekey  
					from @tempResponseToRemove )   
					order by  (airPriceBase + airPriceTax)asc 
				END   

				SET @airPriceForAnotherLeg = (SELECT SUM(Airpricebase) FROM @multiLegPrice )  
				SET @airPriceTaxForAnotherLeg = (SELECT SUM(airPriceTax) FROM @multiLegPrice )  
				SET @airPriceSeniorForAnotherLeg = (SELECT SUM(AirpricebaseSenior) FROM @multiLegPrice )  
				SET @airPriceTaxSeniorForAnotherLeg = (SELECT SUM(airPriceTaxSenior) FROM @multiLegPrice )  
				SET @airPriceChildrenForAnotherLeg = (SELECT SUM(AirpricebaseChildren) FROM @multiLegPrice )  
				SET @airPriceTaxChildrenForAnotherLeg = (SELECT SUM(airPriceTaxChildren) FROM @multiLegPrice )  
				SET @airPriceInfantForAnotherLeg = (SELECT SUM(AirpricebaseInfant) FROM @multiLegPrice )  
				SET @airPriceTaxInfantForAnotherLeg = (SELECT SUM(airPriceTaxInfant) FROM @multiLegPrice )  
				SET @airPriceYouthForAnotherLeg = (SELECT SUM(AirpricebaseYouth) FROM @multiLegPrice )  
				SET @airPriceTaxYouthForAnotherLeg = (SELECT SUM(airPriceTaxYouth) FROM @multiLegPrice )
				SET @airPriceTotalForAnotherLeg = (SELECT SUM(AirPriceBaseTotal) FROM @multiLegPrice )  
				SET @airPriceTaxTotalForAnotherLeg = (SELECT SUM(AirPriceTaxTotal) FROM @multiLegPrice )  
				SET @airPriceDisplayForAnotherLeg = (SELECT SUM(AirpricebaseDisplay) FROM @multiLegPrice )  
				SET @airPriceTaxDisplayForAnotherLeg = (SELECT SUM(airPriceTaxDisplay) FROM @multiLegPrice )  
				
				
				
		--  SET @anotherLegAirlines = (SELECT Top 1 N.airlines FROM NormalizedAirResponses N Inner join @multiLegPrice M on N.airresponsekey = M.airresponsekey )

				DECLARE @secondLegRequestKey  AS INT = (SELECT top 1 airsubrequestkey from AirResponse R WITH(NOLOCK) Inner join @multiLegPrice M on R.airResponseKey = M.airresponsekey and R.gdsSourceKey = 9 AND R.refundable = @ForRefundable) 
				DECLARE @SecondLegs_CTE  AS TABLE(noofairlines INT , airPrice DECIMAL (12,2), airlineName VARCHAR(40),airresponse UNIQUEIDENTIFIER)

				INSERT INTO @SecondLegs_CTE 	  
				SELECT COUNT(DISTINCT airSegmentMarketingAirlineCode) , (airPriceBaseDisplay + airPriceTaxDisplay  ),
				( CASE WHEN (COUNT(DISTINCT airSegmentMarketingAirlineCode))> 1 THEN 'Multiple' ELSE 
				MIN (airSegmentMarketingAirlineCode ) END ) ,seg.airResponseKey  From airsegments seg WITH (NOLOCK) INNER JOIN airresponse r WITH (NOLOCK)
				ON seg.airResponseKey = r.airResponseKey 
				WHERE AIRSUbrequestKEy = @secondLegRequestKey and
				r.gdsSourceKey = 9 AND r.refundable = @ForRefundable
				AND Convert(DECIMAL (12,2),(airPriceBaseDisplay + airPriceTaxDisplay  )) = Convert (DECIMAL(12,2), (@airPriceTaxDisplayForAnotherLeg + @airPriceDisplayForAnotherLeg) )
				group by seg.airResponseKey ,airPriceBaseDisplay , airPriceTaxDisplay  ,seg.airResponseKey 

				SELECT @anotherLegAirlinesCount = noofairlines , @anotherLegAirlines = airlineName  from @SecondLegs_CTE where noofairlines = 1  
				IF ( @anotherLegAirlines IS NULL OR @anotherLegAirlines  = '' ) 
				BEGIN
					SELECT @anotherLegAirlinesCount =  COUNT(distinct airSegmentMarketingAirlineCode) , @anotherLegAirlines = ( CASE WHEN (COUNT(distinct airSegmentMarketingAirlineCode))> 1 THEN 'Multiple' ELSE 
					MIN (airSegmentMarketingAirlineCode ) END ) From airsegments seg WITH (NOLOCK)
					INNER JOIN airresponse r WITH (NOLOCK) on seg.airResponseKey = r.airResponseKey
					INNER JOIN @multiLegPrice V on r.airResponseKey = v.airResponsekey 
					where r.gdsSourceKey = 9 AND r.refundable = @ForRefundable
					GROUP BY seg.airResponseKey 
				END 

			END  

	ELSE   
	BEGIN  
		/**airLEg > 1 **/  
			DECLARE @SELECTedResponse as  table  
			(  
			legIndex int   identity ( 1,1) ,  
			responsekey uniqueidentifier ,  
			fareType varchar(100)  
			)  
			IF   @SelectedResponseKey  IS NOT NULL AND @SelectedResponseKey <> '{00000000-0000-0000-0000-000000000000}'    
			BEGIN  
				IF ( SELECT AirSubRequestKey FROM AirResponse WITH(NOLOCK) WHERE  airResponseKey = @SELECTedResponseKey ) <>  @airBundledRequest   
				BEGIN  
					INSERT @SELECTedResponse (responsekey,fareType  ) values (@SELECTedResponseKey ,@SELECTedFareType)  
				END  
				ELSE   
				BEGIN  

					INSERT @SELECTedResponse (responsekey,fareType )  
					 --(SELECT TOP 1  airResponseKey,@SELECTedFareType  FROM  NormalizedAirResponses n WITH(NOLOCK)inner join AirSubRequest r WITH(NOLOCK) on n.airsubrequestkey = r.airSubRequestKey  WHERE airRequestKey = @airRequestKey and  airSubRequestLegIndex = 1 and flightNumber =(SELECT flightnumber FROM NormalizedAirResponses WHERE airresponsekey = @SELECTedResponseKey  and airLegNumber =1 )   AND AIRLINES = (SELECT airlines FROM NormalizedAirResponses WHERE airresponsekey = @SELECTedResponseKey and airLegNumber =1 ) AND N.airsubrequestkey <> @airBundledRequest )  
					  (SELECT TOP 1  airResponseKey,@SELECTedFareType  FROM  NormalizedAirResponses n WITH(NOLOCK)
  inner join AirSubRequest r WITH(NOLOCK) on n.airsubrequestkey = r.airSubRequestKey  WHERE airRequestKey = @airRequestKey AND airlegnumber =1
   and  airSubRequestLegIndex = 1 and flightNumber =(SELECT flightnumber FROM NormalizedAirResponses WHERE airresponsekey = @SELECTedResponseKey  and airLegNumber =1 
   
   )   AND AIRLINES = (SELECT airlines FROM NormalizedAirResponses WHERE airresponsekey = @SELECTedResponseKey and airLegNumber =1 ) AND N.airsubrequestkey <> @airBundledRequest )
   
 					END   
				SET @selectedDate = ( SELECT MAX (airSegmentArrivalDate  )   FROM AirSegments WITH (NOLOCK)WHERE airResponseKey = @SELECTedResponseKey AND airLegNumber =(@airRequestTypeKey-1) )  
			END   

			IF @airRequestTypeKey = 3   
			BEGIN    
				IF @SELECTedResponseKeySecond is null or @SELECTedResponseKeySecond ='{00000000-0000-0000-0000-000000000000}'    
				BEGIN  
					SET  @SELECTedResponseKeySecond = @SELECTedResponseKey   
				END   
			END   
			IF   @SELECTedResponseKeySecond is not null or @SELECTedResponseKeySecond <> '{00000000-0000-0000-0000-000000000000}'    
			BEGIN  
				IF ( SELECT AirSubRequestKey FROM AirResponse WITH(NOLOCK) WHERE  airResponseKey = @SELECTedResponseKeySecond  ) <>  @airBundledRequest   
				BEGIN   
					INSERT @SELECTedResponse (responsekey,fareType  ) values   (@SELECTedResponseKeySecond ,@SELECTedFareType)  
				END   
				ELSE   
				BEGIN  
					INSERT @SELECTedResponse (responsekey,fareType  )   (SELECT TOP 1  airResponseKey,@SELECTedFareType  FROM  NormalizedAirResponses n WITH(NOLOCK) inner join AirSubRequest r on n.airsubrequestkey = r.airSubRequestKey  WHERE airRequestKey = @airRequestKey and airSubRequestLegIndex = 2 and flightNumber =(SELECT flightnumber FROM NormalizedAirResponses WITH(NOLOCK) WHERE airresponsekey = @SELECTedResponseKeySecond  and airLegNumber =2)   AND AIRLINES = (SELECT airlines FROM NormalizedAirResponses WHERE airresponsekey = @SELECTedResponseKeySecond and airLegNumber =2) )  
				END   
				SET @selectedDate = ( SELECT MAX (airSegmentArrivalDate  )   FROM AirSegments  WITH (NOLOCK) WHERE airResponseKey = @SELECTedResponseKeySecond AND airLegNumber =(@airRequestTypeKey-1) )  
			END    

			IF @airRequestTypeKey = 4   
			BEGIN    
				IF @SELECTedResponseKeyThird is null or @SELECTedResponseKeyThird ='{00000000-0000-0000-0000-000000000000}'    
				BEGIN  
					SET  @SELECTedResponseKeyThird = @SELECTedResponseKey   
				END   
			END   

			IF   @SELECTedResponseKeyThird  is not null and @SELECTedResponseKeyThird <> '{00000000-0000-0000-0000-000000000000}'    
			BEGIN  
				IF ( SELECT AirSubRequestKey FROM AirResponse  WITH (NOLOCK) WHERE  airResponseKey = @SELECTedResponseKeyThird  ) <>  @airBundledRequest   
				BEGIN   
					INSERT @SELECTedResponse (responsekey,fareType  ) values (@SELECTedResponseKeyThird ,@SELECTedFareType)  
				END   
				ELSE   
				BEGIN  
					INSERT @SELECTedResponse (responsekey,fareType  )   (SELECT TOP 1  airResponseKey,@SELECTedFareType  FROM  NormalizedAirResponses n  WITH (NOLOCK) inner join AirSubRequest r  WITH (NOLOCK) on n.airsubrequestkey = r.airSubRequestKey  WHERE airRequestKey = @airRequestKey and airSubRequestLegIndex =3 and flightNumber =(SELECT flightnumber FROM NormalizedAirResponses WHERE airresponsekey = @SELECTedResponseKeyThird and airLegNumber =3 )   AND AIRLINES = (SELECT airlines FROM NormalizedAirResponses WITH(NOLOCK) WHERE airresponsekey = @SELECTedResponseKeyThird and airLegNumber =3 ) )  
				END   
				SET @selectedDate = ( SELECT MAX (airSegmentArrivalDate  )   FROM AirSegments WITH(NOLOCK) WHERE airResponseKey = @SELECTedResponseKeyThird AND airLegNumber =(@airRequestTypeKey-1) )  
			END    

			IF @airRequestTypeKey = 5  
			BEGIN    
				IF @SELECTedResponseKeyFourth is null or @SELECTedResponseKeyFourth ='{00000000-0000-0000-0000-000000000000}'    
				BEGIN  
					SET  @SELECTedResponseKeyFourth = @SELECTedResponseKey   
				END   
			END    
			
			IF   @SELECTedResponseKeyFourth is not null and @SELECTedResponseKeyFourth  <> '{00000000-0000-0000-0000-000000000000}'    
			BEGIN  
			IF ( SELECT AirSubRequestKey FROM AirResponse  WITH (NOLOCK) WHERE  airResponseKey = @SELECTedResponseKeyFourth  ) <>  @airBundledRequest    
				BEGIN   
					INSERT @SELECTedResponse (responsekey,fareType  ) values (@SELECTedResponseKeyFourth,@SELECTedFareType )  
				END    
				ELSE   
				BEGIN  
					INSERT @SELECTedResponse (responsekey,fareType  )   (SELECT TOP 1  airResponseKey ,@SELECTedFareType FROM  NormalizedAirResponses n  WITH (NOLOCK) inner join AirSubRequest r  WITH (NOLOCK) on n.airsubrequestkey = r.airSubRequestKey  WHERE airRequestKey = @airRequestKey and airSubRequestLegIndex =4 and flightNumber =(SELECT flightnumber FROM NormalizedAirResponses WHERE airresponsekey = @SELECTedResponseKeyFourth and airLegNumber =4 )   AND AIRLINES = (SELECT airlines FROM NormalizedAirResponses WITH(NOLOCK) WHERE airresponsekey = @SELECTedResponseKeyFourth and airLegNumber =4 ) )  
				END   
				SET @selectedDate = ( SELECT MAX (airSegmentArrivalDate  )   FROM AirSegments  WITH (NOLOCK) WHERE airResponseKey = @SELECTedResponseKeyFourth AND airLegNumber =(@airRequestTypeKey-1) )  
			END   

			IF @airRequestTypeKey = 6  
			BEGIN    
				IF @SELECTedResponseKeyFourth is null or @SELECTedResponseKeyFourth ='{00000000-0000-0000-0000-000000000000}'    
				BEGIN  
					SET  @SelectedResponseKeyFifth  = @SELECTedResponseKey   
				END   
			END    
			
			IF   @SELECTedResponseKeyFourth is not null and @SELECTedResponseKeyFourth  <> '{00000000-0000-0000-0000-000000000000}'    
			BEGIN  
				IF ( SELECT AirSubRequestKey FROM AirResponse WITH(NOLOCK) WHERE  airResponseKey = @SelectedResponseKeyFifth  ) <>  @airBundledRequest    
				BEGIN   
					INSERT @SELECTedResponse (responsekey,fareType  ) values (@SelectedResponseKeyFifth,@SELECTedFareType )  
				END    
				ELSE   
				BEGIN  
					INSERT @SELECTedResponse (responsekey,fareType  )   (SELECT TOP 1  airResponseKey ,@SELECTedFareType FROM  NormalizedAirResponses n  WITH (NOLOCK) inner join AirSubRequest r  WITH (NOLOCK) on n.airsubrequestkey = r.airSubRequestKey  WHERE airRequestKey = @airRequestKey and airSubRequestLegIndex =5 and flightNumber =(SELECT flightnumber FROM NormalizedAirResponses WHERE airresponsekey = @SelectedResponseKeyFifth and airLegNumber =5 )   AND AIRLINES = (SELECT airlines FROM NormalizedAirResponses WITH(NOLOCK) WHERE airresponsekey = @SelectedResponseKeyFifth and airLegNumber =5 ) )  
				END   
				SET @selectedDate = (SELECT MAX (airSegmentArrivalDate) FROM AirSegments  WITH (NOLOCK) WHERE airResponseKey = @SELECTedResponseKeyFourth AND airLegNumber =(@airRequestTypeKey-1) )  
			END  			 

			DECLARE @SELECTedFareTypeTable as table (  
			fareLegIndex int identity (1,1),  
			fareType varchar(20)  
			)  
			INSERT @SELECTedFareTypeTable ( fareType )(SELECT * FROM vault.dbo.ufn_CSVToTable ( @SELECTedFareType ) )  

			UPDATE @SELECTedResponse SET fareType = fare.fareType FROM @SELECTedResponse sResponse  INNER JOIN 
			@SELECTedFareTypeTable fare on sResponse .legIndex =fare.fareLegIndex   
            
             
			IF ( @airLines = '' or @airLines = 'Multiple Airlines' )   
			BEGIN    
				INSERT @multiLegPrice (airPriceBase,airPriceTax,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth,airPriceTaxYouth,AirPriceBaseTotal,AirPriceTaxTotal ,airPriceBaseDisplay,airPriceTaxDisplay )  
				SELECT    ( MIN(airPriceBase  )), (SELECT MIN ( airpriceTax) FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and airPriceBase =  MIN(resp.airPriceBAse)),
				( MIN(airPriceBaseSenior  )), (SELECT MIN ( airpriceTaxSenior) FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and airPriceBaseSenior =  MIN(resp.airPriceBaseSenior)),
				( MIN(airPriceBaseChildren  )), (SELECT MIN ( airpriceTaxChildren)FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and airpriceBaseChildren =  MIN(resp.airpriceBaseChildren)) ,
				( MIN(airPriceBaseInfant  )), (SELECT MIN ( airpriceTaxInfant)FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and airPriceBaseInfant =  MIN(resp.airPriceBAseInfant ) ) ,
				( MIN(airPriceBaseYouth  )), (SELECT MIN ( airpriceTaxYouth)FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and airPriceBaseYouth =  MIN(resp.airPriceBAseyouth ) ) ,
				( MIN(AirPriceBaseTotal  )), (SELECT MIN ( AirPriceTaxTotal) FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and AirPriceBaseTotal =  MIN(resp.AirPriceBaseTotal ) ),
				( MIN(airPriceBaseDisplay  )), (SELECT MIN ( airpriceTaxDisplay) FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and airpriceBaseDisplay =  MIN(resp.airpriceBaseDisplay ) )
				FROM AirResponse resp    WITH (NOLOCK)
				inner join AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey = subReq.airSubRequestKey  
				WHERE airRequestKey  = @airRequestKey  and airSubRequestLegIndex > @airRequestTypeKey  
				and     resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable
				GROUP BY resp.airSubRequestKey   
				UNION ALL   
				SELECT  ISNULL( (CASE WHEN  SELECTed.fareType =   'Super Saver' THEN   airSuperSaverPrice   
				WHEN SELECTed.fareType =   'Econ Saver' THEN   airEconSaverPrice   
				WHEN SELECTed.fareType =   'First Flex' THEN   airFirstFlexPrice   
				WHEN SELECTed.fareType =   'Corporate' THEN   airCorporatePrice    
				WHEN SELECTed.fareType =   'Econ Flex' THEN   airEconFlexPrice    
				WHEN SELECTed.fareType =  'Instant Upgrade' THEN   airEconUpgradePrice   
				ELSE airpriceBase END   
				) ,airpriceBase)as airpriceBase  ,  

				ISNULL( (CASE WHEN  SELECTed.fareType =   'Super Saver' THEN   airSuperSaverTax    
				WHEN SELECTed.fareType =   'Econ Saver' THEN   airEconSaverTax   
				WHEN SELECTed.fareType =   'First Flex' THEN   airFirstFlexTax   
				WHEN SELECTed.fareType =   'Corporate' THEN   airCorporateTax    
				WHEN SELECTed.fareType =   'Econ Flex' THEN   airEconFlexTax   
				WHEN SELECTed.fareType =  'Instant Upgrade' THEN   airEconUpgradetax   
				ELSE airPriceTax END   
				) ,airPriceTax)as   
				airPriceTax ,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth,airPriceTaxYouth,AirPriceBaseTotal,AirPriceTaxTotal ,

				ISNULL( (CASE WHEN  SELECTed.fareType =   'Super Saver' THEN   airSuperSaverPrice   
				WHEN SELECTed.fareType =   'Econ Saver' THEN   airEconSaverPrice   
				WHEN SELECTed.fareType =   'First Flex' THEN   airFirstFlexPrice   
				WHEN SELECTed.fareType =   'Corporate' THEN   airCorporatePrice    
				WHEN SELECTed.fareType =   'Econ Flex' THEN   airEconFlexPrice    
				WHEN SELECTed.fareType =  'Instant Upgrade' THEN   airEconUpgradePrice   
				ELSE airpriceBase END   
				) ,airpriceBase)as airPriceBaseDisplay  ,  

				ISNULL( (CASE WHEN  SELECTed.fareType =   'Super Saver' THEN   airSuperSaverTax    
				WHEN SELECTed.fareType =   'Econ Saver' THEN   airEconSaverTax   
				WHEN SELECTed.fareType =   'First Flex' THEN   airFirstFlexTax   
				WHEN SELECTed.fareType =   'Corporate' THEN   airCorporateTax    
				WHEN SELECTed.fareType =   'Econ Flex' THEN   airEconFlexTax   
				WHEN SELECTed.fareType =  'Instant Upgrade' THEN   airEconUpgradetax   
				ELSE airPriceTax END   
				) ,airPriceTax)as   
				airPriceTaxDisplay  
				FROM AirResponse resp   WITH (NOLOCK)
				inner join @SELECTedResponse SELECTed   
				on resp .airResponseKey = SELECTed .responsekey  
				WHERE resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable
			END   
			ELSE   
			BEGIN  
				INSERT @multiLegPrice (airPriceBase,airPriceTax,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth,airPriceTaxYouth,AirPriceBaseTotal,AirPriceTaxTotal ,airPriceBaseDisplay,airPriceTaxDisplay  )  
				SELECT    ( MIN(airPriceBase  )), (SELECT MIN ( airpriceTax) FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and airPriceBase =  MIN(resp.airPriceBAse)),
				( MIN(airPriceBaseSenior  )), (SELECT MIN ( airpriceTaxSenior) FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and airPriceBaseSenior =  MIN(resp.airPriceBaseSenior)),
				( MIN(airPriceBaseChildren  )), (SELECT MIN ( airpriceTaxChildren)FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and airpriceBaseChildren =  MIN(resp.airpriceBaseChildren)) ,
				( MIN(airPriceBaseInfant  )), (SELECT MIN ( airpriceTaxInfant)FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and airPriceBaseInfant =  MIN(resp.airPriceBAseInfant ) ) ,
				( MIN(airPriceBaseYouth  )), (SELECT MIN ( airpriceTaxYouth)FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and airPriceBaseYouth =  MIN(resp.airPriceBAseyouth ) ) ,
				( MIN(AirPriceBaseTotal  )), (SELECT MIN ( AirPriceTaxTotal) FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and AirPriceBaseTotal =  MIN(resp.AirPriceBaseTotal ) ),
				( MIN(airPriceBaseDisplay  )), (SELECT MIN ( airpriceTaxDisplay) FROM AirResponse r  WHERE r.airSubrequestkey = resp.airsubrequestkey and airpriceBaseDisplay =  MIN(resp.airpriceBaseDisplay ) )
				FROM AirResponse resp    WITH (NOLOCK)
				inner join AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey = subReq.airSubRequestKey   
				inner join AirSegments seg WITH(NOLOCK) on resp.airResponseKey = seg.airResponseKey    
				WHERE airRequestKey  = @airRequestKey  and airSubRequestLegIndex > @airRequestTypeKey and seg.airSegmentMarketingAirlineCode =@airLines   
				and  
				resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable
				group by resp.airSubRequestKey  ,seg.airSegmentMarketingAirlineCode    
				union ALL   
				SELECT  ISNULL( (case WHEN  SELECTed.fareType =   'Super Saver' THEN   airSuperSaverPrice   
				WHEN SELECTed.fareType =   'Econ Saver' THEN   airEconSaverPrice   
				WHEN SELECTed.fareType =   'First Flex' THEN   airFirstFlexPrice   
				WHEN SELECTed.fareType =   'Corporate' THEN   airCorporatePrice    
				WHEN SELECTed.fareType =   'Econ Flex' THEN   airEconFlexPrice    
				WHEN SELECTed.fareType =  'Instant Upgrade' THEN   airEconUpgradePrice   
				ELSE airpriceBase  END ) ,airpriceBase)as airpriceBase  ,  
				ISNULL( (CASE WHEN  SELECTed.fareType =   'Super Saver' THEN   airSuperSaverTax    
				WHEN SELECTed.fareType =   'Econ Saver' THEN   airEconSaverTax   
				WHEN SELECTed.fareType =   'First Flex' THEN   airFirstFlexTax   
				WHEN SELECTed.fareType =   'Corporate' THEN   airCorporateTax    
				WHEN SELECTed.fareType =   'Econ Flex' THEN   airEconFlexTax   
				WHEN SELECTed.fareType =  'Instant Upgrade' THEN   airEconUpgradetax   
				ELSE airPriceTax END   
				) ,airPriceTax)as   
				airPriceTax   ,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth,airPriceTaxYouth,AirPriceBaseTotal,AirPriceTaxTotal ,airPriceBaseDisplay,airPriceTaxDisplay  
				FROM AirResponse resp  WITH(NOLOCK)
				inner join @SELECTedResponse SELECTed   
				on resp .airResponseKey = SELECTed .responsekey 
				WHERE resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable  
			END   
			
			SET @airPriceForAnotherLeg = (SELECT SUM(Airpricebase) FROM @multiLegPrice )  
			SET @airPriceTaxForAnotherLeg = ( SELECT SUM(airpriceTax ) FROM @multiLegPrice )  
			SET @airPriceSeniorForAnotherLeg = (SELECT SUM(AirpricebaseSenior) FROM @multiLegPrice )  
			SET @airPriceTaxSeniorForAnotherLeg = (SELECT SUM(airPriceTaxSenior) FROM @multiLegPrice )  
			SET @airPriceChildrenForAnotherLeg = (SELECT SUM(AirpricebaseChildren) FROM @multiLegPrice )  
			SET @airPriceTaxChildrenForAnotherLeg = (SELECT SUM(airPriceTaxChildren) FROM @multiLegPrice )  
			SET @airPriceInfantForAnotherLeg = (SELECT SUM(AirpricebaseInfant) FROM @multiLegPrice )  
			SET @airPriceTaxInfantForAnotherLeg = (SELECT SUM(airPriceTaxInfant) FROM @multiLegPrice )  
			SET @airPriceYouthForAnotherLeg = (SELECT SUM(AirpricebaseYouth) FROM @multiLegPrice )  
			SET @airPriceTaxYouthForAnotherLeg = (SELECT SUM(airPriceTaxYouth) FROM @multiLegPrice )  
			SET @airPriceTotalForAnotherLeg = (SELECT SUM(AirPriceBaseTotal) FROM @multiLegPrice )  
			SET @airPriceTaxTotalForAnotherLeg = (SELECT SUM(AirPriceTaxTotal) FROM @multiLegPrice )  
			SET @airPriceDisplayForAnotherLeg = (SELECT SUM(AirpricebaseDisplay) FROM @multiLegPrice )  
			SET @airPriceTaxDisplayForAnotherLeg = (SELECT SUM(airPriceTaxDisplay) FROM @multiLegPrice ) 
			
			-- Gettting bucket price of selected response
			IF @gdssourcekey = 9
			BEGIN
				SELECT @airSuperSaverPriceForAnotherLeg = ISNULL(airSuperSaverPrice,0),@airSuperSaverTaxForAnotherLeg = ISNULL(airSuperSaverTax,0)
				,@airEconSaverPriceForAnotherLeg = ISNULL(airEconSaverPrice,0),@airEconSaverTaxForAnotherLeg = ISNULL(airEconSaverTax,0)
				,@airEconFlexPriceForAnotherLeg = ISNULL(airEconFlexPrice,0),@airEconFlexTaxForAnotherLeg = ISNULL(airEconFlexTax,0)
				,@airFirstFlexPriceForAnotherLeg = ISNULL(airFirstFlexPrice,0),@airFirstFlexTaxForAnotherLeg = ISNULL(airFirstFlexTax,0)
				FROM AirResponse resp  WITH(NOLOCK)
				inner join @SELECTedResponse SELECTed   
				on resp .airResponseKey = SELECTed .responsekey 
				where resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable
            END 
            -- -------------------------------------
            
			select @anotherLegAirlinesCount = COUNT(distinct airSegmentMarketingAirlineCode) , 
			@anotherLegAirlines = ( CASE WHEN (COUNT(distinct airSegmentMarketingAirlineCode))> 1 then 'Multiple' else 
			MIN (airSegmentMarketingAirlineCode ) END ) From airsegments seg  WITH (NOLOCK)
			where airresponsekey = @SelectedResponseKey 
			group by seg.airResponseKey 
            
            
            
	--  SET @anotherLegAirlines = (SELECT Top 1 N.airlines FROM NormalizedAirResponses N  where airresponsekey = @SelectedResponseKey )
	END   


	/**pricing logic ends here .**/  
	/**** flitering logic start **/  
	---creating table variable for container for flitered result ..  
	CREATE TABLE #airResponseResultset  
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
	NoOfSTOPs int ,  
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
	airEconFlexPrice float ,  
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
	airPriceClassSELECTed   varchar (50) NULL ,  
	otherLegPrice float ,  
	isRefundable bit ,  
	isBrandedFare bit ,  
	cabinClass varchar(50),  
	fareType varchar(20),segmentOrder int ,  
	airsegmentCabin varchar (20),  
	totalCost float ,
	airSegmentOperatingFlightNumber int,
	otherlegtax float,
	airSegmentOperatingAirlineCompanyShortName VARCHAR(100) ,
	otherlegAirlines varchar(100) ,
	noOfOtherlegairlines int ,
	airRowNum int identity (1,1) ,
	legDuration int ,
	legConnections Varchar(100),actualNoOFStops INT ,
	isSameAirlinesItin bit,
	isLowestJourneyTime bit default 0, 
    airSuperSaverTax float ,  
	airEconSaverTax float ,  
	airFirstFlexTax  float ,  
	airCorporateTax  float ,  
	airEconFlexTax float   ,  
	airEconUpgradeTax float 
	)  


	CREATE TABLE #AllOneWayResponses      
	(  
	airOneIdent int identity (1,1),  
	airOneResponsekey uniqueidentifier ,   
	airOnePriceBase float ,  
	airOnePriceTax float,  
	airOnePriceBaseSenior float,
	airOnePriceTaxSenior float,
	airOnePriceBaseChildren float,
	airOnePriceTaxChildren float,
	airOnePriceBaseInfant float,
	airOnePriceTaxInfant float,
	airOnePriceBaseYouth float,
	airOnePriceTaxYouth float,
	airOnePriceBaseTotal float,
	airOnePriceTaxTotal float,
	airOnePriceBaseDisplay float,
	airOnePriceTaxDisplay float,
	airSegmentFlightNumber varchar(100),  
	airSegmentMarketingAirlineCode varchar(100),  
	airsubRequestkey int ,  
	airpriceTotal float ,   
	otherLegprice float , 
	cabinclass varchar(50),
	otherlegtax float ,
	otherlegAirlines varchar(100) ,
	noOfOtherlegairlines int    ,
	legConnections Varchar(100),
	airOneSuperSaverBase float ,  
	airOneSuperSaverTax float,  
	airOneEconSaverBase float ,  
	airOneEconSaverTax float,  
	airOneEconFlexBase float ,  
	airOneEconFlexTax float,  
	airOneFirstFlexBase float ,  
	airOneFirstFlexTax float
	)      

	DECLARE @secondLegDetails as TABLE 
	(
	otherLegAirlines varchar(40) , 
	responsekey uniqueidentifier , 
	otherlegsAirlinesCount int 
	)

	IF ( @airRequestTypeKey = 1)   
	BEGIN   

		INSERT #AllOneWayResponses (airOneResponsekey,airOnePriceBase,airOnePriceBaseSenior ,airOnePriceTaxSenior, airOnePriceBaseChildren ,airOnePriceTaxChildren ,airOnePriceBaseInfant, airOnePriceTaxInfant,airOnePriceBaseYouth, airOnePriceTaxYouth, airOnePriceBaseTotal, airOnePriceTaxTotal,airOnePriceBaseDisplay, airOnePriceTaxDisplay,airSegmentFlightNumber,airSegmentMarketingAirlineCode,airsubRequestkey,airOnePriceTax ,airpriceTotal ,cabinclass  ,legConnections
		,airOneSuperSaverBase, airOneSuperSaverTax, airOneEconSaverBase,  airOneEconSaverTax ,  airOneEconFlexBase,  airOneEconFlexTax,  airOneFirstFlexBase,  airOneFirstFlexTax)  
		SELECT resp.airresponsekey, airPriceBase ,
		airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth,airPriceTaxYouth,AirPriceBaseTotal,AirPriceTaxTotal, airPriceBaseDisplay, airPriceTaxDisplay,flightNumber,airlines,resp .airSubRequestKey ,(airPriceTax ) ,airPriceBase + airPriceTax ,n.cabinclass    ,n.airLegConnections 
		,airSuperSaverPrice,airSuperSaverTax,airEconSaverPrice,airEconSaverTax,airEconFlexPrice,airEconFlexTax,airFirstFlexPrice,airFirstFlexTax
		From NormalizedAirResponses n  WITH (NOLOCK) inner join AirResponse resp  WITH (NOLOCK) on n.airresponsekey = resp.airResponseKey WHERE resp.airSubRequestKey =@airBundledRequest      and airlegnumber = @airRequestTypeKey    
		and resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable


		INSERT #AllOneWayResponses (airOneResponsekey,airOnePriceBase,airOnePriceBaseSenior ,airOnePriceTaxSenior, airOnePriceBaseChildren ,airOnePriceTaxChildren ,airOnePriceBaseInfant, airOnePriceTaxInfant,airOnePriceBaseYouth, airOnePriceTaxYouth, airOnePriceBaseTotal, airOnePriceTaxTotal,airOnePriceBaseDisplay, airOnePriceTaxDisplay,airSegmentFlightNumber,airSegmentMarketingAirlineCode,airsubRequestkey,airOnePriceTax ,airpriceTotal ,cabinclass  ,legConnections
		,airOneSuperSaverBase, airOneSuperSaverTax, airOneEconSaverBase,  airOneEconSaverTax ,  airOneEconFlexBase,  airOneEconFlexTax,  airOneFirstFlexBase,  airOneFirstFlexTax)  
		SELECT resp.airresponsekey, (airPriceBase   ),
		airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth,airPriceTaxYouth,AirPriceBaseTotal,AirPriceTaxTotal, airPriceBaseDisplay, airPriceTaxDisplay,flightNumber,airlines,resp .airSubRequestKey ,(airPriceTax ) ,airPriceBase + airPriceTax ,n.cabinclass    ,n.airLegConnections 
		,airSuperSaverPrice,airSuperSaverTax,airEconSaverPrice,airEconSaverTax,airEconFlexPrice,airEconFlexTax,airFirstFlexPrice,airFirstFlexTax
		From NormalizedAirResponses n  WITH (NOLOCK) inner join AirResponse resp  WITH (NOLOCK) on n.airresponsekey = resp.airResponseKey WHERE resp.airSubRequestKey =@airPublishedFareRequest      and airlegnumber = @airRequestTypeKey    
		and resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable
		/***Delete responses which are not available in respective one way responses AS fare buckets are applicable for one way logic  **/   
		--IF ( @airBundledRequest is not null )   
		--BEGIN   
		--IF (SELECT COUNT(*)   From NormalizedAirResponses  WITH (NOLOCK) WHERE airsubrequestkey = @airSubRequestKey ) > 0   
		--	delete FROM #AllOneWayResponses WHERE airOneResponsekey in (  
		--	SELECT n.airresponsekey From NormalizedAirResponses n  WITH (NOLOCK) 
		--	INNER JOIN AirResponse resp  WITH (NOLOCK) ON n.airresponsekey =resp.airResponseKey   
		--	WHERE resp.airsubrequestkey = @airBundledRequest AND resp.gdsSourceKey = 2  AND airLegNumber =@airRequestTypeKey AND flightNumber not in (  
		--	SELECT flightNumber From NormalizedAirResponses WITH (NOLOCK)WHERE airsubrequestkey = @airSubRequestKey))   
		--END   
	/***Delete all other airlines other than filter airlines**/ 
	
	

	 
		IF @gdssourcekey = 9   
		BEGIN   
		IF(@airLines <> 'Multiple Airlines')  
		BEGIN  
			DELETE FROM #AllOneWayResponses WHERE airOneResponsekey in (  
			SELECT DISTINCT seg.airResponseKey   FROM AirSegments seg  WITH (NOLOCK) INNER JOIN AirResponse  resp  WITH (NOLOCK) ON seg .airResponseKey = resp.airresponsekey   
			INNER JOIN AirSubRequest subrequest  WITH (NOLOCK) ON resp.airSubRequestKey = subrequest .airSubRequestKey and seg.airSegmentMarketingAirlineCode not in (select * From @tmpAirline )   
			WHERE   airrequestKey = @airRequestKey    AND gdsSourceKey = @gdssourcekey  AND airLegNumber =@airRequestTypeKey)   
		END  
		END   

		INSERT @secondLegDetails ( otherlegsAirlinesCount ,responsekey ,otherLegAirlines )
		SELECT COUNT(DISTINCT airSegmentMarketingAirlineCode) , seg.airResponseKey ,
		( CASE WHEN (COUNT(DISTINCT airSegmentMarketingAirlineCode))> 1 THEN 'Multiple Airlines' ELSE 
		MIN (airSegmentMarketingAirlineCode ) END ) From airsegments seg WITH (NOLOCK)  INNER JOIN airresponse r WITH ( NOLOCK)
		ON seg.airResponseKey = r.airResponseKey where ( airSubRequestKey =@airBundledRequest OR airSubRequestKey =@airPublishedFareRequest )  and airLegNumber = 2
		and r.gdsSourceKey = 9 AND r.refundable = @ForRefundable
		GROUP BY seg.airResponseKey 

		--INSERT @secondLegDetails ( otherlegsAirlinesCount ,responsekey ,otherLegAirlines )
		--SELECT COUNT(DISTINCT airSegmentMarketingAirlineCode) , seg.airResponseKey ,
		--( CASE WHEN (COUNT(DISTINCT airSegmentMarketingAirlineCode))> 1 THEN 'Multiple Airlines' ELSE 
		--MIN (airSegmentMarketingAirlineCode ) END ) From airsegments seg WITH (NOLOCK)  INNER JOIN airresponse r WITH ( NOLOCK)
		--ON seg.airResponseKey = r.airResponseKey where airSubRequestKey =@airPublishedFareRequest  and airLegNumber = 2
		--GROUP BY seg.airResponseKey 

	END   
	ELSE  
	BEGIN    
	DECLARE @isPure AS int   
	SET  @isPure =(SELECT count(distinct airSegmentMarketingAirlineCode) FROM airsegments  WITH (NOLOCK) WHERE airresponsekey =@SELECTedResponseKey)  
	--IF @airLegNumber = 2 /**Round trip or 1st basic validation for 2nd leg */  
	DECLARE @valid AS TABLE ( airResponsekey uniqueidentifier )   
	--BEGIN  

	SET @gdssourcekey = ( SELECT distinct gdssourcekey FROM AirResponse  WITH (NOLOCK)WHERE airResponseKey = @SELECTedResponseKey )           


	IF (SELECT COUNT(*) FROM @SELECTedResponse SELECTed INNER JOIN AirResponse resp  WITH (NOLOCK) ON SELECTed .responsekey = resp.airResponseKey WHERE gdsSourceKey = 9 )   = 0   
	BEGIN  
	IF ( @SELECTedFareType = '') /*No bucket SELECTed */  
	BEGIN  
	INSERT @valid ( airResponsekey )   
	( SELECT * FROM ufn_GetValidResponsesForMultiCity  (@airRequestTypeKey  ,@airBundledRequest   , @SELECTedResponseKey   ,@SELECTedResponseKeySecond   ,@SELECTedResponseKeyThird   ,@SELECTedResponseKeyFourth ,@SelectedResponseKeyFifth  ))  
	END   
	END   
		INSERT #AllOneWayResponses (airOneResponsekey,airOnePriceBase,airOnePriceBaseSenior ,airOnePriceTaxSenior, airOnePriceBaseChildren ,airOnePriceTaxChildren ,airOnePriceBaseInfant, airOnePriceTaxInfant,airOnePriceBaseYouth, airOnePriceTaxYouth, airOnePriceBaseTotal, airOnePriceTaxTotal,airOnePriceBaseDisplay, airOnePriceTaxDisplay,airSegmentFlightNumber,airSegmentMarketingAirlineCode,airsubRequestkey,airOnePriceTax ,airpriceTotal ,cabinclass ,legConnections 
		,airOneSuperSaverBase, airOneSuperSaverTax, airOneEconSaverBase,  airOneEconSaverTax ,  airOneEconFlexBase,  airOneEconFlexTax,  airOneFirstFlexBase,  airOneFirstFlexTax)  
		SELECT distinct resp.AirResponsekey, (airPriceBase    ) ,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth,airPriceTaxYouth,AirPriceBaseTotal,AirPriceTaxTotal,airPriceBaseDisplay, airPriceTaxDisplay,N.flightNumber ,N.airlines,resp.airSubRequestKey,airPriceTax ,airPriceBase + airPriceTax ,n.cabinclass ,n.airLegConnections  
		,airSuperSaverPrice,airSuperSaverTax,airEconSaverPrice,airEconSaverTax,airEconFlexPrice,airEconFlexTax,airFirstFlexPrice,airFirstFlexTax
		FROM AirResponse resp  WITH (NOLOCK) 
		INNER JOIN NormalizedAirResponses n  WITH (NOLOCK) ON resp.airresponsekey = n.airresponsekey  
		INNER JOIN @valid valid ON resp.airResponseKey = valid .airResponsekey  
		AND resp.gdsSourceKey = 9 AND N .airLegNumber = @airRequestTypeKey AND resp.refundable = @ForRefundable  


		INSERT @secondLegDetails ( otherlegsAirlinesCount ,responsekey ,otherLegAirlines )
		select COUNT(distinct airSegmentMarketingAirlineCode) , seg.airResponseKey ,
		( CASE WHEN (COUNT(distinct airSegmentMarketingAirlineCode))> 1 then 'Multiple Airlines' else 
		MIN (airSegmentMarketingAirlineCode ) END ) From airsegments seg WITH (NOLOCK) inner join airresponse r WITH (NOLOCK) on seg.airResponseKey = r.airResponseKey
		INNER JOIN @valid V on r.airResponseKey = v.airResponsekey     WHERE airLegNumber = 1
		and r.gdsSourceKey = 9 AND r.refundable = @ForRefundable
		group by seg.airResponseKey 

	/***Delete all other airlines other than filter airlines**/  
	--      IF @gdssourcekey =9   
	--      BEGIN    
	--IF(@airLines <> 'Multiple Airlines')  
	--BEGIN  
	-- delete from #AllOneWayResponses where airOneResponsekey in (  
	-- select distinct seg.airResponseKey   FROM AirSegments seg INNER JOIN AirResponse  resp ON seg .airResponseKey = resp.airresponsekey   
	-- INNER JOIN AirSubRequest subrequest ON resp.airSubRequestKey = subrequest .airSubRequestKey and seg.airSegmentMarketingAirlineCode not in (select * From @tmpAirline )   
	-- WHERE   airrequestKey = @airRequestKey    AND gdsSourceKey = @gdssourcekey)  
	--END  
	--END  
	END   
	

	/***getting valid one ways ***/  
	DECLARE @noOfLegsForRequest AS int   
	SET @noOfLegsForRequest =( SELECT COUNT(*) FROM AirSubRequest WITH(NOLOCK) WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex > 0 )   

	DECLARE @validOneWays AS bit = 1   

	IF  @noOfLegsForRequest > 1   
	BEGIN  
	IF ( @airRequestTypeKey > 1 )  
	BEGIN    
	IF ( SELECT COUNT (*) FROM @SELECTedResponse ) = @airRequestTypeKey -1   
	BEGIN   
	SET @validOneWays = 1  
	END   
	ELSE    
	BEGIN  
	SET @validOneWays = 0   
	END   
	END   
	END   
	/***END  valid one ways ***/  
	DECLARE @selectedgroupKey AS INT 
	SELECT @selectedgroupKey= groupKey  FROM AirSubRequest Sub WITH (NOLOCK) INNER JOIN AirResponse AR WITH (NOLOCK) on sub.airSubRequestKey = AR.airSubRequestKey WHERE AR.airResponseKey = @SelectedResponseKey and AR.gdsSourceKey = 9 and AR.refundable = @ForRefundable 

	IF ( @validOneWays =1 ) /**checking for all leg one way prices are available*/  
	BEGIN   

	IF ( @airRequestTypeKey = 1 )   
	BEGIN   
		INSERT #AllOneWayResponses (airOneResponsekey,airOnePriceBase,airOnePriceBaseSenior,airOnePriceTaxSenior,airOnePriceBaseChildren,airOnePriceTaxChildren,airOnePriceBaseInfant,airOnePriceTaxInfant,airOnePriceBaseYouth,airOnePriceTaxYouth,airOnePriceBaseTotal,airOnePriceTaxTotal,airOnePriceBaseDisplay, airOnePriceTaxDisplay,airSegmentFlightNumber,airSegmentMarketingAirlineCode,airsubRequestkey,airOnePriceTax ,airpriceTotal,otherLegprice,cabinclass  ,otherlegtax ,legConnections
		 ,airOneSuperSaverBase, airOneSuperSaverTax, airOneEconSaverBase,  airOneEconSaverTax ,  airOneEconFlexBase,  airOneEconFlexTax,  airOneFirstFlexBase,  airOneFirstFlexTax)  
		SELECT resp.airresponsekey, (airPriceBase + ISNULL(@airPriceForAnotherLeg,0)  ),
		(airPriceBaseSenior + ISNULL(@airPriceSeniorForAnotherLeg,0)  ),(airPriceTaxSenior + ISNULL(@airPriceTaxSeniorForAnotherLeg,0)),
		(airPriceBaseChildren + ISNULL(@airPriceChildrenForAnotherLeg,0)  ),(airPriceTaxChildren + ISNULL(@airPriceTaxChildrenForAnotherLeg,0)),
		(airPriceBaseInfant + ISNULL(@airPriceInfantForAnotherLeg,0)  ),(airPriceTaxInfant + ISNULL(@airPriceTaxInfantForAnotherLeg,0)),
		(airPriceBaseYouth + ISNULL(@airPriceYouthForAnotherLeg,0)  ),(airPriceTaxYouth + ISNULL(@airPriceTaxYouthForAnotherLeg,0)),
		(AirPriceBaseTotal + ISNULL(@airPriceTotalForAnotherLeg,0)  ),(AirPriceTaxTotal + ISNULL(@airPriceTaxTotalForAnotherLeg,0)),
		(airPriceBaseDisplay + ISNULL(@airPriceDisplayForAnotherLeg,0)  ),(airPriceTaxDisplay + ISNULL(@airPriceTaxDisplayForAnotherLeg,0)),
		flightNumber,airlines,resp .airSubRequestKey ,(airPriceTax + ISNULL(@airPriceTaxForAnotherLeg,0)),(airPriceBase + ISNULL(@airPriceForAnotherLeg,0)  )+(airPriceTax + ISNULL
		(@airPriceTaxForAnotherLeg,0)), case when @isTotalPriceSort = 0 THEN  ISNULL(@airPriceForAnotherLeg,0) else( isnull(@airPriceForAnotherLeg ,0) + isnull(@airPriceTaxForAnotherLeg,0) ) END ,N.cabinclass ,isnull(@airPriceTaxForAnotherLeg,0)  ,n.airLegConnections
		,Case WHEN (ISNull(airSuperSaverPrice,0) > 0 AND @airSuperSaverPriceForAnotherLeg > 0) OR @airRequestType = 1 then (airSuperSaverPrice + @airSuperSaverPriceForAnotherLeg)  else 0 end,
		 Case WHEN (ISNull(airSuperSaverTax,0) > 0 AND @airSuperSaverTaxForAnotherLeg > 0) OR @airRequestType = 1 then (airSuperSaverTax + @airSuperSaverTaxForAnotherLeg)  else 0 end,
		Case WHEN (ISNull(airEconSaverPrice,0) > 0 AND @airEconSaverPriceForAnotherLeg > 0) OR @airRequestType = 1 then (airEconSaverPrice + @airEconSaverPriceForAnotherLeg)  else 0 end ,
		Case WHEN (ISNull(airEconSaverTax,0) > 0 AND @airEconSaverTaxForAnotherLeg > 0) OR @airRequestType = 1 then (airEconSaverTax + @airEconSaverTaxForAnotherLeg)  else 0 end ,
		Case WHEN (ISNull(airEconFlexPrice,0) > 0 AND @airEconFlexPriceForAnotherLeg > 0) OR @airRequestType = 1 then (airEconFlexPrice + @airEconFlexPriceForAnotherLeg)  else 0 end ,
		Case WHEN (ISNull(airEconFlexTax,0) > 0 AND @airEconFlexTaxForAnotherLeg > 0) OR @airRequestType = 1 then (airEconFlexTax + @airEconFlexTaxForAnotherLeg)  else 0 end,
		Case WHEN (ISNull(airFirstFlexPrice,0) > 0 AND @airFirstFlexPriceForAnotherLeg > 0) OR @airRequestType = 1 then (airFirstFlexPrice + @airFirstFlexPriceForAnotherLeg)  else 0 end ,
		Case WHEN (ISNull(airFirstFlexTax,0) > 0 AND @airFirstFlexTaxForAnotherLeg > 0) OR @airRequestType = 1 then (airFirstFlexTax + @airFirstFlexTaxForAnotherLeg)  else 0 end 

		From NormalizedAirResponses n WITH (NOLOCK)inner join AirResponse resp WITH (NOLOCK) on n.airresponsekey = resp.airResponseKey WHERE resp.airSubRequestKey = @airSubRequestKey   
		and resp.gdsSourceKey = 9 and resp.refundable = @ForRefundable 

		print('remove')
		if ( @airRequestType =1  ) 
		BEGIN
		INSERT #AllOneWayResponses (airOneResponsekey,airOnePriceBase,airOnePriceBaseSenior,airOnePriceTaxSenior,airOnePriceBaseChildren,airOnePriceTaxChildren,airOnePriceBaseInfant,airOnePriceTaxInfant,airOnePriceBaseYouth,airOnePriceTaxYouth,airOnePriceBaseTotal,airOnePriceTaxTotal,airOnePriceBaseDisplay, airOnePriceTaxDisplay,airSegmentFlightNumber,airSegmentMarketingAirlineCode,airsubRequestkey,airOnePriceTax ,airpriceTotal,otherLegprice,cabinclass  ,otherlegtax ,legConnections 
		,airOneSuperSaverBase, airOneSuperSaverTax, airOneEconSaverBase,  airOneEconSaverTax ,  airOneEconFlexBase,  airOneEconFlexTax,  airOneFirstFlexBase,  airOneFirstFlexTax)  
		SELECT resp.airresponsekey, (airPriceBase + ISNULL(@airPriceForAnotherLeg,0)  ),
		(airPriceBaseSenior + ISNULL(@airPriceSeniorForAnotherLeg,0)  ),(airPriceTaxSenior + ISNULL(@airPriceTaxSeniorForAnotherLeg,0)),
		(airPriceBaseChildren + ISNULL(@airPriceChildrenForAnotherLeg,0)  ),(airPriceTaxChildren + ISNULL(@airPriceTaxChildrenForAnotherLeg,0)),
		(airPriceBaseInfant + ISNULL(@airPriceInfantForAnotherLeg,0)  ),(airPriceTaxInfant + ISNULL(@airPriceTaxInfantForAnotherLeg,0)),
		(airPriceBaseYouth + ISNULL(@airPriceYouthForAnotherLeg,0)  ),(airPriceTaxYouth + ISNULL(@airPriceTaxYouthForAnotherLeg,0)),
		(AirPriceBaseTotal + ISNULL(@airPriceTotalForAnotherLeg,0)  ),(AirPriceTaxTotal + ISNULL(@airPriceTaxTotalForAnotherLeg,0)),
		(airPriceBaseDisplay + ISNULL(@airPriceDisplayForAnotherLeg,0)  ),(airPriceTaxDisplay + ISNULL(@airPriceTaxDisplayForAnotherLeg,0)),
		flightNumber,airlines,resp .airSubRequestKey ,(airPriceTax + ISNULL(@airPriceTaxForAnotherLeg,0)),(airPriceBase + ISNULL(@airPriceForAnotherLeg,0)  )+(airPriceTax + ISNULL
		(@airPriceTaxForAnotherLeg,0)), case when @isTotalPriceSort = 0 THEN  ISNULL(@airPriceForAnotherLeg,0) else( isnull(@airPriceForAnotherLeg ,0) + isnull(@airPriceTaxForAnotherLeg,0) ) END ,N.cabinclass ,isnull(@airPriceTaxForAnotherLeg,0)  ,n.airLegConnections
		,Case WHEN (ISNull(airSuperSaverPrice,0) > 0 AND @airSuperSaverPriceForAnotherLeg > 0) OR @airRequestType = 1 then (airSuperSaverPrice + @airSuperSaverPriceForAnotherLeg)  else 0 end,
		 Case WHEN (ISNull(airSuperSaverTax,0) > 0 AND @airSuperSaverTaxForAnotherLeg > 0) OR @airRequestType = 1 then (airSuperSaverTax + @airSuperSaverTaxForAnotherLeg)  else 0 end,
		Case WHEN (ISNull(airEconSaverPrice,0) > 0 AND @airEconSaverPriceForAnotherLeg > 0) OR @airRequestType = 1 then (airEconSaverPrice + @airEconSaverPriceForAnotherLeg)  else 0 end ,
		Case WHEN (ISNull(airEconSaverTax,0) > 0 AND @airEconSaverTaxForAnotherLeg > 0) OR @airRequestType = 1 then (airEconSaverTax + @airEconSaverTaxForAnotherLeg)  else 0 end ,
		Case WHEN (ISNull(airEconFlexPrice,0) > 0 AND @airEconFlexPriceForAnotherLeg > 0) OR @airRequestType = 1 then (airEconFlexPrice + @airEconFlexPriceForAnotherLeg)  else 0 end ,
		Case WHEN (ISNull(airEconFlexTax,0) > 0 AND @airEconFlexTaxForAnotherLeg > 0) OR @airRequestType = 1 then (airEconFlexTax + @airEconFlexTaxForAnotherLeg)  else 0 end,
		Case WHEN (ISNull(airFirstFlexPrice,0) > 0 AND @airFirstFlexPriceForAnotherLeg > 0) OR @airRequestType = 1 then (airFirstFlexPrice + @airFirstFlexPriceForAnotherLeg)  else 0 end ,
		Case WHEN (ISNull(airFirstFlexTax,0) > 0 AND @airFirstFlexTaxForAnotherLeg > 0) OR @airRequestType = 1 then (airFirstFlexTax + @airFirstFlexTaxForAnotherLeg)  else 0 end 

		From NormalizedAirResponses n WITH (NOLOCK)inner join AirResponse resp WITH (NOLOCK) on n.airresponsekey = resp.airResponseKey WHERE resp.airSubRequestKey = @airPublishedFareRequest    
		and resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable


	END    
	 -- Remove those records which doesn't have any amount in bucket list.
      -- Remove those records which doesn't have any amount in bucket list.
			  UPDATE P  SET 
			    airOnePriceBase = case WHEN  T.airPriceClassSelected =   'Lowest Fare' THEN   airOneSuperSaverBase   
				WHEN T.airPriceClassSelected =   'Choice Essential' THEN   airOneEconSaverBase   
				WHEN T.airPriceClassSelected =   'First/Business' THEN   airOneFirstFlexBase   
				WHEN T.airPriceClassSelected =   'Choice Plus' THEN   airOneEconFlexBase    
				ELSE airOnePriceBase  END,
			   airOnePriceTax  = case WHEN  T.airPriceClassSelected =   'Lowest Fare' THEN   airOneSuperSaverTax   
				WHEN T.airPriceClassSelected =   'Choice Essential' THEN   airOneEconSaverTax   
				WHEN T.airPriceClassSelected =   'First/Business' THEN   airOneFirstFlexTax   
				WHEN T.airPriceClassSelected =   'Choice Plus' THEN   airOneEconFlexTax    
				ELSE airOnePriceBase  END,
			   airpriceTotal = case WHEN  T.airPriceClassSelected =   'Lowest Fare' THEN   airOneSuperSaverBase + airOneSuperSaverTax   
				WHEN T.airPriceClassSelected =   'Choice Essential' THEN   airOneEconSaverBase+airOneEconSaverTax   
				WHEN T.airPriceClassSelected =   'First/Business' THEN   airOneFirstFlexBase+airOneFirstFlexTax   
				WHEN T.airPriceClassSelected =   'Econ Flex' THEN   airOneEconFlexBase + airOneEconFlexTax    
				ELSE airOnePriceBase  END,
			   airOnePriceBaseDisplay = case WHEN  T.airPriceClassSelected =   'Lowest Fare' THEN   airOneSuperSaverBase   
				WHEN T.airPriceClassSelected =   'Choice Essential' THEN   airOneEconSaverBase   
				WHEN T.airPriceClassSelected =   'First/Business' THEN   airOneFirstFlexBase   
				WHEN T.airPriceClassSelected =   'Choice Plus' THEN   airOneEconFlexBase    
				ELSE airOnePriceBase  END,
				airOnePriceTaxDisplay = case WHEN  T.airPriceClassSelected =   'Lowest Fare' THEN   airOneSuperSaverTax   
				WHEN T.airPriceClassSelected =   'Choice Essential' THEN   airOneEconSaverTax   
				WHEN T.airPriceClassSelected =   'First/Business' THEN   airOneFirstFlexTax   
				WHEN T.airPriceClassSelected =   'Choice Plus' THEN   airOneEconFlexTax    
				ELSE airOnePriceBase  END
	          FROM #AllOneWayResponses P
	          INNER JOIN AirResponse T  ON P.airOneResponsekey = T.airresponsekey 
	          AND T.gdsSourceKey = 9 
	          
	          DELETE P
	          FROM #ALLOneWayResponses P 
	          INNER JOIN AirResponse T  ON P.airOneResponsekey = T.airresponsekey 
	          AND T.gdsSourceKey = 9 
	          AND airOneSuperSaverBase = 0 AND airOneEconSaverBase = 0 AND airOneFirstFlexBase = 0 AND airOneEconFlexBase = 0
	END   
	ELSE   
	BEGIN  
		--IF @gdssourcekey =  0 or @gdssourcekey <> 9  
		--BEGIN  
		IF ( @airPriceForAnotherLeg is not null AND @airPriceForAnotherLeg > 0 AND (@airRequestType >= 2 )    )   
		BEGIN  
		update #AllOneWayResponses SET otherLegprice = case when @isTotalPriceSort = 0 THEN  ISNULL(@airPriceForAnotherLeg,0) else( isnull(@airPriceForAnotherLeg ,0) + isnull(@airPriceTaxForAnotherLeg,0) ) END ,otherlegtax =isnull(@airPriceTaxForAnotherLeg,0
		)

		IF(@selectedgroupKey = 1) 
		BEGIN

		INSERT #AllOneWayResponses (airOneResponsekey,airOnePriceBase,airOnePriceBaseSenior ,airOnePriceTaxSenior, airOnePriceBaseChildren ,airOnePriceTaxChildren ,airOnePriceBaseInfant, airOnePriceTaxInfant,airOnePriceBaseYouth, airOnePriceTaxYouth, airOnePriceBaseTotal, airOnePriceTaxTotal,airOnePriceBaseDisplay, airOnePriceTaxDisplay,
		airSegmentFlightNumber,airSegmentMarketingAirlineCode,airsubRequestkey,airOnePriceTax ,airpriceTotal,otherLegprice ,cabinclass ,otherlegtax  ,legConnections 
		,airOneSuperSaverBase, airOneSuperSaverTax, airOneEconSaverBase,  airOneEconSaverTax ,  airOneEconFlexBase,  airOneEconFlexTax,  airOneFirstFlexBase,  airOneFirstFlexTax)  
		SELECT resp.airresponsekey, (airPriceBase + ISNULL(@airPriceForAnotherLeg,0)  ),
		(airPriceBaseSenior + ISNULL(@airPriceSeniorForAnotherLeg,0)  ),
		(airPriceTaxSenior + ISNULL(@airPriceTaxSeniorForAnotherLeg,0)),
		(airPriceBaseChildren + ISNULL(@airPriceChildrenForAnotherLeg,0)  ),
		(airPriceTaxChildren + ISNULL(@airPriceTaxChildrenForAnotherLeg,0)),
		(airPriceBaseInfant + ISNULL(@airPriceInfantForAnotherLeg,0)  ),
		(airPriceTaxInfant + ISNULL(@airPriceTaxInfantForAnotherLeg,0)),
		(airPriceBaseYouth + ISNULL(@airPriceYouthForAnotherLeg,0)  ),
		(airPriceTaxYouth + ISNULL(@airPriceTaxYouthForAnotherLeg,0)),
		(AirPriceBaseTotal + ISNULL(@airPriceTotalForAnotherLeg,0)  ),
		(AirPriceTaxTotal + ISNULL(@airPriceTaxTotalForAnotherLeg,0)),
		(airPriceBaseDisplay + ISNULL(@airPriceDisplayForAnotherLeg,0)  ),
		(airPriceTaxDisplay + ISNULL(@airPriceTaxDisplayForAnotherLeg,0)),
		flightNumber,airlines,resp .airSubRequestKey ,(airPriceTax + ISNULL(@airPriceTaxForAnotherLeg,0)),(airPriceBase + ISNULL(@airPriceForAnotherLeg,0)  )+(airPriceTax + ISNULL(@airPriceTaxForAnotherLeg,0)) , case when @isTotalPriceSort = 0 THEN  ISNULL(@airPriceForAnotherLeg,0) else( isnull(@airPriceForAnotherLeg ,0) + isnull(@airPriceTaxForAnotherLeg,0) ) END,n .cabinclass ,isnull(@airPriceTaxForAnotherLeg,0)  ,n.airLegConnections
		,Case WHEN ISNull(airSuperSaverPrice,0) > 0 AND @airSuperSaverPriceForAnotherLeg > 0 then (airSuperSaverPrice + @airSuperSaverPriceForAnotherLeg)  else 0 end,
		 Case WHEN ISNull(airSuperSaverTax,0) > 0 AND @airSuperSaverTaxForAnotherLeg > 0 then (airSuperSaverTax + @airSuperSaverTaxForAnotherLeg)  else 0 end,
		Case WHEN ISNull(airEconSaverPrice,0) > 0 AND @airEconSaverPriceForAnotherLeg > 0 then (airEconSaverPrice + @airEconSaverPriceForAnotherLeg)  else 0 end ,
		Case WHEN ISNull(airEconSaverTax,0) > 0 AND @airEconSaverTaxForAnotherLeg > 0 then (airEconSaverTax + @airEconSaverTaxForAnotherLeg)  else 0 end ,
		Case WHEN ISNull(airEconFlexPrice,0) > 0 AND @airEconFlexPriceForAnotherLeg > 0 then (airEconFlexPrice + @airEconFlexPriceForAnotherLeg)  else 0 end ,
		Case WHEN ISNull(airEconFlexTax,0) > 0 AND @airEconFlexTaxForAnotherLeg > 0 then (airEconFlexTax + @airEconFlexTaxForAnotherLeg)  else 0 end,
		Case WHEN ISNull(airFirstFlexPrice,0) > 0 AND @airFirstFlexPriceForAnotherLeg > 0 then (airFirstFlexPrice + @airFirstFlexPriceForAnotherLeg)  else 0 end ,
		Case WHEN ISNull(airFirstFlexTax,0) > 0 AND @airFirstFlexTaxForAnotherLeg > 0 then (airFirstFlexTax + @airFirstFlexTaxForAnotherLeg)  else 0 end 

		From NormalizedAirResponses n WITH (NOLOCK) inner join AirResponse resp WITH (NOLOCK) on n.airresponsekey = resp.airResponseKey WHERE resp.airSubRequestKey = @airSubRequestKey 
	    and resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable
		
		--and gdsSourceKey <> 9  
		END
		END  
		ELSE IF    (@airRequestType=1  )  
		BEGIN   
		update #AllOneWayResponses SET otherLegprice = case when @isTotalPriceSort = 0 THEN  ISNULL(@airPriceForAnotherLeg,0) else( isnull(@airPriceForAnotherLeg ,0) + isnull(@airPriceTaxForAnotherLeg,0) ) END ,otherlegtax =isnull(@airPriceTaxForAnotherLeg,0)

		INSERT #AllOneWayResponses (airOneResponsekey,airOnePriceBase,airOnePriceBaseSenior ,airOnePriceTaxSenior, airOnePriceBaseChildren ,airOnePriceTaxChildren ,airOnePriceBaseInfant, airOnePriceTaxInfant,airOnePriceBaseYouth, airOnePriceTaxYouth, airOnePriceBaseTotal, airOnePriceTaxTotal,airOnePriceBaseDisplay, airOnePriceTaxDisplay,
		airSegmentFlightNumber,airSegmentMarketingAirlineCode,airsubRequestkey,airOnePriceTax ,airpriceTotal,otherLegprice ,cabinclass ,otherlegtax  ,legConnections 
		,airOneSuperSaverBase, airOneSuperSaverTax, airOneEconSaverBase,  airOneEconSaverTax ,  airOneEconFlexBase,  airOneEconFlexTax,  airOneFirstFlexBase,  airOneFirstFlexTax)  
		SELECT resp.airresponsekey, (airPriceBase + ISNULL(@airPriceForAnotherLeg,0)  ), 
		(airPriceBaseSenior + ISNULL(@airPriceSeniorForAnotherLeg,0)  ),
		(airPriceTaxSenior + ISNULL(@airPriceTaxSeniorForAnotherLeg,0)),
		(airPriceBaseChildren + ISNULL(@airPriceChildrenForAnotherLeg,0)  ),
		(airPriceTaxChildren + ISNULL(@airPriceTaxChildrenForAnotherLeg,0)),
		(airPriceBaseInfant + ISNULL(@airPriceInfantForAnotherLeg,0)  ),
		(airPriceTaxInfant + ISNULL(@airPriceTaxInfantForAnotherLeg,0)),
		(airPriceBaseYouth + ISNULL(@airPriceYouthForAnotherLeg,0)  ),
		(airPriceTaxYouth + ISNULL(@airPriceTaxYouthForAnotherLeg,0)),
		(AirPriceBaseTotal + ISNULL(@airPriceTotalForAnotherLeg,0)  ),
		(AirPriceTaxTotal + ISNULL(@airPriceTaxTotalForAnotherLeg,0)), 
		(airPriceBaseDisplay + ISNULL(@airPriceDisplayForAnotherLeg,0)  ),
		(airPriceTaxDisplay + ISNULL(@airPriceTaxDisplayForAnotherLeg,0)),
		flightNumber,airlines,resp .airSubRequestKey ,(airPriceTax + ISNULL(@airPriceTaxForAnotherLeg,0)),(airPriceBase + ISNULL(@airPriceForAnotherLeg,0)  )+(airPriceTax + ISNULL(@airPriceTaxForAnotherLeg,0)) , case when @isTotalPriceSort = 0 THEN  ISNULL(@airPriceForAnotherLeg,0) else( isnull(@airPriceForAnotherLeg ,0) + isnull(@airPriceTaxForAnotherLeg,0) ) END,n .cabinclass ,isnull(@airPriceTaxForAnotherLeg,0) ,n.airLegConnections 
		,Case WHEN ISNull(airSuperSaverPrice,0) > 0 AND @airSuperSaverPriceForAnotherLeg > 0 then (airSuperSaverPrice + @airSuperSaverPriceForAnotherLeg)  else 0 end,
		 Case WHEN ISNull(airSuperSaverTax,0) > 0 AND @airSuperSaverTaxForAnotherLeg > 0 then (airSuperSaverTax + @airSuperSaverTaxForAnotherLeg)  else 0 end,
		Case WHEN ISNull(airEconSaverPrice,0) > 0 AND @airEconSaverPriceForAnotherLeg > 0 then (airEconSaverPrice + @airEconSaverPriceForAnotherLeg)  else 0 end ,
		Case WHEN ISNull(airEconSaverTax,0) > 0 AND @airEconSaverTaxForAnotherLeg > 0 then (airEconSaverTax + @airEconSaverTaxForAnotherLeg)  else 0 end ,
		Case WHEN ISNull(airEconFlexPrice,0) > 0 AND @airEconFlexPriceForAnotherLeg > 0 then (airEconFlexPrice + @airEconFlexPriceForAnotherLeg)  else 0 end ,
		Case WHEN ISNull(airEconFlexTax,0) > 0 AND @airEconFlexTaxForAnotherLeg > 0 then (airEconFlexTax + @airEconFlexTaxForAnotherLeg)  else 0 end,
		Case WHEN ISNull(airFirstFlexPrice,0) > 0 AND @airFirstFlexPriceForAnotherLeg > 0 then (airFirstFlexPrice + @airFirstFlexPriceForAnotherLeg)  else 0 end ,
		Case WHEN ISNull(airFirstFlexTax,0) > 0 AND @airFirstFlexTaxForAnotherLeg > 0 then (airFirstFlexTax + @airFirstFlexTaxForAnotherLeg)  else 0 end 
		From NormalizedAirResponses n WITH (NOLOCK) inner join AirResponse resp WITH (NOLOCK) on n.airresponsekey = resp.airResponseKey WHERE resp.airSubRequestKey = @airSubRequestKey
		AND  resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable  
		--and gdsSourceKey <> 9 
		
		END  
		--END   
		--IF @gdssourcekey = 0 or @gdssourcekey = 9  
		--BEGIN  
		--DECLARE @farelogixairlineLowest AS table (airline  varchar (20) ,airpriceBase   float , airpriceTax   float,airpriceBaseSenior   float , airpriceTaxSenior   float ,airpriceBaseChildren   float , airpriceTaxChildren   float ,airpriceBaseInfant   float , airpriceTaxInfant   float ,airpriceBaseYouth   float , airpriceTaxYouth   float ,AirPriceBaseTotal   float , AirPriceTaxTotal   float ,airpriceBaseDisplay   float , airpriceTaxDisplay   float )  
		--INSERT @farelogixairlineLowest   
		--SELECT airLines ,sum(airPriceBase) ,sum(airPriceTax),sum(airPriceBaseSenior) ,sum(airPriceTaxSenior),sum(airPriceBaseChildren) ,sum(airPriceTaxChildren),sum(airPriceBaseInfant) ,sum(airPriceTaxInfant),sum(airPriceBaseYouth) ,sum(airPriceTaxYouth),sum(AirPriceBaseTotal) ,sum(AirPriceTaxTotal),sum(airPriceBaseDisplay) ,sum(airPriceTaxDisplay) FROM   
		--(  
		--SELECT airLegNumber,  SUBSTRING (airlines,1,2) airLines , MIN (airpriceBase )airpriceBase,MIN ( airpriceTax)airpriceTax ,
		--MIN (airPriceBaseSenior )airpriceBaseSenior,MIN ( airpriceTaxSenior)airpriceTaxSenior ,
		--MIN (airPriceBaseChildren )airPriceBaseChildren,MIN ( airPriceTaxChildren)airpriceTaxChildren  ,
		--MIN (airPriceBaseInfant )airPriceBaseInfant,MIN ( airPriceTaxInfant)airPriceTaxInfant ,
		--MIN (airPriceBaseYouth )airPriceBaseYouth,MIN ( airPriceTaxYouth)airPriceTaxYouth ,
		--MIN (AirPriceBaseTotal )AirPriceBaseTotal,MIN ( AirPriceTaxTotal)AirPriceTaxTotal  ,
		--MIN (airPriceBaseDisplay )airPriceBaseDisplay,MIN ( airPriceTaxDisplay)airPriceTaxDisplay  
		--FROM NormalizedAirResponses  n  WITH(NOLOCK)
		--inner join AirResponse r WITH(NOLOCK)on n.airresponsekey= r.airResponseKey 
		--inner join AirSubRequest s WITH(NOLOCK) on r.airSubRequestKey = s.airSubRequestKey 
		--WHERE airRequestKey = @airRequestKey and airLegNumber <> 1  and gdsSourceKey = 9 group by SUBSTRING (airlines,1,2) ,airLegNumber ) AS FlxPrices group by airLines   

		--DECLARE @farelogixairline AS table (airline  varchar (20) )  
		--INSERT @farelogixairline   
		--SELECT * FROM [udf_GetCommonAirline] (@airRequestKey )   

		----SELECT SUBSTRING (airlines,1,2) , MIN (airpriceBase ),MIN ( airpriceTax)  FROM NormalizedAirResponses n  inner join AirResponse r on n.airresponsekey= r.airResponseKey inner join AirSubRequest s on r.airSubRequestKey = s.airSubRequestKey WHERE airRequestKey = @airRequestKey and airLegNumber = 2 and gdsSourceKey = 9   
		----     group by SUBSTRING (airlines,1,2)  

		----  SELECT SUBSTRING (airlines,1,2) , MIN (airpriceBase ),MIN ( airpriceTax)  FROM NormalizedAirResponses n  inner join AirResponse r on n.airresponsekey= r.airResponseKey inner join AirSubRequest s on r.airSubRequestKey = s.airSubRequestKey   
		--INSERT #AllOneWayResponses (airOneResponsekey,airOnePriceBase,airOnePriceBaseSenior,airOnePriceTaxSenior,airOnePriceBaseChildren,airOnePriceTaxChildren,airOnePriceBaseInfant,airOnePriceTaxInfant,airOnePriceBaseYouth,airOnePriceTaxYouth,airOnePriceBaseTotal,airOnePriceTaxTotal,airOnePriceBaseDisplay,airOnePriceTaxDisplay,airSegmentFlightNumber,airSegmentMarketingAirlineCode,airsubRequestkey,airOnePriceTax ,airpriceTotal,otherLegprice,cabinclass  ,otherlegtax ,legConnections )  
		--SELECT resp.airresponsekey,(resp.airPriceBase + ISNULL(f.airpriceBase ,0)  ), 
		--(resp.airPriceBaseSenior + ISNULL(f.airPriceBaseSenior ,0)  ),(resp.airPriceTaxSenior + ISNULL(f.airPriceTaxSenior ,0)),
		--(resp.airPriceBaseChildren + ISNULL(f.airPriceBaseChildren ,0)  ),(resp.airPriceTaxChildren + ISNULL(f.airPriceTaxChildren  ,0)),
		--(resp.airPriceBaseInfant + ISNULL(f.airPriceBaseInfant  ,0)  ),(resp.airPriceTaxInfant  + ISNULL(f.airPriceTaxInfant ,0)),
		--(resp.airPriceBaseYouth + ISNULL(f.airPriceBaseYouth  ,0)  ),(resp.airPriceTaxYouth  + ISNULL(f.airPriceTaxYouth ,0)),
		--(resp.AirPriceBaseTotal + ISNULL(f.AirPriceBaseTotal ,0)  ),(resp.AirPriceTaxTotal + ISNULL(f.AirPriceTaxTotal  ,0)),
		--(resp.airPriceBaseDisplay + ISNULL(f.airPriceBaseDisplay ,0)  ),(resp.airPriceTaxDisplay + ISNULL(f.airPriceTaxDisplay  ,0)),
		--flightNumber,airlines,resp .airSubRequestKey ,(resp.airPriceTax + ISNULL(f.airpriceTax  ,0)),(resp.airPriceBase + ISNULL(f.airpriceBase  ,0)  )+(resp.airPriceTax + ISNULL(f.airpriceTax,0)) ,  
		--case when @isTotalPriceSort = 0 THEN  ISNULL(f.airpriceBase,0) else( isnull(f.airpriceBase ,0) + isnull(f.airpriceTax,0) ) END  
		--,n.cabinclass ,isnull(@airPriceTaxForAnotherLeg,0)  ,n.airLegConnections 
		--From NormalizedAirResponses n WITH(NOLOCK)inner join AirResponse resp WITH(NOLOCK)on n.airresponsekey = resp.airResponseKey   
		--INNER JOIN @farelogixairline flxAirlines on flxAirlines.airline = SUBSTRING (n.airlines,1,2)  
		--left outer  join @farelogixairlineLowest f on SUBSTRING(n.airlines,1,2)= f.airline   
		--WHERE resp.airSubRequestKey = @airSubRequestKey   
		--and gdsSourceKey = 9  
		--END   
	
				
			IF @gdssourcekey = 9 AND (@SelectedFareType is not null  AND @SelectedFareType != '')
			BEGIN
			  UPDATE #AllOneWayResponses   SET 
			         airOnePriceBase = case WHEN  @SelectedFareType =   'Super Saver' THEN   airOneSuperSaverBase   
				WHEN @SelectedFareType =   'Econ Saver' THEN   airOneEconSaverBase   
				WHEN @SelectedFareType =   'First Flex' THEN   airOneFirstFlexBase   
				WHEN @SelectedFareType =   'Econ Flex' THEN   airOneEconFlexBase    
				ELSE airOnePriceBase  END,
			   airOnePriceTax  = case WHEN  @SelectedFareType =   'Super Saver' THEN   airOneSuperSaverTax   
				WHEN @SelectedFareType =   'Econ Saver' THEN   airOneEconSaverTax   
				WHEN @SelectedFareType =   'First Flex' THEN   airOneFirstFlexTax   
				WHEN @SelectedFareType =   'Econ Flex' THEN   airOneEconFlexTax    
				ELSE airOnePriceBase  END,
			   airpriceTotal = case WHEN  @SelectedFareType =   'Super Saver' THEN   airOneSuperSaverBase + airOneSuperSaverTax   
				WHEN @SelectedFareType =   'Econ Saver' THEN   airOneEconSaverBase+airOneEconSaverTax   
				WHEN @SelectedFareType =   'First Flex' THEN   airOneFirstFlexBase+airOneFirstFlexTax   
				WHEN @SelectedFareType =   'Econ Flex' THEN   airOneEconFlexBase + airOneEconFlexTax    
				ELSE airOnePriceBase  END,
			   airOnePriceBaseDisplay = case WHEN  @SelectedFareType =   'Super Saver' THEN   airOneSuperSaverBase   
				WHEN @SelectedFareType =   'Econ Saver' THEN   airOneEconSaverBase   
				WHEN @SelectedFareType =   'First Flex' THEN   airOneFirstFlexBase   
				WHEN @SelectedFareType =   'Econ Flex' THEN   airOneEconFlexBase    
				ELSE airOnePriceBase  END,
				airOnePriceTaxDisplay = case WHEN  @SelectedFareType =   'Super Saver' THEN   airOneSuperSaverTax   
				WHEN @SelectedFareType =   'Econ Saver' THEN   airOneEconSaverTax   
				WHEN @SelectedFareType =   'First Flex' THEN   airOneFirstFlexTax   
				WHEN @SelectedFareType =   'Econ Flex' THEN   airOneEconFlexTax    
				ELSE airOnePriceBase  END
	          FROM #AllOneWayResponses
	          
	          DELETE FROM #ALLOneWayResponses
	          Where airOnePriceBase = 0
	          
			END
	END   
	END   


	/***Delete all other airlines other than filter airlines**/  
	-- IF @gdssourcekey = 9   
	-- BEGIN  
	--IF(@airLines <> 'Multiple Airlines')  
	--BEGIN  
	-- delete from #AllOneWayResponses where airOneResponsekey in (  
	-- select distinct seg.airResponseKey   FROM AirSegments seg INNER JOIN AirResponse  resp ON seg .airResponseKey = resp.airresponsekey   
	-- INNER JOIN AirSubRequest subrequest ON resp.airSubRequestKey = subrequest .airSubRequestKey and seg.airSegmentMarketingAirlineCode not in (select * From @tmpAirline )   
	-- WHERE   airrequestKey = @airRequestKey    AND gdsSourceKey = @gdssourcekey)  
	--END   
	--END   

	IF @airRequestTypeKey > 1
	BEGIN
		IF ( select COUNT (*) from  AirSegments seg WITH (NOLOCK) inner join @SELECTedResponse s on seg.airResponseKey =s.responsekey and airSegmentMarketingAirlineCode ='WN' ) > 0    
		BEGIN   
			DELETE FROM #AllOneWayResponses WHERE airOneResponsekey in (Select distinct airresponsekey from  AirSegments seg WITH (NOLOCK) inner join #AllOneWayResponses res on res.airOneResponsekey = seg.airResponseKey where seg.airSegmentMarketingAirlineCode <> 'WN')
		END   
		ELSE   
		BEGIN   
			IF (@SelectedResponseKey  IS NOT NULL AND @SelectedResponseKey <> '{00000000-0000-0000-0000-000000000000}')
			BEGIN  
				IF (SELECT COUNT(*) FROM AirSegments S WITH (NOLOCK) INNER JOIN airResponse A on A.airResponseKey = S.airResponseKey AND A.airResponseKey = @SelectedResponseKey AND airSegmentMarketingAirlineCode ='WN' ) < 0
				BEGIN
					DELETE FROM #AllOneWayResponses WHERE airOneResponsekey in (Select distinct airresponsekey from  AirSegments seg WITH (NOLOCK) inner join #AllOneWayResponses res on res.airOneResponsekey = seg.airResponseKey where seg.airSegmentMarketingAirlineCode = 'WN')
				END
			END				  
		END
	--PRINT 'Is SouthWest: ' + CASE WHEN @isSouthWestPresent = 1 THEN 'Yes' ELSE 'No' END
	END	


	Delete P  
	FROM #AllOneWayResponses  P  
	INNER JOIN @tempResponseToRemove T  ON P.airOneResponsekey = T.airresponsekey  

	-- INSERT into @tempOneWayResponses   
	-- SELECT ROW_NUMBER() over (order by airpriceTotal ) AS airOneIdent , * FROM #AllOneWayResponses    

	----Delete P  
	----   FROM @tempOneWayResponses P  
	----   INNER JOIN @tempResponseToRemove T  ON P.airOneResponsekey = T.airresponsekey  

	--delete #AllOneWayResponses  
	--FROM #AllOneWayResponses t,  
	--(  
	-- SELECT min(airOnePriceBase + airOnePriceTax) AS minPrice,MIN(airOneIdent )  AS minIdent,   airSegmentFlightNumber,airSegmentMarketingAirlineCode  ,cabinclass   
	-- FROM #AllOneWayResponses m  
	-- GROUP BY   airSegmentFlightNumber,airSegmentMarketingAirlineCode  ,cabinclass   
	-- having count(1) > 1  
	--) AS derived  
	--WHERE t.airSegmentFlightNumber = derived.airSegmentFlightNumber AND t.airSegmentMarketingAirlineCode =derived .airSegmentMarketingAirlineCode AND isnull(t.cabinclass,'') =isnull(derived .cabinclass ,'')  
	--AND (airOnePriceBase + airOnePriceTax) >= minPrice  AND airOneIdent > minIdent  

	/****KEEP ALL DUPLICATE WITH LOWEST PRICE AND DELETE HIGHER PRICE ****/
	
	delete #AllOneWayResponses  
	FROM #AllOneWayResponses t,  
	(  
	SELECT min(airOnePriceBase + airOnePriceTax) AS minPrice,MIN(airOneIdent )  AS minIdent,   airSegmentFlightNumber,airSegmentMarketingAirlineCode  ,cabinclass   
	FROM #AllOneWayResponses m  
	GROUP BY   airSegmentFlightNumber,airSegmentMarketingAirlineCode  ,cabinclass   
	having count(1) > 1  
	) AS derived  
	WHERE t.airSegmentFlightNumber = derived.airSegmentFlightNumber AND t.airSegmentMarketingAirlineCode =derived .airSegmentMarketingAirlineCode AND isnull(t.cabinclass,'') =isnull(derived .cabinclass ,'')  
	AND (airOnePriceBase + airOnePriceTax) >  minPrice  --AND airOneIdent >= minIdent  

	/****KEEP ONLY ONE LOWEST PRICE ,REMOVE ALL OTHER WITH SAME PRICE ****/
	delete #AllOneWayResponses  
	FROM #AllOneWayResponses t,  
	(  
	SELECT min(airOnePriceBase + airOnePriceTax) AS minPrice,MIN(airOneIdent )  AS minIdent,   airSegmentFlightNumber,airSegmentMarketingAirlineCode  ,cabinclass   
	FROM #AllOneWayResponses m  
	GROUP BY   airSegmentFlightNumber,airSegmentMarketingAirlineCode  ,cabinclass   
	having count(1) > 1  
	) AS derived  
	WHERE t.airSegmentFlightNumber = derived.airSegmentFlightNumber AND t.airSegmentMarketingAirlineCode =derived .airSegmentMarketingAirlineCode AND isnull(t.cabinclass,'') =isnull(derived .cabinclass ,'')  
	AND airOneIdent > minIdent 

	UPDATE  A  SET otherlegAirlines = S.otherLegAirlines , noOfOtherlegairlines = otherlegsAirlinesCount  FROM #AllOneWayResponses A inner join @secondLegDetails S on A.airOneResponsekey = S.responsekey and airsubRequestkey = @airBundledRequest 

	UPDATE #AllOneWayResponses   SET otherlegAirlines = @anotherLegAirlines, noOfOtherlegairlines = @anotherLegAirlinesCount   
	FROM #AllOneWayResponses WHERE  otherlegAirlines is null or noOfOtherlegairlines is null 



	DECLARE @rowIndex AS INT =0 
	CREATE table #normalizedResultSet       
	(  
	airresponsekey uniqueidentifier ,  
	noOFSTOPs int ,  
	gdssourcekey int ,  
	noOfAirlines int ,  
	takeoffdate datetime ,  
	landingdate datetime ,   
	airlineCode varchar(60),  
	airsubrequetkey int  ,  
	otherlegprice float ,
	cabinclass varchar(20),
	otherlegtax float,
	airPriceBase float ,  
	airpriceTax float ,  
	airPriceBaseSenior float,
	airPriceTaxSenior float,
	airPriceBaseChildren float,
	airPriceTaxChildren float,
	airPriceBaseInfant float,
	airPriceTaxInfant float,
	airPriceBaseYouth float,
	airPriceTaxYouth float,
	airPriceBaseTotal float,
	airPriceTaxTotal float,
	airPriceBaseDisplay float,
	airPriceTaxDisplay float  ,
	otherlegAirlines varchar(40),
	noOfOtherlegairlines int ,
	legconnections varchar(50),actualNoOFStops INT,
	legDurationInMinutes INT ,
	legDuration INT ,
	startingFlightNumber Varchar(10),
	startingFlightAirline Varchar(20),
	rowNumber INT,
	isSameAirlinesItin bit default 0 ,
	airSuperSaverPrice float ,  
	airEconSaverPrice float ,  
	airFirstFlexPrice  float ,  
	airEconFlexPrice float ,  
	airSuperSaverTax float ,  
	airEconSaverTax float ,  
	airFirstFlexTax  float ,  
	airEconFlexTax float  ,
	isLowestJourneyTime bit default 0,  
	lastFlightNumber Varchar(10),
	lastFlightAirline Varchar(20)
	)   

	INSERT  #normalizedResultSet (airresponsekey ,airPriceBase,noOFSTOPs ,noOfAirlines ,takeoffdate ,landingdate ,airlinecode ,gdssourcekey ,airpricetax ,airsubrequetkey ,otherlegprice,cabinclass,otherlegtax ,  airPriceBaseSenior, airPriceTaxSenior, airPriceBaseChildren,airPriceTaxChildren, airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth, airPriceTaxYouth, airPriceBaseTotal,airPriceTaxTotal, airPriceBaseDisplay,airPriceTaxDisplay,noOfOtherlegairlines ,otherlegAirlines,legConnections,actualNoOFStops,isSameAirlinesItin
	,airSuperSaverPrice,airEconSaverPrice,airFirstFlexPrice,airEconFlexPrice,  airSuperSaverTax,  airEconSaverTax,  airFirstFlexTax, airEconFlexTax)  
	(  
	SELECT seg.airresponsekey,result.airOnePriceBaseDisplay ,CASE WHEN COUNT(seg.airresponsekey )-1  > 1 THEN (CASE WHEN @MaxNoofstops=2 THEN 2 ELSE 1 END) ELSE  COUNT(seg.airresponsekey )-1 END ,COUNT(distinct seg.airSegmentMarketingAirlineCode ),MIN(airSegmentDepartureDate ) ,MAX(airSegmentArrivalDate ), 
	CASE WHEN COUNT(distinct seg.airSegmentMarketingAirlineCode ) > 1 THEN 'Multiple Airlines'  ELSE MIN(seg.airSegmentMarketingAirlineCode) END ,  
	resp.gdsSourceKey, result.airOnePriceTaxDisplay ,result.airsubRequestkey ,otherlegprice ,result.cabinclass ,otherlegtax , result.airOnePriceBaseSenior, result.airOnePriceTaxSenior, result.airOnePriceBaseChildren,result.airOnePriceTaxChildren, result.airOnePriceBaseInfant,result.airOnePriceTaxInfant,result.airOnePriceBaseYouth, result.airOnePriceTaxYouth, result.airOnePriceBaseTotal,result.airOnePriceTaxTotal, result.airOnePriceBaseDisplay,result.airOnePriceTaxDisplay  ,result.noOfOtherlegairlines ,result.otherlegAirlines ,result.legConnections,COUNT(seg.airresponsekey )-1,0
	,airOneSuperSaverBase, airOneEconSaverBase,airOneFirstFlexBase,airOneEconFlexBase, airOneSuperSaverTax, airOneEconSaverTax,airOneFirstFlexTax,  airOneEconFlexTax
	FROM   
	#AllOneWayResponses result  INNER JOIN   
	AirResponse resp  WITH (NOLOCK)  ON resp.airResponseKey = result.airOneResponsekey   
	INNER JOIN  
	AirSegments seg WITH(NOLOCK) ON result .airOneResponsekey = seg.airResponseKey   
	WHERE airLegNumber = @airRequestTypeKey and
	resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable  
	GROUP BY seg.airResponseKey,result.airOnePriceBaseDisplay ,gdssourcekey  ,result .airOnePriceTaxDisplay , result.airsubRequestkey ,otherlegprice ,result.cabinclass ,otherlegtax,result.airOnePriceBaseSenior, result.airOnePriceTaxSenior, result.airOnePriceBaseChildren,result.airOnePriceTaxChildren, result.airOnePriceBaseInfant,result.airOnePriceTaxInfant,result.airOnePriceBaseYouth, result.airOnePriceTaxYouth, result.airOnePriceBaseTotal,result.airOnePriceTaxTotal, result.airOnePriceBaseDisplay,result.airOnePriceTaxDisplay,result.noOfOtherlegairlines ,result.otherlegAirlines ,legConnections
	,airOneSuperSaverBase, airOneEconSaverBase,airOneFirstFlexBase,airOneEconFlexBase, airOneSuperSaverTax, airOneEconSaverTax,airOneFirstFlexTax,  airOneEconFlexTax
	--Removed as restricted one way call from front end for Same Day Return for Domestic Trip
	--  having MIN(airSegmentDepartureDate ) > ISNULL ( DATEADD (HH,1, @selectedDate ) , DATEADD(D, -1,GETDATE() ))  
	)  
	/****Logic for lower connection point display Rick's recommendation point#9 ******/
	UPDATE  N SET takeoffdate = airSegmentDepartureDate  , startingFlightAirline = airSegmentMarketingAirlineCode , startingFlightNumber = airSegmentFlightNumber   FROM #normalizedResultSet N inner join
	AirSegments seg  WITH (NOLOCK) ON N.airresponsekey = seg.airResponseKey  and seg.airLegNumber =@airRequestTypeKey and segmentOrder = 1 

	UPDATE  N SET landingdate  = airSegmentArrivalDate ,lastFlightAirline = airSegmentMarketingAirlineCode , lastFlightNumber = airSegmentFlightNumber    FROM #normalizedResultSet N inner join
	AirSegments seg  WITH (NOLOCK) ON N.airresponsekey = seg.airResponseKey  and seg.airLegNumber =@airRequestTypeKey and segmentOrder = (n.actualNoOFStops + 1) 
		
	UPDATE  N SET legDurationInMinutes = DATEDIFF( MINUTE , DATEADD( MINUTE, (@departureOffset*-1),N.takeoffdate ), DATEADD( MINUTE, (@arrivalOffset*-1), N.landingdate) ),
	legDuration  = DATEDIFF( HOUR , DATEADD( HOUR, (@departureOffset*-1),N.takeoffdate ), DATEADD( HOUR, (@arrivalOffset*-1), N.landingdate) )
	FROM #normalizedResultSet N

	--UPDATE   #normalizedResultSet 
	--SET @rowIndex = RowNumber = @rowIndex + 1 

	;WITH tbl AS (
	SELECT *, ROW_NUMBER() OVER(ORDER BY legDurationInMinutes) AS RowNo FROM #normalizedResultSet
	)
	UPDATE #normalizedResultSet SET RowNumber = RowNo 
	FROM #normalizedResultSet N inner join tbl on n.airresponsekey = tbl.airresponsekey 

	UPDATE N SET isLowestJourneyTime = 1 FROM #normalizedResultSet N  WHERE noOFSTOPs = 0  

	SELECT * INTO #tmpDeparturesLowest 
	FROM 
	(SELECT  MIN(rowNumber) minRowIndex ,MAX(rowNumber) maxRowIndex, MIN(N.legDurationInMinutes) durationInMinutes,MAX(N.legDurationInMinutes) maximumDuration,COUNT(*) totalRecords ,noOFSTOPs ,startingFlightAirline ,startingFlightNumber,( airPriceBase  + airpriceTax ) Price  FROM #normalizedResultSet N 
	GROUP BY noOFSTOPs ,startingFlightAirline ,startingFlightNumber , ( airPriceBase  + airpriceTax )--,N.legConnections
	) T 

	SELECT * INTO #tmpArrivalLowest 
	FROM 
	(
	SELECT MIN(rowNumber) minRowIndex ,MAX(rowNumber) maxRowIndex, MIN(N1.legDurationInMinutes) durationInMinutes,MAX(N1.legDurationInMinutes) maximumDuration,COUNT(*) totalRecords ,n1.noOFSTOPs ,n1.lastFlightAirline ,n1.lastFlightNumber ,( airPriceBase  + airpriceTax ) Price 
	FROM #normalizedResultSet N1 
	INNER JOIN #tmpDeparturesLowest T1 ON N1.rowNumber = T1.minRowIndex 
	GROUP BY n1.noOFSTOPs ,n1.lastFlightAirline ,n1.lastFlightNumber  , ( airPriceBase  + airpriceTax )--,N1.legConnections
	)T

	UPDATE  N1 SET isLowestJourneyTime = 1 FROM #normalizedResultSet N1 
	INNER JOIN #tmpArrivalLowest arrival 
	ON N1.rowNumber = arrival.minRowIndex

	UPDATE #normalizedResultSet SET isSameAirlinesItin = 1 WHERE (airlineCode = otherlegAirlines ) 
	and airlineCode <> 'Multiple Airlines' AND otherlegAirlines <> 'Multiple Airlines'


	UPDATE #normalizedResultSet SET isSameAirlinesItin = 1 WHERE  airlineCode = 'Multiple Airlines' 

	IF ( @airRequestType = 1) 
	BEGIN 
	UPDATE #normalizedResultSet SET isSameAirlinesItin = 1
	END

	/****Logic for lower connection point display Rick's recommendation point#9 END HERE ******/

	INSERT into #airResponseResultset (airSegmentKey , airResponseKey,airLegNumber,airSegmentMarketingAirlineCode,airSegmentFlightNumber,airSegmentDuration, airSegmentEquipment,airSegmentMiles,airSegmentDepartureDate,airSegmentArrivalDate ,airSegmentDepartureAirport,
	airSegmentArrivalAirport,airPrice,MarketingAirlineName,NoOfSTOPs ,actualTakeOffDateForLeg,actualLandingDateForLeg ,airSegmentOperatingAirlineCode , airSegmentResBookDesigCode,noofAirlines ,airlineName , gdsSourceKey ,airPriceTax ,airRequestKey ,
	airsegmentDepartureOffset,airSegmentArrivalOffset ,airSegmentSeatRemaining,priceClassCommentsSuperSaver,priceClassCommentsEconSaver ,priceClassCommentsFirstFlex ,priceClassCommentsCorporate,priceClassCommentsEconFlex,priceClassCommentsEconUpgrade, 
	airSuperSaverPrice ,airEconSaverPrice ,airFirstFlexPrice ,airCorporatePrice,airEconFlexPrice,airEconUpgradePrice ,airClassSuperSaver,airClassEconSaver,airClassFirstFlex,airClassCorporate,airClassEconFlex,airClassEconUpgrade,airSuperSaverSeatRemaining,
	airEconSaverSeatRemaining,airFirstFlexSeatRemaining,airCorporateSeatRemaining,airEconFlexSeatRemaining,airEconUpgradeSeatRemaining, airPriceClassSELECTed,otherLegPrice ,isRefundable ,isBrandedFare,cabinClass ,fareType ,segmentOrder ,airsegmentCabin,totalCost,
	airSegmentOperatingFlightNumber,otherlegtax,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant, airPriceTaxInfant,airPriceBaseYouth, airPriceTaxYouth,
	AirPriceBaseTotal,AirPriceTaxTotal,airPriceBaseDisplay, airPriceTaxDisplay,airSegmentOperatingAirlineCompanyShortName,otherlegAirlines ,noOfOtherlegairlines,legConnections ,legDuration,actualNoOFStops ,isSameAirlinesItin ,isLowestJourneyTime
	,airSuperSaverTax,airEconSaverTax,airFirstFlexTax,airCorporateTax,airEconFlexTax,airEconUpgradeTax)  
	SELECT seg.airSegmentKey, seg.airResponseKey, seg.airLegNumber, seg. airSegmentMarketingAirlineCode ,seg. airSegmentFlightNumber, seg.airSegmentDuration , (case when AircraftsLookup.AircraftName IS NULL then airSegmentEquipment else AircraftsLookup.AircraftName end) as airSegmentEquipment , seg.airSegmentMiles , seg.airSegmentDepartureDate ,  
	seg.airSegmentArrivalDate , seg.airSegmentDepartureAirport , seg.airSegmentArrivalAirport ,normalized .airPriceBase AS airPriceBase , airVendor.ShortName AS MarketingAirlineName ,noOFSTOPs  ,  takeoffdate  , landingdate ,airSegmentOperatingAirlineCode ,
	seg.airSegmentResBookDesigCode,noOfAirlines ,normalized .airlineCode ,ISNULL(normalized.gdssourcekey,2) ,normalized.airpriceTax  ,airsubrequetkey ,airsegmentDepartureOffset,airSegmentArrivalOffset ,airSegmentSeatRemaining,priceClassCommentsSuperSaver , 
	priceClassCommentsEconSaver,priceClassCommentsFirstFlex ,priceClassCommentsCorporate,priceClassCommentsEconFlex,priceClassCommentsEconUpgrade,normalized.airSuperSaverPrice ,normalized.airEconSaverPrice ,normalized.airFirstFlexPrice ,airCorporatePrice ,normalized.airEconFlexPrice,airEconUpgradePrice,  
	airClassSuperSaver,airClassEconSaver,airClassFirstFlex,airClassCorporate,airClassEconFlex,airClassEconUpgrade,airSuperSaverSeatRemaining,airEconSaverSeatRemaining,airFirstFlexSeatRemaining,airCorporateSeatRemaining,airEconFlexSeatRemaining,airEconUpgradeSeatRemaining,  
	airPriceClassSELECTed ,otherlegprice ,refundable ,isBrandedFare ,normalized. cabinClass ,resp.faretype,seg.segmentOrder ,seg.airsegmentCabin,(isnull(normalized .airPriceBase,0)+ isnull(normalized.airpriceTax,0)),seg.airSegmentOperatingFlightNumber,otherlegtax ,
	normalized.airPriceBaseSenior,normalized.airPriceTaxSenior,normalized.airPriceBaseChildren,normalized.airPriceTaxChildren,normalized.airPriceBaseInfant, normalized.airPriceTaxInfant,normalized.airPriceBaseYouth, normalized.airPriceTaxYouth,normalized.AirPriceBaseTotal,normalized.AirPriceTaxTotal,normalized.airPriceBaseDisplay, normalized.airPriceTaxDisplay,airSegmentOperatingAirlineCompanyShortName  ,normalized.otherlegAirlines ,normalized.noOfOtherlegairlines ,legconnections,DATEDIFF( HOUR , DATEADD( HOUR, (@departureOffset*-1),normalized.takeoffdate ), DATEADD( HOUR, (@arrivalOffset*-1), normalized.landingdate) ) ,actualNoOFStops ,isSameAirlinesItin,isLowestJourneyTime
	,normalized.airSuperSaverTax,normalized.airEconSaverTax,normalized.airFirstFlexTax,airCorporateTax,normalized.airEconFlexTax,airEconUpgradetax
	FROM AirSegments seg  WITH (NOLOCK)   
	INNER JOIN #normalizedResultSet normalized ON seg.airresponsekey = normalized .airresponsekey   
	INNER JOIN AirResponse resp WITH (NOLOCK) ON seg .airresponsekey = resp.airResponseKey   
	INNER JOIN @noSTOPs nSTOP ON normalized .noOFSTOPs = nSTOP .sTOPs   
	INNER JOIN  AirVendorLookup airVendor WITH (NOLOCK)   ON seg.airSegmentMarketingAirlineCode = airVendor  .AirlineCode    
	LEFT OUTER JOIN AircraftsLookup WITH(NOLOCK) on (seg.airSegmentEquipment = AircraftsLookup.SubTypeCode AND AircraftsLookup.SubTypeCode = AircraftsLookup.AircraftCode)  
	WHERE normalized.airPriceBase  <=    @price    and airLegNumber = @airRequestTypeKey 
	and resp.gdsSourceKey = 9 AND resp.refundable = @ForRefundable 
	AND ( takeoffdate    BETWEEN @minTakeOffDate AND @maxTakeOffDate    )  
	AND (  landingdate  BETWEEN @minLandingDate AND @maxLandingDate  )  
 


	CREATE TABLE #pagingResultSet     
	(  
	rowNum int IDENTITY(1,1) NOT NULL,     
	airResponseKey uniqueidentifier  ,  
	airlineName varchar(100),   
	airPrice decimal (12,2) ,   
	actualTakeOffDateForLeg datetime,
	isSmartFare bit default 0   
	)   

	IF @sortField <> ''  
	BEGIN   
	INSERT into #pagingResultSet (airResponseKey,airPrice ,actualTakeOffDateForLeg ,airlineName    )  

	SELECT    air.airResponseKey ,( case When @isTotalPriceSort = 0  then MIN( airPrice)  else MIN(totalCost ) END) ,MIN(actualTakeOffDateForLeg) , MIN(MarketingAirlineName)  FROM #airResponseResultset air   
	INNER JOIN #normalizedResultSet normalized on air.airresponsekey = normalized .airresponsekey   
	INNER  JOIN @tmpAirline airline on (normalized .airlineCode  = airline.airLineCode   )   
	INNER JOIN @noSTOPs nSTOP ON normalized .noOFSTOPs = nSTOP .sTOPs   
	AND ( takeoffdate    BETWEEN @minTakeOffDate AND @maxTakeOffDate    )  
	AND (  landingdate  BETWEEN @minLandingDate AND @maxLandingDate  )  


	GROUP BY air.airResponseKey,airlineName ,normalized.legDurationInMinutes   order by   
	CASE WHEN @sortField  = 'Price'      THEN ( case When @isTotalPriceSort = 0  then ROUND(MIN( airPrice),0)  else ROUND(MIN(totalCost ),0) END  ) END  ,    
	CASE WHEN @sortField  = 'Airline' THEN  MIN(MarketingAirlineName)         END   ,   
	CASE WHEN @sortField  ='Departure' THEN MIN( actualTakeOffDateForLeg) END   ,  
	--CASE WHEN @sortField ='Duration' THEN MIN(duration) END ,  
	CASE WHEN @sortField  ='' THEN ROUND(MIN( airPrice),0)  END   ,
	normalized.legDurationInMinutes   

	END   
	ELSE   
	BEGIN   
	INSERT into #pagingResultSet (airResponseKey,airPrice ,actualTakeOffDateForLeg ,airlineName    )  
	SELECT    air.airResponseKey ,( case When @isTotalPriceSort = 0  then MIN( airPrice)  else MIN(totalCost ) END) ,MIN(actualTakeOffDateForLeg) , MIN(MarketingAirlineName)  FROM #airResponseResultset air   
	INNER JOIN #normalizedResultSet normalized ON air.airresponsekey = normalized .airresponsekey   
	INNER  JOIN @tmpAirline airline ON (normalized .airlineCode  = airline.airLineCode   )   
	GROUP BY air.airResponseKey,airlineName ,normalized.legDurationInMinutes  order by 
	( case When @isTotalPriceSort = 0  then ROUND(MIN( airPrice),0)  else ROUND(MIN(totalCost ),0) END) , normalized.legDurationInMinutes  ,MIN(MarketingAirlineName) , min(normalized.noOFSTOPs ),MIN( actualTakeOffDateForLeg) ,MIN( actualLandingDateForLeg )  

	END   


	--UPDATE P SET  isLowestJourneyTime = 1 FROM #pagingResultSet P inner join #normalizedResultSet N ON p.airResponseKey =n.airresponsekey   WHERE noOFSTOPs = 0  

	--UPDATE  P1 SET isLowestJourneyTime = 1 FROM #pagingResultSet P1 
	--INNER JOIN 
	--(
	--SELECT  MIN(P.rowNum) minRowIndex ,MAX(P.rowNum) maxRowIndex, MIN(N.legDurationInMinutes) durationInMinutes,MAX(N.legDurationInMinutes) maximumDuration,COUNT(*) totalRecords ,noOFSTOPs ,startingFlightAirline ,startingFlightNumber,( airPriceBaseTotal + airPriceTaxTotal ) Price  
	--FROM #pagingResultSet P inner join #normalizedResultSet N ON p.airResponseKey =n.airresponsekey 
	--GROUP BY noOFSTOPs ,startingFlightAirline ,startingFlightNumber , ( airPriceBaseTotal + airPriceTaxTotal )
	--)   DERIVED 
	--ON P1.rowNum = DERIVED.minRowIndex



	DECLARE @firstRoundTripResponse as int 
	DECLARE @firstRoundTripResponsePrice as decimal (12,2) 

	/****Old smart fare logic ****/
	--SELECT top 1    @firstRoundTripResponse = rowNum ,@firstRoundTripResponsePrice= ( case When @isTotalPriceSort = 0  then  ( a.airPrice)  else  (totalCost ) END)  from #pagingResultSet P inner join #airResponseResultset A on p.airResponseKey = a.airResponseKey 

	-- where airRequestKey   = @airBundledRequest order by rownum  

	--UPDATE #pagingResultSet SET isSmartFare = 1 where rowNum < @firstRoundTripResponse  and  airPrice < @firstRoundTripResponsePrice 
	/***Old smart fare logic ends here **/

	SELECT top 1    @firstRoundTripResponse = rowNum ,@firstRoundTripResponsePrice= ( case When @isTotalPriceSort = 0  then  ( a.airPrice)  else  (totalCost ) END)  from #pagingResultSet P inner join #airResponseResultset A on p.airResponseKey = a.airResponseKey 

	where noofAirlines =1 and noOfOtherlegairlines  =1 and airSegmentMarketingAirlineCode = otherlegAirlines  order by rownum  

	IF ( @airRequestTypeKey =1 ) 
	BEGIN
	UPDATE P  SET isSmartFare = 1 from #pagingResultSet P inner join #airResponseResultset A on P.airResponseKey = A.airResponseKey  
	where rowNum < @firstRoundTripResponse  and  P.airPrice < @firstRoundTripResponsePrice and noofAirlines =1 and noOfOtherlegairlines = 1 and airSegmentMarketingAirlineCode <> otherlegAirlines 
	END


	----IF ( @superSetAirlines is not null AND @superSetAirlines <> '' )  
	----BEGIN   
	---- Delete P  
	---- FROM #pagingResultSet P  
	---- INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey  

	---- Delete P  
	---- FROM #airResponseResultset P  
	---- INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey  

	---- Delete P  
	---- FROM #normalizedResultSet P  
	---- INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey  
	----END   

	--UPDATE #airResponseResultset 
	--SET airSegmentCabin = C.CabinClass
	--FROM #airResponseResultset A
	--INNER JOIN airSegmentCabin  C ON A.airSegmentMarkettingAirlineCode = C.airVendorCode 
	--AND A.airSegmentOperatingAirlineCode = C.airVendorCode
	--AND A.airSegmentResBookDesigCode  = C.BookingClass 



	/****MAIN RESULTSET FOR LIST ****STARTS HERE *****/  

	SELECT distinct  rowNum,air.*, airSegmentArrivalOffset,departureAirport .CityName AS DepartureAirPortCityName ,departureAirport.StateCode AS DepartureAirportStateCode ,departureAirport .AirportName AS DepartureAirportName , departureAirport.CountryCode AS DepartureAirportCountryCode,   
	arrivalAirport .CItyName AS ArrivalAirPortCityName ,arrivalAirport .StateCode AS ArrivalAirportStateCode , arrivalAirport .AirportName AS ArrivalAirportName ,arrivalAirport .CountryCode  AS ArrivalAirportCountryCode,  
	operatingAirline .ShortName AS OperatingAirlineName  ,isRefundable ,isBrandedFare ,cabinClass,
	CD.CountryName AS DepartureAirportCountryName, CA.CountryName AS ArrivalAirportCountryName,isSmartFare 
	FROM #airResponseResultset air INNER JOIN #pagingResultSet  paging ON air.airResponseKey = paging.airResponseKey  
	LEFT OUTER JOIN AirVendorLookup operatingAirline WITH (NOLOCK)   ON air .airSegmentOperatingAirlineCode = operatingAirline .AirlineCode   
	LEFT OUTER JOIN AirportLookup departureAirport  WITH (NOLOCK)   ON air .airSegmentDepartureAirport = departureAirport .AirportCode   
	LEFT OUTER JOIN AirportLookup arrivalAirport  WITH (NOLOCK)    ON air .airSegmentArrivalAirport = arrivalAirport.AirportCode   
	LEFT OUTER JOIN Vault..CountryLookup CD  WITH (NOLOCK)  ON departureAirport.CountryCode = CD.CountryCode
	LEFT OUTER JOIN Vault..CountryLookup CA WITH (NOLOCK)  ON arrivalAirport.CountryCode = CA.CountryCode
	WHERE ---rowNum > @FirstRec  AND rowNum< @LastRec   AND  
	airLegNumber = CASE WHEN @airRequestTypeKey > -1 THEN @airRequestTypeKey ELSE airLegNumber END    
	order by rowNum ,airlegnumber ,segmentOrder, airSegmentDepartureDate  




	/****MAIN RESULTSET FOR LIST ****END HERE *****/  


	/******MIN -MAX PRICE FOR FILTERS START HERE ***/  
	IF ( @gdssourcekey =9 ) AND @airRequestTypeKey = 2   
	BEGIN  
    	SELECT (case when @isTotalPriceSort= 0 then( MIN (airPrice) ) else  min (totalcost) end ) AS LowestPrice , (case when @isTotalPriceSort= 0 then MAX(airPrice ) else max(totalcost) end ) AS HighestPrice FROM #airResponseResultset  result1  
    	Where result1.totalCost > 0  
	--SELECT MIN (airPrice)  AS LowestPrice ,MAX(airPrice ) AS HighestPrice FROM #airResponseResultset  result1    
	--INNER JOIN #normalizedResultSet normalized ON result1.airresponsekey = normalized .airresponsekey   
	--INNER  JOIN @tmpAirline airline ON (normalized .airlineCode  = airline.airLineCode   )   
	END   
	ELSE   
	BEGIN   


	SELECT (case when @isTotalPriceSort= 0 then( MIN (airPrice) ) else  min (totalcost) end ) AS LowestPrice , (case when @isTotalPriceSort= 0 then MAX(airPrice ) else max(totalcost) end ) AS HighestPrice FROM #airResponseResultset  result1    
	END   
	/******MIN -MAX PRICE FOR FILTERS END HERE ***/  

	/***LANDING & TAKEOFF TIME STARTS HERE *****/  
	SELECT distinct  MIN (actualTakeOffDateForLeg ) AS MinDepartureTakeOffDate,  MAX (actualTakeOffDateForLeg) AS MaxDepartureTakeOffDate, MIN (actualLandingDateForLeg) AS MinDepartureLandingDate,  MAX (actualLandingDateForLeg) AS MaxDepartureLandingDate, 
	cast(CAST(CONVERT(DATE, MAX (actualLandingDateForLeg)) AS VARCHAR(20)) +' '+Replace(Min(Replace(LEFT(CONVERT(TIME(0),actualLandingDateForLeg) ,5),':','.')),'.',':') +':00' as datetime) as MinDepartureLandingTime ,
	cast(CAST(CONVERT(DATE, MAX (actualLandingDateForLeg)) AS VARCHAR(20)) +' '+Replace(Max(Replace(LEFT(CONVERT(TIME(0),actualLandingDateForLeg) ,5),':','.')),'.',':') +':00' as datetime) as MaxDepartureLandingTime
	
  FROM #airResponseResultset    
	/***LANDING & TAKEOFF TIME ENDS HERE *****/  

	/* STOPs for Slider END */  
	SELECT distinct NoOfSTOPs AS NoOfSTOPs  FROM #airResponseResultset   
	/* STOPs for Slider END*/  

	/*****TOTAL RECORD FOUND *****/  
	SELECT COUNT(*) AS [TotalCount] FROM #pagingResultSet   
	/*****TOTAL RECORD FOUND *****/  

	IF @airLines <> '' and @isIgnoreAirlineFilter = 1    
	BEGIN  
	delete from @tmpAirline    
	INSERT into @tmpAirline(airlineCode)    SELECT * FROM vault.dbo.ufn_CSVToTable (@airLines )    

	END  

	/**** MATRIX SUMMARY STARTES HERE *****/  
	IF ( SELECT COUNT (*) FROM @tmpAirline) > 1    
	BEGIN   

	SELECT (case when @isTotalPriceSort = 0 then MIN(airPrice ) else min(totalcost) end ) AS LowestPrice ,ISNULL (ShortName,'Multiple Airlines')AS MarketingAirlineName ,airlineName AS airSegmentMarketingAirlineCode 
	From #airResponseResultset air  
	INNER JOIN #normalizedResultSet n ON air.airResponseKey = n.airresponsekey and air.totalCost > 0  
	INNER JOIN @tmpAirline tmp ON n.airlineCode = tmp.airLineCode   
	LEFT OUTER JOIN AirVendorLookup vendor WITH (NOLOCK) ON air.airlineName = vendor .AirlineCode   
	GROUP BY airlineName ,ShortName   
	END   
	ELSE   
	BEGIN    
	IF ( @gdssourcekey =9 ) AND @airRequestTypeKey = 2   
	BEGIN  

	SELECT (case when @isTotalPriceSort = 0 then MIN(airPrice ) else min(totalcost) end )AS LowestPrice ,ISNULL (ShortName,'Multiple Airlines')AS MarketingAirlineName ,airlineName AS airSegmentMarketingAirlineCode 
	From #airResponseResultset air  
	INNER JOIN #normalizedResultSet n ON air.airResponseKey = n.airresponsekey AND air.totalCost > 0  
	INNER JOIN @tmpAirline tmp ON n.airlineCode = tmp.airLineCode   
	LEFT OUTER JOIN AirVendorLookup vendor WITH (NOLOCK) ON air.airlineName = vendor.AirlineCode   
	GROUP BY airlineName ,ShortName   

	END   
	ELSE   
	BEGIN    

	SELECT (case when @isTotalPriceSort = 0 then MIN(airPrice ) else min(totalcost) end ) AS LowestPrice ,ISNULL (ShortName,'Multiple Airlines')AS MarketingAirlineName ,airlineName AS airSegmentMarketingAirlineCode 
	From #airResponseResultset air  
	INNER JOIN #normalizedResultSet n ON air.airResponseKey = n.airresponsekey   and air.totalCost>0
	LEFT OUTER JOIN AirVendorLookup vendor WITH (NOLOCK) ON air.airlineName = vendor .AirlineCode   
	GROUP BY airlineName ,ShortName   
	END   
	END   

	DECLARE @markettingAirline AS varchar(100)   
	DECLARE @noOFDrillDownCount as int    
	IF @airRequestTypeKey > 1   
	BEGIN   

	IF (SELECT count(distinct (airSegmentMarketingAirlineCode ))  FROM AirSegments seg  WITH (NOLOCK) INNER JOIN @SELECTedResponse SELECTed ON seg.airResponseKey = SELECTed .responsekey ) = 1   
	BEGIN  

	IF   (SELECT COUNT(*) FROM @tmpAirline) > 1   
	BEGIN  
	SET @markettingAirline  =(SELECT   distinct (airSegmentMarketingAirlineCode )   FROM AirSegments seg WITH (NOLOCK)   INNER JOIN @SELECTedResponse SELECTed ON seg.airResponseKey = SELECTed .responsekey )    

	END  
	ELSE   
	BEGIN  
	SET @markettingAirline= @airLines       
	END  

	END   
	ELSE  
	BEGIN   


	IF ( SELECT airRequestTypeKey  FROM AirRequest WITH (NOLOCK) WHERE airRequestKey = @airRequestKey ) >= 2   
	BEGIN  
	IF (SELECT count(distinct (airSegmentMarketingAirlineCode ))  FROM AirSegments seg WITH (NOLOCK)  WHERE airResponseKey = @SELECTedResponseKey   ) = 1   
	BEGIN  
	IF   (SELECT COUNT(*) FROM @tmpAirline) > 1   
	BEGIN  

	SET @markettingAirline  =(SELECT   distinct (airSegmentMarketingAirlineCode )   FROM AirSegments seg WITH (NOLOCK)   WHERE airResponseKey = @SELECTedResponseKey  )            
	END  
	ELSE   
	BEGIN  

	SET @markettingAirline= @airLines          
	END  
	END  
	ELSE IF  (@airLines <> '') -- AND (select COUNT(*) from @tmpAirline ) = 1)  
	BEGIN   

	SET @markettingAirline= @airLines          
	END  

	END   

	END   
	IF  @markettingAirline =''   
	BEGIN   

	SET @markettingAirline='Multiple Airlines'  

	END   

	END   
	ELSE   
	BEGIN  

	IF   (SELECT COUNT(*) FROM @tmpAirline) = 1   
	BEGIN  
	SET @markettingAirline = @airlines   
	END   
	ELSE   
	BEGIN   
	SET @markettingAirline = ''   
	END   
	END   

	IF @markettingAirline <> 'Multiple Airlines' AND @markettingAirline <> ''   
	BEGIN   


	SET @noOFDrillDownCount = ( SELECT top 1 COUNT(*)   FROM #airResponseResultset      air  INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE   air.airlineName = @markettingAirline  )  
	END   
	ELSE   
	BEGIN   

	SET @noOFDrillDownCount = (SELECT top 1 COUNT(*)  FROM #airResponseResultset      air  INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE   air.airlineName = 'Multiple Airlines')  
	END   

	IF ( @drillDownLevel = 1 )   
	BEGIN   
	IF ( @noOFDrillDownCount = 0 ) --WHEN NO RESULT FOUND FOR LEVEL 1   
	BEGIN   
	SET  @drillDownLevel =0  
	END   
	ELSE   
	BEGIN   
	SET @drillDownLevel =1  
	END   
	END   

	SELECT @drillDownLevel    
	IF ( @drillDownLevel =0 )   
	BEGIN  
	IF ( @matrixview = 0 AND @airRequestTypeKey = 1 )    
	BEGIN  
	DECLARE @seconSubRequestKey AS int   
	SET @seconSubRequestKey =( SELECT airSubRequestKey  FROM AirSubRequest  WITH (NOLOCK)  WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex = 2 )  

	DECLARE @tmpSecondLowestPrice AS table   
	(  
	legPrice float ,  
	airline varchar(100)   
	)  
	INSERT @tmpSecondLowestPrice (legPrice ,airline   )  
	SELECT (case when @isTotalPriceSort = 0 then MIN(airPriceBAse ) else min(airPriceBase+ airpriceTax) end )  AS secondLegPrice,airSegmentMarketingAirlineCode FROM AirResponse ar   
	INNER JOIN   
	(  
	SELECT A.* FROM AirSegments A WITH (NOLOCK)
	Except   
	SELECT A.* FROM AirSegments A WITH (NOLOCK)INNER JOIN @tempResponseToRemove T ON A.airResponseKey = T.airresponsekey  
	) Tmp  
	ON ar.airResponseKey = Tmp.airResponseKey   
	WHERE airSubRequestKey = @seconSubRequestKey GROUP BY  airSegmentMarketingAirlineCode  

				 if ( select COUNT (*) from @tmpSecondLowestPrice ) = 0   
				 begin  
				 INSERT @tmpSecondLowestPrice (legPrice ,airline   )  
				 select 0 , t.airLineCode  from @tmpAirline  t  
				 end  
	               
	DECLARE @thirdSubRequestKey AS int   
	SET @thirdSubRequestKey =( SELECT airSubRequestKey  FROM AirSubRequest  WITH (NOLOCK)  WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex =3 )  

	--DECLARE @tmpThirdLowestPrice AS table   
	--(  
	--thirdlegPrice float ,  
	--airline varchar(100)   
	--)  
	--INSERT @tmpThirdLowestPrice (thirdlegPrice ,airline   )  
	----SELECT (case when @isTotalPriceSort = 0 then MIN(airPriceBAse ) else min(airPriceBase+ airpriceTax) end ) AS secondLegPrice,airSegmentMarketingAirlineCode FROM AirResponse ar  
	----INNER JOIN AirSegments aseg ON ar.airResponseKey = aseg.airResponseKey   
	----WHERE airSubRequestKey = @thirdSubRequestKey GROUP BY  airSegmentMarketingAirlineCode   

	--select    MIN ( airpricebase )  ,airline    
	--from   
	--(select ( case when @isTotalPriceSort = 0 then  MIN(airPriceBase ) else  MIN ( airPriceBase + airPriceTax )end ) as airpriceBAse ,   MIN( airSegmentMarketingAirlineCode ) airline   
	--  From AirResponse r WITH (NOLOCK) 
	--inner join AirSegments s  WITH (NOLOCK) on r.airResponseKey =s.airResponseKey where airSubRequestKey = @thirdSubRequestKey group by s.airResponseKey    
	--having  COUNT(distinct airSegmentMarketingAirlineCode ) = 1) as t   
	--group by airline   


	--                   if ( select COUNT (*) from @tmpThirdLowestPrice ) = 0   
	--                   begin  
	--                   INSERT @tmpThirdLowestPrice (thirdlegPrice ,airline   )  
	--                   select 0 , t.airLineCode  from @tmpAirline  t  
	--                   end  
	               
	--DECLARE @fourthSubRequestKey AS int   
	--SET @fourthSubRequestKey =( SELECT airSubRequestKey  FROM AirSubRequest  WITH(NOLOCK)  WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex =4 )  

	--DECLARE @tmpFourthLowestPrice AS table   
	--(  
	--fourthlegPrice float ,  
	--airline varchar(100)   
	--)  
	--INSERT @tmpFourthLowestPrice (fourthlegPrice ,airline   )  
	----SELECT (case when @isTotalPriceSort = 0 then MIN(airPriceBAse ) else min(airPriceBAse+ airpriceTax) end ) AS secondLegPrice,airSegmentMarketingAirlineCode FROM AirResponse ar  
	----INNER JOIN AirSegments aseg ON ar.airResponseKey = aseg.airResponseKey   
	----WHERE airSubRequestKey = @fourthSubRequestKey GROUP BY  airSegmentMarketingAirlineCode   
	               
	--select    MIN ( airpricebase )  ,airline    
	--from   
	--(select ( case when @isTotalPriceSort = 0 then  MIN(airPriceBase ) else  MIN ( airPriceBase + airPriceTax )end ) as airpriceBAse ,   MIN( airSegmentMarketingAirlineCode ) airline   
	--  From AirResponse r WITH (NOLOCK)  
	--inner join AirSegments s  WITH (NOLOCK) on r.airResponseKey =s.airResponseKey where airSubRequestKey = @fourthSubRequestKey group by s.airResponseKey    
	--having  COUNT(distinct airSegmentMarketingAirlineCode ) = 1) as t   
	--group by airline   


	--                   if ( select COUNT (*) from @tmpFourthLowestPrice ) = 0   
	--                   begin  
	--                   INSERT @tmpFourthLowestPrice (fourthlegPrice  ,airline   )  
	--                   select 0 , t.airLineCode  from @tmpAirline  t  
	--                   end  

	               
	--DECLARE @fifthSubRequestKey AS int   
	--SET @fifthSubRequestKey =( SELECT airSubRequestKey  FROM AirSubRequest WITH(NOLOCK) WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex =4 )  

	--DECLARE @tmpFifthLowestPrice AS table   
	--(  
	--fifthlegPrice float ,  
	--airline varchar(100)   
	--)  
	--INSERT @tmpFifthLowestPrice (fifthlegPrice ,airline   )  

	--select    MIN ( airpricebase )  ,airline    
	--from   
	--(select ( case when @isTotalPriceSort = 0 then  MIN(airPriceBase ) else  MIN ( airPriceBase + airPriceTax )end ) as airpriceBAse ,   MIN( airSegmentMarketingAirlineCode ) airline   
	--  From AirResponse   r    WITH (NOLOCK) 
	--inner join AirSegments s  WITH (NOLOCK) on r.airResponseKey =s.airResponseKey where airSubRequestKey = @fifthSubRequestKey group by s.airResponseKey    
	--having  COUNT(distinct airSegmentMarketingAirlineCode ) = 1) as t   
	--group by airline   

	--  if ( select COUNT (*) from @tmpFifthLowestPrice ) = 0   
	--                   begin  
	--                   INSERT @tmpFifthLowestPrice (fifthlegPrice  ,airline   )  
	--                   select 0 , t.airLineCode  from @tmpAirline  t  
	--                   end  

	IF(@superSetAirlines != '' AND @superSetAirlines is not null)  
	Begin  

	SELECT min( summary1 .LowestPrice) AS LowestPRice, summary1.airSegmentMarketingAirlineCode AS airSegmentMarketingAirlineCode ,NoOFSegments ,ISNULL(airvend .ShortName,airSegmentMarketingAirlineCode) AS marketingAirlineName,sum(summary1.noOFFLights) AS noOFFLights ,convert(bit,1) as isSameAirlinesItin  FROM   
	(  
	SELECT min ((case when @isTotalPriceSort = 0 then r.airPriceBase else (r.airpricebase + r.airPricetax) end )
	+ISNULL( legPrice,0) --+ ISNULL (thirdlegPrice ,0)  + ISNULL (fourthlegPrice ,0) + ISNULL (fifthlegPrice ,0)   

	) AS LowestPrice  
	,t.noOFSTOPs AS NoOFSegments,t.airlineCode  AS airSegmentMarketingAirlineCode,COUNT(distinct r.airResponseKey ) noOFFLights    
	From   
	#normalizedResultSet   t INNER JOIN   
	(  
	SELECT A.* FROM AirResponse A  WITH (NOLOCK)     
	Except   
	SELECT A.* FROM AirResponse A  WITH (NOLOCK)  INNER JOIN @tempResponseToRemove T ON A.airResponseKey = T.airresponsekey) r   
	ON t.airresponsekey = r.airResponseKey   
	INNER JOIN @tmpAirline air ON t.airlineCode = air.airLineCode   
	InNER JOIN @tmpSecondLowestPrice s ON s.airline = t.airlineCode    
	--InNER   JOIN  @tmpThirdLowestPrice third ON t.airlineCode = third.airline   
	--InNER   JOIN @tmpFourthLowestPrice fourth ON t.airlineCode = fourth .airline   
	--InNER   JOIN @tmpFifthLowestPrice fifth ON t.airlineCode = fifth .airline   
	WHERE t.airsubrequetkey  = @airSubRequestKey AND t.airlineCode <> 'Multiple Airlines' GROUP BY t.airlineCode ,t.noOFSTOPs   
	union   
	SELECT (case when @isTotalPriceSort = 0  Then MIN(t.airPriceBase ) else   MIN(t.airPriceBase +t.airPriceTax) end), t.noOFSTOPs,t.airlineCode,COUNT(distinct t.airResponseKey ) noOFFLights       
	From #normalizedResultSet   t    INNER JOIN   
	(SELECT A.* FROM AirResponse A  WITH (NOLOCK) 
	Except   
	SELECT A.* FROM AirResponse A  WITH (NOLOCK)  INNER JOIN @tempResponseToRemove T ON A.airResponseKey = T.airresponsekey) r   
	ON t.airresponsekey = r.airResponseKey   
	WHERE t.airsubrequetkey  <> @airSubRequestKey  AND t.airlineCode <> 'Multiple Airlines'  GROUP BY t.airlineCode ,t.noOFSTOPs   
	union   
	SELECT (case when @isTotalPriceSort = 0  Then MIN( airPriceBase ) else   MIN( airPriceBase + airPriceTax) end), t.noOFSTOPs,'all',COUNT(distinct t.airResponseKey ) noOFFLights     From #normalizedResultSet   t    
	INNER JOIN @tmpAirline air ON air.airLineCode = t.airlineCode  
	GROUP BY  t.noOFSTOPs   
	union   
	SELECT (case when @isTotalPriceSort = 0  Then MIN( m.airPriceBase  ) else   MIN( m.airPriceBase + m.airPriceTax) end)     AS LowestPrice,m.noOFSTOPs AS NoOFSegments,m.airlineCode  AS airSegmentMarketingAirlineCode ,COUNT(distinct m.airResponseKey ) noOFFLights  From #normalizedResultSet   m INNER JOIN AirResponse r  WITH (NOLOCK) 
	ON m.airresponsekey =r.airResponseKey  WHERE m.airlineCode ='Multiple Airlines'   GROUP BY m.airlineCode ,noOFSTOPs   
	) summary1   
	LEFT OUTER  JOIN AirVendorLookup airvend  WITH (NOLOCK)  ON summary1 .airSegmentMarketingAirlineCode = airvend .AirlineCode   
	GROUP BY airvend .ShortName,airSegmentMarketingAirlineCode ,NoOFSegments   
	END  
	ELSE  
	BEGIN  

	SELECT min( summary1 .LowestPrice) AS LowestPRice, summary1.airSegmentMarketingAirlineCode AS airSegmentMarketingAirlineCode ,NoOFSegments ,ISNULL(airvend .ShortName,airSegmentMarketingAirlineCode) AS marketingAirlineName,sum(summary1.noOFFLights) AS noOFFLights ,convert(bit,1) as isSameAirlinesItin  FROM   
	(  
	SELECT min ((case when @isTotalPriceSort = 0 then r.airPriceBase else (r.airpricebase + r.airPricetax) end )   
	+ISNULL( legPrice,0) 
	-- + ISNULL (thirdlegPrice ,0) + ISNULL (fourthlegPrice ,0) + ISNULL (fifthlegPrice ,0)   
	) AS LowestPrice  
	,t.noOFSTOPs AS NoOFSegments,t.airlineCode  AS airSegmentMarketingAirlineCode,COUNT(distinct r.airResponseKey ) noOFFLights   From #normalizedResultSet   t INNER JOIN AirResponse r ON t.airresponsekey =r.airResponseKey   
	INNER JOIN @tmpAirline air ON t.airlineCode = air.airLineCode   
	InNER JOIN @tmpSecondLowestPrice s ON s.airline = t.airlineCode    
	--InNER JOIN @tmpThirdLowestPrice third ON t.airlineCode = third.airline   
	--InNER JOIN @tmpFourthLowestPrice fourth ON t.airlineCode = fourth .airline   
	--InNER JOIN @tmpFifthLowestPrice fifth ON t.airlineCode = fifth .airline   
	WHERE t.airsubrequetkey  = @airSubRequestKey AND t.airlineCode <> 'Multiple Airlines' GROUP BY t.airlineCode ,t.noOFSTOPs   
	union   
	SELECT (case when @isTotalPriceSort = 0  Then MIN(t.airPriceBase ) else   MIN(t.airPriceBase +t.airPriceTax) end), t.noOFSTOPs,t.airlineCode,COUNT(distinct t.airResponseKey ) noOFFLights     From #normalizedResultSet   t    WHERE t.airsubrequetkey <> @airSubRequestKey  
	AND t.airlineCode <> 'Multiple Airlines'  GROUP BY t.airlineCode ,t.noOFSTOPs   
	union   
	SELECT (case when @isTotalPriceSort = 0  Then MIN(t.airPriceBase ) else   MIN(t.airPriceBase +t.airPriceTax) end), t.noOFSTOPs,'all',COUNT(distinct t.airResponseKey ) noOFFLights     From #normalizedResultSet   t    
	INNER JOIN @tmpAirline air ON air.airLineCode = t.airlineCode  
	GROUP BY  t.noOFSTOPs   
	union   
	SELECT (case when @isTotalPriceSort = 0  Then MIN(m.airPriceBase ) else   MIN(m.airPriceBase +m.airPriceTax) end)     AS LowestPrice,m.noOFSTOPs AS NoOFSegments,m.airlineCode  AS airSegmentMarketingAirlineCode ,COUNT(distinct m.airResponseKey ) noOFFLights  
	From #normalizedResultSet   m INNER JOIN AirResponse r  WITH (NOLOCK)ON m.airresponsekey =r.airResponseKey  WHERE m.airlineCode ='Multiple Airlines'   GROUP BY m.airlineCode ,noOFSTOPs   
	)   
	summary1   
	LEFT OUTER  JOIN AirVendorLookup airvend  WITH (NOLOCK)  ON summary1 .airSegmentMarketingAirlineCode = airvend .AirlineCode   
	GROUP BY airvend .ShortName,airSegmentMarketingAirlineCode ,NoOFSegments   
	END  
	END   

	ELSE  
	BEGIN  

	DECLARE @MatrixResult AS TABLE
	(
	LowestPrice float,
	NoOFSegments int,
	airSegmentMarketingAirlineCode varchar(50),
	noOFFLights INT,
	MarketingAirlineName varchar(50),
	isSameAirlinesItin bit default 0 
	)

	INSERT INTO @MatrixResult (LowestPrice,NoOFSegments,airSegmentMarketingAirlineCode,noOFFLights,MarketingAirlineName)   
	SELECT ( case when @isTotalPriceSort = 0 then  MIN(airPrice ) else min ( airprice + airpricetax) end )AS LowestPrice ,NoOfSTOPs AS NoOFSegments ,airlineName AS airSegmentMarketingAirlineCode,COUNT(distinct air.airResponseKey ) noOFFLights ,
	ISNULL (ShortName,airlineName)AS MarketingAirlineName From #airResponseResultset air  
	LEFT OUTER JOIN AirVendorLookup vendor  WITH (NOLOCK) ON air.airlineName = vendor .AirlineCode   
	GROUP BY airlineName ,ShortName ,NoOfSTOPs   
	union   
	SELECT ( case when @isTotalPriceSort = 0 then  MIN(airPriceBASe ) else min ( airPriceBASe + airpricetax) end ), t.noOFSTOPs,'all',COUNT(distinct t.airResponseKey ) noOFFLights ,'all'    From #normalizedResultSet t     
	INNER JOIN @tmpAirline air ON air.airLineCode = t.airlineCode  
	GROUP BY t.noOFSTOPs   
	order by MarketingAirlineName  

	IF ( @isTotalPriceSort = 0 ) 
	BEGIN
	UPDATE T SET isSameAirlinesItin = 1 FROM  @MatrixResult T Inner join #airResponseResultset A
	ON t.airSegmentMarketingAirlineCode =A.airlineName AND T.LowestPrice = A.airprice  
	WHERE A.airlineName =A.otherlegAirlines AND noOfOtherlegairlines = 1 and airlineName <> 'Multiple Airlines' AND otherlegAirlines <> 'Multiple Airlines' 

	UPDATE T SET isSameAirlinesItin = 0 FROM  @MatrixResult T Inner join #airResponseResultset A
	ON t.airSegmentMarketingAirlineCode = A.airlineName AND T.LowestPrice = A.airprice  
	WHERE A.airlineName <> A.otherlegAirlines AND T.isSameAirlinesItin = 0 --and airlineName <> 'Multiple Airlines' AND otherlegAirlines <> 'Multiple Airlines' 
	END  
	ELSE 
	BEGIN 
	UPDATE T SET isSameAirlinesItin = 1 FROM  @MatrixResult T Inner join #airResponseResultset A
	ON t.airSegmentMarketingAirlineCode =A.airlineName AND T.LowestPrice =(airprice + airpricetax)
	WHERE A.airlineName =A.otherlegAirlines AND noOfOtherlegairlines = 1 and airlineName <> 'Multiple Airlines' AND otherlegAirlines <> 'Multiple Airlines' 

	UPDATE T SET isSameAirlinesItin = 0 FROM  @MatrixResult T Inner join #airResponseResultset A
	ON t.airSegmentMarketingAirlineCode = A.airlineName AND T.LowestPrice =(airprice + airpricetax)
	WHERE A.airlineName <> A.otherlegAirlines AND T.isSameAirlinesItin = 0 

	END

	UPDATE T SET isSameAirlinesItin = 1 FROM  @MatrixResult T  WHERE  
	airSegmentMarketingAirlineCode = 'Multiple Airlines'

	IF ( @airrequestType = 1 ) 
	BEGIN 
	UPDATE T SET isSameAirlinesItin = 1 FROM  @MatrixResult T
	END

	SELECT * FROM @MatrixResult 
	-- SELECT ( case when @isTotalPriceSort = 0 then  MIN(airPrice ) else min ( airprice + airpricetax) end )AS LowestPrice ,NoOfSTOPs AS NoOFSegments ,airlineName AS airSegmentMarketingAirlineCode,COUNT(distinct air.airResponseKey ) noOFFLights ,
	-- ISNULL (ShortName,airlineName)AS MarketingAirlineName From #airResponseResultset air  
	--LEFT OUTER JOIN AirVendorLookup vendor  WITH (NOLOCK) ON air.airlineName = vendor .AirlineCode   
	--GROUP BY airlineName ,ShortName ,NoOfSTOPs   
	--union   
	--SELECT ( case when @isTotalPriceSort = 0 then  MIN(airPriceBASe ) else min ( airPriceBASe + airpricetax) end ), t.noOFSTOPs,'all',COUNT(distinct t.airResponseKey ) noOFFLights ,'all'    From #normalizedResultSet t     
	--INNER JOIN @tmpAirline air ON air.airLineCode = t.airlineCode  
	--GROUP BY t.noOFSTOPs   
	--order by MarketingAirlineName  
	END 

	END   
	ELSE   
	BEGIN   

	IF @markettingAirline <> 'Multiple Airlines' AND @markettingAirline <> ''   
	BEGIN   
	PRINT ('1')
	PRINT @markettingAirline
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end )AS LowestPrice ,NoofsTOPs AS NoOFSegments ,air.airlineName AS airSegmentMarketingAirlineCode ,air.MarketingAirlineName  ,0 AS start , 6  AS endTime ,COUNT(
	distinct air.airResponseKey ) noOFFLights   FROM #airResponseResultset  air INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey  WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  <   '06:00:00.0000000'  AND air.airlineName = @markettingAirline 
	AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey  END)  
	GROUP BY air.NoOfSTOPs ,air.airlineName  ,air.MarketingAirlineName   
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName ,6 , 8 ,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset      air 
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey   WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '06:00:00.0000000' AND '07:59:59.0000000' AND air.airlineName = @markettingAirline AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END)  
	GROUP BY air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName   
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName ,8 , 10 ,COUNT(distinct air.airResponseKey ) noOFFLights FROM #airResponseResultset      air  
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey   WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '08:00:00.0000000' AND '09:59:59.0000000' AND air.airlineName = @markettingAirline AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END)  
	GROUP BY air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName   
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName ,10, 12 ,COUNT(distinct air.airResponseKey ) noOFFLights FROM #airResponseResultset      air 
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '10:00:00.0000000' AND '11:59:59.0000000' AND air.airlineName = @markettingAirline AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName   
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName ,12 , 14 ,COUNT(distinct air.airResponseKey ) noOFFLights FROM #airResponseResultset      air 
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '12:00:00.0000000' AND '13:59:59.0000000' AND air.airlineName = @markettingAirline AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName   
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName ,14 , 16,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset      air  
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '14:00:00.0000000' AND '15:59:59.0000000' AND air.airlineName = @markettingAirline AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName   
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName ,16 ,18,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset      air 
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '16:00:00.0000000' AND '17:59:59.0000000' AND air.airlineName = @markettingAirline AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName   
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName ,18 , 20 ,COUNT(distinct air.airResponseKey ) noOFFLights FROM #airResponseResultset      air 
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '18:00:00.0000000' AND '19:59:59.0000000' AND air.airlineName = @markettingAirline AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName   
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName ,20 , 22 ,COUNT(distinct air.airResponseKey ) noOFFLights FROM #airResponseResultset      air 
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '20:00:00.0000000' AND '21:59:59.0000000' AND air.airlineName = @markettingAirline AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName   
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName ,22 , 24 ,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset      air  
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '22:00:00.0000000' AND '23:59:59.0000000' AND air.airlineName = @markettingAirline 
	AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName   
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName ,01 ,23 ,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset air  
	INNER JOIN #normalizedResultSet page ON air.airResponseKey=page.airResponseKey WHERE    page.airlineCode = @markettingAirline AND air.gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN air.gdsSourceKey ELSE @gdssourcekey END )      
	GROUP BY air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName   
	--SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName ,01 ,23 ,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset   air  INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE    airSegmentMarketingAirlineCode = @markettingAirline AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )      GROUP BY air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName   
	--order by endTime ,start    


	END   
	ELSE   

	BEGIN   
	PRINT ('2')
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ) AS LowestPrice ,NoofsTOPs AS NoOFSegments ,air.airlineName AS airSegmentMarketingAirlineCode ,'Multiple Airlines' AS MarketingAirlineName  ,0 AS start , 6
	AS endTime ,COUNT(distinct air.airResponseKey ) noOFFLights   FROM #airResponseResultset  air INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey  WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  <   '06:00:00.0000000'  
	AND air.airlineName = 'Multiple Airlines' AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey  END)  
	GROUP BY air.NoOfSTOPs ,air.airlineName     
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,'Multiple Airlines' ,6 , 8 ,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset      air 
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey   WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '06:00:00.0000000' AND '07:59:59.0000000' AND air.airlineName = 'Multiple Airlines' AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0
	THEN gdsSourceKey ELSE @gdssourcekey END)  
	GROUP BY air.NoOfSTOPs ,air.airlineName    
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,'Multiple Airlines' ,8 , 10 ,COUNT(distinct air.airResponseKey ) noOFFLights FROM #airResponseResultset      air  
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey  WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '08:00:00.0000000' AND '09:59:59.0000000' AND air.airlineName = 'Multiple Airlines' AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0
	THEN gdsSourceKey ELSE @gdssourcekey END)  
	GROUP BY air.NoOfSTOPs ,air.airlineName    
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,'Multiple Airlines' ,10, 12 ,COUNT(distinct air.airResponseKey ) noOFFLights FROM #airResponseResultset      air 
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '10:00:00.0000000' AND '11:59:59.0000000' AND air.airlineName = 'Multiple Airlines' 
	AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName    
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,'Multiple Airlines' ,12 , 14 ,COUNT(distinct air.airResponseKey ) noOFFLights FROM #airResponseResultset      air 
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '12:00:00.0000000' AND '13:59:59.0000000' AND air.airlineName = 'Multiple Airlines' 
	AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName    
	union       
	SELECT(case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,'Multiple Airlines' ,14 , 16,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset      air  
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '14:00:00.0000000' AND '15:59:59.0000000' AND air.airlineName = 'Multiple Airlines' AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 
	THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName    
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,'Multiple Airlines' ,16 ,18,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset      air 
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '16:00:00.0000000' AND '17:59:59.0000000' AND air.airlineName = 'Multiple Airlines' 
	AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName    
	union   
	SELECT(case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,'Multiple Airlines' ,18 , 20 ,COUNT(distinct air.airResponseKey ) noOFFLights FROM #airResponseResultset      air 
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '18:00:00.0000000' AND '19:59:59.0000000' AND air.airlineName = 'Multiple Airlines' 
	AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName    
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,'Multiple Airlines' ,20 , 22 ,COUNT(distinct air.airResponseKey ) noOFFLights FROM #airResponseResultset      air 
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '20:00:00.0000000' AND '21:59:59.0000000' AND air.airlineName = 'Multiple Airlines' 
	AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName   
	union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,'Multiple Airlines' ,22 , 24 ,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset      air  
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE  CAST (air.actualTakeOffDateForLeg  AS time )  BETWEEN '22:00:00.0000000' AND '23:59:59.0000000' AND air.airlineName = 'Multiple Airlines' 
	AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName   
	Union   
	SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,air.airlineName ,'Multiple Airlines' ,01 , 23 ,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset      air  
	INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE air.airlineName = 'Multiple Airlines' 
	AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )  
	GROUP BY air.NoOfSTOPs ,air.airlineName   
	-- select 0 , 0 ,  'Multiple Airlines' ,'Multiple Airlines' ,01 ,23 ,0 --for non stop   
	--union   
	-- SELECT MIN (air.airPrice ),NoOfSTOPs ,air.airlineName ,'Multiple Airlines' ,01 ,23 ,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset   air  INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE airSegmentMarketingAirlineCode = 'Multiple Airlines' AND gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )      GROUP BY air.NoOfSTOPs ,air.airlineName ,air.MarketingAirlineName SELECT (case when @isTotalPriceSort = 0 then  MIN (air.airPrice ) else min (air.totalcost ) end ),NoOfSTOPs ,'Multiple Airlines' ,'Multiple Airlines' ,01 ,23 ,COUNT(distinct air.airResponseKey ) noOFFLights  FROM #airResponseResultset   air  INNER JOIN #pagingResultSet page ON air.airResponseKey=page.airResponseKey WHERE     gdsSourceKey = (CASE WHEN @gdssourcekey = 0 THEN gdsSourceKey ELSE @gdssourcekey END )      GROUP BY air.NoOfSTOPs  order by endTime ,start   

	END   
	-- select * from @multiLegPrice

	END   

	--SELECT * FROM #AllOneWayResponses 
	-- SELECT * FROM #airResponseResultset where noofAirlines = 1 and noOfOtherlegairlines  =1 and airSegmentMarketingAirlineCode <> otherlegAirlines 



	DECLARE @normalAirlines AS TABLE 
	(
	airlegConnections varchar(100), airlines varchar(100)
	)

	INSERT @normalAirlines 
	Select DISTINCT  airLegConnections,
	(Select DISTINCT  airSegmentMarketingAirlineCode + ',' AS [text()]
	   FROM #airResponseResultset Seg2
	Where A.airSegmentKey  = Seg2.airSegmentKey 
	 
	For XML PATH ('')) [Airlines]
	FROM #airResponseResultset A  
	inner join NormalizedAirResponses N WITH (NOLOCK)
	on A.airResponseKey = N.airresponsekey and N.airLegNumber = @airRequestTypeKey   and a.airLegNumber =@airRequestTypeKey  



	DECLARE @cityPairAirlines AS TABLE 
	(
	airlegConnections varchar(100), airlines varchar(100)
	)

	INSERT @cityPairAirlines
	SELECT DISTINCT airLegConnections  , stuff(
	(
	select DISTINCT  ',' + [Airlines] from @normalAirlines  T2  where t2.airLegConnections = t.airLegConnections for XML path('')
	),1,1,'') 

	FROM  (SELECT *FROM @normalAirlines ) T

	DECLARE @NormalMap as Table 
	( 
	rowId int Identity (1,1),
	airLegConnections varchar(100),

	airresponsekey varchar(200) , 
	NoOfStops int , 

	MinimumTotalCost decimal (12,2) ,
	MaximumTotalCost decimal (12,2) ,
	Minimumduration INT ,
	MaximumDuration INT  ,
	Airlines varchar(500),
	tripType  varchar(20),
	NoOfFlights INT

	)

	INSERT @NormalMap( airLegConnections,NoOfFlights,airresponsekey,NoOfStops,MinimumTotalCost,MaximumTotalCost ,Minimumduration ,MaximumDuration,tripType ,Airlines )

	SELECT DISTINCT A.legConnections,COUNT(DISTINCT Airresponsekey), MIN(CAST( A.airResponseKey AS varchar(200))) ,A.NoOfSTOPs ,  MIN( totalCost),MAX(totalCost) ,   MIN(legDuration)  ,MAX(legDuration)  ,
	( CASE  WHEN @airRequestType = 1 then 'OneWay' 
	WHEN @airRequestType = 2 then 'RoundTrip' 
	WHEN @airRequestType =3 then 'MultiCity' END) ,  replace( NA.airlines ,',,',',')
	FROM #airResponseResultset A inner join  
	@cityPairAirlines NA on A.legConnections= NA.airLegConnections 
	WHERE totalCost > 0
	GROUP BY A.legConnections,A.NoOfSTOPs,NA.airlines 


	--SELECT * FROM @NormalMap AirLeg   
	--INNER JOIN #airResponseResultset AirSegment On AirSegment.airResponseKey = CAST (Airleg.airresponsekey AS uniqueidentifier)
	--FOR XML AUTO, ELEMENTS, ROOT('AirMap') 

	SELECT
	-- Map columns to XML attributes/elements with XPath selectors.
	TripType AS [Type],AirLeg.MinimumTotalCost,AirLeg.MaximumTotalCost,airleg.NoOfStops ,
	Substring(Airleg.Airlines,1, LEN(AirLeg.Airlines)-1) As Airlines ,Airleg.NoOfFlights ,Airleg.Minimumduration, Airleg.MaximumDuration ,
	(
	-- Use a sub query for child elements.
	SELECT ROW_NUMBER()  over ( order by segmentOrder)RowID,
	 depart.CityName DepartCityName ,CAST (depart.Latitude as VARCHAR(200)) "DepartAirport/@Lattitude" ,CAST (depart.Longitude as VARCHAR(200))"DepartAirport/@Longitude"  ,DEPART.AirportCode as DepartAirport  ,
	 
	 arrival.CityName ArrivalCityName ,
	 CAST (arrival.Latitude as VARCHAR(200)) "ArrivalAirport/@Lattitude" ,CAST (Arrival.Longitude as VARCHAR(200))"ArrivalAirport/@Longitude"  ,Arrival.AirportCode as ArrivalAirport  
	 
	FROM
	#airResponseResultset result  LEFT OUTER JOIN AirportLookup  depart WITH (NOLOCK) on result.airSegmentDepartureAirport = depart.AirportCode 
	LEFT OUTER JOIN AirportLookup  arrival WITH (NOLOCK) on result.airSegmentArrivalAirport  = arrival.AirportCode 
	WHERE
	airResponseKey = CAST (Airleg.airresponsekey AS uniqueidentifier)
	FOR
	XML PATH('AirSegment') , -- The element name for each row.
	TYPE  -- Column is typed so it nests as XML, not text.
	    
	) AS 'AirSegments' -- The root element name for this child collection.
	FROM
	@NormalMap AirLeg 
	FOR
	XML PATH('AirLeg'), -- The element name for each row.
	ROOT('AirMap')     -- The root element name for this result set.
	
	SELECT @isExcludeAirlinesPresent AS IsExcludeAirlinesAvailable
	SELECT @isExcludeCountryPresent AS IsExcludeCountryAvailable
 	DROP TABLE #tmpDeparturesLowest 
	DROP TABLE #tmpArrivalLowest  
	DROP TABLE #airResponseResultset
	DROP TABLE #AllOneWayResponses
	DROP TABLE #normalizedResultSet
	DROP TABLE #pagingResultSet
GO