SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Asha>
-- Create date: <Create Date,19JULY2011,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[USP_UpdateAddExpenseStatusForAir]
 @airResponseKey uniqueidentifier ,
 @tripKey int
 
AS
BEGIN
 
UPDATE TripAirResponse SET isExpenseAdded = 1 WHERE tripKey = @tripKey AND airResponseKey = @airResponseKey 
 	 
END
GO
