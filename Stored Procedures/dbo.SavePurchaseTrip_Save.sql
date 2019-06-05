SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Ravindra Kocharekar>
-- Create date: <5th Sep 17>
-- Description:	<To Insert into Trip History Table>
-- declare @xmldata xml = N'<SavePurchasedTrip><TripPassenger><TripPassengerInfos><TripPassengerInfo><TripHistoryKey>00000000-0000-0000-0000-000000000000</TripHistoryKey><PassengerKey>562934</PassengerKey><PassengerTypeKey>1</PassengerTypeKey><IsPrimaryPassenger>True</IsPrimaryPassenger><AdditionalRequest></AdditionalRequest><PassengerEmailID>steve@via.biz</PassengerEmailID><PassengerFirstName>SteveRo</PassengerFirstName><PassengerLastName>Edgerton</PassengerLastName><PassengerLocale></PassengerLocale><PassengerTitle></PassengerTitle><PassengerGender>M</PassengerGender><PassengerBirthDate>5/8/1982 12:00:00 AM</PassengerBirthDate><TravelReferenceNo>1.1</TravelReferenceNo><TripRequestKey>521370</TripRequestKey><IsExcludePricingInfo>false</IsExcludePricingInfo><TripPassengerCreditCardInfos><TripPassengerCreditCardInfo><TripTypeComponent>7</TripTypeComponent><CreditCardKey>1717</CreditCardKey><creditCardVendorCode>VI</creditCardVendorCode><creditCardDescription>AirNew</creditCardDescription><creditCardLastFourDigit>1111</creditCardLastFourDigit><expiryMonth>1</expiryMonth><expiryYear>2021</expiryYear><NameOnCard>Milind Lad</NameOnCard><UsedforAir>1</UsedforAir><UsedforHotel>0</UsedforHotel><UsedforCar>0</UsedforCar><creditCardTypeKey>0</creditCardTypeKey></TripPassengerCreditCardInfo><TripPassengerCreditCardInfo><TripTypeComponent>7</TripTypeComponent><CreditCardKey>1717</CreditCardKey><creditCardVendorCode>VI</creditCardVendorCode><creditCardDescription>AirNew</creditCardDescription><creditCardLastFourDigit>1111</creditCardLastFourDigit><expiryMonth>1</expiryMonth><expiryYear>2021</expiryYear><NameOnCard>Milind Lad</NameOnCard><UsedforAir>0</UsedforAir><UsedforHotel>1</UsedforHotel><UsedforCar>0</UsedforCar><creditCardTypeKey>0</creditCardTypeKey></TripPassengerCreditCardInfo></TripPassengerCreditCardInfos><TripPassengerPreferences><TripPassengerAirPreference><ID>0</ID><OriginAirportCode></OriginAirportCode><TicketDelivery></TicketDelivery><AirSeatingType>2</AirSeatingType><AirRowType>0</AirRowType><AirMealType>3</AirMealType><AirSpecialSevicesType>0</AirSpecialSevicesType></TripPassengerAirPreference><TripPassengerHotelPreference><TripPassengerHotelVendorPreferences><TripPassengerHotelVendorPreference><ID>0</ID><HotelChainCode>AN</HotelChainCode><HotelChainName></HotelChainName><PreferenceNo>1</PreferenceNo><ProgramNumber>ANA123</ProgramNumber></TripPassengerHotelVendorPreference><TripPassengerHotelVendorPreference><ID>0</ID><HotelChainCode>HS</HotelChainCode><HotelChainName></HotelChainName><PreferenceNo>2</PreferenceNo><ProgramNumber>ABA123</ProgramNumber></TripPassengerHotelVendorPreference><TripPassengerHotelVendorPreference><ID>0</ID><HotelChainCode>HI</HotelChainCode><HotelChainName></HotelChainName><PreferenceNo>3</PreferenceNo><ProgramNumber>HOL123</ProgramNumber></TripPassengerHotelVendorPreference><TripPassengerHotelVendorPreference><ID>0</ID><HotelChainCode>HP</HotelChainCode><HotelChainName></HotelChainName><PreferenceNo>4</PreferenceNo><ProgramNumber>HYP123</ProgramNumber></TripPassengerHotelVendorPreference><TripPassengerHotelVendorPreference><ID>0</ID><HotelChainCode>HX</HotelChainCode><HotelChainName></HotelChainName><PreferenceNo>5</PreferenceNo><ProgramNumber>HAMP123</ProgramNumber></TripPassengerHotelVendorPreference><TripPassengerHotelVendorPreference><ID>0</ID><HotelChainCode>NY</HotelChainCode><HotelChainName></HotelChainName><PreferenceNo>6</PreferenceNo><ProgramNumber>AFF123</ProgramNumber></TripPassengerHotelVendorPreference><TripPassengerHotelVendorPreference><ID>0</ID><HotelChainCode>OT</HotelChainCode><HotelChainName></HotelChainName><PreferenceNo>7</PreferenceNo><ProgramNumber>OTH123</ProgramNumber></TripPassengerHotelVendorPreference><TripPassengerHotelVendorPreference><ID>0</ID><HotelChainCode>GI</HotelChainCode><HotelChainName></HotelChainName><PreferenceNo>8</PreferenceNo><ProgramNumber>DDD123</ProgramNumber></TripPassengerHotelVendorPreference><TripPassengerHotelVendorPreference><ID>0</ID><HotelChainCode>HH</HotelChainCode><HotelChainName></HotelChainName><PreferenceNo>9</PreferenceNo><ProgramNumber>HOTEL789</ProgramNumber></TripPassengerHotelVendorPreference></TripPassengerHotelVendorPreferences></TripPassengerHotelPreference><TripPassengerCarPreference><TripPassengerCarVendorPreferences><TripPassengerCarVendorPreference><ID>0</ID><CarVendorCode>ZD</CarVendorCode><CarVendorName></CarVendorName><PreferenceNo>1</PreferenceNo><ProgramNumber>SP874C</ProgramNumber></TripPassengerCarVendorPreference><TripPassengerCarVendorPreference><ID>0</ID><CarVendorCode>ZE</CarVendorCode><CarVendorName></CarVendorName><PreferenceNo>2</PreferenceNo><ProgramNumber>HER123</ProgramNumber></TripPassengerCarVendorPreference><TripPassengerCarVendorPreference><PassengerKey>562934</PassengerKey><ID>0</ID><CarVendorCode>ZR</CarVendorCode><CarVendorName></CarVendorName><PreferenceNo>3</PreferenceNo><ProgramNumber>DOL123</ProgramNumber></TripPassengerCarVendorPreference></TripPassengerCarVendorPreferences></TripPassengerCarPreference></TripPassengerPreferences><TripPassengerUDIDInfos><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3589</CompanyUDIDKey><CompanyUDIDDescription>ravi</CompanyUDIDDescription><CompanyUDIDNumber>3</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>1</ReportFieldType><TextEntryType>0</TextEntryType><UserID>562934</UserID><PassengerUDIDValue></PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>0</CompanyUDIDKey><CompanyUDIDDescription></CompanyUDIDDescription><CompanyUDIDNumber>17</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>0</ReportFieldType><TextEntryType>1</TextEntryType><UserID>562934</UserID><PassengerUDIDValue>S Edgerton</PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3587</CompanyUDIDKey><CompanyUDIDDescription>Test1</CompanyUDIDDescription><CompanyUDIDNumber>14</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>1</ReportFieldType><TextEntryType>0</TextEntryType><UserID>562934</UserID><PassengerUDIDValue>milind12345</PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>0</CompanyUDIDKey><CompanyUDIDDescription></CompanyUDIDDescription><CompanyUDIDNumber>11</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>0</ReportFieldType><TextEntryType>1</TextEntryType><UserID>562934</UserID><PassengerUDIDValue>218.98</PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3594</CompanyUDIDKey><CompanyUDIDDescription>q</CompanyUDIDDescription><CompanyUDIDNumber>12</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>1</ReportFieldType><TextEntryType>0</TextEntryType><UserID>562934</UserID><PassengerUDIDValue>218.98</PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>0</CompanyUDIDKey><CompanyUDIDDescription></CompanyUDIDDescription><CompanyUDIDNumber>300</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>2</ReportFieldType><TextEntryType>1</TextEntryType><UserID>562934</UserID><PassengerUDIDValue>steve@via.biz</PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3054</CompanyUDIDKey><CompanyUDIDDescription>TestData</CompanyUDIDDescription><CompanyUDIDNumber>5</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>True</IsPrintInvoice><ReportFieldType>2</ReportFieldType><TextEntryType>1</TextEntryType><UserID>562934</UserID><PassengerUDIDValue></PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3055</CompanyUDIDKey><CompanyUDIDDescription>DropData</CompanyUDIDDescription><CompanyUDIDNumber>8</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>1</ReportFieldType><TextEntryType>0</TextEntryType><UserID>562934</UserID><PassengerUDIDValue></PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3376</CompanyUDIDKey><CompanyUDIDDescription>PullDown</CompanyUDIDDescription><CompanyUDIDNumber>1</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>True</IsPrintInvoice><ReportFieldType>1</ReportFieldType><TextEntryType>0</TextEntryType><UserID>562934</UserID><PassengerUDIDValue></PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3402</CompanyUDIDKey><CompanyUDIDDescription>BookingANWS</CompanyUDIDDescription><CompanyUDIDNumber>81</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>2</ReportFieldType><TextEntryType>5</TextEntryType><UserID>562934</UserID><PassengerUDIDValue></PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3403</CompanyUDIDKey><CompanyUDIDDescription>BookingANWSC</CompanyUDIDDescription><CompanyUDIDNumber>80</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>2</ReportFieldType><TextEntryType>6</TextEntryType><UserID>562934</UserID><PassengerUDIDValue></PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3590</CompanyUDIDKey><CompanyUDIDDescription>MyField</CompanyUDIDDescription><CompanyUDIDNumber>13</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>True</IsPrintInvoice><ReportFieldType>2</ReportFieldType><TextEntryType>2</TextEntryType><UserID>562934</UserID><PassengerUDIDValue></PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3591</CompanyUDIDKey><CompanyUDIDDescription>testfield</CompanyUDIDDescription><CompanyUDIDNumber>16</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>2</ReportFieldType><TextEntryType>2</TextEntryType><UserID>562934</UserID><PassengerUDIDValue></PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3593</CompanyUDIDKey><CompanyUDIDDescription>abcc</CompanyUDIDDescription><CompanyUDIDNumber>28</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>2</ReportFieldType><TextEntryType>2</TextEntryType><UserID>562934</UserID><PassengerUDIDValue></PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3595</CompanyUDIDKey><CompanyUDIDDescription>ewr</CompanyUDIDDescription><CompanyUDIDNumber>9</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>1</ReportFieldType><TextEntryType>0</TextEntryType><UserID>562934</UserID><PassengerUDIDValue></PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3597</CompanyUDIDKey><CompanyUDIDDescription>Numeric</CompanyUDIDDescription><CompanyUDIDNumber>23</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>1</ReportFieldType><TextEntryType>0</TextEntryType><UserID>562934</UserID><PassengerUDIDValue></PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3380</CompanyUDIDKey><CompanyUDIDDescription>Email</CompanyUDIDDescription><CompanyUDIDNumber>6</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>2</ReportFieldType><TextEntryType>4</TextEntryType><UserID>562934</UserID><PassengerUDIDValue>DEVELOPMENT</PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>3055</CompanyUDIDKey><CompanyUDIDDescription>DropData</CompanyUDIDDescription><CompanyUDIDNumber>8</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>1</ReportFieldType><TextEntryType>0</TextEntryType><UserID>562934</UserID><PassengerUDIDValue>5</PassengerUDIDValue></TripPassengerUDIDInfo><TripPassengerUDIDInfo><PassengerKey>562934</PassengerKey><CompanyUDIDKey>0</CompanyUDIDKey><CompanyUDIDDescription></CompanyUDIDDescription><CompanyUDIDNumber>18</CompanyUDIDNumber><CompanyUDIDOptionID>0</CompanyUDIDOptionID><CompanyUDIDOptionCode></CompanyUDIDOptionCode><CompanyUDIDOptionText></CompanyUDIDOptionText><IsPrintInvoice>False</IsPrintInvoice><ReportFieldType>2</ReportFieldType><TextEntryType>1</TextEntryType><UserID>562934</UserID><PassengerUDIDValue>Cap90</PassengerUDIDValue></TripPassengerUDIDInfo></TripPassengerUDIDInfos></TripPassengerInfo></TripPassengerInfos></TripPassenger><TripComponents><Air><TripAirPrices><TripAirPrice><tripCategory>Actual</tripCategory><tripAdultBase>190.49</tripAdultBase><tripAdultTax>28.49</tripAdultTax><tripSeniorBase>0</tripSeniorBase><tripSeniorTax>0</tripSeniorTax><tripYouthBase>0</tripYouthBase><tripYouthTax>0</tripYouthTax><tripChildBase>0</tripChildBase><tripChildTax>0</tripChildTax><tripInfantBase>0</tripInfantBase><tripInfantTax>0</tripInfantTax><tripInfantWithSeatBase>0</tripInfantWithSeatBase><tripInfantWithSeatTax>0</tripInfantWithSeatTax><tripAirResponseTaxes><tripAirResponseTax><amount>4.1</amount><designator></designator><nature></nature><description>Segment Fee</description></tripAirResponseTax><tripAirResponseTax><amount>5.6</amount><designator></designator><nature></nature><description>Passenger Facility Charge</description></tripAirResponseTax><tripAirResponseTax><amount>4.5</amount><designator></designator><nature></nature><description>September 11th Security Fee</description></tripAirResponseTax><tripAirResponseTax><amount>14.29</amount><designator></designator><nature></nature><description>Excise Tax</description></tripAirResponseTax></tripAirResponseTaxes></TripAirPrice><TripAirPrice><tripCategory>Reprice</tripCategory><tripAdultBase>190.49</tripAdultBase><tripAdultTax>28.49</tripAdultTax><tripSeniorBase>0</tripSeniorBase><tripSeniorTax>0</tripSeniorTax><tripYouthBase>0</tripYouthBase><tripYouthTax>0</tripYouthTax><tripChildBase>0</tripChildBase><tripChildTax>0</tripChildTax><tripInfantBase>0</tripInfantBase><tripInfantTax>0</tripInfantTax><tripInfantWithSeatBase>0</tripInfantWithSeatBase><tripInfantWithSeatTax>0</tripInfantWithSeatTax><tripAirResponseTaxes><tripAirResponseTax><amount>4.1</amount><designator></designator><nature></nature><description>Segment Fee</description></tripAirResponseTax><tripAirResponseTax><amount>5.6</amount><designator></designator><nature></nature><description>Passenger Facility Charge</description></tripAirResponseTax><tripAirResponseTax><amount>14.29</amount><designator></designator><nature></nature><description>Excise Tax</description></tripAirResponseTax><tripAirResponseTax><amount>4.5</amount><designator></designator><nature></nature><description>September 11th Security Fee</description></tripAirResponseTax><tripAirResponseTax><amount>5</amount><designator></designator><nature></nature><description>BOOKING CHARGE</description></tripAirResponseTax></tripAirResponseTaxes></TripAirPrice><TripAirPrice><tripCategory>Search</tripCategory><tripAdultBase>190.49</tripAdultBase><tripAdultTax>28.49</tripAdultTax><tripSeniorBase>0</tripSeniorBase><tripSeniorTax>0</tripSeniorTax><tripYouthBase>0</tripYouthBase><tripYouthTax>0</tripYouthTax><tripChildBase>0</tripChildBase><tripChildTax>0</tripChildTax><tripInfantBase>0</tripInfantBase><tripInfantTax>0</tripInfantTax><tripInfantWithSeatBase>0</tripInfantWithSeatBase><tripInfantWithSeatTax>0</tripInfantWithSeatTax></TripAirPrice></TripAirPrices><TripAirResponse><searchAirPrice>190.49</searchAirPrice><searchAirTax>28.49</searchAirTax><actualAirPrice>190.49</actualAirPrice><actualAirTax>28.49</actualAirTax><bookingcharges>5</bookingcharges><appliedDiscount>0</appliedDiscount><repricedAirPrice>190.49</repricedAirPrice><repricedAirTax>28.49</repricedAirTax><CurrencyCodeKey>USD</CurrencyCodeKey><isSplit>False</isSplit><agentWareQueryID>122167828</agentWareQueryID><agentwareItineraryID>916163292</agentwareItineraryID><TripAirLegs><TripAirSegments><TripAirLeg><gdsSourceKey>12</gdsSourceKey><selectedBrand></selectedBrand><recordLocator></recordLocator><airLegNumber>1</airLegNumber><validatingCarrier>WN</validatingCarrier><contractCode></contractCode><isRefundable>True</isRefundable><TripAirLegPassengerInfos><TripAirLegPassengerInfo><PassengerKey>562934</PassengerKey><ticketNumber>5268524561592</ticketNumber><InvoiceNumber></InvoiceNumber></TripAirLegPassengerInfo></TripAirLegPassengerInfos></TripAirLeg><TripAirSegment><airSegmentKey>d428a637-dd3d-4f6c-b016-272a81e86ef1</airSegmentKey><airLegNumber>1</airLegNumber><airSegmentMarketingAirlineCode>WN</airSegmentMarketingAirlineCode><airSegmentOperatingAirlineCode>WN</airSegmentOperatingAirlineCode><airSegmentFlightNumber>4008</airSegmentFlightNumber><airSegmentDuration>01:25:00</airSegmentDuration><airSegmentEquipment></airSegmentEquipment><airSegmentMiles>0</airSegmentMiles><airSegmentDepartureDate>10/15/2017 8:45:00 AM</airSegmentDepartureDate><airSegmentArrivalDate>10/15/2017 10:10:00 AM</airSegmentArrivalDate><airSegmentDepartureAirport>SFO</airSegmentDepartureAirport><airSegmentArrivalAirport>LAX</airSegmentArrivalAirport><airSegmentResBookDesigCode>Y</airSegmentResBookDesigCode><airSegmentDepartureOffset>0</airSegmentDepartureOffset><airSegmentArrivalOffset>0</airSegmentArrivalOffset><airSegmentSeatRemaining>0</airSegmentSeatRemaining><airSegmentMarriageGrp>          </airSegmentMarriageGrp><airFareBasisCode></airFareBasisCode><airFareReferenceKey></airFareReferenceKey><airSelectedSeatNumber></airSelectedSeatNumber><airsegmentcabin>Economy</airsegmentcabin><ticketNumber></ticketNumber><airSegmentOperatingFlightNumber>4008</airSegmentOperatingFlightNumber><RecordLocator>U2HI6S</RecordLocator><RPH>0</RPH><airSegmentOperatingAirlineCompanyShortName></airSegmentOperatingAirlineCompanyShortName><DepartureTerminal></DepartureTerminal><ArrivalTerminal></ArrivalTerminal><PNRNo>2727401</PNRNo><airSegmentBrandName>Anytime</airSegmentBrandName><TripAirSegmentPassengersInfo><TripAirSegmentPassengerInfo><PassengerKey>562934</PassengerKey><airFareBasisCode></airFareBasisCode><airSelectedSeatNumber></airSelectedSeatNumber><seatMapStatus></seatMapStatus></TripAirSegmentPassengerInfo></TripAirSegmentPassengersInfo></TripAirSegment></TripAirSegments></TripAirLegs><TripPolicyExceptions><TripPolicyException><TripRequestKey>521370</TripRequestKey><TimeBandTotalThresholdAmt>0</TimeBandTotalThresholdAmt><AlternateAirportTotalThresholdAmt>0</AlternateAirportTotalThresholdAmt><AdvancePurchaseAirportTotalThresholdAmt>0</AdvancePurchaseAirportTotalThresholdAmt><penaltyFareTotalThresholdAmt>0</penaltyFareTotalThresholdAmt><xConnectionsPolicyTotalThresholdAmt>0</xConnectionsPolicyTotalThresholdAmt><lowestPriceOfTrip>0</lowestPriceOfTrip><ReasonCode>229</ReasonCode><PolicyKey>2482</PolicyKey><ReasonDescription>OOP</ReasonDescription><thresholdamt>0</thresholdamt><LowFarePolicyAmt>0</LowFarePolicyAmt><LowestAmtFromAllPolicy>0</LowestAmtFromAllPolicy><TripHistoryKey>00000000-0000-0000-0000-000000000000</TripHistoryKey></TripPolicyException></TripPolicyExceptions></TripAirResponse></Air></TripComponents><SaveTrip><Trip><tripName>Trip-OFXWCH</tripName><userKey>562934</userKey><recordLocator>OFXWCH</recordLocator><tripStatusKey>1</tripStatusKey><agencyKey>1</agencyKey><siteKey>51</siteKey><tripComponentType>1</tripComponentType><tripRequestKey>521370</tripRequestKey><meetingCodeKey></meetingCodeKey><tripAdultsCount>1</tripAdultsCount><tripSeniorsCount>0</tripSeniorsCount><tripChildCount>0</tripChildCount><tripInfantCount>0</tripInfantCount><tripYouthCount>0</tripYouthCount><tripInfantWithSeatCount>0</tripInfantWithSeatCount><noOfTotalTraveler>1</noOfTotalTraveler><noOfRooms>0</noOfRooms><noOfCars>0</noOfCars><isAudit>False</isAudit><tripCreationPath>2</tripCreationPath><TrackingLogID>0</TrackingLogID><bookingFeeARC></bookingFeeARC><Issue_Date>9/5/2017 1:08:10 PM</Issue_Date><SabreCreationDate>9/5/2017 1:08:10 PM</SabreCreationDate><groupKey>1004</groupKey><EventKey></EventKey><AttendeeGuid></AttendeeGuid><UserIPAddress>::1</UserIPAddress><SessionId>1njpcefwvm54al2yx31yqv2e</SessionId><subsiteKey></subsiteKey><isArrangerBookForGuest>False</isArrangerBookForGuest><FailureReason></FailureReason></Trip><UpdateTrip><tripTotalBaseCost>190.49</tripTotalBaseCost><tripTotalTaxCost>28.49</tripTotalTaxCost><startdate>10/15/2017 8:45:00 AM</startdate><enddate>10/15/2017 8:45:00 AM</enddate><bookingCharges>5</bookingCharges><isOnlineBooking>True</isOnlineBooking></UpdateTrip><TripConfirmationFriendEmails /></SaveTrip></SavePurchasedTrip>'
-- EXEC [dbo].[SavePurchaseTrip_Save] @xmldata
-- =============================================
CREATE PROCEDURE [dbo].[SavePurchaseTrip_Save] 
	-- Add the parameters for the stored procedure here
	@xml XML
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRANSACTION
BEGIN TRY
	
	Declare @TripPurchaseKey uniqueidentifier = NEWID()
	Declare @tripId int
	SELECT @tripId = T.value('(tripKey/text())[1]','int')
	FROM @xml.nodes('/SavePurchasedTrip/SaveTrip/Trip')AS TEMPTABLE(T)
	
	Insert into [dbo].[TripPurchased] (tripPurchasedKey) values (@TripPurchaseKey)	
		
	INSERT INTO [TripStatusHistory] ([tripKey],[tripStatusKey],[createdDateTime])
	SELECT @tripId,  
	  TripStatusHistory.value('(tripStatusKey/text())[1]','int') AS tripStatusKey,
	  getdate()  
	FROM @xml.nodes('/SavePurchasedTrip/SaveTrip/Trip')AS TEMPTABLE(TripStatusHistory)
	
	---------------Passenger Info-----------------
	declare @xmlTripPassenger xml, @TripPassenger SavePurchaseTrip_TripPassenger
	select @xmlTripPassenger = @xml.query('/SavePurchasedTrip/TripPassenger')
	INSERT INTO @TripPassenger EXEC [dbo].[SavePurchaseTrip_TripPassenger_Insert] @xmlTripPassenger, @TripPurchaseKey, @tripId	  
		  
	---------------Travel Component-----------------	  	  
	declare @xmlTripAir xml
	select @xmlTripAir = @xml.query('/SavePurchasedTrip/TripComponents/Air')
	EXEC [dbo].[SavePurchaseTrip_TravelComponent_Air_Insert] @xmlTripAir, @TripPurchaseKey, @tripId, @TripPassenger
	
	declare @xmlTripHotel xml
	select @xmlTripHotel = @xml.query('/SavePurchasedTrip/TripComponents/Hotel')
	EXEC [dbo].[SavePurchaseTrip_TravelComponent_Hotel_Insert] @xmlTripHotel, @TripPurchaseKey, @TripPassenger
	
	declare @xmlTripCar xml
	select @xmlTripCar = @xml.query('/SavePurchasedTrip/TripComponents/Car')
	EXEC [dbo].[SavePurchaseTrip_TravelComponent_Car_Insert] @xmlTripCar, @TripPurchaseKey, @TripPassenger
	
	declare @xmlTripCruise xml
	select @xmlTripCruise = @xml.query('/SavePurchasedTrip/TripComponents/Cruise')
	EXEC [dbo].[SavePurchaseTrip_TravelComponent_Cruise_Insert] @xmlTripCruise, @TripPurchaseKey, @tripId
	
	declare @xmlTripActivity xml
	select @xmlTripActivity = @xml.query('/SavePurchasedTrip/TripComponents/Activity')
	EXEC [dbo].[SavePurchaseTrip_TravelComponent_Activity_Insert] @xmlTripActivity, @TripPurchaseKey, @tripId, @TripPassenger
	
	declare @xmlTripRail xml
	select @xmlTripRail = @xml.query('/SavePurchasedTrip/TripComponents/Rail')
	EXEC [dbo].[SavePurchaseTrip_TravelComponent_Rail_Insert] @xmlTripRail, @TripPurchaseKey, @tripId, @TripPassenger
	
	--EXEC [dbo].[USP_AddTripPromotionHistory] 
	INSERT INTO [Trip].[dbo].[TripPromotionHistory] ([PromoId],[PromoCampaignName],[PublicCode],[PromoCampaignType],[DiscountRate],[UsageRestriction]          
			   ,[OfferMatchType],[HotelVenorMatch],[HotelChainMatch],[HotelGroupMatch],[CitySpecificMatch],[SpecificAirportCodeMatch],[PurchaseStart],[PuchaseEnd]          
			   ,[TravelDateStart],[TravelDateEnd],[MinimumNightStayRequirement],[MinimumSpendRequirement],[PromoCodeApplied],[IsTravelAirCarHotelEligible]        
			   ,[IsAirHoteEligible],[IsHotelOnlyEligible],[IsAllActivtyEligible],[IsTravelToMexicoEligible],[IsTravelToCaribbeanEligible]        
			   ,[IsTravelToEuropeEligible],[IsTravelToSouthAmericaEligible],[UserKey],[CreateDate],[ModifiedDate],[CitySpecificMatchKey],[TripGuidKey],[PromotionDiscount]) 
		SELECT TripPromotionHistory.value('(PromoId/text())[1]','int') AS PromoId,  
		TripPromotionHistory.value('(PromoCampaignName/text())[1]','VARCHAR(50)') AS PromoCampaignName,
		TripPromotionHistory.value('(PublicCode/text())[1]','VARCHAR(100)') AS PublicCode,
		TripPromotionHistory.value('(PromoCampaignType/text())[1]','VARCHAR(100)') AS PromoCampaignType,
		TripPromotionHistory.value('(DiscountRate/text())[1]','VARCHAR(10)') AS DiscountRate,
		TripPromotionHistory.value('(UsageRestriction/text())[1]','VARCHAR(20)') AS UsageRestriction,
		TripPromotionHistory.value('(OfferMatchType/text())[1]','VARCHAR(100)') AS OfferMatchType,
		TripPromotionHistory.value('(HotelVendorMatch/text())[1]','VARCHAR(50)') AS HotelVendorMatch,
		TripPromotionHistory.value('(HotelChainMatch/text())[1]','VARCHAR(50)') AS HotelChainMatch,
		TripPromotionHistory.value('(HotelGroupMatch/text())[1]','VARCHAR(50)') AS HotelGroupMatch,
		TripPromotionHistory.value('(CitySpecificMatch/text())[1]','VARCHAR(50)') AS CitySpecificMatch,
		TripPromotionHistory.value('(SpecificAirportCodeMatch/text())[1]','VARCHAR(50)') AS SpecificAirportCodeMatch,
		(case when (charindex('-', TripPromotionHistory.value('(PurchaseStart/text())[1]','VARCHAR(30)')) > 0) 
			then CONVERT(datetime, TripPromotionHistory.value('(PurchaseStart/text())[1]','VARCHAR(30)'), 103) 
			else TripPromotionHistory.value('(PurchaseStart/text())[1]','datetime') end) AS PurchaseStart,
		(case when (charindex('-', TripPromotionHistory.value('(PurchaseEnd/text())[1]','VARCHAR(30)')) > 0) 
			then CONVERT(datetime, TripPromotionHistory.value('(PurchaseEnd/text())[1]','VARCHAR(30)'), 103) 
			else TripPromotionHistory.value('(PurchaseEnd/text())[1]','datetime') end) AS PurchaseEnd,
		(case when (charindex('-', TripPromotionHistory.value('(TravelDateStart/text())[1]','VARCHAR(30)')) > 0) 
			then CONVERT(datetime, TripPromotionHistory.value('(TravelDateStart/text())[1]','VARCHAR(30)'), 103) 
			else TripPromotionHistory.value('(TravelDateStart/text())[1]','datetime') end) AS TravelDateStart,
		(case when (charindex('-', TripPromotionHistory.value('(TravelDateEnd/text())[1]','VARCHAR(30)')) > 0) 
			then CONVERT(datetime, TripPromotionHistory.value('(TravelDateEnd/text())[1]','VARCHAR(30)'), 103) 
			else TripPromotionHistory.value('(TravelDateEnd/text())[1]','datetime') end) AS TravelDateEnd,	
		TripPromotionHistory.value('(MinimumNightStayRequirement/text())[1]','VARCHAR(50)') AS MinimumNightStayRequirement,
		TripPromotionHistory.value('(MinimumSpendRequirement/text())[1]','VARCHAR(50)') AS MinimumSpendRequirement,
		TripPromotionHistory.value('(PromoCodeApplied/text())[1]','VARCHAR(20)') AS PromoCodeApplied,
		TripPromotionHistory.value('(IsTravelAirCarHotelEligible/text())[1]','bit') AS IsTravelAirCarHotelEligible,	
		TripPromotionHistory.value('(IsAirHoteEligible/text())[1]','bit') AS IsAirHoteEligible,	
		TripPromotionHistory.value('(IsHotelOnlyEligible/text())[1]','bit') AS IsHotelOnlyEligible,	
		TripPromotionHistory.value('(IsAllActivtyEligible/text())[1]','bit') AS IsAllActivtyEligible,	
		TripPromotionHistory.value('(IsTravelToMexicoEligible/text())[1]','bit') AS IsTravelToMexicoEligible,	
		TripPromotionHistory.value('(IsTravelToCaribbeanEligible/text())[1]','bit') AS IsTravelToCaribbeanEligible,	
		TripPromotionHistory.value('(IsTravelToEuropeEligible/text())[1]','bit') AS IsTravelToEuropeEligible,	
		TripPromotionHistory.value('(IsTravelToSouthAmericaEligible/text())[1]','bit') AS IsTravelToSouthAmericaEligible,			
		TripPromotionHistory.value('(UserKey/text())[1]','VARCHAR(10)') AS UserKey, GETDATE(), GETDATE(),
		TripPromotionHistory.value('(CitySpecificMatchKey/text())[1]','VARCHAR(10)') AS CitySpecificMatchKey,
		@TripPurchaseKey,
		TripPromotionHistory.value('(PromotionDiscount/text())[1]','float') AS PromotionDiscount  
	FROM @xml.nodes('/SavePurchasedTrip/TripComponents/Promotion')AS TEMPTABLE(TripPromotionHistory)
	---------------Travel Component-----------------	  
	
	UPDATE T SET T.tripPurchasedKey = X.tripPurchasedKey, T.recordLocator = X.recordLocator, T.PurchaseComponentType  = X.PurchaseComponentType, 
				T.tripStatusKey = X.tripStatusKey, T.tripTotalBaseCost = X.tripTotalBaseCost, T.tripTotalTaxCost = X.tripTotalTaxCost, 
				T.startdate = X.startdate, T.enddate = X.enddate, T.tripName = X.tripName,
				T.bookingCharges = X.bookingCharges, T.promoId = X.promoId, T.cashRewardId = X.cashRewardId, 
				T.isUserCreatedSavedTrip = X.isUserCreatedSavedTrip FROM [dbo].[Trip] T 
		INNER JOIN (SELECT @TripPurchaseKey as tripPurchasedKey, @tripId as tripId, 
							UpdateTrip.value('(recordLocator/text())[1]','VARCHAR(50)') AS recordLocator,
							UpdateTrip.value('(PurchaseComponentType/text())[1]','int') AS PurchaseComponentType,
							UpdateTrip.value('(tripStatusKey/text())[1]','int') AS tripStatusKey,
							UpdateTrip.value('(tripTotalBaseCost/text())[1]','float') AS tripTotalBaseCost,
							UpdateTrip.value('(tripTotalTaxCost/text())[1]','float') AS tripTotalTaxCost,
							(case when (charindex('-', UpdateTrip.value('(startdate/text())[1]','VARCHAR(30)')) > 0) 
								then CONVERT(datetime, UpdateTrip.value('(startdate/text())[1]','VARCHAR(30)'), 103) 
								else UpdateTrip.value('(startdate/text())[1]','datetime') end) AS startdate,
							(case when (charindex('-', UpdateTrip.value('(enddate/text())[1]','VARCHAR(30)')) > 0) 
								then CONVERT(datetime, UpdateTrip.value('(enddate/text())[1]','VARCHAR(30)'), 103) 
								else UpdateTrip.value('(enddate/text())[1]','datetime') end) AS enddate,
							UpdateTrip.value('(tripName/text())[1]','VARCHAR(50)') AS tripName,
							UpdateTrip.value('(bookingCharges/text())[1]','float') AS bookingCharges,
							UpdateTrip.value('(promoId/text())[1]','int') AS promoId,
							UpdateTrip.value('(cashRewardId/text())[1]','int') AS cashRewardId,
							UpdateTrip.value('(isUserCreatedSavedTrip/text())[1]','bit') AS isUserCreatedSavedTrip
					FROM @xml.nodes('/SavePurchasedTrip/SaveTrip/Trip')AS TEMPTABLE(UpdateTrip))X ON T.tripKey = X.tripId 
	
	INSERT INTO [TripConfirmationFriendEmail] ([tripKey],[friendEmailAddress]) 
	SELECT @tripId,  
	  TripConfirmationFriendEmail.value('(FriendEmailAddress/text())[1]','VARCHAR(100)') AS FriendEmailAddress
	FROM @xml.nodes('/SavePurchasedTrip/SaveTrip/TripConfirmationFriendEmails/TripConfirmationFriendEmail')AS TEMPTABLE(TripConfirmationFriendEmail)
	
	COMMIT TRANSACTION;
	--print 'Commit'
END TRY
BEGIN CATCH
	--SELECT ERROR_NUMBER() AS ErrorNumber, ERROR_PROCEDURE() AS ErrorProcedure, ERROR_LINE() AS ErrorLine, ERROR_MESSAGE() AS ErrorMessage;
	ROLLBACK TRANSACTION;
	--print 'Rollback'
END CATCH
	
END
GO