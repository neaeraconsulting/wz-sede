## Response Properties
Property	Type	Description
format	String	The format of the response data
version	String	The Wanco Fleet Manager API Version
source	String	The source of the response data
time	ISO8601 Date String	Date/time of the most recent update within the response results
endpoint	URL	Endpoint of the request
continued	URL or Null/Absent	If the results are segmented with more available, Endpoint for the next segment
data	Object	SABP formatted data
data.document	Object	
data.document.format	String	The format of the response data
data.document.version	String	The SABP Version of the response data
data.document.source	String	The source of the response data
data.document.tier	Integer	The SABP Tier of the response data
data.document.timestamp	ISO8601 Date String	Date of the most recent update within the ressponse results
data.arrowboards	Array of Objects	An array of Arrow Board objects (note lowercase "b")
data.arrowboards[n]	Object	An Arrow Board object
data.arrowboards[n].id	String	SABP ID value
data.arrowboards[n].name	String	SABP Name value
data.arrowboards[n].lastContact	ISO8601 Date String	Date of the last transmitted data
data.arrowboards[n].firmware	String	Software version
data.arrowboards[n].voltage	Decimal	Battery voltage
data.arrowboards[n].errorCodes	Array or Null/Absent	
data.arrowboards[n].errorCodes[n]	String	Alarm title (see: Error Codes)
data.arrowboards[n].owner	Object	
data.arrowboards[n].owner.company	String	Company name of the owner
data.arrowboards[n].gps	Object	
data.arrowboards[n].gps.lock	Boolean	Whether the most recent GPS lock attempt was successful
data.arrowboards[n].gps.sampled	ISO8601 Date String	Date of the last attempt to lock GPS
data.arrowboards[n].gps.lat	Decimal	Latitude of the last attempt to lock GPS (0 if no lock)
data.arrowboards[n].gps.lon	Decimal	Longitude of the last attempt to lock GPS (0 if no lock)
data.arrowboards[n].gps.tried	ISO8601 Date String	Date of the last successful GPS lock
data.arrowboards[n].display	Object	
data.arrowboards[n].display.compass	Integer	180 degrees opposite of the compass direction the display is facing (0 = North), i.e. heading direction of on-coming traffic. Value of -999 if compass is unknown.
data.arrowboards[n].display.deployed	Boolean	Whether the display is deployed (rotated up for traffic visibility)
data.arrowboards[n].display.pattern	String	Displayed pattern (see: Display Patterns)



## Error Codes
Value	Description
CriticalVoltageLow	Battery voltage critically low (below 11.6v)
CriticalVoltageLampsDisabled	Battery voltage critically low (below 11.1v), lamps are off
CriticalVoltageDisconnect	Battery voltage critically low, shutdown process started
CriticalBoardTipped	The Arrow Board has overturned / tipped
CriticalMagnetometerError	An internal error with the magnetometer, orientation status unknown
CriticalRateLimited	An internal error is causing excessive automated reports to Fleet Manager, which are being blocked
WarningVoltageLow	Battery voltage low (below 12.0v)
WarningRemoteFourCorners	Four Corners Caution display pattern was activated via Fleet Manager
WarningSoftwareChecksumError	An internal error with the software boot loader
StatusStowedPosition	The display is in the stowed position