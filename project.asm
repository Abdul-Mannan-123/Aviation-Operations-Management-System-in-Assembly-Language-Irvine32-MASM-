; Combined Airline System (Irvine32 style)
; Login + Manage Flights + Manage Tickets + Manage Passengers + Staff + Aircraft


INCLUDE Irvine32.inc

.data
; -----------------------
; Common / Main menu
; -----------------------
welcomeMsg      BYTE "Welcome to Airline Operations Management System",0
loginMsg        BYTE "Enter Employee ID: ",0
invalidIDMsg    BYTE "Invalid ID. Try again.",0
accessMsg       BYTE "Login successful. Access granted.",0
validIDs     DWORD 101,202,303
validCount   DWORD 3

MAX_ATTEMPTS EQU 3
attempts     DWORD 0

attemptsLeftMsg BYTE "Attempts remaining: ",0
lockoutMsg      BYTE "Too many failed attempts. Program locked.",0

mainMenuMsg     BYTE "===== MAIN MENU =====",0
menuOptions     BYTE "1. Manage Flights",0Dh,0Ah, \
                 "2. Manage Tickets",0Dh,0Ah, \
                 "3. Manage Passengers",0Dh,0Ah, \
                 "4. Manage Staff",0Dh,0Ah, \
                 "5. Track Aircraft",0Dh,0Ah, \
                 "6. Exit",0Dh,0Ah,0
enterChoiceMsg  BYTE "Enter your choice: ",0
invalidChoiceMsg BYTE "Invalid choice! Try again.",0

pauseMsg        BYTE 13,10,"Press any key to continue...",0

; -----------------------
; Flight module data
; -----------------------
MAX_FLIGHTS     = 20
flightCount     DWORD 0
flightIDs       DWORD MAX_FLIGHTS DUP(0)
pilotIDs        DWORD MAX_FLIGHTS DUP(0)
destCodes       DWORD MAX_FLIGHTS DUP(0)
flightStatus    BYTE  MAX_FLIGHTS DUP(0) ; 1=Active,2=Delayed,3=Cancelled

flightMenuMsg       BYTE "===== MANAGE FLIGHTS =====",0
flightMenuOptions   BYTE "1. Add Flight",0Dh,0Ah, \
                      "2. List Flight IDs",0Dh,0Ah, \
                      "3. Show Flight Details",0Dh,0Ah, \
                      "4. Delete Flight",0Dh,0Ah, \
                      "5. Update Flight Status",0Dh,0Ah, \
                      "6. Back to Main Menu",0Dh,0Ah,0
flightMenuPrompt    BYTE "Enter your option: ",0
invalidFlightChoice BYTE "Invalid flight menu option!",0

addFlightMsg        BYTE "Enter Flight ID (numeric): ",0
addPilotMsg         BYTE "Enter Pilot ID (numeric): ",0
addDestMsg          BYTE "Enter Destination Code (numeric): ",0
flightSavedMsg      BYTE "Flight added.",0
duplicateMsg        BYTE "Flight ID already exists.",0
dbFullMsg           BYTE "Flight storage full.",0
viewFlightsHead     BYTE "===== FLIGHT IDs =====",0
enterFlightIDMsg    BYTE "Enter Flight ID: ",0
flightNotFoundMsg   BYTE "Flight not found.",0
delPromptMsg        BYTE "Enter Flight ID to delete: ",0
delSuccessMsg       BYTE "Flight deleted.",0
delFailMsg          BYTE "Flight not found. Cannot delete.",0
updatePromptMsg     BYTE "Enter Flight ID to update: ",0
statusPromptMsg     BYTE "Enter new status (1=Active,2=Delayed,3=Cancelled): ",0
statusUpdatedMsg    BYTE "Status updated.",0
detailHeader        BYTE "----- FLIGHT DETAILS -----",0
flightIDLabel       BYTE "Flight ID: ",0
pilotIDLabel        BYTE "Pilot ID: ",0
destCodeLabel       BYTE "Destination Code: ",0
statusActiveStr     BYTE "Status: Active",0
statusDelayedStr    BYTE "Status: Delayed",0
statusCancelledStr  BYTE "Status: Cancelled",0

; -----------------------
; Ticket module data
; -----------------------
MAX_TICKETS    = 50
ticketCount    DWORD 0
ticketFlight   BYTE MAX_TICKETS*10 DUP(0)
ticketPassenger BYTE MAX_TICKETS*20 DUP(0)
ticketStatus   BYTE MAX_TICKETS DUP(0) ; 1=Booked,0=Cancelled

menuTitleT      BYTE 13,10,"TICKET MANAGEMENT",13,10,0
menuT1          BYTE "1. Book a Ticket",13,10,0
menuT2          BYTE "2. Cancel a Ticket",13,10,0
menuT3          BYTE "3. Display Passenger List",13,10,0
menuT4          BYTE "4. Back",13,10,0
menuPromptT     BYTE 13,10,"Enter choice: ",0
promptNameT     BYTE "Enter passenger name: ",0
promptFlightT   BYTE "Enter flight code: ",0
promptTicketNum BYTE "Enter ticket number to cancel: ",0
msgBookSuccessT BYTE "Ticket booked successfully! Ticket #",0
msgCancelSuccessT BYTE "Ticket canceled successfully!",13,10,0
msgCancelFailT  BYTE "Invalid ticket number or ticket already canceled!",13,10,0
msgNoTicketsT   BYTE "No tickets booked yet.",13,10,0
msgMaxReachedT  BYTE "Maximum ticket limit reached!",13,10,0
headerTicket    BYTE 13,10,"Ticket#   Flight      Passenger",13,10,0
headerLineT     BYTE "-------------------------------------------",13,10,0

; -----------------------
; Passenger module data
; -----------------------
MAX_PASSENGERS = 50
passengerCount      DWORD 0
passengerNames      BYTE MAX_PASSENGERS*20 DUP(0)
passengerID         DWORD MAX_PASSENGERS DUP(0)
passengerFlight     BYTE MAX_PASSENGERS*10 DUP(0)

menuTitleP          BYTE "===== PASSENGER MANAGEMENT =====",0
menuP1              BYTE "1. Add Passenger",0Dh,0Ah,0
menuP2              BYTE "2. Delete Passenger",0Dh,0Ah,0
menuP3              BYTE "3. View All Passengers",0Dh,0Ah,0
menuP4              BYTE "4. View by Flight",0Dh,0Ah,0
menuP5              BYTE "5. View Sorted by ID",0Dh,0Ah,0
menuP6              BYTE "6. Back",0Dh,0Ah,0
menuPromptP         BYTE "Enter choice: ",0

promptNameP         BYTE "Enter passenger name: ",0
promptIDP           BYTE "Enter passenger ID: ",0
promptFlightP       BYTE "Enter flight code: ",0
promptDeleteIDP     BYTE "Enter passenger ID to delete: ",0
promptFlightViewP   BYTE "Enter flight code to view: ",0

msgAddSuccessP      BYTE "Passenger added successfully!",0Dh,0Ah,0
msgDeleteSuccessP   BYTE "Passenger deleted successfully!",0Dh,0Ah,0
msgDeleteFailP      BYTE "Passenger ID not found!",0Dh,0Ah,0
msgNoPassengersP    BYTE "No passengers registered yet.",0Dh,0Ah,0
msgMaxReachedP      BYTE "Passenger storage full!",0Dh,0Ah,0
msgDuplicateIDP     BYTE "Passenger ID already exists!",0Dh,0Ah,0
msgNoFlightMatchP   BYTE "No passengers found for this flight.",0Dh,0Ah,0

headerPassengerP    BYTE "ID        Name                Flight",0Dh,0Ah,0
headerLineP         BYTE "-----------------------------------------",0Dh,0Ah,0

spaces4             BYTE "    ",0
spaces8             BYTE "        ",0

nameBuffer          BYTE 20 DUP(0)
flightBuffer        BYTE 10 DUP(0)
inputBuffer         BYTE 20 DUP(0)

; -----------------------
; Staff module data
; -----------------------
MAX_STAFF EQU 50
staffNames BYTE MAX_STAFF*20 DUP(?)
staffRoles BYTE MAX_STAFF*15 DUP(?)
staffShift BYTE MAX_STAFF*10 DUP(?)
staffAttendance DWORD MAX_STAFF DUP(0)
staffHours DWORD MAX_STAFF DUP(0)
staffCount DWORD 0
menuTitleStaff BYTE 13,10,"STAFF MANAGEMENT",13,10,0
menuStaff1 BYTE "1. Add Staff Member",13,10,0
menuStaff2 BYTE "2. Mark Attendance",13,10,0
menuStaff3 BYTE "3. Update Working Hours",13,10,0
menuStaff4 BYTE "4. View All Staff",13,10,0
menuStaff5 BYTE "5. Edit Staff Info",13,10,0
menuStaff6 BYTE "6. Back to Main Menu",13,10,0
menuPromptStaff BYTE 13,10,"Enter choice: ",0
promptNameStaff BYTE "Enter staff name: ",0
promptRoleStaff BYTE "Enter role: ",0
promptShiftStaff BYTE "Enter shift: ",0
promptStaffNumStaff BYTE "Enter staff number: ",0
promptAttendanceStaff BYTE "Enter attendance days: ",0
promptHoursStaff BYTE "Enter working hours: ",0
msgAddSuccessStaff BYTE "Staff member added successfully!",13,10,0
msgUpdateSuccessStaff BYTE "Information updated successfully!",13,10,0
msgNoStaffStaff BYTE "No staff members registered yet.",13,10,0
msgMaxReachedStaff BYTE "Maximum staff limit reached!",13,10,0
msgInvalidChoiceStaff BYTE "Invalid choice! Try again.",13,10,0
msgInvalidStaffStaff BYTE "Invalid staff number!",13,10,0
headerStaffStaff BYTE 13,10,"No.  Name                Role            Shift      Attendance  Hours",13,10,0
headerLineStaff BYTE "------------------------------------------------------------------------",13,10,0
nameBufferStaff BYTE 20 DUP(?)
roleBufferStaff BYTE 15 DUP(?)
shiftBufferStaff BYTE 10 DUP(?)

; -----------------------
; Aircraft module data
; -----------------------
MAX_PLANES EQU 50
aircraftID BYTE MAX_PLANES*10 DUP(?)
aircraftStatus BYTE MAX_PLANES*15 DUP(?)
aircraftCount DWORD 0
menuTitleAircraft BYTE 13,10,"AIRCRAFT TRACKING",13,10,0
menuAircraft1 BYTE "1. Add Aircraft Record",13,10,0
menuAircraft2 BYTE "2. Mark Aircraft Available",13,10,0
menuAircraft3 BYTE "3. Mark Aircraft Unavailable",13,10,0
menuAircraft4 BYTE "4. Schedule Maintenance",13,10,0
menuAircraft5 BYTE "5. View Aircraft List",13,10,0
menuAircraft6 BYTE "6. Back to Main Menu",13,10,0
menuPromptAircraft BYTE 13,10,"Enter choice: ",0
promptIDAircraft BYTE "Enter aircraft ID: ",0
promptAircraftNumAircraft BYTE "Enter aircraft number: ",0
msgAddSuccessAircraft BYTE "Aircraft added successfully!",13,10,0
msgUpdateSuccessAircraft BYTE "Aircraft status updated successfully!",13,10,0
msgNoAircraftAircraft BYTE "No aircraft registered yet.",13,10,0
msgMaxReachedAircraft BYTE "Maximum aircraft limit reached!",13,10,0
msgInvalidChoiceAircraft BYTE "Invalid choice! Try again.",13,10,0
msgInvalidAircraftAircraft BYTE "Invalid aircraft number!",13,10,0
msgDuplicateIDAircraft BYTE "Aircraft ID already exists!",13,10,0
statusAvailableAircraft BYTE "Available",0
statusUnavailableAircraft BYTE "Unavailable",0
statusMaintenanceAircraft BYTE "Maintenance",0
headerAircraftAircraft BYTE 13,10,"No.  Aircraft ID    Status",13,10,0
headerLineAircraft BYTE "------------------------------------------------",13,10,0
idBufferAircraft BYTE 10 DUP(?)

.code

; -----------------------
; Helper: Print string + CRLF
; -----------------------
PrintLine PROC
    mov edx, [esp+4]
    call WriteString
    call CrLf
    ret 4
PrintLine ENDP

; -----------------------
; Helper: Pause (no name clash)
; -----------------------
PauseProc PROC
    push edx
    mov edx, OFFSET pauseMsg
    call WriteString
    call ReadChar
    pop edx
    ret
PauseProc ENDP

; -----------------------
; main
; -----------------------
main PROC
    call Clrscr

    ; Welcome
    push OFFSET welcomeMsg
    call PrintLine

    ; Login
    call LoginSystem

    ; Main menu
    call MainMenu

    exit
main ENDP

; -----------------------
; LoginSystem: loops until user enters a valid ID
; -----------------------
LoginSystem PROC

    mov attempts, 0      ; reset attempts

LoginLoop:

    call Clrscr
    mov edx, OFFSET welcomeMsg
    call WriteString
    call CrLf

    mov edx, OFFSET loginMsg
    call WriteString
    call ReadInt          ; eax = user input

    ; Reject invalid input (0 or negative)
    cmp eax, 1
    jl InvalidLogin

    ; Check ID
    mov ecx, validCount
    mov esi, OFFSET validIDs

CheckLoop:
    mov ebx, [esi]
    cmp ebx, eax
    je LoginSuccess

    add esi, 4
    loop CheckLoop

InvalidLogin:
    inc attempts
    cmp attempts, MAX_ATTEMPTS
    jge TooManyAttempts

    mov edx, OFFSET invalidIDMsg
    call WriteString
    call CrLf

    ; Show remaining attempts
    mov edx, OFFSET attemptsLeftMsg
    call WriteString

    mov eax, MAX_ATTEMPTS
    sub eax, attempts
    call WriteInt
    call CrLf

    call PauseProc
    jmp LoginLoop

LoginSuccess:
    mov edx, OFFSET accessMsg
    call WriteString
    call PauseProc
    ret

TooManyAttempts:
    mov edx, OFFSET lockoutMsg
    call WriteString
    call CrLf
    call PauseProc
    exit

LoginSystem ENDP

; -----------------------
; MainMenu (calls modules, does not jump into them)
; -----------------------
MainMenu PROC
MainLoop:
    call CrLf
    push OFFSET mainMenuMsg
    call PrintLine

    mov edx, OFFSET menuOptions
    call WriteString

    mov edx, OFFSET enterChoiceMsg
    call WriteString
    call ReadInt
    mov ebx, eax

    cmp ebx, 1
    je MM_Flights
    cmp ebx, 2
    je MM_Tickets
    cmp ebx, 3
    je MM_Passengers
    cmp ebx, 4
    je MM_Staff
    cmp ebx, 5
    je MM_Aircraft
    cmp ebx, 6
    je ExitProgram

    push OFFSET invalidChoiceMsg
    call PrintLine
    jmp MainLoop

MM_Flights:
    call ManageFlights
    jmp MainLoop

MM_Tickets:
    call ManageTickets
    jmp MainLoop

MM_Passengers:
    call ManagePassengers
    jmp MainLoop

MM_Staff:
    call ManageStaff
    jmp MainLoop

MM_Aircraft:
    call TrackAirplanes
    jmp MainLoop

ExitProgram:
    ret
MainMenu ENDP

; =======================
; Manage Flights module
; =======================
ManageFlights PROC

FlightMenuLoop:
    call CrLf
    push OFFSET flightMenuMsg
    call PrintLine

    mov edx, OFFSET flightMenuOptions
    call WriteString

    mov edx, OFFSET flightMenuPrompt
    call WriteString
    call ReadInt
    mov ebx, eax

    cmp ebx, 1
    je AddFlight
    cmp ebx, 2
    je ViewFlightIDs
    cmp ebx, 3
    je ShowFlightDetails
    cmp ebx, 4
    je DeleteFlight
    cmp ebx, 5
    je UpdateFlightStatus
    cmp ebx, 6
    ret

    push OFFSET invalidFlightChoice
    call PrintLine
    jmp FlightMenuLoop

; Add flight
AddFlight:
    mov eax, flightCount
    cmp eax, MAX_FLIGHTS
    jae AddFull

    mov edx, OFFSET addFlightMsg
    call WriteString
    call ReadInt
    mov esi, eax        ; newFlightID

    ; Check duplicate
    mov ecx, 0
AF_DupCheck:
    cmp ecx, flightCount
    jge AF_NoDup
    mov ebx, ecx
    shl ebx, 2
    mov eax, flightIDs[ebx]
    cmp eax, esi
    je AF_DupFound
    inc ecx
    jmp AF_DupCheck

AF_DupFound:
    push OFFSET duplicateMsg
    call PrintLine
    jmp FlightMenuLoop

AF_NoDup:
    mov edx, OFFSET addPilotMsg
    call WriteString
    call ReadInt
    mov edi, eax        ; pilotID

    mov edx, OFFSET addDestMsg
    call WriteString
    call ReadInt
    mov ebx, eax        ; destCode

    mov eax, flightCount
    mov ecx, eax
    shl eax, 2

    mov edx, esi
    mov flightIDs[eax], edx

    mov edx, edi
    mov pilotIDs[eax], edx

    mov edx, ebx
    mov destCodes[eax], edx

    mov BYTE PTR flightStatus[ecx], 1

    inc flightCount

    push OFFSET flightSavedMsg
    call PrintLine
    jmp FlightMenuLoop

AddFull:
    push OFFSET dbFullMsg
    call PrintLine
    jmp FlightMenuLoop

; View flight IDs
ViewFlightIDs:
    mov eax, flightCount
    cmp eax, 0
    je NoFlights

    push OFFSET viewFlightsHead
    call PrintLine

    mov ecx, 0
VF_Loop:
    cmp ecx, flightCount
    jge FlightMenuLoop
    mov ebx, ecx
    shl ebx, 2
    mov eax, flightIDs[ebx]
    call WriteInt
    call CrLf
    inc ecx
    jmp VF_Loop

NoFlights:
    push OFFSET flightNotFoundMsg
    call PrintLine
    jmp FlightMenuLoop

; Show flight details
ShowFlightDetails:
    mov edx, OFFSET enterFlightIDMsg
    call WriteString
    call ReadInt
    mov ebx, eax        ; targetID

    mov ecx, 0
SD_FindLoop:
    cmp ecx, flightCount
    jge SD_NotFound

    mov edi, ecx
    shl edi, 2
    mov eax, flightIDs[edi]
    cmp eax, ebx
    je SD_Found

    inc ecx
    jmp SD_FindLoop

SD_NotFound:
    push OFFSET flightNotFoundMsg
    call PrintLine
    jmp FlightMenuLoop

SD_Found:
    push OFFSET detailHeader
    call PrintLine

    mov edx, OFFSET flightIDLabel
    call WriteString
    mov eax, flightIDs[edi]
    call WriteInt
    call CrLf

    mov edx, OFFSET pilotIDLabel
    call WriteString
    mov eax, pilotIDs[edi]
    call WriteInt
    call CrLf

    mov edx, OFFSET destCodeLabel
    call WriteString
    mov eax, destCodes[edi]
    call WriteInt
    call CrLf

    mov al, flightStatus[ecx]
    cmp al, 1
    je SD_Active
    cmp al, 2
    je SD_Delayed
    cmp al, 3
    je SD_Cancelled
    jmp FlightMenuLoop

SD_Active:
    mov edx, OFFSET statusActiveStr
    call WriteString
    call CrLf
    jmp FlightMenuLoop

SD_Delayed:
    mov edx, OFFSET statusDelayedStr
    call WriteString
    call CrLf
    jmp FlightMenuLoop

SD_Cancelled:
    mov edx, OFFSET statusCancelledStr
    call WriteString
    call CrLf
    jmp FlightMenuLoop

; Delete flight
DeleteFlight:
    mov edx, OFFSET delPromptMsg
    call WriteString
    call ReadInt
    mov ebx, eax        ; idToDelete

    mov ecx, 0
DF_Find:
    cmp ecx, flightCount
    jge DF_NotFound
    mov edi, ecx
    shl edi, 2
    mov eax, flightIDs[edi]
    cmp eax, ebx
    je DF_DoDelete
    inc ecx
    jmp DF_Find

DF_NotFound:
    push OFFSET delFailMsg
    call PrintLine
    jmp FlightMenuLoop

DF_DoDelete:
DF_ShiftLoop:
    mov eax, flightCount
    dec eax
    cmp ecx, eax
    jge DF_ShiftDone

    mov edx, ecx
    mov edi, edx
    shl edi, 2
    mov esi, edx
    inc esi
    shl esi, 2

    mov eax, flightIDs[esi]
    mov flightIDs[edi], eax

    mov eax, pilotIDs[esi]
    mov pilotIDs[edi], eax

    mov eax, destCodes[esi]
    mov destCodes[edi], eax

    mov al, flightStatus[ecx+1]
    mov flightStatus[ecx], al

    inc ecx
    jmp DF_ShiftLoop

DF_ShiftDone:
    dec flightCount
    push OFFSET delSuccessMsg
    call PrintLine
    jmp FlightMenuLoop

; Update flight status
UpdateFlightStatus:
    mov edx, OFFSET updatePromptMsg
    call WriteString
    call ReadInt
    mov ebx, eax        ; targetID

    mov ecx, 0
UF_FindLoop:
    cmp ecx, flightCount
    jge UF_NotFound

    mov edi, ecx
    shl edi, 2
    mov eax, flightIDs[edi]
    cmp eax, ebx
    je UF_Found

    inc ecx
    jmp UF_FindLoop

UF_NotFound:
    push OFFSET flightNotFoundMsg
    call PrintLine
    jmp FlightMenuLoop

UF_Found:
    mov edx, OFFSET statusPromptMsg
    call WriteString
    call ReadInt
    ; Basic validation: ensure 1-3
    cmp eax, 1
    jl UF_InvalidStatus
    cmp eax, 3
    jg UF_InvalidStatus
    mov flightStatus[ecx], al
    push OFFSET statusUpdatedMsg
    call PrintLine
    jmp FlightMenuLoop

UF_InvalidStatus:
    push OFFSET invalidChoiceMsg
    call PrintLine
    jmp FlightMenuLoop

ManageFlights ENDP

; =======================
; Manage Tickets module
; =======================
ManageTickets PROC

TicketMenuLoop:
    call CrLf
    mov edx, OFFSET menuTitleT
    call WriteString
    call CrLf

    mov edx, OFFSET menuT1
    call WriteString
    mov edx, OFFSET menuT2
    call WriteString
    mov edx, OFFSET menuT3
    call WriteString
    mov edx, OFFSET menuT4
    call WriteString

    mov edx, OFFSET menuPromptT
    call WriteString
    call ReadInt
    cmp eax, 1
    je BookTicket
    cmp eax, 2
    je CancelTicket
    cmp eax, 3
    je DisplayTickets
    cmp eax, 4
    ret
    jmp TicketMenuLoop

; Book ticket
BookTicket:
    mov eax, ticketCount
    cmp eax, MAX_TICKETS
    jae MaxTicketsT

    mov edx, OFFSET promptNameT
    call WriteString
    mov edx, OFFSET nameBuffer
    mov ecx, 20
    call ReadString

    mov edx, OFFSET promptFlightT
    call WriteString
    mov edx, OFFSET flightBuffer
    mov ecx, 10
    call ReadString

    mov ebx, ticketCount

    ; Store passenger name
    mov eax, ebx
    imul eax, 20
    mov edi, OFFSET ticketPassenger
    add edi, eax
    mov esi, OFFSET nameBuffer
    mov ecx, 20
    rep movsb

    ; Store flight code
    mov eax, ebx
    imul eax, 10
    mov edi, OFFSET ticketFlight
    add edi, eax
    mov esi, OFFSET flightBuffer
    mov ecx, 10
    rep movsb

    ; Status = booked
    mov edi, OFFSET ticketStatus
    add edi, ebx
    mov BYTE PTR [edi], 1
    inc ticketCount

    mov edx, OFFSET msgBookSuccessT
    call WriteString
    mov eax, ebx
    inc eax
    call WriteInt
    call CrLf
    jmp TicketMenuLoop

MaxTicketsT:
    mov edx, OFFSET msgMaxReachedT
    call WriteString
    jmp TicketMenuLoop

; Cancel ticket
CancelTicket:
    mov eax, ticketCount
    cmp eax, 0
    je NoTicketsT
    mov edx, OFFSET promptTicketNum
    call WriteString
    call ReadInt
    dec eax
    cmp eax, 0
    jl InvalidTicket
    mov ebx, ticketCount
    cmp eax, ebx
    jge InvalidTicket
    mov edi, OFFSET ticketStatus
    add edi, eax
    mov bl, [edi]
    cmp bl, 0
    je InvalidTicket
    mov BYTE PTR [edi], 0
    mov edx, OFFSET msgCancelSuccessT
    call WriteString
    jmp TicketMenuLoop

InvalidTicket:
    mov edx, OFFSET msgCancelFailT
    call WriteString
    jmp TicketMenuLoop

NoTicketsT:
    mov edx, OFFSET msgNoTicketsT
    call WriteString
    jmp TicketMenuLoop

; Display tickets  (simplified formatting)
DisplayTickets:
    mov eax, ticketCount
    cmp eax, 0
    je NoTicketsT

    mov edx, OFFSET headerTicket
    call WriteString
    mov edx, OFFSET headerLineT
    call WriteString

    xor ebx, ebx
DT_Loop:
    cmp ebx, ticketCount
    jge DT_End

    ; check status
    mov edi, OFFSET ticketStatus
    add edi, ebx
    mov al, [edi]
    cmp al, 0
    je DT_Skip

    ; Ticket number
    mov eax, ebx
    inc eax
    mov edx, OFFSET spaces4
    call WriteString
    call WriteInt
    mov edx, OFFSET spaces4
    call WriteString

    ; Flight
    mov eax, ebx
    imul eax, 10
    mov edx, OFFSET ticketFlight
    add edx, eax
    call WriteString
    mov edx, OFFSET spaces4
    call WriteString

    ; Passenger name
    mov eax, ebx
    imul eax, 20
    mov edx, OFFSET ticketPassenger
    add edx, eax
    call WriteString
    call CrLf

DT_Skip:
    inc ebx
    jmp DT_Loop

DT_End:
    jmp TicketMenuLoop

ManageTickets ENDP

; ============================================
; PASSENGER MANAGEMENT MODULE (FINAL VERSION)
; ============================================

ManagePassengers PROC

PassengerMenuLoop:
    call Clrscr
    mov edx, OFFSET menuTitleP
    call WriteString
    call CrLf

    mov edx, OFFSET menuP1
    call WriteString
    mov edx, OFFSET menuP2
    call WriteString
    mov edx, OFFSET menuP3
    call WriteString
    mov edx, OFFSET menuP4
    call WriteString
    mov edx, OFFSET menuP5
    call WriteString
    mov edx, OFFSET menuP6
    call WriteString

    mov edx, OFFSET menuPromptP
    call WriteString
    call ReadInt

    cmp eax, 1
    je MP_Add

    cmp eax, 2
    je MP_Del

    cmp eax, 3
    je MP_ViewAll

    cmp eax, 4
    je MP_ViewByFlight

    cmp eax, 5
    je MP_Sorted

    cmp eax, 6
    ret            ; Back to main menu

    jmp PassengerMenuLoop


; -------------------------
; 1. ADD PASSENGER
; -------------------------
MP_Add:
    call AddPassengerProc
    call PauseProc
    jmp PassengerMenuLoop


; -------------------------
; 2. DELETE PASSENGER
; -------------------------
MP_Del:
    call DeletePassengerProc
    call PauseProc
    jmp PassengerMenuLoop


; -------------------------
; 3. VIEW ALL PASSENGERS
; -------------------------
MP_ViewAll:
    call ViewPassengerListProc
    call PauseProc
    jmp PassengerMenuLoop


; -------------------------
; 4. VIEW BY FLIGHT
; -------------------------
MP_ViewByFlight:
    call ViewPassengersByFlightProc
    call PauseProc
    jmp PassengerMenuLoop


; -------------------------
; 5. VIEW SORTED
; -------------------------
MP_Sorted:
    call ViewPassengersSortedProc
    call PauseProc
    jmp PassengerMenuLoop

ManagePassengers ENDP



; ============================================
; ADD PASSENGER
; ============================================
AddPassengerProc PROC

    mov eax, passengerCount
    cmp eax, MAX_PASSENGERS
    jae AddFullP

    ; Read ID
    mov edx, OFFSET promptIDP
    call WriteString
    call ReadInt
    mov ebx, eax       ; entered ID

    ; Check duplicate
    push ebx
    call CheckDuplicateID
    pop ebx
    cmp eax, 1
    je DuplicateP

    ; Read name
    mov edx, OFFSET promptNameP
    call WriteString
    mov edx, OFFSET nameBuffer
    mov ecx, 20
    call ReadString

    ; Read flight code
    mov edx, OFFSET promptFlightP
    call WriteString
    mov edx, OFFSET flightBuffer
    mov ecx, 10
    call ReadString

    ; Store ID
    mov eax, passengerCount
    shl eax, 2
    mov [passengerID + eax], ebx

    ; Store name
    mov eax, passengerCount
    imul eax, 20
    mov edi, OFFSET passengerNames
    add edi, eax
    mov esi, OFFSET nameBuffer
    mov ecx, 20
    rep movsb

    ; Store flight code
    mov eax, passengerCount
    imul eax, 10
    mov edi, OFFSET passengerFlight
    add edi, eax
    mov esi, OFFSET flightBuffer
    mov ecx, 10
    rep movsb

    inc passengerCount

    mov edx, OFFSET msgAddSuccessP
    call WriteString
    ret

AddFullP:
    mov edx, OFFSET msgMaxReachedP
    call WriteString
    ret

DuplicateP:
    mov edx, OFFSET msgDuplicateIDP
    call WriteString
    ret

AddPassengerProc ENDP



; ============================================
; DELETE PASSENGER
; ============================================
DeletePassengerProc PROC

    mov eax, passengerCount
    cmp eax, 0
    je NoPassengersP_Del

    mov edx, OFFSET promptDeleteIDP
    call WriteString
    call ReadInt
    mov ebx, eax ; ID to delete

    mov ecx, 0
SearchDeleteP:
    cmp ecx, passengerCount
    jge NotFoundDelP

    mov eax, ecx
    shl eax, 2
    mov eax, [passengerID + eax]
    cmp eax, ebx
    je FoundToDeleteP

    inc ecx
    jmp SearchDeleteP


FoundToDeleteP:
ShiftLeftP:
    mov eax, passengerCount
    dec eax
    cmp ecx, eax
    jge ShiftDoneP

    ; Shift ID
    mov esi, ecx
    shl esi, 2
    mov edi, esi
    add edi, 4
    mov eax, [passengerID + edi]
    mov [passengerID + esi], eax

    ; Shift NAME (20 bytes)
    mov esi, ecx
    imul esi, 20
    mov edi, esi
    add edi, 20
    push ecx
    mov ecx, 20
ShiftNameLoopP:
    mov al, [passengerNames + edi]
    mov [passengerNames + esi], al
    inc esi
    inc edi
    loop ShiftNameLoopP
    pop ecx

    ; Shift FLIGHT CODE (10 bytes)
    mov esi, ecx
    imul esi, 10
    mov edi, esi
    add edi, 10
    push ecx
    mov ecx, 10
ShiftFlightLoopP:
    mov al, [passengerFlight + edi]
    mov [passengerFlight + esi], al
    inc esi
    inc edi
    loop ShiftFlightLoopP
    pop ecx

    inc ecx
    jmp ShiftLeftP

ShiftDoneP:
    dec passengerCount
    mov edx, OFFSET msgDeleteSuccessP
    call WriteString
    ret

NotFoundDelP:
    mov edx, OFFSET msgDeleteFailP
    call WriteString
    ret

NoPassengersP_Del:
    mov edx, OFFSET msgNoPassengersP
    call WriteString
    ret

DeletePassengerProc ENDP



; ============================================
; VIEW ALL PASSENGERS
; ============================================
ViewPassengerListProc PROC

    mov eax, passengerCount
    cmp eax, 0
    je NoPassengersVP

    mov edx, OFFSET headerPassengerP
    call WriteString
    mov edx, OFFSET headerLineP
    call WriteString

    xor ebx, ebx
VPLoop:
    cmp ebx, passengerCount
    jge EndVP

    ; Print ID
    mov eax, ebx
    shl eax, 2
    mov eax, [passengerID + eax]
    call WriteInt
    mov edx, OFFSET spaces8
    call WriteString

    ; Print NAME
    mov eax, ebx
    imul eax, 20
    mov edx, OFFSET passengerNames
    add edx, eax
    call WriteString
    mov edx, OFFSET spaces4
    call WriteString

    ; Print FLIGHT CODE
    mov eax, ebx
    imul eax, 10
    mov edx, OFFSET passengerFlight
    add edx, eax
    call WriteString
    call CrLf

    inc ebx
    jmp VPLoop

EndVP:
    ret

NoPassengersVP:
    mov edx, OFFSET msgNoPassengersP
    call WriteString
    ret

ViewPassengerListProc ENDP



; ============================================
; VIEW PASSENGERS BY FLIGHT
; ============================================
ViewPassengersByFlightProc PROC

    mov eax, passengerCount
    cmp eax, 0
    je NoPBF

    mov edx, OFFSET promptFlightViewP
    call WriteString
    mov edx, OFFSET flightBuffer
    mov ecx, 10
    call ReadString

    mov edx, OFFSET headerPassengerP
    call WriteString
    mov edx, OFFSET headerLineP
    call WriteString

    xor ebx, ebx
    xor ebp, ebp   ; found counter

SearchPBF:
    cmp ebx, passengerCount
    jge DonePBF

    mov eax, ebx
    imul eax, 10
    mov esi, OFFSET passengerFlight
    add esi, eax
    mov edi, OFFSET flightBuffer
    mov ecx, 10

ComparePBF:
    mov al, [esi]
    mov dl, [edi]
    cmp al, dl
    jne NoMatchPBF
    cmp al, 0
    je MatchPBF
    inc esi
    inc edi
    dec ecx
    jnz ComparePBF

MatchPBF:
    inc ebp

    mov eax, ebx
    shl eax, 2
    mov eax, [passengerID + eax]
    call WriteInt
    mov edx, OFFSET spaces8
    call WriteString

    mov eax, ebx
    imul eax, 20
    mov edx, OFFSET passengerNames
    add edx, eax
    call WriteString
    mov edx, OFFSET spaces4
    call WriteString

    mov eax, ebx
    imul eax, 10
    mov edx, OFFSET passengerFlight
    add edx, eax
    call WriteString
    call CrLf

NoMatchPBF:
    inc ebx
    jmp SearchPBF

DonePBF:
    cmp ebp, 0
    je NonePBF
    ret

NonePBF:
    mov edx, OFFSET msgNoFlightMatchP
    call WriteString
    ret

NoPBF:
    mov edx, OFFSET msgNoPassengersP
    call WriteString
    ret

ViewPassengersByFlightProc ENDP



; ============================================
; SORTED VIEW (BUBBLE SORT)
; ============================================
ViewPassengersSortedProc PROC

    mov eax, passengerCount
    cmp eax, 1
    jle SortedDoneP

    mov ecx, passengerCount
    dec ecx

OuterSortP:
    xor ebx, ebx
InnerSortP:
    cmp ebx, ecx
    jge NextOuterP

    mov esi, ebx
    shl esi, 2
    mov edi, esi
    add edi, 4

    mov eax, [passengerID + esi]
    mov edx, [passengerID + edi]
    cmp eax, edx
    jle NoSwapP

    ; Swap IDs
    mov [passengerID + esi], edx
    mov [passengerID + edi], eax

    ; Swap Names (20 bytes)
    push ecx
    mov esi, ebx
    imul esi, 20
    mov edi, esi
    add edi, 20
    mov ecx, 20
SwapNameLoopP:
    mov al, [passengerNames + esi]
    mov ah, [passengerNames + edi]
    mov [passengerNames + esi], ah
    mov [passengerNames + edi], al
    inc esi
    inc edi
    loop SwapNameLoopP
    pop ecx

    ; Swap Flight Codes (10 bytes)
    push ecx
    mov esi, ebx
    imul esi, 10
    mov edi, esi
    add edi, 10
    mov ecx, 10
SwapFlightLoopP:
    mov al, [passengerFlight + esi]
    mov ah, [passengerFlight + edi]
    mov [passengerFlight + esi], ah
    mov [passengerFlight + edi], al
    inc esi
    inc edi
    loop SwapFlightLoopP
    pop ecx

NoSwapP:
    inc ebx
    jmp InnerSortP

NextOuterP:
    dec ecx
    jnz OuterSortP

SortedDoneP:
    call ViewPassengerListProc
    ret

ViewPassengersSortedProc ENDP



; ============================================
; CHECK DUPLICATE ID
; ============================================
CheckDuplicateID PROC

    mov ecx, 0
CheckLoopP:
    cmp ecx, passengerCount
    jge NotFoundP

    mov eax, ecx
    shl eax, 2
    mov eax, [passengerID + eax]
    cmp eax, ebx
    je FoundP

    inc ecx
    jmp CheckLoopP

FoundP:
    mov eax, 1
    ret

NotFoundP:
    mov eax, 0
    ret

CheckDuplicateID ENDP


; =======================
; Staff Module
; =======================
ManageStaff PROC
StaffMenuLoop:
    call Clrscr
    mov edx, OFFSET menuTitleStaff
    call WriteString
    mov edx, OFFSET menuStaff1
    call WriteString
    mov edx, OFFSET menuStaff2
    call WriteString
    mov edx, OFFSET menuStaff3
    call WriteString
    mov edx, OFFSET menuStaff4
    call WriteString
    mov edx, OFFSET menuStaff5
    call WriteString
    mov edx, OFFSET menuStaff6
    call WriteString
    mov edx, OFFSET menuPromptStaff
    call WriteString
    call ReadInt
    call CrLf
    cmp eax, 1
    je AddStaff
    cmp eax, 2
    je MarkAttendance
    cmp eax, 3
    je UpdateHours
    cmp eax, 4
    je ViewStaff
    cmp eax, 5
    je EditStaff
    cmp eax, 6
    ret  ; Back to main menu
    mov edx, OFFSET msgInvalidChoiceStaff
    call WriteString
    call PauseProc
    jmp StaffMenuLoop

AddStaff:
    call AddStaffProc
    call PauseProc
    jmp StaffMenuLoop

MarkAttendance:
    call MarkAttendanceProc
    call PauseProc
    jmp StaffMenuLoop

UpdateHours:
    call UpdateHoursProc
    call PauseProc
    jmp StaffMenuLoop

ViewStaff:
    call ViewStaffList
    call PauseProc
    jmp StaffMenuLoop

EditStaff:
    call EditStaffProc
    call PauseProc
    jmp StaffMenuLoop
ManageStaff ENDP

AddStaffProc PROC
    mov eax, staffCount
    cmp eax, MAX_STAFF
    jge MaxStaff
    mov edx, OFFSET promptNameStaff
    call WriteString
    mov edx, OFFSET nameBufferStaff
    mov ecx, 20
    call ReadString
    mov edx, OFFSET promptRoleStaff
    call WriteString
    mov edx, OFFSET roleBufferStaff
    mov ecx, 15
    call ReadString
    mov edx, OFFSET promptShiftStaff
    call WriteString
    mov edx, OFFSET shiftBufferStaff
    mov ecx, 10
    call ReadString

    mov eax, staffCount

    ; Name
    mov edi, OFFSET staffNames
    imul eax, 20
    add edi, eax
    mov esi, OFFSET nameBufferStaff
    mov ecx, 20
    rep movsb

    ; Role
    mov eax, staffCount
    mov edi, OFFSET staffRoles
    imul eax, 15
    add edi, eax
    mov esi, OFFSET roleBufferStaff
    mov ecx, 15
    rep movsb

    ; Shift
    mov eax, staffCount
    mov edi, OFFSET staffShift
    imul eax, 10
    add edi, eax
    mov esi, OFFSET shiftBufferStaff
    mov ecx, 10
    rep movsb

    ; Attendance & hours = 0
    mov eax, staffCount
    imul eax, 4
    mov edi, OFFSET staffAttendance
    add edi, eax
    mov DWORD PTR [edi], 0
    mov edi, OFFSET staffHours
    add edi, eax
    mov DWORD PTR [edi], 0

    inc staffCount
    mov edx, OFFSET msgAddSuccessStaff
    call WriteString
    ret

MaxStaff:
    mov edx, OFFSET msgMaxReachedStaff
    call WriteString
    ret
AddStaffProc ENDP

MarkAttendanceProc PROC
    mov eax, staffCount
    cmp eax, 0
    je NoStaff_Mark
    mov edx, OFFSET promptStaffNumStaff
    call WriteString
    call ReadInt
    dec eax
    cmp eax, 0
    jl Invalid_Mark
    cmp eax, staffCount
    jge Invalid_Mark
    mov ebx, eax
    mov edx, OFFSET promptAttendanceStaff
    call WriteString
    call ReadInt
    mov ecx, eax
    mov eax, ebx
    imul eax, 4
    mov edi, OFFSET staffAttendance
    add edi, eax
    mov [edi], ecx
    mov edx, OFFSET msgUpdateSuccessStaff
    call WriteString
    ret

Invalid_Mark:
    mov edx, OFFSET msgInvalidStaffStaff
    call WriteString
    ret

NoStaff_Mark:
    mov edx, OFFSET msgNoStaffStaff
    call WriteString
    ret
MarkAttendanceProc ENDP

UpdateHoursProc PROC
    mov eax, staffCount
    cmp eax, 0
    je NoStaff_Hours
    mov edx, OFFSET promptStaffNumStaff
    call WriteString
    call ReadInt
    dec eax
    cmp eax, 0
    jl Invalid_Hours
    cmp eax, staffCount
    jge Invalid_Hours
    mov ebx, eax
    mov edx, OFFSET promptHoursStaff
    call WriteString
    call ReadInt
    mov ecx, eax
    mov eax, ebx
    imul eax, 4
    mov edi, OFFSET staffHours
    add edi, eax
    mov [edi], ecx
    mov edx, OFFSET msgUpdateSuccessStaff
    call WriteString
    ret

Invalid_Hours:
    mov edx, OFFSET msgInvalidStaffStaff
    call WriteString
    ret

NoStaff_Hours:
    mov edx, OFFSET msgNoStaffStaff
    call WriteString
    ret
UpdateHoursProc ENDP

ViewStaffList PROC
    mov eax, staffCount
    cmp eax, 0
    je NoStaff_List
    mov edx, OFFSET headerStaffStaff
    call WriteString
    mov edx, OFFSET headerLineStaff
    call WriteString
    xor ebx, ebx

DisplayLoop:
    cmp ebx, staffCount
    jge EndDisplay
    mov eax, ebx
    inc eax
    call WriteDec
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar

    ; Name
    push ebx
    mov eax, ebx
    imul eax, 20
    mov edx, OFFSET staffNames
    add edx, eax
    call WriteString
    mov ecx, 20
    mov edi, edx

CountName:
    mov al, [edi]
    cmp al, 0
    je DoneName
    inc edi
    dec ecx
    jnz CountName

DoneName:
NameSpaceLoop:
    cmp ecx, 0
    jle DoneNameSpace
    mov al, ' '
    call WriteChar
    dec ecx
    jmp NameSpaceLoop

DoneNameSpace:
    pop ebx
    push ebx

    ; Role
    mov eax, ebx
    imul eax, 15
    mov edx, OFFSET staffRoles
    add edx, eax
    call WriteString
    mov ecx, 16
    mov edi, edx

CountRole:
    mov al, [edi]
    cmp al, 0
    je DoneRole
    inc edi
    dec ecx
    jnz CountRole

DoneRole:
RoleSpaceLoop:
    cmp ecx, 0
    jle DoneRoleSpace
    mov al, ' '
    call WriteChar
    dec ecx
    jmp RoleSpaceLoop

DoneRoleSpace:
    pop ebx
    push ebx

    ; Shift
    mov eax, ebx
    imul eax, 10
    mov edx, OFFSET staffShift
    add edx, eax
    call WriteString
    mov ecx, 11
    mov edi, edx

CountShift:
    mov al, [edi]
    cmp al, 0
    je DoneShift
    inc edi
    dec ecx
    jnz CountShift

DoneShift:
ShiftSpaceLoop:
    cmp ecx, 0
    jle DoneShiftSpace
    mov al, ' '
    call WriteChar
    dec ecx
    jmp ShiftSpaceLoop

DoneShiftSpace:
    pop ebx
    push ebx

    ; Attendance
    mov eax, ebx
    imul eax, 4
    mov edi, OFFSET staffAttendance
    add edi, eax
    mov eax, [edi]
    call WriteDec
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar

    ; Hours
    mov eax, ebx
    imul eax, 4
    mov edi, OFFSET staffHours
    add edi, eax
    mov eax, [edi]
    call WriteDec
    call Crlf

    pop ebx
    inc ebx
    jmp DisplayLoop

EndDisplay:
    ret

NoStaff_List:
    mov edx, OFFSET msgNoStaffStaff
    call WriteString
    ret
ViewStaffList ENDP

EditStaffProc PROC
    mov eax, staffCount
    cmp eax, 0
    je NoStaff_Edit
    mov edx, OFFSET promptStaffNumStaff
    call WriteString
    call ReadInt
    dec eax
    cmp eax, 0
    jl Invalid_Edit
    cmp eax, staffCount
    jge Invalid_Edit
    mov ebx, eax

    mov edx, OFFSET promptNameStaff
    call WriteString
    mov edx, OFFSET nameBufferStaff
    mov ecx, 20
    call ReadString

    mov edx, OFFSET promptRoleStaff
    call WriteString
    mov edx, OFFSET roleBufferStaff
    mov ecx, 15
    call ReadString

    mov edx, OFFSET promptShiftStaff
    call WriteString
    mov edx, OFFSET shiftBufferStaff
    mov ecx, 10
    call ReadString

    mov eax, ebx
    imul eax, 20
    mov edi, OFFSET staffNames
    add edi, eax
    mov esi, OFFSET nameBufferStaff
    mov ecx, 20
    rep movsb

    mov eax, ebx
    imul eax, 15
    mov edi, OFFSET staffRoles
    add edi, eax
    mov esi, OFFSET roleBufferStaff
    mov ecx, 15
    rep movsb

    mov eax, ebx
    imul eax, 10
    mov edi, OFFSET staffShift
    add edi, eax
    mov esi, OFFSET shiftBufferStaff
    mov ecx, 10
    rep movsb

    mov edx, OFFSET msgUpdateSuccessStaff
    call WriteString
    ret

Invalid_Edit:
    mov edx, OFFSET msgInvalidStaffStaff
    call WriteString
    ret

NoStaff_Edit:
    mov edx, OFFSET msgNoStaffStaff
    call WriteString
    ret
EditStaffProc ENDP

; =======================
; Aircraft Module
; =======================
TrackAirplanes PROC
AircraftMenuLoop:
    call Clrscr
    mov edx, OFFSET menuTitleAircraft
    call WriteString
    mov edx, OFFSET menuAircraft1
    call WriteString
    mov edx, OFFSET menuAircraft2
    call WriteString
    mov edx, OFFSET menuAircraft3
    call WriteString
    mov edx, OFFSET menuAircraft4
    call WriteString
    mov edx, OFFSET menuAircraft5
    call WriteString
    mov edx, OFFSET menuAircraft6
    call WriteString
    mov edx, OFFSET menuPromptAircraft
    call WriteString
    call ReadInt
    call Crlf
    cmp eax, 1
    je AddAircraft
    cmp eax, 2
    je MarkAvailable
    cmp eax, 3
    je MarkUnavailable
    cmp eax, 4
    je ScheduleMaintenance
    cmp eax, 5
    je ViewAircraft
    cmp eax, 6
    ret  ; Back to main menu
    mov edx, OFFSET msgInvalidChoiceAircraft
    call WriteString
    call PauseProc
    jmp AircraftMenuLoop

AddAircraft:
    call AddAircraftProc
    call PauseProc
    jmp AircraftMenuLoop

MarkAvailable:
    call MarkAvailableProc
    call PauseProc
    jmp AircraftMenuLoop

MarkUnavailable:
    call MarkUnavailableProc
    call PauseProc
    jmp AircraftMenuLoop

ScheduleMaintenance:
    call ScheduleMaintenanceProc
    call PauseProc
    jmp AircraftMenuLoop

ViewAircraft:
    call ViewAircraftList
    call PauseProc
    jmp AircraftMenuLoop
TrackAirplanes ENDP

AddAircraftProc PROC
    mov eax, aircraftCount
    cmp eax, MAX_PLANES
    jge MaxAircraft
    mov edx, OFFSET promptIDAircraft
    call WriteString
    mov edx, OFFSET idBufferAircraft
    mov ecx, 10
    call ReadString

    ; check duplicate
    call CheckDuplicateIDAircraft
    cmp eax, 1
    je DuplicateFound

    mov edi, aircraftCount
    mov eax, edi
    imul eax, 10
    mov edi, OFFSET aircraftID
    add edi, eax
    mov esi, OFFSET idBufferAircraft
    mov ecx, 10
    rep movsb

    mov eax, aircraftCount
    imul eax, 15
    mov edi, OFFSET aircraftStatus
    add edi, eax
    mov esi, OFFSET statusAvailableAircraft
    mov ecx, 15
    rep movsb

    inc aircraftCount
    mov edx, OFFSET msgAddSuccessAircraft
    call WriteString
    ret

MaxAircraft:
    mov edx, OFFSET msgMaxReachedAircraft
    call WriteString
    ret

DuplicateFound:
    mov edx, OFFSET msgDuplicateIDAircraft
    call WriteString
    ret
AddAircraftProc ENDP

CheckDuplicateIDAircraft PROC
    push ebx
    push ecx
    push edi
    push esi
    xor ebx, ebx

CheckLoopAircraft:
    cmp ebx, aircraftCount
    jge NotFoundAircraft
    mov eax, ebx
    imul eax, 10
    mov esi, OFFSET aircraftID
    add esi, eax
    mov edi, OFFSET idBufferAircraft
    mov ecx, 10

CompareLoopAircraft:
    mov al, [esi]
    mov dl, [edi]
    cmp al, dl
    jne NoMatchAircraft
    cmp al, 0
    je FoundAircraft
    inc esi
    inc edi
    dec ecx
    jnz CompareLoopAircraft
    jmp FoundAircraft

NoMatchAircraft:
    inc ebx
    jmp CheckLoopAircraft

FoundAircraft:
    mov eax, 1
    jmp CheckDoneAircraft

NotFoundAircraft:
    mov eax, 0

CheckDoneAircraft:
    pop esi
    pop edi
    pop ecx
    pop ebx
    ret
CheckDuplicateIDAircraft ENDP

MarkAvailableProc PROC
    mov eax, aircraftCount
    cmp eax, 0
    je NoAircraft_Avail
    mov edx, OFFSET promptAircraftNumAircraft
    call WriteString
    call ReadInt
    dec eax
    cmp eax, 0
    jl InvalidAircraft_Avail
    cmp eax, aircraftCount
    jge InvalidAircraft_Avail
    mov ebx, eax
    imul eax, 15
    mov edi, OFFSET aircraftStatus
    add edi, eax
    mov esi, OFFSET statusAvailableAircraft
    mov ecx, 15
    rep movsb
    mov edx, OFFSET msgUpdateSuccessAircraft
    call WriteString
    ret

InvalidAircraft_Avail:
    mov edx, OFFSET msgInvalidAircraftAircraft
    call WriteString
    ret

NoAircraft_Avail:
    mov edx, OFFSET msgNoAircraftAircraft
    call WriteString
    ret
MarkAvailableProc ENDP

MarkUnavailableProc PROC
    mov eax, aircraftCount
    cmp eax, 0
    je NoAircraft_Un
    mov edx, OFFSET promptAircraftNumAircraft
    call WriteString
    call ReadInt
    dec eax
    cmp eax, 0
    jl InvalidAircraft_Un
    cmp eax, aircraftCount
    jge InvalidAircraft_Un
    mov ebx, eax
    imul eax, 15
    mov edi, OFFSET aircraftStatus
    add edi, eax
    mov esi, OFFSET statusUnavailableAircraft
    mov ecx, 15
    rep movsb
    mov edx, OFFSET msgUpdateSuccessAircraft
    call WriteString
    ret

InvalidAircraft_Un:
    mov edx, OFFSET msgInvalidAircraftAircraft
    call WriteString
    ret

NoAircraft_Un:
    mov edx, OFFSET msgNoAircraftAircraft
    call WriteString
    ret
MarkUnavailableProc ENDP

ScheduleMaintenanceProc PROC
    mov eax, aircraftCount
    cmp eax, 0
    je NoAircraft_Maint
    mov edx, OFFSET promptAircraftNumAircraft
    call WriteString
    call ReadInt
    dec eax
    cmp eax, 0
    jl InvalidAircraft_Maint
    cmp eax, aircraftCount
    jge InvalidAircraft_Maint
    mov ebx, eax
    imul eax, 15
    mov edi, OFFSET aircraftStatus
    add edi, eax
    mov esi, OFFSET statusMaintenanceAircraft
    mov ecx, 15
    rep movsb
    mov edx, OFFSET msgUpdateSuccessAircraft
    call WriteString
    ret

InvalidAircraft_Maint:
    mov edx, OFFSET msgInvalidAircraftAircraft
    call WriteString
    ret

NoAircraft_Maint:
    mov edx, OFFSET msgNoAircraftAircraft
    call WriteString
    ret
ScheduleMaintenanceProc ENDP

ViewAircraftList PROC
    mov eax, aircraftCount
    cmp eax, 0
    je NoAircraft_List
    mov edx, OFFSET headerAircraftAircraft
    call WriteString
    mov edx, OFFSET headerLineAircraft
    call WriteString
    xor ebx, ebx

DisplayLoopAircraft:
    cmp ebx, aircraftCount
    jge EndDisplayAircraft
    mov eax, ebx
    inc eax
    call WriteDec
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar

    push ebx
    mov eax, ebx
    imul eax, 10
    mov edx, OFFSET aircraftID
    add edx, eax
    call WriteString

    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar
    mov al, ' '
    call WriteChar

    mov eax, ebx
    imul eax, 15
    mov edx, OFFSET aircraftStatus
    add edx, eax
    call WriteString
    call Crlf
    pop ebx
    inc ebx
    jmp DisplayLoopAircraft

EndDisplayAircraft:
    ret

NoAircraft_List:
    mov edx, OFFSET msgNoAircraftAircraft
    call WriteString
    ret
ViewAircraftList ENDP

; -----------------------
; End of code
; -----------------------
END main
