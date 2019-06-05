SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
/*Exec [usp_GetsaveTripDetailsForMultipax] 7841,0   */              
CREATE PROCEDURE [dbo].[usp_GetSaveTripDetailsForMultipax]                      
(                  
 @tripID   int   ,                    
 @tripRequestID Int = 0                    
)                  
as                      
BEGIN                    
                    
DECLARE @tblTrip as table                    
(                    
 tripKey int,                    
 RequestKey int,        
 statusKey int                    
)                    
                    
                   
if(@tripRequestID is Null  or @tripRequestID = 0 )                     
BEGIN                    
 INSERT Into @tblTrip                    
 Select  @tripID,  tripRequestKey, tripStatusKey  from Trip WITH(NOLOCK) where tripKey  = @tripID  and tripStatusKey <> 17                    
END                    
ELSE                     
BEGIN                    
 INSERT Into @tblTrip                    
 Select  tripKey ,  tripRequestKey, tripStatusKey  from Trip WITH(NOLOCK) where tripRequestKey  = @tripRequestID     and tripStatusKey <> 17                  
END                    
                    
                    
                    
                    
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
Select distinct U.userKey , U.userFirstName , U.userLastName , U.userLogin  ,U.companyKey, UP.ReceiptEmail                       
From Vault.dbo.[User] U  WITH(NOLOCK)                  
 inner join Trip T WITH(NOLOCK) on  U.userKey = T.userKey                     
 Inner join @tblTrip tt on tt.tripKey = T.tripKey and T.tripStatusKey <> 17             
 inner join Vault.dbo.UserProfile UP WITH(NOLOCK) ON U.userKey = UP.userKey
                    
select Trip.*, vault.dbo.Agency .agencyKey As Agency_ID, U.* from Trip                     
inner join vault.dbo.Agency WITH(NOLOCK) on trip.agencyKey = Agency.agencyKey                     
Left Outer join @tblUser U  on Trip.userKey = U.UserKey                     
Inner join @tblTrip tt on tt.tripKey = Trip.tripKey and Trip.tripStatusKey <> 17                                
Order by tripKey                     
                    
select TPI.* from TripPassengerInfo TPI WITH(NOLOCK)                     
  Inner join @tblTrip tt on tt.tripKey = TPI.tripKey 
  WHERE    TPI.Active = 1               
              
        
/*Getting Add Collect Amount From Trip Ticket Info table*/                    
DECLARE @AddCollectAmount FLOAT        
SET @AddCollectAmount = 0        
        
SELECT TOP 1 @AddCollectAmount = AddCollectFare FROM TripTicketInfo  TTI  WITH(NOLOCK)       
INNER JOIN @tblTrip tt ON tt.tripKey = TTI.tripKey WHERE IsExchanged = 1 AND tt.statusKey = 12        
ORDER BY tripTicketInfoKey Desc        
                    
SELECT      
DISTINCT T.tripKey ,                    
                     
segments.tripAirSegmentKey,              
segments.airSegmentKey,              
segments.tripAirLegsKey,              
--segments.airResponseKey,              
segments.airLegNumber,              
segments.airSegmentMarketingAirlineCode,              
segments.airSegmentOperatingAirlineCode,              
segments.airSegmentFlightNumber,              
segments.airSegmentDuration,              
segments.airSegmentEquipment,              
segments.airSegmentMiles,              
segments.airSegmentDepartureDate,              
segments.airSegmentArrivalDate,              
segments.airSegmentDepartureAirport,              
segments.airSegmentArrivalAirport,              
segments.airSegmentResBookDesigCode,              
segments.airSegmentDepartureOffset,              
segments.airSegmentArrivalOffset,              
segments.airSegmentSeatRemaining,              
segments.airSegmentMarriageGrp,              
segments.airFareBasisCode,              
segments.airFareReferenceKey,              
segments.airSelectedSeatNumber,              
segments.ticketNumber,              
segments.airsegmentcabin,              
segments.recordLocator as SegRecordLocator                 
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
ISNULL (airven.ShortName,segments.airSegmentMarketingAirlineCode )                      
as MarketingAirLine,airSegmentOperatingAirlineCode  ,  
AirResp.CurrencyCodeKey as CurrencyCode,                    
ISNULL (airOperatingven.ShortName,segments.airSegmentOperatingAirlineCode ) as OperatingAirLine,                      
isnull(airSelectedSeatNumber,0)  as SeatNumber  , segments.ticketNumber as TicketNumber ,segments.airsegmentcabin as airsegmentcabin    ,AirResp.isExpenseAdded,                  
ISNULL(t.deniedReason,'') as deniedReason, t.CreatedDate       , segments.airSegmentOperatingFlightNumber ,airresp.bookingcharges              
,ISNULL(seatMapStatus,'') AS seatMapStatus, AirResp.ValidatingCarrier          
,@AddCollectAmount AS AddCollectAmount,        
 G.AgentURL,
 --AirResp.tripGUIDKey ,
 segments.RPH 
 ,segments.ArrivalTerminal,segments.DepartureTerminal,
 airSegmentOperatingAirlineCompanyShortName    ,
        
--   ,TPR.RemarkFieldName                    
--,TPR.RemarkFieldValue                    
--,TPR.TripTypeKey                    
--,TPR.RemarksDesc                    
--,TPR.GeneratedType                
AirResp.*    
  ,legs.ValidatingCarrier as LegValidatingCarrier  
--,TPR.CreatedOn                    
 from TripAirSegments  segments  WITH(NOLOCK)                     
  inner join TripAirLegs legs  WITH(NOLOCK)                     
   on ( segments .tripAirLegsKey = legs .tripAirLegsKey --and segments .airResponseKey = legs.airResponseKey                       
   and segments .airLegNumber = legs .airLegNumber )                      
  inner join TripAirResponse   AirResp  WITH(NOLOCK)                     
   on segments .airResponseKey = AirResp .airResponseKey                        
  inner join Trip t WITH(NOLOCK) on AirResp.tripGUIDKey  = t.tripsavedkey                     
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
         
 WHERE ISNULL(LEGS.ISDELETED,0) = 0 AND ISNULL (segments.ISDELETED ,0) = 0     and T.tripStatusKey <> 17                      
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
    
select              
hotel.*,t.tripKey,GL.AgentURL,HI.SupplierImageURL,CRH.RedeemedAmount from vw_TripHotelResponseDetails hotel WITH(NOLOCK)      
inner join trip t WITH(NOLOCK) on hotel.tripGUIDKey = t.tripsavedkey   and T.tripStatusKey <> 17                        
Inner join @tblTrip tt on tt.tripKey = t.tripKey      
Inner Join vault.dbo.GDSSourceLookup GL WITH(NOLOCK) On GL.GDSName = hotel.SupplierId      
LEFT OUTER JOIN HotelContent..HotelImages HI WITH(NOLOCK) ON HI.HotelId = hotel.HotelId AND HI.ImageType = 'Exterior'     
LEFT OUTER JOIN Loyalty..CashRewardHistory CRH WITH(NOLOCK) ON CRH.Id = T.cashRewardId
Order by t.tripKey      
                      
--Select * from vw_TripCarResponseDetails car WITH(NOLOCK)  
-- inner join                 
--trip t WITH(NOLOCK) on car .tripguidkey =t.tripsavedkey                     
--Inner join @tblTrip tt on tt.tripKey  = t.tripKey           
--Inner Join vault.dbo.GDSSourceLookup GL WITH(NOLOCK) On GL.GDSName = car.SupplierId                    
--Order by t.tripKey    

SELECT T.tripKey as tripKey,* FROM vw_TripCarResponseDetails TD  
 INNER JOIN dbo.Trip T WITH (NOLOCK) ON TD.tripKey = T.tripKey    and T.tripStatusKey <> 17                   
 Inner join @tblTrip tt ON tt.tripKey  = T.tripKey               
 Inner Join vault.dbo.GDSSourceLookup GL WITH(NOLOCK) On GL.GDSName = TD.SupplierId                        
 UNION   
 SELECT T.tripKey as tripKey,* FROM vw_TripCarResponseDetails TD  
 INNER JOIN dbo.Trip T WITH (NOLOCK) ON TD.tripguidkey =t.tripsavedkey    and T.tripStatusKey <> 17                  
 Inner join @tblTrip tt ON tt.tripKey  = T.tripKey               
 Inner Join vault.dbo.GDSSourceLookup GL WITH(NOLOCK) On GL.GDSName = TD.SupplierId                        
 ORDER BY T.tripKey        
 
 --Inner join vault.dbo.[User] U on t.userKey = U.userKey                     
 --where t.tripRequestKey = @tripRequestID                     
                
                       
select TAVP.*, TPI.PassengerFirstName,TPI.PassengerLastName, TPI.PassengerLocale,TPI.PassengerEmailID        
from TripPassengerInfo TPI   WITH(NOLOCK)                   
  INNER JOIN  TripPassengerAirVendorPreference TAVP WITH(NOLOCK) ON TPI.TripKey = TAVP.TripKey                    
  Inner join @tblTrip tt on tt.tripKey = TPI.tripKey                      
  WHERE    TPI.Active = 1 and TAVP.Active = 1                     
  order by TPI.TripKey                    
                    
SELECT GeneratedType ,TPR.TripKey ,TPR.RemarksDesc,RemarkFieldName,RemarkFieldValue   
FROM TripPNRRemarks TPR WITH(NOLOCK)                        
INNER JOIN @tblTrip tt on TPR.tripKey = tt.tripKey                         
WHERE TPR.Active= 1  and (tt.statusKey != 5)  
   --AND DATEDIFF( DAY  ,CreatedOn, GETDATE())<=1                      
                      
                      
                    
SELECT TOP 1                  
  ISNULL(ReasonDescription,'') as ReasonDescription,                  
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
              
              
              
        
select TCVP.* from TripPassengerInfo TPI   WITH(NOLOCK)              
  INNER JOIN  TripPassengerUDIDInfo TCVP WITH(NOLOCK) ON TCVP.TripKey = TPI.TripKey                   
   Inner join @tblTrip tt   on tt.tripKey = TPI.tripKey              
  WHERE   TCVP.Active=1              
  order by TPI.TripKey                
              
Select * from vw_TripCruiseResponse cruise  WITH(NOLOCK)          
 inner join trip t WITH(NOLOCK) on cruise.tripGuidkey =t.tripsavedkey  and T.tripStatusKey <> 17                                    
 Inner join @tblTrip tt on tt.tripKey = t.tripKey                     
    Order by t.tripKey             
               
    /***tripairleg pax info****/        
            
 SELECT TLP.* ,TLA.tripAirLegsKey FROM TripAirLegPassengerInfo  TLP  WITH(NOLOCK) inner join          
 TripAirLegs  TLA WITH(NOLOCK) ON Tlp.tripAirLegKey = TLA.tripAirLegsKey inner join          
   TripAirResponse TA  WITH(NOLOCK) ON TLA.airResponseKey= TA.airResponseKey         
 inner join Trip T WITH(NOLOCK) ON TA.tripGUIDKey = t.tripsavedkey   and T.tripStatusKey <> 17                  
 inner join @tblTrip Tbl on t.tripKey = tbl.tripKey         
    /****TRipSEGMENT pax details DETAILS***/        
 SELECT TSP.* ,TSA.airSegmentKey FROM TripAirSegmentPassengerInfo TSP  WITH(NOLOCK) inner join          
 TripAirSegments TSA WITH(NOLOCK) ON TSp.tripAirSegmentkey = TSA.tripAirSegmentKey inner join          
   TripAirResponse TA  ON TSA.airResponseKey= TA.airResponseKey         
 inner join Trip T ON TA.tripGUIDKey = t.tripsavedkey   and T.tripStatusKey <> 17                  
 inner join @tblTrip Tbl on t.tripKey = tbl.tripKey         
        
 /* trip hotel pax info */      
 SELECT THP.* FROM TripHotelResponsePassengerInfo THP WITH(NOLOCK)      
 INNER JOIN TripPassengerInfo TPI WITH(NOLOCK) ON TPI.TripPassengerInfoKey = THP.TripPassengerInfoKey      
 INNER JOIN TripHotelResponse TH WITH(NOLOCK) ON TH.hotelResponseKey = THP.hotelResponseKey      
 INNER JOIN Trip T WITH(NOLOCK) ON TH.tripGUIDKey = T.tripsavedkey    and T.tripStatusKey <> 17                       
 INNER JOIN @tblTrip Tbl on T.tripKey = tbl.tripKey         
       
 SELECT TT.tripKey, friendEmailAddress FROM TripConfirmationFriendEmail TCFE WITH(NOLOCK)      
 INNER JOIN @tblTrip TT ON TCFE.tripKey = TT.tripKey      
       
  /* Trip Activity Details */      
  SELECT 
		--ActivityId,
		ISNULL(ConfirmationNumber, '')as ConfirmationNumber,
		ISNULL(RecordLocator, '') as RecordLocator,         
		ISNULL(ActivityType, '') as ActivityType, 
		ISNULL(ActivityTitle, '') as ActivityTitle,
		ISNULL(ActivityText, '') as ActivityText,         
		ActivityDate, ISNULL(VoucherURL, '') as VoucherURL,
		ISNULL(CancellationFormURL, '') as CancellationFormURL, 
		NoOfAdult,        
		NoOfChild,
		NoOfYouth,
		NoOfInfant,
		NoOfSenior,
		TotalPrice,
		ISNULL(Link, '') as Link        
 FROM  TripActivityResponse  TAR WITH(NOLOCK)      
 INNER JOIN @tblTrip TT ON TAR.tripKey = TT.tripKey      
       
 /* Trip Insurance Details */      
 SELECT *       
 FROM [TripPurchasedInsurance] TPI WITH(NOLOCK)      
 INNER JOIN @tblTrip TT ON TPI.tripKey = TT.tripKey      
       
END      
GO
