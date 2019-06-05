SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE FUNCTION [dbo].[ufn_CSVSplitStringtoInt] ( @StringInput VARCHAR(8000) )
RETURNS @OutputTable TABLE ( Value int )
AS
BEGIN

    DECLARE @String    VARCHAR(100)

    WHILE LEN(@StringInput) > 0
    BEGIN
        SET @String      = LEFT(@StringInput, 
                                ISNULL(NULLIF(CHARINDEX(',', @StringInput) - 1, -1),
                                LEN(@StringInput)))
        SET @StringInput = SUBSTRING(@StringInput,
                                     ISNULL(NULLIF(CHARINDEX(',', @StringInput), 0),
                                     LEN(@StringInput)) + 1, LEN(@StringInput))

        INSERT INTO @OutputTable ( Value )
        VALUES ( @String )
    END
    
    RETURN
END

GO