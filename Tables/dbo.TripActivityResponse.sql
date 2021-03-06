CREATE TABLE [dbo].[TripActivityResponse]
(
[ActivityResponseKey] [uniqueidentifier] NOT NULL,
[TripGUIDKey] [uniqueidentifier] NOT NULL,
[ConfirmationNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RecordLocator] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TotalPrice] [float] NOT NULL,
[ActivityType] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActivityTitle] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActivityText] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ActivityDate] [datetime] NOT NULL,
[VoucherURL] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CancellationFormURL] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TripKey] [int] NULL,
[NoOfAdult] [int] NOT NULL CONSTRAINT [DF__TripActiv__NoOfA__027D5126] DEFAULT ((0)),
[NoOfChild] [int] NOT NULL CONSTRAINT [DF__TripActiv__NoOfC__0371755F] DEFAULT ((0)),
[NoOfYouth] [int] NOT NULL CONSTRAINT [DF__TripActiv__NoOfY__04659998] DEFAULT ((0)),
[NoOfInfant] [int] NOT NULL CONSTRAINT [DF__TripActiv__NoOfI__0559BDD1] DEFAULT ((0)),
[NoOfSenior] [int] NOT NULL CONSTRAINT [DF__TripActiv__NoOfS__064DE20A] DEFAULT ((0)),
[Link] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TripPassengerInfoKey] [int] NULL,
[ActivityCode] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OptionCode] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isDeleted] [bit] NULL CONSTRAINT [DF__TripActiv__isDel__1B13F4C6] DEFAULT ((0)),
[AdultPrice] [decimal] (10, 2) NULL CONSTRAINT [DF_TripActivityResponse_AdultPrice] DEFAULT ((0)),
[ChildPrice] [decimal] (10, 2) NULL CONSTRAINT [DF_TripActivityResponse_ChildPrice] DEFAULT ((0)),
[SeniorPrice] [decimal] (10, 2) NULL CONSTRAINT [DF_TripActivityResponse_SeniorPrice] DEFAULT ((0)),
[InfantPrice] [decimal] (10, 2) NULL CONSTRAINT [DF_TripActivityResponse_InfantPrice] DEFAULT ((0)),
[YouthPrice] [decimal] (10, 2) NULL CONSTRAINT [DF_TripActivityResponse_YouthPrice] DEFAULT ((0)),
[RecommendedAdultPrice] [decimal] (10, 2) NULL CONSTRAINT [DF_TripActivityResponse_RecommendedAdultPrice] DEFAULT ((0)),
[RecommendedChildPrice] [decimal] (10, 2) NULL CONSTRAINT [DF_TripActivityResponse_RecommendedChildPrice] DEFAULT ((0)),
[RecommendedSeniorPrice] [decimal] (10, 2) NULL CONSTRAINT [DF_TripActivityResponse_RecommendedSeniorPrice] DEFAULT ((0)),
[RecommendedInfantPrice] [decimal] (10, 2) NULL CONSTRAINT [DF_TripActivityResponse_RecommendedInfantPrice] DEFAULT ((0)),
[RecommendedYouthPrice] [decimal] (10, 2) NULL CONSTRAINT [DF_TripActivityResponse_RecommendedYouthPrice] DEFAULT ((0)),
[TotalNetRate] [float] NULL,
[isOnlineBooking] [bit] NULL CONSTRAINT [DF__TripActiv__isOnl__666B225D] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TripActivityResponse] ADD CONSTRAINT [PK_TripActivityResponse] PRIMARY KEY CLUSTERED  ([ActivityResponseKey]) ON [PRIMARY]
GO
