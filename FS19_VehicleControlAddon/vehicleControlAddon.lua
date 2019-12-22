--
-- vehicleControlAddon
-- This is the specialization for vehicleControlAddon
--

--***************************************************************
source(Utils.getFilename("mogliBase.lua", g_currentModDirectory))
source(Utils.getFilename("vehicleControlAddonTransmissions.lua", g_currentModDirectory))
_G[g_currentModName..".mogliBase"].newClass( "vehicleControlAddon" )
--***************************************************************

function vehicleControlAddon.prerequisitesPresent(specializations)
	return true
end

function vehicleControlAddon.registerEventListeners(vehicleType)
	for _,n in pairs( { "onLoad", 
											"onPostLoad", 
											"onPreUpdate", 
											"onUpdate", 
											"onPostUpdateTick",
											"onDraw",
											"onLeaveVehicle",
											"onReadStream", 
											"onWriteStream", 
											"onReadUpdateStream", 
											"onWriteUpdateStream", 
											"saveToXMLFile", 
											"onRegisterActionEvents", 
											"onStartReverseDirectionChange",
											"onAIEnd" } ) do
		SpecializationUtil.registerEventListener(vehicleType, n, vehicleControlAddon)
	end 
end 

local function getTransmission( xmlFile, xmlProp )
	local text = getXMLString( xmlFile, xmlProp )
	if text == nil then	
		return 
	end 
	
	for i,t in pairs( vehicleControlAddonTransmissionBase.transmissionList ) do 
		if t.params.name == text then 
			return i 
		end 
	end 
	
	return tonumber( text ) 
end 

local function setTransmission( xmlFile, xmlProp, value )
	if value ~= nil and vehicleControlAddonTransmissionBase.transmissionList[value] ~= nil then 
		setXMLString( xmlFile, xmlProp, vehicleControlAddonTransmissionBase.transmissionList[value].params.name )
	end 
end 

local listOfProperties =
	{ { getFunc=getXMLBool , setFunc=setXMLBool , xmlName="steering",      propName="vcaSteeringIsOn"  },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="shuttle",       propName="vcaShuttleCtrl"   },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="peek",          propName="vcaPeekLeftRight" },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="limitSpeed",    propName="vcaLimitSpeed"    },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="keepSpeed",     propName="vcaKSToggle"      },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="freeSteering",  propName="vcaNoARBToggle"   },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="camRotInside",  propName="vcaCamRotInside"  },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="camRotOutside", propName="vcaCamRotOutside" },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="camRevInside",  propName="vcaCamRevInside"  },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="camRevOutside", propName="vcaCamRevOutside" },
		{ getFunc=getXMLInt  , setFunc=setXMLInt  , xmlName="exponent",      propName="vcaExponent"      },
		{ getFunc=getXMLInt  , setFunc=setXMLInt  , xmlName="throttle",      propName="vcaLimitThrottle" },
		{ getFunc=getXMLInt  , setFunc=setXMLInt  , xmlName="snapAngle",     propName="vcaSnapAngle"     },
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="snapDist",      propName="vcaSnapDistance"  },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="drawHud",       propName="vcaDrawHud"       }, 
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="brakeForce",    propName="vcaBrakeForce"    },
		{ getFunc=getTransmission, setFunc=setTransmission, xmlName="transmission", propName="vcaTransmission"  },
		{ getFunc=getXMLInt  , setFunc=setXMLInt  , xmlName="launchGear",    propName="vcaLaunchGear"    },
		{ getFunc=getXMLInt  , setFunc=setXMLInt  , xmlName="currentGear",   propName="vcaGear",         },
		{ getFunc=getXMLInt  , setFunc=setXMLInt  , xmlName="currentRange",  propName="vcaRange",        },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="autoShift",     propName="vcaAutoShift"     },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="autoClutch",    propName="vcaAutoClutch"    },
		{ getFunc=getXMLBool , setFunc=setXMLBool , xmlName="turboClutch",   propName="vcaTurboClutch"   },
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="maxSpeed",      propName="vcaMaxSpeed"      },
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="ccSpeed2",      propName="vcaCCSpeed2"      },
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="ccSpeed3",      propName="vcaCCSpeed3"      },
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="snapDir",       propName="vcaLastSnapAngle" },
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="snapPosX",      propName="vcaLastSnapPosX"  },
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="snapPosZ",      propName="vcaLastSnapPosZ"  },
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="handthrottle",  propName="vcaHandthrottle"  },
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="pitchFactor",   propName="vcaPitchFactor"   },
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="pitchExponent", propName="vcaPitchExponent" },
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="minGearRatio",  propName="vcaGearRatioF"    },
		{ getFunc=getXMLFloat, setFunc=setXMLFloat, xmlName="maxGearRatio",  propName="vcaGearRatioT"    },
		{ getFunc=getXMLInt,   setFunc=setXMLInt  , xmlName="g27Mode",       propName="vcaG27Mode"       } }


VCAGlobals = {}
vehicleControlAddon.snapAngles = { 1, 5, 15, 22.5, 45, 90 }
vehicleControlAddon.factor30pi = 9.5492965855137201461330258023509
vehicleControlAddon.g27Mode6R  = 0 -- 6 Gears, 1 Reverse, Range Splitter
vehicleControlAddon.g27Mode6S  = 1 -- 6 Gears, Shuttle, Range Splitter
vehicleControlAddon.g27Mode6D  = 2 -- 6 Gears, Fwd/back, Range Splitter
vehicleControlAddon.g27Mode6RR = 3 -- 6 Gears, Range up/down, 1 Reverse
vehicleControlAddon.g27Mode6RS = 4 -- 6 Gears, Range up/down, Shuttle
vehicleControlAddon.g27Mode8R  = 5 -- 8 Gears, 1 Reverse, Range Splitter
vehicleControlAddon.g27Mode8S  = 6 -- 8 Gears, Shuttle, Range Splitter
vehicleControlAddon.g27Mode4RR = 7 -- 4 Gears, Range up/down, 1 Reverse
vehicleControlAddon.g27Mode4RS = 8 -- 4 Gears, Range up/down, Shuttle
vehicleControlAddon.g27Mode4RD = 9 -- 4 Gears, Range up/down, Fwd/back
vehicleControlAddon.g27ModeSGR =10 -- Fwd/back , Gear up/down, Range up/down


function vehicleControlAddon.globalsReset( createIfMissing )
	VCAGlobals                     = {}
	VCAGlobals.cameraRotFactor     = 0
	VCAGlobals.cameraRotFactorRev  = 0
	VCAGlobals.cameraRotTime       = 0
  VCAGlobals.timer4Reverse       = 0
  VCAGlobals.limitThrottle       = 0
  VCAGlobals.snapAngle           = 0
  VCAGlobals.brakeForceFactor    = 0
  VCAGlobals.snapAngleHudX       = 0
  VCAGlobals.snapAngleHudY       = 0
	VCAGlobals.drawHud             = false  
  VCAGlobals.transmission        = 0
  VCAGlobals.launchGear          = 0
	VCAGlobals.clutchTimer         = 0
	VCAGlobals.clutchTimerIdle     = 0
 	VCAGlobals.debugPrint          = false
 	VCAGlobals.mouseAutoRotateBack = false
 	VCAGlobals.rotInertiaFactor    = 0
 	VCAGlobals.modifyPitch         = false
	
-- defaults	
	VCAGlobals.adaptiveSteering    = false
  VCAGlobals.camOutsideRotation  = false
  VCAGlobals.camInsideRotation   = false
 	VCAGlobals.camReverseRotation  = false
 	VCAGlobals.camRevOutRotation   = false
	VCAGlobals.shuttleControl      = false	
	VCAGlobals.peekLeftRight       = false	
	VCAGlobals.hiredWorker         = 0
	
	local file
	file = vehicleControlAddon.baseDirectory.."vehicleControlAddonConfig.xml"
	if fileExists(file) then	
		vehicleControlAddon.globalsLoad( file, "VCAGlobals", VCAGlobals )	
	else
		print("ERROR: NO GLOBALS IN "..file)
	end
	
	file = getUserProfileAppPath().. "modsSettings/FS19_VehicleControlAddon/config.xml"
	if fileExists(file) then	
		print('Loading "'..file..'"...')
		vehicleControlAddon.globalsLoad( file, "VCAGlobals", VCAGlobals )	
	elseif createIfMissing then
		vehicleControlAddon.globalsCreate( file, "VCAGlobals", VCAGlobals, true )	
	end
	
	print("vehicleControlAddon initialized");
end

vehicleControlAddon.globalsReset(g_server ~= nil and g_client == nil)

function vehicleControlAddon.debugPrint( ... )
	if VCAGlobals.debugPrint then
		print( ... )
	end
end

function vehicleControlAddon:mpDebugPrint( ... )
	if VCAGlobals.debugPrint or self == nil or not ( self.isClient ) then 
		print( ... )
	end 
end

function vehicleControlAddon:vcaIsValidCam( index )
	local i = Utils.getNoNil( index, self.spec_enterable.camIndex )
	
	if      self.spec_enterable            ~= nil 
			and self.spec_enterable.cameras    ~= nil 
			and i ~= nil 
			and self.spec_enterable.cameras[i] ~= nil 
			and self.spec_enterable.cameras[i].vehicle == self
			and self.spec_enterable.cameras[i].isRotatable then
		return true
	end
	
	return false
end

function vehicleControlAddon:vcaIsNonDefaultProp( propName, setting )
	if setting == nil then 
		setting = self 
	end 
	local check = self 
	if setting == self then 
		check = self.vcaDefaults 
	end 
	if check == nil or setting[propName] == nil or check[propName] == nil then 
		isEqual = true 
	end
	if type( setting[propName] ) == "number" and type( check[propName] ) == "number" then 
		if math.abs( setting[propName] - check[propName] ) < 1e-4 then 
			return false 
		end 
		return true 
	elseif setting[propName] == check[propName] then 
		return false 
	end 
	return true  
end 




--********************************************************************************************
-- functions for others mods 
function vehicleControlAddon:vcaExternalSetShuttleCtrl( value )
	if type( value ) == "boolean" then 
		self:vcaSetState( "vcaShuttleCtrl", value )
	end 
end 

function vehicleControlAddon:vcaExternalGetShuttleCtrl()
	return self.vcaShuttleCtrl 
end 

function vehicleControlAddon:vcaExternalSetMovingDirection( value )
	if type( value ) == "number" then 
		self:vcaSetState( "vcaExternalDir", value )
	end 
end 

function vehicleControlAddon:vcaExternalSetOverwriteBrakeForce( value )
	if value then 
		self:vcaSetState( "vcaBrakeForce", VCAGlobals.brakeForceFactor )
	else 
		self:vcaSetState( "vcaBrakeForce", 1 )
	end 
end 

function vehicleControlAddon:vcaExternalSetHideHud( value )
	if value then 
		self:vcaSetState( "vcaDrawHud", false )
	else 
		self:vcaSetState( "vcaDrawHud", true )
	end 
end 

function vehicleControlAddon:vcaExternalGetHudPosition()
	if not self.vcaDrawHud then 
		return 0, 0, 0, 0
	end 
	
	local l = getCorrectTextSize(0.02)

	-- since we use align center it is hard to estimate the correct size
	-- let's assume that it is 10 characters wide and 3.6 characters high	
	if VCAGlobals.snapAngleHudX >= 0 then 
		local x = VCAGlobals.snapAngleHudX
		local y = VCAGlobals.snapAngleHudY
		
		return x, y, x+10*l, y+3.4*l 
	end 
	
	local x = g_currentMission.inGameMenu.hud.speedMeter.gaugeCenterX
	local y = g_currentMission.inGameMenu.hud.speedMeter.gaugeCenterY + g_currentMission.inGameMenu.hud.speedMeter.fuelGaugeRadiusY * 1.6
	
	return x-5*l, y+0.7*l, x+5*l, y+4.1*l 
end 
-- functions for others mods 
--********************************************************************************************

function vehicleControlAddon:onLoad(savegame)
	self.vcaIsLoaded         = true 

	self.vcaScaleFx          = vehicleControlAddon.vcaScaleFx
	self.vcaSetState         = vehicleControlAddon.mbSetState
	self.vcaIsValidCam       = vehicleControlAddon.vcaIsValidCam
	self.vcaIsActive         = vehicleControlAddon.vcaIsActive
	self.vcaIsNonDefaultProp = vehicleControlAddon.vcaIsNonDefaultProp
	self.vcaGetSteeringNode  = vehicleControlAddon.vcaGetSteeringNode
	self.vcaGetTransmissionActive = vehicleControlAddon.vcaGetTransmissionActive
	self.vcaGetNoIVT         = vehicleControlAddon.vcaGetNoIVT
	self.vcaIsVehicleControlledByPlayer = vehicleControlAddon.vcaIsVehicleControlledByPlayer
	self.vcaGetAutoShift     = vehicleControlAddon.vcaGetAutoShift
	self.vcaGetAutoClutch    = vehicleControlAddon.vcaGetAutoClutch
	self.vcaGetShuttleCtrl   = vehicleControlAddon.vcaGetShuttleCtrl
	self.vcaGetNeutral       = vehicleControlAddon.vcaGetNeutral
	self.vcaGetAutoHold      = vehicleControlAddon.vcaGetAutoHold
	self.vcaSetSnapFactor    = vehicleControlAddon.vcaSetSnapFactor
	
	--********************************************************************************************
	-- functions for others mods 
	self.vcaExternalSetShuttleCtrl         = vehicleControlAddon.vcaExternalSetShuttleCtrl
	self.vcaExternalGetShuttleCtrl         = vehicleControlAddon.vcaExternalGetShuttleCtrl
	self.vcaExternalSetMovingDirection     = vehicleControlAddon.vcaExternalSetMovingDirection
	self.vcaExternalSetOverwriteBrakeForce = vehicleControlAddon.vcaExternalSetOverwriteBrakeForce
	self.vcaExternalSetHideHud             = vehicleControlAddon.vcaExternalSetHideHud
	self.vcaExternalGetHudPosition         = vehicleControlAddon.vcaExternalGetHudPosition
	
	self.ksmExternalSetShuttleCtrl         = vehicleControlAddon.vcaExternalSetShuttleCtrl
	self.ksmExternalGetShuttleCtrl         = vehicleControlAddon.vcaExternalGetShuttleCtrl
	self.ksmExternalSetMovingDirection     = vehicleControlAddon.vcaExternalSetMovingDirection
	self.ksmExternalSetOverwriteBrakeForce = vehicleControlAddon.vcaExternalSetOverwriteBrakeForce
	self.ksmExternalSetHideHud             = vehicleControlAddon.vcaExternalSetHideHud
	self.ksmExternalGetHudPosition         = vehicleControlAddon.vcaExternalGetHudPosition	
	-- functions for others mods 
	--********************************************************************************************

	vehicleControlAddon.registerState( self, "vcaSteeringIsOn", VCAGlobals.adaptiveSteering )
	vehicleControlAddon.registerState( self, "vcaShuttleCtrl",  VCAGlobals.shuttleControl, vehicleControlAddon.onSetShuttleControl )
	vehicleControlAddon.registerState( self, "vcaPeekLeftRight",VCAGlobals.peekLeftRight )
	vehicleControlAddon.registerState( self, "vcaShuttleFwd",   true, vehicleControlAddon.vcaOnSetDirection )
	vehicleControlAddon.registerState( self, "vcaExternalDir",  0 )
	vehicleControlAddon.registerState( self, "vcaCamFwd"      , true )
	vehicleControlAddon.registerState( self, "vcaCamRotInside", VCAGlobals.camInsideRotation )
	vehicleControlAddon.registerState( self, "vcaCamRotOutside",VCAGlobals.camOutsideRotation )
	vehicleControlAddon.registerState( self, "vcaCamRevInside", vehicleControlAddon.getDefaultReverse( self, true ) )
	vehicleControlAddon.registerState( self, "vcaCamRevOutside",vehicleControlAddon.getDefaultReverse( self, false ) )
	vehicleControlAddon.registerState( self, "vcaExponent"    , 1    , vehicleControlAddon.vcaOnSetFactor )
	vehicleControlAddon.registerState( self, "vcaWarningText" , ""   , vehicleControlAddon.vcaOnSetWarningText )
	vehicleControlAddon.registerState( self, "vcaLimitThrottle",VCAGlobals.limitThrottle )
	vehicleControlAddon.registerState( self, "vcaSnapAngle"   , VCAGlobals.snapAngle, vehicleControlAddon.vcaOnSetSnapAngle )
	vehicleControlAddon.registerState( self, "vcaSnapDistance", 3 )
	vehicleControlAddon.registerState( self, "vcaSnapIsOn" ,    false, vehicleControlAddon.vcaOnSetSnapIsOn )
	vehicleControlAddon.registerState( self, "vcaDrawHud" ,     VCAGlobals.drawHud )
	vehicleControlAddon.registerState( self, "vcaInchingIsOn" , false )
	vehicleControlAddon.registerState( self, "vcaNoAutoRotBack",false )
	vehicleControlAddon.registerState( self, "vcaNoARBToggle",  false )
	vehicleControlAddon.registerState( self, "vcaBrakeForce",   VCAGlobals.brakeForceFactor )
	vehicleControlAddon.registerState( self, "vcaTransmission", vehicleControlAddon.getDefaultTransmission( self ), vehicleControlAddon.onSetTransmission )
	vehicleControlAddon.registerState( self, "vcaMaxSpeed",     vehicleControlAddon.getDefaultMaxSpeed( self ) )
	vehicleControlAddon.registerState( self, "vcaGear",         0 ) --, vehicleControlAddon.vcaOnSetGear )
	vehicleControlAddon.registerState( self, "vcaRange",        0 ) --, vehicleControlAddon.vcaOnSetRange )
	vehicleControlAddon.registerState( self, "vcaNeutral",      false, vehicleControlAddon.vcaOnSetNeutral )
	vehicleControlAddon.registerState( self, "vcaAutoShift",    true) --, vehicleControlAddon.vcaOnSetAutoShift )
	vehicleControlAddon.registerState( self, "vcaShifterIndex", 0 )
	vehicleControlAddon.registerState( self, "vcaShifterUsed",  false )
	vehicleControlAddon.registerState( self, "vcaShifterLH",    true )
	vehicleControlAddon.registerState( self, "vcaLimitSpeed",   true )
	vehicleControlAddon.registerState( self, "vcaLaunchGear",   VCAGlobals.launchGear )
	vehicleControlAddon.registerState( self, "vcaBOVVolume",    0, vehicleControlAddon.vcaOnSetGearChanged )
	vehicleControlAddon.registerState( self, "vcaKSIsOn",       false ) --, vehicleControlAddon.vcaOnSetKSIsOn )
	vehicleControlAddon.registerState( self, "vcaKeepSpeed",    0 )
	vehicleControlAddon.registerState( self, "vcaKSToggle",     false )
	vehicleControlAddon.registerState( self, "vcaCCSpeed2",     10 )
	vehicleControlAddon.registerState( self, "vcaCCSpeed3",     15 )
	vehicleControlAddon.registerState( self, "vcaAutoClutch",   true )
	vehicleControlAddon.registerState( self, "vcaTurboClutch",  false )
	vehicleControlAddon.registerState( self, "vcaLastSnapAngle",10 ) --, vehicleControlAddon.vcaOnSetLastSnapAngle ) -- value should be between -pi and pi !!!
	vehicleControlAddon.registerState( self, "vcaLastSnapPosX", 0 )
	vehicleControlAddon.registerState( self, "vcaLastSnapPosZ", 0 )
	vehicleControlAddon.registerState( self, "vcaIsEnteredMP",  false )
	vehicleControlAddon.registerState( self, "vcaSnapDraw",     1 )
	vehicleControlAddon.registerState( self, "vcaHandthrottle", 0 )
	vehicleControlAddon.registerState( self, "vcaPitchFactor",  1 )
	vehicleControlAddon.registerState( self, "vcaPitchExponent",1 )
	vehicleControlAddon.registerState( self, "vcaGearRatioF",   0 )
	vehicleControlAddon.registerState( self, "vcaGearRatioT",   0 )
	vehicleControlAddon.registerState( self, "vcaG27Mode",      0 )
	vehicleControlAddon.registerState( self, "vcaSnapFactor",   0 )
	
	self.vcaFactor        = 1
	self.vcaReverseTimer  = 1.5 / VCAGlobals.timer4Reverse
	self.vcaMovingDir     = 0
	self.vcaLastFactor    = 0
	self.vcaWarningTimer  = 0
	self.vcaShifter7isR1  = nil 
	self.vcaGearbox       = nil
	self.vcaTickDt        = 0
	self.vcaIsEntered     = false

	self.vcaClutchPercent = 0
	self.vcaClutchPercentS= 0
	self.vcaClutchDisp    = 0
	self.vcaClutchDispS   = 0
	self.vcaRpmFactor     = 1
	self.vcaRpmFactorS    = 1
	self.vcaLastRpmFactor = 1

	if self.isClient then 
		if vehicleControlAddon.snapOnSample == nil then 
			local fileName = Utils.getFilename( "GPS_on.ogg", vehicleControlAddon.baseDirectory )
			vehicleControlAddon.snapOnSample = createSample("AutoSteerOnSound")
			loadSample(vehicleControlAddon.snapOnSample, fileName, false)
		end 
		
		if vehicleControlAddon.snapOffSample == nil then 
			local fileName = Utils.getFilename( "GPS_off.ogg", vehicleControlAddon.baseDirectory )
			vehicleControlAddon.snapOffSample = createSample("AutoSteerOffSound")
			loadSample(vehicleControlAddon.snapOffSample, fileName, false)
		end 
		
		if vehicleControlAddon.bovSample == nil then 
			local fileName = Utils.getFilename( "blowOffVentil.ogg", vehicleControlAddon.baseDirectory )
			vehicleControlAddon.bovSample = createSample("vehicleControlAddonBOVSample")
			loadSample(vehicleControlAddon.bovSample, fileName, false)
		end 	

		if vehicleControlAddon.grindingSample == nil then 
			local fileName = Utils.getFilename( "grinding.ogg", vehicleControlAddon.baseDirectory )
			vehicleControlAddon.grindingSample = createSample("vehicleControlAddonGrindingSample")
			loadSample(vehicleControlAddon.grindingSample, fileName, false)
		end 	
	
		if vehicleControlAddon.gearShiftSample == nil then 
			local fileName = Utils.getFilename( "shift.ogg", vehicleControlAddon.baseDirectory )
			vehicleControlAddon.gearShiftSample = createSample("vehicleControlAddonGearShiftSampleSample")
			loadSample(vehicleControlAddon.gearShiftSample, fileName, false)
		end 	
	
		if vehicleControlAddon.ovArrowUpWhite == nil then
			vehicleControlAddon.ovArrowUpWhite   = createImageOverlay( Utils.getFilename( "arrow_up_white.dds",   vehicleControlAddon.baseDirectory ))
			vehicleControlAddon.ovArrowUpGray    = createImageOverlay( Utils.getFilename( "arrow_up_gray.dds",    vehicleControlAddon.baseDirectory ))
			vehicleControlAddon.ovArrowDownWhite = createImageOverlay( Utils.getFilename( "arrow_down_white.dds", vehicleControlAddon.baseDirectory ))
			vehicleControlAddon.ovArrowDownGray  = createImageOverlay( Utils.getFilename( "arrow_down_gray.dds",  vehicleControlAddon.baseDirectory ))
			vehicleControlAddon.ovHandBrakeUp    = createImageOverlay( Utils.getFilename( "hand_brake_up.dds",    vehicleControlAddon.baseDirectory ))
			vehicleControlAddon.ovHandBrakeDown  = createImageOverlay( Utils.getFilename( "hand_brake_down.dds",  vehicleControlAddon.baseDirectory ))
			vehicleControlAddon.ovHandBrake      = createImageOverlay( Utils.getFilename( "hand_brake.dds",       vehicleControlAddon.baseDirectory ))
			vehicleControlAddon.ovAutoHoldUp     = createImageOverlay( Utils.getFilename( "auto_hold_up.dds",     vehicleControlAddon.baseDirectory ))
			vehicleControlAddon.ovAutoHoldDown   = createImageOverlay( Utils.getFilename( "auto_hold_down.dds",   vehicleControlAddon.baseDirectory ))
			vehicleControlAddon.ovAutoHold       = createImageOverlay( Utils.getFilename( "auto_hold.dds",        vehicleControlAddon.baseDirectory ))
		end 
	end 

	self.vcaDefaults = {}
	for _,prop in pairs( listOfProperties ) do 
		self.vcaDefaults[prop.propName] = self[prop.propName]
	end
	self.vcaDefaults.vcaTransmission = 0
	
	if self.isServer then 
		self.vcaUserSettings = {}	
	end 
	self.vcaControllerName = ""	
end

function vehicleControlAddon:onPostLoad(savegame)
	if savegame ~= nil then
		local xmlFile = savegame.xmlFile

		vehicleControlAddon.debugPrint("Loading: "..tostring(savegame.key).."...")
		
		local nonDefaultTransmission = false   
		for _,prop in pairs( listOfProperties ) do 
			local v = prop.getFunc( savegame.xmlFile, savegame.key.."."..vehicleControlAddon_Register.specName.."#"..prop.xmlName )
			vehicleControlAddon.debugPrint(tostring(prop.xmlName)..": "..tostring(v))
			if v ~= nil then 
				if prop.propName ~= "vcaGear" or prop.propName ~= "vcaRange" or nonDefaultTransmission then 
					self:vcaSetState( prop.propName, v, true ) 
				end 
				if prop.propName == "vcaTransmission" then 
					nonDefaultTransmission = true   
				end 
			end 
		end 
				
		local u = 0 
		while true do 
			local key  = string.format( "%s.%s.users(%d)", savegame.key, vehicleControlAddon_Register.specName, u )
			u = u + 1 
			local name = getXMLString(xmlFile, key.."#user")
			if name == nil then 
				break 
			end 
			if self.vcaUserSettings == nil then 
				self.vcaUserSettings = {} 
			end 
			self.vcaUserSettings[name] = {} 
			
			nonDefaultTransmission = false  
			for _,prop in pairs( listOfProperties ) do 
				local v = prop.getFunc( savegame.xmlFile, key.."#"..prop.xmlName )
				vehicleControlAddon.debugPrint("User: "..tostring(name).."; "..tostring(prop.xmlName)..": "..tostring(v))
				if v == nil then 
					self.vcaUserSettings[name][prop.propName] = self[prop.propName] 
				else
					if prop.propName ~= "vcaGear" or prop.propName ~= "vcaRange" or nonDefaultTransmission then
						self.vcaUserSettings[name][prop.propName] = v 
					end 
					if prop.propName == "vcaTransmission" then 
						nonDefaultTransmission = true   
					end 
				end 
			end 
		end 
	
		self:vcaSetState( "vcaKSIsOn", self.vcaKSToggle, true )
	end 
		
	if self.spec_motorized ~= nil then 
		local pMax  = 0
		local mMax1 = 0
		local mMax2 = 0
		for _,k in pairs( self.spec_motorized.motor.torqueCurve.keyframes ) do 
			local p = k.time * k[1]
			if p > pMax then 
				pMax  = p 
				mMax1 = k.time 
				mMax2 = k.time 
			elseif p > 0.9 * pMax then 
				mMax2 = k.time 
			end 
		end 
		
		vehicleControlAddon.debugPrint(tostring(self.configFileName)..": "..tostring( mMax1 ).." .. "..tostring(mMax2 ))
		
		self.vcaPowerRpm = mMax1 
		self.vcaRatedRpm = mMax2 
	end 
	
end 

function vehicleControlAddon:saveToXMLFile(xmlFile, xmlKey)

	for _,prop in pairs( listOfProperties ) do 
		if self:vcaIsNonDefaultProp( prop.propName ) then 
			prop.setFunc( xmlFile, xmlKey.."#"..prop.xmlName, self[prop.propName] )
		end 
	end 
	
	if type( self.vcaUserSettings ) == "table" then 
		local u = 0
		for name,setting in pairs( self.vcaUserSettings ) do 
			local ins = true 
			local key = string.format( "%s.users(%d)", xmlKey, u ) 
			
			for _,prop in pairs( listOfProperties ) do 
				if self:vcaIsNonDefaultProp( prop.propName, setting ) then
					if ins then 
					-- store setting for this user 
						ins = false 
						u   = u + 1 
						setXMLString( xmlFile, key.."#user", name )
					end 
					prop.setFunc( xmlFile, key.."#"..prop.xmlName, setting[prop.propName] )
				end 
			end 
		end 
	end 
end 

function vehicleControlAddon:onRegisterActionEvents(isSelected, isOnActiveVehicle)
	if self.isClient and self:getIsActiveForInput(true, true) then
		if self.vcaActionEvents == nil then 
			self.vcaActionEvents = {}
		else	
			self:clearActionEventsTable( self.vcaActionEvents )
		end 
		
		for _,actionName in pairs({ "vcaSETTINGS",  
                                "vcaUP",        
                                "vcaDOWN",      
                                "vcaLEFT",      
                                "vcaRIGHT",     
                                "vcaSnapUP",        
                                "vcaSnapDOWN",      
                                "vcaSnapLEFT",      
                                "vcaSnapRIGHT", 
                                "vcaDIRECTION",     
                                "vcaFORWARD",     
                                "vcaREVERSE",
																"vcaNO_ARB",
																"vcaINCHING",
																"vcaKEEPSPEED",
																"vcaKEEPSPEED2",
																"vcaSWAPSPEED",
                                "vcaSNAP",
                                "vcaSNAPRESET",
																"vcaGearUp",
																"vcaGearDown",
																"vcaRangeUp", 
																"vcaRangeDown",
																"vcaNeutral",
																"vcaShifter1",
																"vcaShifter2",
																"vcaShifter3",
																"vcaShifter4",
																"vcaShifter5",
																"vcaShifter6",
																"vcaShifter7",
																"vcaShifter8",
																"vcaShifter9",
																"vcaShifterLH",
																"vcaClutch",
																"vcaHandMode",
																"vcaHandRpm" }) do
																
			local addThis = true  
			if      actionName == "vcaDIRECTION" 
					or  actionName == "vcaFORWARD"   
					or  actionName == "vcaREVERSE" then 
				addThis = self.vcaShuttleCtrl 
			end 
			if      actionName == "vcaGearUp"
					or  actionName == "vcaGearDown"
					or  actionName == "vcaRangeUp"
					or  actionName == "vcaRangeDown"
					or  actionName == "vcaShifter1"
					or  actionName == "vcaShifter2"
					or  actionName == "vcaShifter3"
					or  actionName == "vcaShifter4"
					or  actionName == "vcaShifter5"
					or  actionName == "vcaShifter6"
					or  actionName == "vcaShifter7"
					or  actionName == "vcaShifter8"
					or  actionName == "vcaShifter9"
					or  actionName == "vcaShifterLH"			
					or  actionName == "vcaClutch"		
					or  actionName == "vcaHandMode"		
					or  actionName == "vcaHandRpm" then 	
				addThis = self.vcaIsLoaded and self:vcaGetTransmissionActive()
			end 
			
			if      addThis 
					and ( isOnActiveVehicle 
						or  actionName == "vcaUP"
						or  actionName == "vcaDOWN"
						or  actionName == "vcaLEFT"
						or  actionName == "vcaRIGHT"
						or  actionName == "vcaSWAPSPEED" ) then 
				-- above actions are still active for hired worker
				local pBool1, pBool2, pBool3, pBool4 = false, true, false, true 
				if     actionName == "vcaUP"
						or actionName == "vcaDOWN"
						or actionName == "vcaLEFT"
						or actionName == "vcaRIGHT" 
						or actionName == "vcaINCHING"
						or actionName == "vcaKEEPSPEED"
						or actionName == "vcaShifter1"
						or actionName == "vcaShifter2"
						or actionName == "vcaShifter3"
						or actionName == "vcaShifter4"
						or actionName == "vcaShifter5"
						or actionName == "vcaShifter6"
						or actionName == "vcaShifter7"
						or actionName == "vcaShifter8"
						or actionName == "vcaShifter9"
						or actionName == "vcaNO_ARB"
						then 
					pBool1 = true 
				elseif actionName == "vcaClutch" then 
					pBool2 = false 
					pBool3 = true 
				elseif actionName == "vcaHandRpm" then 
					pBool3 = true 
				end 
				
				
				local _, eventName = self:addActionEvent(self.vcaActionEvents, InputAction[actionName], self, vehicleControlAddon.actionCallback, pBool1, pBool2, pBool3, pBool4, nil);

				if      g_inputBinding                   ~= nil 
						and g_inputBinding.events            ~= nil 
						and g_inputBinding.events[eventName] ~= nil
						and ( actionName == "vcaSETTINGS"
							 or ( self.vcaShuttleCtrl and actionName == "vcaDIRECTION" ) ) then 
					if isSelected then
						g_inputBinding.events[eventName].displayPriority = 1
					elseif  isOnActiveVehicle then
						g_inputBinding.events[eventName].displayPriority = 3
					end
				end
			end
		end
	end
end

function vehicleControlAddon:actionCallback(actionName, keyStatus, callbackState, isAnalog, isMouse, deviceCategory)


	if     actionName == "vcaGearUp"
			or actionName == "vcaGearDown"
			or actionName == "vcaRangeUp" 
			or actionName == "vcaRangeDown"
			or actionName == "vcaShifter1"
			or actionName == "vcaShifter2"
			or actionName == "vcaShifter3"
			or actionName == "vcaShifter4"
			or actionName == "vcaShifter5"
			or actionName == "vcaShifter6"
			or actionName == "vcaShifter7"
			or actionName == "vcaShifter8"
			or actionName == "vcaShifter9"
			or actionName == "vcaShifterLH" then 
		if self.vcaGearbox ~= nil then 
			self.vcaGearbox:actionCallback( actionName, keyStatus )
		end 
		return 
	end 

	if     actionName == "vcaClutch" then 
		self.vcaCloseClutchNonAnalog = nil 
		if     isAnalog then 
			self.vcaClutchPercent = math.min( 1, 1.2*math.max( keyStatus-0.1, 0 ) )
		elseif self.vcaAutoClutch then 
			self.vcaClutchPercent = keyStatus
		elseif keyStatus > 0.5 then 
			self.vcaClutchPercent = math.min( 1, self.vcaClutchPercent + 0.004 * self.vcaTickDt )
		else 
			self.vcaCloseClutchNonAnalog = true 
		end 
			
	elseif actionName == "vcaUP"
			or actionName == "vcaDOWN"
			or actionName == "vcaLEFT"
			or actionName == "vcaRIGHT" then

		if not ( self.vcaPeekLeftRight ) then 
			if     actionName == "vcaUP" then
				self.vcaNewRotCursorKey = 0
			elseif actionName == "vcaDOWN" then
				self.vcaNewRotCursorKey = math.pi
			elseif actionName == "vcaLEFT" then
				if not ( self.vcaCamFwd ) then
					self.vcaNewRotCursorKey =  0.7*math.pi
				else 
					self.vcaNewRotCursorKey =  0.3*math.pi
				end 
			elseif actionName == "vcaRIGHT" then
				if not ( self.vcaCamFwd ) then
					self.vcaNewRotCursorKey = -0.7*math.pi
				else 
					self.vcaNewRotCursorKey = -0.3*math.pi
				end 
			end
			self.vcaPrevRotCursorKey  = nil 
		elseif keyStatus >= 0.5 then 
			local i = self.spec_enterable.camIndex
			local r = nil
			if i ~= nil and self.spec_enterable.cameras[i].rotY and self.spec_enterable.cameras[i].origRotY ~= nil then 
				r = vehicleControlAddon.normalizeAngle( self.spec_enterable.cameras[i].rotY - self.spec_enterable.cameras[i].origRotY )
			end

			if     actionName == "vcaUP" then
				if     r == nil then 
					self.vcaNewRotCursorKey = 0
				elseif math.abs( r ) < 0.1 * math.pi then
					self.vcaNewRotCursorKey = math.pi
				else 
					self.vcaNewRotCursorKey = 0
				end 
				self.vcaPrevRotCursorKey  = nil 
				r = nil
			elseif actionName == "vcaDOWN" then
				if     r == nil then 
					self.vcaNewRotCursorKey = nil
				elseif math.abs( r ) < 0.5 * math.pi then
					self.vcaNewRotCursorKey = math.pi
				else 
					self.vcaNewRotCursorKey = 0
				end 
			elseif actionName == "vcaLEFT" then
				if     r ~= nil and math.abs( r ) > 0.7 * math.pi then
					self.vcaNewRotCursorKey =  0.7*math.pi
				elseif r ~= nil and math.abs( r ) < 0.3 * math.pi then
					self.vcaNewRotCursorKey =  0.3*math.pi
				else 
					self.vcaNewRotCursorKey =  0.5*math.pi
				end 
			elseif actionName == "vcaRIGHT" then
				if     r ~= nil and math.abs( r ) > 0.7 * math.pi then
					self.vcaNewRotCursorKey = -0.7*math.pi
				elseif r ~= nil and math.abs( r ) < 0.3 * math.pi then
					self.vcaNewRotCursorKey = -0.3*math.pi
				else 
					self.vcaNewRotCursorKey = -0.5*math.pi
				end 
			end
			
			if self.vcaPrevRotCursorKey == nil and r ~= nil then 
				self.vcaPrevRotCursorKey = r 
			end 
		elseif self.vcaPrevRotCursorKey ~= nil then 
			self.vcaNewRotCursorKey  = self.vcaPrevRotCursorKey
			self.vcaPrevRotCursorKey = nil
		end
	elseif actionName == "vcaINCHING" then 
		self:vcaSetState( "vcaInchingIsOn", keyStatus >= 0.5 )
	elseif actionName == "vcaKEEPSPEED" then 
		local isPressed = keyStatus >= 0.5 
		if self.vcaKSToggle then 
			isPressed = not isPressed
		end 
		if isPressed then 
			self:vcaSetState( "vcaKeepSpeed", self.lastSpeed * 3600 )
			self:vcaSetState( "vcaKSIsOn", true )
		else 
			self:vcaSetState( "vcaKSIsOn", false )
		end 
	elseif actionName == "vcaKEEPSPEED2" then 
		self:vcaSetState( "vcaKSToggle", not self.vcaKSToggle )
		if self.vcaKSToggle then 
			self:vcaSetState( "vcaKeepSpeed", self.lastSpeed * 3600 )
			self:vcaSetState( "vcaKSIsOn", true )
		else 
			self:vcaSetState( "vcaKSIsOn", false )
		end 
	elseif actionName == "vcaSWAPSPEED" then 
		local temp = self.spec_drivable.cruiseControl.speed
		self:setCruiseControlMaxSpeed( self.vcaCCSpeed2 )
		self:vcaSetState( "vcaCCSpeed2", self.vcaCCSpeed3 )
		self:vcaSetState( "vcaCCSpeed3", temp )
	elseif actionName == "vcaNO_ARB" then 
		self:vcaSetState( "vcaNoAutoRotBack", keyStatus >= 0.5 )
	elseif actionName == "vcaDIRECTION" then
		self:vcaSetState( "vcaShuttleFwd", not self.vcaShuttleFwd )
	elseif actionName == "vcaFORWARD" then
		if self.spec_reverseDriving  ~= nil and self.spec_reverseDriving.isReverseDriving then
			self:vcaSetState( "vcaShuttleFwd", false )
		else 
			self:vcaSetState( "vcaShuttleFwd", true )
		end 
	elseif actionName == "vcaREVERSE" then
		if self.spec_reverseDriving  ~= nil and self.spec_reverseDriving.isReverseDriving then
			self:vcaSetState( "vcaShuttleFwd", true )
		else 
			self:vcaSetState( "vcaShuttleFwd", false )
		end
		
	elseif  -4 <= self.vcaLastSnapAngle and self.vcaLastSnapAngle <= 4
			and self.vcaSnapDistance >= 0.25
			and ( actionName == "vcaSnapLEFT" or actionName == "vcaSnapRIGHT" ) then
		self.vcaSnapPosTimer  = math.max( Utils.getNoNil( self.vcaSnapPosTimer , 0 ), 3000 )
		
		local lx,_,lz = localDirectionToWorld( self:vcaGetSteeringNode(), 0, 0, 1 )			
		local d = 0
		if lx*lx+lz*lz > 1e-6 then 
			d = math.atan2( lx, lz )
		end 
		local a  = vehicleControlAddon.vcaGetCurrentSnapAngle( self, d )
		local dx = math.sin( a )
		local dz = math.cos( a )			
		local fx = 0
		local fz = 0
		
		if     actionName == "vcaSnapLEFT"  then
			fx = 0.1 
		else
			fx = -0.1 
		end 

		self:vcaSetState( "vcaLastSnapPosX", self.vcaLastSnapPosX + fz * dx + fx * dz )
		self:vcaSetState( "vcaLastSnapPosZ", self.vcaLastSnapPosZ + fz * dz - fx * dx )
		
	elseif  -4 <= self.vcaLastSnapAngle and self.vcaLastSnapAngle <= 4
			and self.vcaSnapDistance >= 0.25
			and vehicleControlAddon.snapAngles[self.vcaSnapAngle] ~= nil
			and actionName == "vcaSnapDOWN" then 
		self.vcaSnapPosTimer  = math.max( Utils.getNoNil( self.vcaSnapPosTimer , 0 ), 3000 )
		self:vcaSetState( "vcaLastSnapAngle", vehicleControlAddon.normalizeAngle( self.vcaLastSnapAngle - math.rad(0.1*vehicleControlAddon.snapAngles[self.vcaSnapAngle])))
		self:vcaSetSnapFactor()
	elseif  -4 <= self.vcaLastSnapAngle and self.vcaLastSnapAngle <= 4
			and self.vcaSnapDistance >= 0.25
			and vehicleControlAddon.snapAngles[self.vcaSnapAngle] ~= nil
			and actionName == "vcaSnapUP" then 
		self.vcaSnapPosTimer  = math.max( Utils.getNoNil( self.vcaSnapPosTimer , 0 ), 3000 )
		self:vcaSetState( "vcaLastSnapAngle", vehicleControlAddon.normalizeAngle( self.vcaLastSnapAngle + math.rad(0.1*vehicleControlAddon.snapAngles[self.vcaSnapAngle])))
		self:vcaSetSnapFactor()
	elseif actionName == "vcaSNAPRESET" then
		self:vcaSetState( "vcaLastSnapAngle", 10 )
		self:vcaSetState( "vcaLastSnapPosX", 0 )
		self:vcaSetState( "vcaLastSnapPosZ", 0 )
		self:vcaSetState( "vcaSnapIsOn", false )
	elseif actionName == "vcaSNAP" then
		self:vcaSetState( "vcaSnapIsOn", not self.vcaSnapIsOn )
		self:vcaSetSnapFactor()
 	elseif actionName == "vcaNeutral" then
		if self.vcaNeutral and self.vcaShifterUsed then 
			self:vcaSetState( "vcaShifterUsed", false )
		else 
			self:vcaSetState( "vcaNeutral", not self.vcaNeutral )
		end 
	elseif actionName == "vcaSETTINGS" then
		vehicleControlAddon.vcaShowSettingsUI( self )
	elseif actionName == "vcaHandMode" then 
		local h, t = 0, "vcaHANDTHROTTLE"
		if self.vcaHandthrottle ~= nil then 
			h = self.vcaHandthrottle
		end 
		
		local g = h
		local p = 0
		if h <= 0 then 
			p = Utils.getNoNil( PowerConsumer.getMaxPtoRpm( self ), 0 )
		end 
		
		-- 0, -0.7, -0.9, -1
		if h > 0 then 
			h = 0
			t = "off"
		elseif h > -0.6  and p > 0 then 
			h = -1 
			t = "100% PTO RPM"
		elseif h < -0.95 and p > 0 then 
			h = -0.9 
			t = "90% PTO RPM"
		elseif h < -0.8  and p > 0 then 
			h = -0.7
			t = "70% PTO RPM"
		elseif self.vcaHandthrottle2 ~= nil then 
			h = self.vcaHandthrottle2
			local r = self.spec_motorized.motor.minRpm + h * ( self.spec_motorized.motor.maxRpm - self.spec_motorized.motor.minRpm )
			t = string.format( "%4.0f U/min", r )
		else 
			h = 0
			t = "off"
		end 
		
		self:vcaSetState( "vcaHandthrottle", h )
		self:vcaSetState( "vcaWarningText", Utils.getNoNil( vehicleControlAddon_Register.mogliTexts.vcaHANDTHROTTLE, "" )..": ".. t )
	elseif actionName == "vcaHandRpm" then 
		local h = 0
		if self.vcaHandthrottle ~= nil and self.vcaHandthrottle > 0 then 
			h = self.vcaHandthrottle
		end 
		
		if     isAnalog then 
			h = 1 + keyStatus 
		elseif keyStatus > 0.5 then 
			h = math.min( 1, h + 0.0005 * self.vcaTickDt )
		elseif keyStatus < 0.5 then 
			h = math.max( 0, h - 0.0005 * self.vcaTickDt )
		end 
		
		self:vcaSetState( "vcaHandthrottle", vehicleControlAddon.mbClamp( h, 0, 1 ) )
		if h <= 0 then 
			self:vcaSetState( "vcaWarningText", Utils.getNoNil( vehicleControlAddon_Register.mogliTexts.vcaHANDTHROTTLE, "" )..": off" )
			self.vcaHandthrottle2 = nil 
		elseif  self.spec_motorized ~= nil 
				and self.spec_motorized.motor ~= nil 
				and self.spec_motorized.motor.maxRpm ~= nil 
				and self.spec_motorized.motor.maxRpm > 0 then 
			local r = self.spec_motorized.motor.minRpm + h * ( self.spec_motorized.motor.maxRpm - self.spec_motorized.motor.minRpm )
			self:vcaSetState( "vcaWarningText", string.format("%s: %4.0f U/min", Utils.getNoNil( vehicleControlAddon_Register.mogliTexts.vcaHANDTHROTTLE, "" ), r ) )
		end 
	end
end

function vehicleControlAddon:vcaSetSnapFactor()
	if 			self.vcaSnapDistance >= 0.25 
			and self.vcaSnapIsOn
			and -4 <= self.vcaLastSnapAngle and self.vcaLastSnapAngle <= 4 then 
		local wx,wy,wz = getWorldTranslation( self:vcaGetSteeringNode() )
		local lx,_,lz = localDirectionToWorld( self:vcaGetSteeringNode(), 0, 0, 1 )			
		local d = 0
		if lx*lx+lz*lz > 1e-6 then 
			d = math.atan2( lx, lz )
		end 
		local curSnapAngle = vehicleControlAddon.vcaGetCurrentSnapAngle( self, d )
		local dx    = math.sin( curSnapAngle )
		local dz    = math.cos( curSnapAngle )			
		local distX = wx - self.vcaLastSnapPosX
		local distZ = wz - self.vcaLastSnapPosZ 	
		local dist  = distX * dz - distZ * dx + self.vcaSnapFactor * self.vcaSnapDistance

		while dist+dist > self.vcaSnapDistance do 
			self:vcaSetState( "vcaSnapFactor", self.vcaSnapFactor - 1 )
			dist  = distX * dz - distZ * dx + self.vcaSnapFactor * self.vcaSnapDistance
		end 
		while dist+dist <-self.vcaSnapDistance do 
			self:vcaSetState( "vcaSnapFactor", self.vcaSnapFactor + 1 )
			dist  = distX * dz - distZ * dx + self.vcaSnapFactor * self.vcaSnapDistance
		end 			
	end 
end

function vehicleControlAddon:onLeaveVehicle()
	if self.vcaIsEntered then 
		self:vcaSetState( "vcaInchingIsOn", false )
		self:vcaSetState( "vcaNoAutoRotBack", false )
		self.vcaNewRotCursorKey  = nil
		self.vcaPrevRotCursorKey = nil
		self:vcaSetState( "vcaSnapIsOn", false )
		self:vcaSetState( "vcaShifterUsed", false )
		self:vcaSetState( "vcaInchingIsOn", false )
		self:vcaSetState( "vcaKSIsOn", self.vcaKSToggle )
		self:vcaSetState( "vcaIsEnteredMP", false )
	end 

	self.vcaIsEntered = false 
end 

function vehicleControlAddon:vcaIsVehicleControlledByPlayer()
	if self:getIsVehicleControlledByPlayer() then 
		return true 
	end 
	if not self:getIsControlled() then 
		return false 
	end 
	if self.spec_globalPositioningSystem == nil then 
		return false 
	end 
	if self.spec_globalPositioningSystem.guidanceSteeringIsActive then 
		return true 
	end 
	return false 
end 

function vehicleControlAddon:vcaIsActive()
	if self.vcaIsLoaded and self:getIsEntered() and self:vcaIsVehicleControlledByPlayer() then 
		return true 
	end 
	return false
end 

function vehicleControlAddon:vcaGetTransmissionActive()
	if not self.vcaIsLoaded then 
		return false 
	end 
	if self.vcaTransmission == nil or self.vcaTransmission < 1 then 
		return false 
	end 
	if self:vcaIsVehicleControlledByPlayer() then 
		return true 
	end 
	if     VCAGlobals.hiredWorker <= 0 then 
		return false 
	elseif not self:vcaGetNoIVT()      then 
		return false 
	elseif VCAGlobals.hiredWorker >= 2 then 
		return self:getIsActive() 
	else 
		return self:getIsControlled()
	end 
end 

function vehicleControlAddon:vcaGetNoIVT()
	if self.vcaTransmission == nil or self.vcaTransmission <= 0 or self.vcaGearbox == nil then 
		return false 
	elseif self.vcaGearbox.isIVT then 
		return false 
	end 
	return true 
end 

function vehicleControlAddon:vcaGetAutoShift()
	if self.vcaIsLoaded and self:vcaIsVehicleControlledByPlayer() then 
		return self.vcaAutoShift 
	end 
	return true 
end 

function vehicleControlAddon:vcaGetAutoClutch()
	if self.vcaIsLoaded and self:vcaIsVehicleControlledByPlayer() then 
		return self.vcaAutoClutch 
	end 
	return true 
end 

function vehicleControlAddon:vcaGetShuttleCtrl()
	if self.vcaIsLoaded and self:vcaIsVehicleControlledByPlayer() then 
		return self.vcaShuttleCtrl
	end 
	return false  
end 

function vehicleControlAddon:vcaGetNeutral()
	if self.vcaIsLoaded then 
		if not self:getIsMotorStarted() then 
			return true 
		elseif self.spec_motorized.motorStartTime ~= nil and g_currentMission.time <= self.spec_motorized.motorStartTime then 
			return true 
		elseif self:vcaIsVehicleControlledByPlayer() then 
			if self.vcaClutchPercent >= 1 or self.vcaNeutral then 
				return true 
			end 
			return false 
		end 
	end 
	return false  
end 

function vehicleControlAddon:vcaGetAutoHold()
	local motor = self:getMotor()
	if 			self.vcaIsLoaded
			and self:vcaGetTransmissionActive()
			and motor ~= nil 
			and motor.vcaAutoStop then 
		return true 
	end 
	return false  
end 

function vehicleControlAddon:onPreUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)

--******************************************************************************************************************************************
-- g_soundManager modifications
	if vehicleControlAddon.origPitchFunc == nil 
			and ( ( self.vcaPitchFactor   ~= nil and math.abs( self.vcaPitchFactor   - 1 ) > 0.01 )
			   or ( self.vcaPitchExponent ~= nil and math.abs( self.vcaPitchExponent - 1 ) > 0.01 ) ) then 
		local m = g_soundManager.modifierTypeNameToIndex.MOTOR_RPM
		vehicleControlAddon.origPitchFunc = g_soundManager.modifierTypeIndexToDesc[m].func 
		g_soundManager.modifierTypeIndexToDesc[m].func = function( self )
			local p = vehicleControlAddon.origPitchFunc( self )
			if self.vcaPitchFactor ~= nil and math.abs( self.vcaPitchFactor - 1 ) > 0.01 then 
				local m1 = self.spec_motorized.motor:getMinRpm()
				local m2 = self.spec_motorized.motor:getMaxRpm()
				p = math.min( 1, p * ( m2 - m1 ) / ( m2 / self.vcaPitchFactor - m1 ) )
			end 
			if p < 1 and self.vcaPitchExponent ~= nil and math.abs( self.vcaPitchExponent - 1 ) > 0.01 then 
				p = p ^ ( math.log( self.vcaPitchExponent * 0.5 ) / math.log( 0.5 ) )
			end 
			if p < 0 then p = 0 elseif p > 1 then p = 1 end 
			self.vcaLastPitch = p
			return p 
		end 
	end 

	if self:vcaGetTransmissionActive() and vehicleControlAddon.origLoadFunc == nil then 
		local m = g_soundManager.modifierTypeNameToIndex.MOTOR_LOAD
		vehicleControlAddon.origLoadFunc = g_soundManager.modifierTypeIndexToDesc[m].func 
		g_soundManager.modifierTypeIndexToDesc[m].func = function( self )
			local l = vehicleControlAddon.origLoadFunc( self )
			if self.vcaIsLoaded and self:vcaGetTransmissionActive() then
				if     l <= 0 then 
					l = 0
				elseif l <= 0.1 then 
					l = 2 * l
				elseif l <= 0.2 then 
					l = 0.2 + 1.5 * ( l - 0.1 )
				elseif l <= 0.3 then 
					l = 0.35 + ( l - 0.2 ) 
				elseif l <= 0.6 then 
					l = 0.45 + 0.5 * ( l - 0.3 )
				elseif l <= 0.7 then 
					l = 0.6 + 0.7 * ( l - 0.6 )
				elseif l <= 0.8 then 
					l = 0.67 + 0.8 * ( l - 0.7 ) 
				elseif l <= 0.9 then 
					l = 0.75 + 1.2 * ( l - 0.8 ) 
				elseif l <= 1 then 
					l = 0.87 + 1.3 * ( l - 0.9 ) 
				else 
					l = 1 
				end 
			end 
			if l < 0 then l = 0 elseif l > 1 then l = 1 end 
			return l 
		end 
	end 
	
	if vehicleControlAddon.origCruiseFunc == nil 
			and ( self.vcaKSIsOn or self:vcaGetTransmissionActive() ) then 
		local m = g_soundManager.modifierTypeNameToIndex.CRUISECONTROL
		vehicleControlAddon.origCruiseFunc = g_soundManager.modifierTypeIndexToDesc[m].func 
		g_soundManager.modifierTypeIndexToDesc[m].func = function( self )
			local c = vehicleControlAddon.origCruiseFunc( self )
			if self.vcaIsLoaded then 
				if c < 0.01 and self.vcaKSIsOn then 
				-- no retarder sound with keep speed 
					c = 1					
				end 
				if self:vcaGetTransmissionActive() and self.spec_motorized.smoothedLoadPercentage < 0.1 then 
				-- retarder sound with very low load 
					c = 0 
				end 
				if self:vcaGetNeutral() then 
				-- no retarder sound if clutch is fully pressed 
					c = 1
				end 
			end 
			return c 
		end 
	end 
	
--******************************************************************************************************************************************

	self.vcaUpdateGearDone = false 

	if      self.isClient
			and self.vcaIsEntered
			and self.vcaSnapIsOn
			and self.spec_drivable ~= nil
			and self:getIsActiveForInput(true, true)
			and self:getIsVehicleControlledByPlayer()
			and math.abs( self.spec_drivable.lastInputValues.axisSteer ) > 0.15 then 
		self:vcaSetState( "vcaSnapIsOn", false )
	end 
	
	if      self.spec_globalPositioningSystem ~= nil
			and self.vcaSnapIsOn
			and self.spec_globalPositioningSystem.guidanceSteeringIsActive then
		self:vcaSetState( "vcaSnapIsOn", false )
	end 
	
--******************************************************************************************************************************************
-- adaptive steering 	
	local lastAxisSteer, lastAxisSteerTime1, lastAxisSteerTime2
	
	if self.vcaLastAxisSteer ~= nil then 
		lastAxisSteer               = self.vcaLastAxisSteer
		lastAxisSteerTime1          = self.vcaLastAxisSteerTime1
		lastAxisSteerTime2          = self.vcaLastAxisSteerTime2
		self.vcaLastAxisSteer       = nil
		self.vcaLastAxisSteerAnalog = nil
		self.vcaLastAxisSteerDevice = nil
		self.vcaLastAxisSteerTime1  = nil
		self.vcaLastAxisSteerTime2  = nil
	end 
	
	if      self.isClient
			and self.getIsEntered  ~= nil and self:getIsEntered()
			and self.spec_drivable ~= nil
			and not ( FS19_TrailerAssist ~= nil 
						and FS19_TrailerAssist.trailerAssist ~= nil
						and type( FS19_TrailerAssist.trailerAssist.isActive ) == "function"
						and FS19_TrailerAssist.trailerAssist.isActive( self ) )
      and self:getIsActiveForInput(true, true)
      and self:getIsVehicleControlledByPlayer() then 
			
		local noARB = self.vcaNoARBToggle 
		local ana   = self.spec_drivable.lastInputValues.axisSteerIsAnalog 
		local dev   = self.spec_drivable.lastInputValues.axisSteerDeviceCategory 
		if      self.spec_drivable.lastInputValues.axisSteer == 0
				and self.vcaLastAxisSteer ~= nil then 
			ana = self.vcaLastAxisSteerAnalog
			dev = self.vcaLastAxisSteerDevice
		end 
		if  not VCAGlobals.mouseAutoRotateBack
				and ana 
				and dev == InputDevice.CATEGORY.KEYBOARD_MOUSE then 
			noARB = true 
		end 
		if self.vcaNoAutoRotBack then 
			noARB = not noARB
		end 
		
		if self.vcaSteeringIsOn or noARB then 
			if lastAxisSteer == nil then 
				self.vcaLastAxisSteer       = self.spec_drivable.lastInputValues.axisSteer 
				self.vcaLastAxisSteerAnalog = self.spec_drivable.lastInputValues.axisSteerIsAnalog 
				self.vcaLastAxisSteerDevice = self.spec_drivable.lastInputValues.axisSteerDeviceCategory
				lastAxisSteerTime1          = nil 
				lastAxisSteerTime2          = nil 
			else  
				self.vcaLastAxisSteer       = lastAxisSteer
			end 
			
			if self.spec_drivable.lastInputValues.axisSteer ~= 0 then 
				self.vcaLastAxisSteerAnalog = self.spec_drivable.lastInputValues.axisSteerIsAnalog 
				self.vcaLastAxisSteerDevice = self.spec_drivable.lastInputValues.axisSteerDeviceCategory
			end 

			local s = math.abs( self.lastSpeed * 3600 )
			
			if noARB  or ( not self.vcaLastAxisSteerAnalog and math.abs( self.spec_drivable.lastInputValues.axisSteer ) > 0.01 ) then 
				local f = dt * 0.0005
				if self.vcaLastAxisSteerAnalog then 
					f = dt * 0.002
				elseif s < 1 then 
					f = dt * 0.001
				elseif ( self.vcaLastAxisSteer > 0 and self.spec_drivable.lastInputValues.axisSteer < 0 )
						or ( self.vcaLastAxisSteer < 0 and self.spec_drivable.lastInputValues.axisSteer > 0 ) then 
					f = dt * 0.003 * math.min( 1, 0.25 + math.abs( self.vcaLastAxisSteer ) * 2 )	 
				elseif not noARB then 
					if lastAxisSteerTime1 == nil then 
						self.vcaLastAxisSteerTime1 = g_currentMission.time 
					else 
						self.vcaLastAxisSteerTime1 = lastAxisSteerTime1
					end 
					local tMax = 3000
					if s >= 60 then 
						tMax = 200 
					elseif s >= 10 then 
						tMax = 200 + 88 * ( 85 - s )
					end 
					f = dt * 1e-6 * vehicleControlAddon.mbClamp( g_currentMission.time - self.vcaLastAxisSteerTime1, 25, tMax )
					if s < 21 then 
						f = math.max( f, dt * 5e-5 * ( 21 - s ) )
					end 
				else 
					f = dt * 0.001 * math.min( 1, 0.25 + math.abs( self.vcaLastAxisSteer ) * 2 ) 
				end 
				self.vcaLastAxisSteer = vehicleControlAddon.mbClamp( self.vcaLastAxisSteer + f * self.spec_drivable.lastInputValues.axisSteer, -1, 1 )
			elseif self.vcaLastAxisSteerAnalog then 
				self.vcaLastAxisSteer = self.spec_drivable.lastInputValues.axisSteer 
			elseif s > 1 then 
				local a = 1
				local f = 0.0006
				if self.autoRotateBackSpeed ~= nil then 
					a = self.autoRotateBackSpeed 
				end 
				if s <= 26 then 
					a = a * ( s - 1 ) * 0.04 
				end
				if s <= 11 then
					f = math.max( ( 11 - s  ) * 0.1, f ) 
				end 

				if lastAxisSteerTime2 == nil then 
					self.vcaLastAxisSteerTime2 = g_currentMission.time 
					a = 0
				else 
					self.vcaLastAxisSteerTime2 = lastAxisSteerTime2
					a = a * vehicleControlAddon.mbClamp( f * ( g_currentMission.time - lastAxisSteerTime2 - 50 ), 0, 1 ) ^1.5
				end 
													
				if self.vcaLastAxisSteer > 0 then 
					self.vcaLastAxisSteer = math.max( 0, self.vcaLastAxisSteer - dt * 0.001 * a )
				elseif self.vcaLastAxisSteer < 0 then                                        
					self.vcaLastAxisSteer = math.min( 0, self.vcaLastAxisSteer + dt * 0.001 * a )
				end 
			end 
			
			self.spec_drivable.lastInputValues.axisSteer = self.vcaLastAxisSteer
			self.spec_drivable.lastInputValues.axisSteerIsAnalog = true 
			self.spec_drivable.lastInputValues.axisSteerDeviceCategory = InputDevice.CATEGORY.UNKNOWN
		end 
	end 
--******************************************************************************************************************************************
end

function vehicleControlAddon:onAIEnd()
	if self:getIsMotorStarted() and self:vcaGetTransmissionActive() then 
		local motor = self:getMotor()
		if motor ~= nil then 
			motor.vcaAutoStop = true 
			motor.gearChangeTimer = 2000 
		end 
	end 
end 	

function vehicleControlAddon:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)

	self.vcaTickDt = dt

	if self.isClient and self.getIsEntered ~= nil and self:getIsControlled() and self:getIsEntered() then 
		self.vcaIsEntered = not g_gui:getIsGuiVisible()
		self:vcaSetState( "vcaIsEnteredMP", self.vcaIsEntered or self.spec_drivable.cruiseControl.state == 1 )
	else 
		self.vcaIsEntered = false 
	end 	
	
	if self.vcaIsLoaded and not self:vcaIsVehicleControlledByPlayer() and self.vcaClutchPercent > 0 then 
		self.vcaClutchPercent = 0
	end 
	
	if self.vcaHandthrottle ~= nil and self.vcaHandthrottle > 0 then 
		self.vcaHandthrottle2 = self.vcaHandthrottle 
	end 
	
	--*******************************************************************
	-- G27 mode
	if     self.vcaG27Mode == vehicleControlAddon.g27Mode6R  then 
		self.vcaShifter7isR1 = true 
	elseif self.vcaG27Mode == vehicleControlAddon.g27Mode6S  then 
		self.vcaShifter7isR1 = false 
	elseif self.vcaG27Mode == vehicleControlAddon.g27Mode6D  then 
		self.vcaShifter7isR1 = false 
	elseif self.vcaG27Mode == vehicleControlAddon.g27Mode6RR then 
		self.vcaShifter7isR1 = true 
	elseif self.vcaG27Mode == vehicleControlAddon.g27Mode6RS  then 
		self.vcaShifter7isR1 = false 
	elseif self.vcaG27Mode == vehicleControlAddon.g27Mode8R  then 
		self.vcaShifter7isR1 = true 
	elseif self.vcaG27Mode == vehicleControlAddon.g27Mode8S  then 
		self.vcaShifter7isR1 = false 
	elseif self.vcaG27Mode == vehicleControlAddon.g27Mode4RR then 
		self.vcaShifter7isR1 = true 
	elseif self.vcaG27Mode == vehicleControlAddon.g27Mode4RS then 
		self.vcaShifter7isR1 = false 
	elseif self.vcaG27Mode == vehicleControlAddon.g27Mode4RD then 
		self.vcaShifter7isR1 = false 
	elseif self.vcaG27Mode == vehicleControlAddon.g27ModeSGR then 
		self.vcaShifter7isR1 = false 
	end 
	
	--*******************************************************************
	-- user settings
	lastControllerName = self.vcaControllerName
	if self:getIsControlled() then 
		self.vcaControllerName = self:getControllerName()
		if lastControllerName == nil or lastControllerName ~= self.vcaControllerName then 
			vehicleControlAddon.mpDebugPrint( self,"New controller of vehicle is: "..self.vcaControllerName)
		end 
	elseif lastControllerName ~= nil then 
		if lastControllerName ~= "" then 
			vehicleControlAddon.mpDebugPrint( self,lastControllerName.." left vehicle")
		end 
		self.vcaControllerName = "" 
	end 
	
	if self.isServer and lastControllerName ~= "" then 
		if self.vcaUserSettings[lastControllerName] == nil then 
			print("Error in vehicleControlAddon.lua: self.vcaUserSettings["..tostring(lastControllerName).."] is nil")
			self.vcaUserSettings[lastControllerName] = {} 
		end 
	-- remember previous user settings 
		for _,prop in pairs( listOfProperties ) do 
			self.vcaUserSettings[lastControllerName][prop.propName] = self[prop.propName] 
		end 
	end 
		
	if self.isServer and self.vcaControllerName ~= "" and self.vcaControllerName ~= lastControllerName then 
		if self.vcaUserSettings[self.vcaControllerName] == nil then 
		-- new user or no settings in save game => create setting from self
			vehicleControlAddon.mpDebugPrint( self,"Creating settings for user "..self.vcaControllerName)
			self.vcaUserSettings[self.vcaControllerName] = {} 
			for _,prop in pairs( listOfProperties ) do 
				self.vcaUserSettings[self.vcaControllerName][prop.propName] = self[prop.propName]
			end 
		else
		-- changed user => restore user settings 
			vehicleControlAddon.mpDebugPrint( self,"Restoring settings for user "..self.vcaControllerName)
			for _,prop in pairs( listOfProperties ) do 
				if self.vcaUserSettings[self.vcaControllerName][prop.propName] ~= nil then 
					self:vcaSetState( prop.propName, self.vcaUserSettings[self.vcaControllerName][prop.propName] )
					vehicleControlAddon.mpDebugPrint( self, prop.propName.." of "..self.vcaControllerName..": "
																				..tostring( self[prop.propName]) .." ("..tostring(self.vcaUserSettings[	self.vcaControllerName][prop.propName])..")")
				end 
			end 
		end 
		if self.isClient and self.getIsEntered ~= nil and self:getIsEntered() then 
			self.vcaUserSettings[self.vcaControllerName].isMain = true 
		end 
	end 
	
	
	--*******************************************************************
	-- start the transmission
	if not ( self:vcaGetTransmissionActive() 
			 and self:getIsMotorStarted()
			 and ( ( self.isClient and self.vcaIsEntered ) or self.isServer ) ) then 
		if self.vcaLastTransmission ~= nil then 
			vehicleControlAddon.mpDebugPrint( self, "*********************************************" )
			vehicleControlAddon.mpDebugPrint( self, tostring(self.configFileName))
			vehicleControlAddon.mpDebugPrint( self, "Resetting transmission")
			vehicleControlAddon.mpDebugPrint( self, "*********************************************" )
		end 
		self.vcaLastTransmission = nil 
	elseif self.vcaLastTransmission == nil 
			or self.vcaLastTransmission ~= self.vcaTransmission
			or ( self.vcaTransmission >= 1 and self.vcaGearbox == nil ) then 
		vehicleControlAddon.mpDebugPrint( self, "*********************************************" )
		vehicleControlAddon.mpDebugPrint( self, tostring(self.configFileName))
		vehicleControlAddon.mpDebugPrint( self, "Old transmission: "..tostring(self.vcaLastTransmission)..", new transmission: "..tostring(self.vcaTransmission))
		self.vcaLastTransmission = self.vcaTransmission
		
		if self.vcaGearbox ~= nil then 
			self.vcaGearbox:delete()
			self.vcaGearbox = nil
		end 
		
		local transmissionDef = vehicleControlAddonTransmissionBase.transmissionList[self.vcaTransmission]
		if transmissionDef ~= nil then 
			self.vcaGearbox = transmissionDef.class:new( transmissionDef.params )
		end 
		
		if self.vcaGearbox ~= nil then 
			self.vcaGearbox:setVehicle( self )
		end 
		
		if self.isServer and self.vcaLastTransmission == nil or self.vcaLastTransmission <= 1 then 
			vehicleControlAddon.mpDebugPrint( self, "New launch gear index: "..tostring(VCAGlobals.launchGear))
			self:vcaSetState( "vcaLaunchGear", VCAGlobals.launchGear, noEventSend )
		end 
		
		if self.vcaGearbox ~= nil then 
			self.vcaGearbox:initGears( true )	
		end 
		
		vehicleControlAddon.mpDebugPrint( self, "Gear: "..tostring(self.vcaGear)..", range: "..tostring(self.vcaRange))
		vehicleControlAddon.mpDebugPrint( self, "*********************************************" )
		
		if self.isServer then
			local spec = self.spec_motorized
			if spec.motorizedNode ~= nil and next(spec.differentials) ~= nil then
				self:updateMotorProperties()
			end 
		end 
	end 
	
	
	local newRotCursorKey = self.vcaNewRotCursorKey
	local i               = self.spec_enterable.camIndex
	local requestedBack   = nil

	self.vcaNewRotCursorKey = nil

	if newRotCursorKey ~= nil then
		self.spec_enterable.cameras[i].rotY = vehicleControlAddon.normalizeAngle( self.spec_enterable.cameras[i].origRotY + newRotCursorKey )
		if     math.abs( newRotCursorKey ) < 1e-4 then 
			requestedBack = false 
		elseif math.abs( newRotCursorKey - math.pi ) < 1e-4 then 
			requestedBack = true 
		end
	end
	
	--*******************************************************************
	-- disable shuttle and transmission in case of FS19_RealManualTransmission
	if self.hasRMT then 
		self:vcaSetState( "vcaShuttleCtrl", false )
	end 
	if self.rmtIsOn then 
		self:vcaSetState( "vcaTransmission", 0 )
	end 
	
	if self.vcaCloseClutchNonAnalog then 
		self.vcaClutchPercent = self.vcaClutchPercent - 0.001 * dt
		if self.vcaClutchPercent <= 0 then 
			self.vcaClutchPercent = 0
			self.vcaCloseClutchNonAnalog = nil 
		end 
	end 

	--*******************************************************************
	-- overwrite or reset some values 
	if self:vcaGetShuttleCtrl() then 
		if     self.spec_reverseDriving  ~= nil then 
			if self.spec_reverseDriving.isReverseDriving then 
				self.vcaReverserDirection = -1 
			else
				self.vcaReverserDirection = 1 
			end 
		elseif self.vcaReverserDirection == nil then 
			self.vcaReverserDirection = self.spec_drivable.reverserDirection
		end 
		if self.vcaShuttleFwd then 
			self.spec_drivable.reverserDirection = 1
		else 
			self.spec_drivable.reverserDirection = -1
		end 
	elseif self.vcaReverserDirection ~= nil then 
		self.spec_drivable.reverserDirection = self.vcaReverserDirection
		self.vcaReverserDirection            = nil
	end 
	
	if self:vcaGetShuttleCtrl() then 
		if self.vcaReverseDriveSample == nil then 
			self.vcaReverseDriveSample = self.spec_motorized.samples.reverseDrive 
		end 
		self.spec_motorized.samples.reverseDrive = nil 
	elseif self.vcaReverseDriveSample ~= nil then 
		self.spec_motorized.samples.reverseDrive = self.vcaReverseDriveSample
		self.vcaReverseDriveSample               = nil
	end 
	
	if     self.spec_motorized.motor.lowBrakeForceScale == nil then
	elseif self:vcaIsActive() and self.vcaBrakeForce <= 0.99 then 
		if self.vcaLowBrakeForceScale == nil then 
			self.vcaLowBrakeForceScale                 = self.spec_motorized.motor.lowBrakeForceScale
		end 
		self.spec_motorized.motor.lowBrakeForceScale = self.vcaBrakeForce * self.vcaLowBrakeForceScale 
	elseif self.vcaLowBrakeForceScale ~= nil then  
		self.spec_motorized.motor.lowBrakeForceScale = self.vcaLowBrakeForceScale 
		self.vcaLowBrakeForceScale                   = nil
	end 
	
	if not self.vcaLimitSpeed then 
		if self.vcaMaxForwardSpeed == nil then 
			self.vcaMaxForwardSpeed  = self.spec_motorized.motor.maxForwardSpeed 
			self.vcaMaxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeed
		end
		self.spec_motorized.motor.maxForwardSpeed  = self.vcaMaxSpeed 
		self.spec_motorized.motor.maxBackwardSpeed = self.vcaMaxSpeed 
	elseif self.vcaMaxForwardSpeed ~= nil then 
		self.spec_motorized.motor.maxForwardSpeed  = self.vcaMaxForwardSpeed 
		self.spec_motorized.motor.maxBackwardSpeed = self.vcaMaxBackwardSpeed
		self.vcaMaxForwardSpeed  = nil
		self.vcaMaxBackwardSpeed = nil
	end 
	
	if self.vcaInchingIsOn and self.vcaIsEntered and self.spec_drivable.cruiseControl.state == 1 then
		local limitThrottleRatio     = 0.75
		if self.vcaLimitThrottle < 11 then
			limitThrottleRatio     = 0.45 + 0.05 * self.vcaLimitThrottle
		else
			limitThrottleRatio     = 1.5 - 0.05 * self.vcaLimitThrottle
		end
		if self.vcaSpeedLimit == nil then 
			self.vcaSpeedLimit = self.spec_drivable.cruiseControl.speed
		end 
		self.spec_drivable.cruiseControl.speed = self.vcaSpeedLimit * limitThrottleRatio
	elseif self.vcaSpeedLimit ~= nil then 
		self.spec_drivable.cruiseControl.speed = self.vcaSpeedLimit
		self.vcaSpeedLimit = nil
	end 	
	-- overwrite or reset some values 
	--*******************************************************************
	

	if self:getIsActive() and self.isServer then
		if     self.vcaExternalDir > 0 then 
			self.vcaMovingDir = 1
		elseif self.vcaExternalDir < 0 then 
			self.vcaMovingDir = -1
		elseif self:vcaGetShuttleCtrl() then 
			local controlledVehicles = g_currentMission.controlledVehicles
			local isHudVisible = g_currentMission.hud:getIsVisible()
			if self.vcaShuttleFwd then
				self.vcaMovingDir = 1
			else
				self.vcaMovingDir = -1
			end
		elseif g_currentMission.missionInfo.stopAndGoBraking then
			local movingDirection = self.movingDirection * self.spec_drivable.reverserDirection
			if math.abs( self.lastSpeed ) < 0.000278 then
				movingDirection = 0
			end
				
			local maxDelta    = dt * self.vcaReverseTimer
			self.vcaMovingDir = self.vcaMovingDir + vehicleControlAddon.mbClamp( movingDirection - self.vcaMovingDir, -maxDelta, maxDelta )
		else
			self.vcaMovingDir = Utils.getNoNil( self.nextMovingDirection * self.spec_drivable.reverserDirection )
		end
		
		
		if     self.vcaMovingDir < -0.5 then
			self:vcaSetState( "vcaCamFwd", false )
		elseif self.vcaMovingDir >  0.5 then
			self:vcaSetState( "vcaCamFwd", true )
		else
			fwd = self.vcaCamFwd
		end		
	end

	--*******************************************************************
	-- Keep Speed 
	if self.vcaKSIsOn and self.vcaIsEntered then			                               
		if     self.spec_drivable.cruiseControl.state == Drivable.CRUISECONTROL_STATE_FULL then 
			self:vcaSetState( "vcaKeepSpeed", self.lastSpeedReal * 3600 * self.movingDirection )
			self.vcaKSDirection = self.movingDirection
		elseif self.spec_drivable.cruiseControl.state ~= Drivable.CRUISECONTROL_STATE_OFF then 
			self:vcaSetState( "vcaKeepSpeed", self:getCruiseControlSpeed() * self.movingDirection )
			self.vcaKSDirection = self.movingDirection
			self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_OFF )
		elseif math.abs( self.spec_drivable.axisForward ) < 0.1 and not self:vcaGetShuttleCtrl() and self.movingDirection == 0 then 
			self:vcaSetState( "vcaKeepSpeed", 0 )
		elseif math.abs( self.spec_drivable.axisForward ) > 0.01 then 
			local f = 3.6 * math.max( -self.spec_motorized.motor.maxBackwardSpeed, self.lastSpeedReal * 1000 * self.movingDirection - 0.4 )
			local t = 3.6 * math.min(  self.spec_motorized.motor.maxForwardSpeed,  self.lastSpeedReal * 1000 * self.movingDirection + 0.4  )
			local a = self.spec_drivable.axisForward
			-- joystick
			if self:vcaGetShuttleCtrl() then 
				-- with shuttle control
				if self.vcaShuttleFwd then 
					f = 0
				else 
					t = 0
					a = -a
				end 
			else
				-- w/o shuttle control
				if     self.vcaReverserDirection ~= nil then 
					a = a * self.vcaReverserDirection
				elseif self.spec_drivable.reverserDirection ~= nil then 
					a = a * self.spec_drivable.reverserDirection
				end 
				if     self.lastSpeedReal * 3600 > 1 then 
					if     self.movingDirection > 0 then 
					  f = 0
					elseif self.movingDirection < 0 then
						t = 0 
					end 
					self.vcaLastKSStopTimer = g_currentMission.time + 2000 
				elseif self.vcaLastKSStopTimer == nil then 
					self.vcaLastKSStopTimer = g_currentMission.time 
				elseif g_currentMission.time < self.vcaLastKSStopTimer then 
					-- wait two seconds 
					f = 0
					t = 0
				end 
			end 
			self:vcaSetState( "vcaKeepSpeed", vehicleControlAddon.mbClamp( self.vcaKeepSpeed + a * 0.0067 * dt, f, t )  )
		end 
	end 
	
	--*******************************************************************
	-- Camera Rotation
	if      self:getIsActive() 
			and self.isClient 
			and self.vcaIsLoaded 
			and self:vcaIsVehicleControlledByPlayer()
			and self:vcaIsValidCam() then
			
		local camera  = self.spec_enterable.cameras[i]
		local rotIsOn = self.vcaCamRotOutside
		local revIsOn = self.vcaCamRevOutside
		
		if camera.isInside then 
			rotIsOn = self.vcaCamRotInside
		  revIsOn = self.vcaCamRevInside
		end 
		
	--vehicleControlAddon.debugPrint( "Cam: "..tostring(rotIsOn)..", "..tostring(revIsOn)..", "..tostring(self.vcaLastCamIndex)..", "..tostring(self.vcaLastCamFwd))

		if     self.vcaLastCamIndex == nil 
				or self.vcaLastCamIndex ~= i then
				
			if      self.vcaLastCamIndex ~= nil
					and self.vcaZeroCamRotY  ~= nil
					and self.vcaLastCamRotY  ~= nil
					and self:vcaIsValidCam( self.vcaLastCamIndex ) then
				local oldCam = self.spec_enterable.cameras[self.vcaLastCamIndex]
				
				if (oldCam.resetCameraOnVehicleSwitch == nil and g_gameSettings:getValue("resetCamera")) or oldCam.resetCameraOnVehicleSwitch then
				-- camera is automatically reset
				elseif ( not oldCam.isInside and self.vcaCamRotOutside )
						or (     oldCam.isInside and self.vcaCamRotInside  ) then 
					oldCam.rotY = self.vcaZeroCamRotY + oldCam.rotY - self.vcaLastCamRotY
				end 
			end 
				
			self.vcaLastCamIndex = self.spec_enterable.camIndex
			self.vcaZeroCamRotY  = camera.rotY
			self.vcaLastCamRotY  = camera.rotY 
			self.vcaLastCamFwd   = nil
			
		elseif  g_gameSettings:getValue("isHeadTrackingEnabled") 
				and isHeadTrackingAvailable() 
				and camera.isInside 
				and camera.headTrackingNode ~= nil then
				
			if requestedBack ~= nil then 
				self.vcaCamBack = requestedBack 
			end 
			
			if revIsOn or self.vcaCamBack ~= nil then			
				if camera.headTrackingMogliPF == nil then 
					local p = getParent( camera.headTrackingNode )
					camera.headTrackingMogliPF = createTransformGroup("headTrackingMogliPF")
					link( p, camera.headTrackingMogliPF )
					link( camera.headTrackingMogliPF, camera.headTrackingNode )
					setRotation( camera.headTrackingMogliPF, 0, 0, 0 )
					setTranslation( camera.headTrackingMogliPF, 0, 0, 0 )
					camera.headTrackingMogliPR = false 
				end 
				
				local targetBack = false 
				if revIsOn and not ( self.vcaCamFwd ) then 
					targetBack = true 
				end 
				
				if self.vcaCamBack ~= nil then 
					if self.vcaCamBack == targetBack then 
						self.vcaCamBack = nil 
					else 
						targetBack = self.vcaCamBack 
					end 
				end
				
				if targetBack then 
					if not camera.headTrackingMogliPR then 
						camera.headTrackingMogliPR = true 
						setRotation( camera.headTrackingMogliPF, 0, math.pi, 0 )
					end 
				else 
					if camera.headTrackingMogliPR then 
						camera.headTrackingMogliPR = false  
						setRotation( camera.headTrackingMogliPF, 0, 0, 0 )
					end 
				end 
			end 
			
		elseif rotIsOn 
				or revIsOn then

			local pi2 = math.pi / 2
			local eps = 1e-6
			oldRotY = camera.rotY
			local diff = oldRotY - self.vcaLastCamRotY
			
			
			if newRotCursorKey ~= nil then
				self.vcaZeroCamRotY = vehicleControlAddon.normalizeAngle( camera.origRotY + newRotCursorKey )
			elseif rotIsOn then
				self.vcaZeroCamRotY = self.vcaZeroCamRotY + diff
			else
				self.vcaZeroCamRotY = camera.rotY
			end
				
		--diff = math.abs( vehicleControlAddon.vcaGetAbsolutRotY( self, i ) )
			local isRev = false
			local aRotY = vehicleControlAddon.normalizeAngle( vehicleControlAddon.vcaGetAbsolutRotY( self, i ) - camera.rotY + self.vcaZeroCamRotY )
			if -pi2 < aRotY and aRotY < pi2 then
				isRev = true
			end
			
			if revIsOn then
				if     newRotCursorKey ~= nil then
				-- nothing
				elseif self.vcaLastCamFwd == nil or self.vcaLastCamFwd ~= self.vcaCamFwd then
					if isRev == self.vcaCamFwd then
						self.vcaZeroCamRotY = vehicleControlAddon.normalizeAngle( self.vcaZeroCamRotY + math.pi )
						isRev = not isRev						
					end
				end
				self.vcaLastCamFwd = self.vcaCamFwd
			end
			
			local newRotY = self.vcaZeroCamRotY
			
			if rotIsOn then
				
				local f = 0
				if     self.rotatedTime > 0 then
					f = self.rotatedTime / self.maxRotTime
				elseif self.rotatedTime < 0 then
					f = self.rotatedTime / self.minRotTime
				end
				if f < 0.1 then
					f = 0
				else
					f = 1.2345679 * ( f - 0.1 ) ^2 / 0.81
				--f = 1.1111111 * ( f - 0.1 )
				end
				if self.rotatedTime < 0 then
					f = -f
				end
				
				local g = self.vcaLastFactor
				self.vcaLastFactor = self.vcaLastFactor + vehicleControlAddon.mbClamp( f - self.vcaLastFactor, -VCAGlobals.cameraRotTime*dt, VCAGlobals.cameraRotTime*dt )
				if math.abs( self.vcaLastFactor - g ) > 0.01 then
					f = self.vcaLastFactor
				else
					f = g
				end
				
				if isRev then
				--vehicleControlAddon.debugPrint("reverse")
					newRotY = newRotY - self:vcaScaleFx( VCAGlobals.cameraRotFactorRev, 0.1, 3 ) * f				
				else
				--vehicleControlAddon.debugPrint("forward")
					newRotY = newRotY + self:vcaScaleFx( VCAGlobals.cameraRotFactor, 0.1, 3 ) * f
				end	
				
			else
				self.vcaLastFactor = 0
			end

			camera.rotY = newRotY			
			
		--if math.abs( vehicleControlAddon.normalizeAngle( camera.rotY - newRotY ) ) > 0.5 * math.pi then
		--	if camera.positionSmoothingParameter > 0 then
		--		camera:updateRotateNodeRotation()
		--		local xlook,ylook,zlook = getWorldTranslation(camera.rotateNode)
		--		camera.lookAtPosition[1] = xlook
		--		camera.lookAtPosition[2] = ylook
		--		camera.lookAtPosition[3] = zlook
		--		local x,y,z = getWorldTranslation(camera.cameraPositionNode)
		--		camera.position[1] = x
		--		camera.position[2] = y
		--		camera.position[3] = z
		--		camera:setSeparateCameraPose()
		--	end
		--end 			
		end
		
		self.vcaLastCamRotY = camera.rotY
	elseif self.vcaLastCamIndex ~= nil then 
		if self.vcaZeroCamRotY and self:vcaIsValidCam( self.vcaLastCamIndex ) then
			self.spec_enterable.cameras[self.vcaLastCamIndex].rotY = self.vcaZeroCamRotY 
		end 
		self.vcaLastCamIndex = nil
		self.vcaZeroCamRotY  = nil
		self.vcaLastCamRotY  = nil
		self.vcaLastCamFwd   = nil
	end	
	
	self.vcaWarningTimer = self.vcaWarningTimer - dt
	
	if      self:getIsActive()
			and self.vcaWarningText ~= nil
			and self.vcaWarningText ~= "" then
		if self.vcaWarningTimer <= 0 then
			self.vcaWarningText = ""
		elseif self.vcaIsEntered then 
			g_currentMission:showBlinkingWarning(self.vcaWarningText, self.vcaWarningTimer)
			self.vcaWarningTimer = 0
			self.vcaWarningText  = ""
		end	
	end		
	
--******************************************************************************************************************************************
-- Reverse driving sound
	if self.isClient and self:vcaIsActive() then 
		if self:vcaGetShuttleCtrl() and self.vcaReverseDriveSample ~= nil then 
			local notRev = self.vcaShuttleFwd or self.vcaNeutral
			if not g_soundManager:getIsSamplePlaying(self.vcaReverseDriveSample) and not notRev then
				g_soundManager:playSample(self.vcaReverseDriveSample)
			elseif notRev then
				g_soundManager:stopSample(self.vcaReverseDriveSample)
			end
		end
	end 	
	
--******************************************************************************************************************************************
-- Real RPM 
	if self.isServer then 
		self.vcaRpmFactor = 1 
		if      self:vcaGetTransmissionActive()
				and self:getIsMotorStarted() then 
			local motor = self.spec_motorized.motor 
			local m = motor:getMinRpm()
			local r = motor:getNonClampedMotorRpm()
			if self.spec_motorized.motor.vcaFakeRpm ~= nil then 
				r = self.spec_motorized.motor.vcaFakeRpm
			end 
			local e = motor:getEqualizedMotorRpm()
			if self:getIsMotorStarted() and motor:getMinRpm() > 0 and r < m and e < m+1 then 
				self.vcaRpmFactor = math.max( 0.1, r / m )
			end 
			m = motor:getMaxRpm() / self.vcaPitchFactor
			if self:getIsMotorStarted() and motor:getMaxRpm() > 0 and r > m and e > m-1 then 
				self.vcaRpmFactor = math.min( 1.9, r / m )
			end 
		end 
	end 
	
	if      self.isClient
			and self.spec_motorized.motorSamples ~= nil
			and ( math.abs( self.vcaLastRpmFactor - self.vcaRpmFactor ) > 0.02 or ( self.vcaRpmFactor == 1 and self.vcaLastRpmFactor ~= 1 ) ) then 
		self.vcaLastRpmFactor = self.vcaRpmFactor
		if self.vcaPitchBackup == nil then 
			self.vcaPitchBackup = {}
			for i,s in pairs( self.spec_motorized.motorSamples ) do 
				local indoor, outdoor = nil, nil 
				if s.indoorAttributes ~= nil then 
					indoor = s.indoorAttributes.pitch 
				end 
				if s.outdoorAttributes ~= nil then 
					outdoor = s.outdoorAttributes.pitch 
				end 
				self.vcaPitchBackup[i] =  { indoor = indoor, outdoor = outdoor }
			end 
		end 
		
		for i,s in pairs( self.spec_motorized.motorSamples ) do
			local indoor  = self.vcaPitchBackup[i].indoor 
			local outdoor = self.vcaPitchBackup[i].outdoor
			if indoor  ~= nil then 
				s.indoorAttributes.pitch  = self.vcaRpmFactor * indoor 
			end 
			if outdoor ~= nil then 
				s.outdoorAttributes.pitch = self.vcaRpmFactor * outdoor 
			end 
		end 
	end 
	
	if      self.isClient
			and self.spec_motorized.motorSamples ~= nil
			and self:getIsMotorStarted() then 
		local m = g_soundManager.modifierTypeNameToIndex.MOTOR_RPM
		if self:vcaGetTransmissionActive() and VCAGlobals.modifyPitch then 
			if not ( self.vcaModifiedSound ) then 
				local function getPitch( v )
					return ( self.spec_motorized.motor.minRpm + v * ( self.spec_motorized.motor.maxRpm - self.spec_motorized.motor.minRpm ) ) / self.spec_motorized.motor.maxRpm
				end 
				self.vcaModifiedSound = true 
				for i,s in pairs( self.spec_motorized.motorSamples ) do
					if      s.modifiers          ~= nil 
							and s.modifiers.pitch    ~= nil 
							and s.modifiers.pitch[m] ~= nil
							and s.modifiers.pitch[m].keyframes ~= nil 
							and table.getn( s.modifiers.pitch[m].keyframes ) > 1 then 
						local p1, v1 
						for j,k in pairs( s.modifiers.pitch[m].keyframes ) do 
							if v1 == nil or math.abs( v1 - 1 ) > math.abs( k[1] - 1 ) then 
								v1 = k[1]
								p1 = k.time 
							end 					
						end 
						local f = v1 / getPitch( p1 )
						for j,k in pairs( s.modifiers.pitch[m].keyframes ) do 
							if k.vcaOrig == nil then 
								k.vcaOrig = k[1]
							end 
							k[1] = getPitch( k.time ) * f 
						--print( string.format("Corrected pitch: %d, %4.2f, %4.2f => %4.2f", i, k.time, k.vcaOrig, k[1] ) )
						end 
					end 
				end 
			end 
		elseif self.vcaModifiedSound then 
			self.vcaModifiedSound = false  
			for i,s in pairs( self.spec_motorized.motorSamples ) do
				if      s.modifiers          ~= nil 
						and s.modifiers.pitch    ~= nil 
						and s.modifiers.pitch[m] ~= nil
						and s.modifiers.pitch[m].keyframes ~= nil 
						and table.getn( s.modifiers.pitch[m].keyframes ) > 1 then 
					for j,k in pairs( s.modifiers.pitch[m].keyframes ) do 
						if k.vcaOrig ~= nil then 
						--print( string.format("Resetting pitch: %d, %4.2f, %4.2f => %4.2f", i, k.time, k[1], k.vcaOrig ) )
							k[1] = k.vcaOrig 
						end 
					end 
				end 
			end 
		end 
	end 
	
--******************************************************************************************************************************************
-- Simple fix if vcaMaxSpeed was cleared for unknown reasons on Dedi
	local somethingWentWrong = false 
	for _,n in pairs({ "vcaSteeringIsOn",
	                   "vcaShuttleCtrl", 
	                   "vcaPeekLeftRight",
	                   "vcaShuttleFwd",  
	                   "vcaExternalDir", 
	                   "vcaCamFwd"      ,
	                   "vcaCamRotInside"  ,
	                   "vcaCamRotOutside"  ,
	                   "vcaCamRevInside"  ,
	                   "vcaCamRevOutside"  ,
	                   "vcaExponent"    ,
	                   "vcaWarningText" ,
	                   "vcaLimitThrottle",
	                   "vcaSnapAngle"   ,
	                   "vcaSnapIsOn" ,   
	                   "vcaDrawHud" ,    
	                   "vcaInchingIsOn" ,
	                   "vcaNoAutoRotBack",
	                   "vcaBrakeForce",  
	                   "vcaTransmission",
	                   "vcaMaxSpeed",    
	                   "vcaGear",        
	                   "vcaRange",       
	                   "vcaNeutral",     
	                   "vcaAutoShift",   
	                   "vcaShifterIndex",
	                   "vcaShifterUsed",
	                   "vcaShifterLH",   
	                   "vcaLimitSpeed",  
	                   "vcaLaunchGear",  
	                   "vcaBOVVolume",   
	                   "vcaKSIsOn",      
	                   "vcaKeepSpeed",   
	                   "vcaKSToggle",    
	                   "vcaCCSpeed2",    
	                   "vcaCCSpeed3" }) do 
		if self[n] == nil then 
			print( "Error: someone cleared variable self."..n.."!!! self.isServer = "..tostring(self.isServer)..", self.isClient = "..tostring(self.isClient))
			if      self.vehicleControlAddonStateHandler ~= nil 
					and self.vehicleControlAddonStateHandler[n] ~= nil 
					and self.vehicleControlAddonStateHandler[n].default ~= nil then 
				self:vcaSetState( n, self.vehicleControlAddonStateHandler[n].default )
				print("Value was reset to default: '"..tostring(self[n]))
			end 
		end 
	end 
end  

function vehicleControlAddon:onPostUpdateTick( dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected )
	if      self.isServer
			and not ( self.vcaIsEnteredMP )
			and self.vcaUpdateGearTimer ~= nil
			and self.getIsMotorStarted  ~= nil 		
			and self.vcaUpdateGearTimer > g_currentMission.time
			and self:getIsMotorStarted()
			and ( self.spec_aiVehicle == nil or not ( self.spec_aiVehicle.isActive ) )
			and not ( self.vcaUpdateGearDone ) then 
		WheelsUtil.updateWheelsPhysics( self, dt, self.lastSpeedReal*self.movingDirection, 0, true, g_currentMission.missionInfo.stopAndGoBraking)
	end 
end 

function vehicleControlAddon:onDraw()

	if self.vcaIsEntered then
		local x = g_currentMission.inGameMenu.hud.speedMeter.gaugeCenterX
		local y = g_currentMission.inGameMenu.hud.speedMeter.gaugeCenterY + g_currentMission.inGameMenu.hud.speedMeter.fuelGaugeRadiusY * 1.6
		local l = getCorrectTextSize(0.02)
		local w = 0.015 * vehicleControlAddon.getUiScale()
		local h = w * g_screenAspectRatio
		
		setTextAlignment( RenderText.ALIGN_CENTER ) 
		setTextVerticalAlignment( RenderText.VERTICAL_ALIGN_MIDDLE )
		setTextColor(1, 1, 1, 1) 
		setTextBold(false)

		if     vehicleControlAddon.ovArrowUpWhite == nil then 
		-- no output 
		elseif self.vcaNeutral and not self.vcaShifterUsed then 
		-- handbrake
			if not self:vcaGetShuttleCtrl() then 
				renderOverlay( vehicleControlAddon.ovHandBrake, x-0.5*w, y-0.5*h, w, h )
			elseif self.vcaShuttleFwd then
				renderOverlay( vehicleControlAddon.ovHandBrakeUp, x-0.5*w, y-0.5*h, w, h )
			else 
				renderOverlay( vehicleControlAddon.ovHandBrakeDown, x-0.5*w, y-0.5*h, w, h )
			end 
		elseif not self:vcaGetTransmissionActive() and not self:vcaGetShuttleCtrl() then 
		-- no output 
		elseif not self:vcaGetShuttleCtrl() then 
		-- no shuttle control
			if     self:vcaGetAutoHold() then 
				renderOverlay( vehicleControlAddon.ovAutoHold, x-0.5*w, y-0.5*h, w, h )
			end 
		elseif not self:vcaGetTransmissionActive() then 		
		-- transmission off and shuttle control
			if self.vcaShuttleFwd then
				renderOverlay( vehicleControlAddon.ovArrowUpWhite, x-0.5*w, y-0.5*h, w, h )
			else 
				renderOverlay( vehicleControlAddon.ovArrowDownWhite, x-0.5*w, y-0.5*h, w, h )
			end 			
		elseif self:vcaGetAutoHold() then 
		-- auto hold 
			if self.vcaShuttleFwd then
				renderOverlay( vehicleControlAddon.ovAutoHoldUp, x-0.5*w, y-0.5*h, w, h )
			else 
				renderOverlay( vehicleControlAddon.ovAutoHoldDown, x-0.5*w, y-0.5*h, w, h )
			end 
		elseif self:vcaGetNeutral() then 
			if self.vcaShifterUsed then 
			-- not in (G27) gear
			else
			-- neutral / park break
				if self.vcaShuttleFwd then
					renderOverlay( vehicleControlAddon.ovArrowUpGray, x-0.5*w, y-0.5*h, w, h )
				else 
					renderOverlay( vehicleControlAddon.ovArrowDownGray, x-0.5*w, y-0.5*h, w, h )
				end 
			end 
		else 
		-- normal shuttle control
			if self.vcaShuttleFwd then
				renderOverlay( vehicleControlAddon.ovArrowUpWhite, x-0.5*w, y-0.5*h, w, h )
			else 
				renderOverlay( vehicleControlAddon.ovArrowDownWhite, x-0.5*w, y-0.5*h, w, h )
			end 
		end 
		
		local lx,_,lz = localDirectionToWorld( self:vcaGetSteeringNode(), 0, 0, 1 )			
		local d = 0
		if lx*lx+lz*lz > 1e-6 then 
			d = math.atan2( lx, lz )
		end 
		local curSnapAngle = vehicleControlAddon.vcaGetCurrentSnapAngle( self, d )
		
		if self.vcaDrawHud then 
			if VCAGlobals.snapAngleHudX >= 0 and self:getIsVehicleControlledByPlayer() then
				x = VCAGlobals.snapAngleHudX
				y = VCAGlobals.snapAngleHudY
				setTextAlignment( RenderText.ALIGN_LEFT ) 
				setTextVerticalAlignment( RenderText.VERTICAL_ALIGN_BASELINE )
			else 
				y = y + l * 1.2
			end 
			
			if self:vcaGetTransmissionActive() and self.vcaTransmission >= 1 and self.vcaGearbox ~= nil then 
				local gear  = self.vcaGearbox:getRatioIndex( self.vcaGear, self.vcaRange )		
				local ratio = self.vcaGearbox:getGearRatio( gear )
				local maxSpeed = 0
				local text 
				local l2    = l
				if gear ~= nil and ratio ~= nil and self.vcaMaxSpeed ~= nil then 
					maxSpeed = 3.6 * ratio * self.vcaMaxSpeed
					text = self.vcaGearbox:getGearText( self.vcaGear, self.vcaRange )	
					
					if self.vcaShifterUsed then 
						local rev = 0
						if     self.vcaG27Mode == vehicleControlAddon.g27Mode6R then 
							rev = 7
						elseif self.vcaG27Mode == vehicleControlAddon.g27Mode8R then 
							rev = 9
						end 
						
						if     self.vcaShifterIndex == rev then 
							if self.vcaShifterLH then 
								text = "R+ ("..text..")"
							else 
								text = "R- ("..text..")" 
							end 
							l2 = l * 0.8
						elseif self.vcaG27Mode == vehicleControlAddon.g27Mode6R
								or self.vcaG27Mode == vehicleControlAddon.g27Mode6S
								or self.vcaG27Mode == vehicleControlAddon.g27Mode6D
								or self.vcaG27Mode == vehicleControlAddon.g27Mode8R
								or self.vcaG27Mode == vehicleControlAddon.g27Mode8S
								then 
							if self.vcaShifterLH then 
								text = tostring(self.vcaShifterIndex).."+ ("..text..")"
							else 
								text = tostring(self.vcaShifterIndex).."- ("..text..")" 
							end 				
							l2 = l * 0.8
						end 
					end 
				else 
					text = "nil"
				end 

				text = text .." "..vehicleControlAddon.vcaSpeedToString( maxSpeed )
				
				local c
				if self:vcaGetAutoClutch() then 
					c = self.vcaClutchDisp
				else 
					c = self.vcaClutchPercent 
				end 
				if c > 0.01 then 
					text = text ..string.format(" %3.0f%%",c*100 )
				else 
				end 
				renderText(x, y, l2, text)
				y = y + l * 1.2	
			end 
			
			local showCompass = ( self.spec_globalPositioningSystem == nil )

			if not self:getIsVehicleControlledByPlayer() then 
			elseif self.spec_globalPositioningSystem ~= nil and self.spec_globalPositioningSystem.guidanceSteeringIsActive then
			elseif self.aiveAutoSteer or not ( -4 <= self.vcaLastSnapAngle and self.vcaLastSnapAngle <= 4 ) then 
				if showCompass then 
					renderText(x, y, l, string.format( "%4.1f°", math.deg( math.pi - d )))
					y = y + l * 1.2	
				end 
			elseif self.vcaSnapIsOn then 
				setTextColor(0, 1, 0, 0.5) 
				if self.vcaSnapDistance >= 0.25 then 
					renderText(x, y, l, string.format( "%4.1f° / %4.1fm", math.deg( math.pi - curSnapAngle ), self.vcaSnapDistance))
				else
					renderText(x, y, l, string.format( "%4.1f° / %4.1f°", math.deg( math.pi - curSnapAngle ), math.deg( math.pi - d )))
				end 
				y = y + l * 1.2	
				setTextColor(1, 1, 1, 1) 
			else
				renderText(x, y, l, string.format( "%4.1f° / %4.1f°", math.deg( math.pi - curSnapAngle ), math.deg( math.pi - d )))
				y = y + l * 1.2	
			end
			
			if self.vcaKSIsOn and self.spec_drivable.cruiseControl.state == 0 then 
				renderText(x, y, l, vehicleControlAddon.vcaSpeedToString( self.vcaKeepSpeed, "%5.1f" ))
				y = y + l * 1.2	
			end

		end 
		
		if not ( self.vcaSnapIsOn ) and self.vcaDrawSnapIsOn == nil then 
		-- leave vcaDrawSnapIsOn nil 
		elseif self.vcaSnapIsOn and not ( -4 <= self.vcaLastSnapAngle and self.vcaLastSnapAngle <= 4 ) then 
		-- start new 
			self.vcaSnapPosTimer  = 20000
			self.vcaDrawSnapIsOn  = true 
		else 
			if     self.vcaSnapIsOn and self.vcaDrawSnapIsOn == nil  then 
				self.vcaSnapPosTimer  = math.max( Utils.getNoNil( self.vcaSnapPosTimer , 0 ), 3000 )
			elseif self.vcaSnapIsOn and not ( self.vcaDrawSnapIsOn ) then 
				self.vcaSnapDrawTimer = 3000
			elseif self.vcaDrawSnapIsOn and not ( self.vcaSnapIsOn ) then 
				self.vcaSnapDrawTimer = 20000
			end 
			self.vcaDrawSnapIsOn = self.vcaSnapIsOn
		end 
		
		local snapDraw = false
		
		if not self:getIsVehicleControlledByPlayer() then 
			self.vcaSnapDrawTimer = nil
			self.vcaSnapPosTimer  = nil 
			self.vcaDrawSnapIsOn  = nil 
		elseif self.aiveAutoSteer or not ( -4 <= self.vcaLastSnapAngle and self.vcaLastSnapAngle <= 4 ) then 		
			self.vcaSnapDrawTimer = nil
			self.vcaSnapPosTimer  = nil 
			self.vcaDrawSnapIsOn  = nil 
		elseif self.vcaSnapDistance  < 0.25 then 
			snapDraw = false
			self.vcaSnapPosTimer  = nil 
		elseif self.vcaSnapPosTimer ~= nil then 
			snapDraw = true
		elseif self.vcaSnapDraw <= 0 then 
			self.vcaSnapDrawTimer = nil
			self.vcaSnapPosTimer  = nil 
		elseif self.vcaSnapDraw >= 2 then 
			snapDraw = true 
		elseif self.vcaSnapDrawTimer ~= nil then 
			if math.abs( self.lastSpeedReal ) * 3600 > 1 or self.vcaSnapDrawTimer > 3000 then 
				self.vcaSnapDrawTimer = self.vcaSnapDrawTimer - self.vcaTickDt 
			end 
			if self.vcaSnapDrawTimer < 0 then 
				self.vcaSnapDrawTimer = nil 
			else 
				snapDraw = true 
			end 
		end 		
				
		if snapDraw then
			local wx,wy,wz = getWorldTranslation( self:vcaGetSteeringNode() )
			
			local dx    = math.sin( curSnapAngle )
			local dz    = math.cos( curSnapAngle )			
			local distX = wx - self.vcaLastSnapPosX
			local distZ = wz - self.vcaLastSnapPosZ 	
			
			local dist  = distX * dz - distZ * dx

			if self.vcaSnapIsOn then 
				dist = dist + self.vcaSnapFactor * self.vcaSnapDistance
				setTextColor(0, 1, 0, 0.5) 
				if math.abs( dist ) > 1 then 
					if self.vcaSnapPosTimer == nil or self.vcaSnapPosTimer < 1000 then 
						self.vcaSnapPosTimer = 1000
					end
				end 
			elseif self.vcaSnapDistance >= 0.25 then 
				while dist+dist > self.vcaSnapDistance do 
					dist = dist - self.vcaSnapDistance
				end 
				while dist+dist <-self.vcaSnapDistance do 
					dist = dist + self.vcaSnapDistance
				end 
				setTextColor(1, 0, 0, 1) 
			end 

			setTextAlignment( RenderText.ALIGN_CENTER ) 
			setTextVerticalAlignment( RenderText.VERTICAL_ALIGN_BASELINE )
				
			local xMax = 1 
			if self.vcaSnapIsOn and self.vcaSnapPosTimer == nil then 
				xMax = 0 
			end 
			local a = 0
			local t = "|"
			for x=-xMax,xMax do 
				for zi=-2,3,0.1 do
					local z = 10 
					if zi < 0 then 
						z = z + 10 * zi 
					else 
						z = z + 10 * zi * zi 
					end 
					local px = wx - dist * dz - x * 0.5 * self.vcaSnapDistance * dz + z * dx 
					local pz = wz + dist * dx + x * 0.5 * self.vcaSnapDistance * dx + z * dz 
					local py = getTerrainHeightAtWorldPos( g_currentMission.terrainRootNode, px, 0, pz )
					renderText3D( px,py,pz, 0,curSnapAngle-a,0, 0.5, t )
				end 
			end 
			dx, dz = -dz, dx
		end 
		
		if self.vcaSnapPosTimer ~= nil then 
			self.vcaSnapPosTimer = self.vcaSnapPosTimer - self.vcaTickDt 
			if self.vcaSnapPosTimer < 0 then 
				self.vcaSnapPosTimer = nil 
			end 
		
		--local dx = math.sin( curSnapAngle )
		--local dz = math.cos( curSnapAngle )	
		--local df = 0.5 * self.vcaSnapDistance
		--
		--setTextColor(0, 0, 1, 1) 
		--
		--for f=-df,df,0.25 do 
		--	for i=1,4 do 
		--		local vx, vz = f, self.vcaSnapDistance + f 
		--		if     i == 1 then 
		--			vz = self.vcaSnapDistance + df
		--		elseif i == 2 then 
		--			vz = self.vcaSnapDistance - df
		--		elseif i == 3 then 
		--			vx = df
		--		elseif i == 4 then 
		--			vx = -df
		--		end 
		--	
		--		local px = self.vcaLastSnapPosX + vz * dx + vx * dz 
		--		local pz = self.vcaLastSnapPosZ + vz * dz - vx * dx 				
		--		local py = getTerrainHeightAtWorldPos( g_currentMission.terrainRootNode, px, 0, pz )
		--		renderText3D( px,py+0.3,pz, 0,curSnapAngle-0.5*math.pi,0, 0.2, "+" )
		--		renderText3D( px,py+0.3,pz, 0,curSnapAngle,0, 0.2, "+" )
		--	end 
		--end 
		end 

		setTextAlignment( RenderText.ALIGN_LEFT ) 
		setTextVerticalAlignment( RenderText.VERTICAL_ALIGN_BASELINE )
		setTextColor(1, 1, 1, 1) 
	end 	
end


--******************************************************************************************************************************************
-- Some UI specific functions 
--******************************************************************************************************************************************
function vehicleControlAddon:newUpdateSpeedGauge( superFunc, dt ) 
	if not ( self.vehicle ~= nil
			 and self.vehicle.vcaIsLoaded
			 and self.vehicle.spec_motorized ~= nil 
			 and self.vehicle.spec_motorized.motor ~= nil 
			 and self.vehicle.spec_motorized.motor.minRpm ~= nil
			 and self.vehicle.spec_motorized.motor.maxRpm ~= nil
			 and self.vehicle.spec_motorized.motor.maxRpm > self.vehicle.spec_motorized.motor.minRpm
			 and self.vehicle:vcaGetTransmissionActive() ) then 		
		return superFunc( self, dt )
	end 

	-- used again for drawing the speed text
	self.speedKmh = math.max(0, self.vehicle:getLastSpeed() * self.vehicle.spec_motorized.speedDisplayScale)
	if self.speedKmh < 0.5 then
		self.speedKmh = 0
	end
	
	local gaugeValue = 0
	
	if false then 
		gaugeValue = MathUtil.clamp(self.speedKmh / (self.vehicle.spec_drivable.cruiseControl.maxSpeed * 1.1), 0, 1)
	elseif self.vehicle:getIsMotorStarted() then 
		local rpm
		if self.vehicle.spec_motorized.motor.vcaFakeRpm ~= nil then 
			rpm = self.vehicle.spec_motorized.motor.vcaFakeRpm
		else 
			rpm = self.vehicle.spec_motorized.motor:getNonClampedMotorRpm()
		end 
		rpm = rpm - self.vehicle.spec_motorized.motor.minRpm
		local mxr = self.vehicle.spec_motorized.motor.maxRpm - self.vehicle.spec_motorized.motor.minRpm
		gaugeValue = MathUtil.clamp( 0.1 + 0.8 * rpm / mxr, 0, 1)
	else 
		gaugeValue = 0
	end 
	
	local indicatorRotation = MathUtil.lerp(SpeedMeterDisplay.ANGLE.SPEED_GAUGE_MIN, SpeedMeterDisplay.ANGLE.SPEED_GAUGE_MAX, gaugeValue)
	self:updateGaugeIndicator(self.speedIndicatorElement, self.speedIndicatorRadiusX, self.speedIndicatorRadiusY,
		indicatorRotation)
	self:updateGaugeFillSegments(self.speedGaugeSegmentElements, gaugeValue)
	self:updateGaugePartialSegments(
		self.speedGaugeSegmentPartElements,
		indicatorRotation, 1,
		self.speedGaugeRadiusX, self.speedGaugeRadiusY,
		SpeedMeterDisplay.ANGLE.SPEED_GAUGE_MIN,
		SpeedMeterDisplay.ANGLE.SPEED_GAUGE_SEGMENT_FULL,
		SpeedMeterDisplay.ANGLE.SPEED_GAUGE_SEGMENT_SMALLEST)	
end 
function vehicleControlAddon:newDrivableGetDrivingDirection( superFunc )
	if self ~= nil and self.vcaIsLoaded then 
		if self:vcaGetNeutral() then
			return 0 
		elseif self:getIsVehicleControlledByPlayer() then 
			if self.vcaCamFwd then 
				return 1 
			else 
				return -1 
			end 
		end 
	end 
	return superFunc( self )
end 
function vehicleControlAddon:newDrivableGetAccelerationAxis( superFunc )
	if self ~= nil and self.vcaIsLoaded and ( self:vcaGetShuttleCtrl() or self:vcaGetNeutral() ) then 
		return math.max(self.spec_drivable.axisForward, 0)
	end 
	return superFunc( self )
end 
function vehicleControlAddon:newDrivableGetDecelerationAxis( superFunc )
	if self ~= nil and self.vcaIsLoaded and ( self:vcaGetShuttleCtrl() or self:vcaGetNeutral() ) then 
		return math.max(-self.spec_drivable.axisForward, 0)
	end 
	return superFunc( self )
end 
function vehicleControlAddon:newDrivableGetAcDecelerationAxis( superFunc )
	if self ~= nil and self.vcaIsLoaded and ( self:vcaGetShuttleCtrl() or self:vcaGetNeutral() ) then 
		return self.spec_drivable.axisForward
	end 
	return superFunc( self )
end 
function vehicleControlAddon:newDrivableGetCruiseControlAxis( superFunc )
	if self ~= nil and self.vcaIsLoaded and self.vcaKSIsOn then 
		return 1
	end 
	return superFunc( self )
end 

SpeedMeterDisplay.updateSpeedGauge = Utils.overwrittenFunction( SpeedMeterDisplay.updateSpeedGauge, vehicleControlAddon.newUpdateSpeedGauge )
Drivable.getDrivingDirection       = Utils.overwrittenFunction( Drivable.getDrivingDirection,       vehicleControlAddon.newDrivableGetDrivingDirection )
Drivable.getAccelerationAxis       = Utils.overwrittenFunction( Drivable.getAccelerationAxis,       vehicleControlAddon.newDrivableGetAccelerationAxis )
Drivable.getDecelerationAxis       = Utils.overwrittenFunction( Drivable.getDecelerationAxis,       vehicleControlAddon.newDrivableGetDecelerationAxis )
Drivable.getAcDecelerationAxis     = Utils.overwrittenFunction( Drivable.getAcDecelerationAxis,     vehicleControlAddon.newDrivableGetAcDecelerationAxis )
Drivable.getCruiseControlAxis      = Utils.overwrittenFunction( Drivable.getCruiseControlAxis,      vehicleControlAddon.newDrivableGetCruiseControlAxis )
--******************************************************************************************************************************************


function vehicleControlAddon:onReadStream(streamId, connection)

	self:vcaSetState( "vcaSteeringIsOn" , streamReadBool(streamId)      , true )
  self:vcaSetState( "vcaCamRotInside" , streamReadBool(streamId)      , true )
  self:vcaSetState( "vcaCamRotOutside", streamReadBool(streamId)      , true )
  self:vcaSetState( "vcaCamRevInside" , streamReadBool(streamId)      , true )
  self:vcaSetState( "vcaCamRevOutside", streamReadBool(streamId)      , true )
  self:vcaSetState( "vcaCamFwd"       , streamReadBool(streamId)      , true )
  self:vcaSetState( "vcaShuttleCtrl"  , streamReadBool(streamId)      , true )
  self:vcaSetState( "vcaShuttleFwd"   , streamReadBool(streamId)      , true )
  self:vcaSetState( "vcaNeutral"      , streamReadBool(streamId)      , true )
  self:vcaSetState( "vcaDrawHud"      , streamReadBool(streamId)      , true )
	self:vcaSetState( "vcaExternalDir"  , streamReadInt16(streamId)     , true )   
	self:vcaSetState( "vcaExponent"     , streamReadInt16(streamId)     , true )   
	self:vcaSetState( "vcaSnapAngle"    , streamReadInt16(streamId)     , true )   
	self:vcaSetState( "vcaPeekLeftRight", streamReadBool(streamId)      , true )
	self:vcaSetState( "vcaAutoShift"    , streamReadBool(streamId)      , true )
	self:vcaSetState( "vcaLimitSpeed"   , streamReadBool(streamId)      , true )
	self:vcaSetState( "vcaLimitThrottle", streamReadInt16(streamId)     , true )
	self:vcaSetState( "vcaBrakeForce"   , streamReadInt16(streamId)*0.05, true )
	self:vcaSetState( "vcaLaunchGear"   , streamReadInt16(streamId)     , true )
	self:vcaSetState( "vcaTransmission" , streamReadInt16(streamId)     , true )
	self:vcaSetState( "vcaMaxSpeed"     , streamReadFloat32(streamId)   , true )
	self:vcaSetState( "vcaLastSnapAngle", streamReadFloat32(streamId)   , true )
	self:vcaSetState( "vcaLastSnapPosX" , streamReadFloat32(streamId)   , true )
	self:vcaSetState( "vcaLastSnapPosZ" , streamReadFloat32(streamId)   , true )
	
end

function vehicleControlAddon:onWriteStream(streamId, connection)

	streamWriteBool(streamId,    self.vcaSteeringIsOn )
	streamWriteBool(streamId,    self.vcaCamRotInside )
	streamWriteBool(streamId,    self.vcaCamRotOutside )
	streamWriteBool(streamId,    self.vcaCamRevInside )
	streamWriteBool(streamId,    self.vcaCamRevOutside )
	streamWriteBool(streamId,    self.vcaCamFwd )     
	streamWriteBool(streamId,    self.vcaShuttleCtrl )     
	streamWriteBool(streamId,    self.vcaShuttleFwd )     
	streamWriteBool(streamId,    self.vcaNeutral )     
	streamWriteBool(streamId,    self.vcaDrawHud )     
	streamWriteInt16(streamId,   self.vcaExternalDir )     
	streamWriteInt16(streamId,   self.vcaExponent )     
	streamWriteInt16(streamId,   self.vcaSnapAngle )     
	streamWriteBool(streamId,    self.vcaPeekLeftRight )
	streamWriteBool(streamId,    self.vcaAutoShift     )
	streamWriteBool(streamId,    self.vcaLimitSpeed    )
	streamWriteInt16(streamId,   self.vcaLimitThrottle )
	streamWriteInt16(streamId,   math.floor( 20 * self.vcaBrakeForce + 0.5 ) )
	streamWriteInt16(streamId,   self.vcaLaunchGear    )
	streamWriteInt16(streamId,   self.vcaTransmission  )
	streamWriteFloat32(streamId, self.vcaMaxSpeed      )
	streamWriteFloat32(streamId, self.vcaLastSnapAngle )
	streamWriteFloat32(streamId, self.vcaLastSnapPosX  )
	streamWriteFloat32(streamId, self.vcaLastSnapPosZ  )

end 


function vehicleControlAddon:onReadUpdateStream(streamId, timestamp, connection)
	local motor = self.spec_motorized.motor
	if streamReadBool(streamId) then
		if not connection:getIsServer() then
		-- receive vcaClutchPercent from client  
			self.vcaClutchPercent = streamReadUIntN(streamId, 10) / 1023 
		else 
		-- receive vcaClutchDisp from server 
			self.vcaClutchDisp = streamReadUIntN(streamId, 10) / 1023
			self.vcaRpmFactor  = streamReadUIntN(streamId, 6 ) / 43
		end 
	end
end

function vehicleControlAddon:onWriteUpdateStream(streamId, connection, dirtyMask)
	local spec = self.spec_motorized
	if connection:getIsServer() then
	-- send vcaClutchPercent to server 
		if streamWriteBool(streamId, math.abs( self.vcaClutchPercent - self.vcaClutchPercentS ) > 0.001) then
			streamWriteUIntN(streamId, math.floor( self.vcaClutchPercent * 1023 + 0.5 ), 10)
			self.vcaClutchPercentS = self.vcaClutchPercent
		end
	else 
	-- send vcaClutchDisp and vcaRpmFactor to client
		local hasUpdate = false 
		if     math.abs( self.vcaClutchDisp - self.vcaClutchDispS ) > 0.001
				or math.abs( self.vcaRpmFactor  - self.vcaRpmFactorS  ) > 0.02 then 
			hasUpdate = true 
		end 
			
		if streamWriteBool(streamId, hasUpdate ) then
			streamWriteUIntN(streamId, vehicleControlAddon.mbClamp( math.floor( 0.5 + self.vcaClutchDisp * 1023 ), 0, 1023 ), 10)			
			-- 0 to 1.1 * maxRpm; 3723 * 1.1 = 4095.3
			streamWriteUIntN(streamId, vehicleControlAddon.mbClamp( math.floor( 0.5 + self.vcaRpmFactor * 43 ), 0, 63 ), 6)
			self.vcaClutchDispS = self.vcaClutchDisp  
			self.vcaRpmFactorS  = self.vcaRpmFactor 
		end
	end

end

function vehicleControlAddon:onStartReverseDirectionChange()
	if self.vcaShuttleCtrl then 
		self:vcaSetState( "vcaShuttleFwd", not self.vcaShuttleFwd )
	end 
end 

function vehicleControlAddon:vcaGetSteeringNode()
	if self.spec_aiVehicle ~= nil and self.spec_aiVehicle.steeringNode ~= nil then 
		return self.spec_aiVehicle.steeringNode
	end 
	return self.components[1].node  
end 

function vehicleControlAddon:vcaGetCurrentSnapAngle(curRot)

	if self.vcaLastSnapAngle == nil or curRot == nil then 
		return 0 
	end
	
	local a = self.vcaLastSnapAngle
	local c = curRot 
	local f = 0.5 -- 0.5 for 180° and 0.25 for 90°

	while a - c <= -math.pi*f do 
		a = a + math.pi*(f+f)
	end 
	while a - c > math.pi*f do 
		a = a - math.pi*(f+f)
	end

	return a			
end 

function vehicleControlAddon:getDefaultTransmission()
	if VCAGlobals.transmission <= 0 then 
		return 0
	elseif self.spec_combine ~= nil then 
		return 1
	end 
	return VCAGlobals.transmission
end 

function vehicleControlAddon:getDefaultMaxSpeed()
	local m 
	local n = Utils.getNoNil( self.vcaMaxForwardSpeed, self.spec_motorized.motor.maxForwardSpeed )

	if     n <= 7.5 then 
	--25.2 km/h
		m = 7
	elseif n <= 9 then 
	--32 km/h
		m = 8.889
	elseif n <= 12.223 then 
	--43 km/h
		m = 11.944
	elseif n <= 14.723 then 
	--58 km/h for vehicles up to 53 km/h
		m = 16.111
	elseif n <= 21 then 
	--73.5 km/h for vehicles up to 63 km/h
		m = n * 7 / 6
	else
	--120 km/h for vehicles with 90 km/h max speed
		m = n * 4 / 3
	end 
	return math.max( m, n )
end 

function vehicleControlAddon:getDefaultReverse( isInside )
	if isInside then 
		if self.attacherJoints ~= nil then
			for _,a in pairs( self.attacherJoints ) do
				if a.jointType == JOINTTYPE_SEMITRAILER then
					return false
				end
			end
		end
	
		if SpecializationUtil.hasSpecialization(Combine, self.specializations) then
			return false
		end 
		
		return VCAGlobals.camReverseRotation 
	end
	
	return VCAGlobals.camRevOutRotation
end

function vehicleControlAddon:vcaScaleFx( fx, mi, ma )
	return vehicleControlAddon.mbClamp( 1 + self.vcaFactor * ( fx - 1 ), mi, ma )
end

--******************************************************************************************************************************************
function vehicleControlAddon:vcaUpdateVehiclePhysics( superFunc, axisForward, axisSide, doHandbrake, dt )
	--*******************************************************************
	-- Snap Angle
	local axisSideLast       = self.vcaAxisSideLast
	local lastSnapAngleTimer = self.vcaSnapAngleTimer
	self.vcaAxisSideLast     = nil
	self.vcaSnapAngleTimer   = nil
	self.vcaLastSnapIsOn     = self.vcaSnapIsOn 
	
	if self.vcaSnapIsOn then 
		if not ( self.vcaIsEnteredMP ) then
			self:vcaSetState( "vcaSnapIsOn", false )
		elseif self.spec_aiVehicle ~= nil and self.spec_aiVehicle.isActive then 
			self:vcaSetState( "vcaSnapIsOn", false )
		elseif self.aiveAutoSteer then 
			self:vcaSetState( "vcaSnapIsOn", false )
		end 
	end 
	
	if self.vcaSnapIsOn then 
		local lx, lz 
		local m = self.movingDirection
		if self.lastSpeedReal * 3600 < 1 or ( -0.5 < m and m < 0.5 ) then 
			m = self.vcaMovingDir 
		end 
		if m < 0 then 
			lx,_,lz = localDirectionToWorld( self:vcaGetSteeringNode(), 0, 0, -1 )	
		else 
			lx,_,lz = localDirectionToWorld( self:vcaGetSteeringNode(), 0, 0, 1 )		
		end 
		local wx,_,wz = getWorldTranslation( self:vcaGetSteeringNode() )
		if lx*lx+lz*lz > 1e-6 then 
			local rot    = math.atan2( lx, lz )
			local d      = vehicleControlAddon.snapAngles[self.vcaSnapAngle]
			
			if not ( -4 <= self.vcaLastSnapAngle and self.vcaLastSnapAngle <= 4 ) then 
				if self:getIsVehicleControlledByPlayer() then 
					self.vcaSnapPosTimer = 20000
				end 

				self:vcaSetState( "vcaLastSnapPosX", wx )
				self:vcaSetState( "vcaLastSnapPosZ", wz )
				local target = 0
				local diff   = math.pi+math.pi
				if d == nil then 
					if self.vcaSnapAngle < 1 then 
						d = vehicleControlAddon.snapAngles[1] 
					else 
						d = 90 
					end 
				end 
				for i=0,360,d do 
					local a = math.rad( i )
					local b = math.abs( vehicleControlAddon.normalizeAngle( a - rot ) )
					if b < diff then 
						target = a 
						diff   = b
					end 
				end 
				
				self:vcaSetState( "vcaLastSnapAngle", vehicleControlAddon.normalizeAngle( target ) )
				self:vcaSetState( "vcaSnapFactor", 0 )
			end 
			
			local curSnapAngle = vehicleControlAddon.vcaGetCurrentSnapAngle( self, rot )
			
			local dist    = 0
			local diffR   = vehicleControlAddon.normalizeAngle( rot - curSnapAngle )
			
			if     diffR > 0.5 * math.pi then 
				curSnapAngle = curSnapAngle + math.pi
				diffR = vehicleControlAddon.normalizeAngle( rot - curSnapAngle )
			elseif diffR <-0.5 * math.pi then 
				curSnapAngle = curSnapAngle - math.pi
				diffR = vehicleControlAddon.normalizeAngle( rot - curSnapAngle )
			end 
	
			local f = self.vcaSnapFactor
			if m < 0 then 
				f = -f 
			end 
			do
				local dx    = math.sin( curSnapAngle )
				local dz    = math.cos( curSnapAngle )			
				local distX = wx - self.vcaLastSnapPosX
				local distZ = wz - self.vcaLastSnapPosZ 			
				local dist  = dist + distX * dz - distZ * dx + f * self.vcaSnapDistance				
				local alpha = math.asin( vehicleControlAddon.mbClamp( 0.1 * dist, -0.851, 0.851 ) )			
				diffR = diffR + alpha
			end 
			local a = vehicleControlAddon.mbClamp( diffR / 0.174, -1, 1 ) 
			if m < 0 then 
				a = -a 
			end

			d = 0.0005 * ( 2 + math.min( 18, self.lastSpeed * 3600 ) ) * dt
			
			if axisSideLast == nil then 
				axisSideLast = axisSide
			end 
			
			axisSide = axisSideLast + vehicleControlAddon.mbClamp( a - axisSideLast, -d, d )
			
		--print(string.format("%3d°, %3d°, %2d, %2d, %6.3f, %6.3f",math.deg(rot), math.deg(curSnapAngle), m, self.movingDirection, a, axisSide ))
		end 
	end 
	self.vcaAxisSideLast = axisSide
	
	local ccState = nil
	local spec = self.spec_drivable
	if      self.vcaIsLoaded
			and self:vcaIsVehicleControlledByPlayer()
			and spec.cruiseControl.state ~= Drivable.CRUISECONTROL_STATE_OFF
			and ( self:vcaGetShuttleCtrl() or self.movingDirection > 0 )
			and axisForward > 0 then 
		local speed,_ = self:getSpeedLimit(true)			
		ccState = spec.cruiseControl.state
		spec.cruiseControl.state = Drivable.CRUISECONTROL_STATE_OFF
		self:getMotor():setSpeedLimit( speed )
	end 
	
	local res = { superFunc( self, axisForward, axisSide, doHandbrake, dt ) }
	
	if ccState ~= nil and spec.cruiseControl.state == Drivable.CRUISECONTROL_STATE_OFF then 
		self:setCruiseControlState(ccState)
	end 
	
	return unpack( res )
end 

Drivable.updateVehiclePhysics = Utils.overwrittenFunction( Drivable.updateVehiclePhysics, vehicleControlAddon.vcaUpdateVehiclePhysics )
--******************************************************************************************************************************************
-- shuttle control and inching
function vehicleControlAddon:vcaUpdateWheelsPhysics( superFunc, dt, currentSpeed, acceleration, doHandbrake, stopAndGoBraking )

	if not ( self.vcaIsLoaded ) then 
		return superFunc( self, dt, currentSpeed, acceleration, doHandbrake, stopAndGoBraking )
	end 

	local lightsBackup = self.spec_lights
	local brake        = ( acceleration < -0.1 )
	
	self.vcaOldAcc       = acceleration
	self.vcaOldHandbrake = doHandbrake
	self.vcaBrakePedal   = nil

	if self.vcaIsLoaded and self:vcaIsVehicleControlledByPlayer() then 		
		if self.vcaKSIsOn and self.spec_drivable.cruiseControl.state == 0 then 
			if math.abs( self.vcaKeepSpeed ) < 0.5 then 
				acceleration = 0
				doHandbrake  = true 
				self:getMotor().vcaAutoStop = true 
				brake = true 
			else 
				self.spec_motorized.motor:setSpeedLimit( math.min( self:getSpeedLimit(true), math.abs(self.vcaKeepSpeed) ) )
				if self:vcaGetShuttleCtrl() then 
					acceleration = 1
					brake        = false 
				elseif self.vcaKeepSpeed > 0 then 
					acceleration = self.spec_drivable.reverserDirection
					self.nextMovingDirection = 1
				else
					acceleration = -self.spec_drivable.reverserDirection
					self.nextMovingDirection = -1
				end 
			end 
			self.vcaOldAcc = acceleration
		end 
	
		if self:vcaGetShuttleCtrl() then 
			if     self.vcaShuttleFwd then 
				self.nextMovingDirection = 1 
			else 
				self.nextMovingDirection = -1 
			end 
			
			if not self:getIsMotorStarted() then 
				acceleration = 0
				doHandbrake  = true 
			elseif acceleration < -0.01 then  
				local lowSpeedBrake = 1.389e-4 - acceleration * 6.944e-4 -- 0.5 .. 3			
				if  math.abs( currentSpeed ) < lowSpeedBrake then 
					-- braking at low speed
					acceleration = 0
					doHandbrake  = true 
				end			
			elseif acceleration < 0 then 
				acceleration = 0				
			end 
			if self:vcaGetNeutral() then 
				if self.vcaNeutral and not self.vcaShifterUsed then 
					doHandbrake = true 
				end 
				if acceleration > -0.05 then 
					acceleration = 0 
				end 
			end 
			if      self.spec_motorized.motor.vcaDirTimer ~= nil then 
				doHandbrake  = true 
				acceleration = 0 
				if self.lastSpeedReal * 3600 > 1 then 
					brake      = true 
				end 
			elseif  self.spec_motorized.motor.vcaAutoStop
					and acceleration < 0.1 then 
				doHandbrake  = true 
			end		
			if doHandbrake then 
				self.vcaBrakePedal = 1
			else 
				self.vcaBrakePedal = math.max( 0, -acceleration )
			end 
		end 			
			
		if self.spec_drivable.cruiseControl.state == 0 and self.vcaLimitThrottle ~= nil and self.vcaInchingIsOn ~= nil and math.abs( acceleration ) > 0.01 then 
			local limitThrottleRatio     = 0.75
			local limitThrottleIfPressed = true
			if self.vcaLimitThrottle < 11 then
				limitThrottleIfPressed = false
				limitThrottleRatio     = 0.45 + 0.05 * self.vcaLimitThrottle
			else
				limitThrottleIfPressed = true
				limitThrottleRatio     = 1.5 - 0.05 * self.vcaLimitThrottle
			end
				
			if self.vcaInchingIsOn == limitThrottleIfPressed then
				acceleration   = acceleration   * limitThrottleRatio
				self.vcaOldAcc = self.vcaOldAcc * limitThrottleRatio
			end
		end
	end 
	
	self.vcaNewAcc       = acceleration
	self.vcaNewHandbrake = doHandbrake
	
	local rotatedTimeBackup = self.rotatedTime
	if self:vcaGetShuttleCtrl() then 
		self.spec_lights   = nil
		stopAndGoBraking   = true 
	
		if      self.spec_motorized.motor.vcaDirTimer ~= nil 
				and self.spec_articulatedAxis ~= nil
				and self.spec_articulatedAxis.componentJoint ~= nil
				and math.abs(self.rotatedTime) > 0.01 then 
			self.rotatedTime  = 0
		end 
	end 
	
	local state, result = pcall( superFunc, self, dt, currentSpeed, acceleration, doHandbrake, stopAndGoBraking ) 
	if not ( state ) then
		print("Error in updateWheelsPhysics :"..tostring(result))
		self.spec_lights     = lightsBackup
		self.rotatedTime     = rotatedTimeBackup
		self.vcaShuttleCtrl  = false 
		self.vcaTransmission = 0 
	end
	
	if self:vcaGetShuttleCtrl() then 
		self.spec_lights = lightsBackup
		self.rotatedTime = rotatedTimeBackup
		if type( self.setBrakeLightsVisibility ) == "function" then 
			self:setBrakeLightsVisibility( brake )
		end 
		if type( self.setReverseLightsVisibility ) == "function" then 
			self:setReverseLightsVisibility( not self.vcaShuttleFwd )
		end 
	end 
	
	return result 
end 
WheelsUtil.updateWheelsPhysics = Utils.overwrittenFunction( WheelsUtil.updateWheelsPhysics, vehicleControlAddon.vcaUpdateWheelsPhysics )
--******************************************************************************************************************************************

--******************************************************************************************************************************************
-- getSmoothedAcceleratorAndBrakePedals
function vehicleControlAddon:vcaGetSmoothedAcceleratorAndBrakePedals( superFunc, acceleratorPedal, brakePedal, dt )
	if      self.vcaIsLoaded
			and self:vcaIsVehicleControlledByPlayer()
			and self.vcaBrakePedal ~= nil
			-- limit for automaticBrake is 0.001; take 0.003 to be on the safe side 
			and ( math.abs( acceleratorPedal ) >= 0.003
			   or self:vcaGetNeutral() 
				 or self.vcaBrakePedal >= 0.003 ) then 
		brakePedal = self.vcaBrakePedal
	end 
	
	return superFunc( self, acceleratorPedal, brakePedal, dt )
end 

WheelsUtil.getSmoothedAcceleratorAndBrakePedals = Utils.overwrittenFunction( WheelsUtil.getSmoothedAcceleratorAndBrakePedals, vehicleControlAddon.vcaGetSmoothedAcceleratorAndBrakePedals )
--******************************************************************************************************************************************

function vehicleControlAddon:vcaSetSpeedLimit( superFunc, limit )
	self.vcaWantedSpeedLimit = nil
	if not (  self.vehicle ~= nil
				and self.vehicle.vcaIsLoaded
				and self.vehicle.vcaLastTransmission ~= nil
				and self.vehicle.vcaLastTransmission >= 1 ) then 
		return superFunc( self, limit )
	end 
	if     self.vehicle.spec_drivable.cruiseControl.state == Drivable.CRUISECONTROL_STATE_OFF 
			or self.vehicle.spec_drivable.cruiseControl.state == Drivable.CRUISECONTROL_STATE_FULL then 
		return superFunc( self, limit )
	end 
	self.vcaWantedSpeedLimit = math.max(limit, self.minSpeed) 
end 

VehicleMotor.setSpeedLimit = Utils.overwrittenFunction( VehicleMotor.setSpeedLimit, vehicleControlAddon.vcaSetSpeedLimit )


--******************************************************************************************************************************************
-- increased minRPM
function vehicleControlAddon:getRequiredMotorRpmRange( superFunc, ... )
	if      self.vcaMinRpm ~= nil 
			and self.vcaMaxRpm ~= nil then 
		return self.vcaMinRpm, self.vcaMaxRpm 
	end 
	return superFunc( self, ... )
end 

VehicleMotor.getRequiredMotorRpmRange = Utils.overwrittenFunction( VehicleMotor.getRequiredMotorRpmRange, vehicleControlAddon.getRequiredMotorRpmRange )

--******************************************************************************************************************************************
-- less acceleration 
function vehicleControlAddon:getAccelerationLimit( superFunc, ... )
	if not (  self.vehicle ~= nil
				and self.vehicle.vcaIsLoaded
				and self.vehicle.vcaLastTransmission ~= nil
				and self.vehicle.vcaActualLoad       ~= nil
				and self.vehicle.vcaLastTransmission >= 1 ) then 
		return superFunc( self, ... )
	end 
--if self.vcaAccS == nil or self.vcaAccS < 0.2 then 
--	return superFunc( self, ... )
--end 
	local a = superFunc( self, ... )
	local f = 0.01 + vehicleControlAddon.mbClamp( 3 * ( 1 - math.max( self.vehicle.vcaActualLoad, self.vehicle.vcaActualLoadS ) ), 0, 0.99 )
	if f >= 1 then 
		return a 
	end 
	return f * a
end 

VehicleMotor.getAccelerationLimit = Utils.overwrittenFunction( VehicleMotor.getAccelerationLimit, vehicleControlAddon.getAccelerationLimit )

--******************************************************************************************************************************************
-- select gear
function vehicleControlAddon:vcaUpdateGear( superFunc, acceleratorPedal, dt )
	
	if not ( self.vehicle ~= nil and self.vehicle.vcaIsLoaded ) then 
		return superFunc( self, acceleratorPedal, dt )
	end

	self.vehicle.vcaUpdateGearDone    = true 
	if self.vehicle.vcaIsEnteredMP  then 
	  self.vehicle.vcaUpdateGearTimer = g_currentMission.time + 1000
	end 
		
	local lastMinRpm        = Utils.getNoNil( self.vcaMinRpm,   self.minRpm )
	local lastMaxRpm        = Utils.getNoNil( self.vcaMaxRpm,   self.maxRpm )
	local lastFakeRpm       = Utils.getNoNil( self.vcaFakeRpm,  math.max( self.equalizedMotorRpm, self.minRpm )) 
	local lastIdleAcc       = Utils.getNoNil( self.vcaIdleAcc,  0 )
	local lastRpmC          = self.vcaLastRpmC
	local lastRpmW          = self.vcaLastRpmW
	local lastAutoStopTimer = self.vcaAutoStopTimer
	local lastStallTimer    = self.vcaStallTimer
	local lastAutoShiftLoad = Utils.getNoNil( self.vcaAutoShiftLoad, 0 )
	
	self.vcaMinRpm        = nil 
	self.vcaMaxRpm        = nil 
	self.vcaFakeRpm       = nil
	self.vcaClutchRpm     = nil 
	self.vcaLastRpmC      = nil 
	self.vcaLastRpmW      = nil 
	self.vcaIdleAcc       = nil
	self.vcaAutoStopTimer = nil 
	self.vcaStallTimer    = nil
	self.vcaAutoShiftLoad = nil
	
	local speed        = math.abs( self.vehicle.lastSpeedReal ) *3600
	local motorPtoRpm  = math.min(PowerConsumer.getMaxPtoRpm(self.vehicle)*self.ptoMotorRpmRatio, self.maxRpm)
	local motorRpm     = self.motorRotSpeed * vehicleControlAddon.factor30pi
	local rpmRange     = self.maxRpm - self.minRpm
	
	local idleRpm      = self.minRpm  
	if     self.vehicle.vcaHandthrottle == nil 
			or self.vehicle.vcaHandthrottle == 0 then 
	elseif self.vehicle.vcaHandthrottle < 0 then 
		idleRpm          = math.max( idleRpm, -self.vehicle.vcaHandthrottle * motorPtoRpm )
	elseif self.vehicle.vcaHandthrottle > 0 then 
		idleRpm          = self.minRpm + self.vehicle.vcaHandthrottle * rpmRange
		if self.vehicle:vcaGetNoIVT() and self.vehicle:vcaGetAutoShift() then 
			idleRpm        = math.min( idleRpm, 0.95 * self.maxRpm )
		end 
	elseif not self.vcaIsEnteredMP then 
		idleRpm = vehicleControlAddon.mbClamp( motorPtoRpm, self.minRpm, self.maxRpm )
	end 
	
	if self.vcaWantedSpeedLimit ~= nil then 
		if self.vcaSpeedLimit == nil then 
			self.vcaSpeedLimit = speed
		end 
		local limit,_   = self.vehicle:getSpeedLimit(true)
		if     self.vcaSpeedLimit > limit then 
			self.vcaSpeedLimit = math.max( self.vcaWantedSpeedLimit, math.min( speed, self.vcaSpeedLimit ) - 0.004 * dt )
		elseif self.vcaSpeedLimit > self.vcaWantedSpeedLimit then  
			self.vcaSpeedLimit = math.max( self.vcaWantedSpeedLimit, math.min( speed, self.vcaSpeedLimit ) - 0.001 * dt * math.max( 2, speed * 0.1 ) )
		elseif self.vcaSpeedLimit < self.vcaWantedSpeedLimit then 
			self.vcaSpeedLimit = math.min( self.vcaWantedSpeedLimit, math.max( speed, self.vcaSpeedLimit ) + 0.002 * dt )
		end 
		self.speedLimit = self.vcaSpeedLimit
	else 
		self.vcaSpeedLimit = nil 
	end 
	
	if      self.vehicle.vcaForceStopMotor ~= nil 
			and self.vehicle.vcaForceStopMotor > 0		
			and ( self.vehicle:getIsMotorStarted()
				 or self.vehicle:vcaGetNeutral()
				 or self.vehicle:vcaGetAutoClutch() 
				 or ( self.vehicle.vcaClutchPercent ~= nil and self.vehicle.vcaClutchPercent > 0.5 ) ) then 
		self.vehicle.vcaForceStopMotor = self.vehicle.vcaForceStopMotor - dt 
		if self.vehicle.vcaForceStopMotor < 0 then 
			self.vehicle.vcaForceStopMotor = nil 
		end 
	end 
	
	if not ( self.vehicle:vcaGetTransmissionActive() or self.vehicle:vcaGetNeutral() ) then 
		if self.vehicle.vcaClutchDisp ~= nil and self.vehicle.vcaClutchDisp ~= 0 then 
			self.vehicle.vcaClutchDisp = 0
		end 
		return superFunc( self, acceleratorPedal, dt )
	end 
	
	local fwd, curBrake
	local lastFwd
	if self.vcaLastFwd ~= nil then 
		lastFwd  = self.vcaLastFwd
	elseif self.vehicle.movingDirection < 0 then 
		lastFwd = false 
	else
		lastFwd = true 
	end 
	
	if     self.vehicle.vcaBrakePedal ~= nil then 
		curBrake = self.vehicle.vcaBrakePedal
	elseif self.vehicle.spec_wheels   ~= nil then 
		curBrake = Utils.getNoNil( self.vehicle.spec_wheels.brakePedal, 0 )
	else 
		curBrake = 0
	end 
	if     self.vehicle:vcaGetNeutral() then 
		if     self.vehicle.movingDirection > 0 then 
			fwd = true 
		elseif self.vehicle.movingDirection < 0 then 
			fwd = false 
		elseif self.vehicle:vcaGetShuttleCtrl() then 
			fwd = self.vehicle.vcaShuttleFwd 
		else 
			fwd = lastFwd 
		end 
	elseif self.vehicle:vcaGetShuttleCtrl() then 
		fwd      = self.vehicle.vcaShuttleFwd 
	elseif acceleratorPedal < 0 then 
		fwd      = false 
		curBrake = 0
	elseif acceleratorPedal > 0 then 
		fwd      = true 
		curBrake = 0
	else
		fwd      = lastFwd
	end 

	self.vcaLastFwd = fwd
	
	local dftDirTimer = 1000
	if not self.vehicle:vcaIsVehicleControlledByPlayer() then
		dftDirTimer = nil
	elseif self.vehicle:vcaGetShuttleCtrl() then
		dftDirTimer = 250
	elseif stopAndGoBraking then 
		dftDirTimer = 100
	end 

	if fwd then 
		if self.vehicle.movingDirection < 0 then 
			speed = -speed 
		end 
	else 
		if self.vehicle.movingDirection > 0 then 
			speed = -speed 
		end 
	end 

	if     self.vehicle:vcaGetNeutral() then 
		self.vcaDirTimer = nil
	elseif fwd ~= lastFwd and speed < -0.5 then 
		self.vcaDirTimer = dftDirTimer 
	elseif speed >  0.5 then 
		self.vcaDirTimer = nil 
	elseif self.vcaDirTimer == nil then
	elseif speed > -0.1 then 
		self.vcaDirTimer = self.vcaDirTimer - dt
		if self.vcaDirTimer < 0 then 
			self.vcaDirTimer = nil 
		end 
	end 

	local newAcc = acceleratorPedal
	local autoNeutral =  self.vcaAutoStop or self.vehicle:vcaGetNeutral() or lastAutoStopTimer ~= nil
	
	if self.vcaDirTimer ~= nil then 
		autoNeutral = true 
		newAcc      = 0
	end 
	
	if fwd then 
		if newAcc < 0 then 
			newAcc = 0
		end 
	else 
		if newAcc > 0 then 
			newAcc = 0 
		end 
	end 

	if self.vcaDirTimer ~= nil or self.vcaLastSpeed == nil or dt <= 0 then 
		self.vcaAcc  = 0
		self.vcaAccS = 0
	else 
		self.vcaAcc  = ( speed - self.vcaLastSpeed ) / ( dt * 0.0036 )
		self.vcaAccS = self.vcaAccS + 0.01 * ( self.vcaAcc - self.vcaAccS )
	end 
	self.vcaLastSpeed = speed 
	
	local curGearRatio = self.gearRatio 
	local minGearRatio = self.minGearRatio
	local maxGearRatio = self.maxGearRatio
	if not lastFwd then 
		curGearRatio = -curGearRatio
		minGearRatio = -minGearRatio
		maxGearRatio = -maxGearRatio
	end 
	
	--****************************************
	-- neutral
	local curAcc      = math.abs( newAcc )
	local fakeAcc     = curAcc 
	if self.vehicle:vcaGetShuttleCtrl() and self.vehicle.vcaOldAcc ~= nil then 
		fakeAcc         =  self.vehicle.vcaOldAcc
	end
	if self.vcaDirTimer ~= nil then 
		fakeAcc         = 0
	end 
	local fakeRpm     = math.max( self.minRpm + fakeAcc * rpmRange, idleRpm )
	if self.vehicle.vcaHandthrottle == 0 or self.vehicle.vcaHandthrottle < -0.8 then 
		fakeRpm         = math.max( fakeRpm, motorPtoRpm )
	end 
	
	if autoNeutral then 
		self.vcaFakeRpm   = vehicleControlAddon.mbClamp( fakeRpm, lastFakeRpm - 0.0005 * dt * rpmRange, lastFakeRpm + 0.001 * dt * rpmRange )		
		self.vcaFakeTimer = 500 
		newAcc            = 0
	elseif self.vcaFakeTimer ~= nil then 
		if math.abs( lastFakeRpm - motorRpm ) < 2 then 
			self.vcaFakeTimer = nil 
		else 
			local rpmRange = self.maxRpm - self.minRpm	
			self.vcaFakeRpm   = vehicleControlAddon.mbClamp( motorRpm, lastFakeRpm - 0.0005 * dt * rpmRange, lastFakeRpm + 0.001 * dt * rpmRange )	
			self.vcaFakeTimer = self.vcaFakeTimer - dt 
			if self.vcaFakeTimer <= 0 then 
				self.vcaFakeTimer = nil 
			end 
		end 
	end 
	
	local transmission = self.vehicle.vcaGearbox 

	if autoNeutral or math.abs( newAcc ) < 1e-3 then 
		self.vehicle.vcaActualLoad = self.motorExternalTorque / math.max(self.motorAvailableTorque, 0.0001)
	else 
		self.vehicle.vcaActualLoad = self.motorAppliedTorque / math.max(self.motorAvailableTorque, 0.0001)
	end 

	if     autoNeutral or self.gearChangeTimer > 0 then 
	-- no load during shift
		if self.vehicle.vcaActualLoadN == nil and self.gearChangeTimer > 0 then 
			self.vehicle.vcaActualLoadN = self.vehicle.vcaActualLoadS 
		end 
		self.vehicle.vcaActualLoadS = self.vehicle.vcaActualLoad
	elseif self.vehicle.vcaActualLoadN ~= nil then 
	-- use previous load after shift 
		self.vehicle.vcaActualLoadS = self.vehicle.vcaActualLoadN 
		self.vehicle.vcaActualLoadN = nil 
	elseif self.vehicle.vcaActualLoadS == nil then 
	-- first time run 
		self.vehicle.vcaActualLoadS = self.vehicle.vcaActualLoad
		self.vehicle.vcaActualLoadN = nil 
	elseif self.vehicle.vcaActualLoad > self.vehicle.vcaActualLoadS then 
	-- smooth up 
		self.vehicle.vcaActualLoadS = self.vehicle.vcaActualLoadS + 0.05  * ( self.vehicle.vcaActualLoad - self.vehicle.vcaActualLoadS )
	else 
	-- smooth down 
		self.vehicle.vcaActualLoadS = self.vehicle.vcaActualLoadS + 0.015 * ( self.vehicle.vcaActualLoad - self.vehicle.vcaActualLoadS )
	end 

	local speedMS   = speed / 3.6
	local wheelRpm  = speedMS * curGearRatio * vehicleControlAddon.factor30pi
	if curGearRatio > 1000 then 
		wheelRpm = 0
	end 
	local clutchRpm = wheelRpm
	if self.gearChangeTimer <= 0 and not autoNeutral then 
		clutchRpm = self.differentialRotSpeed * self.gearRatio * vehicleControlAddon.factor30pi
		if wheelRpm > clutchRpm then 
			wheelRpm = clutchRpm 
		end 
	end 
	
	if self.vcaDirTimer ~= nil then 
		self.vcaLastRpmC = 0
		self.vcaLastRpmW = 0
	elseif lastRpmC == nil or lastRpmW == nil or self.gearChangeTimer > 0 or autoNeutral or self.vcaFakeRpm ~= nil then 
		self.vcaLastRpmC = clutchRpm 
		self.vcaLastRpmW = wheelRpm 
	else 
		self.vcaLastRpmC = lastRpmC + 0.05 * ( clutchRpm - lastRpmC )
		self.vcaLastRpmW = lastRpmW + 0.05 * ( wheelRpm  - lastRpmW )
	end 
	
	local slip       = 0
	local wheelSpeed = self.differentialRotSpeed 
	if self.vcaLastSpeedLimit ~= nil and wheelSpeed * 3.6 > self.vcaLastSpeedLimit then 
		wheelSpeed = self.vcaLastSpeedLimit / 3.6
	end 
	if speedMS > 0.5 and wheelSpeed > speedMS then 
		slip = wheelSpeed / speedMS - 1
	end 
	if self.vehicle.vcaSlip == nil then 
		self.vehicle.vcaSlip = 0 
	end 
	self.vehicle.vcaSlip = self.vehicle.vcaSlip + 0.05 * ( slip - self.vehicle.vcaSlip )
	
	self.speedLimit        = self.speedLimit * ( 1 + self.vehicle.vcaSlip )
	self.vcaLastSpeedLimit = self.speedLimit
	
	if not self.vehicle:getIsMotorStarted() or dt < 0 or self.vehicle.vcaLastTransmission == nil then 
		self.vcaClutchTimer   = nil
		self.vcaAutoDownTimer = nil
		self.vcaAutoUpTimer   = nil
		self.vcaNoShiftTimer  = nil
		self.vcaAutoLowTimer  = nil
		self.vcaBrakeTimer    = nil
		self.vcaIncreaseRpm   = nil
		self.vcaAutoStop      = nil
	elseif self.vehicle.vcaGearbox ~= nil and self.vehicle.vcaGearbox.isIVT then 
--****************************************************************************************	
-- IVT
--****************************************************************************************	
		transmission:initGears() 
		
		local gear  = transmission:getRatioIndex( self.vehicle.vcaGear, self.vehicle.vcaRange )		
		local ratio = transmission:getGearRatio( gear )
		if ratio == nil then 
			print("Error in vehicleControlAddonTransmission: ratio is nil")
			gear  = 1	
			ratio = 0.5
		end 
		if self.vehicle.vcaGearRatioT > 0 and ratio > self.vehicle.vcaGearRatioT then 
			ratio = self.vehicle.vcaGearRatioT
		end 
		local maxSpeed  = ratio * self.vehicle.vcaMaxSpeed 
	
		local peakPowerNRpmL = 1
		local peakPowerNRpmH = 1
		if self.vcaMaxPowerRpmL ~= nil and self.vcaMaxPowerRpmL < self.maxRpm then 
			peakPowerNRpmL    = self.vcaMaxPowerRpmL / self.maxRpm 
		end 
		if self.vcaMaxPowerRpmH ~= nil and self.vcaMaxPowerRpmH < self.maxRpm then 
			peakPowerNRpmH    = self.vcaMaxPowerRpmH / self.maxRpm 
		end 
		
		if self.vehicle.vcaClutchDisp ~= 0 then 
			self.vehiclevcaClutchDisp = 0
		end 
	
		if     self.vehicle.vcaHandthrottle > 0 then 
			newMinRpm = math.max( self.minRpm, idleRpm * 0.95 )
			newMaxRpm = math.min( self.maxRpm, idleRpm * 1.05 )
		elseif motorPtoRpm > 0 and self.vehicle.vcaHandthrottle < 0 then 
			newMinRpm = math.max( self.minRpm, idleRpm * 0.95 )
			newMaxRpm = math.min( self.maxRpm, idleRpm * 1.05 ) 
		elseif motorPtoRpm > 0 then 
			newMinRpm = math.max( self.minRpm, motorPtoRpm * 0.95 )
			newMaxRpm = math.min( self.maxRpm, motorPtoRpm * 1.05 )
		else 
			newMinRpm = self.minRpm
			newMaxRpm = self.maxRpm
		end 
		
	--if self.vehicle.vcaGearRatioF > 0 then 
	--	newMinRpm = vehicleControlAddon.mbClamp( self.vehicle.lastSpeedReal * 1000 * self.maxRpm / ( maxSpeed * self.vehicle.vcaGearRatioF ), self.minRpm, self.maxRpm )
	--end 
	--if self.vehicle.vcaGearRatioT > 0 then 
	--	newMaxRpm = vehicleControlAddon.mbClamp( self.vehicle.lastSpeedReal * 1000 * self.maxRpm / ( maxSpeed * self.vehicle.vcaGearRatioT ), self.minRpm, self.maxRpm )
	--end 
					
		if speed > 2 then 
			self.vcaIncreaseRpm = g_currentMission.time + 2000 
		end 
		
		local minReducedRpm = math.min( math.max( newMinRpm, 0.5*math.min( 2200, self.maxRpm ) ), newMaxRpm )
		if self.vehicle.spec_combine ~= nil then 
			minReducedRpm = math.min( math.max( newMinRpm, 0.8*math.min( 2200, self.maxRpm ) ), newMaxRpm )
		end 
		
		local noThrottle = ( curAcc <= 0.1 )
		if speed >= self:getSpeedLimit() - 0.5 then 
			if self.vehicle.vcaKSIsOn then 
				noThrottle = self.vehicle.vcaOldAcc <= 0.1
			else 
				noThrottle = true 
			end 
		end 
		if noThrottle then 
			minReducedRpm = math.max( minReducedRpm - 0.05 * self.maxRpm, newMinRpm )
		else 
			minReducedRpm = math.min( minReducedRpm + 0.05 * self.maxRpm, self.maxRpm )
		end 					
		
		if self.vcaIncreaseRpm ~= nil and g_currentMission.time < self.vcaIncreaseRpm then 
			if speed > 0.5 then 
				newMinRpm = vehicleControlAddon.mbClamp( minReducedRpm, newMinRpm, newMaxRpm )
			end 
			if self.vcaFakeRpm ~= nil then 
				self.vcaFakeRpm = math.max( self.vcaFakeRpm, minReducedRpm )
			end 
		end		
		
		minReducedRpm = minReducedRpm + 0.2 * self.maxRpm
		
		if self.vehicle.spec_combine == nil and self.vehicle.vcaLimitThrottle ~= nil and self.vehicle.vcaInchingIsOn ~= nil then 
				
			if self.vehicle.spec_drivable.cruiseControl.state == 0 then
					
				local limitThrottleRatio     = 0.75
				local limitThrottleIfPressed = true
				if self.vehicle.vcaLimitThrottle < 11 then
					limitThrottleIfPressed = false
					limitThrottleRatio     = 0.45 + 0.05 * self.vehicle.vcaLimitThrottle
				else
					limitThrottleIfPressed = true
					limitThrottleRatio     = 1.5 - 0.05 * self.vehicle.vcaLimitThrottle
				end
						
				if self.vehicle.vcaInchingIsOn == limitThrottleIfPressed then 
					newMaxRpm = math.max( minReducedRpm, math.min( newMaxRpm, self.maxRpm * limitThrottleRatio ) )
				end 
			end 

			-- vehicle should be able to reach max speed 
			local speedFactor = 0
			if maxSpeed > 0 then 
				speedFactor = self.maxRpm / ( 3.6 * maxSpeed ) 
			end 
			if speed > 0 then 
				newMinRpm = vehicleControlAddon.mbClamp( speedFactor * math.min( speed, 3.6 * maxSpeed ), newMinRpm, newMaxRpm )
			end 
			if self.vcaAccS > 0.25 and newMaxRpm > self.vcaMaxPowerRpmL then 
				-- reduce max RPM at high acceleration; note: we are still at 97% max. power
				local r = newMaxRpm
				if self.vcaAcc >= 1.25 then 
					r = self.vcaMaxPowerRpmL
				else
					r = self.vcaMaxPowerRpmL + ( 1.25 - self.vcaAccS )^2 * ( newMaxRpm - self.vcaMaxPowerRpmL )
				end 
				newMaxRpm = math.min( newMaxRpm, math.max( newMinRpm, r, speedFactor * ( speed + 1 ) ) )
			end 
			
			local m1, m2 = newMinRpm, newMaxRpm 
			
			if     self.vehicle.vcaActualLoadS >= 0.97 then 
				newMaxRpm = vehicleControlAddon.mbClamp( self.vcaMaxPowerRpmL, m1, m2 )
				newMinRpm = vehicleControlAddon.mbClamp( self.vcaMaxPowerRpmL, m1, m2 )
			elseif self.vehicle.vcaActualLoadS >= 0.8 then 
				local v = 0
				if self.vehicle.vcaActualLoadS > 0.9 then 
					v = ( self.vehicle.vcaActualLoadS - 0.9 ) / ( 0.97 - 0.9 )
				end 
				local fl, fh = 1.00, peakPowerNRpmL
				newMaxRpm = vehicleControlAddon.mbClamp( ( fl + v * ( fh - fl ) ) * self.maxRpm, m1, m2 )
				fl, fh = peakPowerNRpmH, peakPowerNRpmL
				newMinRpm = vehicleControlAddon.mbClamp( ( fl + v * ( fh - fl ) ) * self.maxRpm, m1, m2 )
			else 
				newMaxRpm = vehicleControlAddon.mbClamp( math.max( minReducedRpm, speedFactor * ( speed + 1 ) ), m1, m2 )

				if self.vehicle.vcaActualLoadS > 0.7 then 
					local v = ( self.vehicle.vcaActualLoadS - 0.7 ) / ( 0.8 - 0.7 )
					newMinRpm = vehicleControlAddon.mbClamp( newMinRpm + v * ( self.vcaMaxPowerRpmH - newMinRpm ), m1, m2 )
					newMaxRpm = vehicleControlAddon.mbClamp( newMaxRpm + v * ( self.maxRpm - newMaxRpm ), m1, m2 )
				end 
			end 

		end 
		
		local deltaS, deltaF
		deltaS = self:getMaxRpm() * 0.0001 * dt
		deltaF = self:getMaxRpm() * 0.0002 * dt
		self.vcaMinRpm = vehicleControlAddon.mbClamp( newMinRpm, lastMinRpm - deltaS, math.max( lastMinRpm, self.lastRealMotorRpm + deltaF ) )
		self.vcaMaxRpm = vehicleControlAddon.mbClamp( newMaxRpm, math.max( lastMaxRpm, self.lastRealMotorRpm ) - deltaS, lastMaxRpm + deltaS )

		self.minGearRatio = self.maxRpm / ( maxSpeed * vehicleControlAddon.factor30pi )
		self.maxGearRatio = 1000
		
	-- this is already part of maxSpeed 
	--if self.vehicle.vcaGearRatioT > 0 then 
	--	self.minGearRatio = self.maxRpm / ( self.vehicle.vcaMaxSpeed * self.vehicle.vcaGearRatioT * vehicleControlAddon.factor30pi )
	--end 
		if self.vehicle.vcaGearRatioF > 0 then 
			self.maxGearRatio = self.maxRpm / ( self.vehicle.vcaMaxSpeed * math.max( self.vehicle.vcaGearRatioT, self.vehicle.vcaGearRatioF ) * vehicleControlAddon.factor30pi )
		end 
		
		if not autoNeutral then 
			if curGearRatio > 0 and self.minGearRatio > 0 and self.maxGearRatio > 0 then 
				local g1 = 1 / curGearRatio 
				local gm = 1 / self.minGearRatio
				local gn = 1 / self.maxGearRatio
				local gd = dt * 0.0001
				self.minGearRatio = 1 / vehicleControlAddon.mbClamp( g1 + gd, gn, gm )
				self.maxGearRatio = 1 / vehicleControlAddon.mbClamp( g1 - gd, gn, gm )
			end
		end 
		
		if not fwd then 
			self.minGearRatio = -self.minGearRatio
			self.maxGearRatio = -self.maxGearRatio
		end 
		
		if     self.vcaAutoStop == nil then 
			self.vcaAutoStop = true 
		elseif curAcc > 0.1 and not self.vehicle:vcaGetNeutral() then  
			self.vcaAutoStop = false 
		elseif self.vehicle.vcaClutchPercent >= 1 and not self.vehicle.vcaNeutral then 
			self.vcaAutoStop = false 
		elseif self.vehicle:vcaGetNeutral() and speed < 1 then 
			self.vcaAutoStop = true
		elseif lastFwd ~= fwd or self.vcaDirTimer ~= nil then 
		-- no change 
		elseif speed < 3.6 and curBrake > 0.1 and not self.vcaAutoStop then 
			if lastAutoStopTimer == nil then 
				self.vcaAutoStopTimer = 1000
			elseif lastAutoStopTimer > 0 then 
				self.vcaAutoStopTimer = lastAutoStopTimer - dt 
			else 
				self.vcaAutoStop = true 
			end 
		end 
		
		self.vehicle:vcaSetState("vcaAutoClutch",true)
		self.vehicle:vcaSetState("vcaBOVVolume",0)
		if not autoNeutral then 
			local gearTime  = transmission:getChangeTimeGears()
			local rangeTime = transmission:getChangeTimeRanges()
			if not self.vehicle:vcaIsVehicleControlledByPlayer() then 
				gearTime, rangeTime = -1, -1  
			end 
			if gearTime < 1 then	
				gearTime = -1 
			end 
			if rangeTime < 1 then 
				rangeTime = -1
			end 
			
			if self.vcaLastRange ~= nil and self.vehicle.vcaRange ~= self.vcaLastRange and self.gearChangeTimer < rangeTime then 
				self.gearChangeTimer = rangeTime
				if self.vcaGearIndex ~= nil and self.vcaGearIndex < gear and rangeTime > 0 then 
					self.vehicle:vcaSetState("vcaBOVVolume",self.vehicle.vcaActualLoadS)
				end 
			end 
			if self.vcaLastGear ~= nil and self.vehicle.vcaGear ~= self.vcaLastGear and self.gearChangeTimer < gearTime then 
				self.gearChangeTimer = gearTime
				if self.vcaGearIndex ~= nil and self.vcaGearIndex < gear and gearTime > 0 then 
					self.vehicle:vcaSetState("vcaBOVVolume",self.vehicle.vcaActualLoadS)
				end 
			end 
		end 
		
		self.vcaGearIndex = gear
		self.vcaLastGear  = self.vehicle.vcaGear
		self.vcaLastRange = self.vehicle.vcaRange
		
		if self.gearChangeTimer == nil then 
			self.gearChangeTimer = 0
		elseif self.gearChangeTimer > 0 then 
			self.gearChangeTimer = self.gearChangeTimer - dt 
		end 			
		if self.gearChangeTimer > 0 then 
			self.vcaFakeRpm     = vehicleControlAddon.mbClamp( math.max( self.minRpm, motorPtoRpm ), 
																												lastFakeRpm - 0.0005 * dt * rpmRange,
																												lastFakeRpm + 0.001  * dt * rpmRange )		
			self.vcaFakeTimer   = 100 
			newAcc              = 0
		end 
		
		if autoNeutral then 
			return 0
		end 
		return newAcc

	elseif transmission ~= nil then 
--****************************************************************************************	
-- 4x4 / 4x4 PS / 2x6 / FPS 
--****************************************************************************************	
	
		local initGear = transmission:initGears() 
				
		if     self.vcaClutchTimer == nil 
				or self.vcaAutoStop    == nil then 
			autoNeutral      = true 
			self.vcaAutoStop = true			
		elseif curAcc > 0.1 and not self.vehicle:vcaGetNeutral() then  
			autoNeutral = false 
			self.vcaAutoStop = false 
		elseif self.vehicle.vcaClutchPercent >= 1 and not self.vehicle.vcaNeutral then 
			self.vcaAutoStop = false 
		elseif self.vehicle:vcaGetNeutral() and speed < 1 then 
			self.vcaAutoStop = true
		elseif lastFwd ~= fwd or self.vcaDirTimer ~= nil then 
		-- no change 
		elseif  curBrake > 0.1
				and not self.vcaAutoStop
				and ( wheelRpm < 0.9 * self.minRpm or speed < 2 )
				and ( self.vehicle:vcaGetAutoClutch() or self.vehicle:vcaGetAutoShift() or self.vehicle.vcaClutchPercent > 0.8 ) 
				then 
			autoNeutral = true 
			if lastAutoStopTimer == nil then 
				self.vcaAutoStopTimer = 1000
			elseif lastAutoStopTimer > 0 then 
				self.vcaAutoStopTimer = lastAutoStopTimer - dt 
			else 
				self.vcaAutoStop = true 
			end 
		end 
		
		if self.gearChangeTimer == nil then 
			self.gearChangeTimer = 200
		elseif self.gearChangeTimer > 0 then 
			self.gearChangeTimer = self.gearChangeTimer - dt 
		end
		if self.vcaClutchTimer == nil  then 
			self.vcaClutchTimer = VCAGlobals.clutchTimer
		elseif self.vcaClutchTimer > 0 then 
			local f = VCAGlobals.clutchTimer / VCAGlobals.clutchTimerIdle
			if     curAcc >= 0.9 then 
				f = 1
			elseif curAcc >  0.1 then 
				local a = curAcc 
				if lastIdleAcc ~= nil and lastIdleAcc > a then 
					a = lastIdleAcc 
				end 				
				f = f + a * ( 1 - f ) 
			end 
			self.vcaClutchTimer   = self.vcaClutchTimer - f * dt
		end 
		if autoNeutral then 
			self.vcaAutoDownTimer = 0
			self.vcaAutoUpTimer   = VCAGlobals.clutchTimer
		end 
						
		local gear  = transmission:getRatioIndex( self.vehicle.vcaGear, self.vehicle.vcaRange )		
		local ratio = transmission:getGearRatio( gear )
		if ratio == nil then 
			print("Error in vehicleControlAddonTransmission: ratio is nil")
			gear  = 1	
			ratio = 0.3
		end 
		local maxSpeed  = ratio * self.vehicle.vcaMaxSpeed 
		
		self.vehicle.vcaDebugR = string.format("g: %2d, r: %5.3f, s: %5.1f, m: %4.0f, w: %4.0f, c: %4.0f",
																	gear, ratio, maxSpeed*3.6,
																	self.lastRealMotorRpm, self.vcaLastRpmW, self.vcaLastRpmC )
		
		
		--****************************************
		if self.gearChangeTimer > 0 then 
			self.vcaAutoShiftLoad = lastAutoShiftLoad
		else 
			local curLoad = 0
			if math.abs( newAcc ) < 1e-3 then 
				curLoad = self.motorExternalTorque 
			else 
				curLoad = self.motorAppliedTorque
			end 
			curLoad = 1.07 * curLoad * self.motorRotSpeed
			
			if     curLoad <= 0 then 
				curLoad = 0
			elseif curLoad >= self.peakMotorPower then 
				curLoad = 1 
			else
				curLoad = curLoad / self.peakMotorPower
				if self.motorExternalTorque > 0.99 * self.motorAvailableTorque then 
					curLoad = math.max( math.abs( newAcc ), curLoad )
				end 
			end 
			if curBrake >= 0.5 and speed > 10 and curLoad < 0.75 then 
			-- simulate high load for immediate down shift
				curLoad = 0.75
			end 
			
			if curLoad > lastAutoShiftLoad then 
				self.vcaAutoShiftLoad = lastAutoShiftLoad + 0.05  * ( curLoad - lastAutoShiftLoad ) 
			else 
				self.vcaAutoShiftLoad = lastAutoShiftLoad + 0.015 * ( curLoad - lastAutoShiftLoad ) 
			end 
		end 
		
		-- no automatic shifting during gear shift or if clutch is open
		if self.vcaAutoDownTimer == nil then 
			self.vcaAutoDownTimer = 0
		elseif self.vcaAutoDownTimer > 0 then 
			self.vcaAutoDownTimer = self.vcaAutoDownTimer - dt 
		end 		
		if self.vcaAutoUpTimer == nil then 
			self.vcaAutoUpTimer = VCAGlobals.clutchTimer
		elseif self.vcaAutoUpTimer > 0 then 
			self.vcaAutoUpTimer = self.vcaAutoUpTimer - dt 
		end 
		if self.vcaAutoLowTimer == nil then 
			self.vcaAutoLowTimer = 5000
		elseif self.vcaAutoLowTimer > 0 then 
			self.vcaAutoLowTimer = self.vcaAutoLowTimer - dt 
		end 
		if self.vcaNoShiftTimer == nil or self.gearChangeTimer > 0 then 
			self.vcaNoShiftTimer = 1000 
		elseif self.vcaNoShiftTimer > 0 and self.vcaClutchTimer <= 0 then 
			self.vcaNoShiftTimer = self.vcaNoShiftTimer - dt 
		end 
		if self.gearChangeTimer > 0 and self.vcaAutoDownTimer < 1000 then 
			self.vcaAutoDownTimer = 1000 
		end 
		
		if     self.vcaAutoStop then 
			self.vcaBrakeTimer = nil
		elseif curBrake >= 0.1 then 
			if self.vcaBrakeTimer == nil then  
				self.vcaBrakeTimer = 0
			else 
				self.vcaBrakeTimer = self.vcaBrakeTimer + dt
			end 
		elseif self.vcaBrakeTimer ~= nil then 
			self.vcaBrakeTimer = self.vcaBrakeTimer - dt
			if self.vcaBrakeTimer < 0 then 
				self.vcaBrakeTimer = nil
			end 
		end 

			-- no automatic shifting#
		if self.vcaClutchTimer > 0 and self.vcaAutoUpTimer < 1000 then 
			self.vcaAutoUpTimer = 1000 
		end 
		if self.gearChangeTimer > 0 and self.vcaAutoUpTimer < 1000 then 
			self.vcaAutoUpTimer = 1000 
		end 
		if curBrake >= 0.1 and self.vcaBrakeTimer ~= nil and self.vcaBrakeTimer > 500 then 
			self.vcaAutoDownTimer = 0
		end 
		if motorPtoRpm < self.minRpm and curAcc < 0.1 and curBrake < 0.1 and self.vcaAutoDownTimer < 3000 then  
			self.vcaAutoDownTimer = 3000 
		end 
		if self.gearChangeTimer > 0 and self.vcaAutoDownTimer < 1000 then 
			self.vcaAutoDownTimer = 1000 
		end 
		if self.vcaAccS < 0.1 and self.vcaAutoUpTimer < 1000 then 
			self.vcaAutoUpTimer = 1000 
		end 
		if motorPtoRpm < self.minRpm and self.vcaAutoShiftLoad < 0.8 then 
			self.vcaAutoLowTimer = 5000 
		end 
		if curAcc < 0.1 and self.vcaAutoLowTimer < 2000 then 
			self.vcaAutoLowTimer = 2000
		end 
	--if maxSpeed > 0.41667 * self:getSpeedLimit() and self.vcaAutoDownTimer > 1000 then -- 0.41667 = 1.5 / 3.6
	--	self.vcaAutoDownTimer = 1000
	--end 
		
		local setLaunchGear = ( initGear or lastFwd ~= fwd or self.vcaAutoStop )
		local newGear    = gear 
		local launchGear = self.vehicle.vcaLaunchGear 
		if     self.vehicle:vcaIsVehicleControlledByPlayer()
		-- AutoDrive
				or ( self.vehicle.ad ~= nil and self.vehicle.ad.isActive  ) 
		-- Courseplay
				or ( self.vehicle.cp ~= nil and self.vehicle.cp.isDriving ) then 
			self.vcaAILaunchGear = nil 
		elseif self.vcaAILaunchGear == nil then 
			launchGear = nil 
			delta      = math.huge 
			for i=1,self.vehicle.vcaLaunchGear do 
				local r = transmission:getGearRatio(i)
				if r ~= nil then 
					local d = math.abs( 3.6 * r * self.vehicle.vcaMaxSpeed - 10 )
					if launchGear == nil or d < delta then 
						launchGear = i 
						delta      = d
					end 
				end 
			end 
		--print("AI launch gear: "..tostring(launchGear).." ("..tostring(delta)..")")
			if launchGear == nil then 
				launchGear = self.vehicle.vcaLaunchGear 
			end 
			
			self.vcaAILaunchGear = launchGear 
		else 
			launchGear = self.vcaAILaunchGear 
		end 
		
		if initGear then 
			newGear = launchGear
		elseif  self.vehicle:vcaGetAutoShift() 
				and setLaunchGear then 
			if      self.vcaSetLaunchGear then 
				if self.vcaAutoStop and gear ~= launchGear then 
					self.vehicle:vcaSetState("vcaLaunchGear",gear)
				end 
			elseif  gear > launchGear
					and not self.vehicle.vcaShifterUsed then 
				local gearlist = transmission:getAutoShiftIndeces( gear, launchGear, true, false )
				if #gearlist > 0 then
					newGear = gearlist[1]
				end 
			end 
		elseif self.vehicle:vcaGetAutoShift() and self.gearChangeTimer <= 0 and not self.vehicle:vcaGetNeutral() and not self.vehicle.vcaShifterUsed then
			local m1 = self.minRpm * 1.1
			local m4 = math.min( math.max( self.vehicle.vcaRatedRpm, motorPtoRpm ), 
													 self.vcaMaxPowerRpmH - self.maxRpm * 0.1 * math.max( 0, self.vcaAccS ),
													 0.975 * self.maxRpm )
			if motorPtoRpm <= 0 and curBrake < 0.1 and curAcc > 0.1 and curAcc < 0.8 and self.gearChangeTimer <= 0 then 
				m4 = math.max( m1, math.min( m4, self.minRpm + curAcc * rpmRange * 0.975 ) )
			end 
			local m2 = vehicleControlAddon.mbClamp( self.vcaMaxPowerRpmL, m1, m4 )
			local m3 = math.max( m1, m4 * 0.72 )
			local autoMinRpm = m1 + self.vcaAutoShiftLoad * ( m2 - m1 )
			local autoMaxRpm = m3 + self.vcaAutoShiftLoad * ( m4 - m3 )
			if self.vehicle.vcaHandthrottle > 0 then 
				autoMaxRom = math.min( m4, idleRpm * 1.025 )
				autoMinRpm = math.min( m4, idleRpm * 0.975 )
			elseif motorPtoRpm > 0 then 
				if -1 < self.vehicle.vcaHandthrottle and self.vehicle.vcaHandthrottle < -0.8 then 
				-- 90% PTO 
					autoMaxRom = math.min( m4, motorPtoRpm * 1.025 )
					autoMinRpm = math.min( m4, idleRpm * 0.975 )
				elseif self.vehicle.vcaHandthrottle < 0 then 
				-- PTO ECO
					autoMaxRom = math.min( m4, idleRpm * 1.025 )
					autoMinRpm = math.min( m4, idleRpm * 0.975 )
				elseif motorPtoRpm > 0 then 
					autoMaxRom = math.min( m4, motorPtoRpm * 1.025 )
					autoMinRpm = math.min( m4, motorPtoRpm * 0.975 )
				end 
			end 
			
			if     self.vcaLastRpmW > m4 and self.vcaAutoUpTimer > 250 then 
				self.vcaAutoUpTimer = 250
			elseif self.vcaLastRpmW < autoMinRpm and self.vcaAutoUpTimer < 1000 then 
				self.vcaAutoUpTimer = 1000
			elseif self.vcaLastRpmW < autoMaxRpm and self.vcaAutoUpTimer < 250 then 
				self.vcaAutoUpTimer = 250
			end 
			if self.vcaClutchTimer <= 0 and self.vcaLastRpmW < m1 and gear > launchGear and self.vcaAutoDownTimer > 250 then 
				self.vcaAutoDownTimer = 250
			end 
			
			local lowGear = launchGear 
			if self.vcaAutoLowTimer <= 0 and self.vcaAutoShiftLoad > 0.8 then 
				lowGear = math.floor( lowGear * ( 1 - self.vcaAutoShiftLoad ) )
			end 
			
			local searchUp   = ( self.vcaLastRpmC > autoMaxRpm and self.vcaAutoUpTimer   <= 0 and self.vcaNoShiftTimer <= 0 )
			local searchDown = ( self.vcaLastRpmW  < autoMinRpm and self.vcaAutoDownTimer <= 0 and self.vcaNoShiftTimer <= 0 )

			if self.vcaAutoStop or curBrake > 0.1 then
				searchUp   = false 
				lowGear    = launchGear
			end 
			
			local gearlist = transmission:getAutoShiftIndeces( gear, lowGear, searchDown, searchUp )
			
			if #gearlist > 0 then 
				local d = 0
				if self.vcaLastRpmW < autoMinRpm then 
					d = autoMinRpm - self.vcaLastRpmW
				end 
				if self.vcaLastRpmC > autoMaxRpm then 
					d = math.max( d, self.vcaLastRpmC - autoMaxRpm )
				end 
				d = d - 1
				local d1 = d
				local rr = self.vcaLastRpmW
				for _,i in pairs( gearlist ) do 
					local nr = transmission:getGearRatio( i )
					local rpm = self.vcaLastRpmW * ratio / nr
					local d2 = 0
					if rpm < autoMinRpm then 
						d2 = autoMinRpm - rpm
					end 
					rpm = self.vcaLastRpmC * ratio / nr
					if rpm > autoMaxRpm then 
						d2 = math.max( d2, rpm - autoMaxRpm )
					end 
					if d2 < d or ( d2 == d and searchUp ) then 
						newGear = i 
						d = d2
						rr = rpm
					end 
				end 
				
				self.vehicle.vcaDebugA = string.format( "%3.0f%%; %3.0f%%; %4.0f..%4.0f; %4.0f -> %4.0f; %d -> %d; %5.0f -> %5.0f",
																								curAcc*100,self.vcaAutoShiftLoad*100,autoMinRpm,autoMaxRpm,self.vcaLastRpmW, rr,gear,newGear,d1,d )
			else 
				self.vehicle.vcaDebugA = string.format( "%3.0f%%; %3.0f%%; %4.0f..%4.0f; %4.0f no gear",
																								curAcc*100,self.vcaAutoShiftLoad*100,autoMinRpm,autoMaxRpm,self.vcaLastRpmW)
			end 
		end

		self.vcaSetLaunchGear = setLaunchGear
		
		if gear ~= newGear then 
			if self.vehicle.vcaDebugA ~= nil then 
				vehicleControlAddon.debugPrint( g_currentMission.time.."; "..self.vehicle.vcaDebugA )
			end 
			
			local g, r = transmission:getBestGearRangeFromIndex( self.vehicle.vcaGear, self.vehicle.vcaRange, newGear )
			self.vehicle:vcaSetState( "vcaGear",  g )
			self.vehicle:vcaSetState( "vcaRange", r )
			
			gear     = transmission:getRatioIndex( g, r ) 
			ratio    = transmission:getGearRatio( gear )
			maxSpeed = ratio * self.vehicle.vcaMaxSpeed 
			wheelRpm = self.vehicle.lastSpeedReal * 1000 * self.maxRpm / maxSpeed 
		end 
		
		self.vehicle:vcaSetState("vcaBOVVolume",0)
		if not autoNeutral then 
			local gearTime  = transmission:getChangeTimeGears()
			local rangeTime = transmission:getChangeTimeRanges()
			if not self.vehicle:vcaIsVehicleControlledByPlayer() then 
				gearTime, rangeTime = -1, -1  
			end 
			if gearTime < 1 then	
				gearTime = -1 
			end 
			if rangeTime < 1 then 
				rangeTime = -1
			end 
			
			if self.vcaLastRange ~= nil and self.vehicle.vcaRange ~= self.vcaLastRange and self.gearChangeTimer < rangeTime then 
				self.gearChangeTimer = rangeTime
				if self.vcaGearIndex ~= nil and self.vcaGearIndex < gear and rangeTime > 0 then 
					self.vehicle:vcaSetState("vcaBOVVolume",self.vehicle.vcaActualLoadS)
				end 
			end 
			if self.vcaLastGear ~= nil and self.vehicle.vcaGear ~= self.vcaLastGear and self.gearChangeTimer < gearTime then 
				self.gearChangeTimer = gearTime
				if self.vcaGearIndex ~= nil and self.vcaGearIndex < gear and gearTime > 0 then 
					self.vehicle:vcaSetState("vcaBOVVolume",self.vehicle.vcaActualLoadS)
				end 
			end 
		end 
		
		local minRequiredRpm = math.max( self.minRpm, motorPtoRpm )
						
		if self.vcaGearIndex ~= nil and self.vcaGearIndex ~= gear then 
			if gear > self.vcaGearIndex then 
				self.vcaAutoUpTimer	  = math.max( self.vcaAutoUpTimer	 , 2000 + self.gearChangeTimer * 2 )
				self.vcaAutoDownTimer = math.max( self.vcaAutoDownTimer, 4000 + self.gearChangeTimer )
			else                                    
				self.vcaAutoUpTimer	  = math.max( self.vcaAutoUpTimer	 , 4000 + self.gearChangeTimer * 2 )
				self.vcaAutoDownTimer = math.max( self.vcaAutoDownTimer, 2000 + self.gearChangeTimer )
			end
			self.vcaNoShiftTimer = 1000 
		elseif motorRpm < 0.8 * self.minRpm and not self.vcaAutoStop and self.vcaFakeRpm == nil then 
			if curBrake > 0.1 or self.vehicle.vcaTurboClutch then   
				self.vcaClutchTimer = self.vcaClutchTimer
			else 
				if lastStallTimer == nil then 
					self.vcaStallTimer = dt
				else
					self.vcaStallTimer = lastStallTimer + dt
				end 
				if ( lastStallTimer == nil or lastStallTimer < 500 ) and self.vcaStallTimer >= 500 then 
					self.vehicle:vcaSetState( "vcaWarningText", string.format( "RPM too low: %4.0f < %4.0f", motorRpm, self.minRpm ) )
				end 
				if self.vcaStallTimer > 3000 and motorRpm < 0.5 * self.minRpm then 
					self.vehicle.vcaForceStopMotor = 2000
				end 
			end 
		elseif wheelRpm < minRequiredRpm and ( curBrake > 0.1 or self.vehicle.vcaTurboClutch ) then 
			self.vcaClutchTimer = math.min( self.vcaClutchTimer + dt + dt, VCAGlobals.clutchTimer )
		end 
		
		self.vehicle.vcaDebugM = string.format("%5.0f, %5.0f, %5.0f, %3.0f%%, %s, %5.0f", motorRpm, wheelRpm, minRequiredRpm, newAcc*100, tostring(self.vcaAutoStop), self.vcaClutchTimer )
		
		self.vcaGearIndex = gear
		self.vcaLastGear  = self.vehicle.vcaGear
		self.vcaLastRange = self.vehicle.vcaRange
		
		self.minGearRatio = self.maxRpm / ( maxSpeed * vehicleControlAddon.factor30pi )
		self.maxGearRatio = self.minGearRatio 
		
		-- *******************************************
		-- clutch
		local clutchFactor = 0 
		if self.vehicle:vcaGetAutoClutch() then 
			if self.vehicle.vcaClutchPercent > 0 then 
				self.vcaClutchTimer = math.max( self.vcaClutchTimer, self.vehicle.vcaClutchPercent * VCAGlobals.clutchTimer )
			end 
			clutchFactor = math.max( self.vcaClutchTimer / VCAGlobals.clutchTimer, 0 )
			if curGearRatio <= self.minGearRatio then 
				self.vehicle.vcaClutchDisp = 0
			else 
				self.vehicle.vcaClutchDisp = math.min( 1 - self.minGearRatio / curGearRatio, self.vcaClutchTimer / VCAGlobals.clutchTimer )
			end 
		else 
			self.vcaClutchTimer          = 0
			clutchFactor                 = self.vehicle.vcaClutchPercent
			self.vehicle.vcaClutchDisp   = self.vehicle.vcaClutchPercent
		end 
		
		self.vehicle.vcaDebugK = string.format( "%5.0f > 0 and %5.0f > %5.0f and %5.0f <= 0 and %4.0f < %4.0f = %s",
																						self.vcaClutchTimer,
																						wheelRpm,
																						self.minRpm,
																						self.gearChangeTimer,
																						curGearRatio,
																						1.1 * self.minGearRatio,
																						tostring( self.vcaClutchTimer > 0 and wheelRpm > self.minRpm and self.gearChangeTimer <= 0 and curGearRatio < 1.1 * self.minGearRatio ) )

		if self.vehicle:vcaGetNeutral() then 
			self.vcaClutchTimer = VCAGlobals.clutchTimer 
		end 

		if autoNeutral or self.gearChangeTimer > 0 or clutchFactor >= 1 then 
		  -- neutral or no gear
			if self.gearChangeTimer > 0 and not autoNeutral then 
				self.vcaFakeRpm   = vehicleControlAddon.mbClamp( math.max( self.minRpm, 0.9 * motorPtoRpm ), 
																												lastFakeRpm - 0.0004 * dt * rpmRange,
													 															lastFakeRpm + 0.001  * dt * rpmRange )		
				self.vcaFakeTimer = 100 
			elseif self.vcaFakeRpm == nil then 
				self.vcaFakeRpm   = vehicleControlAddon.mbClamp( fakeRpm, lastFakeRpm - 0.0005 * dt * rpmRange, lastFakeRpm + 0.001 * dt * rpmRange )			
				self.vcaFakeTimer = 100 
			end

			newAcc = 0
			
			self.vcaClutchTimer = VCAGlobals.clutchTimer
			self.vcaMinRpm      = self.vcaFakeRpm
			self.vcaMaxRpm      = self.vcaFakeRpm
			self.minGearRatio   = 1
			self.maxGearRatio   = 1000000
			self.vehicle.vcaClutchDisp = 1
		else

			local clutchCloseRpm = math.max( self.minRpm, 0.9 * motorPtoRpm, math.min( 1.1 * motorPtoRpm, fakeRpm ) )
			if self.vehicle.vcaTurboClutch then 
				clutchCloseRpm = math.max( clutchCloseRpm, 0.6 * self.maxRpm ) 
			end 
			clutchCloseRpm = math.min( fakeRpm, clutchCloseRpm )
			
			if      self.vcaClutchTimer   > 0
					and self.vcaFakeRpm      == nil
					and curGearRatio          < 1.2 * self.minGearRatio
					and wheelRpm             >= self.minRpm then 
				self.vcaClutchTimer = 0
			end 
		
			if     clutchFactor > 0 then 
				local r = fakeRpm
				if self.vcaFakeRpm ~= nil then 
					f = self.vcaFakeRpm
				end 
				if self.vehicle:vcaGetAutoClutch() then 
					r = math.min( r, clutchCloseRpm )
				end 
				self.vcaClutchRpm   = vehicleControlAddon.mbClamp( ( 1 - clutchFactor ) * vehicleControlAddon.mbClamp( wheelRpm, self.minRpm, self.maxRpm ) + clutchFactor * r, 
																													 lastFakeRpm - 0.001 * dt * rpmRange, lastFakeRpm + 0.001 * dt * rpmRange )
				-- open the RPM range as maxGearRatio decreases																									
				self.vcaMinRpm      = clutchFactor * self.vcaClutchRpm
				self.vcaMaxRpm      = self.maxRpm + clutchFactor * ( self.vcaClutchRpm - self.maxRpm )
				self.maxGearRatio   = math.max( self.minGearRatio, math.min( 100000, self.minGearRatio / math.max( 1 - clutchFactor, 0.00001 ) ) )
				
				-- emergency mode
				if clutchFactor > 0.5 and motorRpm < 0.8 * self.minRpm then 
					self.vcaFakeRpm   = vehicleControlAddon.mbClamp( 0.8 * self.minRpm,  
																													 lastFakeRpm - 0.0004 * dt * rpmRange,
																													 lastFakeRpm + 0.001  * dt * rpmRange )		
					if self.vcaFakeTimer == nil or self.vcaFakeTimer < 100 then 
						self.vcaFakeTimer = 100 
					end 
				end 
			else
				self.vcaMinRpm      = 0
				self.vcaMaxRpm      = self.maxRpm
			end  
			
			-- *******************************************
			-- idle acceleration
			local fullRpm = idleRpm - 0.15 * self.minRpm
			local zeroRpm = math.min( idleRpm + 0.05 * self.minRpm, self.maxRpm )
			local idleAcc = 0
			
			local smoothF = 0.1414
			local deltaR  = math.abs( motorRpm - idleRpm )
			
			if     3 * deltaR >= 0.4472 * self.minRpm then 
				smoothF = 0.4472
			elseif 3 * deltaR > smoothF * self.minRpm  then 
				smoothF = 3 * deltaR / self.minRpm 
			end 
			smoothF = smoothF * smoothF 
			
			if     motorRpm >= zeroRpm then 
				idleAcc = 0
			elseif motorRpm <= fullRpm then 
				idleAcc = 1 
			else 
				idleAcc = ( zeroRpm - motorRpm ) / ( zeroRpm - fullRpm ) 
			end 
			
			if lastIdleAcc == nil or smoothF >= 1 then 
				self.vcaIdleAcc = idleAcc
			else 
				self.vcaIdleAcc = lastIdleAcc + smoothF * ( idleAcc - lastIdleAcc )
			end 
						
			if curBrake <= 0 and self.vcaIdleAcc > curAcc then 
				newAcc = self.vcaIdleAcc
				if  not fwd then 
					newAcc = -newAcc
				end 
			elseif motorRpm > fakeRpm + 0.05 * self.maxRpm then 
				newAcc = 0
			end 	
	
			if self.vehicle.vcaHandthrottle == 0 and not self.vehicle:vcaGetAutoShift() and motorPtoRpm >= self.minRpm then 
				self.vcaMaxRpm = math.min( motorPtoRpm * 1.11, self.vcaMaxRpm )
			end 		
		end 		
		
		if not fwd then 
			self.minGearRatio = -self.minGearRatio
			self.maxGearRatio = -self.maxGearRatio
		end 
		
		if autoNeutral then 
			return 0
		end 
		return newAcc
	end 
	
--****************************************
-- standard / IVT
	if      self.minForwardGearRatio  ~= nil 
			and self.maxForwardGearRatio  ~= nil 
			and self.minBackwardGearRatio ~= nil 
			and self.maxBackwardGearRatio ~= nil then 
		if fwd then 
			self.minGearRatio = self.minForwardGearRatio
			self.maxGearRatio = self.maxForwardGearRatio
		else 
			self.minGearRatio = -self.minBackwardGearRatio
			self.maxGearRatio = -self.maxBackwardGearRatio
		end 
	end 
	
	if autoNeutral then 
		return 0
	end 
	return newAcc
end 

VehicleMotor.updateGear = Utils.overwrittenFunction( VehicleMotor.updateGear, vehicleControlAddon.vcaUpdateGear )

function vehicleControlAddon:vcaGetMaxClutchTorque( superFunc, ... )
	if not ( self.vehicle ~= nil and self.vehicle.vcaIsLoaded ) then 
		return superFunc( self, ... )
	end 
	if not ( self.vehicle.vcaIsLoaded and self.vehicle:vcaGetTransmissionActive() ) then 
		return superFunc( self, ... )
	end 
	if self.vehicle:vcaGetNeutral() or self.gearChangeTimer > 0 or self.vehicle.vcaClutchDisp >= 1 then 
		return 0
	end 
	
	local c = 1
	if self.vehicle:vcaGetNoIVT() then 
		c = 1 - self.vehicle.vcaClutchDisp
		if 0 < c and c < 0.1 then 
			-- let the engine rev up first
			local t = Utils.getNoNil( self.vcaClutchRpm, 1.11 * self.minRpm )
			local r = self.motorRotSpeed * vehicleControlAddon.factor30pi
			if ( c < 0.05 and r < 0.9 * t ) or ( c < 0.1 and r < self.minRpm ) then 
				c = 0
			end 
		end 
	end 
	
	return math.min( self:getPeakTorque() * 0.75 * ( 1 - math.cos( math.pi * c ) ), superFunc( self, ... ) )
end 

VehicleMotor.getMaxClutchTorque = Utils.overwrittenFunction( VehicleMotor.getMaxClutchTorque, vehicleControlAddon.vcaGetMaxClutchTorque )

function vehicleControlAddon:vcaGetCanMotorRun( superFunc, ... )
	if self.vcaForceStopMotor ~= nil and self.vcaForceStopMotor > 0 then 
		return false 
	end 
	return superFunc( self, ... )
end

Motorized.getCanMotorRun = Utils.overwrittenFunction( Motorized.getCanMotorRun, vehicleControlAddon.vcaGetCanMotorRun )

function vehicleControlAddon:vcaUpdateMotorProperties( superFunc, ... )
	if self.vcaLastTransmission ~= nil then 
		local motor = self.spec_motorized.motor
		local numKeyFrames = #motor.torqueCurve.keyframes
		if numKeyFrames < 1 then 
			motor.vcaMaxPowerRpmL = self.minRpm 
			motor.vcaMaxPowerRpmH = self.maxRpm 
		else
			local listL, listH
			for i=1,numKeyFrames do		
				local v = motor.torqueCurve.keyframes[i]
				local rotSpeed = v.time*math.pi/30
				local torque = motor.torqueCurve:getFromKeyframes(v, v, i, i, 0)
				local p = rotSpeed*torque
				
				if i == 1 then 
					listL = { { r = v.time, p = p } }
					listH = { { r = v.time, p = p } }
				elseif p < listH[1].p then 
					table.insert( listH, { r = v.time, p = p } )
				else
					if p > listH[1].p then  
						table.insert( listL, { r = v.time, p = p } )
					end 
					if #listH == 1 then 
						listH[1].r = v.time 
						listH[1].p = p 
					else 
						listH = { { r = v.time, p = p } }
					end 
				end 
			end 
			
			numKeyFrames = #listL
			motor.vcaMaxPowerRpmL = listL[numKeyFrames].r
			if numKeyFrames > 1 then 
				local i = numKeyFrames - 1 
				local p = 0.97 * listL[numKeyFrames].p
				while i > 1 and listL[i].p > p do 
					i = i - 1
				end 
				if listL[i].p < p then 
					motor.vcaMaxPowerRpmL = listL[i].r + ( p - listL[i].p ) * ( listL[numKeyFrames].r - listL[i].r ) / ( listL[numKeyFrames].p - listL[i].p )
				else 
					motor.vcaMaxPowerRpmL = listL[i].r
				end 
			end 
			
			numKeyFrames = #listH
			motor.vcaMaxPowerRpmH = listH[1].r
			if numKeyFrames > 1 then 
				local i = 2 
				local p = 0.97 * listH[1].p
				while i < numKeyFrames and listH[i].p > p do 
					i = i + 1
				end 
				if listH[i].p < p then 
					motor.vcaMaxPowerRpmH = listH[i].r + ( p - listH[i].p ) * ( listH[1].r - listH[i].r ) / ( listH[1].p - listH[i].p )
				else 
					motor.vcaMaxPowerRpmH = listH[i].r
				end 
			end 
		end 
	end 

	if self.vcaLastTransmission ~= nil and self.vcaGearbox ~= nil then 
		local motor = self.spec_motorized.motor
		motor.vcaMinRpm = motor.minRpm
		motor.vcaMaxRpm = motor.maxRpm

		motor.minRpm = 0
	--motor.maxRpm = motor.vcaMaxRpm * 1.1

		local state, result = pcall( superFunc, self, ... ) 
		if not ( state ) then
			print("Error in updateMotorProperties :"..tostring(result))
			self.vcaTransmission    = 0 
			self.vehicle.vcaGearbox = nil
		end
		
		motor.minRpm = motor.vcaMinRpm
		motor.maxRpm = motor.vcaMaxRpm
	else 
		superFunc( self, ... )
	end 
end 

Motorized.updateMotorProperties = Utils.overwrittenFunction( Motorized.updateMotorProperties, vehicleControlAddon.vcaUpdateMotorProperties )
--******************************************************************************************************************************************

function vehicleControlAddon:vcaGetEqualizedMotorRpm( superFunc ) 		
	if self.vehicle.isServer then 
		local r = superFunc( self )
		if self.vcaFakeRpm ~= nil then 
			r = self.vcaFakeRpm
		elseif self.vehicle.vcaGearbox ~= nil then 
			r = self.motorRotSpeed * vehicleControlAddon.factor30pi
		end 
		return vehicleControlAddon.mbClamp( r, self.minRpm, self.maxRpm )
	end 
	return superFunc( self )
end 

VehicleMotor.getEqualizedMotorRpm = Utils.overwrittenFunction( VehicleMotor.getEqualizedMotorRpm, vehicleControlAddon.vcaGetEqualizedMotorRpm )
--******************************************************************************************************************************************

function vehicleControlAddon:vcaGetMotorAppliedTorque( superFunc ) 
	if self.vehicle.vcaGearbox ~= nil and self.vehicle:vcaGetNoIVT() and self.gearChangeTimer > 0 then 
		return 0
	end 
	return superFunc( self )
end 

VehicleMotor.getMotorAppliedTorque = Utils.overwrittenFunction( VehicleMotor.getMotorAppliedTorque, vehicleControlAddon.vcaGetMotorAppliedTorque )
--******************************************************************************************************************************************

function vehicleControlAddon:vcaMotorGetRotInertia( superFunc ) 
	local r = superFunc( self )
	
	if      type( r ) == "number" 
			and VCAGlobals.rotInertiaFactor   > 0 
			and VCAGlobals.rotInertiaFactor  ~= 1
			and self.vehicle                 ~= nil
			and self.vehicle.vcaIsLoaded 
			and self.vehicle:vcaGetTransmissionActive()
			and self.vehicle:getIsMotorStarted()
			and self.vehicle:vcaIsVehicleControlledByPlayer()
			then 
		if     self.gearChangeTimer > 0
				or self.vehicle.vcaNeutral
				or self.vcaAutoStop then 
			return 0.5 * r 
		end 
		local f = VCAGlobals.rotInertiaFactor
		if f > 0.5 and self.vehicle:vcaGetNoIVT() and self.vehicle.vcaClutchDisp > 0 then 
			f = 0.5 + ( 1 - self.vehicle.vcaClutchDisp ) * ( f - 0.5 )  
		end 
		return math.max( r, math.min( f * r, self.peakMotorTorque * 0.01 ) ) 
	end 
	return r
end 
VehicleMotor.getRotInertia = Utils.overwrittenFunction( VehicleMotor.getRotInertia, vehicleControlAddon.vcaMotorGetRotInertia )
--******************************************************************************************************************************************

function vehicleControlAddon:vcaOnSetFactor( old, new, noEventSend )
	self.vcaExponent = new
	self.vcaFactor   = 1.1 ^ new
end

function vehicleControlAddon:onSetShuttleControl( old, new, noEventSend )
	self.vcaShuttleCtrl = new 
	self:requestActionEventUpdate()
end 

function vehicleControlAddon:onSetTransmission( old, new, noEventSend )
	self.vcaTransmission = new 
	self:requestActionEventUpdate()
end 

function vehicleControlAddon:vcaOnSetSnapAngle( old, new, noEventSend )
	if new < 1 then 
		self.vcaSnapAngle = 1 
	elseif new > table.getn( vehicleControlAddon.snapAngles ) then 
		self.vcaSnapAngle = table.getn( vehicleControlAddon.snapAngles ) 
	else 
		self.vcaSnapAngle = new 
	end 
end 

function vehicleControlAddon:vcaOnSetSnapIsOn( old, new, noEventSend )
	self.vcaSnapIsOn = new 
	
  if      ( old == nil or new ~= old ) then 
		if self.isClient and self:vcaIsActive() then
			if new and vehicleControlAddon.snapOnSample ~= nil then
				playSample(vehicleControlAddon.snapOnSample, 1, 0.2, 0, 0, 0)
			elseif not new and vehicleControlAddon.snapOffSample ~= nil then
				playSample(vehicleControlAddon.snapOffSample, 1, 0.2, 0, 0, 0)
			end 
		end 
		
	--print("Turning off snap angle (server:"..tostring(self.isServer).."/client:"..tostring(self.isClient)..")")
	--print("old: "..tostring(old).." => new: "..tostring(new))
	--printCallstack()
	end 
end 

function vehicleControlAddon:vcaOnSetKSIsOn( old, new, noEventSend )
	self.vcaKSIsOn = new 
	
--if      ( old == nil or new ~= old ) then 
--	printCallstack()
--end 
end 

function vehicleControlAddon:vcaOnSetLastSnapAngle( old, new, noEventSend )
	self.vcaLastSnapAngle = new 
	
--if      ( old == nil or new ~= old ) then 
--	print("vcaOnSetLastSnapAngle: "..tostring(new))
--	printCallstack()
--end 
end 

function vehicleControlAddon:vcaOnSetDirection( old, new, noEventSend )
	if self.vcaShuttleCtrl then 
		self.vcaShuttleFwd = new 
		if self.vcaKSIsOn then 
			local sign = 1
			if not self.vcaShuttleFwd then 
				sign = -1 
			end 
			self:vcaSetState( "vcaKeepSpeed", sign * math.abs( self.vcaKeepSpeed ), noEventSend )
		end 
	end 
end 

function vehicleControlAddon:vcaOnSetNeutral( old, new, noEventSend )
	self.vcaNeutral = new 
	if self.isServer and self.vcaIsLoaded and self:vcaGetTransmissionActive() and not ( new ) and old and self.getMotor ~= nil then 
		motor = self:getMotor() 
		if motor ~= nil then 
			motor.vcaAutoStop = false 
		end 
	end 
end 

function vehicleControlAddon:vcaOnSetGearChanged( old, new, noEventSend )
	if      ( old == nil or new > old )
			and self.isClient
			and self:vcaIsActive()
			and vehicleControlAddon.bovSample ~= nil then 
		local v = 0.2 * new 
		if isSamplePlaying( vehicleControlAddon.bovSample ) then
			setSampleVolume( vehicleControlAddon.bovSample, v )
		else 
			playSample( vehicleControlAddon.bovSample, 1, v, 0, 0, 0)
		end 
	end 
	self.vcaBOVVolume = new 
end 

function vehicleControlAddon:vcaOnSetAutoShift( old, new, noEventSend )
	self.vcaAutoShift = new 
	
	if old and not ( new ) then 
		printCallstack()
	end 
end 

function vehicleControlAddon:vcaOnSetGear( old, new, noEventSend )
	print("vcaOnSetGear: "..string(old).."->"..tostring(new))
	self.vcaGear = new 
	printCallstack()
end
 
function vehicleControlAddon:vcaOnSetRange( old, new, noEventSend )
	print("vcaOnSetRange: "..string(old).."->"..tostring(new))
	self.vcaRange = new 
	printCallstack()
end

function vehicleControlAddon:vcaOnSetWarningText( old, new, noEventSend )
	self.vcaWarningText  = new
  self.vcaWarningTimer = 2000
end

function vehicleControlAddon:vcaGetAbsolutRotY( camIndex )
	if     self.spec_enterable.cameras == nil
			or self.spec_enterable.cameras[camIndex] == nil then
		return 0
	end
  return vehicleControlAddon.vcaGetRelativeYRotation( self.spec_enterable.cameras[camIndex].cameraNode, self.spec_wheels.steeringCenterNode )
end

function vehicleControlAddon.vcaGetRelativeYRotation(root,node)
	if root == nil or node == nil then
		return 0
	end
	local x, y, z = worldDirectionToLocal(node, localDirectionToWorld(root, 0, 0, 1))
	local dot = z
	local len = 0
	if math.abs( z ) < 1e-6 then 
		len = math.abs( x )
	elseif math.abs( x ) < 1e-6 then 
		len = math.abs( z ) 
	else 
		len = math.sqrt( x*x + z*z )
	end 
	dot = dot / len
	local angle = math.acos(dot)
	if x < 0 then
		angle = -angle
	end
	return angle
end

function vehicleControlAddon.vcaSpeedToString( speed, numberFormat )
	if speed == nil then	
		return "nil" 
	end 
	local s = speed 
	local u = "km/h" 
	if g_gameSettings.useMiles then 
		s = s * 0.621371
		u = "mph"
	end 
	return string.format( Utils.getNoNil( numberFormat, "%3.0f" ), s ).." "..u 	
end 


function vehicleControlAddon:vcaShowSettingsUI()
	if g_gui:getIsGuiVisible() then
		return 
	end
	if g_vehicleControlAddonScreen == nil then
		-- settings screen
		g_vehicleControlAddonScreen = vehicleControlAddonScreen:new()
		for n,t in pairs( vehicleControlAddon_Register.mogliTexts ) do
			g_vehicleControlAddonScreen.mogliTexts[n] = t
		end
		g_gui:loadGui(vehicleControlAddon_Register.g_currentModDirectory .. "vehicleControlAddonScreen.xml", "vehicleControlAddonScreen", g_vehicleControlAddonScreen)	
		g_vehicleControlAddonScreen:setTitle( "vcaVERSION" )
	end

	self.vcaUI = {}
	self.vcaUI.vcaExponent_V = { -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5 }
	self.vcaUI.vcaExponent = {}
	for i,e in pairs( self.vcaUI.vcaExponent_V ) do
		self.vcaUI.vcaExponent[i] = string.format("%3.0f %%", 100 * ( 1.1 ^ e ), true )
	end
	self.vcaUI.vcaLimitThrottle   = {}
	for i=1,20 do
	  self.vcaUI.vcaLimitThrottle[i] = string.format("%3d %% / %3d %%", 45 + 5 * math.min( i, 11 ), 150 - 5 * math.max( i, 10 ), true )
	end
	self.vcaUI.vcaSnapAngle = {}
	for i,v in pairs( vehicleControlAddon.snapAngles ) do 
		self.vcaUI.vcaSnapAngle[i] = string.format( "%3d°", v )
	end 
	self.vcaUI.vcaBrakeForce_V = { 0, 0.05, 0.10, 0.15, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1 }
	self.vcaUI.vcaBrakeForce = {}
	for i,e in pairs( self.vcaUI.vcaBrakeForce_V ) do
		self.vcaUI.vcaBrakeForce[i] = string.format("%3.0f %%", 100 * e )
	end
	self.vcaUI.vcaTransmission = { "off" }
	for i,t in pairs(vehicleControlAddonTransmissionBase.transmissionList) do 
		table.insert( self.vcaUI.vcaTransmission , t.text )
	end 
	
	local m = vehicleControlAddon.getDefaultMaxSpeed( self )
	self.vcaUI.vcaMaxSpeed_V = { 7, 8.889, 11.944, 14.722, 16.111, 18.056, 20.417, 25, 33.333, 50 }
	local found = -1 
	for i,v in pairs(self.vcaUI.vcaMaxSpeed_V) do
		if math.abs( m-v ) < 1 then 
			self.vcaUI.vcaMaxSpeed_V[i] = m 
			found = 0
			break 
		elseif v > m and found < 0 then 
			found = i 
		end 
	end 
	if found < 0 then 
		table.insert( self.vcaUI.vcaMaxSpeed_V, m ) 
	elseif found > 0 then 
		table.insert( self.vcaUI.vcaMaxSpeed_V, found, m ) 
	end 
	self.vcaUI.vcaMaxSpeed = {}
	for i,v in pairs(self.vcaUI.vcaMaxSpeed_V) do
		self.vcaUI.vcaMaxSpeed[i] = vehicleControlAddon.vcaSpeedToString( v*3.6 )
	end
	self.vcaUI.oldTransmission = self.vcaTransmission
	
	self.vcaUI.vcaSnapDistance_V = {}
	self.vcaUI.vcaSnapDistance   = {}
	for i,v in pairs( { 0, 1.5, 1.6, 1.7, 1.8, 1.9,
											2, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 
											3, 3.1, 3.2, 3.4, 3.6, 3.8, 4, 4.2, 4.5, 4.8, 
											5, 5.5, 6, 6.5, 7, 7.5, 8, 8.4, 9, 10, 12, 13.5, 15, 
											18, 18.2, 21, 24, 28, 30, 36, 40, 48 } ) do
		self.vcaUI.vcaSnapDistance_V[i] = v
		self.vcaUI.vcaSnapDistance[i]   = string.format( "%4.1fm",v )
	end 
	
	self.vcaUI.vcaSnapDraw = { "off", "only if inactive", "always" }
	
	self.vcaUI.vcaHandthrottle = { "off", "PTO ECO", "90% PTO", "100% PTO" } 
	self.vcaUI.vcaHandthrottle_V = { 0, -0.7, -0.9, -1 }
	local m1 = self.spec_motorized.motor.minRpm 
	local m2 = self.spec_motorized.motor.maxRpm 
	local md = m2 - m1
	
	local r = m1 + 100 
	while r <= m2 do 
		h = ( r - m1 ) / md 
		table.insert( self.vcaUI.vcaHandthrottle, string.format( "%4d U/min", r ) )
		table.insert( self.vcaUI.vcaHandthrottle_V, h )
		r = r + 100
	end 
	
	self.vcaUI.vcaPitchFactor   = {}
	self.vcaUI.vcaPitchFactor_V = {}
	self.vcaUI.vcaPitchExponent   = {}
	self.vcaUI.vcaPitchExponent_V = {}
	for i=1,15 do 
		local v = 0.8 + ( i - 1 ) * 0.05
		table.insert( self.vcaUI.vcaPitchFactor, string.format( "%3.0f%%", v*100 ) )
		table.insert( self.vcaUI.vcaPitchFactor_V, v )
		table.insert( self.vcaUI.vcaPitchExponent, string.format( "%3.0f%%", v*100 ) )
		table.insert( self.vcaUI.vcaPitchExponent_V, v )
	end 
	
	self.vcaUI.vcaG27Mode = { "6G, 1R, LH",
														"6G, Shuttle, LH",
														"6G, D/R, LH",
														"6G, R+/-, 1R",
														"6G, R+/-, Shuttle",
														"8G, 1R, LH",
														"8G, Shuttle, LH",
														"4G, R+/-, 1R",
														"4G, R+/-, Shuttle",
														"4G, R+/-, D/R",
														"D/R , G+/-, R+/-" }
	
	g_vehicleControlAddonScreen:setVehicle( self )
	g_gui:showGui( "vehicleControlAddonScreen" )
end

function vehicleControlAddon:vcaUIGetvcaExponent()
	for i,e in pairs( self.vcaUI.vcaExponent_V ) do
		if math.abs( e - self.vcaExponent ) < 0.5 then
			return i
		end
	end
	return 7
end

function vehicleControlAddon:vcaUISetvcaExponent( value )
	if self.vcaUI.vcaExponent_V[value] ~= nil then
		self:vcaSetState( "vcaExponent", self.vcaUI.vcaExponent_V[value] )
	end
end

function vehicleControlAddon:vcaUIGetvcaBrakeForce()
	local d = 2
	local j = 4
	for i,e in pairs( self.vcaUI.vcaBrakeForce_V ) do
		if math.abs( e - self.vcaBrakeForce ) < d then
			d = math.abs( e - self.vcaBrakeForce )
			j = i
		end
	end
	return j
end

function vehicleControlAddon:vcaUISetvcaBrakeForce( value )
	if self.vcaUI.vcaBrakeForce_V[value] ~= nil then
		self:vcaSetState( "vcaBrakeForce", self.vcaUI.vcaBrakeForce_V[value] )
	end
end

function vehicleControlAddon:vcaUIGetvcaMaxSpeed()
	local d, j
	for i,e in pairs( self.vcaUI.vcaMaxSpeed_V ) do
		local f = math.abs( e - self.vcaMaxSpeed )
		if d == nil or d > f then 
			d = f 
			j = i 
		end
	end
	return j
end

function vehicleControlAddon:vcaUISetvcaMaxSpeed( value )
	if self.vcaUI.vcaMaxSpeed_V[value] ~= nil then
		self:vcaSetState( "vcaMaxSpeed", self.vcaUI.vcaMaxSpeed_V[value] )
	end
end

function vehicleControlAddon:vcaUIGetvcaSnapDistance()
	local d, j
	for i,e in pairs( self.vcaUI.vcaSnapDistance_V ) do
		local f = math.abs( e - self.vcaSnapDistance )
		if d == nil or d > f then 
			d = f 
			j = i 
		end
	end
	return j
end

function vehicleControlAddon:vcaUISetvcaSnapDistance( value )
	if self.vcaUI.vcaSnapDistance_V[value] ~= nil then
		self:vcaSetState( "vcaSnapDistance", self.vcaUI.vcaSnapDistance_V[value] )
	end
end

function vehicleControlAddon:vcaUISetvcaHandthrottle( value )
	if self.vcaUI.vcaHandthrottle_V[value] ~= nil then
		self:vcaSetState( "vcaHandthrottle", self.vcaUI.vcaHandthrottle_V[value] )
	end
end

function vehicleControlAddon:vcaUIGetvcaHandthrottle()
	local i = 1
	local d = 2
	for j,h in pairs( self.vcaUI.vcaHandthrottle_V ) do 
		if math.abs( h - self.vcaHandthrottle ) < d then 
			d = math.abs( h - self.vcaHandthrottle )
			i = j 
		end 
	end 
	return i
end

function vehicleControlAddon:vcaUIGetvcaPitchFactor()
	local j = 5
	local d = math.abs( self.vcaPitchFactor - 1 )
	for i,v in pairs( self.vcaUI.vcaPitchFactor_V ) do 
		if math.abs( self.vcaPitchFactor - v ) < d then 
			j = i 
			d = math.abs( self.vcaPitchFactor - v )
		end 
	end 
	return j 
end 

function vehicleControlAddon:vcaUISetvcaPitchFactor( value )
	self:vcaSetState( "vcaPitchFactor", 0.8 + ( value - 1 ) * 0.05 )
end 

function vehicleControlAddon:vcaUIGetvcaPitchExponent()
	local j = 5
	local d = math.abs( self.vcaPitchExponent - 1 )
	for i,v in pairs( self.vcaUI.vcaPitchExponent_V ) do 
		if math.abs( self.vcaPitchExponent - v ) < d then 
			j = i 
			d = math.abs( self.vcaPitchExponent - v )
		end 
	end 
	return j 
end 

function vehicleControlAddon:vcaUISetvcaPitchExponent( value )
	self:vcaSetState( "vcaPitchExponent", 0.8 + ( value - 1 ) * 0.05 )
end 

function vehicleControlAddon:getUIMaxSpeed()
	if     g_vehicleControlAddonScreen == nil
			or g_vehicleControlAddonScreen.mogliScreenElements == nil
			or g_vehicleControlAddonScreen.mogliScreenElements.vcaMaxSpeed == nil
			or g_vehicleControlAddonScreen.mogliScreenElements.vcaMaxSpeed.element == nil
			or g_vehicleControlAddonScreen.mogliScreenElements.vcaMaxSpeed.element.getState == nil
			then
		print("getUIMaxSpeed: nil error I")
		return nil 
	end 
	local value = g_vehicleControlAddonScreen.mogliScreenElements.vcaMaxSpeed.element:getState()
	if     self.vcaUI == nil 
			or self.vcaUI.vcaMaxSpeed_V == nil
			or value == nil 
			then 
		print("getUIMaxSpeed: nil error II")
		return nil 
	end 
--print("getUIMaxSpeed: "..tostring(value)..", "..tostring(self.vcaUI.vcaMaxSpeed_V[value]))
	return self.vcaUI.vcaMaxSpeed_V[value]
end 

function vehicleControlAddon:setUIGearSpeed( name, value )
	if self == nil then print("setUIGearSpeed nil error 1 ("..tostring(name)..")") return end 
	if value <= 1 then 
		self:vcaSetState( name, 0 )
		return 
	end 
	local speed = vehicleControlAddon.getUIMaxSpeed( self )
	if speed == nil or speed <= 0 then print("setUIGearSpeed nil error 2 ("..tostring(name)..")") return end 
	speed = speed * 3.6
	local s, i = 5, 2
	while s < speed do 
		if i == value then 
			self:vcaSetState( name, s / speed )
			return 
		end 
		if     s < 16 then 
			s = s + 1 
		elseif s < 20 then 
			s = s + 2 
		else
			s = s + 5 
		end 
		i = i + 1
	end 
end

function vehicleControlAddon:getUIGearSpeed( name )
	if self == nil then print("getUIGearSpeed nil error 1 ("..tostring(name)..")") return 1 end 
	local speed = self.vcaMaxSpeed -- vehicleControlAddon.getUIMaxSpeed( self )
	if speed == nil or speed <= 0 then print("getUIGearSpeed nil error 2 ("..tostring(name)..")") return 1 end 
	local v = self[name]
	if v == nil then print("getUIGearSpeed nil error 3 ("..tostring(name)..")") return 1 end 
	if v <= 0 then return 1 end 
	speed = speed * 3.6
	v = v * speed
	local s, i = 5, 2
	local t
	while s < speed do 
		if t == nil or math.abs( t-v ) > math.abs( s-v ) then 
			t = s 
		else 
			return i-1
		end 
		if     s < 16 then 
			s = s + 1 
		elseif s < 20 then 
			s = s + 2 
		else
			s = s + 5 
		end 
		i = i + 1
	end 
	return 1
end

function vehicleControlAddon:drawUIGearSpeed()
	if self == nil then return { "off" } end 
	local res   = { "off" }
	local speed = vehicleControlAddon.getUIMaxSpeed( self )
	if speed == nil then return { "off" } end 
	speed = speed * 3.6
	local s = 5
	while s < speed do 
		table.insert( res, vehicleControlAddon.vcaSpeedToString( s ) ) 
		if     s < 16 then 
			s = s + 1 
		elseif s < 20 then 
			s = s + 2 
		else
			s = s + 5 
		end 
	end 
	return res
end


function vehicleControlAddon:vcaUISetvcaGearRatioF( value )
	vehicleControlAddon.setUIGearSpeed( self, "vcaGearRatioF", value )
end 
function vehicleControlAddon:vcaUIGetvcaGearRatioF()
	return vehicleControlAddon.getUIGearSpeed( self, "vcaGearRatioF" )
end
function vehicleControlAddon:vcaUIDrawvcaGearRatioF()
	return vehicleControlAddon.drawUIGearSpeed( self )
end

function vehicleControlAddon:vcaUISetvcaGearRatioT( value )
	vehicleControlAddon.setUIGearSpeed( self, "vcaGearRatioT", value )
end 
function vehicleControlAddon:vcaUIGetvcaGearRatioT()
	return vehicleControlAddon.getUIGearSpeed( self, "vcaGearRatioT" )
end
function vehicleControlAddon:vcaUIDrawvcaGearRatioT()
	return vehicleControlAddon.drawUIGearSpeed( self )
end

function vehicleControlAddon:vcaUIGetvcaSnapDistance()
	return tostring( self.vcaSnapDistance )
end 
function vehicleControlAddon:vcaUISetvcaSnapDistance( value )
	local v = tonumber( value )
	if type( v ) == "number" and v > 0 then 
		self:vcaSetState( "vcaSnapDistance", tonumber( value ) )
	end 
end 