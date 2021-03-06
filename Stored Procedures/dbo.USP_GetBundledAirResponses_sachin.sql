SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[USP_GetBundledAirResponses_sachin]
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
   @siteKey int = 0,
   @CutOffSalesPriorDepartureInMinutes INT = 35,
   @MaxFareTotal FLOAT = 0,
   @UserKey int =0,
   @CompanyKey int =0,
   @UserGroupKey int =0
 )  
 
  AS  
  /*
 add this index

CREATE NONCLUSTERED INDEX [IX_INC_airLinecode] ON [dbo].[AirVendorLookup]
(
	[AirlineCode] ASC,
	[ShortName] ASC,
	[AirlineProgrammes] ASC
)
INCLUDE ( 	[IsSeatChooseAvailable]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

 */ 
 SET NOCOUNT ON   
 DECLARE @FirstRec INT  
 DECLARE @LastRec INT  
 DECLARE @isInternationalTrip BIT = 0
 DECLARE @isExcludeAirlinesPresent BIT = 0  ,@isExcludeCountryPresent BIT = 0 , @isOutOfPolicyResultsPresent BIT = 0
 DECLARE @HighFareTotal AS FLOAT = 0, @LowFareThreshold AS FLOAT = 0, @IsLowFareThreshold AS BIT = 0, @LowestPrice AS FLOAT = 0, @IsHideFare AS BIT = 0,@IsHighFareTotal AS BIT = 0;

 DECLARE @isAdvancePurchase bit = 0,	@IsNotifyAdvancePurchase bit=0, @IsApproveAdvancePurchase bit = 0,	@IsflagAdvancePurchase bit =0,				@AdvancePurchaseDays int,	@AdvancePurchasePrice float,
    	@IsBasicUnselectable BIT = 0,	@ApplyBasicUnselectable BIT =0,	@IsFlagBasicUnselectable BIT = 0,	@IsSuppressAirline bit = 0,						@policyKey int,
		@IsBussinessClassAllowed BIT=0,	@BusinessClassOverHrs INT=0 ,	@IsFlagBusinessClassOverHrs BIT=0,	@IsBusinessLongFlightsUnselectable BIT=0,
		@IsFirstClassAllowed BIT=0,		@FirstClassOverHrs INT=0,		@IsFlagFirstClassOverHrs BIT=0,		@IsFirstLongFlightsUnselectable BIT=0,			 @IsPolicyApplicable BIT=0
DECLARE @TripFromDate DATETIME
 -- Initialize variables. 
 ---STEP1 - GET PAGE VARIABLES . NOT USED IN ANY OF PROJECTS 
 SET @FirstRec = (@pageNo  - 1) * @PageSize  
 SET @LastRec = (@pageNo  * @PageSize + 1)  

 CREATE TABLE #AirSubRequest
	(
		[airSubRequestKey] [int] NOT NULL,
		[airRequestKey] [int],
		[airRequestDateTypeKey] [int],
		[airRequestDepartureAirport] [varchar](50),
		[airRequestArrivalAirport] [varchar](50),
		[airRequestDepartureDate] [datetime],
		[airRequestDepartureDateVariance] [int],
		[airRequestArrivalDate] [datetime],
		[airRequestArrivalDateVariance] [int],
		[airRequestCalendarMonth] [datetime],
		[airRequestCalendarMinDays] [int],
		[airRequestCalendarMaxDays] [int],
		[airSubRequestLegIndex] [int],
		[airSpecificDepartTime] [int],
		[groupKey] [int],
		[CalendarRequest] [varchar](500),
		[IsSubRequestCompleted] [bit],
		[ThirdPartySessionId] [nvarchar](200)
	--,CONSTRAINT [PK1_tempAirSubRequest_1] PRIMARY KEY CLUSTERED 
	--(
	--	[airSubRequestKey] 
	--)
	)

	CREATE TABLE #AirResponse
	(
		[airResponseKey] [uniqueidentifier] ,
		[airSubRequestKey] [int] ,
		[airPriceBase] [float],
		[airPriceTax] [float],
		[gdsSourceKey] [int],
		[refundable] [bit],
		[airClass] [varbinary](50),
		[priceClassCommentsSuperSaver] [varchar](500),
		[priceClassCommentsEconSaver] [varchar](500),
		[priceClassCommentsFirstFlex] [varchar](500),
		[priceClassCommentsCorporate] [varchar](500),
		[priceClassCommentsEconFlex] [varchar](500),
		[priceClassCommentsEconUpgrade] [varchar](500),
		[airSuperSaverPrice] [float],
		[airEconSaverPrice] [float],
		[airFirstFlexPrice] [float],
		[airCorporatePrice] [float],
		[airEconFlexPrice] [float],
		[airEconUpgradePrice] [float],
		[airClassSuperSaver] [varchar](50),
		[airClassEconSaver] [varchar](50),
		[airClassFirstFlex] [varchar](50),
		[airClassCorporate] [varchar](50),
		[airClassEconFlex] [varchar](50),
		[airClassEconUpgrade] [varchar](50),
		[airSuperSaverSeatRemaining] [int],
		[airEconSaverSeatRemaining] [int],
		[airFirstFlexSeatRemaining] [int],
		[airCorporateSeatRemaining] [int],
		[airEconFlexSeatRemaining] [int],
		[airEconUpgradeSeatRemaining] [int],
		[airSuperSaverFareReferenceKey] [varchar](1000),
		[airEconSaverFareReferenceKey] [varchar](1000),
		[airFirstFlexFareReferenceKey] [varchar](1000),
		[airCorporateFareReferenceKey] [varchar](1000),
		[airEconFlexFareReferenceKey] [varchar](1000),
		[airEconUpgradeFareReferenceKey] [varchar](1000),
		[airPriceClassSelected] [varchar](1000),
		[airSuperSaverTax] [float],
		[airEconSaverTax] [float],
		[airEconFlexTax] [float],
		[airCorporateTax] [float],
		[airEconUpgradetax] [float],
		[airFirstFlexTax] [float],
		[airSuperSaverFareBasisCode] [varchar](50),
		[airEconSaverFareBasisCode] [varchar](50),
		[airFirstFlexFareBasisCode] [varchar](50),
		[airCorporateFareBasisCode] [varchar](50),
		[airEconFlexFareBasisCode] [varchar](50),
		[airEconUpgradeFareBasisCode] [varchar](50),
		[isBrandedFare] [bit],
		[cabinClass] [varchar](20),
		[fareType] [varchar](20),
		[isGeneratedBundle] [bit],
		[ValidatingCarrier] [varchar](3),
		[contractCode] [varchar](50),
		[airPriceBaseSenior] [float],
		[airPriceTaxSenior] [float],
		[airPriceBaseChildren] [float],
		[airPriceTaxChildren] [float],
		[airPriceBaseInfant] [float],
		[airPriceTaxInfant] [float],
		[airPriceBaseDisplay] [float],
		[airPriceTaxDisplay] [float],
		[airPriceBaseTotal] [float],
		[airPriceTaxTotal] [float],
		[airPriceBaseYouth] [float],
		[airPriceTaxYouth] [float],
		[airCurrencyCode] [varchar](10),
		[airResponseId] [bigint] NOT NULL,
		[airPriceBaseInfantWithSeat] [float],
		[airPriceTaxInfantWithSeat] [float],
		[agentwareQueryID] [nvarchar](30),
		[agentwareItineraryID] [nvarchar](30),
		[Points] [int],
		[ticketDesignator] [nvarchar](10),
		[awardCode] [nvarchar](6),
		[ITAQueryId] [nvarchar](100),
		[ITAItineraryId] [nvarchar](100),
		[isAvailable] [bit],
		[isReturnFare] [bit] NULL
	--, CONSTRAINT [PK_AirResponse_1] PRIMARY KEY CLUSTERED
	-- (
	--	[airResponseID] 
	-- )
	)

	
	CREATE TABLE #AirSegments
	(
		[airSegmentKey] [uniqueidentifier] NOT NULL,
		[airResponseKey] [uniqueidentifier],
		[airLegNumber] [int],
		[airSegmentMarketingAirlineCode] [varchar](2),
		[airSegmentOperatingAirlineCode] [varchar](2),
		[airSegmentFlightNumber] [int],
		[airSegmentDuration] [time](7),
		[airSegmentEquipment] [varchar](4),
		[airSegmentMiles] [int],
		[airSegmentDepartureDate] [datetime],
		[airSegmentArrivalDate] [datetime],
		[airSegmentDepartureAirport] [varchar](50),
		[airSegmentArrivalAirport] [varchar](50),
		[airSegmentResBookDesigCode] [varchar](3),
		[airSegmentDepartureOffset] [float],
		[airSegmentArrivalOffset] [float],
		[airSegmentSeatRemaining] [int],
		[airSegmentMarriageGrp] [char](10),
		[airFareBasisCode] [varchar](50),
		[airFareReferenceKey] [varchar](400),
		[airSegmentOperatingFlightNumber] [int],
		[airsegmentCabin] [varchar](20),
		[segmentOrder] [int],
		[amadeusSNDIndicator] [varchar](3),
		[airSegmentOperatingAirlineCompanyShortName] [varchar](100),
		[OriginalairsegmentCabin] [varchar](20),
		[airSegmentId] [bigint],
		[airSuperSaverFareBasisCode] [varchar](50),
		[airEconSaverFareBasisCode] [varchar](50),
		[airFirstFlexFareBasisCode] [varchar](50),
		[airCorporateFareBasisCode] [varchar](50),
		[airEconFlexFareBasisCode] [varchar](50),
		[airEconUpgradeFareBasisCode] [varchar](50),
		[airSuperSaverFareReferenceKey] [varchar](1000),
		[airEconSaverFareReferenceKey] [varchar](1000),
		[airFirstFlexFareReferenceKey] [varchar](1000),
		[airCorporateFareReferenceKey] [varchar](1000),
		[airEconFlexFareReferenceKey] [varchar](1000),
		[airEconUpgradeFareReferenceKey] [varchar](1000),
		[airSegmentClassSuperSaver] [varchar](10),
		[airSegmentClassEconSaver] [varchar](10),
		[airSegmentClassFirstFlex] [varchar](10),
		[airSegmentClassEconFlex] [varchar](10),
		[airsegmentPricingKey] [nvarchar](20),
		[airsegmentFareCategory] [nvarchar](100),
		[airSegmentBrandName] [nvarchar](100),
		[airSegmentBrandID] [nvarchar](100),
		[airSegmentBaggage] [nvarchar](100),
		[airSegmentMealCode] [nvarchar](100),
		[airSegmentStops] [int],
		[ProgramCode] [varchar](20),
		[isReturnFare] [bit] NULL
	--, CONSTRAINT [PK_AirSegments_1] PRIMARY KEY CLUSTERED 
	--(
	--	[airSegmentId] 
	--)
	)

	CREATE TABLE #AirSegmentsMultiBrand(
		[airSegmentMultiBrandKey] [uniqueidentifier] NOT NULL,
		[airSegmentKey] [uniqueidentifier] NOT NULL,
		[airResponseMultiBrandKey] [uniqueidentifier] NOT NULL,
		[airResponseKey] [uniqueidentifier] NOT NULL,
		[airLegNumber] [int] NOT NULL,
		[airSegmentResBookDesigCode] [varchar](3) NULL,
		[airSegmentSeatRemaining] [int] NULL,
		[airSegmentFareBasisCode] [varchar](50) NULL,
		[airSegmentFareReferenceKey] [varchar](400) NULL,
		[airSegmentCabin] [varchar](20) NULL,
		[segmentOrder] [int] NULL,
		[airSegmentPricingKey] [nvarchar](10) NULL,
		[airSegmentBrandName] [nvarchar](100) NULL,
		[airSegmentBrandID] [nvarchar](100) NULL,
		[airSegmentBaggage] [nvarchar](100) NULL,
		[airSegmentMealCode] [nvarchar](100) NULL,
		[isReturnFare] [bit] NULL
	)

  
     ---STEP2 -GET ALL BUNDLED SUBREQUESTKEYS (NORMAL & PUBLISHED)
 DECLARE @airRequestKey AS int   
 SET @airRequestKey =( SELECT TOP 1 airRequestKey  FROM AirSubRequest WHERE airSubRequestKey = @airSubRequestKey )  
 
 SELECT @isInternationalTrip = (SELECT isInternationalTrip FROM AirRequest where airRequestKey = @airRequestKey)

 INSERT INTO #AirSubRequest 
    SELECT * FROM AirSubRequest WHERE airrequestKey = @airRequestKey
 
 INSERT INTO #AirResponse
	SELECT [airResponseKey]
      ,[airSubRequestKey]
      ,[airPriceBase]
      ,[airPriceTax]
      ,[gdsSourceKey]
      ,[refundable]
      ,[airClass]
      ,[priceClassCommentsSuperSaver]
      ,[priceClassCommentsEconSaver]
      ,[priceClassCommentsFirstFlex]
      ,[priceClassCommentsCorporate]
      ,[priceClassCommentsEconFlex]
      ,[priceClassCommentsEconUpgrade]
      ,[airSuperSaverPrice]
      ,[airEconSaverPrice]
      ,[airFirstFlexPrice]
      ,[airCorporatePrice]
      ,[airEconFlexPrice]
      ,[airEconUpgradePrice]
      ,[airClassSuperSaver]
      ,[airClassEconSaver]
      ,[airClassFirstFlex]
      ,[airClassCorporate]
      ,[airClassEconFlex]
      ,[airClassEconUpgrade]
      ,[airSuperSaverSeatRemaining]
      ,[airEconSaverSeatRemaining]
      ,[airFirstFlexSeatRemaining]
      ,[airCorporateSeatRemaining]
      ,[airEconFlexSeatRemaining]
      ,[airEconUpgradeSeatRemaining]
      ,[airSuperSaverFareReferenceKey]
      ,[airEconSaverFareReferenceKey]
      ,[airFirstFlexFareReferenceKey]
      ,[airCorporateFareReferenceKey]
      ,[airEconFlexFareReferenceKey]
      ,[airEconUpgradeFareReferenceKey]
      ,[airPriceClassSelected]
      ,[airSuperSaverTax]
      ,[airEconSaverTax]
      ,[airEconFlexTax]
      ,[airCorporateTax]
      ,[airEconUpgradetax]
      ,[airFirstFlexTax]
      ,[airSuperSaverFareBasisCode]
      ,[airEconSaverFareBasisCode]
      ,[airFirstFlexFareBasisCode]
      ,[airCorporateFareBasisCode]
      ,[airEconFlexFareBasisCode]
      ,[airEconUpgradeFareBasisCode]
      ,[isBrandedFare]
      ,[cabinClass]
      ,[fareType]
      ,[isGeneratedBundle]
      ,[ValidatingCarrier]
      ,[contractCode]
      ,[airPriceBaseSenior]
      ,[airPriceTaxSenior]
      ,[airPriceBaseChildren]
      ,[airPriceTaxChildren]
      ,[airPriceBaseInfant]
      ,[airPriceTaxInfant]
      ,[airPriceBaseDisplay]
      ,[airPriceTaxDisplay]
      ,[airPriceBaseTotal]
      ,[airPriceTaxTotal]
      ,[airPriceBaseYouth]
      ,[airPriceTaxYouth]
      ,[airCurrencyCode]
      ,[airResponseId]
      ,[airPriceBaseInfantWithSeat]
      ,[airPriceTaxInfantWithSeat]
      ,[agentwareQueryID]
      ,[agentwareItineraryID]
      ,[Points]
      ,[ticketDesignator]
      ,[awardCode]
      ,[ITAQueryId]
      ,[ITAItineraryId]
      ,[isAvailable]
      ,[isReturnFare] 
		FROM AirResponse WITH(NOLOCK) WHERE airSubRequestKey IN (SELECT airSubRequestKey FROM #AirSubRequest)

		INSERT INTO #Airsegments
		SELECT [airSegmentKey]
      ,[airResponseKey]
      ,[airLegNumber]
      ,[airSegmentMarketingAirlineCode]
      ,[airSegmentOperatingAirlineCode]
      ,[airSegmentFlightNumber]
      ,[airSegmentDuration]
      ,[airSegmentEquipment]
      ,[airSegmentMiles]
      ,[airSegmentDepartureDate]
      ,[airSegmentArrivalDate]
      ,[airSegmentDepartureAirport]
      ,[airSegmentArrivalAirport]
      ,[airSegmentResBookDesigCode]
      ,[airSegmentDepartureOffset]
      ,[airSegmentArrivalOffset]
      ,[airSegmentSeatRemaining]
      ,[airSegmentMarriageGrp]
      ,[airFareBasisCode]
      ,[airFareReferenceKey]
      ,[airSegmentOperatingFlightNumber]
      ,[airsegmentCabin]
      ,[segmentOrder]
      ,[amadeusSNDIndicator]
      ,[airSegmentOperatingAirlineCompanyShortName]
      ,[OriginalairsegmentCabin]
      ,[airSegmentId]
      ,[airSuperSaverFareBasisCode]
      ,[airEconSaverFareBasisCode]
      ,[airFirstFlexFareBasisCode]
      ,[airCorporateFareBasisCode]
      ,[airEconFlexFareBasisCode]
      ,[airEconUpgradeFareBasisCode]
      ,[airSuperSaverFareReferenceKey]
      ,[airEconSaverFareReferenceKey]
      ,[airFirstFlexFareReferenceKey]
      ,[airCorporateFareReferenceKey]
      ,[airEconFlexFareReferenceKey]
      ,[airEconUpgradeFareReferenceKey]
      ,[airSegmentClassSuperSaver]
      ,[airSegmentClassEconSaver]
      ,[airSegmentClassFirstFlex]
      ,[airSegmentClassEconFlex]
      ,[airsegmentPricingKey]
      ,[airsegmentFareCategory]
      ,[airSegmentBrandName]
      ,[airSegmentBrandID]
      ,[airSegmentBaggage]
      ,[airSegmentMealCode]
      ,[airSegmentStops]
      ,[ProgramCode]
      ,[isReturnFare]
		 FROM AirSegments WITH(NOLOCK) WHERE airResponseKey in (SELECT airResponseKey FROM #AirResponse)
	
	SELECT *,CONVERT(VARCHAR(20), '') AS airlineCode INTO #NormalizedAirResponses FROM NormalizedAirResponses WHERE airsubrequestkey IN (SELECT airSubRequestKey FROM #AirSubRequest)
	create clustered index IX_AR on #NormalizedAirResponses(airResponseKey)
	SELECT * INTO #AirResponseMultiBrand FROM AirResponseMultiBrand WHERE airSubRequestKey IN (SELECT airSubRequestKey FROM #AirSubRequest)
		--SELECT * INTO #AirSegmentsMultiBrand FROM AirSegmentsMultiBrand WHERE airResponseKey in (SELECT airResponseKey FROM #AirResponseMultiBrand)
	create clustered index IX_MB on #AirResponseMultiBrand(airResponseKey)
	INSERT INTO #AirSegmentsMultiBrand
	
	SELECT ASMB.*  FROM AirSegmentsMultiBrand ASMB WITH(NOLOCK) 
		INNER JOIN #AirResponseMultiBrand t ON ASMB.airResponseKey = t.airResponseKey 
		create clustered index IX_DX on #AirSegmentsMultiBrand(airResponseKey)
	--WHERE airResponseKey in (SELECT airResponseKey FROM #AirResponseMultiBrand)
	SELECT *,CONVERT(VARCHAR(20), '') AS airlineCode INTO #NormalizedAirResponsesMultiBrand FROM NormalizedAirResponsesMultiBrand WITH(NOLOCK) WHERE airsubrequestkey IN (SELECT airSubRequestKey FROM #AirSubRequest)
	create clustered index ix_ci on #NormalizedAirResponsesMultiBrand(airResponseMultiBrandKey)
 DECLARE @airBundledRequest AS int   
 SET @airBundledRequest = (SELECT TOP 1 AirSubRequestKey FROM #AirSubRequest WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex = -1 And groupKey = 1 )   
    
 DECLARE @airPublishedFareRequest AS int   
 SET @airPublishedFareRequest = (SELECT TOP 1 AirSubRequestKey FROM #AirSubRequest WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex = -1 And groupKey = 2 )   
    
 SELECT @TripFromDate = tripFromDate1 FROM TripRequest WHERE tripRequestKey  = (SELECT tripRequestKey FROM TripRequest_air WHERE airRequestKey = @airRequestKey)


	DECLARE @tblGetPolicyDetailsForAir as Table      
	(      
	policyDetailKey int,      
	policyKey int,    
	policyName nvarchar(50),  
	farePolicyAmt float,      
	domFareTol varchar(10),
	domHighFareTol varchar(10),
	intlFareTol float,      
	LowFareThreshold float,      
	fareType varchar(100),      
	reasonCode int,      
	multiAirport int,      
	serviceClass varchar(100),      
	paymentForm int,      
	isFarePolicyAmt bit,      
	isIntlFareTol bit,      
	isServiceClass bit,      
	isPaymentForm bit,      
	isLowFareThreshold bit,      
	isDelete bit,      
	policyTypeName nvarchar(50),      
	IsInternational bit,      
	IsMaxConnections bit,      
	MaxConnections int,      
	IsTimeBand bit,      
	TimeBand int,    
	IsApproveFarePolicyAmt bit,    
	IsApproveInternationalFare bit,    
	IsApproveLowFareThreshold bit,    
	NoBusinessClass bit,    
	isApproveBusinessClass bit,    
	NoFirstClass bit,    
	isApproveFirstClass bit,    
	NoInternational bit,    
	IsApproveNoInternational bit,    
	AdvancePurchaseDays int,    
	IsAdvancePurchase bit,    
	IsApproveAdvancePurchase bit,    
	ApproverEmailId VARCHAR(MAX),    
	IsAllTravel BIT,
	LowFareThresholdInternational float,
	IsLowFareThresholdInternational bit,
	InternationalHighFareTol float,
	IsInternationalHighFareTol bit,
	IsDomesticHighFareTol bit,
	IsNotifyAdvancePurchase bit, 
	IsflagAdvancePurchase bit,
	AdvancePurchasePrice float,
	IsBasicUnselectable BIT,
	ApplyBasicUnselectable BIT,
	IsFlagBasicUnselectable BIT,
	IsSuppressAirline BIT,
	IsBussinessClassAllowed BIT,
	BusinessClassOverHrs INT,
	IsFlagBusinessClassOverHrs BIT,
	IsBusinessLongFlightsUnselectable BIT,
	IsFirstClassAllowed BIT,
	FirstClassOverHrs INT,
	IsFlagFirstClassOverHrs BIT,
	IsFirstLongFlightsUnselectable BIT
	)  

	IF (@siteKey = 0)
	BEGIN
		IF (@UserKey <> 0)
		BEGIN
		   SELECT @siteKey = siteKey FROM Vault..[User] WHERE userkey = @UserKey
		END
	END

	SELECT @IsPolicyApplicable = CONVERT(BIT,ISNULL(data.value('(/Site/UI/IsPolicyApplicable/node())[1]', 'BIT'),0))
	FROM	Vault..SiteConfiguration 
	WHERE siteKey = @SiteKey

	IF (@IsPolicyApplicable = 1)
	BEGIN

		--Start - Get Policy 
		INSERT INTO @tblGetPolicyDetailsForAir 
		SELECT policyDetailKey,			policyKey,					policyName,							farePolicyAmt, 					domFareTol,							domHighFareTol, 
			   intlFareTol,				LowFareThreshold,			fareType,							reasonCode,      				multiAirport,						serviceClass, 
			   paymentForm,				isFarePolicyAmt,			isIntlFareTol,						isServiceClass,					isPaymentForm,						isLowFareThreshold, 
			   isDelete,      			policyTypeName,				IsInternational,					IsMaxConnections,				MaxConnections,						IsTimeBand, 
			   TimeBand,				IsApproveFarePolicyAmt,		IsApproveInternationalFare,			IsApproveLowFareThreshold,		NoBusinessClass,					isApproveBusinessClass, 
			   NoFirstClass,			isApproveFirstClass,		NoInternational,					IsApproveNoInternational,		AdvancePurchaseDays,				IsAdvancePurchase, 
			   IsApproveAdvancePurchase,							ApproverEmailId,					IsAllTravel,					LowFareThresholdInternational,		IsLowFareThresholdInternational,
			   InternationalHighFareTol,							IsInternationalHighFareTol,			IsDomesticHighFareTol,			IsNotifyAdvancePurchase,			IsflagAdvancePurchase, 
			   AdvancePurchasePrice,	IsBasicUnselectable,		ApplyBasicUnselectable ,			IsFlagBasicUnselectable,		IsSuppressAirline ,					IsBussinessClassAllowed,
			   BusinessClassOverHrs,	IsFlagBusinessClassOverHrs,	IsBusinessLongFlightsUnselectable,	IsFirstClassAllowed,			FirstClassOverHrs,					IsFlagFirstClassOverHrs ,	
			   IsFirstLongFlightsUnselectable
		FROM vault.dbo.[udf_GetPolicyDetailsForAir] (@UserKey, @CompanyKey, 'CORPORATE',@isInternationalTrip,@UserGroupKey)
		--End - Get Policy 
	
		--Set Domestic Fare Total/ Intl Fare Total from Policy
		IF (@isInternationalTrip = 0)
		   SELECT TOP 1 @MaxFareTotal = domFareTol, @IsHideFare = isFarePolicyAmt,  @HighFareTotal = domHighFareTol,@LowFareThreshold = LowFareThreshold, @IsLowFareThreshold = isLowFareThreshold,@IsHighFareTotal = IsDomesticHighFareTol FROM @tblGetPolicyDetailsForAir
		ELSE
		   SELECT TOP 1 @MaxFareTotal = intlFareTol, @IsHideFare = isIntlFareTol,@HighFareTotal = InternationalHighFareTol,@LowFareThreshold = LowFareThresholdInternational, @IsLowFareThreshold = IsLowFareThresholdInternational,@IsHighFareTotal = IsInternationalHighFareTol FROM @tblGetPolicyDetailsForAir

		SELECT TOP 1 @isAdvancePurchase = isAdvancePurchase,				@IsNotifyAdvancePurchase = IsNotifyAdvancePurchase, @IsApproveAdvancePurchase = IsApproveAdvancePurchase,		@IsflagAdvancePurchase=IsflagAdvancePurchase,	@AdvancePurchaseDays = AdvancePurchaseDays, @AdvancePurchasePrice = AdvancePurchasePrice, 
					 @IsBasicUnselectable = IsBasicUnselectable,			@ApplyBasicUnselectable = ApplyBasicUnselectable ,	@IsFlagBasicUnselectable  = IsFlagBasicUnselectable ,		@IsSuppressAirline = IsSuppressAirline,			@PolicyKey = policyKey,
					 @IsBussinessClassAllowed = IsBussinessClassAllowed,	@BusinessClassOverHrs=BusinessClassOverHrs,			@IsFlagBusinessClassOverHrs = IsFlagBusinessClassOverHrs,	@IsBusinessLongFlightsUnselectable = IsBusinessLongFlightsUnselectable,	
					 @IsFirstClassAllowed=IsFirstClassAllowed,				@FirstClassOverHrs = FirstClassOverHrs,				@IsFlagFirstClassOverHrs =	IsFlagFirstClassOverHrs,	    @IsFirstLongFlightsUnselectable = IsFirstLongFlightsUnselectable
		FROM @tblGetPolicyDetailsForAir
	END
	
  /******/  
--  STEP3-CREATE TEMP VARIABLE FOR AirSegments 
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
 airSegmentOperatingAirlineCompanyShortName VARCHAR(100),
 ProgramCode VARCHAR (20)
 )  
 
	 INSERT into @AirSegments ( airSegmentKey,airResponseKey,airLegNumber,airSegmentMarketingAirlineCode,airSegmentOperatingAirlineCode,airSegmentFlightNumber,airSegmentDuration,airSegmentEquipment,airSegmentMiles,airSegmentDepartureDate,airSegmentArrivalDate
	,airSegmentDepartureAirport,airSegmentArrivalAirport,airSegmentResBookDesigCode,airSegmentDepartureOffset,airSegmentArrivalOffset ,airSegmentSeatRemaining,airSegmentMarriageGrp ,airFareBasisCode ,airFareReferenceKey,airSegmentOperatingFlightNumber,airsegmentCabin ,segmentOrder,airSegmentOperatingAirlineCompanyShortName,ProgramCode)  
	 (SELECT airSegmentKey,SEG.airResponseKey,airLegNumber,airSegmentMarketingAirlineCode,airSegmentOperatingAirlineCode,airSegmentFlightNumber,airSegmentDuration,(case when AircraftsLookup.AircraftName IS NULL then airSegmentEquipment else AircraftsLookup.AircraftName end) as airSegmentEquipment,airSegmentMiles,airSegmentDepartureDate,airSegmentArrivalDate,airSegmentDepartureAirport,airSegmentArrivalAirport,airSegmentResBookDesigCode,airSegmentDepartureOffset,airSegmentArrivalOffset ,airSegmentSeatRemaining,
	airSegmentMarriageGrp ,airFareBasisCode ,airFareReferenceKey,airSegmentOperatingFlightNumber,airsegmentCabin,segmentOrder,airSegmentOperatingAirlineCompanyShortName,seg.ProgramCode
	  From #AirSegments seg INNER JOIN #AirResponse  resp ON seg .airResponseKey = resp.airresponsekey    
	 INNER JOIN #AirSubRequest sub on sub.airSubRequestKey = resp.airSubRequestKey   
	  LEFT OUTER JOIN AircraftsLookup on (seg.airSegmentEquipment = AircraftsLookup.SubTypeCode AND AircraftsLookup.SubTypeCode = AircraftsLookup.AircraftCode)  
	 WHERE  airRequestKey = @airRequestKey and (resp.airSubRequestKey  = @airBundledRequest   OR resp.airSubRequestKey =@airPublishedFareRequest)
	 AND ISNULL(resp.gdsSourceKey,2) =( Case WHEN @gdssourcekey = 0 THEN ISNULL(resp.gdsSourceKey ,2) ELSE @gdssourcekey END ) )  

	--select * from @AirSegments
	--return
	--  STEP4-GET START & END AIRPORT
	   /***code for date time offset ****/  
	 DECLARE @startAirPort AS varchar(100)   
	 DECLARE @endAirPort AS varchar(100)   
	 SELECT  @startAirPort=  airRequestDepartureAirport ,@endAirPort=airRequestArrivalAirport FROM #AirSubRequest WHERE  airSubRequestKey = @airSubRequestKey   
	  
	 
	DECLARE @tempResponseToRemove AS table ( airresponsekey uniqueidentifier )   

	-- declare Tables
	DECLARE @tblAirlinesGroup AS TABLE ( marketingAirline varchar(10),operatingAirline varchar(10), groupKey int)
	DECLARE @tblSuperAirlines AS TABLE ( marketingAirline varchar(10))
	DECLARE @tblOperatingAirlines AS TABLE ( operatingAirline VARCHAR(10))
	DECLARE @tblExcludedAirlines AS TABLE ( excludeAirline VARCHAR(10))	  
	DECLARE @tblExcludedCountries AS TABLE ( excludeCountry VARCHAR(10))	  	  
	DECLARE @tblExcludedAirport AS TABLE ( excludeAirport VARCHAR(10))	  
	DECLARE @tblExcludeNonDiscountedFareAirlines AS TABLE ( marketingAirline varchar(10))	
	
--SETP5 :GET ALL RESPONSES TO REMOVE BASED ON FILTERS 
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

			--Exclude Non Discounted Fare
    		IF (select COUNT(ExcludeNonDiscountedFareAirlinesKey) from vault.dbo.ExcludeNonDiscountedFareAirlines where siteKey = @siteKey) > 0
			BEGIN			
				INSERT INTO @tblExcludeNonDiscountedFareAirlines(marketingAirline) 			
				SELECT NF.MarketingAirline
				FROM vault.dbo.ExcludeNonDiscountedFareAirlines NF
				INNER JOIN @tblSuperAirlines S ON NF.MarketingAirline = S.marketingAirline
				WHERE NF.SiteKey = @siteKey
			
				INSERT @tempResponseToRemove (airresponsekey )   
				(SELECT DISTINCT s.airResponseKey FROM #AirSegments s WITH(NOLOCK) 
				INNER JOIN #AirResponse resp WITH(NOLOCK) ON s.airResponseKey =resp.airResponseKey   
				INNER JOIN #AirSubRequest subReq WITH(NOLOCK) ON resp.airSubRequestKey =subReq.airSubRequestKey  
				WHERE airRequestKey = @airRequestKey 
				AND airSegmentMarketingAirlineCode in (SELECT * FROM @tblExcludeNonDiscountedFareAirlines) 
				AND (resp.fareType is NULL OR ltrim(rtrim(resp.fareType))=''))
			END	
		END
					
		-- Add all responsekey to @tempResponseToRemove EXCEPT combinations from @tblAirlinesGroup table
		IF (SELECT COUNT(*) FROM @tblAirlinesGroup) > 0
		BEGIN
			INSERT @tempResponseToRemove (airresponsekey )
			(SELECT DISTINCT S.airresponsekey FROM #AirSegments S WITH(NOLOCK) 
			INNER JOIN #AirResponse AR WITH(NOLOCK)  ON S.airResponseKey = Ar.airResponseKey 
			INNER JOIN #AirSubRequest SUB WITH(NOLOCK) ON Ar.airSubRequestKey = SUB.airSubRequestKey 		
			WHERE airRequestKey = @airRequestKey AND SUB.groupKey = 1
			AND S.airSegmentMarketingAirlineCode + S.airSegmentOperatingAirlineCode NOT IN 
			(SELECT AG.marketingAirline + AG.operatingAirline FROM @tblAirlinesGroup AG WHERE AG.groupKey = 1))
			
			IF @airPublishedFareRequest > 0 -- For GroupKey 2(Publish fares)
			BEGIN
				INSERT @tempResponseToRemove (airresponsekey )
				(SELECT DISTINCT S.airresponsekey FROM #AirSegments S WITH(NOLOCK) 
				INNER JOIN #AirResponse AR WITH(NOLOCK)  ON S.airResponseKey = Ar.airResponseKey 
				INNER JOIN #AirSubRequest SUB WITH(NOLOCK) ON Ar.airSubRequestKey = SUB.airSubRequestKey 		
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
		(SELECT DISTINCT s.airResponseKey FROM #AirSegments s WITH(NOLOCK) 
		INNER JOIN #AirResponse resp WITH(NOLOCK) ON s.airResponseKey =resp.airResponseKey   
		INNER JOIN #AirSubRequest subReq WITH(NOLOCK) ON resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey and airSegmentMarketingAirlineCode IN (SELECT * FROM @tblExcludedAirlines))

	  IF((SELECT COUNT(DISTINCT s.airResponseKey) FROM #AirSegments s WITH(NOLOCK) 
	  INNER JOIN #AirResponse resp WITH(NOLOCK) on s.airResponseKey =resp.airResponseKey   
	  INNER JOIN #AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey =subReq.airSubRequestKey  
	  WHERE airRequestKey = @airRequestKey and airSegmentMarketingAirlineCode IN (SELECT * FROM @tblExcludedAirlines) )> 0 ) 
	  BEGIN
		SET @isExcludeAirlinesPresent =  1 
	  END 

		-- to exclude operating airlines
		INSERT @tempResponseToRemove (airresponsekey )   
		(SELECT DISTINCT s.airResponseKey FROM #AirSegments s WITH(NOLOCK) 
		INNER JOIN #AirResponse resp WITH(NOLOCK) ON s.airResponseKey =resp.airResponseKey   
		INNER JOIN #AirSubRequest subReq WITH(NOLOCK) ON resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey and airSegmentOperatingAirlineCode in (SELECT * FROM @tblExcludedAirlines))

  		IF ( @isExcludeAirlinesPresent = 0 ) 
		BEGIN
			IF((SELECT COUNT(DISTINCT s.airResponseKey )FROM #AirSegments s WITH(NOLOCK) 
		INNER JOIN #AirResponse resp WITH(NOLOCK) ON s.airResponseKey =resp.airResponseKey   
		INNER JOIN #AirSubRequest subReq WITH(NOLOCK) ON resp.airSubRequestKey =subReq.airSubRequestKey  
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
		(SELECT DISTINCT s.airResponseKey FROM #AirSegments s WITH(NOLOCK) 
		INNER JOIN #AirResponse resp WITH(NOLOCK) on s.airResponseKey =resp.airResponseKey   
		INNER JOIN #AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey 
		AND ((S.airSegmentDepartureAirport IN (SELECT * FROM @tblExcludedAirport)) OR (S.airSegmentArrivalAirport IN (SELECT * FROM @tblExcludedAirport))))
		
		IF((SELECT COUNT(DISTINCT s.airResponseKey) FROM #AirSegments s WITH(NOLOCK) 
		INNER JOIN #AirResponse resp WITH(NOLOCK) on s.airResponseKey =resp.airResponseKey   
		INNER JOIN #AirSubRequest subReq WITH(NOLOCK) on resp.airSubRequestKey =subReq.airSubRequestKey  
		WHERE airRequestKey = @airRequestKey 
		AND ((S.airSegmentDepartureAirport IN (SELECT * FROM @tblExcludedAirport)) OR (S.airSegmentArrivalAirport IN (SELECT * FROM @tblExcludedAirport))))> 0 ) 
		BEGIN
			SET @isExcludeCountryPresent =  1 
		END 
    END
  
 ---STEP 6 CALCULATE DEPARTURE OFFSET   AND ARRIVAL OFFSET   
 DECLARE @departureOffset AS float   
 SET @departureOffset =(  SELECT distinct  TOP 1  airSegmentDepartureOffset FROM #AirSegments seg INNER JOIN #AirResponse r ON seg.airResponseKey =r.airResponseKey  
  WHERE(  r.airSubRequestKey = @airSubRequestKey     )  AND airSegmentDepartureAirport= @startAirPort AND airSegmentDepartureOffset is not null  )  
 ---CALCULATE ARRIVAL OFFSET   
 DECLARE @arrivalOffset AS float   
 SET @arrivalOffset = (SELECT distinct TOP 1 airSegmentArrivalOffset  FROM #AirSegments seg INNER JOIN #AirResponse r ON seg.airResponseKey =r.airResponseKey  
 WHERE(  r.airSubRequestKey = @airSubRequestKey    )  AND airSegmentArrivalAirport=@endAirPort AND airSegmentArrivalOffset is not null )  
  
  
  IF ( @airRequestTypeKey = 1 AND @CutOffSalesPriorDepartureInMinutes IS NOT NULL) 
	BEGIN
		DECLARE @departOffset AS float
	    IF (@departureOffset IS NULL)
	    BEGIN
			SET @departOffset =(  SELECT  TOP 1  airSegmentDepartureOffset FROM #AirSegments seg WITH (NOLOCK) INNER JOIN #AirResponse r WITH (NOLOCK) ON seg.airResponseKey =r.airResponseKey
			WHERE(  r.airSubRequestKey = @airBundledRequest  )
			AND airLegNumber =@airRequestTypeKey AND airSegmentDepartureAirport= @startAirPort AND airSegmentDepartureOffset is not null ORDER by segmentOrder ASC )
	    END
	    ELSE
	     SET @departOffset = @departureOffset
	
        DECLARE @OriginGMTTime DATETIME, @FilterDateTime DATETIME	
		SET @OriginGMTTime = DATEADD(MINUTE, (60)*(@departOffset),GETUTCDATE())
		SET @FilterDateTime = DATEADD(MINUTE,@CutOffSalesPriorDepartureInMinutes,@OriginGMTTime)
	
		INSERT @tempResponseToRemove (airresponsekey ) 
		(SELECT DISTINCT seg.airResponseKey FROM #AirSegments seg WITH(NOLOCK) 
		INNER JOIN #AirResponse resp ON seg.airResponseKey = resp.airResponseKey   
		INNER JOIN #AirSubRequest subReq ON resp.airSubRequestKey =subReq.airSubRequestKey
		WHERE airRequestKey = @airRequestKey AND segmentOrder = 1
		AND seg.airSegmentDepartureDate < @FilterDateTime)

	END
  
  
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
 DECLARE @airPriceInfantWithSeatForAnotherLeg AS FLOAT   
 DECLARE @airPriceTaxInfantWithSeatForAnotherLeg AS FLOAT
 
 DECLARE @tmpAirline  TABLE   
  (  
  airLineCode VARCHAR (200)   
  )  
    --STEP 7: CREATE @NoOfSTOPs AND @tmpAirline TABLES
	IF @NoOfSTOPs = '-1' /*****Default view WHEN no of sTOPs not SELECTed *********/  
	BEGIN   
		SET @NoOfSTOPs = '0,1,2'  
	END   

	DECLARE @noSTOPs AS table ( stops int  )  
	INSERT @noSTOPs (stops )  
	SELECT * FROM vault.dbo.ufn_CSVToTable (@NoOfSTOPs)  

	IF (SELECT gdsSourceKey  From #AirResponse WHERE airResponseKey = @SELECTedResponseKey)  =  9    
	BEGIN   
		SET @airLines = (SELECT  DISTINCT TOP 1 airSegmentMarketingAirlineCode FROM #AirSegments WHERE airResponseKey = @SELECTedResponseKey )  
	END   
	IF @airLines <> '' and @isIgnoreAirlineFilter <> 1    -- AND @airLines <> 'Multiple Airlines'  -- AND not exists(  SELECT @airLines WHERE @airLines like '%Multiple Airlines%')  
	BEGIN   
		INSERT into @tmpAirline(airlineCode)    SELECT * FROM vault.dbo.ufn_CSVToTable (@airLines )    
	END   
	ELSE       
	BEGIN   
		INSERT into @tmpAirline(airlineCode)  SELECT DISTINCT seg1.airSegmentMarketingAirlineCode FROM #AirSegments seg1
		INNER JOIN #AirResponse resp  ON seg1.airResponseKey = resp.airResponseKey WHERE 
		( resp.airSubRequestKey = @airSubRequestKey or resp .airSubRequestKey = @airBundledRequest   ) 
		
		INSERT into @tmpAirline(airlineCode)  SELECT DISTINCT seg1.airSegmentMarketingAirlineCode FROM #AirSegments seg1
		INNER JOIN #AirResponse resp  ON seg1.airResponseKey = resp.airResponseKey WHERE 
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
  airSegmentFlightNumber int,   
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
  airSegmentOperatingAirlineCompanyShortName VARCHAR(100)  ,
  airPriceBaseInfantWithSeat float,
  airPriceTaxInfantWithSeat float,
  ReasonCode NVARCHAR(10) DEFAULT 'NONE',
  airlegBrandName NVARCHAR(200),
  ProgramCode varchar(20),
  IsSuppressed BIT DEFAULT 0,
  IsSuppressAirline BIT DEFAULT 0
 )  
  
  --STEP 8  ADD ALL LEG DETAILS IN  tempOneWayResponses
  
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
  cabinClass varchar(20) ,
  airlegnumber int,
  airOnePriceBaseInfantWithSeat float,
  airOnePriceTaxInfantWithSeat float,
  airlegBrandName NVARCHAR(200)  
 )  
    
	INSERT @tempOneWayResponses (airOneResponsekey,airOnePriceBase,airOneBaseSenior ,airOneTaxSenior, airOneBaseChildren ,airOneTaxChildren ,airOneBaseInfant, airOneTaxInfant,airOneBaseYouth, airOneTaxYouth, airOneBaseTotal, airOneTaxTotal, airOneBaseDisplay, airOneTaxDisplay,airSegmentFlightNumber,airSegmentMarketingAirlineCode,airsubRequestkey,airOnePriceTax   ,cabinClass ,otherLegPrice  ,airlegnumber ,airOnePriceBaseInfantWithSeat,airOnePriceTaxInfantWithSeat,airlegBrandName)  
	       
	SELECT resp.AirResponsekey, airPriceBase ,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,airPriceBaseYouth,airPriceTaxYouth,AirPriceBaseTotal,AirPriceTaxTotal,airPriceBaseDisplay,airPriceTaxDisplay,nresp.flightNumber ,nresp.airlines,nresp.airSubRequestKey,airPriceTax ,nresp.cabinclass,(case when @isTotalPriceSort = 0 then isnull(@airPriceForAnotherLeg,0)else ( isnull(@airPriceForAnotherLeg,0) + isnull(@airPriceTaxForAnotherLeg,0))  end),nresp.airLegNumber,airPriceBaseInfantWithSeat,airPriceTaxInfantWithSeat,nresp.airLegBrandName
	FROM #AirResponse resp  INNER JOIN #NormalizedAirResponses nresp ON resp.airResponseKey = nresp .airresponsekey   
	inner join #AirSubRequest sub on sub.airSubRequestKey =resp.airSubRequestKey where airRequestKey =@airRequestKey	   
	AND ISNULL(resp.gdsSourceKey,2) =( CASE WHEN @gdssourcekey = 0 THEN ISNULL(resp.gdsSourceKey,2) ELSE @gdssourcekey END )     

   --select * from @tempOneWayResponses
   --return
	DECLARE @noOfLegsForRequest AS int   
	SET @noOfLegsForRequest =( SELECT COUNT(*) FROM #AirSubRequest WHERE airRequestKey = @airRequestKey AND airSubRequestLegIndex > 0 )   

	IF @gdssourcekey = 9   
	BEGIN  
		IF ( @airLines <> 'Multiple Airlines')  
		BEGIN   
			delete from @tempOneWayResponses where airOneResponsekey in (  
			select distinct seg.airResponseKey   FROM #AirSegments seg INNER JOIN #AirResponse  resp ON seg .airResponseKey = resp.airresponsekey   
			INNER JOIN #AirSubRequest subrequest ON resp.airSubRequestKey = subrequest .airSubRequestKey 
			and seg.airSegmentMarketingAirlineCode not in (select * From @tmpAirline )   
			WHERE   airrequestKey = @airRequestKey    AND gdsSourceKey = @gdssourcekey)  
		END  
	END   
  
	   
--STEP 9 CREATE NORMAL TABLE WITH ALL LEG DETAILS IN DENORMALIZED FORM SORTED BY PRICE ASC

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
airPriceTotal float,
airLegBrandName nvarchar(200),
refundable bit
)

CREATE TABLE #tmp_normal
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
airPriceTotal float,
airLegBrandName nvarchar(200),
refundable bit,
childResponseKey uniqueidentifier
)

Create table #ResultToMergeResponseKey
 (
		responseKeysWithBrandName nvarchar(512),
 )

CREATE TABLE #AdditionalFares 
	( 
	airresponsekey uniqueidentifier , 
	airresponseMultiBrandkey uniqueidentifier ,
	airLegBrandName varchar(200) ,
	TotalPriceToDisplay decimal(12,2),
	TotalAllPaxPriceToDisplay decimal(12,2),
	childresponsekey uniqueidentifier,
	isRefundable bit,
	ReasonCode NVARCHAR(10) DEFAULT 'NONE',
	airResBookDesigCode varchar(100) default '',
	IsSuppressed BIT DEFAULT 0,
	airRequestKey int                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
	)

	CREATE TABLE #tmp_AdditionalFares 
	( 
	id int identity (1,1),
	airresponsekey uniqueidentifier , 
	airresponseMultiBrandkey uniqueidentifier ,
	airLegBrandName varchar(200) ,
	TotalPriceToDisplay decimal(12,2),
	TotalAllPaxPriceToDisplay decimal(12,2),
	childresponsekey uniqueidentifier,
	isRefundable bit,
	ReasonCode NVARCHAR(10) DEFAULT 'NONE',
	airResBookDesigCode varchar(100) default '',
	IsSuppressed BIT DEFAULT 0,
	airRequestKey int  ,
	isValid bit DEFAULT 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
	)
	
--exec [usp_UnifyResultsForMultiCity] @airBundledRequest, @airPublishedFareRequest, @airrequestkey

 INSERT INTO #normal (airresponsekey,airsubrequestkey,leg1flightnumber,leg1airlines,leg1Connection,airPriceTotal,airLegBrandName,refundable)

 SELECT n1.airresponsekey,n1.airsubrequestkey,n1.flightNumber , n1.airlines,n1.airLegConnections ,A.airpricebaseTotal + A.airpriceTaxTotal,n1.airLegBrandName,a.refundable
 --,n3.flightNumber , n3.airlines,n3.airLegConnections 
 FROM #NormalizedAirResponses N1 WITH (NOLOCK) INNER JOIN #AirResponse A WITH (NOLOCK) on N1.airresponsekey = A.airresponsekey
WHERE (n1.airsubrequestkey =@airBundledRequest or n1.airSubrequestkey = @airPublishedFareRequest) and airlegnumber =1 
ORDER BY (A.airpricebaseTotal + A.airpriceTaxTotal) ASC , N1.airsubrequestkey,N1.airresponsekey

---Leg2
UPDATE  N SET leg2flightNUMBER = flightNumber , leg2Airlines = N1.airlines, leg2Connection = N1.airLegConnections FROM #normal N INNER JOIN #NormalizedAirResponses N1 WITH (NOLOCK)ON N.airresponsekey = N1.airresponsekey AND N1.airlegnumber = 2 
UPDATE  N SET leg3flightNUMBER = flightNumber , leg3Airlines = N1.airlines, leg3Connection = N1.airLegConnections FROM #normal N INNER JOIN #NormalizedAirResponses N1 WITH (NOLOCK) ON N.airresponsekey = N1.airresponsekey AND N1.airlegnumber = 3 
UPDATE  N SET leg4flightNUMBER = flightNumber , leg4Airlines = N1.airlines, leg4Connection = N1.airLegConnections FROM #normal N INNER JOIN #NormalizedAirResponses N1 WITH (NOLOCK) ON N.airresponsekey = N1.airresponsekey AND N1.airlegnumber = 4 

UPDATE  N SET leg5flightNUMBER = flightNumber , leg5Airlines = N1.airlines, leg5Connection = N1.airLegConnections FROM #normal N INNER JOIN #NormalizedAirResponses N1 WITH (NOLOCK) ON N.airresponsekey = N1.airresponsekey AND N1.airlegnumber = 5 
--leg6
UPDATE  N SET leg6flightNUMBER = flightNumber , leg6Airlines = N1.airlines, leg6Connection = N1.airLegConnections FROM #normal N INNER JOIN #NormalizedAirResponses N1 WITH (NOLOCK) ON N.airresponsekey = N1.airresponsekey AND N1.airlegnumber = 6 



  --STEP 10 DELETE DUPLICATE KEEPING UNIQUES OPTIONS 
DELETE FROM #Normal 
WHERE ID not in 
(
SELECT min(ID)  FROM #normal 
group by leg1FlightNumber,leg1Airlines,leg1Connection ,leg2FlightNumber,leg2Airlines,leg2Connection,leg3FlightNumber,leg3Airlines,leg3Connection ,leg4FlightNumber,leg4Airlines,leg4Connection,leg5FlightNumber,leg5Airlines,leg5Connection,leg6FlightNumber,leg6Airlines,leg6Connection,airLegBrandName,refundable
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
	airOnePriceBaseInfantWithSeat float,
	airOnePriceTaxInfantWithSeat float,
	agentwareQueryID nvarchar(30),
	agentwareItineraryID nvarchar(30),
	airLegBrandName nvarchar(200) NULL,
	airLegBookingClasses varchar(20) NULL,
	airResponseMultiBrandKey uniqueidentifier NULL,
	isMultiBrandFare bit default 0,
	gdsSourceKey int ,
	childResponsekey uniqueidentifier NULL,
	isMultiCabinFare bit default 0,
	isRefundable bit default 0,
	isValid bit default 1
	) 
 
			
			INSERT INTO #tmp_normal(airresponsekey,airsubrequestkey,leg1flightnumber,leg1airlines,leg1Connection,airPriceTotal,airLegBrandName,refundable,leg2flightnumber,leg2airlines,leg2Connection,leg3flightnumber,leg3airlines,leg3Connection,leg4flightnumber,leg4airlines,leg4Connection,leg5flightnumber,leg5airlines,leg5Connection,leg6flightnumber,leg6airlines,leg6Connection,childResponseKey)
			SELECT t.airresponsekey,t.airsubrequestkey,t.leg1flightnumber,t.leg1airlines,t.leg1Connection,t.airPriceTotal,t.airLegBrandName,t.refundable,t.leg2flightnumber,t.leg2airlines,t.leg2Connection,t.leg3flightnumber,t.leg3airlines,t.leg3Connection,t.leg4flightnumber,t.leg4airlines,t.leg4Connection,t.leg5flightnumber,t.leg5airlines,t.leg5Connection,t.leg6flightnumber,t.leg6airlines,t.leg6Connection,t.airresponsekey
			FROM #normal t,
			(
			SELECT min(airPriceTotal) AS minPrice,MIN(id )  AS minIdent, leg1FlightNumber,leg1Airlines,leg1Connection ,leg2FlightNumber,leg2Airlines,leg2Connection,leg3FlightNumber,leg3Airlines,leg3Connection ,leg4FlightNumber,leg4Airlines,leg4Connection,leg5FlightNumber,leg5Airlines,leg5Connection,leg6FlightNumber,leg6Airlines,leg6Connection  
			FROM #normal m  
			GROUP BY leg1FlightNumber,leg1Airlines,leg1Connection ,leg2FlightNumber,leg2Airlines,leg2Connection,leg3FlightNumber,leg3Airlines,leg3Connection ,leg4FlightNumber,leg4Airlines,leg4Connection,leg5FlightNumber,leg5Airlines,leg5Connection,leg6FlightNumber,leg6Airlines,leg6Connection
			having count(1) > 1  
			) AS derived 
			WHERE isnull(t.leg1FlightNumber,'')=isnull(derived.leg1FlightNumber,'') AND isnull(t.leg2FlightNumber,'')=isnull(derived.leg2FlightNumber,'') and isnull(t.leg3FlightNumber,'')=isnull(derived.leg3FlightNumber,'')  AND isnull(t.leg4FlightNumber,'')=isnull(derived.leg4FlightNumber,'') and isnull(t.leg5FlightNumber,'')=isnull(derived.leg5FlightNumber,'')  AND isnull(t.leg6FlightNumber,'')=isnull(derived.leg6FlightNumber,'') 
			AND (airPriceTotal) >  minPrice
			
			delete #normal  
			FROM #normal t,  
			(  
			SELECT min(airPriceTotal) AS minPrice,MIN(id )  AS minIdent, leg1FlightNumber,leg1Airlines,leg1Connection ,leg2FlightNumber,leg2Airlines,leg2Connection,leg3FlightNumber,leg3Airlines,leg3Connection ,leg4FlightNumber,leg4Airlines,leg4Connection,leg5FlightNumber,leg5Airlines,leg5Connection,leg6FlightNumber,leg6Airlines,leg6Connection  
			FROM #normal m  
			GROUP BY  leg1FlightNumber,leg1Airlines,leg1Connection ,leg2FlightNumber,leg2Airlines,leg2Connection,leg3FlightNumber,leg3Airlines,leg3Connection ,leg4FlightNumber,leg4Airlines,leg4Connection,leg5FlightNumber,leg5Airlines,leg5Connection,leg6FlightNumber,leg6Airlines,leg6Connection
			having count(1) > 1  
			) AS derived  
			WHERE isnull(t.leg1FlightNumber,'')=isnull(derived.leg1FlightNumber,'') AND isnull(t.leg2FlightNumber,'')=isnull(derived.leg2FlightNumber,'') and isnull(t.leg3FlightNumber,'')=isnull(derived.leg3FlightNumber,'')  AND isnull(t.leg4FlightNumber,'')=isnull(derived.leg4FlightNumber,'') and isnull(t.leg5FlightNumber,'')=isnull(derived.leg5FlightNumber,'')  AND isnull(t.leg6FlightNumber,'')=isnull(derived.leg6FlightNumber,'') 
			AND airPriceTotal >  minPrice
			
			UPDATE #tmp_normal   
			SET airResponsekey = S.airResponsekey 
			FROM #normal S 
			LEFT OUTER JOIN #tmp_normal Temp
			ON isnull(Temp.leg1FlightNumber,'')=isnull(S.leg1FlightNumber,'') AND isnull(Temp.leg2FlightNumber,'')=isnull(S.leg2FlightNumber,'') and isnull(Temp.leg3FlightNumber,'')=isnull(S.leg3FlightNumber,'')  AND isnull(Temp.leg4FlightNumber,'')=isnull(S.leg4FlightNumber,'') and isnull(Temp.leg5FlightNumber,'')=isnull(S.leg5FlightNumber,'')  AND isnull(Temp.leg6FlightNumber,'')=isnull(S.leg6FlightNumber,'') 
			
			-- MC1 Data No need to add at end
			insert into #tmp_AdditionalFares(airresponsekey,childresponsekey,airLegBrandName,isRefundable,isValid)
			Select airresponsekey,airresponsekey,airLegBrandName,refundable,0 FROM #normal

			-- MC2 Data 
			insert into #tmp_AdditionalFares
			select arm1.airresponsekey,'00000000-0000-0000-0000-000000000000',arm1.airLegBrandName,arm1.airPriceTotal,arm1.airPriceTotal,arm1.childResponseKey,arm1.refundable,'NONE',
			STUFF((
			SELECT ',' + airLegBookingClasses 
			from #NormalizedAirResponses arm2 
			WHERE (arm2.airresponsekey = arm1.airresponsekey) 
			FOR XML PATH('')), 1, 1, '')  as airResBookDesigCode,0,@airRequestKey,1
			from #tmp_normal arm1
			
			-- All MB Data 
			insert into #AdditionalFares
			select  arm.airResponseKey as airresponsekey,
			arm.airResponseMultiBrandKey as airresponseMultiBrandkey,
			narmb.airlegbrandname as airLegBrandName,
			cast((arm.airPriceBase+arm.airPriceTax) as decimal(12,2)) as TotalAllPaxPriceToDisplay,
			cast((arm.airPriceBase+arm.airPriceTax) as decimal(12,2)) as TotalPriceToDisplay,
			arm.airResponseKey as  childresponsekey,
			arm.refundable as isRefundable,
			'NONE' as ReasonCode,
			  STUFF((
			SELECT ',' + airLegBookingClasses 
			from #NormalizedAirResponsesMultiBrand arm1 
			WHERE (arm1.airResponseMultiBrandKey = arm.airResponseMultiBrandKey) 
			FOR XML PATH('')), 1, 1, '')     as airResBookDesigCode,
			0 as IsSuppressed,
			@airRequestKey as airRequestKey
			from #AirResponseMultiBrand arm 
			inner join #NormalizedAirResponsesMultiBrand narmb on arm.airResponseMultiBrandKey=narmb.airresponseMultiBrandkey
			 WHERE arm.airSubRequestKey  = @airBundledRequest   OR arm.airSubRequestKey =@airPublishedFareRequest
			group by  arm.airresponsekey,arm.airresponseMultiBrandkey,narmb.airLegBrandName,arm.airPriceBase,arm.airPriceTax,arm.refundable

			-- Remove MB falls under tmpResponseToRemove
			Delete P  
			FROM #AdditionalFares P  
			INNER JOIN @tempResponseToRemove T  ON P.airResponseKey = T.airresponsekey

			-- Insert AirResponse MB from table
			insert into #tmp_AdditionalFares
			select Ar.airresponsekey,Ar.airresponseMultiBrandkey,Ar.airLegBrandName,Ar.TotalPriceToDisplay,Ar.TotalAllPaxPriceToDisplay,Ar.childresponsekey,Ar.isRefundable,Ar.ReasonCode,Ar.airResBookDesigCode,Ar.IsSuppressed,Ar.airRequestKey,1
			from #normal TAR
			inner join #AdditionalFares AR
			on TAR.airresponsekey = AR.airresponsekey
			
			-- Insert ChildResponse MB from table
			insert into #tmp_AdditionalFares
			select TAR.airresponsekey,Ar.airresponseMultiBrandkey,Ar.airLegBrandName,Ar.TotalPriceToDisplay,Ar.TotalAllPaxPriceToDisplay,Ar.childresponsekey,Ar.isRefundable,Ar.ReasonCode,Ar.airResBookDesigCode,Ar.IsSuppressed,Ar.airRequestKey,1
			from #tmp_normal TAR
			inner join #AdditionalFares AR
			on TAR.childresponsekey = AR.airresponsekey

			delete #tmp_AdditionalFares  
			FROM #tmp_AdditionalFares t,  
			(  
			SELECT min(TotalPriceToDisplay) AS minPrice,MIN(id )  AS minIdent,   airresponsekey,airLegBrandName,isRefundable   
			FROM #tmp_AdditionalFares m  
			GROUP BY airresponsekey,airLegBrandName,isRefundable 
			having count(1) > 1  
			) AS derived  
			WHERE t.airresponsekey = derived.airresponsekey AND t.airLegBrandName =derived .airLegBrandName 
			AND t.isRefundable = derived.isRefundable 
			AND (TotalPriceToDisplay) >  minPrice
			
			delete #tmp_AdditionalFares  
			FROM #tmp_AdditionalFares t,  
			(  
			SELECT min(TotalPriceToDisplay) AS minPrice,MIN(id )  AS minIdent,   airresponsekey,airLegBrandName,isRefundable   
			FROM #tmp_AdditionalFares m  
			GROUP BY  airresponsekey,airLegBrandName,isRefundable 
			having count(1) > 1  
			) AS derived  
			WHERE t.airresponsekey = derived.airresponsekey AND t.airLegBrandName =derived .airLegBrandName 
			AND t.isRefundable = derived.isRefundable AND t.isRefundable = derived.isRefundable
			AND id > minIdent
			
			 -- At the end delete from all Invalid Responses
			 delete from #tmp_AdditionalFares
			 where isValid = 0


--STEP11 GET ALL LEGS AIRLINES COUNT IN @normalizedResultSet 
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
  otherlegPrice float ,otherlegtax float ,airlegnumber int ,
  airlegBrandName NVARCHAR(200),
 ProgramCode VARCHAR(20)
 )     
	INSERT  @normalizedResultSet (airresponsekey ,airPriceBase,noOFStops ,noOfAirlines ,takeoffdate ,landingdate ,airlinecode ,gdssourcekey ,airpricetax ,airsubrequetkey ,cabinclass ,otherlegPrice,otherlegtax ,airlegnumber,airlegBrandName,ProgramCode)  
	(SELECT seg.airresponsekey,result.airOneBaseDisplay ,CASE WHEN COUNT(seg.airresponsekey )-1 > 1 THEN 1 ELSE  COUNT(seg.airresponsekey )-1 END ,COUNT(distinct seg.airSegmentMarketingAirlineCode ),MIN(airSegmentDepartureDate ) ,MAX(airSegmentArrivalDate ),  
	CASE WHEN COUNT(distinct seg.airSegmentMarketingAirlineCode ) > 1 THEN 'Multiple Airlines'  ELSE MIN(seg.airSegmentMarketingAirlineCode) END ,  
	resp.gdsSourceKey, result.airOneTaxDisplay ,result.airsubRequestkey ,result .cabinClass  ,otherLegPrice,otherLegTax  ,result.airlegnumber,result.airlegBrandName,'' as ProgramCode   
	FROM @tempOneWayResponses result  INNER JOIN 
	  
	#AirResponse resp   ON resp.airResponseKey = result.airOneResponsekey   
	
	INNER JOIN  #AirSegments seg   ON result .airOneResponsekey = seg.airResponseKey   
	INNER JOIN #normal N ON resp.airresponsekey = N.airresponsekey   
	GROUP BY seg.airResponseKey,result.airOneBaseDisplay ,gdssourcekey  ,result .airOneTaxDisplay , result.airsubRequestkey ,result.cabinClass ,result.otherlegprice,otherLegTax ,result.airlegnumber,result.airlegBrandName)  
    
	

    --STEP 12 INSERT DATA FROM @normalizedResultSet AND @airSegments into @airResponseResultset
	INSERT into @airResponseResultset (airSegmentKey , airResponseKey,airLegNumber,airSegmentMarketingAirlineCode,airSegmentFlightNumber,airSegmentDuration, airSegmentEquipment,airSegmentMiles,airSegmentDepartureDate,airSegmentArrivalDate ,airSegmentDepartureAirport,airSegmentArrivalAirport,airPrice,MarketingAirlineName,NoOfStops ,actualTakeOffDateForLeg,actualLandingDateForLeg ,airSegmentOperatingAirlineCode , airSegmentResBookDesigCode,noofAirlines ,airlineName , gdsSourceKey ,airPriceTax ,airRequestKey 
	, airsegmentDepartureOffset,airSegmentArrivalOffset ,airSegmentSeatRemaining,priceClassCommentsSuperSaver,priceClassCommentsEconSaver ,priceClassCommentsFirstFlex ,priceClassCommentsCorporate,priceClassCommentsEconFlex,priceClassCommentsEconUpgrade, airSuperSaverPrice ,airEconSaverPrice ,airFirstFlexPrice ,airCorporatePrice,airEconFlexPrice,airEconUpgradePrice ,airClassSuperSaver,airClassEconSaver,airClassFirstFlex,airClassCorporate,airClassEconFlex,airClassEconUpgrade,airSuperSaverSeatRemaining,airEconSaverSeatRemaining,airFirstFlexSeatRemaining,airCorporateSeatRemaining,airEconFlexSeatRemaining,airEconUpgradeSeatRemaining, airPriceClassSelected,otherLegPrice,isRefundable,isBrandedFare  ,cabinClass ,fareType,segmentOrder ,airsegmentCabin ,totalCost,
	airSegmentOperatingFlightNumber ,otherlegtax ,isgeneratedBundle,airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,AirPriceBaseTotal,AirPriceTaxTotal,airPriceBaseDisplay, airPriceTaxDisplay,airSegmentOperatingAirlineCompanyShortName,airPriceBaseInfantWithSeat,airPriceTaxInfantWithSeat,airlegBrandName,ProgramCode)  
	SELECT seg.airSegmentKey, seg.airResponseKey, seg.airLegNumber, seg. airSegmentMarketingAirlineCode ,seg. airSegmentFlightNumber, seg.airSegmentDuration , seg.airSegmentEquipment , seg.airSegmentMiles , seg.airSegmentDepartureDate , seg.airSegmentArrivalDate , seg.airSegmentDepartureAirport , seg.airSegmentArrivalAirport  ,normalized .airPriceBase      AS airPriceBase , airVendor.ShortName AS MarketingAirlineName ,noOFStops  ,  takeoffdate  , landingdate ,airSegmentOperatingAirlineCode , seg.airSegmentResBookDesigCode,noOfAirlines ,normalized .airlineCode , ISNULL(normalized.gdssourcekey,2) ,normalized.airpriceTax  ,airsubrequetkey ,airsegmentDepartureOffset,airSegmentArrivalOffset ,airSegmentSeatRemaining,priceClassCommentsSuperSaver ,priceClassCommentsEconSaver,
	priceClassCommentsFirstFlex ,priceClassCommentsCorporate,priceClassCommentsEconFlex,priceClassCommentsEconUpgrade,airSuperSaverPrice ,airEconSaverPrice ,airFirstFlexPrice ,airCorporatePrice ,airEconFlexPrice,airEconUpgradePrice,airClassSuperSaver,
	airClassEconSaver,airClassFirstFlex,airClassCorporate,airClassEconFlex,airClassEconUpgrade,airSuperSaverSeatRemaining,airEconSaverSeatRemaining,airFirstFlexSeatRemaining,airCorporateSeatRemaining,airEconFlexSeatRemaining,airEconUpgradeSeatRemaining, airPriceClassSelected ,   
	isnull (otherlegPrice,0)    ,refundable   ,isBrandedFare ,normalized .cabinclass ,fareType,segmentOrder ,seg.airsegmentCabin,(isnull(normalized.airPriceBase,0) + ISNULL (normalized.airpriceTax,0) ),seg.airSegmentOperatingFlightNumber,otherlegtax ,isGeneratedBundle,
	airPriceBaseSenior,airPriceTaxSenior,airPriceBaseChildren,airPriceTaxChildren,airPriceBaseInfant,airPriceTaxInfant,AirPriceBaseTotal,AirPriceTaxTotal,airPriceBaseDisplay, airPriceTaxDisplay,seg.airSegmentOperatingAirlineCompanyShortName,airPriceBaseInfantWithSeat,airPriceTaxInfantWithSeat,normalized.airlegBrandName,seg.ProgramCode
	FROM @AirSegments seg     
	INNER JOIN @normalizedResultSet normalized ON (seg.airresponsekey = normalized .airresponsekey  and seg.airLegNumber = normalized.airlegnumber  )  
	INNER JOIN #AirResponse resp WITH(NOLOCK) ON seg .airresponsekey = resp.airResponseKey   
	INNER JOIN @noStops nStop ON normalized .noOFStops = nStop .stops   
	INNER JOIN  AirVendorLookup airVendor  WITH(NOLOCK)  ON seg.airSegmentMarketingAirlineCode = airVendor  .AirlineCode    
	--STEP 13: PAGING RESULTSET BASED ON SORTFIELD AND SORTDIRECTION

	--select * from  @airResponseResultset where airResponseKey='9E08C7F1-73B2-4D2C-BC2C-099D877D5B92'
	
--IF ((@MaxFareTotal != 0) and (@IsHideFare = 1))
--BEGIN
--	IF EXISTS(SELECT 1 FROM @airResponseResultset WHERE airresponsekey IN (SELECT A.airResponseKey from @airResponseResultset A WHERE A.totalCost > @MaxFareTotal))
--	BEGIN
--	SET @isOutOfPolicyResultsPresent = 1
--	END

--	DELETE FROM @airResponseResultset 
--    WHERE airresponsekey IN (SELECT A.airResponseKey 
--							 from @airResponseResultset A 
--							  WHERE ROUND(A.totalCost,2) > ROUND(@MaxFareTotal,2))
--END


--  IF (@HighFareTotal != 0 AND @IsHighFareTotal = 1)
--	BEGIN
--	IF (@MaxFareTotal !=0)
--	BEGIN
--		UPDATE @airResponseResultset 
--		SET ReasonCode = 'High' 
--		WHERE airResponsekey IN (SELECT A.airResponseKey 
--									FROM @airResponseResultset A 
--									WHERE ROUND(A.totalCost,2) > ROUND(@HighFareTotal,2)
--									AND ROUND(A.totalCost,2) <=  ROUND(@MaxFareTotal,2))
--	END
--	ELSE
--	BEGIN
--		UPDATE @airResponseResultset 
--		SET ReasonCode = 'High' 
--		WHERE airResponsekey IN (SELECT A.airResponseKey 
--									FROM @airResponseResultset A 
--									WHERE ROUND(A.totalCost,2) > ROUND(@HighFareTotal,2))
--	END
--END


--IF (( @IsLowFareThreshold =1) AND (@LowFareThreshold > 0))
--BEGIN
--	SELECT @LowestPrice = (CASE WHEN @isTotalPriceSort = 0 THEN (MIN (airPrice)) ELSE  min(totalcost) end ) FROM @airResponseResultset

--	if (@HighFareTotal != 0) 
--	BEGIN
--		UPDATE @airResponseResultset 
--		SET ReasonCode = 'OOP' 
--		WHERE airResponsekey IN (SELECT A.airResponseKey 
--									FROM @airResponseResultset A 
--									WHERE ROUND(A.totalCost,2) > ROUND((@LowestPrice + @LowFareThreshold),2)
--									AND ROUND(A.totalCost,2) <= ROUND(@HighFareTotal,2))
--	END
--	ELSE
--	BEGIN
--		UPDATE @airResponseResultset 
--		SET ReasonCode = 'OOP' 
--		WHERE airResponsekey IN (SELECT A.airResponseKey 
--									FROM @airResponseResultset A 
--									WHERE ROUND(A.totalCost,2) > ROUND((@LowestPrice + @LowFareThreshold),2))
--	END
--END

	--Policy Implementation - start
IF (@IsPolicyApplicable = 1)
BEGIN
	--Hide
	IF ((@MaxFareTotal != 0) and (@IsHideFare = 1))
	BEGIN
		IF EXISTS(SELECT 1 FROM @airResponseResultset  WHERE airresponsekey IN (SELECT A.airResponseKey from @airResponseResultset  A WHERE A.totalCost > @MaxFareTotal))
		BEGIN
		SET @isOutOfPolicyResultsPresent = 1
		END
		DELETE FROM @airResponseResultset 
		WHERE airresponsekey IN (SELECT A.airResponseKey from @airResponseResultset A WHERE ROUND(A.totalCost,2) > ROUND(@MaxFareTotal,2))
	END


	--Basic Economy
	IF (@ApplyBasicUnselectable = 1 AND @IsBasicUnselectable = 1)
	BEGIN

	print @ApplyBasicUnselectable
	print @IsBasicUnselectable
		UPDATE @airResponseResultset 
		SET IsSuppressed = 1
		WHERE airResponsekey IN (SELECT A.airResponseKey 
									FROM @airResponseResultset A 
									WHERE LOWER(A.airLegBrandName) like '%basic%' OR LOWER(A.airLegBrandName) like '%wanna get away%')
	END
	ELSE IF (@ApplyBasicUnselectable = 1 AND @IsBasicUnselectable = 0)
	BEGIN
		UPDATE @airResponseResultset 
		SET ReasonCode = 'OOP' 
		WHERE airResponsekey IN (SELECT A.airResponseKey 
									FROM @airResponseResultset A 
									WHERE LOWER(A.airLegBrandName) like '%basic%' OR LOWER(A.airLegBrandName) like '%wanna get away%')
	END

	--Suppress Airline
	
	IF (@IsSuppressAirline = 1) 
	BEGIN
	    DECLARE @SuppressedAirline  TABLE (airlineCode VARCHAR (5) )  
		INSERT INTO @SuppressedAirline(airlineCode)  SELECT S.SuppressedAirlineCode FROM vault..SuppressedAirlinePolicyMapping S WHERE S.policyKey = @PolicyKey

		UPDATE @airResponseResultset 
		SET IsSuppressAirline = 1
		WHERE airResponsekey IN (SELECT A.airResponseKey 
									FROM @airResponseResultset A 
									WHERE LTRIM(RTRIM(A.airSegmentMarketingAirlineCode)) IN (SELECT airlineCode FROM @SuppressedAirline))
	END

	
	--Allow Business on long flights
	IF (@IsBussinessClassAllowed = 1 AND @IsBusinessLongFlightsUnselectable = 1)
	BEGIN
		UPDATE @airResponseResultset 
		SET IsSuppressed = 1
		WHERE airResponseKey NOT IN ( SELECT A.airResponseKey 
									 FROM @airResponseResultset A 
  									WHERE lower(A.airLegBrandName) = 'business' 
									--WHERE lower(A.airsegmentCabin) = 'business' 
									--AND  DATEDIFF( MINUTE , DATEADD( MINUTE, (@departureOffset*-1),A.airSegmentDepartureDate ), DATEADD( MINUTE, (@arrivalOffset*-1), A.airSegmentArrivalDate)) > (@BusinessClassOverHrs * (60))
									  AND  ABS(DATEDIFF( MINUTE , DATEADD( HOUR, (A.airsegmentDepartureOffset *-1),A.airSegmentDepartureDate ), DATEADD( HOUR, (A.airSegmentArrivalOffset *-1), A.airSegmentArrivalDate))) > (@BusinessClassOverHrs* (60) )
									)
    	AND lower(airLegBrandName) = 'business'
	END
	ELSE IF(@IsBussinessClassAllowed = 1 AND @IsBusinessLongFlightsUnselectable = 0)
	BEGIN
		UPDATE @airResponseResultset 
		SET ReasonCode = 'OOP' 
		WHERE airResponseKey NOT IN ( SELECT A.airResponseKey 
									 FROM @airResponseResultset A 
  									WHERE lower(A.airLegBrandName) = 'business' 
									--WHERE lower(A.airsegmentCabin) = 'business' 
									--AND  DATEDIFF( MINUTE , DATEADD( MINUTE, (@departureOffset*-1),A.airSegmentDepartureDate ), DATEADD( MINUTE, (@arrivalOffset*-1), A.airSegmentArrivalDate)) > (@BusinessClassOverHrs * (60))
									AND  ABS(DATEDIFF( MINUTE , DATEADD( HOUR, (A.airsegmentDepartureOffset *-1),A.airSegmentDepartureDate ), DATEADD( HOUR, (A.airSegmentArrivalOffset *-1), A.airSegmentArrivalDate))) > (@BusinessClassOverHrs* (60) )
									)
    	AND lower(airLegBrandName) = 'business'
	END

	
	--Allow First on long flights
	IF (@IsFirstClassAllowed = 1 AND @IsFirstLongFlightsUnselectable = 1)
	BEGIN
		UPDATE @airResponseResultset 
		SET IsSuppressed = 1
		WHERE airResponsekey NOT IN (SELECT A.airResponseKey 
									FROM @airResponseResultset A 
									WHERE lower(A.airsegmentCabin) = 'first' 
									--WHERE lower(A.airLegBrandName) = 'first' 
									--AND DATEDIFF( MINUTE , DATEADD( MINUTE, (@departureOffset*-1),A.airSegmentDepartureDate ), DATEADD( MINUTE, (@arrivalOffset*-1), A.airSegmentArrivalDate)) > (@FirstClassOverHrs * (60))
									AND  ABS(DATEDIFF( MINUTE , DATEADD( HOUR, (A.airsegmentDepartureOffset *-1),A.airSegmentDepartureDate ), DATEADD( HOUR, (A.airSegmentArrivalOffset *-1), A.airSegmentArrivalDate))) > (@FirstClassOverHrs * (60) )
									)
	  AND lower(airLegBrandName) = 'first'
	END
	ELSE IF(@IsFirstClassAllowed = 1 AND @IsFirstLongFlightsUnselectable = 0)
	BEGIN
		UPDATE @airResponseResultset 
		SET ReasonCode = 'OOP' 
		WHERE airResponsekey IN (SELECT A.airResponseKey 
									FROM @airResponseResultset A 
									WHERE lower(A.airsegmentCabin) = 'first' 
									--WHERE lower(A.airLegBrandName) = 'first' 
									--AND DATEDIFF( MINUTE , DATEADD( MINUTE, (@departureOffset*-1),A.airSegmentDepartureDate ), DATEADD( MINUTE, (@arrivalOffset*-1), A.airSegmentArrivalDate)) > (@FirstClassOverHrs * (60))
									AND  ABS(DATEDIFF( MINUTE , DATEADD( HOUR, (A.airsegmentDepartureOffset *-1),A.airSegmentDepartureDate ), DATEADD( HOUR, (A.airSegmentArrivalOffset *-1), A.airSegmentArrivalDate))) > (@FirstClassOverHrs * (60))
									)
	 AND lower(airLegBrandName) = 'first'
	END

		--High
	IF (@HighFareTotal != 0 AND @IsHighFareTotal = 1)
	BEGIN
	IF (@MaxFareTotal !=0)
	BEGIN
		UPDATE @airResponseResultset 
		SET ReasonCode = 'High' 
		WHERE airResponsekey IN (SELECT A.airResponseKey 
									FROM @airResponseResultset A 
									WHERE ROUND(A.totalCost,2) > ROUND(@HighFareTotal,2)
									AND ROUND(A.totalCost,2) <=  ROUND(@MaxFareTotal,2))
	END
	ELSE
	BEGIN
		UPDATE @airResponseResultset 
		SET ReasonCode = 'High' 
		WHERE airResponsekey IN (SELECT A.airResponseKey 
									FROM @airResponseResultset A 
									WHERE ROUND(A.totalCost,2) > ROUND(@HighFareTotal,2))
	END
END
    --OOP
	IF (( @IsLowFareThreshold =1) AND (@LowFareThreshold > 0))
	BEGIN
		SELECT @LowestPrice = (CASE WHEN @isTotalPriceSort = 0 THEN (MIN (airPrice)) ELSE  min(totalcost) end ) FROM @airResponseResultset

		if (@HighFareTotal != 0) 
		BEGIN
			UPDATE @airResponseResultset 
			SET ReasonCode = 'OOP' 
			WHERE airResponsekey IN (SELECT A.airResponseKey 
										FROM @airResponseResultset A 
										WHERE ROUND(A.totalCost,2) > ROUND((@LowestPrice + @LowFareThreshold),2)
										AND ROUND(A.totalCost,2) <= ROUND(@HighFareTotal,2))
		END
		ELSE
		BEGIN
			UPDATE @airResponseResultset 
			SET ReasonCode = 'OOP' 
			WHERE airResponsekey IN (SELECT A.airResponseKey 
										FROM @airResponseResultset A 
										WHERE ROUND(A.totalCost,2) > ROUND((@LowestPrice + @LowFareThreshold),2))
		END
	END
		
	--Advance Purchase
	IF (( @isAdvancePurchase =1 AND @IsflagAdvancePurchase = 1) AND (@AdvancePurchaseDays > 0 AND @AdvancePurchasePrice !=0))
	BEGIN
	
		UPDATE @airResponseResultset 
		SET ReasonCode = 'OOP' 
		WHERE airResponsekey IN (SELECT A.airResponseKey 
									FROM @airResponseResultset A 
									WHERE ROUND(A.totalCost,2) >= ROUND(@AdvancePurchasePrice,2)
									AND DATEDIFF(dd,getdate(),@TripFromDate) < ROUND(@AdvancePurchaseDays,2))
	END
END
	--Policy Implementation - end
	


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
	END


   ---UNNECESSARY CODE -NEED TO REMOVE START HERE
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
	   ---UNNECESSARY CODE -NEED TO REMOVE END HERE
	/**STEP14 MAIN RESULTSET FOR LIST STARTS HERE
   Create table  #SortedResultSet   
(  
    [rowNum] [int] NOT NULL,
	[airSegmentKey] [uniqueidentifier] NULL,
	[airResponseKey] [uniqueidentifier] NULL,
	[airLegNumber] [int] NULL,
	[airSegmentMarketingAirlineCode] [varchar](10) NULL,
	[airSegmentFlightNumber] [varchar](50) NULL,
	[airSegmentDuration] [time](7) NULL,
	[airSegmentEquipment] [varchar](50) NULL,
	[airSegmentMiles] [int] NULL,
	[airSegmentDepartureDate] [datetime] NULL,
	[airSegmentArrivalDate] [datetime] NULL,
	[airSegmentDepartureAirport] [varchar](50) NULL,
	[airSegmentArrivalAirport] [varchar](50) NULL,
	[airPrice] [float] NULL,
	[airPriceTax] [float] NULL,
	[airPriceBaseSenior] [float] NULL,
	[airPriceTaxSenior] [float] NULL,
	[airPriceBaseChildren] [float] NULL,
	[airPriceTaxChildren] [float] NULL,
	[airPriceBaseInfant] [float] NULL,
	[airPriceTaxInfant] [float] NULL,
	[airPriceBaseYouth] [float] NULL,
	[airPriceTaxYouth] [float] NULL,
	[AirPriceBaseTotal] [float] NULL,
	[AirPriceTaxTotal] [float] NULL,
	[airPriceBaseDisplay] [float] NULL,
	[airPriceTaxDisplay] [float] NULL,
	[airRequestKey] [int] NULL,
	[gdsSourceKey] [int] NULL,
	[MarketingAirlineName] [varchar](50) NULL,
	[NoOfStops] [int] NULL,
	[actualTakeOffDateForLeg] [datetime] NULL,
	[actualLandingDateForLeg] [datetime] NULL,
	[airSegmentOperatingAirlineCode] [varchar](10) NULL,
	[airSegmentResBookDesigCode] [varchar](3) NULL,
	[noofAirlines] [int] NULL,
	[airlineName] [varchar](50) NULL,
	[airsegmentDepartureOffset] [float] NULL,
	[airSegmentArrivalOffset] [float] NULL,
	[airSegmentSeatRemaining] [int] NULL,
	[priceClassCommentsSuperSaver] [varchar](500) NULL,
	[priceClassCommentsEconSaver] [varchar](500) NULL,
	[priceClassCommentsFirstFlex] [varchar](500) NULL,
	[priceClassCommentsCorporate] [varchar](500) NULL,
	[priceClassCommentsEconFlex] [varchar](500) NULL,
	[priceClassCommentsEconUpgrade] [varchar](500) NULL,
	[airSuperSaverPrice] [float] NULL,
	[airEconSaverPrice] [float] NULL,
	[airFirstFlexPrice] [float] NULL,
	[airCorporatePrice] [float] NULL,
	[airEconFlexPrice] [float] NULL,
	[airEconUpgradePrice] [float] NULL,
	[airClassSuperSaver] [varchar](50) NULL,
	[airClassEconSaver] [varchar](50) NULL,
	[airClassFirstFlex] [varchar](50) NULL,
	[airClassCorporate] [varchar](50) NULL,
	[airClassEconFlex] [varchar](50) NULL,
	[airClassEconUpgrade] [varchar](50) NULL,
	[airSuperSaverSeatRemaining] [int] NULL,
	[airEconSaverSeatRemaining] [int] NULL,
	[airFirstFlexSeatRemaining] [int] NULL,
	[airCorporateSeatRemaining] [int] NULL,
	[airEconFlexSeatRemaining] [int] NULL,
	[airEconUpgradeSeatRemaining] [int] NULL,
	[airSuperSaverFareReferenceKey] [varchar](50) NULL,
	[airEconSaverFareReferenceKey] [varchar](50) NULL,
	[airFirstFlexFareReferenceKey] [varchar](50) NULL,
	[airCorporateFareReferenceKey] [varchar](50) NULL,
	[airEconFlexFareReferenceKey] [varchar](50) NULL,
	[airEconUpgradeFareReferenceKey] [varchar](50) NULL,
	[airPriceClassSelected] [varchar](50) NULL,
	[otherLegPrice] [float] NULL,
	[isRefundable] [bit] NULL,
	[isbrandedFare] [bit] NULL,
	[cabinClass] [varchar](20) NULL,
	[fareType] [varchar](20) NULL,
	[segmentOrder] [int] NULL,
	[airsegmentCabin] [varchar](20) NULL,
	[totalCost] [float] NULL,
	[airSegmentOperatingFlightNumber] [int] NULL,
	[otherlegtax] [float] NULL,
	[isgeneratedBundle] [bit] NULL,
	[airSegmentOperatingAirlineCompanyShortName] [varchar](100) NULL,
	[airPriceBaseInfantWithSeat] [float] NULL,
	[airPriceTaxInfantWithSeat] [float] NULL,
	[ReasonCode] NVARCHAR(10) DEFAULT 'NONE',
	[airlegBrandName] NVARCHAR(200) null,
	[ProgramCode] VARCHAR(20) NULL,
	[IsSuppressed] BIT DEFAULT 0,
    [IsSuppressAirline] BIT DEFAULT 0,
	[DepartureAirPortCityName] [varchar](64) NULL,
	[DepartureAirportStateCode] [varchar](2) NULL,
	[DepartureAirportName] [varchar](100) NULL,
	[DepartureAirportCountryCode] [varchar](2) NULL,
	[ArrivalAirPortCityName] [varchar](64) NULL,
	[ArrivalAirportStateCode] [varchar](2) NULL,
	[ArrivalAirportName] [varchar](100) NULL,
	[ArrivalAirportCountryCode] [varchar](2) NULL,
	[OperatingAirlineName] [varchar](64) NULL,
	[DepartureAirportCountryName] [varchar](128) NULL,
	[ArrivalAirportCountryName] [varchar](128) NULL,
	[multiBrandFaresInfo] xml Null
	
 )   
**/      	 
	--insert into #SortedResultSet
	SELECT distinct    rowNum,air.*,departureAirport.CityName AS DepartureAirPortCityName ,departureAirport.StateCode AS DepartureAirportStateCode ,departureAirport .AirportName AS DepartureAirportName , departureAirport.CountryCode
	AS DepartureAirportCountryCode,   
	arrivalAirport .CItyName AS ArrivalAirPortCityName ,arrivalAirport .StateCode AS ArrivalAirportStateCode , arrivalAirport .AirportName AS ArrivalAirportName ,arrivalAirport .CountryCode  AS ArrivalAirportCountryCode,  
	operatingAirline .ShortName AS OperatingAirlineName ,
	CD.CountryName AS DepartureAirportCountryName, CD.CountryName AS ArrivalAirportCountryName,convert(nvarchar(max),null) as [multiBrandFaresInfo]
into #SortedResultSet FROM @airResponseResultset air INNER JOIN @pagingResultSet  paging ON air.airResponseKey = paging.airResponseKey  
	LEFT OUTER JOIN AirVendorLookup operatingAirline    ON air .airSegmentOperatingAirlineCode = operatingAirline .AirlineCode   
	LEFT OUTER JOIN AirportLookup departureAirport   ON air .airSegmentDepartureAirport = departureAirport .AirportCode   
	LEFT OUTER JOIN AirportLookup arrivalAirport    ON air .airSegmentArrivalAirport =arrivalAirport .AirportCode   
	LEFT OUTER JOIN Vault..CountryLookup CD  WITH (NOLOCK)  ON departureAirport.CountryCode = CD.CountryCode
	and arrivalAirport.CountryCode = CD.CountryCode
	--LEFT OUTER JOIN Vault..CountryLookup CA WITH (NOLOCK)  ON arrivalAirport.CountryCode = CA.CountryCode
	order by rowNum ,airLegNumber ,segmentOrder, airSegmentDepartureDate  
	option(maxdop 2)
	alter table #SortedResultSet
	alter column [multiBrandFaresInfo] xml
	
	--policy implementation - start
	IF (@IsPolicyApplicable = 1)
BEGIN
IF ((@MaxFareTotal != 0) and (@IsHideFare = 1))
		BEGIN
			DELETE FROM #AdditionalFares 
			WHERE Round((TotalPriceToDisplay),2) > Round((@MaxFareTotal),2)
		END
		
		IF (@ApplyBasicUnselectable = 1 AND @IsBasicUnselectable = 1)
		BEGIN
			UPDATE #AdditionalFares 
			SET IsSuppressed = 1
			WHERE (LOWER(airLegBrandName) like '%basic%' OR LOWER(airLegBrandName) like '%wanna get away%')
		END
		ELSE IF (@ApplyBasicUnselectable = 1 AND @IsBasicUnselectable = 0)
		BEGIN
			UPDATE #AdditionalFares 
			SET ReasonCode = 'OOP' 
			WHERE (LOWER(airLegBrandName) like '%basic%' OR LOWER(airLegBrandName) like '%wanna get away%')
		END

	
		--Allow Business on long flights
		IF (@IsBussinessClassAllowed = 1 AND @IsBusinessLongFlightsUnselectable = 1)
	BEGIN
			UPDATE #AdditionalFares 
			SET IsSuppressed = 1
			WHERE airResponseKey not in ( SELECT airResponseKey 
									FROM @airResponseResultset A 
									WHERE (A.airResponseKey = airResponseKey 
									--AND  ABS(DATEDIFF( HOUR , DATEADD( HOUR, (@departureOffset*-1),A.airSegmentDepartureDate ), DATEADD( HOUR, (@arrivalOffset*-1), A.airSegmentArrivalDate))) > (@BusinessClassOverHrs ))
									AND  ABS(DATEDIFF( MINUTE , DATEADD( HOUR, (ISNULL(A.airSegmentDepartureOffset,@departureOffset) *-1),A.airSegmentDepartureDate ), DATEADD( HOUR, (ISNULL(A.airSegmentArrivalOffset,@arrivalOffset) *-1), A.airSegmentArrivalDate))) > (@BusinessClassOverHrs * (60) ))
									)
			AND (lower(airLegBrandName) = 'business' OR lower(airLegBrandName) = 'select')

	END
	ELSE IF(@IsBussinessClassAllowed = 1 AND @IsBusinessLongFlightsUnselectable = 0)
	BEGIN
			UPDATE #AdditionalFares 
			SET ReasonCode = 'OOP' 
			WHERE airResponseKey not in ( SELECT airResponseKey 
									FROM @airResponseResultset A 
									WHERE (A.airResponseKey = airResponseKey 
									AND  ABS(DATEDIFF( MINUTE , DATEADD( HOUR, (ISNULL(A.airSegmentDepartureOffset,@departureOffset) *-1),A.airSegmentDepartureDate ), DATEADD( HOUR, (ISNULL(A.airSegmentArrivalOffset,@arrivalOffset) *-1), A.airSegmentArrivalDate))) > (@BusinessClassOverHrs * (60) ))
									)
			AND (lower(airLegBrandName) = 'business' OR lower(airLegBrandName) = 'select')

	END

		----Allow First on long flights
		IF (@IsFirstClassAllowed = 1 AND @IsFirstLongFlightsUnselectable = 1)
	BEGIN
			UPDATE #AdditionalFares 
			SET IsSuppressed = 1
			WHERE airResponseKey not in ( SELECT airResponseKey 
									FROM @airResponseResultset A 
									WHERE (A.airResponseKey = airResponseKey 
									--AND  DATEDIFF( MINUTE , DATEADD( MINUTE, (@departureOffset*-1),A.airSegmentDepartureDate ), DATEADD( MINUTE, (@arrivalOffset*-1), A.airSegmentArrivalDate)) > (@FirstClassOverHrs * (60)))
									AND  ABS(DATEDIFF( MINUTE , DATEADD( HOUR, (ISNULL(A.airSegmentDepartureOffset,@departureOffset) *-1),A.airSegmentDepartureDate ), DATEADD( HOUR, (ISNULL(A.airSegmentArrivalOffset,@arrivalOffset) *-1), A.airSegmentArrivalDate))) > (@FirstClassOverHrs * (60) ))
									)
			AND (lower(airLegBrandName) = 'first')

	END
	ELSE IF(@IsFirstClassAllowed = 1 AND @IsFirstLongFlightsUnselectable = 0)
	BEGIN
			UPDATE #AdditionalFares 
			SET ReasonCode = 'OOP' 
			WHERE airResponseKey not in ( SELECT airResponseKey 
									FROM @airResponseResultset A 
									WHERE (A.airResponseKey = airResponseKey 
									--AND  DATEDIFF( MINUTE , DATEADD( MINUTE, (@departureOffset*-1),A.airSegmentDepartureDate ), DATEADD( MINUTE, (@arrivalOffset*-1), A.airSegmentArrivalDate)) > (@FirstClassOverHrs * (60)))
									AND  ABS(DATEDIFF( MINUTE , DATEADD( HOUR, (ISNULL(A.airSegmentDepartureOffset,@departureOffset) *-1),A.airSegmentDepartureDate ), DATEADD( HOUR, (ISNULL(A.airSegmentArrivalOffset,@arrivalOffset) *-1), A.airSegmentArrivalDate))) > (@FirstClassOverHrs * (60) ))
									)
			AND (lower(airLegBrandName) = 'first' )

	END

		IF (@HighFareTotal != 0 AND @IsHighFareTotal = 1 )
		BEGIN
			IF (@MaxFareTotal !=0)
			BEGIN
				UPDATE #AdditionalFares 
				SET ReasonCode = 'High' 
				WHERE (ROUND(TotalPriceToDisplay,2) > ROUND(@HighFareTotal,2)  
				AND ROUND(TotalPriceToDisplay,2) <= ROUND(@MaxFareTotal,2))
			END
			ELSE
			BEGIN
				UPDATE #AdditionalFares 
				SET ReasonCode = 'High' 
				WHERE (ROUND(TotalPriceToDisplay,2) > ROUND(@HighFareTotal,2))
			END
		END

		IF (( @IsLowFareThreshold =1) AND (@LowFareThreshold > 0))
		BEGIN
		
			SELECT @LowestPrice = (CASE WHEN @isTotalPriceSort = 0 THEN (MIN (airPrice)) ELSE  min(totalcost) end ) FROM @airResponseResultset
			IF (@HighFareTotal != 0)
			BEGIN
				UPDATE #AdditionalFares 
				SET ReasonCode = 'OOP' 
				WHERE (ROUND(TotalPriceToDisplay,2) > ROUND((@LowestPrice + @LowFareThreshold),2)
				AND ROUND(TotalPriceToDisplay,2) <= ROUND(@HighFareTotal,2))

			END
			ELSE
			BEGIN
				UPDATE #AdditionalFares 
				SET ReasonCode = 'OOP' 
				WHERE (ROUND(TotalPriceToDisplay,2) > ROUND((@LowestPrice + @LowFareThreshold),2))
			END
		END

		IF (( @isAdvancePurchase =1 AND @IsflagAdvancePurchase = 1) AND (@AdvancePurchaseDays > 0 AND @AdvancePurchasePrice !=0))
		BEGIN

		UPDATE #AdditionalFares 
		SET ReasonCode = 'OOP' 
		WHERE (ROUND(TotalPriceToDisplay,2) > ROUND(@AdvancePurchasePrice,2)
									AND DATEDIFF(dd,getdate(),@TripFromDate) < ROUND(@AdvancePurchaseDays,2))
		END

END

	--policy implementation - end

	--select multiBrandFaresInfo from #SortedResultSet A
	--select (SELECT airresponseMultiBrandkey,airLegBrandName,TotalPriceToDisplay,childresponsekey,isRefundable,ReasonCode,airResBookDesigCode, IsSuppressed,airRequestKey
	--FROM #tmp_AdditionalFares A
	--FOR XML PATH('AdditionalFare'), ROOT('AdditionalFaresInfo')
	--) as nm
	--update #SortedResultSet 
	--SET multiBrandFaresInfo = (
	--SELECT airresponseMultiBrandkey,airLegBrandName,TotalPriceToDisplay,childresponsekey,isRefundable,ReasonCode,airResBookDesigCode, IsSuppressed,airRequestKey
	--FROM #tmp_AdditionalFares A
	--where (A.airresponsekey = #SortedResultSet.airresponsekey)
	--FOR XML PATH('AdditionalFare'), ROOT('AdditionalFaresInfo')
	--)
	alter table #tmp_AdditionalFares
		alter column airresponsekey uniqueidentifier
	create clustered index IX_S on #SortedResultSet(airresponsekey)
		create clustered index IX_F on #tmp_AdditionalFares(airresponsekey)
		
	update #SortedResultSet 
	SET multiBrandFaresInfo =t1.nm
	FROM #SortedResultSet SR
	cross apply(select (SELECT airresponseMultiBrandkey,airLegBrandName,TotalPriceToDisplay,childresponsekey,isRefundable,ReasonCode,airResBookDesigCode, IsSuppressed,airRequestKey
	FROM #tmp_AdditionalFares A where (A.airresponsekey = SR.airresponsekey)
	FOR XML PATH('AdditionalFare'), ROOT('AdditionalFaresInfo')
	) as nm)t1
	
	--where (A.airresponsekey = #SortedResultSet.airresponsekey)
	--FOR XML PATH('AdditionalFare'), ROOT('AdditionalFaresInfo')
	--update #SortedResultSet 
	--SET multiBrandFaresInfo = (
	--SELECT airresponseMultiBrandkey,airLegBrandName,TotalPriceToDisplay,childresponsekey,isRefundable,ReasonCode,airResBookDesigCode, IsSuppressed,airRequestKey
	--FROM #tmp_AdditionalFares A
	--where (A.airresponsekey = #SortedResultSet.airresponsekey)
	--FOR XML PATH('AdditionalFare'), ROOT('AdditionalFaresInfo')
	--)

	--select multiBrandFaresInfo,* from #SortedResultSet
	--return

	--select 'x'
	IF(@sortField = 'Departure')
	BEGIN
		SELECT * FROM #SortedResultSet 	order by rowNum ,airLegNumber ,segmentOrder, airSegmentDepartureDate
	END
	ELSE IF(@sortField = 'Arrival')
	BEGIN
		SELECT * FROM #SortedResultSet 	order by rowNum ,airLegNumber ,segmentOrder, airSegmentArrivalDate
	END
	ELSE IF(@sortField = 'Duration')
	BEGIN
		SELECT * FROM #SortedResultSet 	order by rowNum ,airLegNumber ,segmentOrder, airSegmentDuration
	END
	ELSE
	BEGIN
		SELECT * FROM #SortedResultSet 	order by rowNum ,airLegNumber ,segmentOrder, airSegmentDepartureDate
	END

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

	/****STEP 15 MIN-MAX PRICE FOR FILTERS ***/  
	SELECT (case when @isTotalPriceSort = 0 then MIN (airPriceBaseDisplay)  else MIN (totalCost ) end ) AS LowestPrice ,  (case when @isTotalPriceSort = 0 then MAX (airPriceBaseDisplay)  else MAX (totalCost ) end ) AS HighestPrice FROM @airResponseResultset  result1   
	/****MIN-MAX PRICE FOR FILTERS END***/  
   
	/****TAKEOFF-LANDING TIME START****/  
	SELECT distinct  MIN (actualTakeOffDateForLeg ) AS MinDepartureTakeOffDate,  MAX (actualTakeOffDateForLeg) AS MaxDepartureTakeOffDate, MIN (actualLandingDateForLeg) AS MinDepartureLandingDate,  MAX (actualLandingDateForLeg) AS MaxDepartureLandingDate   
	FROM @airResponseResultset    
	/****TAKEOFF-LANDING TIME END****/  
   
	/* STEP 16Stops for Slider START*/  
	SELECT distinct NoOfStops AS NoOfStops  FROM @airResponseResultset      
	/* Stops for Slider END*/  
  
	/******STEP 17 TOTAL RECORD COUNT FOUND START *********/  
    SELECT COUNT(*) AS [TotalCount] FROM @pagingResultSet   

	IF EXISTS(SELECT 1 FROM @pagingResultSet)
    BEGIN
       SET @isOutOfPolicyResultsPresent = 0
    END

	/******TOTAL RECORD COUNT FOUND END *********/   
	IF @airLines <> '' and @isIgnoreAirlineFilter = 1    
	BEGIN  
		delete from @tmpAirline    
		INSERT into @tmpAirline(airlineCode)    SELECT * FROM vault.dbo.ufn_CSVToTable (@airLines )    
	END  
	   
	/*** MATRIX LOGIC START HERE ***/  
	if ( SELECT COUNT (*) FROM @tmpAirline) > 1    
	BEGIN   
		SELECT (case when @isTotalPriceSort = 0 then MIN (airPriceBaseDisplay)  else MIN (totalCost ) end )AS LowestPrice ,ISNULL (ShortName,'Multiple Airlines')AS MarketingAirlineName ,airlineName AS airSegmentMarketingAirlineCode,
		vendor.IsSeatChooseAvailable FROM @airResponseResultset air  
		INNER JOIN @normalizedResultSet n ON air.airResponseKey = n.airresponsekey   
		INNER JOIN @tmpAirline tmp ON n.airlineCode = tmp.airLineCode   
		LEFT OUTER JOIN AirVendorLookup vendor ON air.airlineName = vendor .AirlineCode   
		GROUP BY airlineName ,ShortName ,vendor.IsSeatChooseAvailable
	END   
	ELSE   
	BEGIN    
		SELECT (case when @isTotalPriceSort = 0 then MIN (airPriceBaseDisplay)  else MIN (totalCost ) end )AS LowestPrice ,ISNULL (ShortName,'Multiple Airlines')AS MarketingAirlineName ,airlineName AS airSegmentMarketingAirlineCode,
		vendor.IsSeatChooseAvailable FROM @airResponseResultset air  
		INNER JOIN @normalizedResultSet n ON air.airResponseKey = n.airresponsekey   
		LEFT OUTER JOIN AirVendorLookup vendor ON air.airlineName = vendor .AirlineCode   
		GROUP BY airlineName ,ShortName ,vendor.IsSeatChooseAvailable  
	END   
	print(@noOfLegsForRequest)  
	print(@noOfLegsForRequest)  
	DECLARE @markettingAirline AS varchar(100)  
	DECLARE @noOFDrillDownCount as int   

SELECT @isExcludeAirlinesPresent AS IsExcludeAirlinesAvailable
SELECT @isExcludeCountryPresent AS IsExcludeCountryAvailable
SELECT @isOutOfPolicyResultsPresent	AS IsOutOfPolicyResultsPresent


DROP TABLE #normal

DROP TABLE #tmp_normal

DROP TABLE #AdditionalFares

DROP TABLE #tmp_AdditionalFares

DROP TABLE #ResultToMergeResponseKey
IF OBJECT_ID('TEMPDB..#AirResponse') IS NOT NULL
		DROP TABLE #AirResponse
IF OBJECT_ID('TEMPDB..#NormalizedAirResponses') IS NOT NULL
		DROP TABLE #NormalizedAirResponses
IF OBJECT_ID('TEMPDB..#Airsegments') IS NOT NULL
		DROP TABLE #Airsegments
IF OBJECT_ID('TEMPDB..#AirResponseMultiBrand') IS NOT NULL
		DROP TABLE #AirResponseMultiBrand
IF OBJECT_ID('TEMPDB..#NormalizedAirResponsesMultiBrand') IS NOT NULL
		DROP TABLE #NormalizedAirResponsesMultiBrand
IF OBJECT_ID('TEMPDB..#AirSegmentsMultiBrand') IS NOT NULL
		DROP TABLE #AirSegmentsMultiBrand
IF OBJECT_ID('TEMPDB..#AirSubRequest') IS NOT NULL
		DROP TABLE #AirSubRequest
GO
