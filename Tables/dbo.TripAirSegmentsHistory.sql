CREATE TABLE [dbo].[TripAirSegmentsHistory]
(
[tripAirSegmentKey] [int] NOT NULL,
[airSegmentKey] [uniqueidentifier] NOT NULL,
[tripAirLegsKey] [int] NULL,
[airResponseKey] [uniqueidentifier] NOT NULL,
[airLegNumber] [int] NOT NULL,
[airSegmentMarketingAirlineCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[airSegmentOperatingAirlineCode] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[airSegmentFlightNumber] [int] NOT NULL,
[airSegmentDuration] [time] NULL,
[airSegmentEquipment] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[airSegmentMiles] [int] NULL,
[airSegmentDepartureDate] [datetime] NOT NULL,
[airSegmentArrivalDate] [datetime] NOT NULL,
[airSegmentDepartureAirport] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[airSegmentArrivalAirport] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[airSegmentResBookDesigCode] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[airSegmentDepartureOffset] [float] NULL,
[airSegmentArrivalOffset] [float] NULL,
[airSegmentSeatRemaining] [int] NULL,
[airSegmentMarriageGrp] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[airFareBasisCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[airFareReferenceKey] [varchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[airSelectedSeatNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ticketNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[airsegmentcabin] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[isDeleted] [bit] NULL,
[RecordLocator] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[airSegmentOperatingFlightNumber] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[seatMapStatus] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[airSegmentOperatingAirlineCompanyShortName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RPH] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DepartureTerminal] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ArrivalTerminal] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PNRNo] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[airSegmentFareCategory] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[airSegmentBrandName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO