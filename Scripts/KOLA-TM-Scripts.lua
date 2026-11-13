env.info('*** 441 SCRIPTS START *** ')
-- ----------------------------------------------------------- --
-- KOLA 2026 TM SCRIPTS
-- TODO: Fix Airboss
-- CHANGES: 
--         111126 - V1 (release)
--         XXXX26 -
-- ----------------------------------------------------------- --
-- Others Menu --
-- ----------------------------------------------------------- --

A2A = MENU_MISSION:New( "A/A Spawns")
	BVR = MENU_MISSION:New( "BVR Spawns", A2A)
	ACM = MENU_MISSION:New("ACM Guns or FOX2s", A2A)
A2G = MENU_MISSION:New( "A/G Spawns")
	SAM = MENU_MISSION:New( "ESR002 Sams", A2G)
AIRBOSS.MenuF10Root=MENU_MISSION:New("Airboss").MenuPath
_SETTINGS:SetPlayerMenuOff()
-- ----------------------------------------------------------- --
-- Support --
-- ----------------------------------------------------------- --

local zoneTanker=ZONE:New("ARCOTANKER") -- Arco Tanker Zone
local zoneRedTank=ZONE:New("REDTANK") -- For PvP F-16s
local zoneAWACS=ZONE:New("AWACS") -- AWACS AXEMAN

-- AWACS
local auftragAWACS=AUFTRAG:NewAWACS(zoneAWACS:GetCoordinate(), 32000, 300, 300, 25)
auftragAWACS:SetRadio(266.250)      
local fsAWACS=FLIGHTGROUP:New("Focus")
fsAWACS:SetDefaultCallsign(CALLSIGN.AWACS.Focus, 7)
fsAWACS:AddMission(auftragAWACS)

-- CC-130T ARCO31  TCN 66 - 9000 266.0MHz BTN 7
local acro3Tanker=AUFTRAG:NewTANKER(zoneTanker:GetCoordinate(), 9000, 271, 200, 10)
	acro3Tanker:SetTACAN(66, "ARC")
	acro3Tanker:SetRadio(266)

local acro31=FLIGHTGROUP:New("ACRO3")
	acro31:SetDefaultCallsign(CALLSIGN.Tanker.Arco, 3)
	acro31:Activate()
	acro31:AddMission(acro3Tanker)

-- KC-135 Boom
local TEX52Tanker=AUFTRAG:NewTANKER(zoneRedTank:GetCoordinate(), 18000, 284, 030, 10)
	TEX52Tanker:SetTACAN(52, "TEX")
	TEX52Tanker:SetRadio(252)

local TEX52=FLIGHTGROUP:New("TEX52")
	TEX52:SetDefaultCallsign(CALLSIGN.Tanker.Texaco, 5)
	TEX52:Activate()
	TEX52:AddMission(TEX52Tanker)


-- ----------------------------------------------------------- --
-- ROST RANGE --
-- ----------------------------------------------------------- --
local RRTargets={"RR-CC-1", 
					"RR-CC-2", 
					"RR-CC-3", 
					"RR-TANK-1",
					"RR-TANK-2",
					"RR-TANK-3",
					"RR-TANK-4",
					"RR-TANK-5",
				}

local RRpit={"RR-PIT-1"}

ROSTRANGE=RANGE:New("Rost Range")
	ROSTRANGE:SetFunkManOn(10042, "127.0.0.1")
	ROSTRANGE:AddBombingTargets(RRTargets)
	ROSTRANGE:SetRangeRadius(15)
	-- ROSTRANGE:SetRangeControl(251.000, "RangeRelay")
	-- ROSTRANGE:SetInstructorRadio(253.000, "RangeRelay")
	ROSTRANGE:AddStrafePit(RRpit, 3000, 360, nil, true, 20, 600)
	ROSTRANGE:Start()

-- ----------------------------------------------------------- --
-- ESR-002 "ARTTU" Range --
-- ----------------------------------------------------------- --
local R2Targets={"R2-CC-1",
					"R2-CC-2",
					"R2-CC-3",
					"R2-CC-4",
					"R2-CC-5",
					"R2-TRUCK",
					"R2-TRUCK-1",
					"R2-TRUCK-2",
					"R2-TRUCK-3",
					"R2-TRUCK-4",
					"R2-TRUCK-5",
					"R2-TRUCK-6",
					"R2-TRUCK-7",
				}
local R2pit={"R2-PIT1"}

ARTTURANGE=RANGE:New("Arttu Range")
	-- ARTTURANGE:SetFunkManOn(10042, "127.0.0.1")
	ARTTURANGE:AddBombingTargets(R2Targets)
	ARTTURANGE:SetRangeRadius(10)
	ARTTURANGE:AddStrafePit(R2pit, 3000, 180, nil, true, 20, 600)
	ARTTURANGE:Start()
	
-- ----------------------------------------------------------- --
-- END533 A/A Range --
-- ----------------------------------------------------------- --

-- Spawn registry helpers.  Each category stores every spawned GROUP object, 
-- allowing the corresponding "Remove" menu item to clean up all instances.
local function registerSpawn(registry, spawnedGroup)
  if spawnedGroup then
    table.insert(registry, spawnedGroup)
  end
  return spawnedGroup
end
-- Remove spawned groups.
local function destroyRegisteredSpawns(registry)
  for i = #registry, 1, -1 do
    local spawnedGroup = registry[i]
    if spawnedGroup then
      spawnedGroup:Destroy()
    end
    table.remove(registry, i)
  end
end
-- Create a table for the airspawn zones. BVRs = 1, BFMS = 2
zoneTable = {ZONE:New("BVRS"), ZONE:New("BFMS")}
-- Find units for menu list and spawn new groups.
bvrTable = {"MIG21-S","MIG21-D","MIG23-S","MIG23-D","J11-S","J11-D","RED-AWACS" }
numberOfBVRAircraft = 7
redBVR = {}
for i=1,numberOfBVRAircraft do
  redBVR[i] = SPAWN:New(bvrTable[i]):InitLimit(24,0) -- Max 24 aircraft spawnable
end

SpawnBVR = {}
	function newBVR(grpname, grpspawn)
		local spawnedGroup = grpspawn:SpawnInZone(zoneTable[1], true, 6000, 10000, nil) -- Min alt 6000m max alt 10000m
			registerSpawn(SpawnBVR, spawnedGroup)
				MESSAGE:New(grpname.." spawned!",15,Info):ToAll()
end
local function destroyBVR()
  destroyRegisteredSpawns(SpawnBVR)
end

for i=1,numberOfBVRAircraft do
  MENU_MISSION_COMMAND:New (bvrTable[i], BVR, newBVR, bvrTable[i], redBVR[i])
end
MENU_MISSION_COMMAND:New ("Remove Spawns?", BVR, destroyBVR)

-- BFM & ACM Spawns END456
-- BFM are guns only, SEM are Guns and Fox 2s
acmTable = {"MiG21 BFM", "MiG21 SEM", "SU27 BFM", "SU27 SEM"}
numberOfACMAircraft = 4
redACM = {}
for i=1,numberOfACMAircraft do
  redACM[i] = SPAWN:New(acmTable[i]):InitLimit(2,0)
end

SpawnACM = {}
function newACM(grpname, grpspawn)
  local spawnedGroup = grpspawn:SpawnInZone(zoneTable[2], true, 1000, 4500, nil) -- zoneTable[2] is BFM zone
  registerSpawn(SpawnACM, spawnedGroup)
  MESSAGE:New(grpname.." spawned!",15,Info):ToAll()
end

local function destroyACM()
  destroyRegisteredSpawns(SpawnACM)
end

for i=1,numberOfACMAircraft do
  MENU_MISSION_COMMAND:New (acmTable[i], ACM, newACM, acmTable[i], redACM[i])
end
MENU_MISSION_COMMAND:New ("Remove Spawns?", ACM, destroyACM)

-- ----------------------------------------------------------- --
-- ES R-002 Range --
-- ----------------------------------------------------------- --

samTable = { "SA-2", "SA-6", "SA-8", "SA-10", "SA-11", "SA-15"}
samZoneTable = {ZONE:New("ESR002_SAMS")}

redSAM = {}
	for i=1,6 do
		redSAM[i] = SPAWN:New(samTable[i]):InitLimit(50,0):InitAIOn():InitRandomizeZones(samZoneTable)
end

SAMSpawn = {}
function newSAMSite(grpname, grpspawn)
  local spawnedGroup = grpspawn:Spawn()
  if spawnedGroup then
    spawnedGroup:OptionAlarmStateRed()
    registerSpawn(SAMSpawn, spawnedGroup)
  end
  MESSAGE:New(grpname.." group spawned!",15,Info):ToAll()
end

local function destroySAM()
  destroyRegisteredSpawns(SAMSpawn)
end

for i=1,6 do
  MENU_MISSION_COMMAND:New (samTable[i], SAM, newSAMSite, samTable[i], redSAM[i])
end
MENU_MISSION_COMMAND:New ("Remove SAMs?", SAM, destroySAM)
-- ----------------------------------------------------------- --
-- Boat Stuff --
-- ----------------------------------------------------------- --
env.info('...AIRBOSS LOADING...')

cvnUnitName = "CVN-71"

--Recovery Tankers   *Callsign parameters (1=Texaco, 2=Arco, 3=Shell, Navy_One=4, Mauler=5, Bloodhound=6,)
tanker=RECOVERYTANKER:New(UNIT:FindByName(cvnUnitName), "SHELL61")
tanker:SetTakeoffAir()
-- tanker:SetCallsign(CALLSIGN.Tanker.Shell, 3)
tanker:SetRadio(261)
tanker:SetModex(661)
tanker:SetTACAN(61, "SHL")
tanker:__Start(3)

local superCarrier=AIRBOSS:New(cvnUnitName)

function superCarrier:OnAfterLSOGrade(from, event, to, playerData, myGrade)
    local player_name = playerData.name:gsub('[%p]', '')
    local trapsheet = "AIRBOSS-trapsheet-" .. player_name
    superCarrier:SetTrapSheet(nil, trapsheet)
    self:_SaveTrapSheet(playerData, myGrade)
		if playerData.wire == 1 then
		myGrade.points = myGrade.points -1.00
        local oneWireMessage = ('**'..player_name..' almost had a rampstrike with that 1-wire!**')
		-- dcsbot.sendBotTable(oneWireMessage)
        if SOCKET then
          local oneWireMessageSocket = SOCKET:New()
          oneWireMessageSocket:SendText(oneWireMessage)
        end
		end	
    local msg = {}
    msg.command = "onMissionEvent"
    msg.eventName = "S_EVENT_AIRBOSS"
    msg.initiator = {}
    msg.initiator.name = playerData.name
    msg.place = {}
    msg.place.name = myGrade.carriername
    msg.points = myGrade.points
    msg.grade = myGrade.grade
    msg.details = myGrade.details
    msg.wire = playerData.wire
    msg.trapsheet = trapsheet
    msg.time = timer.getTime()
    if dcsbot and dcsbot.sendBotTable then
      dcsbot.sendBotTable(msg)
    end
end 

superCarrier:SetMenuRecovery(60, 25, true, 0)
superCarrier:Load()
superCarrier:SetFunkManOn()
superCarrier:SetAutoSave()
superCarrier:SetTACAN(71, "X", "BIG")
superCarrier:SetICLS(11,"TRR")
superCarrier:SetLSORadio(261,AM)
superCarrier:SetMarshalRadio(261, AM)
superCarrier:SetPatrolAdInfinitum()
superCarrier:SetAirbossNiceGuy()
superCarrier:SetRadioRelayLSO("RELAY")
superCarrier:SetRadioRelayMarshal("RELAY")
superCarrier:SetDefaultPlayerSkill(AIRBOSS.Difficulty.NORMAL)
superCarrier:SetMaxSectionSize(4)
superCarrier:SetMPWireCorrection(12)
superCarrier:SetSoundfilesFolder("Airboss Soundfiles/")
superCarrier:SetDespawnOnEngineShutdown()
superCarrier:SetMenuSingleCarrier(true)

local CarrierExcludeSet=SET_GROUP:New():FilterPrefixes("SHELL61"):FilterStart()
superCarrier:SetExcludeAI(CarrierExcludeSet)

-- Log that we have load
env.info('*** 441 SCRIPTS HAVE LOADED *** ')