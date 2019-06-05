CREATE TABLE [dbo].[TripRailResponse]
(
[RailResponseKey] [uniqueidentifier] NOT NULL,
[TripGUIDKey] [uniqueidentifier] NOT NULL,
[TripKey] [int] NULL,
[VendorCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SupplierId] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OriginLocationCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DestinationLocationCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TrainNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BaseFare] [decimal] (10, 2) NULL,
[Taxes] [decimal] (10, 2) NULL,
[Commission] [decimal] (10, 2) NULL,
[TotalPrice] [float] NOT NULL,
[DepartureDate] [datetime] NULL,
[ArrivalDate] [datetime] NULL,
[DepartureTime] [datetime] NULL,
[ArrivalTime] [datetime] NULL,
[ConfirmationNumber] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[InvoiceNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RecordLocator] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[status] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LinkCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Text] [varchar] (5000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NoOfAdult] [int] NOT NULL,
[TripPassengerInfoKey] [int] NULL,
[RPH] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsDeleted] [bit] NULL CONSTRAINT [DF__TripRailR__IsDel__232A17DA] DEFAULT ((0)),
[IsOnlineBooking] [bit] NULL CONSTRAINT [DF__TripRailR__IsOnl__241E3C13] DEFAULT ((1)),
[creationDate] [datetime] NULL
) ON [PRIMARY]
GO
