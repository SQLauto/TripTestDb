SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
        
-- =============================================                      
-- Author : Gopal                    
-- Create date : Jan/10/2012                      
-- Description : Trip Information will be received from Web Service.                      
-- Param : TripKey is optional.                    
--declare @p11 int          
--set @p11=NULL          
--exec usp_Get_Page_Tripsdetail_Traveler @pageName=N'currenttrips',@pageNo=1,@pageSize=25,@userkey=560755,@tripKey=NULL,@fromDate=N'12/22/2013 12:00:00 AM',@toDate=N'4/22/2014 11:59:59 PM',@traveler=NULL,@status=NULL,@companyKey=2469,@totalRecords=0,@TripCompType=N'All', @sortField = 'Traveler', @sortDirection = 'Ascending'          
--select @p11          
        
--declare @p11 int        
--set @p11=NULL        
--exec usp_Get_Page_Tripsdetail_Traveler @pageName=N'pasttrips',@pageNo=1,@pageSize=25,@userkey=559494,@tripKey=NULL,@fromDate=N'1/1/1900 12:00:00 AM',@toDate=N'12/31/9999 11:59:59 PM',@traveler=NULL,@status=NULL,@companyKey=2198,@totalRecords=@p11 output,@TripCompType=N'All', @sortField = 'Depart', @sortDirection = 'Ascending'        
--select @p11        
        
-- =============================================                       
CREATE PROCEDURE [dbo].[usp_GetTrips_tripaudit]        
 @PageName  NVARCHAR(500),                        
 @pageNo   INT,                    
 @pageSize  INT,                    
 @userkey  INT,                     
 @tripKey  INT = NULL,                        
 @fromDate  NVARCHAR(50),                        
 @toDate   NVARCHAR(50),                        
 --@fromDate  DateTime,                        
 --@toDate   DateTime,                        
 @traveler  INT,                    
 @status   INT,                    
 @companyKey  INT = NULL ,                    
 @TripCompType VARCHAR(10),                       
 @siteKey  INT = NULL,                    
 @createdDate DATETIME = '01-01-1900 00:00:00',                    
 @totalRecords INT OUTPUT,          
 @sortField as varchar (200) ,               
 @sortDirection as varchar(20)                           
AS                        
BEGIN                           

                    
 CREATE TABLE #tblUser                        
 (                        
  UserKey INT                        
 )                        
    CREATE TABLE #tmpTrip                        
 (                        
  RowID   INT,                        
  tripKey   INT,                        
  TripRequestKey INT,                        
  tripName  NVARCHAR(100),                        
  userKey   INT,                        
  recordLocator NVARCHAR(100),                        
  startDate  DATETIME,                        
  endDate   DATETIME,                        
  tripStatusKey INT,                        
  agencyKey  INT,                        
  userFirstName NVARCHAR(300),                        
  userLastName NVARCHAR(300),                        
  userLogin  NVARCHAR(300),  
  tripPurchasedKey uniqueidentifier        
 )            
                         
 IF(@traveler IS NOT NULL AND @traveler <> '' )                         
 BEGIN                        
  INSERT INTO #tblUser                        
   SELECT @traveler                        
 END                        
 ELSE                        
 BEGIN                        
  INSERT INTO #tblUser                        
  SELECT DISTINCT userKey FROM Vault.dbo.GetAllArrangees(@userkey, @companyKey)                     
 END                        
                     
 IF @PageName <> N'bids'                    
 BEGIN                    
  SET @tripKey = CASE WHEN @tripKey IS NULL THEN 0 ELSE @tripKey END                     
 END                    
                     
 DECLARE @strQuery NVARCHAR(MAX), @paramDesc NVARCHAR(200)                      
                    
        ---- get the trip detail from trip table with filter parameter                        
 IF @PageName = 'currenttrips'                          
 BEGIN                          
  INSERT INTO #tmpTrip          
  SELECT ROW_NUMBER() OVER (ORDER BY  -----Implemented sorting        
   case when @sortField = 'Traveler' and @sortDirection ='Descending' then    ltrim(U.userFirstName)     End   desc,             
 case when @sortField = 'Traveler' and @sortDirection ='Ascending' then    ltrim(U.userFirstName)  End   asc ,            
 case when @sortField = 'TripName' and @sortDirection ='Descending' then    Trip.TripName  End   desc,        
 case when @sortField = 'TripName' and @sortDirection ='Ascending' then    Trip.TripName  End   asc,          
 case when @sortField = 'Depart' and @sortDirection ='Descending' then    Trip.startDate  End   desc,             
 case when @sortField = 'Depart' and @sortDirection ='Ascending' then    Trip.startDate  End   asc,          
 case when @sortField = 'Return' and @sortDirection ='Descending' then    Trip.endDate  End   desc,             
 case when @sortField = 'Return' and @sortDirection ='Ascending' then    Trip.endDate  End   asc,          
 case when @sortField = 'Status' and @sortDirection ='Descending' then     S.tripStatusName  End   desc,             
 case when @sortField = 'Status' and @sortDirection ='Ascending' then     S.tripStatusName  End   asc,          
 case when @sortField = 'Amount' and @sortDirection ='Descending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   desc,             
 case when @sortField = 'Amount' and @sortDirection ='Ascending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   asc),           
   Trip.tripKey, Trip.TripRequestKey, Trip.tripName, Trip.userKey, Trip.recordLocator, Trip.startDate,        
   Trip.endDate, Trip.tripStatusKey, Trip.agencyKey,                       
   U.userFirstName, U.userLastName, U.userLogin , trip.tripPurchasedKey  
  FROM trip WITH(NOLOCK)             
   INNER JOIN Vault.dbo.[User] U WITH(NOLOCK) ON trip.userKey =  U.UserKey AND Trip.tripStatusKey <> 10    AND Trip.tripStatusKey <> 17          
   INNER JOIN TripStatusLookup S WITH (NOLOCK) ON Trip.tripStatusKey = S.tripStatusKey         
   INNER JOIN #tblUser TU ON U.userKey = TU.userKey        
   LEFT OUTER JOIN TripAirResponse TAR WITH (NOLOCK) ON trip.tripPurchasedKey = TAR.tripGUIDKey        
   LEFT OUTER JOIN TripCarResponse TCR WITH (NOLOCK) ON trip.tripPurchasedKey = TCR.tripGUIDKey        
   LEFT OUTER JOIN TripHotelResponse THR WITH (NOLOCK) ON trip.tripPurchasedKey = THR.tripGUIDKey        
   LEFT OUTER JOIN TripAirSegmentOptionalServices OPT WITH (NOLOCK) ON trip.tripKey = OPT.tripKey AND OPT.isDeleted = 0           
   WHERE 1=1                     
    AND Trip.tripKey = CASE WHEN @tripKey = 0 THEN Trip.tripKey ELSE @tripKey END                     
    AND Trip.startDate between @fromDate and @toDate                     
    AND dbo.IsTripStatusAsPerType(ISNULL(@status,Trip.tripStatusKey),@PageName) = 1                     
    AND Trip.recordlocator IS NOT NULL AND Trip.recordlocator <> '' AND                     
    Trip.endDate >= GETDATE() AND Trip.tripStatusKey = ISNULL(@status,Trip.tripStatusKey)        
    AND Trip.siteKey = CASE WHEN @siteKey IS NULL THEN Trip.siteKey ELSE @siteKey END  --Added for TFS 861           
    
  --select * from #tmpTrip   
  SELECT @totalRecords = COUNT(*) FROM #tmpTrip     ---get total records count in output parameter          
                    
  SELECT trip.tripKey, TripRequestKey, tripName, userKey, recordLocator, startDate, endDate,                    
   tripStatusKey, agencyKey, userFirstName, userLastName, userLogin           
  FROM #tmpTrip trip          
  WHERE RowID > (@pageNo-1)*@pageSize AND RowID <= @pageNo*@pageSize            
                      
        ---  get the Air, car and hotel response detail for filtered trips          
  SELECT vt.TYPE, vt.tripKey, vt.recordLocator, vt.basecost, vt.tax, vt.vendorcode,                    
   vt.VendorName, vt.airSegmentDepartureAirport, vt.airSegmentArrivalAirport, vt.flightNumber,               
   vt.departuredate, vt.arrivaldate, vt.carType, vt.Ratingtype, vt.responseKey, vt.vendorLocator        
  FROM vw_TripDetails_tripaudit vt WITH(NOLOCK)                     
   INNER JOIN #tmpTrip tmp ON tmp.tripKey = vt.tripKey        
   INNER JOIN TripStatusLookup S WITH (NOLOCK) ON tmp.tripStatusKey = S.tripStatusKey        
   LEFT OUTER JOIN TripAirResponse TAR WITH (NOLOCK) ON tmp.tripPurchasedKey = TAR.tripGUIDKey        
   LEFT OUTER JOIN TripCarResponse TCR WITH (NOLOCK) ON tmp.tripPurchasedKey = TCR.tripGUIDKey        
   LEFT OUTER JOIN TripHotelResponse THR WITH (NOLOCK) ON tmp.tripPurchasedKey = THR.tripGUIDKey        
   LEFT OUTER JOIN TripAirSegmentOptionalServices OPT WITH (NOLOCK) ON tmp.tripKey = OPT.tripKey AND OPT.isDeleted = 0           
  ORDER BY      -----Implemented sorting        
    case when @sortField = 'Traveler' and @sortDirection ='Descending' then    ltrim(tmp.userFirstName)     End   desc,             
 case when @sortField = 'Traveler' and @sortDirection ='Ascending' then    ltrim(tmp.userFirstName)  End   asc ,            
 case when @sortField = 'TripName' and @sortDirection ='Descending' then    tmp.TripName  End   desc,             
 case when @sortField = 'TripName' and @sortDirection ='Ascending' then    tmp.TripName  End   asc,          
 case when @sortField = 'Depart' and @sortDirection ='Descending' then    tmp.startDate  End   desc,             
 case when @sortField = 'Depart' and @sortDirection ='Ascending' then    tmp.startDate  End   asc,          
 case when @sortField = 'Return' and @sortDirection ='Descending' then    tmp.endDate  End   desc,             
 case when @sortField = 'Return' and @sortDirection ='Ascending' then    tmp.endDate  End   asc,          
 case when @sortField = 'Status' and @sortDirection ='Descending' then     S.tripStatusName  End   desc,             
 case when @sortField = 'Status' and @sortDirection ='Ascending' then     S.tripStatusName  End   asc,          
 case when @sortField = 'Amount' and @sortDirection ='Descending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   desc,             
 case when @sortField = 'Amount' and @sortDirection ='Ascending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   asc        
                            
  SELECT OPT.*                     
  FROM TripAirSegmentOptionalServices OPT WITH(NOLOCK)                     
   INNER JOIN #tmpTrip T ON OPT.tripKey = T.tripKey AND isDeleted = 0                     
                    
 END            
 ELSE IF @PageName = 'currenttripname'                  
  BEGIN                       
  INSERT INTO #tmpTrip          
  SELECT ROW_NUMBER() OVER (ORDER BY  -----Implemented sorting        
    case when @sortField = 'Traveler' and @sortDirection ='Descending' then    ltrim(U.userFirstName)     End   desc,             
 case when @sortField = 'Traveler' and @sortDirection ='Ascending' then    ltrim(U.userFirstName)  End   asc ,            
 case when @sortField = 'TripName' and @sortDirection ='Descending' then    Trip.TripName  End   desc,             
 case when @sortField = 'TripName' and @sortDirection ='Ascending' then    Trip.TripName  End   asc,          
 case when @sortField = 'Depart' and @sortDirection ='Descending' then    Trip.startDate  End   desc,             
 case when @sortField = 'Depart' and @sortDirection ='Ascending' then    Trip.startDate  End   asc,          
 case when @sortField = 'Return' and @sortDirection ='Descending' then    Trip.endDate  End   desc,             
 case when @sortField = 'Return' and @sortDirection ='Ascending' then    Trip.endDate  End   asc,          
 case when @sortField = 'Status' and @sortDirection ='Descending' then     S.tripStatusName  End   desc,             
 case when @sortField = 'Status' and @sortDirection ='Ascending' then     S.tripStatusName  End   asc,          
 case when @sortField = 'Amount' and @sortDirection ='Descending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   desc,             
 case when @sortField = 'Amount' and @sortDirection ='Ascending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   asc),           
   Trip.tripKey, Trip.TripRequestKey, Trip.tripName, Trip.userKey, Trip.recordLocator, Trip.startDate,        
   Trip.endDate, Trip.tripStatusKey, Trip.agencyKey,                       
   U.userFirstName, U.userLastName, U.userLogin   ,trip.tripPurchasedKey   
  FROM trip WITH(NOLOCK)             
   INNER JOIN Vault.dbo.[User] U WITH(NOLOCK) ON trip.userKey =  U.UserKey AND Trip.tripStatusKey <> 10 AND Trip.tripStatusKey <> 17           
   INNER JOIN TripStatusLookup S WITH (NOLOCK) ON Trip.tripStatusKey = S.tripStatusKey         
   INNER JOIN #tblUser TU ON U.userKey = TU.userKey        
   LEFT OUTER JOIN TripAirResponse TAR WITH (NOLOCK) ON trip.tripPurchasedKey = TAR.tripGUIDKey        
   LEFT OUTER JOIN TripCarResponse TCR WITH (NOLOCK) ON trip.tripPurchasedKey = TCR.tripGUIDKey        
   LEFT OUTER JOIN TripHotelResponse THR WITH (NOLOCK) ON trip.tripPurchasedKey = THR.tripGUIDKey        
   LEFT OUTER JOIN TripAirSegmentOptionalServices OPT WITH (NOLOCK) ON trip.tripKey = OPT.tripKey AND OPT.isDeleted = 0           
   WHERE 1=1                     
    AND Trip.tripKey = CASE WHEN @tripKey = 0 THEN Trip.tripKey ELSE @tripKey END                     
    AND Trip.startDate between @fromDate and @toDate                     
    AND dbo.IsTripStatusAsPerType(ISNULL(@status,Trip.tripStatusKey),@PageName) = 1                     
    AND Trip.recordlocator IS NOT NULL AND Trip.recordlocator <> '' AND                     
    Trip.endDate >= GETDATE() AND Trip.tripStatusKey = ISNULL(@status,Trip.tripStatusKey)        
    AND Trip.siteKey = CASE WHEN @siteKey IS NULL THEN Trip.siteKey ELSE @siteKey END  --Added for TFS 861           
        
  SELECT @totalRecords = COUNT(*) FROM #tmpTrip     ---get total records count in output parameter          
                
  SELECT distinct trip.tripKey, TripRequestKey, tripName, userKey, recordLocator, startDate, endDate,                    
   tripStatusKey, agencyKey, userFirstName, userLastName, userLogin           
  FROM #tmpTrip trip          
  --WHERE RowID > (@pageNo-1)*@pageSize AND RowID <= @pageNo*@pageSize            
                      
        ---  get the Air, car and hotel response detail for filtered trips                        
  SELECT vt.TYPE, vt.tripKey, vt.recordLocator, vt.basecost, vt.tax, vt.vendorcode,                    
   vt.VendorName, vt.airSegmentDepartureAirport, vt.airSegmentArrivalAirport, vt.flightNumber,               
   vt.departuredate, vt.arrivaldate, vt.carType, vt.Ratingtype, vt.responseKey, vt.vendorLocator        
  FROM vw_TripDetails_tripaudit vt WITH(NOLOCK)                     
   INNER JOIN #tmpTrip tmp ON tmp.tripKey = vt.tripKey        
   INNER JOIN TripStatusLookup S WITH (NOLOCK) ON tmp.tripStatusKey = S.tripStatusKey        
   LEFT OUTER JOIN TripAirResponse TAR WITH (NOLOCK) ON tmp.tripPurchasedKey = TAR.tripGUIDKey        
   LEFT OUTER JOIN TripCarResponse TCR WITH (NOLOCK) ON tmp.tripPurchasedKey = TCR.tripGUIDKey        
  LEFT OUTER JOIN TripHotelResponse THR WITH (NOLOCK) ON tmp.tripPurchasedKey = THR.tripGUIDKey        
   LEFT OUTER JOIN TripAirSegmentOptionalServices OPT WITH (NOLOCK) ON tmp.tripKey = OPT.tripKey AND OPT.isDeleted = 0           
  ORDER BY      -----Implemented sorting        
    case when @sortField = 'Traveler' and @sortDirection ='Descending' then    ltrim(tmp.userFirstName)     End   desc,             
 case when @sortField = 'Traveler' and @sortDirection ='Ascending' then    ltrim(tmp.userFirstName)  End   asc ,            
 case when @sortField = 'TripName' and @sortDirection ='Descending' then    tmp.TripName  End   desc,             
 case when @sortField = 'TripName' and @sortDirection ='Ascending' then    tmp.TripName  End   asc,          
 case when @sortField = 'Depart' and @sortDirection ='Descending' then    tmp.startDate  End   desc,             
 case when @sortField = 'Depart' and @sortDirection ='Ascending' then    tmp.startDate  End   asc,          
 case when @sortField = 'Return' and @sortDirection ='Descending' then    tmp.endDate  End   desc,             
 case when @sortField = 'Return' and @sortDirection ='Ascending' then    tmp.endDate  End   asc,          
 case when @sortField = 'Status' and @sortDirection ='Descending' then     S.tripStatusName  End   desc,             
 case when @sortField = 'Status' and @sortDirection ='Ascending' then     S.tripStatusName  End   asc,          
 case when @sortField = 'Amount' and @sortDirection ='Descending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   desc,             
case when @sortField = 'Amount' and @sortDirection ='Ascending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   asc        
                            
  SELECT OPT.*                     
  FROM TripAirSegmentOptionalServices OPT WITH(NOLOCK)                     
   INNER JOIN #tmpTrip T ON OPT.tripKey = T.tripKey AND isDeleted = 0         
 END       
 ELSE IF @PageName = 'pasttripname'      
 BEGIN     
  UPDATE Trip SET tripStatusKey = 3 WHERE tripStatusKey = 2 AND endDate < GETDATE()                
  INSERT INTO #tmpTrip                     
  SELECT RowID = ROW_NUMBER() OVER ( order by  -----Implemented sorting        
 case when @sortField = 'Traveler' and @sortDirection ='Descending' then    ltrim(U.userFirstName)     End   desc,             
 case when @sortField = 'Traveler' and @sortDirection ='Ascending' then    ltrim(U.userFirstName)  End   asc ,            
 case when @sortField = 'TripName' and @sortDirection ='Descending' then    Trip.TripName  End   desc,             
 case when @sortField = 'TripName' and @sortDirection ='Ascending' then    Trip.TripName  End   asc,          
 case when @sortField = 'Depart' and @sortDirection ='Descending' then    Trip.startDate  End   desc,             
 case when @sortField = 'Depart' and @sortDirection ='Ascending' then    Trip.startDate  End   asc,          
 case when @sortField = 'Return' and @sortDirection ='Descending' then    Trip.endDate  End   desc,             
 case when @sortField = 'Return' and @sortDirection ='Ascending' then    Trip.endDate  End   asc,          
 case when @sortField = 'Status' and @sortDirection ='Descending' then     S.tripStatusName  End   desc,             
 case when @sortField = 'Status' and @sortDirection ='Ascending' then     S.tripStatusName  End   asc,          
 case when @sortField = 'Amount' and @sortDirection ='Descending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   desc,             
 case when @sortField = 'Amount' and @sortDirection ='Ascending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   asc),           
   Trip.tripKey, Trip.TripRequestKey, Trip.tripName, Trip.userKey, Trip.recordLocator,                    
   Trip.startDate, Trip.endDate, Trip.tripStatusKey, Trip.agencyKey,                     
   U.userFirstName, U.userLastName, U.userLogin    , trip.tripPurchasedKey  
  FROM trip WITH(NOLOCK)                     
   INNER JOIN Vault.dbo.[User] U WITH(NOLOCK) ON trip.userKey = U.UserKey  AND Trip.tripStatusKey <> 10 AND Trip.tripStatusKey <> 17                   
   INNER JOIN vw_TripDetails_tripaudit TD WITH (NOLOCK) ON trip.tripKey = TD.tripKey        
   INNER JOIN TripStatusLookup S WITH (NOLOCK) ON Trip.tripStatusKey = S.tripStatusKey         
   INNER JOIN #tblUser TU ON U.userKey = TU.userKey        
   LEFT OUTER JOIN TripAirResponse TAR WITH (NOLOCK) ON trip.tripPurchasedKey = TAR.tripGUIDKey        
   LEFT OUTER JOIN TripCarResponse TCR WITH (NOLOCK) ON trip.tripPurchasedKey = TCR.tripGUIDKey        
   LEFT OUTER JOIN TripHotelResponse THR WITH (NOLOCK) ON trip.tripPurchasedKey = THR.tripGUIDKey        
   LEFT OUTER JOIN TripAirSegmentOptionalServices OPT WITH (NOLOCK) ON trip.tripKey = OPT.tripKey AND OPT.isDeleted = 0           
   WHERE 1=1        
    AND Trip.tripKey = CASE WHEN @tripKey = 0 THEN Trip.tripKey ELSE @tripKey END                     
    AND Trip.startDate BETWEEN @fromDate AND @toDate                     
    AND dbo.IsTripStatusAsPerType(ISNULL(@status, Trip.tripStatusKey), @PageName) = 1                     
    AND Trip.recordlocator IS NOT NULL AND Trip.recordlocator <> '' AND                     
     Trip.endDate < GETDATE() AND Trip.tripStatusKey = ISNULL(@status, Trip.tripStatusKey)                     
AND Trip.siteKey = CASE WHEN @siteKey IS NULL THEN Trip.siteKey ELSE @siteKey END  --Added for TFS 861        
                      
  SELECT @totalRecords = COUNT(*) FROM #tmpTrip      ---get total records count in output parameter                     
  --select * from #tmpTrip              
  SELECT distinct tripKey, TripRequestKey, tripName, userKey, recordLocator, startDate, endDate,                    
   tripStatusKey, agencyKey, userFirstName, userLastName, userLogin          
  FROM #tmpTrip                     
  --WHERE RowID > (@pageNo-1)*@pageSize AND RowID <= @pageNo*@pageSize        
                    
        ---  get the Air, car and hotel response detail for filtered trips                        
  SELECT vt.TYPE, vt.tripKey, vt.recordLocator, vt.basecost, vt.tax, vt.vendorcode,                    
   vt.VendorName, vt.airSegmentDepartureAirport, vt.airSegmentArrivalAirport, vt.flightNumber,                    
   vt.departuredate, vt.arrivaldate, vt.carType, vt.Ratingtype, vt.responseKey, vt.vendorLocator                     
  FROM vw_TripDetails_tripaudit vt WITH(NOLOCK)                     
   INNER JOIN #tmpTrip tmp ON tmp.tripKey = vt.tripKey        
   INNER JOIN TripStatusLookup S WITH (NOLOCK) ON tmp.tripStatusKey = S.tripStatusKey        
   LEFT OUTER JOIN TripAirResponse TAR WITH (NOLOCK) ON tmp.tripPurchasedKey = TAR.tripGUIDKey        
   LEFT OUTER JOIN TripCarResponse TCR WITH (NOLOCK) ON tmp.tripPurchasedKey = TCR.tripGUIDKey        
   LEFT OUTER JOIN TripHotelResponse THR WITH (NOLOCK) ON tmp.tripPurchasedKey = THR.tripGUIDKey        
   LEFT OUTER JOIN TripAirSegmentOptionalServices OPT WITH (NOLOCK) ON tmp.tripKey = OPT.tripKey AND OPT.isDeleted = 0           
ORDER BY      -----Implemented sorting        
    case when @sortField = 'Traveler' and @sortDirection ='Descending' then    ltrim(tmp.userFirstName)     End   desc,             
 case when @sortField = 'Traveler' and @sortDirection ='Ascending' then    ltrim(tmp.userFirstName)  End   asc ,   
 case when @sortField = 'TripName' and @sortDirection ='Descending' then    tmp.TripName  End   desc,             
 case when @sortField = 'TripName' and @sortDirection ='Ascending' then    tmp.TripName  End   asc,          
 case when @sortField = 'Depart' and @sortDirection ='Descending' then    tmp.startDate  End   desc,             
 case when @sortField = 'Depart' and @sortDirection ='Ascending' then    tmp.startDate  End   asc,          
 case when @sortField = 'Return' and @sortDirection ='Descending' then    tmp.endDate  End   desc,             
 case when @sortField = 'Return' and @sortDirection ='Ascending' then    tmp.endDate  End   asc,          
 case when @sortField = 'Status' and @sortDirection ='Descending' then     S.tripStatusName  End   desc,             
 case when @sortField = 'Status' and @sortDirection ='Ascending' then     S.tripStatusName  End   asc,          
 case when @sortField = 'Amount' and @sortDirection ='Descending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   desc,             
 case when @sortField = 'Amount' and @sortDirection ='Ascending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   asc        
          
  SELECT OPT.*                     
  FROM TripAirSegmentOptionalServices OPT WITH(NOLOCK)                     
   INNER JOIN #tmpTrip T ON OPT.tripKey = T.tripKey AND isDeleted = 0                     
 END                               
 ELSE IF @PageName = 'pasttrips'                      
 BEGIN                     
---- Change the trip status from purchased to traveled of all trips which have purchased status and end date has been passed ----                             
  ---- LATER ON THIS IS STATEMENT SHOULD BE SCHEDULED TO EXECUTE EVERY DAY                          
  ---- START-----                          
  UPDATE Trip SET tripStatusKey = 3 WHERE tripStatusKey = 2 AND endDate < GETDATE()                     
  ---- END  -----                        
  INSERT INTO #tmpTrip                     
  SELECT RowID = ROW_NUMBER() OVER ( order by  -----Implemented sorting        
 case when @sortField = 'Traveler' and @sortDirection ='Descending' then    ltrim(U.userFirstName)     End   desc,             
 case when @sortField = 'Traveler' and @sortDirection ='Ascending' then    ltrim(U.userFirstName)  End   asc ,            
 case when @sortField = 'TripName' and @sortDirection ='Descending' then    Trip.TripName  End   desc,             
 case when @sortField = 'TripName' and @sortDirection ='Ascending' then    Trip.TripName  End   asc,          
 case when @sortField = 'Depart' and @sortDirection ='Descending' then    Trip.startDate  End   desc,             
 case when @sortField = 'Depart' and @sortDirection ='Ascending' then    Trip.startDate  End   asc,          
 case when @sortField = 'Return' and @sortDirection ='Descending' then    Trip.endDate  End   desc,             
 case when @sortField = 'Return' and @sortDirection ='Ascending' then    Trip.endDate  End   asc,          
 case when @sortField = 'Status' and @sortDirection ='Descending' then     S.tripStatusName  End   desc,             
 case when @sortField = 'Status' and @sortDirection ='Ascending' then     S.tripStatusName  End   asc,          
 case when @sortField = 'Amount' and @sortDirection ='Descending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   desc,             
 case when @sortField = 'Amount' and @sortDirection ='Ascending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   asc),           
   Trip.tripKey, Trip.TripRequestKey, Trip.tripName, Trip.userKey, Trip.recordLocator,                    
   Trip.startDate, Trip.endDate, Trip.tripStatusKey, Trip.agencyKey,                     
   U.userFirstName, U.userLastName, U.userLogin , trip.tripPurchasedKey  
  FROM trip WITH(NOLOCK)                     
   INNER JOIN Vault.dbo.[User] U WITH(NOLOCK) ON trip.userKey = U.UserKey  AND Trip.tripStatusKey <> 10 AND Trip.tripStatusKey <> 17                   
   INNER JOIN vw_TripDetails_tripaudit TD WITH (NOLOCK) ON trip.tripKey = TD.tripKey        
   INNER JOIN TripStatusLookup S WITH (NOLOCK) ON Trip.tripStatusKey = S.tripStatusKey         
   INNER JOIN #tblUser TU ON U.userKey = TU.userKey        
   LEFT OUTER JOIN TripAirResponse TAR WITH (NOLOCK) ON trip.tripPurchasedKey = TAR.tripGUIDKey        
   LEFT OUTER JOIN TripCarResponse TCR WITH (NOLOCK) ON trip.tripPurchasedKey = TCR.tripGUIDKey        
   LEFT OUTER JOIN TripHotelResponse THR WITH (NOLOCK) ON trip.tripPurchasedKey = THR.tripGUIDKey        
   LEFT OUTER JOIN TripAirSegmentOptionalServices OPT WITH (NOLOCK) ON trip.tripKey = OPT.tripKey AND OPT.isDeleted = 0           
   WHERE 1=1        
    AND Trip.tripKey = CASE WHEN @tripKey = 0 THEN Trip.tripKey ELSE @tripKey END                     
    AND Trip.startDate BETWEEN @fromDate AND @toDate                     
    AND dbo.IsTripStatusAsPerType(ISNULL(@status, Trip.tripStatusKey), @PageName) = 1                     
    AND Trip.recordlocator IS NOT NULL AND Trip.recordlocator <> '' AND                     
     Trip.endDate < GETDATE() AND Trip.tripStatusKey = ISNULL(@status, Trip.tripStatusKey)                     
AND Trip.siteKey = CASE WHEN @siteKey IS NULL THEN Trip.siteKey ELSE @siteKey END  --Added for TFS 861        
                      
  SELECT @totalRecords = COUNT(*) FROM #tmpTrip      ---get total records count in output parameter                     
 --select * from #tmpTrip            
  SELECT distinct tripKey, TripRequestKey, tripName, userKey, recordLocator, startDate, endDate,                    
   tripStatusKey, agencyKey, userFirstName, userLastName, userLogin          
  FROM #tmpTrip                     
  WHERE RowID > (@pageNo-1)*@pageSize AND RowID <= @pageNo*@pageSize        
                    
        ---  get the Air, car and hotel response detail for filtered trips                        
  SELECT vt.TYPE, vt.tripKey, vt.recordLocator, vt.basecost, vt.tax, vt.vendorcode,                    
   vt.VendorName, vt.airSegmentDepartureAirport, vt.airSegmentArrivalAirport, vt.flightNumber,                    
   vt.departuredate, vt.arrivaldate, vt.carType, vt.Ratingtype, vt.responseKey, vt.vendorLocator                     
  FROM vw_TripDetails_tripaudit vt WITH(NOLOCK)                     
   INNER JOIN #tmpTrip tmp ON tmp.tripKey = vt.tripKey        
   INNER JOIN TripStatusLookup S WITH (NOLOCK) ON tmp.tripStatusKey = S.tripStatusKey        
   LEFT OUTER JOIN TripAirResponse TAR WITH (NOLOCK) ON tmp.tripPurchasedKey = TAR.tripGUIDKey        
   LEFT OUTER JOIN TripCarResponse TCR WITH (NOLOCK) ON tmp.tripPurchasedKey = TCR.tripGUIDKey        
   LEFT OUTER JOIN TripHotelResponse THR WITH (NOLOCK) ON tmp.tripPurchasedKey = THR.tripGUIDKey        
   LEFT OUTER JOIN TripAirSegmentOptionalServices OPT WITH (NOLOCK) ON tmp.tripKey = OPT.tripKey AND OPT.isDeleted = 0           
ORDER BY      -----Implemented sorting        
    case when @sortField = 'Traveler' and @sortDirection ='Descending' then    ltrim(tmp.userFirstName)     End   desc,             
 case when @sortField = 'Traveler' and @sortDirection ='Ascending' then    ltrim(tmp.userFirstName)  End   asc ,            
 case when @sortField = 'TripName' and @sortDirection ='Descending' then    tmp.TripName  End   desc,             
 case when @sortField = 'TripName' and @sortDirection ='Ascending' then    tmp.TripName  End   asc,          
 case when @sortField = 'Depart' and @sortDirection ='Descending' then    tmp.startDate  End   desc,             
 case when @sortField = 'Depart' and @sortDirection ='Ascending' then    tmp.startDate  End   asc,          
 case when @sortField = 'Return' and @sortDirection ='Descending' then    tmp.endDate  End   desc,             
 case when @sortField = 'Return' and @sortDirection ='Ascending' then    tmp.endDate  End   asc,          
 case when @sortField = 'Status' and @sortDirection ='Descending' then     S.tripStatusName  End   desc,             
 case when @sortField = 'Status' and @sortDirection ='Ascending' then     S.tripStatusName  End   asc,          
 case when @sortField = 'Amount' and @sortDirection ='Descending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   desc,             
 case when @sortField = 'Amount' and @sortDirection ='Ascending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) + isnull(OPT.serviceAmount, 0)  End   asc        
       
  SELECT OPT.*                     
  FROM TripAirSegmentOptionalServices OPT WITH(NOLOCK)                     
   INNER JOIN #tmpTrip T ON OPT.tripKey = T.tripKey AND isDeleted = 0                     
 END                         
 ELSE IF @PageName = 'savedtrips' AND @tripKey = 0                         
 BEGIN                        
  INSERT INTO #tmpTrip                     
   SELECT RowID = ROW_NUMBER() OVER (ORDER BY    -----Implemented sorting        
 case when @sortField = 'Traveler' and @sortDirection ='Descending' then    ltrim(U.userFirstName)     End   desc,             
 case when @sortField = 'Traveler' and @sortDirection ='Ascending' then    ltrim(U.userFirstName)  End   asc ,            
 case when @sortField = 'TripName' and @sortDirection ='Descending' then    Trip.TripName  End   desc,             
 case when @sortField = 'TripName' and @sortDirection ='Ascending' then    Trip.TripName  End   asc,          
 case when @sortField = 'Depart' and @sortDirection ='Descending' then    Trip.startDate  End   desc,             
 case when @sortField = 'Depart' and @sortDirection ='Ascending' then    Trip.startDate  End   asc,          
 case when @sortField = 'Return' and @sortDirection ='Descending' then    Trip.endDate  End   desc,             
 case when @sortField = 'Return' and @sortDirection ='Ascending' then    Trip.endDate  End   asc,          
 case when @sortField = 'Status' and @sortDirection ='Descending' then     S.tripStatusName  End   desc,             
 case when @sortField = 'Status' and @sortDirection ='Ascending' then     S.tripStatusName  End   asc,          
 case when @sortField = 'Amount' and @sortDirection ='Descending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0)  End   desc,             
 case when @sortField = 'Amount' and @sortDirection ='Ascending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0)  End   asc),        
    Trip.tripKey, Trip.TripRequestKey, Trip.tripName, Trip.userKey, Trip.recordLocator, Trip.startDate,                    
    Trip.endDate, Trip.tripStatusKey, Trip.agencyKey,                     
    U.userFirstName, U.userLastName, U.userLogin  
   FROM trip WITH(NOLOCK)                     
    INNER JOIN Vault.dbo.[User] U WITH(NOLOCK) ON trip.userKey = U.UserKey  AND Trip.tripStatusKey <> 10 AND Trip.tripStatusKey <> 17       
    INNER JOIN vw_TripDetails_tripaudit TD WITH (NOLOCK) ON trip.tripKey = TD.tripKey        
    INNER JOIN #tblUser TU ON U.userKey = TU.userKey                      
    INNER JOIN TripAirResponse TAR WITH (NOLOCK) ON trip.tripPurchasedKey = TAR.tripGUIDKey        
    LEFT OUTER JOIN TripCarResponse TCR WITH (NOLOCK) ON trip.tripPurchasedKey = TCR.tripGUIDKey        
    LEFT OUTER JOIN TripHotelResponse THR WITH (NOLOCK) ON trip.tripPurchasedKey = THR.tripGUIDKey        
   WHERE 1=1 AND trip.tripKey = CASE WHEN @tripKey = 0 THEN trip.tripKey ELSE @tripKey END                     
     AND trip.startDate BETWEEN @fromDate AND @toDate         
     AND dbo.IsTripStatusAsPerType(ISNULL(@status, Trip.tripStatusKey), @PageName) = 1                     
     AND trip.recordlocator IS NULL OR trip.recordlocator = ''         
     AND Trip.siteKey = CASE WHEN @siteKey IS NULL THEN Trip.siteKey ELSE @siteKey END  --Added for TFS 861                    
                       
  SELECT @totalRecords = COUNT(*) FROM #tmpTrip      ---get total records count in output parameter                     
                    
  SELECT tripKey, TripRequestKey, tripName, userKey, recordLocator, startDate, endDate,                    
   tripStatusKey, agencyKey, userFirstName, userLastName, userLogin                     
  FROM #tmpTrip                     
  WHERE RowID > (@pageNo-1) * @pageSize AND RowID <= @pageNo*@pageSize                   
  ORDER BY tripkey DESC                     
                    
        ---  get the Air, car and hotel response detail for filtered trips                      
 SELECT vt.TYPE, vt.tripKey, vt.recordLocator, vt.basecost, vt.tax, vt.vendorcode,                    
   vt.VendorName, vt.airSegmentDepartureAirport, vt.airSegmentArrivalAirport, vt.flightNumber,                    
   vt.departuredate, vt.arrivaldate, vt.carType, vt.Ratingtype, vt.responseKey, vt.vendorLocator                     
  FROM vw_TripDetails_tripaudit vt WITH(NOLOCK)                     
   INNER JOIN #tmpTrip tmp ON  tmp.tripKey = vt.tripKey                     
   INNER JOIN TripStatusLookup S WITH (NOLOCK) ON tmp.tripStatusKey = S.tripStatusKey           
   INNER JOIN TripAirResponse TAR WITH (NOLOCK) ON tmp.tripPurchasedKey = TAR.tripGUIDKey        
   LEFT OUTER JOIN TripCarResponse TCR WITH (NOLOCK) ON tmp.tripPurchasedKey = TCR.tripGUIDKey        
   LEFT OUTER JOIN TripHotelResponse THR WITH (NOLOCK) ON tmp.tripPurchasedKey = THR.tripGUIDKey        
ORDER BY      -----Implemented sorting        
    case when @sortField = 'Traveler' and @sortDirection ='Descending' then    ltrim(tmp.userFirstName)     End   desc,             
 case when @sortField = 'Traveler' and @sortDirection ='Ascending' then    ltrim(tmp.userFirstName)  End   asc ,            
 case when @sortField = 'TripName' and @sortDirection ='Descending' then    tmp.TripName  End   desc,             
 case when @sortField = 'TripName' and @sortDirection ='Ascending' then    tmp.TripName  End   asc,          
 case when @sortField = 'Depart' and @sortDirection ='Descending' then    tmp.startDate  End   desc,             
 case when @sortField = 'Depart' and @sortDirection ='Ascending' then    tmp.startDate  End   asc,          
 case when @sortField = 'Return' and @sortDirection ='Descending' then    tmp.endDate  End   desc,             
 case when @sortField = 'Return' and @sortDirection ='Ascending' then    tmp.endDate  End   asc,          
 case when @sortField = 'Status' and @sortDirection ='Descending' then     S.tripStatusName  End   desc,             
 case when @sortField = 'Status' and @sortDirection ='Ascending' then     S.tripStatusName  End   asc,          
 case when @sortField = 'Amount' and @sortDirection ='Descending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0) End   desc,             
 case when @sortField = 'Amount' and @sortDirection ='Ascending' then    isnull(TAR.actualAirPrice, 0) + isnull(TAR.actualAirTax, 0) + isnull(TCR.actualCarPrice, 0) + isnull(TCR.actualCarTax, 0) + isnull(THR.actualHotelPrice, 0) + isnull(THR.actualHotelTax, 0)  End   asc        
           
  SELECT OPT.*                     
  FROM TripAirSegmentOptionalServices OPT WITH(NOLOCK)                     
   INNER JOIN #tmpTrip T  ON OPT. tripKey = T.tripKey AND isDeleted = 0                     
 END                      
 ELSE IF @PageName = 'bids'                     
 BEGIN                    
  SET @tripKey = CASE WHEN @tripKey = 0 THEN NULL ELSE @tripKey END                     
                      
  INSERT INTO #tmpTrip                     
  SELECT RowID = ROW_NUMBER() OVER (ORDER BY tripkey desc),                     
   Trip.tripKey, Trip.TripRequestKey, Trip.tripName, Trip.userKey, Trip.recordLocator, Trip.startDate,                    
   Trip.endDate, Trip.tripStatusKey, Trip.agencyKey,                     
   U.userFirstName, U.userLastName, U.userLogin        
  FROM trip WITH(NOLOCK)                     
   LEFT OUTER JOIN Vault.dbo.[User] U WITH(NOLOCK) ON trip.userKey = U.UserKey AND Trip.tripStatusKey = 10                    
    AND trip.siteKey = ISNULL(@siteKey, trip.siteKey)                    
    --AND trip.CreatedDate >= ISNULL(CONVERT(DATETIME, @createdDate, 103), trip.createdDate)                    
    AND trip.CreatedDate >= ISNULL(@createdDate, trip.createdDate)                    
  WHERE tripKey = ISNULL(@tripKey, tripKey) AND recordlocator IS NOT NULL AND recordlocator <> ''                     
                       
                       
                       
  SELECT tripKey,TripRequestKey,tripName,userKey,recordLocator,startDate,endDate,                    
   tripStatusKey,agencyKey,userFirstName,userLastName,userLogin                      
  FROM #tmpTrip                          
  WHERE RowID > (@pageNo-1)*@pageSize AND RowID <= @pageNo*@pageSize                     
  ORDER BY tripkey DESC                        
                      
                       
  if @TripCompType = 'all'                     
   SET @TripCompType = NULL                    
                       
   SELECT vt.TYPE, vt.tripKey, vt.tripRequestKey, vt.recordLocator, vt.basecost, vt.tax, vt.vendorcode,                    
     vt.VendorName, vt.airSegmentDepartureAirport, vt.airSegmentArrivalAirport, vt.flightNumber,                    
     vt.departuredate, vt.arrivaldate, vt.carType, vt.Ratingtype, vt.responseKey, vt.vendorLocator,                    
     vt.VehicleCompanyName,vt.NoofDays                    
     ,vt.CityName as HotelCityName                    
     ,vt.StateCode as HotelStateCode                    
     ,vt.CountryCode as HotelCountryCode                    
     ,vt.HotelRating                   
    FROM vw_TripDetails vt WITH(NOLOCK)                      
      inner join #tmpTrip tmp on  tmp.tripKey = vt.tripKey AND vt.tripStatusKey <> 10                    
    WHERE vt.tripKey = ISNULL(@tripKey, vt.tripKey) AND vt.siteKey = ISNULL(@siteKey, vt.siteKey)                    
     --AND vt.CreatedDate >= ISNULL(CONVERT(DATETIME, @createdDate, 103), vt.createdDate)                    
     AND vt.CreatedDate >= ISNULL(@createdDate, vt.createdDate)                    
     and vt.TYPE = ISNULL(@TripCompType, vt.TYPE)                    
    ORDER BY tripKey DESC, type, segmentOrder, departuredate ASC                     
                    
             
                    
  SELECT @totalRecords=COUNT(*) FROM #tmpTrip                    
                      
  SELECT OPT.*                     
  FROM TripAirSegmentOptionalServices OPT WITH(NOLOCK)                         
  INNER JOIN Trip T ON OPT.tripKey = T.tripKey AND t.tripKey = ISNULL(@tripKey, t.tripKey) AND isDeleted = 0 AND T.tripStatusKey = 10                    
   AND t.siteKey = ISNULL(@siteKey, t.siteKey)                     
   --AND t.CreatedDate >= ISNULL(CONVERT(DATETIME, @createdDate, 103), t.createdDate)                    
AND t.CreatedDate >= ISNULL(@createdDate, t.createdDate)                    
  INNER JOIN #tmpTrip tmp ON  tmp.tripKey = t.tripKey                     
                      
 END                      
 ELSE  ------CALL FROM ANY OTHER PAGE                        
 BEGIN                          
  INSERT INTO #tmpTrip                     
  SELECT ROW_NUMBER() OVER (ORDER BY tripkey DESC),                        
   Trip.tripKey, Trip.TripRequestKey, Trip.tripName, Trip.userKey, Trip.recordLocator, Trip.startDate,                    
   Trip.endDate, Trip.tripStatusKey, Trip.agencyKey,                     
   U.userFirstName, U.userLastName, U.userLogin        
  FROM trip WITH(NOLOCK)                      
   INNER JOIN Vault.dbo.[User] U  WITH(NOLOCK) ON trip.userKey = U.UserKey AND Trip.tripStatusKey = 10                    
   INNER JOIN #tblUser TU ON U.userKey = TU.userKey                      
  WHERE 1=1 AND tripKey = CASE WHEN @tripKey = 0 THEN tripKey ELSE @tripKey END                     
    AND startDate BETWEEN @fromDate AND @toDate                     
    AND Trip.tripStatusKey = ISNULL(@status, Trip.tripStatusKey)                     
                      
  SELECT @totalRecords=COUNT(*) FROM #tmpTrip     ---get total records count in output parameter                     
                    
  SELECT tripKey, TripRequestKey, tripName, userKey, recordLocator, startDate, endDate,                    
   tripStatusKey, agencyKey, userFirstName, userLastName, userLogin                     
  FROM #tmpTrip                     
  WHERE RowID > (@pageNo-1)*@pageSize AND RowID <= @pageNo*@pageSize ORDER BY tripkey DESC                     
                    
  ---  get the Air, car and hotel response detail for filtered trips                        
  SELECT vt.TYPE, vt.tripKey, vt.recordLocator, vt.basecost, vt.tax, vt.vendorcode,                    
   vt.VendorName, vt.airSegmentDepartureAirport, vt.airSegmentArrivalAirport, vt.flightNumber,                    
   vt.departuredate, vt.arrivaldate, vt.carType, vt.Ratingtype, vt.responseKey, vt.vendorLocator                     
  FROM vw_TripDetails vt WITH(NOLOCK)                     
   INNER JOIN #tmpTrip tmp ON  tmp.tripKey = vt.tripKey AND vt.tripStatusKey <> 10                    
  ORDER BY tripKey DESC, type, segmentOrder, departuredate ASC                     
                            
  SELECT OPT.*                     
  FROM TripAirSegmentOptionalServices OPT WITH(NOLOCK)                     
   INNER JOIN #tmpTrip T  ON OPT.tripKey = T.tripKey AND isDeleted = 0                     
                    
 END                           
                             
    DROP TABLE #tmpTrip                      
    Drop Table #tblUser                      
END
GO
