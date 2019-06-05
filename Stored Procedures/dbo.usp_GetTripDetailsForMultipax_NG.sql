SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
  
--exec [usp_GetTripDetailsForMultipax] 34849,0  
CREATE PROCEDURE [dbo].[usp_GetTripDetailsForMultipax_NG] ( 
--DECLARE  
 @tripID   int   ,                          
 @tripRequestID Int = 0                          
) as                            
  
--SELECT  @tripId=133059,@tripRequestId=1026095 
--SELECT @tripId=133058,@tripRequestId=1026093
  
BEGIN                          
	                          
	DECLARE @TripPurchasedKey UNIQUEIDENTIFIER, @TripStatusKey INT  
	SELECT @TripPurchasedKey = tripPurchasedKey, @TripStatusKey = tripStatusKey  FROM Trip WHERE tripKey = @tripId  
	  
	DECLARE @tblTrip as table                          
	(                          
	 tripKey int,                          
	 RequestKey int,              
	 statusKey int,
	 userKey INT                          
	)                          
--SELECT '1', GETDATE()
	if(@tripRequestID is Null  or @tripRequestID = 0 )                           
	BEGIN                          
		 INSERT Into @tblTrip                          
		 Select  @tripID, tripRequestKey, tripStatusKey, userKey from Trip WITH(NOLOCK) where tripKey  = @tripID and   tripStatusKey <>17 
	END                          
	ELSE                           
	BEGIN                          
		 INSERT Into @tblTrip                          
		 Select  tripKey ,  tripRequestKey, tripStatusKey, userKey from Trip WITH(NOLOCK) 
		 where tripRequestKey  = @tripRequestID  and   tripStatusKey <>17                        
	END       

--SELECT '2', GETDATE()	    
	Declare @tblUser as table                          
	(                          
	 UserKey Int,                          
	 UserFirst_Name nvarchar(200),                          
	 UserLast_Name nvarchar(200),                          
	 User_Login nvarchar(50) ,                          
	 companyKey int,  
	 ReceiptEmail nvarchar(100)  
	)                          
	  
	Insert into @tblUser                           
	Select distinct U.userKey , LTRIM(RTRIM(U.userFirstName)) userFirstName , LTRIM(RTRIM(U.userLastName)) userLastName 
		, U.userLogin  ,U.companyKey, UP.ReceiptEmail                           
	From @tblTrip tt
		INNER JOIN Vault.dbo.[User] U  WITH(NOLOCK) ON tt.userKey = U.userKey 
	 --inner join Trip T WITH(NOLOCK) on  U.userKey = T.userKey  and   T.tripStatusKey <>17                         
	 inner join Vault.dbo.UserProfile UP WITH(NOLOCK) ON U.userKey = UP.userKey  
--SELECT '3', GETDATE()
	                          
	select Trip.*, vault.dbo.Agency .agencyKey As Agency_ID, U.* 
	from Trip                           
	inner join vault.dbo.Agency WITH(NOLOCK) on trip.agencyKey = Agency .agencyKey                           
	Left Outer join @tblUser U  on Trip.userKey = U.UserKey                           
	Inner join @tblTrip tt on tt.tripKey = Trip.tripKey    and   Trip.tripStatusKey <>17                            
	Order by tripKey                           
--SELECT '4', GETDATE()
	  
	select TPI.TripPassengerInfoKey,TPI.TripKey,TPI.PassengerKey,PassengerTypeKey,IsPrimaryPassenger  
	,PassengerEmailID,LTRIM(RTRIM(PassengerFirstName)) PassengerFirstName,LTRIM(RTRIM(PassengerLastName)) PassengerLastName,PassengerLocale,PassengerTitle  
	,PassengerGender,PassengerBirthDate,TravelReferenceNo,PassengerRedressNo  
	PassengerKnownTravellerNo,IsExcludePricingInfo from TripPassengerInfo TPI WITH(NOLOCK)                           
	  Inner join @tblTrip tt on tt.tripKey = TPI.tripKey                            
	  WHERE    TPI.Active = 1  
	  ORDER by PassengerTypeKey                     
--SELECT '5', GETDATE()

	/*Getting Add Collect Amount From Trip Ticket Info table*/                    
	DECLARE @AddCollectAmount FLOAT,@ExchangeFee Float  
	SET @AddCollectAmount = 0   
	Set @ExchangeFee = 0       
	        
	--SELECT TOP 1 @AddCollectAmount = AddCollectFare + serviceCharge FROM TripTicketInfo TTI         
	--INNER JOIN @tblTrip tt ON tt.tripKey = TTI.tripKey WHERE IsExchanged = 1 AND tt.statusKey = 12        
	--ORDER BY tripTicketInfoKey Desc        
	  
	SELECT TOP 1 @AddCollectAmount = TotalFare,@ExchangeFee = ExchangeFee FROM TripTicketInfo TTI         
	INNER JOIN @tblTrip tt ON tt.tripKey = TTI.tripKey WHERE IsExchanged = 1 AND tt.statusKey = 12        
	ORDER BY tripTicketInfoKey Desc     
	---------------------------------------------  
--SELECT '6', GETDATE()
	                          
	SELECT            
	DISTINCT T.tripKey ,                          
		   t.tripRequestKey ,                     
	segments.tripAirSegmentKey,                    
	segments.airSegmentKey,                    
	segments.tripAirLegsKey,                    
	--segments.airResponseKey,                    
	segments.airLegNumber,                    
	segments.airSegmentMarketingAirlineCode,                    
	segments.airSegmentOperatingAirlineCode,                    
	segments.airSegmentFlightNumber,                    
	segments.airSegmentDuration,    
	segments.airSegmentMiles,                    
	segments.airSegmentDepartureDate,                    
	segments.airSegmentArrivalDate,                    
	segments.airSegmentDepartureAirport,                    
	segments.airSegmentArrivalAirport,                    
	segments.airSegmentResBookDesigCode,                    
	segments.airSegmentDepartureOffset,                    
	segments.airSegmentArrivalOffset,         
	(case when AircraftsLookup.AircraftName IS NULL then airSegmentEquipment else AircraftsLookup.AircraftName end) as airSegmentEquipment,                               
	segments.airSegmentSeatRemaining,                    
	segments.airSegmentMarriageGrp,                    
	segments.airFareBasisCode,                    
	segments.airFareReferenceKey,                    
	segments.airSelectedSeatNumber,                    
	segments.ticketNumber,                    
	segments.airsegmentcabin,                    
	segments.recordLocator as SegRecordLocator,                       
	segments.airSegmentOperatingAirlineCompanyShortName      
	,legs.gdsSourceKey ,                            
	departureAirport.AirportName  as departureAirportName ,                            
	departureAirport.CityCode as departureAirportCityCode,departureAirport.CityName as departureAirportCityName,departureAirport.StateCode   as departureAirportStateCode                             
	,departureAirport.CountryCode as departureAirportCountryCode,                            
	arrivalAirport.AirportName  as arrivalAirportName ,arrivalAirport.CityCode as arrivalAirportCityCode,arrivalAirport.CityName as arrivalAirportCityName,                            
	arrivalAirport.StateCode  as arrivalAirportStateCode ,arrivalAirport.CountryCode as arrivalAirportCountryCode,                            
	legs.recordLocator ,   
	--AirResp.actualAirPrice ,    
	--AirResp.actualAirTax ,  
	--AirResp.airResponseKey ,  
	ISNULL (airven.ShortName,segments.airSegmentMarketingAirlineCode ) as MarketingAirLine,airSegmentOperatingAirlineCode  ,    
	AirResp.CurrencyCodeKey as CurrencyCode,                          
	ISNULL (airOperatingven.ShortName,segments.airSegmentOperatingAirlineCode ) as OperatingAirLine,                  isnull(airSelectedSeatNumber,0)  as SeatNumber  ,   
	segments.ticketNumber as TicketNumber ,  
	segments.airsegmentcabin as airsegmentcabin,  
	--AirResp.isExpenseAdded,                        
	ISNULL(t.deniedReason,'') as deniedReason,   
	t.CreatedDate ,  
	segments.airSegmentOperatingFlightNumber ,  
	--airresp.bookingcharges ,  
	ISNULL(seatMapStatus,'') AS seatMapStatus,   
	  
	@AddCollectAmount AS AddCollectAmount,  
	@ExchangeFee as ExchangeBookingFee,                 
	 G.AgentURL     ,   
	  
	 segments.RPH ,  
	 segments.ArrivalTerminal ,  
	 segments.DepartureTerminal,        
	  AirResp.* ,  
	 legs.ValidatingCarrier as LegValidatingCarrier  
	--   ,TPR.RemarkFieldName                          
	--,TPR.RemarkFieldValue                          
	--,TPR.TripTypeKey                          
	--,TPR.RemarksDesc                          
	--,TPR.GeneratedType                          
	--,TPR.CreatedOn         
	               
	 from TripAirSegments  segments  WITH(NOLOCK)                           
	  inner join TripAirLegs legs  WITH(NOLOCK)                           
	   on ( segments .tripAirLegsKey = legs .tripAirLegsKey --and segments .airResponseKey = legs.airResponseKey                             
	   and segments .airLegNumber = legs .airLegNumber )                            
	  inner join TripAirResponse   AirResp  WITH(NOLOCK)                           
	   on segments .airResponseKey = AirResp .airResponseKey                              
	  inner join Trip t WITH(NOLOCK) on AirResp.tripGUIDKey  = t.tripPurchasedKey                           
	Inner join @tblTrip tt on tt.tripKey = t.tripKey                           
	  left outer join AirVendorLookup airVen  WITH(NOLOCK)                           
	   on segments .airSegmentMarketingAirlineCode =airVen .AirlineCode                             
	  left outer join AirVendorLookup airOperatingVen  WITH(NOLOCK)                            
	   on segments .airSegmentOperatingAirlineCode =airOperatingVen .AirlineCode                             
	  left outer join AirportLookup departureAirport WITH(NOLOCK)                             
	   on departureAirport .AirportCode = segments .airSegmentdepartureAirport                             
	 left outer join AirportLookup arrivalAirport WITH(NOLOCK)                            
	   on arrivalAirport.AirportCode = segments .airSegmentarrivalAirport                             
	  inner join Vault.dbo.GDSSourceLookup G WITH(NOLOCK) on G.gdsSourceKey = legs.gdsSourceKey              
	 LEFT OUTER JOIN AircraftsLookup WITH (NOLOCK) on (segments.airSegmentEquipment = AircraftsLookup.SubTypeCode AND AircraftsLookup.SubTypeCode = AircraftsLookup.AircraftCode)      
	              
	 WHERE ISNULL(LEGS.ISDELETED,0) = 0 AND ISNULL (segments.ISDELETED ,0) = 0  and   T.tripStatusKey <>17               
	 AND ISNULL (AirResp.ISDELETED ,0) = 0                                      
	 ORDER BY T.tripKey ,segments.tripAirSegmentKey , segments .airSegmentDepartureDate                             
	-- where t.tripRequestKey = @tripRequestID                               
	            
	--Commented as suggested by Hemali/Asha-New view is used            
	--select                    
	--hotel.*,GL.AgentURL from vw_TripHotelResponse hotel --commented as suggested by Asha as it was not displaying duplicate hotel                           
	--inner join trip t on hotel.tripkey = t.tripkey                             
	--Inner join @tblTrip tt on tt.tripKey = t.tripKey            
	--Inner Join vault.dbo.GDSSourceLookup GL On GL.GDSName = hotel.SupplierId            
	--Order by t.tripKey            
	--End Commented as suggested by Hemali/Asha-New view is used            
	  
--SELECT '7', GETDATE()
	     
	            
	select                  
	hotel.*,t.tripKey,GL.AgentURL,HI.SupplierImageURL,CRH.RedeemedAmount from vw_TripHotelResponseDetails hotel WITH(NOLOCK)            
	inner join trip t WITH(NOLOCK) on hotel.tripGUIDKey = t.tripPurchasedKey    and   T.tripStatusKey <>17          
	Inner join @tblTrip tt on tt.tripKey = t.tripKey           and   T.tripStatusKey <>17     
	Inner Join vault.dbo.GDSSourceLookup GL WITH(NOLOCK) On GL.GDSName = hotel.SupplierId            
	LEFT OUTER JOIN HotelContent..HotelImages HI WITH(NOLOCK) ON HI.HotelId = hotel.HotelId AND HI.ImageType = 'Exterior'           
	LEFT OUTER JOIN Loyalty..CashRewardHistory CRH WITH(NOLOCK) ON CRH.Id = T.cashRewardId  
	Order by t.tripKey            

--SELECT '8', GETDATE()
	                            
	--Select * from vw_TripCarResponse car WITH(NOLOCK) inner join                             
	--trip t WITH(NOLOCK) on car .tripkey =t.tripkey                           
	--Inner join @tblTrip tt on tt.tripKey  = t.tripKey                 
	--Inner Join vault.dbo.GDSSourceLookup GL WITH(NOLOCK) On GL.GDSName = car.SupplierId                          
	--Inner join vault.dbo.[User] U on t.userKey = U.userKey                           
	 --where t.tripRequestKey = @tripRequestID                           
	 --Order by t.tripKey                          
	  
	--SELECT T.tripKey as tripKey,* FROM vw_TripCarResponseDetails TD    
	-- INNER JOIN dbo.Trip T WITH (NOLOCK) ON TD.tripKey = T.tripKey    and   T.tripStatusKey <>17     
	-- Inner join @tblTrip tt ON tt.tripKey  = T.tripKey       and   T.tripStatusKey <>17              
	-- Inner Join vault.dbo.GDSSourceLookup GL WITH(NOLOCK) On GL.GDSName = TD.SupplierId                          
	-- UNION     
	-- SELECT T.tripKey as tripKey,* FROM vw_TripCarResponseDetails TD    
	-- INNER JOIN dbo.Trip T WITH (NOLOCK) ON TD.tripguidkey = T.tripPurchasedKey    and   T.tripStatusKey <>17     
	-- Inner join @tblTrip tt ON tt.tripKey  = T.tripKey            and   T.tripStatusKey <>17         
	-- Inner Join vault.dbo.GDSSourceLookup GL WITH(NOLOCK) On GL.GDSName = TD.SupplierId                          
	-- ORDER BY T.tripKey                  
	DECLARE @isCarExist INT 
	SELECT @isCarExist = 0
PRINT 'isCarExist'
Print @isCarExist
	
	IF(@tripRequestID IS NULL  OR @tripRequestID = 0 )
	BEGIN                          
		IF EXISTS(SELECT TR.tripKey FROM Trip T INNER JOIN TripCarResponse TR WITH (NOLOCK) ON TR.tripGUIDKey = T.tripPurchasedKey 
				WHERE T.tripKey = @tripID AND T.tripStatusKey <> 17)
		BEGIN
			SELECT @isCarExist = 1
		END
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT TR.tripKey FROM Trip T INNER JOIN TripCarResponse TR WITH (NOLOCK) ON TR.tripGUIDKey = T.tripPurchasedKey 
		WHERE T.tripRequestKey = @tripRequestID AND T.tripStatusKey <> 17)
		BEGIN
			SELECT @isCarExist = 1
		END
	END

PRINT 'isCarExist'
Print @isCarExist
	
	IF @isCarExist = 1
	BEGIN
PRINT 'Inside @isCarExist = 1'	    
		SELECT T.tripKey, TD.recordLocator, TD.carResponseKey, confirmationNumber, carVendorKey, supplierId, carCategoryCode, carLocationCode, carLocationCategoryCode  
		 , PerDayRate, searchCarTax, actualCarPrice, actualCarTax, SearchCarPrice, VehicleName, pickupLocationName, pickupLocationAddress, pickupLatitude  
		 , pickupLongitude, pickupZipCode, dropoffLatitude, dropoffLongitude, dropoffZipCode, dropoffLocationAddress, dropoffLocationName, PickUpdate  
		 , dropOutDate, SippCodeDescription, SippCodeTransmission, SippCodeAC, CarCompanyName, SippCodeClass, dropoffCity, dropoffState, dropoffCountry  
		 , pickupCity, pickupState, pickupCountry, minRateTax, TotalChargeAmt, minRate, passenger, baggage, isExpenseAdded, NoOfDays, tripGUIDKey  
		 , contractCode, carRules, rateTypeCode, OperationTimeStart, OperationTimeEnd, PickupLocationInfo, InvoiceNumber, MileageAllowance, RPH  
		 , CurrencyCodeKey, imageName, PhoneNumber, carDropOffLocationCode, carDropOffLocationCategoryCode, tripName, tt.userKey, startDate  
		 , endDate, tripStatusKey, tripSavedKey, tripPurchasedKey, agencyKey, tripComponentType, tripRequestKey, CreatedDate, meetingCodeKey  
		 , deniedReason, siteKey, isBid, isOnlineBooking, tripAdultsCount, tripSeniorsCount, tripChildCount, tripInfantCount, tripYouthCount  
		 , noOfTotalTraveler, noOfRooms, noOfCars, PurchaseComponentType, tripTotalBaseCost, tripTotalTaxCost, ModifiedDateTime, IsWatching  
		 , tripOriginalTotalBaseCost, tripOriginalTotalTaxCost, tripInfantWithSeatCount, passiveRecordLocator, isAudit, bookingCharges  
		 , isUserCreatedSavedTrip, ISSUEDATE, privacyType, HomeAirport, DestinationSmallImageURL, FollowersCount, tripCreationPath, CrowdCount  
		 , TrackingLogID, bookingFeeARC, IsHotelCrowdSavings, SabreCreationDate, promoId, cashRewardId, HostUserId, RetainOrReplace, GroupKey  
		 , cancellationflag, IsShowMyPic, UserIPAddress, SessionId, EventKey, AttendeeGuid, gdsSourceKey, GDSName, SeatMapAirlines, AgentURL   
		FROM vw_TripCarResponseDetails TD    
		 INNER JOIN dbo.Trip T WITH (NOLOCK) ON TD.tripGUIDKey = T.tripPurchasedKey   and   T.tripStatusKey <>17   --TD.tripKey = T.tripKey   
		 Inner join @tblTrip tt ON tt.tripKey  = T.tripKey       and   T.tripStatusKey <>17              
		 Inner Join vault.dbo.GDSSourceLookup GL WITH(NOLOCK) On GL.GDSName = TD.SupplierId                          
		UNION     
		SELECT T.tripKey, TD.recordLocator, TD.carResponseKey, confirmationNumber, carVendorKey, supplierId, carCategoryCode, carLocationCode, carLocationCategoryCode  
		 , PerDayRate, searchCarTax, actualCarPrice, actualCarTax, SearchCarPrice, VehicleName, pickupLocationName, pickupLocationAddress, pickupLatitude  
		 , pickupLongitude, pickupZipCode, dropoffLatitude, dropoffLongitude, dropoffZipCode, dropoffLocationAddress, dropoffLocationName, PickUpdate  
		 , dropOutDate, SippCodeDescription, SippCodeTransmission, SippCodeAC, CarCompanyName, SippCodeClass, dropoffCity, dropoffState, dropoffCountry  
		 , pickupCity, pickupState, pickupCountry, minRateTax, TotalChargeAmt, minRate, passenger, baggage, isExpenseAdded, NoOfDays, tripGUIDKey  
		 , contractCode, carRules, rateTypeCode, OperationTimeStart, OperationTimeEnd, PickupLocationInfo, InvoiceNumber, MileageAllowance, RPH  
		 , CurrencyCodeKey, imageName, PhoneNumber, carDropOffLocationCode, carDropOffLocationCategoryCode, tripName, tt.userKey, startDate  
		 , endDate, tripStatusKey, tripSavedKey, tripPurchasedKey, agencyKey, tripComponentType, tripRequestKey, CreatedDate, meetingCodeKey  
		 , deniedReason, siteKey, isBid, isOnlineBooking, tripAdultsCount, tripSeniorsCount, tripChildCount, tripInfantCount, tripYouthCount  
		 , noOfTotalTraveler, noOfRooms, noOfCars, PurchaseComponentType, tripTotalBaseCost, tripTotalTaxCost, ModifiedDateTime, IsWatching  
		 , tripOriginalTotalBaseCost, tripOriginalTotalTaxCost, tripInfantWithSeatCount, passiveRecordLocator, isAudit, bookingCharges  
		 , isUserCreatedSavedTrip, ISSUEDATE, privacyType, HomeAirport, DestinationSmallImageURL, FollowersCount, tripCreationPath, CrowdCount  
		 , TrackingLogID, bookingFeeARC, IsHotelCrowdSavings, SabreCreationDate, promoId, cashRewardId, HostUserId, RetainOrReplace, GroupKey  
		 , cancellationflag, IsShowMyPic, UserIPAddress, SessionId, EventKey, AttendeeGuid, gdsSourceKey, GDSName, SeatMapAirlines, AgentURL   
		FROM vw_TripCarResponseDetails TD    
		 INNER JOIN dbo.Trip T WITH (NOLOCK) ON TD.tripguidkey = T.tripPurchasedKey    and   T.tripStatusKey <>17     
		 Inner join @tblTrip tt ON tt.tripKey  = T.tripKey            and   T.tripStatusKey <>17         
		 Inner Join vault.dbo.GDSSourceLookup GL WITH(NOLOCK) On GL.GDSName = TD.SupplierId                          
		WHERE TD.tripkey IS NULL AND T.tripStatusKey = 1  
		 UNION     
		SELECT T.tripKey, TD.recordLocator, TD.carResponseKey, confirmationNumber, carVendorKey, supplierId, carCategoryCode, carLocationCode, carLocationCategoryCode  
		 , PerDayRate, searchCarTax, actualCarPrice, actualCarTax, SearchCarPrice, VehicleName, pickupLocationName, pickupLocationAddress, pickupLatitude  
		 , pickupLongitude, pickupZipCode, dropoffLatitude, dropoffLongitude, dropoffZipCode, dropoffLocationAddress, dropoffLocationName, PickUpdate  
		 , dropOutDate, SippCodeDescription, SippCodeTransmission, SippCodeAC, CarCompanyName, SippCodeClass, dropoffCity, dropoffState, dropoffCountry  
		 , pickupCity, pickupState, pickupCountry, minRateTax, TotalChargeAmt, minRate, passenger, baggage, isExpenseAdded, NoOfDays, tripGUIDKey  
		 , contractCode, carRules, rateTypeCode, OperationTimeStart, OperationTimeEnd, PickupLocationInfo, InvoiceNumber, MileageAllowance, RPH  
		 , CurrencyCodeKey, imageName, PhoneNumber, carDropOffLocationCode, carDropOffLocationCategoryCode, tripName, tt.userKey, startDate  
		 , endDate, tripStatusKey, tripSavedKey, tripPurchasedKey, agencyKey, tripComponentType, tripRequestKey, CreatedDate, meetingCodeKey  
		 , deniedReason, siteKey, isBid, isOnlineBooking, tripAdultsCount, tripSeniorsCount, tripChildCount, tripInfantCount, tripYouthCount  
		 , noOfTotalTraveler, noOfRooms, noOfCars, PurchaseComponentType, tripTotalBaseCost, tripTotalTaxCost, ModifiedDateTime, IsWatching  
		 , tripOriginalTotalBaseCost, tripOriginalTotalTaxCost, tripInfantWithSeatCount, passiveRecordLocator, isAudit, bookingCharges  
		 , isUserCreatedSavedTrip, ISSUEDATE, privacyType, HomeAirport, DestinationSmallImageURL, FollowersCount, tripCreationPath, CrowdCount  
		 , TrackingLogID, bookingFeeARC, IsHotelCrowdSavings, SabreCreationDate, promoId, cashRewardId, HostUserId, RetainOrReplace, GroupKey  
		 , cancellationflag, IsShowMyPic, UserIPAddress, SessionId, EventKey, AttendeeGuid, gdsSourceKey, GDSName, SeatMapAirlines, AgentURL   
		FROM vw_TripCarResponseDetails TD    
		 INNER JOIN dbo.Trip T WITH (NOLOCK) ON TD.tripguidkey = T.tripPurchasedKey    and   T.tripStatusKey <>17     
		 Inner join @tblTrip tt ON tt.tripKey  = T.tripKey            and   T.tripStatusKey <>17         
		 Inner Join vault.dbo.GDSSourceLookup GL WITH(NOLOCK) On GL.GDSName = TD.SupplierId                          
		WHERE TD.tripGUIDKey = @TripPurchasedKey AND T.tripStatusKey <> 1  

	END
	ELSE
	BEGIN
PRINT 'Inside @isCarExist = 1 Else block'
		SELECT T.tripKey, TD.recordLocator, TD.carResponseKey 
		FROM Trip T
			INNER JOIN TripCarResponse TD ON T.tripKey = TD.tripKey 
		WHERE 1=2
	END
		  
--SELECT '9', GETDATE()
	                             
	select TAVP.*, TPI.PassengerFirstName,TPI.PassengerLastName, TPI.PassengerLocale,TPI.PassengerEmailID              
	from TripPassengerInfo TPI   WITH(NOLOCK)                         
	  INNER JOIN  TripPassengerAirVendorPreference TAVP WITH(NOLOCK) ON TPI.TripKey = TAVP.TripKey                          
	  Inner join @tblTrip tt on tt.tripKey = TPI.tripKey                            
	  WHERE    TPI.Active = 1 and TAVP.Active = 1                           
	  order by TPI.TripKey                          
--SELECT '10', GETDATE()
	                          
	SELECT GeneratedType ,TPR.TripKey ,TPR.RemarksDesc,RemarkFieldName,RemarkFieldValue     
	FROM TripPNRRemarks TPR WITH(NOLOCK)                          
	INNER JOIN @tblTrip tt on TPR.tripKey = tt.tripKey                           
	WHERE TPR.Active= 1  and (tt.statusKey != 5)    
	   --AND DATEDIFF( DAY  ,CreatedOn, GETDATE())<=1          
--SELECT '11', GETDATE()
	                          
	SELECT TOP 1                        
	  ISNULL(ReasonDescription,'') as ReasonDescription, ReasonCode,                       
	  TripKey                         
	FROM                         
	  TripPolicyException                        
	WHERE                         
	  TripKey = @tripID                     
	                    
	                    
	select distinct TAVP.AirsegmentKey,                     
	                    
	TAVP.PassengerKey,                    
	TAVP.OriginAirportCode,                    
	TAVP.TicketDelivery,                    
	TAVP.AirSeatingType,                    
	TAVP.AirRowType,                    
	TAVP.AirMealType,                    
	TAVP.AirSpecialSevicesType,                    
	TAVP.Active,                    
	TAVP.AirsegmentKey                    
	 , TPI.PassengerFirstName,TPI.PassengerLastName, TPI.PassengerLocale,TPI.PassengerEmailID ,TPI.tripKey,TPI.TripPassengerInfoKey  from TripPassengerInfo TPI WITH(NOLOCK)                          
	  INNER JOIN  TripPassengerAirPreference  TAVP WITH(NOLOCK) ON TPI.TripKey = TAVP.TripKey                          
	  Inner join @tblTrip tt on tt.tripKey = TPI.tripKey                            
	  WHERE    TPI.Active = 1 and TAVP.Active = 1       
	                    
--SELECT '12', GETDATE()
	                    
	                    
	              
	select TCVP.* from TripPassengerInfo TPI   WITH(NOLOCK)                    
	  INNER JOIN  TripPassengerUDIDInfo TCVP WITH(NOLOCK) ON TCVP.TripKey = TPI.TripKey                         
	   Inner join @tblTrip tt   on tt.tripKey = TPI.tripKey                    
	  WHERE   TCVP.Active=1                    
	  order by TPI.TripKey                      

--SELECT '13', GETDATE()
	                    
	Select * from vw_TripCruiseResponse cruise  WITH(NOLOCK)                
	 inner join trip t WITH(NOLOCK) on cruise.tripGuidkey =t.tripPurchasedKey   and   T.tripStatusKey <>17                            
	 Inner join @tblTrip tt on tt.tripKey = t.tripKey       and   T.tripStatusKey <>17                        
		Order by t.tripKey                   
--SELECT '14', GETDATE()
	                     
		/***tripairleg pax info****/              
	                  
	 SELECT TLP.* ,TLA.tripAirLegsKey FROM TripAirLegPassengerInfo  TLP  WITH(NOLOCK) inner join                
	 TripAirLegs  TLA WITH(NOLOCK) ON Tlp.tripAirLegKey = TLA.tripAirLegsKey inner join                
	   TripAirResponse TA  WITH(NOLOCK) ON TLA.airResponseKey= TA.airResponseKey               
	 inner join Trip T WITH(NOLOCK) ON TA.tripGUIDKey = t.tripPurchasedKey inner join @tblTrip Tbl on t.tripKey = tbl.tripKey  and   T.tripStatusKey <>17                 
	 Where TLA.isDeleted = 0      
--SELECT '15', GETDATE()

		/****TRipSEGMENT pax details DETAILS***/              
	 SELECT TSP.* ,TSA.airSegmentKey FROM TripAirSegmentPassengerInfo TSP  WITH(NOLOCK) inner join                
	 TripAirSegments TSA WITH(NOLOCK) ON TSp.tripAirSegmentkey = TSA.tripAirSegmentKey inner join                
	   TripAirResponse TA  ON TSA.airResponseKey= TA.airResponseKey               
	 inner join Trip T ON TA.tripGUIDKey = t.tripPurchasedKey inner join @tblTrip Tbl on t.tripKey = tbl.tripKey    and   T.tripStatusKey <>17                
	 Where TSA.isDeleted = 0      
--SELECT '16', GETDATE()
   
	 /* trip hotel pax info */            
	 SELECT THP.* FROM TripHotelResponsePassengerInfo THP WITH(NOLOCK)            
	 INNER JOIN TripPassengerInfo TPI WITH(NOLOCK) ON TPI.TripPassengerInfoKey = THP.TripPassengerInfoKey            
	 INNER JOIN TripHotelResponse TH WITH(NOLOCK) ON TH.hotelResponseKey = THP.hotelResponseKey            
	 INNER JOIN Trip T WITH(NOLOCK) ON TH.tripGUIDKey = T.tripPurchasedKey  and   T.tripStatusKey <>17                
	 INNER JOIN @tblTrip Tbl on T.tripKey = tbl.tripKey    and   T.tripStatusKey <>17               
--SELECT '17', GETDATE()
       
	 SELECT TT.tripKey, friendEmailAddress FROM TripConfirmationFriendEmail TCFE WITH(NOLOCK)            
	 INNER JOIN @tblTrip TT ON TCFE.tripKey = TT.tripKey            
--SELECT '18', GETDATE()

	  /* Trip Activity Details */            
	  SELECT         
	  TAR.ActivityResponseKey,        
	  ISNULL(ConfirmationNumber, '')as ConfirmationNumber,        
	  ISNULL(RecordLocator, '') as RecordLocator,               
	  ISNULL(ActivityType, '') as ActivityType,         
	  ISNULL(ActivityTitle, '') as ActivityTitle,        
	  ISNULL(ActivityText, '') as ActivityText,               
	  ActivityDate,         
	  ISNULL(VoucherURL, '') as VoucherURL,        
	  ISNULL(CancellationFormURL, '') as CancellationFormURL,         
	  NoOfAdult,              
	  NoOfChild,        
	  NoOfYouth,        
	  NoOfInfant,        
	  NoOfSenior,        
	  TotalPrice,        
	  ISNULL(Link, '') as Link,       
	  TAR.ActivityCode,      
	  TAR.OptionCode,      
	  AL.City, AL.IATACode          
	 FROM  TripActivityResponse  TAR WITH(NOLOCK)       
	 INNER JOIN Activity..ActivityLookUp AC WITH(NOLOCK) ON TAR.ActivityCode = AC.Code            
	 INNER JOIN Activity.dbo.ActivityLocations AL WITH(NOLOCK) ON AC.Id = AL.ActivityId            
	 INNER JOIN @tblTrip TT ON TAR.tripKey = TT.tripKey AND ISNULL(TAR.isDeleted,0) = 0        
--SELECT '19', GETDATE()

	 /* Trip Insurance Details */            
	 SELECT *             
	 FROM [TripPurchasedInsurance] TPI WITH(NOLOCK)            
	 INNER JOIN @tblTrip TT ON TPI.tripKey = TT.tripKey    
	 AND TPI.isDeleted = 0  AND ISNULL(TPI.isDeleted,0) = 0          
--SELECT '20', GETDATE()

	 /* Trip Rail Details */  
	 Select * from TripRailResponse rail  WITH(NOLOCK)                
	 inner join trip t WITH(NOLOCK) on rail.TripGUIDKey =t.tripPurchasedKey   and   T.tripStatusKey <>17                            
	 Inner join @tblTrip tt on tt.tripKey = t.tripKey  and   T.tripStatusKey <>17         
	 AND ISNULL(rail.isDeleted,0) = 0                       
	 Order by t.tripKey    
--SELECT '21', GETDATE()

	select TR.tripRequestKey,TR.tripFrom1 as 'From',TR.tripTo1 as 'To' from TripRequest TR inner join @tblTrip TT   
	on TR.tripRequestKey=TT.RequestKey  
--SELECT '22', GETDATE()
	  
	SELECT TTI.tripKey,recordLocator,isExchanged,isVoided,isRefunded,oldTicketNumber,newTicketNumber,oldFare,newFare,addCollectFare,  
	serviceCharge,residualFare,TotalFare,ExchangeFee,BaseFare,TaxFare FROM TripTicketInfo TTI         
	INNER JOIN @tblTrip tt ON tt.tripKey = TTI.tripKey         
	ORDER BY tripTicketInfoKey Desc   
--SELECT '23', GETDATE()
	         
	SELECT TT.tripKey,tripAdultBase,tripAdultTax,tripSeniorBase,tripSeniorTax,tripYouthBase,tripYouthTax,tripChildBase,tripChildTax,  
	tripInfantBase,tripInfantTax,tripInfantWithSeatBase,tripInfantWithSeatTax FROM TripAirPrices TAP        
	INNER JOIN TripAirResponse TAR ON TAR.actualAirPriceBreakupKey = TAP.tripAirPriceKey    
	INNER JOIN Trip TT on TT.tripPurchasedKey = TAR.tripGUIDKey  
	where TT.tripKey =  @tripID     
--SELECT '24', GETDATE()

END  
GO
