SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 --SELECT [dbo].[fn_GetSegmentDepArrDates]('ABADCFDE-97B3-44A9-AAD2-59EA2901D15C','ARR','2014-11-01','2015-01-31',2)
 --SELECT [dbo].[fn_GetSegmentDepArrDates]('D2ED03EF-C9F9-4108-ACD3-9D00DC9F027B','DEP','2014-11-01','2015-12-31',2)
 --SELECT [dbo].[fn_GetSegmentDepArrDates]('D2ED03EF-C9F9-4108-ACD3-9D00DC9F027B','ARR','2014-11-01','2015-12-31',2)
 --SELECT [dbo].[fn_GetSegmentDepArrDates]('E48E6FF3-F1C5-47E5-BFA1-B67077DBF259','ARR','2014-11-01','2015-01-31',1050)
 
CREATE function [dbo].[fn_GetSegmentDepArrDates]
( 
	@airresponsekey AS UNIQUEIDENTIFIER
	,@Dep_Arr VARCHAR(15)
	,@tripStartDate datetime 
	,@tripEndDate datetime 
	,@meetingCodeKey INT
)  
RETURNS VARCHAR (4000)   
AS BEGIN
	
	DECLARE @Results VARCHAR(MAX),  @TripDest VARCHAR (MAX)
	SELECT @Results = '',  @TripDest = '' 

	DECLARE @tmp AS TABLE (RN INT,airSegmentDepartureDate datetime, airSegmentArrivalAirport VARCHAR(3))
	DECLARE @RN_MIN INT
	DECLARE @RN_MAX INT
	
	INSERT INTO @tmp
	SELECT ROW_NUMBER() OVER (PARTITION BY TAS.airResponseKey ORDER BY tripAirSegmentKey) rn, 
		TAS.airSegmentDepartureDate, TAS.airSegmentArrivalAirport 
	FROM TripAirSegments TAS
		INNER JOIN TripAirLegs legs ON (TAS.tripAirLegsKey = TAS.tripAirLegsKey AND TAS.airResponseKey = legs.airResponseKey 
			AND TAS.airLegNumber = legs.airLegNumber)
	WHERE TAS.airResponseKey = @airresponsekey AND ISNULL (TAS.ISDELETED,0) = 0 AND ISNULL (legs.ISDELETED,0) = 0 
		AND airSegmentDepartureDate BETWEEN @tripStartDate AND @tripEndDate AND airSegmentArrivalDate BETWEEN @tripStartDate AND @tripEndDate
	ORDER BY tripAirSegmentKey
	
	DECLARE @airRequestTypeKey INT
	SELECT @airRequestTypeKey = AR.airRequestTypeKey  
	FROM AirRequest AR
		INNER JOIN TripRequest_air TRA ON AR.airRequestKey = TRA.airRequestKey 
		INNER JOIN Trip T ON TRA.tripRequestKey = T.tripRequestKey 
		INNER JOIN TripAirResponse TAR ON T.tripPurchasedKey = TAR.tripGUIDKey AND TAR.airResponseKey = @airresponsekey
	SELECT @TripDest = meetingAirportCd FROM vault..Meeting	WHERE meetingCodeKey = @meetingCodeKey

	SELECT @RN_MIN = MIN(RN) FROM @tmp WHERE airSegmentArrivalAirport IN (SELECT * FROM ufn_DelimiterToTable(@TripDest, ','))
	SELECT @RN_MAX = MAX(RN) FROM @tmp WHERE airSegmentArrivalAirport IN (SELECT * FROM ufn_DelimiterToTable(@TripDest, ','))

	IF @Dep_Arr = 'DEP'					---Outbound Date
	BEGIN
		IF @airRequestTypeKey = 3		---Multicity Trip
			BEGIN
				SELECT @Results = CONVERT(DATE, MAX(inQ.airSegmentDepartureDate), 103)
				FROM 
				(
				 SELECT rn,airSegmentDepartureDate
				 FROM @tmp
					)inQ WHERE rn=@RN_MIN
			END
		ELSE							---OneWay & RoundTrip
			BEGIN
				SELECT @Results = CONVERT(DATE, MAX(TAS.airSegmentDepartureDate), 103)
				FROM TripAirSegments  TAS
					INNER JOIN TripAirLegs legs ON ( TAS.tripAirLegsKey = TAS.tripAirLegsKey AND TAS.airResponseKey = legs.airResponseKey 
						   AND TAS.airLegNumber = legs.airLegNumber  )
				WHERE TAS.airResponseKey = @airresponsekey AND ISNULL (TAS.ISDELETED,0) = 0 AND ISNULL (legs.ISDELETED,0) = 0 
					AND TAS.airLegNumber = 1
			END
	END
	ELSE								---Inbound Date
	BEGIN
		IF @airRequestTypeKey = 3		---Multicity Trip
			BEGIN
				--IF @RN_MIN=@RN_MAX
				--	BEGIN
					SELECT @Results = CONVERT(DATE, MIN(inQ.airSegmentDepartureDate), 103)
					FROM 
					(
					SELECT rn,airSegmentDepartureDate
					FROM @tmp
						)inQ WHERE rn = @RN_MIN+1
					--END
				--ELSE IF @RN_MAX IS Null
				--	BEGIN
				--	SELECT @Results = CONVERT(DATE, MIN(inQ.airSegmentDepartureDate), 103)
				--	FROM 
				--	(
				--	SELECT rn,airSegmentDepartureDate
				--	FROM @tmp
				--		)inQ WHERE rn =@RN_MIN+1
				--	END
				
			END
		ELSE							---OneWay & RoundTrip
			BEGIN
				SELECT @Results = CONVERT(DATE, MIN(TAS.airSegmentDepartureDate), 103)
				FROM TripAirSegments  TAS
					INNER JOIN TripAirLegs legs ON ( TAS.tripAirLegsKey = TAS.tripAirLegsKey AND TAS.airResponseKey = legs.airResponseKey 
						   AND TAS.airLegNumber = legs.airLegNumber  )
				WHERE TAS.airResponseKey = @airresponsekey AND ISNULL (TAS.ISDELETED,0) = 0 AND ISNULL (legs.ISDELETED,0) = 0 
					AND TAS.airLegNumber = 2
			END
	END
	
	RETURN( @Results  )
END
GO
