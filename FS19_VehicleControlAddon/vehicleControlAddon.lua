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
											"onEnterVehicle",
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

local listOfFunctions = {}
listOfFunctions.bool   = { getXML=getXMLBool     , setXML=setXMLBool     , streamRead=streamReadBool   , streamWrite=streamWriteBool    }
listOfFunctions.int16  = { getXML=getXMLInt      , setXML=setXMLInt      , streamRead=streamReadInt16  , streamWrite=streamWriteInt16   }
listOfFunctions.float  = { getXML=getXMLFloat    , setXML=setXMLFloat    , streamRead=streamReadFloat32, streamWrite=streamWriteFloat32 }
listOfFunctions.trans  = { getXML=getTransmission, setXML=setTransmission, streamRead=streamReadInt16  , streamWrite=streamWriteInt16   }
listOfFunctions.string = { getXML=getXMLString   , setXML=setXMLString   , streamRead=streamReadString , streamWrite=streamWriteString  }

local listOfProperties = 
	{ { func=listOfFunctions.bool , xmlName="steering",      propName="vcaSteeringIsOn"  },
		{ func=listOfFunctions.bool , xmlName="shuttle",       propName="vcaShuttleCtrl"   },
		{ func=listOfFunctions.bool , xmlName="peek",          propName="vcaPeekLeftRight" },
		{ func=listOfFunctions.bool , xmlName="limitSpeed",    propName="vcaLimitSpeed"    },
		{ func=listOfFunctions.bool , xmlName="keepSpeed",     propName="vcaKSToggle"      },
		{ func=listOfFunctions.bool , xmlName="freeSteering",  propName="vcaNoARBToggle"   },
		{ func=listOfFunctions.bool , xmlName="camRotInside",  propName="vcaCamRotInside"  },
		{ func=listOfFunctions.bool , xmlName="camRotOutside", propName="vcaCamRotOutside" },
		{ func=listOfFunctions.bool , xmlName="camRevInside",  propName="vcaCamRevInside"  },
		{ func=listOfFunctions.bool , xmlName="camRevOutside", propName="vcaCamRevOutside" },
		{ func=listOfFunctions.int16, xmlName="exponent",      propName="vcaExponent"      },
		{ func=listOfFunctions.int16, xmlName="throttle",      propName="vcaLimitThrottle" },
		{ func=listOfFunctions.int16, xmlName="snapAngle",     propName="vcaSnapAngle"     },
		{ func=listOfFunctions.float, xmlName="snapDist",      propName="vcaSnapDistance"  },
		{ func=listOfFunctions.float, xmlName="snapOffset1",   propName="vcaSnapOffset1"   },
		{ func=listOfFunctions.float, xmlName="snapOffset2",   propName="vcaSnapOffset2"   },
		{ func=listOfFunctions.bool , xmlName="drawHud",       propName="vcaDrawHud"       }, 
		{ func=listOfFunctions.float, xmlName="brakeForce",    propName="vcaBrakeForce"    },
		{ func=listOfFunctions.trans, xmlName="transmission",  propName="vcaTransmission"  },
		{ func=listOfFunctions.int16, xmlName="launchSpeed",   propName="vcaLaunchSpeed"   },
		{ func=listOfFunctions.int16, xmlName="singleReverse", propName="vcaSingleReverse" },
		{ func=listOfFunctions.int16, xmlName="currentGear",   propName="vcaGear",         },
		{ func=listOfFunctions.int16, xmlName="currentRange",  propName="vcaRange",        },
		{ func=listOfFunctions.bool , xmlName="autoShift",     propName="vcaAutoShift"     },
		{ func=listOfFunctions.bool , xmlName="autoClutch",    propName="vcaAutoClutch"    },
		{ func=listOfFunctions.bool , xmlName="turboClutch",   propName="vcaTurboClutch"   },
		{ func=listOfFunctions.float, xmlName="maxSpeed",      propName="vcaMaxSpeed"      },
		{ func=listOfFunctions.float, xmlName="ccSpeed2",      propName="vcaCCSpeed2"      },
		{ func=listOfFunctions.float, xmlName="ccSpeed3",      propName="vcaCCSpeed3"      },
		{ func=listOfFunctions.float, xmlName="snapDir",       propName="vcaLastSnapAngle" },
		{ func=listOfFunctions.float, xmlName="snapPosX",      propName="vcaLastSnapPosX"  },
		{ func=listOfFunctions.float, xmlName="snapPosZ",      propName="vcaLastSnapPosZ"  },
		{ func=listOfFunctions.float, xmlName="handthrottle",  propName="vcaHandthrottle"  },
		{ func=listOfFunctions.bool,  xmlName="handRpmFull",   propName="vcaHandRpmFullAxis"},
		{ func=listOfFunctions.float, xmlName="pitchFactor",   propName="vcaPitchFactor"   },
		{ func=listOfFunctions.float, xmlName="pitchExponent", propName="vcaPitchExponent" },
		{ func=listOfFunctions.float, xmlName="minGearRatio",  propName="vcaGearRatioF"    },
		{ func=listOfFunctions.float, xmlName="maxGearRatio",  propName="vcaGearRatioT"    },
		{ func=listOfFunctions.int16, xmlName="g27Mode",       propName="vcaG27Mode"       },
		{ func=listOfFunctions.int16, xmlName="hiredWorker",   propName="vcaHiredWorker"   },
		{ func=listOfFunctions.bool,  xmlName="hiredWorker2",  propName="vcaHiredWorker2"  },
		{ func=listOfFunctions.bool , xmlName="modifyPitch",   propName="vcaModifyPitch"   },
		{ func=listOfFunctions.float, xmlName="ownGearFactor", propName="vcaOwnGearFactor" },
		{ func=listOfFunctions.float, xmlName="ownRangeFactor",propName="vcaOwnRangeFactor" },
		{ func=listOfFunctions.int16, xmlName="ownGears",      propName="vcaOwnGears"      },
		{ func=listOfFunctions.int16, xmlName="ownRanges",     propName="vcaOwnRanges"     },
		{ func=listOfFunctions.int16, xmlName="ownGearTime",   propName="vcaOwnGearTime"   },
		{ func=listOfFunctions.int16, xmlName="ownRangeTime",  propName="vcaOwnRangeTime"  },
		{ func=listOfFunctions.bool , xmlName="ownAutoGears",  propName="vcaOwnAutoGears"  },
		{ func=listOfFunctions.bool , xmlName="ownAutoRange",  propName="vcaOwnAutoRange"  },
		{ func=listOfFunctions.float, xmlName="blowOffVolume", propName="vcaBlowOffVolume" },
		{ func=listOfFunctions.float, xmlName="rotSpeedOut",   propName="vcaRotSpeedOut"   },
		{ func=listOfFunctions.float, xmlName="rotSpeedIn",    propName="vcaRotSpeedIn"    },
		{ func=listOfFunctions.bool,  xmlName="antiSlip",      propName="vcaAntiSlip"      },
		{ func=listOfFunctions.bool,  xmlName="diffLockFront", propName="vcaDiffLockFront" },
		{ func=listOfFunctions.bool,  xmlName="diffLockAWD",   propName="vcaDiffLockAWD"   },
		{ func=listOfFunctions.bool,  xmlName="diffLockBack",  propName="vcaDiffLockBack"  },
		{ func=listOfFunctions.bool,  xmlName="diffLockSwap",  propName="vcaDiffLockSwap"  },
		{ func=listOfFunctions.bool,  xmlName="diffFrontAdv",  propName="vcaDiffFrontAdv"  },
		{ func=listOfFunctions.bool,  xmlName="diffManual",    propName="vcaDiffManual"    },
	}


vehicleControlAddon.snapAngles = { 1, 5, 15, 22.5, 45, 90 }
vehicleControlAddon.factor30pi = 30/math.pi  -- RPM = rotSpeed * vehicleControlAddon.factor30pi
vehicleControlAddon.factorpi30 = math.pi/30  -- rotSpeed = RPM * vehicleControlAddon.factorpi30
vehicleControlAddon.maxRpmF0   = 2250/2200
vehicleControlAddon.maxRpmF1   = 1.2
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
vehicleControlAddon.speedRatioOpen       = 1000
vehicleControlAddon.speedRatioClosed0    = -1   -- maxSpeedRatio of diff of diffs
vehicleControlAddon.speedRatioClosed1    = 3    -- maxSpeedRatio of diff of wheels
vehicleControlAddon.speedRatioClosed2    = 1.2  -- at least 20% difference 
vehicleControlAddon.distributeTorqueOpen = false  
vehicleControlAddon.minTorqueRatio       = 0.2

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

local function debugFormat( ... )
	if VCAGlobals.debugPrint then 
		return string.format( ... )
	end 
	return ""
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

function vehicleControlAddon.getText( id, default )
	if id == nil then 
		return "NIL" 
	end 
	if g_i18n:hasText( id ) then 
		return g_i18n:getText( id )
	end 
	if default ~= nil then 
		return default 
	end 
	return id 
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
	
	local x = VCAGlobals.snapAngleHudX
	local y = VCAGlobals.snapAngleHudY
	
	if VCAGlobals.snapAngleHudX < 0 then 
		x = g_currentMission.inGameMenu.hud.speedMeter.gaugeCenterX
		x = x - 5*l 
	end 
	if VCAGlobals.snapAngleHudY < 0 then 
		y = g_currentMission.inGameMenu.hud.speedMeter.gaugeCenterY + g_currentMission.inGameMenu.hud.speedMeter.fuelGaugeRadiusY * 1.6
		y = y + 0.7*l
	end 
	
	return x, y, x+10*l, y+3.4*l 
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
	self.vcaGetIsReverse     = vehicleControlAddon.vcaGetIsReverse
	self.vcaGetDiffState     = vehicleControlAddon.vcaGetDiffState
	self.vcaHasDiffFront     = vehicleControlAddon.vcaHasDiffFront
	self.vcaHasDiffAWD       = vehicleControlAddon.vcaHasDiffAWD 
	self.vcaHasDiffBack      = vehicleControlAddon.vcaHasDiffBack 
	self.vcaSetSnapFactor    = vehicleControlAddon.vcaSetSnapFactor
	self.vcaGetCurrentSnapAngle = vehicleControlAddon.vcaGetCurrentSnapAngle
	self.vcaGetSnapDistance     = vehicleControlAddon.vcaGetSnapDistance
	self.vcaSetCruiseSpeed      = vehicleControlAddon.vcaSetCruiseSpeed
	
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
	vehicleControlAddon.registerState( self, "vcaSnapDistance", 0 )
	vehicleControlAddon.registerState( self, "vcaSnapOffset1",  0 )
	vehicleControlAddon.registerState( self, "vcaSnapOffset2",  0 )
	vehicleControlAddon.registerState( self, "vcaSnapIsOn" ,    false, vehicleControlAddon.vcaOnSetSnapIsOn )
	vehicleControlAddon.registerState( self, "vcaDrawHud" ,     VCAGlobals.drawHud )
	vehicleControlAddon.registerState( self, "vcaInchingIsOn" , false )
	vehicleControlAddon.registerState( self, "vcaNoAutoRotBack",false )
	vehicleControlAddon.registerState( self, "vcaNoARBToggle",  false )
	vehicleControlAddon.registerState( self, "vcaBrakeForce",   VCAGlobals.brakeForceFactor )
	vehicleControlAddon.registerState( self, "vcaTransmission", vehicleControlAddon.getDefaultTransmission( self ), vehicleControlAddon.onSetTransmission )
	vehicleControlAddon.registerState( self, "vcaMaxSpeed",     vehicleControlAddon.getDefaultMaxSpeed( self ) )
	vehicleControlAddon.registerState( self, "vcaSingleReverse",0 ) 
	vehicleControlAddon.registerState( self, "vcaGear",         0 ) --, vehicleControlAddon.vcaOnSetGear )
	vehicleControlAddon.registerState( self, "vcaRange",        0 ) --, vehicleControlAddon.vcaOnSetRange )
	vehicleControlAddon.registerState( self, "vcaNeutral",      false, vehicleControlAddon.vcaOnSetNeutral )
	vehicleControlAddon.registerState( self, "vcaAutoShift",    true) --, vehicleControlAddon.vcaOnSetAutoShift )
	vehicleControlAddon.registerState( self, "vcaShifterIndex", 0 )
	vehicleControlAddon.registerState( self, "vcaShifterUsed",  false )
	vehicleControlAddon.registerState( self, "vcaShifterPark",  false )
	vehicleControlAddon.registerState( self, "vcaShifterLH",    true )
	vehicleControlAddon.registerState( self, "vcaLimitSpeed",   true )
	vehicleControlAddon.registerState( self, "vcaLaunchSpeed",  vehicleControlAddon.getDefaultLaunchSpeed( self ) )
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
	vehicleControlAddon.registerState( self, "vcaIsBlocked",    false )
	vehicleControlAddon.registerState( self, "vcaSnapDraw",     1 )
	vehicleControlAddon.registerState( self, "vcaHandthrottle", 0 )
	vehicleControlAddon.registerState( self, "vcaHandRpmFullAxis", false )
	vehicleControlAddon.registerState( self, "vcaPitchFactor",  1 )
	vehicleControlAddon.registerState( self, "vcaPitchExponent",1 )
	vehicleControlAddon.registerState( self, "vcaGearRatioF",   0 )
	vehicleControlAddon.registerState( self, "vcaGearRatioT",   0 )
	vehicleControlAddon.registerState( self, "vcaG27Mode",      VCAGlobals.g27Mode )
	vehicleControlAddon.registerState( self, "vcaSnapFactor",   0 )
	vehicleControlAddon.registerState( self, "vcaModifyPitch",  VCAGlobals.modifyPitch )
	vehicleControlAddon.registerState( self, "vcaHiredWorker",  VCAGlobals.hiredWorker )
	vehicleControlAddon.registerState( self, "vcaHiredWorker2", VCAGlobals.hiredWorker2 )
	vehicleControlAddon.registerState( self, "vcaBlowOffVolume",VCAGlobals.blowOffVolume )
	vehicleControlAddon.registerState( self, "vcaRotSpeedOut",  VCAGlobals.rotSpeedOut )
	vehicleControlAddon.registerState( self, "vcaRotSpeedIn",   VCAGlobals.rotSpeedIn )
	vehicleControlAddon.registerState( self, "vcaAntiSlip",     false )
	vehicleControlAddon.registerState( self, "vcaDiffLockFront",false )
	vehicleControlAddon.registerState( self, "vcaDiffLockAWD",  false )
	vehicleControlAddon.registerState( self, "vcaDiffLockBack", false )
	vehicleControlAddon.registerState( self, "vcaDiffManual",   false )
	vehicleControlAddon.registerState( self, "vcaDiffLockSwap", false )
	vehicleControlAddon.registerState( self, "vcaDiffFrontAdv", false )
	
	vehicleControlAddon.registerState( self, "vcaOwnGearFactor" , 0.4096, function( self, ... ) vehicleControlAddon.vcaOnSetOwn( self, "vcaOwnGearFactor" , ... ) end )
	vehicleControlAddon.registerState( self, "vcaOwnRangeFactor", 0.4096, function( self, ... ) vehicleControlAddon.vcaOnSetOwn( self, "vcaOwnRangeFactor", ... ) end )
	vehicleControlAddon.registerState( self, "vcaOwnGears"      , 5     , function( self, ... ) vehicleControlAddon.vcaOnSetOwn( self, "vcaOwnGears"      , ... ) end )
	vehicleControlAddon.registerState( self, "vcaOwnRanges"     , 3     , function( self, ... ) vehicleControlAddon.vcaOnSetOwn( self, "vcaOwnRanges"     , ... ) end )
	vehicleControlAddon.registerState( self, "vcaOwnGearTime"   , 0     , function( self, ... ) vehicleControlAddon.vcaOnSetOwn( self, "vcaOwnGearTime"   , ... ) end )
	vehicleControlAddon.registerState( self, "vcaOwnRangeTime"  , 750   , function( self, ... ) vehicleControlAddon.vcaOnSetOwn( self, "vcaOwnRangeTime"  , ... ) end )
	vehicleControlAddon.registerState( self, "vcaOwnAutoGears"  , true  , function( self, ... ) vehicleControlAddon.vcaOnSetOwn( self, "vcaOwnAutoGears"  , ... ) end )
	vehicleControlAddon.registerState( self, "vcaOwnAutoRange"  , false , function( self, ... ) vehicleControlAddon.vcaOnSetOwn( self, "vcaOwnAutoRange"  , ... ) end )
	
	self.vcaFactor        = 1
	self.vcaReverseTimer  = 1.5 / VCAGlobals.timer4Reverse
	self.vcaMovingDir     = 0
	self.vcaLastFactor    = 0
	self.vcaWarningTimer  = 0
	self.vcaShifter7isR1  = nil 
	self.vcaGearbox       = nil
	self.vcaTickDt        = 0
	self.vcaIsEntered     = false
	self.vcaKeepCamRot    = false 
	self.vcaKRToggleIn    = false 
	self.vcaKRToggleOut   = false 
	self.vcaShifterUsed2  = 0

	self.vcaClutchPercent = 0
	self.vcaClutchPercentS= 0
	self.vcaClutchDisp    = 0
	self.vcaClutchDispS   = 0
	self.vcaAutoStopS     = false 
	self.vcaRpmFactor     = 1
	self.vcaRpmFactorS    = 1
	self.vcaWheelSlip     = 0
	self.vcaWheelSlipS    = 0
	self.vcaLastRpmFactor = 1
	
	self.vcaKeepRotPressed   = false 
	self.vcaInchingPressed   = false 
	self.vcaKeepSpeedPressed = false 		

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
			vehicleControlAddon.ovDiffLockFront  = createImageOverlay( Utils.getFilename( "diff_front.dds",       vehicleControlAddon.baseDirectory ))
			vehicleControlAddon.ovDiffLockMid    = createImageOverlay( Utils.getFilename( "diff_middle.dds",      vehicleControlAddon.baseDirectory ))
			vehicleControlAddon.ovDiffLockBack   = createImageOverlay( Utils.getFilename( "diff_back.dds",        vehicleControlAddon.baseDirectory ))
			vehicleControlAddon.ovDiffLockBg     = createImageOverlay( Utils.getFilename( "diff_wheels.dds",      vehicleControlAddon.baseDirectory ))
			
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
			local v = prop.func.getXML( savegame.xmlFile, savegame.key.."."..g_vehicleControlAddon.vcaSpecName.."#"..prop.xmlName )
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
			local key  = string.format( "%s.%s.users(%d)", savegame.key, g_vehicleControlAddon.vcaSpecName, u )
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
				local v = prop.func.getXML( savegame.xmlFile, key.."#"..prop.xmlName )
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

	self.vcaDiffHasF = false 
	self.vcaDiffHasM = false 
	self.vcaDiffHas2 = false 
	self.vcaDiffHasB = false 
	
	if type( self.functionStatus ) == "function" and self:functionStatus("differential") then 
	-- TSX diffs ...
	elseif self.spec_crawlers ~= nil and #self.spec_crawlers.crawlers > 0 then 
	-- crawlers => not support as visible wheel will not turn in most cases
	elseif ( self.spec_articulatedAxis ~= nil and self.spec_articulatedAxis.componentJoint ~= nil )
			or ( self.numComponents == 2 and self.spec_crawlers ~= nil and #self.spec_crawlers.crawlers > 0 ) then 
	-- articulated axis 
		local spec       = self.spec_motorized
		local specWheels = self.spec_wheels
		local noPattern  = false 
		local rootNode1, rootNode2 
				
		if self.spec_articulatedAxis ~= nil and self.spec_articulatedAxis.componentJoint ~= nil then 
			local componentJoint = self.spec_articulatedAxis.componentJoint
			rootNode1 = self.components[componentJoint.componentIndices[1]].node
			rootNode2 = self.components[componentJoint.componentIndices[2]].node
		else 
		-- let's hope that the 2nd node is the front axle 
			rootNode1 = self.components[2].node 
			rootNode2 = self.components[1].node 
		end 
		
		local wx, wy, wz, lz1, lz2
		wx, wy, wz = getWorldTranslation(rootNode1)
		_,_, lz1 = worldToLocal(self.steeringAxleNode, wx, wy, wz)
		wx, wy, wz = getWorldTranslation(rootNode2)
		_,_, lz2 = worldToLocal(self.steeringAxleNode, wx, wy, wz)
		
		if lz1 > lz2 then 
			rootNode1, rootNode2 = rootNode2, rootNode1
		end 
		
		local function checkWheelsOfDiff( rootNode1, rootNode2, index, isWheel, depth )
			local d2 = 2 
			if type( depth ) == 'number' then 
				if depth > #spec.differentials then 
					print("VCA: found recursion in differential definition")
					noPattern = true 
					return false, false, false 
				end 
				d2 = depth + 1
			end 
			if isWheel then 
				local wheel    = self:getWheelFromWheelIndex( index )
				local rootNode = self:getParentComponent(wheel.repr)
				if     rootNode == rootNode1 then
					return true, false, true  
				elseif rootNode == rootNode2 then 
					return false, true, true 
				else 
					return false, false, false 
				end 
			else 				
				local diff = spec.differentials[index+1] 				
				local c11, c21, a1 = checkWheelsOfDiff( rootNode1, rootNode2, diff.diffIndex1, diff.diffIndex1IsWheel, d2 )
				local c12, c22, a2 = checkWheelsOfDiff( rootNode1, rootNode2, diff.diffIndex2, diff.diffIndex2IsWheel, d2 )				
				return c11 or c12, c21 or c22, a1 and a2 
			end 
		end 
		
		for k,differential in pairs(spec.differentials) do
			local c1, c2, all = checkWheelsOfDiff( rootNode1, rootNode2, k-1, false )
			if all and ( c1 or c2 ) then  
				if c1 and c2 then 
					vehicleControlAddon.debugPrint("Diff. "..tostring(k-1).." is in the middle")
					differential.vcaMode = 'M' 
					self.vcaDiffHasM     = true 
				elseif c1 then 
					vehicleControlAddon.debugPrint("Diff. "..tostring(k-1).." is at the front")
					differential.vcaMode = 'F' 
					self.vcaDiffHasF     = true 
				else --if c2 then; is always true 
					vehicleControlAddon.debugPrint("Diff. "..tostring(k-1).." is at the back")
					differential.vcaMode = 'B' 
					self.vcaDiffHasB     = true 
				end 
			else 
				vehicleControlAddon.debugPrint("Diff. "..tostring(k-1).." is mixed: "..tostring(c1)..", "..tostring(c2)..", "..tostring(all))
				noPattern = true 
			end 
			differential.vcaTorqueRatio   = differential.torqueRatio
			differential.vcaMaxSpeedRatio = differential.maxSpeedRatio
			differential.vcaIndex         = k-1
		end 
		
		if noPattern then 
			self.vcaDiffHasF = false 
			self.vcaDiffHasM = false 
			self.vcaDiffHasB = false 
		end 
	else 
	-- hopefully, a normal vehicle 
		local spec = self.spec_motorized
		local noPattern  = false 
				
		local function getMinMaxRotSpeed( index, isWheel, depth ) 
			local d2 = 2 
			if type( depth ) == 'number' then 
				if depth > #spec.differentials then 
					print("VCA: found recursion in differential definition")
					noPattern = true 
					return 0, 0
				end 
				d2 = depth + 1
			end 
			if isWheel then 
				local wheel = self:getWheelFromWheelIndex( index )
				if not wheel.showSteeringAngle then 
					return 0, 0
				elseif wheel.rotSpeed == nil then 
					return 0, 0
				else 
					local r = math.abs( wheel.rotSpeed ) 
					return r, r 
				end 
			else 
				local diff = spec.differentials[index+1] 
				
				local rMin1, rMax1 = getMinMaxRotSpeed( diff.diffIndex1, diff.diffIndex1IsWheel, d2 )
				local rMin2, rMax2 = getMinMaxRotSpeed( diff.diffIndex2, diff.diffIndex2IsWheel, d2 )
				
				return math.min( rMin1, rMin2 ), math.max( rMax1, rMax2 )
			end 
		end 
		
		for k,differential in pairs(spec.differentials) do
			local rMin1, rMax1 = getMinMaxRotSpeed( k-1, false )
			if    rMax1 < 0.1 then 
				differential.vcaMode = 'B' -- back axle, no steering
				self.vcaDiffHasB = true 
			elseif rMin1 > 0.1 then 
				differential.vcaMode = 'F' -- front axle, with steering
				self.vcaDiffHasF = true 
			elseif not differential.diffIndex1IsWheel and not differential.diffIndex2IsWheel then 
				differential.vcaMode = 'M' -- mid differential, between front and back
				self.vcaDiffHasM = true 
				
				local rMin1, rMax1 = getMinMaxRotSpeed( differential.diffIndex1, differential.diffIndex1IsWheel )
				local rMin2, rMax2 = getMinMaxRotSpeed( differential.diffIndex2, differential.diffIndex2IsWheel )
				if     rMin1 > 0.1 and rMax2 < 0.1 then 
					differential.vcaTorqueRatioOpen = 0
					self.vcaDiffHas2 = true 
				elseif rMin2 > 0.1 and rMax1 < 0.1 then 
					differential.vcaTorqueRatioOpen = 1 
					self.vcaDiffHas2 = true 
				end 
			else 
				differential.vcaMode = '-' -- bad 
				noPattern = true 
			end 
			differential.vcaTorqueRatio   = differential.torqueRatio
			differential.vcaMaxSpeedRatio = differential.maxSpeedRatio
			differential.vcaIndex         = k-1
		end 
		
		if noPattern then 
			self.vcaDiffHasF = false 
			self.vcaDiffHasM = false 
			self.vcaDiffHasB = false 
			self.vcaDiffHas2 = false 
		end 
	end
	
end 

function vehicleControlAddon:saveToXMLFile(xmlFile, xmlKey)

	for _,prop in pairs( listOfProperties ) do 
		if self:vcaIsNonDefaultProp( prop.propName ) then 
			prop.func.setXML( xmlFile, xmlKey.."#"..prop.xmlName, self[prop.propName] )
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
					prop.func.setXML( xmlFile, key.."#"..prop.xmlName, setting[prop.propName] )
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
																"vcaKEEPROT",
																"vcaKEEPROT2",
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
																"vcaNeutral0",
																"vcaNeutral1",
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
																"vcaHandRpm",
																"vcaAutoShift",
																"vcaDiffLockF",
																"vcaDiffLockM",
																"vcaDiffLockB",
																"vcaLowerF",
																"vcaLowerB",
																"vcaActivateF",
																"vcaActivateB",
															}) do
																
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
					or  actionName == "vcaHandRpm"
					or  actionName == "vcaAutoShift"
					then 	
				addThis = self.vcaIsLoaded and self:vcaGetTransmissionActive()
			end 
			
			if      addThis 
					and ( isOnActiveVehicle 
						or  actionName == "vcaUP"
						or  actionName == "vcaDOWN"
						or  actionName == "vcaLEFT"
						or  actionName == "vcaRIGHT"
						or  actionName == "vcaKEEPROT"
						or  actionName == "vcaSWAPSPEED"
						or  actionName == "vcaGearUp"
						or  actionName == "vcaGearDown"
						or  actionName == "vcaRangeUp"
						or  actionName == "vcaRangeDown") then 
				-- above actions are still active for hired worker
				local pBool1, pBool2, pBool3, pBool4 = false, true, false, true 
				if     actionName == "vcaUP"
						or actionName == "vcaDOWN"
						or actionName == "vcaLEFT"
						or actionName == "vcaRIGHT" 
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
				elseif actionName == "vcaClutch"
						or actionName == "vcaKEEPSPEED" 
						or actionName == "vcaKEEPROT"
						or actionName == "vcaINCHING"
						then 
					pBool1 = true 
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
						g_inputBinding.events[eventName].displayPriority = 4
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
		
	elseif actionName == "vcaKEEPROT" then 
		self.vcaKeepRotPressed   = keyStatus >= 0.5 			
	elseif actionName == "vcaKEEPROT2" then 
		
		local krToggle = "vcaKRToggleOut"
		if self.vcaCamIsInside then 
			krToggle = "vcaKRToggleIn"
		end 
		self[krToggle] = not self[krToggle] 
		self.vcaKeepCamRot = self[krToggle] 
			
	elseif actionName == "vcaINCHING" then 
		self.vcaInchingPressed   = keyStatus >= 0.5 
	elseif actionName == "vcaKEEPSPEED" then 
		self.vcaKeepSpeedPressed = keyStatus >= 0.5 		
	elseif actionName == "vcaKEEPSPEED2" then 
		self:vcaSetState( "vcaKSToggle", not self.vcaKSToggle )
		if self.vcaKSToggle then 
			self:vcaSetState( "vcaKeepSpeed", self.lastSpeed * 3600 )
			self:vcaSetState( "vcaKSIsOn", true )
		else 
			self:vcaSetState( "vcaKSIsOn", false )
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
	elseif actionName == "vcaSWAPSPEED" then 
		local temp = self:getCruiseControlSpeed()
    self:vcaSetCruiseSpeed( self.vcaCCSpeed2 )
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
		local a  = self:vcaGetCurrentSnapAngle( d )
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
 	elseif actionName == "vcaNeutral" 
	    or actionName == "vcaNeutral0"
			or actionName == "vcaNeutral1" then
		local n 
		if     actionName == "vcaNeutral0" then 
			n = false 
		elseif actionName == "vcaNeutral1" then 
			n = true 
		elseif self.vcaShifterUsed then 
			n = not self.vcaShifterPark  
		else 
			n = not self.vcaNeutral 
		end 
		if self.vcaShifterUsed then 
			self:vcaSetState( "vcaShifterPark", n )
		else 
			self:vcaSetState( "vcaNeutral", n )
		end 
	elseif actionName == "vcaSETTINGS" then
		vehicleControlAddon.vcaShowSettingsUI( self )
	elseif actionName == "vcaAutoShift" then
		self:vcaSetState( "vcaAutoShift", not self.vcaAutoShift )
	elseif actionName == "vcaDiffLockF" then
		if self:vcaIsVehicleControlledByPlayer() and self:vcaHasDiffFront() then
			self:vcaSetState( "vcaDiffLockFront", not self.vcaDiffLockFront )
		end 
	elseif actionName == "vcaDiffLockM" then
		if self:vcaIsVehicleControlledByPlayer() and self:vcaHasDiffAWD() then  
			self:vcaSetState( "vcaDiffLockAWD", not self.vcaDiffLockAWD )
		end 
	elseif actionName == "vcaDiffLockB" then
		if self:vcaIsVehicleControlledByPlayer() and self:vcaHasDiffBack() then
			self:vcaSetState( "vcaDiffLockBack", not self.vcaDiffLockBack )
		end 
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
			t = string.format( "%4.0f %s", r, vehicleControlAddon.getText( "vcaValueRPM", "RPM"  ) )
		else 
			h = 0
			t = "off"
		end 
		
		self:vcaSetState( "vcaHandthrottle", h )
		self:vcaSetState( "vcaWarningText", vehicleControlAddon.getText( "vcaHANDTHROTTLE", "" )..": ".. t )
	elseif actionName == "vcaHandRpm" then 
		local h = 0
		if self.vcaHandthrottle ~= nil and self.vcaHandthrottle > 0 then 
			h = self.vcaHandthrottle
		end 
		
		if     isAnalog then 
			if keyStatus > 0.5 then 
				self:vcaSetState( "vcaHandRpmFullAxis", true )
			end 
			if self.vcaHandRpmFullAxis then 
				h = 0.5 * ( 1 + keyStatus ) 
			else 
				h = 1 + keyStatus
			end 
		elseif keyStatus > 0.5 then 
			h = math.min( 1, h + 0.0005 * self.vcaTickDt )
		elseif keyStatus < 0.5 then 
			h = math.max( 0, h - 0.0005 * self.vcaTickDt )
		end 
		
		self:vcaSetState( "vcaHandthrottle", vehicleControlAddon.mbClamp( h, 0, 1 ) )

		if h <= 0 then 
			self.vcaHandthrottle2 = nil 
		end 
		
		if not isAnalog then 
			if h <= 0 then 
				self:vcaSetState( "vcaWarningText", vehicleControlAddon.getText( "vcaHANDTHROTTLE", "" )..": off" )
			elseif  self.spec_motorized ~= nil 
					and self.spec_motorized.motor ~= nil 
					and self.spec_motorized.motor.maxRpm ~= nil 
					and self.spec_motorized.motor.maxRpm > 0 then 
				local r = self.spec_motorized.motor.minRpm + h * ( self.spec_motorized.motor.maxRpm - self.spec_motorized.motor.minRpm )
				self:vcaSetState( "vcaWarningText", string.format("%s: %4.0f %s", vehicleControlAddon.getText( "vcaHANDTHROTTLE", "" ), r, vehicleControlAddon.getText( "vcaValueRPM", "RPM"  ) ) )
			end 
		end 
		
  elseif actionName == "vcaLowerF" then 
		vehicleControlAddon.setToolStateRec( self, true, false, true, false )
  elseif actionName == "vcaLowerB" then 
		vehicleControlAddon.setToolStateRec( self, true, false, false, true )
  elseif actionName == "vcaActivateF" then 
		vehicleControlAddon.setToolStateRec( self, false, true, true, false )
  elseif actionName == "vcaActivateB" then 
		vehicleControlAddon.setToolStateRec( self, false, true, false, true )
	end
end

function vehicleControlAddon.setToolStateRec( self, lowered, active, front, back, forceState )

-- AttacherJoints:handleLowerImplementByAttacherJointIndex(attacherJointIndex, direction)
-- if direction == nil then direction = not attacherJoint.moveDown end


--  if self:getCanToggleTurnedOn() and self:getCanBeTurnedOn() then self:setIsTurnedOn(not self:getIsTurnedOn()) ...

	local newState  = forceState 
	local recursive = true 

	if self.spec_attacherJoints ~= nil then 
		vehicleControlAddon.debugPrint(tostring(self.configFileName)..": "..tostring(lowered)..", "..tostring(active)..", "..tostring(front)..", "..tostring(back)..", "..tostring(forceState))
	
		local spec = self.spec_attacherJoints
		for _,attachedImplement in pairs( spec.attachedImplements ) do 
			local jointDesc = spec.attacherJoints[attachedImplement.jointDescIndex]
			
			local doit = false 
			if front and back then 
				doit = true 
			else 
				local wx, wy, wz = getWorldTranslation(jointDesc.jointTransform)
				local lx, ly, lz = worldToLocal(self.steeringAxleNode, wx, wy, wz)
				
				if lz > 0 then 
					doit = front 
				else 
					doit = back 
				end 
			end 
			
			if doit and attachedImplement.object ~= nil then 
				local object = attachedImplement.object 
				
				if lowered then -- key V
					if newState == nil then 
						-- getIsLowered is overwritte by Pickup and Foldable 
						-- but getAllowsLowering is not overwritten 
						if     object:getAllowsLowering()
								or object.spec_pickup     ~= nil
								or ( object.spec_foldable ~= nil 
								 and object.spec_foldable.foldMiddleAnimTime ~= nil
								 and object:getIsFoldMiddleAllowed())
								then 
							newState = not object:getIsLowered()
						end 
					end 
					
					if newState ~= nil and object.setLoweredAll ~= nil then 
						object:setLoweredAll(newState, attachedImplement.jointDescIndex)
					end 
				end 
				
				if active then -- key B
					if object.spec_plow ~= nil then 
						-- rotate plow
						local spec = object.spec_plow
						if spec.rotationPart.turnAnimation ~= nil then
							if object:getIsPlowRotationAllowed() then
								object:setRotationMax(not spec.rotationMax)
								recursive = false 
							end
						end
					elseif object.getIsTurnedOn ~= nil then 
						-- turn on 
						if newState == nil then 
							newState = not object:getIsTurnedOn() 
						end 
						
						if object:getCanToggleTurnedOn() and object:getCanBeTurnedOn() then
							object:setIsTurnedOn(newState)
						end 
					end 
				end 
				
				if recursive then
					vehicleControlAddon.setToolStateRec( object, lowered, active, true, true, newState )
				end 
			end 
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
		local curSnapAngle, _, curSnapOffset = self:vcaGetCurrentSnapAngle( d )
		local dx    = math.sin( curSnapAngle )
		local dz    = math.cos( curSnapAngle )			
		local distX = wx - self.vcaLastSnapPosX
		local distZ = wz - self.vcaLastSnapPosZ 	
		local dist  = distX * dz - distZ * dx + self.vcaSnapFactor * self.vcaSnapDistance

		while dist+dist > self.vcaSnapDistance do 
			self:vcaSetState( "vcaSnapFactor", self.vcaSnapFactor - 1 )
			dist  = distX * dz - distZ * dx + self.vcaSnapFactor * self.vcaSnapDistance + curSnapOffset
		end 
		while dist+dist <-self.vcaSnapDistance do 
			self:vcaSetState( "vcaSnapFactor", self.vcaSnapFactor + 1 )
			dist  = distX * dz - distZ * dx + self.vcaSnapFactor * self.vcaSnapDistance + curSnapOffset
		end 			
	end 
end

function vehicleControlAddon:onEnterVehicle( isControlling )
	self:vcaSetState( "vcaIsEnteredMP", true )
	self:vcaSetState( "vcaIsBlocked", false )
	self:vcaSetState( "vcaKSIsOn", self.vcaKSToggle )
end 

function vehicleControlAddon:onLeaveVehicle()
	if self.vcaIsEntered then 
		if self.vcaShifterUsed then
			self:vcaSetState( "vcaShifterUsed", false )
			self:vcaSetState( "vcaShifterPark", false )
			self:vcaSetState( "vcaNeutral", false )
		end 
		self:vcaSetState( "vcaNoAutoRotBack", false )
		self.vcaNewRotCursorKey  = nil
		self.vcaPrevRotCursorKey = nil
		self:vcaSetState( "vcaSnapIsOn", false )
		self:vcaSetState( "vcaInchingIsOn", false )
		self:vcaSetState( "vcaKSIsOn", false )
		self:vcaSetState( "vcaIsEnteredMP", false )
		self:vcaSetState( "vcaIsBlocked", false )
		self:vcaSetState( "vcaShuttleFwd", true )	
		self:vcaSetState( "vcaCamFwd", true )
		self.vcaMovingDir     = 1
		self.vcaKeepCamRot    = false 
		self.vcaClutchPercent = 0
	end 

	self.vcaIsEntered  = false 
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
	if     self.vcaHiredWorker <= 0 then 
		return false 
--elseif not self:vcaGetNoIVT()      then 
--	return false 
	elseif self.vcaHiredWorker >= 2 then 
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
		if      self.vcaAutoShift 
				and self:vcaGetNoIVT()
				and self.vcaGearbox ~= nil
				and ( self.vcaGearbox.autoShiftGears or self.vcaGearbox.autoShiftRange ) then 
			
			local autoGears = self.vcaGearbox.autoShiftGears 
			local autoRange = self.vcaGearbox.autoShiftRange 
			
			if not autoGears then 
			elseif self:vcaGetIsReverse() and self.vcaSingleReverse > 0 then 
				autoGears = false 
			elseif self.vcaShifterUsed then 
				autoGears = false 
			end 

			if not autoRange then 
			elseif self:vcaGetIsReverse() and self.vcaSingleReverse < 0 then 
				autoRange = false 
			elseif self.vcaShifterUsed then 
				autoRange = self.vcaGearbox:getG27ShifterOnGears()
			end 
			 			
			return autoGears or autoRange
		end 
		
		return false 
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
			if self.vcaClutchPercent >= 1 or self.vcaNeutral or ( self.vcaShifterUsed and self.vcaShifterPark ) then 
				return true 
			end 
			return false 
		end 
	end 
	return false  
end 

function vehicleControlAddon:vcaGetIsReverse()
	if self:vcaGetShuttleCtrl() then 
		return not self.vcaShuttleFwd 
	elseif  self.isServer
			and self.spec_motorized ~= nil 
			and self.spec_motorized.motor ~= nil 
			and self.spec_motorized.motor.vcaLastFwd ~= nil then 
		return not self.spec_motorized.motor.vcaLastFwd
	elseif g_currentMission.missionInfo.stopAndGoBraking then
		local movingDirection = self.movingDirection * self.spec_drivable.reverserDirection
		if math.abs( self.lastSpeed ) < 0.000278 then
			return false 
		end
		return movingDirection < 0
	elseif self.nextMovingDirection ~= nil and self.spec_drivable.reverserDirection ~= nil then 
		return self.nextMovingDirection * self.spec_drivable.reverserDirection < 0
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

function vehicleControlAddon:vcaHasDiffFront()
	if not ( self.vcaDiffManual and self.vcaDiffHasF ) then 
		return false 
	end 
	if not self.vcaDiffHas2     then 
		return true 
	elseif self.vcaDiffLockSwap then 
		return true 
	elseif self.vcaDiffLockAWD  then 
		return true 
	end 
	return false 
end 

function vehicleControlAddon:vcaHasDiffAWD()
	if not ( self.vcaDiffManual and self.vcaDiffHasM ) then 
		return false 
	end 
	return true 
end 
	
function vehicleControlAddon:vcaHasDiffBack()
	if not ( self.vcaDiffManual and self.vcaDiffHasB ) then 
		return false 
	end 
	if not self.vcaDiffHas2     then 
		return true 
	elseif not self.vcaDiffLockSwap then 
		return true 
	elseif self.vcaDiffLockAWD  then 
		return true 
	end 
	return false 
end 
		
function vehicleControlAddon:vcaGetDiffState()
	if not ( self.vcaIsLoaded
			 and ( self:vcaIsVehicleControlledByPlayer() or ( self.vcaHiredWorker2 and self:getIsActive() ) )
			 and self:getIsMotorStarted()
			 and self.vcaDiffManual ) then  
	-- hired worker or motor off 
		return 0, 0, 0
	elseif  not self.vcaDiffHasF 
			and not self.vcaDiffHasM 
			and not self.vcaDiffHasB then
	-- no diffs or not the standard pattern
		return 0, 0, 0 
	end 
	
	local f, m, b = 0, 0, 0
	
	if self:vcaHasDiffFront() then 
		if self.vcaDiffLockFront then 
			f = 2 
		else 
			f = 1 
		end 
	end 
	
	if self:vcaHasDiffBack() then 
		if self.vcaDiffLockBack then 
			b = 2 
		else 
			b = 1 
		end 
	end 
	
	if self:vcaHasDiffAWD() then 
		if self.vcaDiffLockAWD then 
			m = 2 
		else 
			m = 1
		end 
	end 
	
	return f, m, b
end 


function vehicleControlAddon:vcaGetTransmissionDef()
	if self.vcaTransmission == vehicleControlAddonTransmissionBase.ownTransmission then 
		local params = {}
--( name, noGears, timeGears, rangeGearOverlap, timeRanges, gearRatios, autoGears, autoRanges, splitGears4Shifter, gearTexts, rangeTexts, shifterIndexList, speedMatching )
		params.noGears   = self.vcaOwnGears
		params.rangeGearOverlap = {}
		for i=2,self.vcaOwnRanges do	
			table.insert( params.rangeGearOverlap, 0 )
		end 
		
		if self.vcaOwnGears > 1 and self.vcaOwnRanges >= 1 then 
			local g = vehicleControlAddon.mbClamp( self.vcaOwnGearFactor,  0.01, 0.99 ) ^ ( 1 / math.max( 1, self.vcaOwnGears  - 1 ) ) 
			local r = vehicleControlAddon.mbClamp( self.vcaOwnRangeFactor, 0.01, 0.99 )
			local j = self.vcaOwnRanges * self.vcaOwnGears
			local k = self.vcaOwnGears
			params.gearRatios    = {}
			params.gearRatios[j] = 1 
			
			while true do 
				j = j - 1
				if j < 1 then 
					break 
				end 
				k = k - 1
				if k < 1 then 
					k = self.vcaOwnGears
					params.gearRatios[j] = params.gearRatios[j + self.vcaOwnGears] * r 
				else 
					params.gearRatios[j] = params.gearRatios[j + 1] * g
				end 
			end 
		end 
			
		params.timeGears  = self.vcaOwnGearTime
		params.timeRanges = self.vcaOwnRangeTime
		params.autoGears  = self.vcaOwnAutoGears
		params.autoRanges = self.vcaOwnAutoRange
		
		return vehicleControlAddonTransmissionBase:new( params ) 
	end 
	
	local def = vehicleControlAddonTransmissionBase.transmissionList[self.vcaTransmission]
	if def ~= nil then 
		return def.class:new( def.params )
	end 	
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
			
			local rso = 1
			if not ( 0.49 < self.vcaRotSpeedOut and self.vcaRotSpeedOut < 0.51 ) then 
				rso = vehicleControlAddon.mbClamp( self.vcaRotSpeedOut + self.vcaRotSpeedOut, 0.01, 2 )
			end 
			local rsi = 1
			if math.abs( self.vcaRotSpeedIn - self.vcaRotSpeedOut ) > 0.01 then 
				rsi = vehicleControlAddon.mbClamp( self.vcaRotSpeedIn + self.vcaRotSpeedIn, 0.01, 2 ) / rso 
			end 
			
			if noARB or ( not self.vcaLastAxisSteerAnalog and math.abs( self.spec_drivable.lastInputValues.axisSteer ) > 0.01 ) then 
				local f = dt * 0.0005
				if self.vcaLastAxisSteerAnalog then 
					f = dt * 0.002
				elseif s < 1 then 
					f = dt * 0.001
				elseif ( self.vcaLastAxisSteer > 0 and self.spec_drivable.lastInputValues.axisSteer < 0 )
						or ( self.vcaLastAxisSteer < 0 and self.spec_drivable.lastInputValues.axisSteer > 0 ) then 
					f = rsi * dt * 0.002 * math.min( 1, 0.25 + math.abs( self.vcaLastAxisSteer ) * 2 )	
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
				f = f * rso
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
	self.vcaAIEndTime = g_currentMission.time
end 	

function vehicleControlAddon:onUpdate(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)

	self.vcaTickDt = dt
	
	local lastIsEntered = self.vcaIsEntered

	if self.isClient and self.getIsEntered ~= nil and self:getIsControlled() and self:getIsEntered() then 
		self.vcaIsEntered = true
		self:vcaSetState( "vcaIsEnteredMP", true )
		if not g_gui:getIsGuiVisible() then 
			self:vcaSetState( "vcaIsBlocked", false )
		elseif g_gui.currentGui ~= nil and g_gui.guis.ChatDialog ~= nil and g_gui.currentGui == g_gui.guis.ChatDialog then 
			self:vcaSetState( "vcaIsBlocked", false )
		else
			self:vcaSetState( "vcaIsBlocked", true )
		end
	else 
		self.vcaIsEntered = false 
	end 	
	
	if self.vcaIsLoaded and not self:vcaIsVehicleControlledByPlayer() and self.vcaClutchPercent > 0 then 
		self.vcaClutchPercent = 0
	end 
	
	if self.vcaHandthrottle ~= nil and self.vcaHandthrottle > 0 then 
		self.vcaHandthrottle2 = self.vcaHandthrottle 
	end 
	
	
	if self.vcaIsEntered then
		self.vcaKeepCamRot     = self.vcaKeepRotPressed 
		self.vcaKeepRotPressed = false 
		
		local krToggle = self.vcaKRToggleOut
		if self.vcaCamIsInside then 
			krToggle = self.vcaKRToggleIn 
		end 
		if krToggle then 
			self.vcaKeepCamRot = not self.vcaKeepCamRot
		end
		
		self:vcaSetState( "vcaInchingIsOn", self.vcaInchingPressed )

		local isPressed = self.vcaKeepSpeedPressed
		if self.vcaKSToggle then 
			isPressed = not isPressed
		end 
		if isPressed and not self.vcaKSIsOn then 
			self:vcaSetState( "vcaKeepSpeed", self.lastSpeed * 3600 )
		end 
		self:vcaSetState( "vcaKSIsOn", isPressed )

		self.vcaKeepRotPressed   = false 
		self.vcaInchingPressed   = false 
		self.vcaKeepSpeedPressed = false 	
	elseif not self.vcaIsEnteredMP then 
		self.vcaKeepCamRot = false 
		self:vcaSetState( "vcaInchingIsOn", false )
		self:vcaSetState( "vcaKSIsOn", false )
	end 
	
	--*******************************************************************
	-- G27 mode
	if self.vcaIsEntered then
		if not ( lastIsEntered ) then 
			local bits = self.vcaShifterUsed2
			self:vcaSetState( "vcaShifterUsed", self.vcaShifterUsed2 >= 1 )
			if self.vcaShifterUsed2 > 0 then 
				self:vcaSetState( "vcaShuttleFwd", bits >= 16 )
				if bits >= 16 then bits = bits - 16 end 
				self:vcaSetState( "vcaShifter7isR1", bits >= 8 )
				if bits >= 8 then bits = bits - 8 end 
				self:vcaSetState( "vcaShifterPark", bits >= 4 )
				if bits >= 8 then bits = bits - 4 end 
				self:vcaSetState( "vcaNeutral", bits >= 2 )
				if bits >= 8 then bits = bits - 2 end 
			end
		else 
			self.vcaShifterUsed2 = 0
			if self.vcaShifterUsed then 
				self.vcaShifterUsed2 = 1
				if self.vcaNeutral      then self.vcaShifterUsed2 = self.vcaShifterUsed2 +  2 end 
				if self.vcaShifterPark  then self.vcaShifterUsed2 = self.vcaShifterUsed2 +  4 end 
				if self.vcaShifter7isR1 then self.vcaShifterUsed2 = self.vcaShifterUsed2 +  8 end 
				if self.vcaShuttleFwd   then self.vcaShifterUsed2 = self.vcaShifterUsed2 + 16 end 
			end 
		end 
	end 
	
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
	
	if self.isServer and self.vcaShifterPark and not self.vcaShifterUsed then 
		self:vcaSetState( "vcaShifterPark", false )
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
		local lt = self.vcaLastTransmission
		self.vcaLastTransmission = self.vcaTransmission
		
		vehicleControlAddon.mpDebugPrint( self, "*********************************************" )
		vehicleControlAddon.mpDebugPrint( self, tostring(self.configFileName))
		vehicleControlAddon.mpDebugPrint( self, "Old transmission: "..tostring(self.vcaLastTransmission)..", new transmission: "..tostring(self.vcaTransmission))
		
		if self.vcaGearbox ~= nil then 
			self.vcaGearbox:delete()
			self.vcaGearbox = nil
		end 
		
		self.vcaGearbox = vehicleControlAddon.vcaGetTransmissionDef( self )
		
		if self.vcaGearbox ~= nil then 
			self.vcaGearbox:setVehicle( self )
		end 
		
		if self.isServer then		
			if self.vcaGearbox ~= nil then 
				if      lt == nil or lt <= 1 then 
				elseif  self.vcaGear  ~= nil and self.vcaGear  > 0
						and self.vcaRange ~= nil and self.vcaRange > 0
						then  
					if self.vcaLastGearRange == nil then 
						self.vcaLastGearRange = {}
					end 
					self.vcaLastGearRange[lt] = { self.vcaGear, self.vcaRange }
					local g,r = 0, 0
					if self.vcaLastGearRange[self.vcaTransmission] ~= nil then 
						g,r = unpack( self.vcaLastGearRange[self.vcaTransmission] )
					end 
					self:vcaSetState( "vcaGear",  Utils.getNoNil( g, 0 ))
					self:vcaSetState( "vcaRange", Utils.getNoNil( r, 0 ))
				end 
				self.vcaGearbox:initGears()	
			end 
		
			local spec = self.spec_motorized
			if spec.motorizedNode ~= nil and next(spec.differentials) ~= nil then
				self:updateMotorProperties()
			end 
		end 
				
		vehicleControlAddon.mpDebugPrint( self, "Gear: "..tostring(self.vcaGear)..", range: "..tostring(self.vcaRange))
		vehicleControlAddon.mpDebugPrint( self, "*********************************************" )
	end 
	
	
	local newRotCursorKey = self.vcaNewRotCursorKey
	local i               = self.spec_enterable.camIndex
	local requestedBack   = nil
	local lastWorldRotation = self.vcaCamRotWorld
			
	self.vcaNewRotCursorKey = nil
	self.vcaCamRotWorld     = nil

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
	
--if     self.spec_motorized.motor.lowBrakeForceScale == nil then
--elseif self:vcaIsActive() and 0.99 < self.vcaBrakeForce and self.vcaBrakeForce < 1.01 then 
--	if self.vcaLowBrakeForceScale == nil then 
--		self.vcaLowBrakeForceScale                 = self.spec_motorized.motor.lowBrakeForceScale
--	end 
--	self.spec_motorized.motor.lowBrakeForceScale = self.vcaBrakeForce * self.vcaLowBrakeForceScale 
--elseif self.vcaLowBrakeForceScale ~= nil then  
--	self.spec_motorized.motor.lowBrakeForceScale = self.vcaLowBrakeForceScale 
--	self.vcaLowBrakeForceScale                   = nil
--end 
	
	if not self.vcaLimitSpeed then 
		if self.vcaMaxForwardSpeed == nil then 
			self.vcaMaxForwardSpeed  = self.spec_motorized.motor.maxForwardSpeed 
			self.vcaMaxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeed
		end
		self.spec_motorized.motor.maxForwardSpeed  = vehicleControlAddon.maxRpmF1 * self.vcaMaxSpeed 
		self.spec_motorized.motor.maxBackwardSpeed = vehicleControlAddon.maxRpmF1 * self.vcaMaxSpeed 
	elseif self:vcaGetTransmissionActive() then 
		if self.vcaMaxForwardSpeed == nil then 
			self.vcaMaxForwardSpeed  = self.spec_motorized.motor.maxForwardSpeed 
			self.vcaMaxBackwardSpeed = self.spec_motorized.motor.maxBackwardSpeed
		end
		self.spec_motorized.motor.maxForwardSpeed  = self.vcaMaxForwardSpeed 
		self.spec_motorized.motor.maxBackwardSpeed = math.max( self.vcaMaxForwardSpeed, self.vcaMaxBackwardSpeed )
	elseif self.vcaMaxForwardSpeed ~= nil then 
		self.spec_motorized.motor.maxForwardSpeed  = self.vcaMaxForwardSpeed 
		self.spec_motorized.motor.maxBackwardSpeed = self.vcaMaxBackwardSpeed
		self.vcaMaxForwardSpeed  = nil
		self.vcaMaxBackwardSpeed = nil
	end 
	
	if self.vcaInchingIsOn and self.vcaIsEntered and self.spec_drivable.cruiseControl.state == Drivable.CRUISECONTROL_STATE_ACTIVE then
		local limitThrottleRatio     = 0.75
		if self.vcaLimitThrottle < 11 then
			limitThrottleRatio     = 0.45 + 0.05 * self.vcaLimitThrottle
		else
			limitThrottleRatio     = 1.5 - 0.05 * self.vcaLimitThrottle
		end
		if self.vcaSpeedLimit == nil then 
			self.vcaSpeedLimit = self:getCruiseControlSpeed()
		end 
		self:vcaSetCruiseSpeed( self.vcaSpeedLimit * limitThrottleRatio )
	elseif self.vcaSpeedLimit ~= nil then 
		self:vcaSetCruiseSpeed( self.vcaSpeedLimit )
		self.vcaSpeedLimit = nil
	end 	
	-- overwrite or reset some values 
	--*******************************************************************
	

	if self:getIsActive()and self.isServer then
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
		elseif self.nextMovingDirection ~= nil and self.spec_drivable.reverserDirection ~= nil then 
			self.vcaMovingDir = self.nextMovingDirection * self.spec_drivable.reverserDirection
		else 
			self.vcaMovingDir = 0
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
		local m
		if self.vcaShuttleCtrl  then
			if self.vcaShuttleFwd       then 
				m = 1 
			else 
				m = -1 
			end 
		elseif self.lastSpeedReal * 3600 < 0.5 then 
			m = 1
		elseif self.movingDirection < 0 then 
			m = -1 
		else
			m = 1
		end
		
		local sl = self:getSpeedLimit(true)
		
		if     self.spec_drivable.cruiseControl.state == Drivable.CRUISECONTROL_STATE_FULL then 
			self:vcaSetState( "vcaKeepSpeed", vehicleControlAddon.mbClamp( self.lastSpeedReal * 3600 * m, -sl, sl ) )
		elseif self.spec_drivable.cruiseControl.state ~= Drivable.CRUISECONTROL_STATE_OFF then 		
			self:vcaSetState( "vcaKeepSpeed", vehicleControlAddon.mbClamp( self:getCruiseControlSpeed() * m, -sl, sl ) )
			self:setCruiseControlState( Drivable.CRUISECONTROL_STATE_OFF )
		elseif math.abs( self.spec_drivable.axisForward ) < 0.1 and not self:vcaGetShuttleCtrl() and self.lastSpeedReal * 3600 < 0.5 then 
			self:vcaSetState( "vcaKeepSpeed", 0 )
		elseif math.abs( self.spec_drivable.axisForward ) > 0.01 then 
		
			local s = self.lastSpeedReal * 1000
			if self:vcaGetTransmissionActive() and self:vcaGetNoIVT() then  
				local motor = self:getMotor() 
				if motor ~= nil and motor.vcaGearRatio ~= nil then  
					s = math.max( s, ( 0.9 * motor.minRpm + 0.1 * motor.maxRpm ) / ( motor.vcaGearRatio * vehicleControlAddon.factor30pi ) )
				end 
			end 
			
			local f = 3.6 * math.max( -self.spec_motorized.motor.maxBackwardSpeed, s * self.movingDirection - 0.4 )
			local t = 3.6 * math.min(  self.spec_motorized.motor.maxForwardSpeed,  s * self.movingDirection + 0.4  )
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
				if     self.lastSpeedReal * 3600 >= 0.5 then 
					if     m > 0 then 
					  f = 0
					elseif m < 0 then
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
			
			if f < -sl then 
				f = -sl 
			end 
			if t > sl then	
				t = sl 
			end 
						
			self:vcaSetState( "vcaKeepSpeed", vehicleControlAddon.mbClamp( self.vcaKeepSpeed + a * 0.0067 * dt, f, t )  )
		elseif math.abs( self.vcaKeepSpeed ) > sl then 
			self:vcaSetState( "vcaKeepSpeed", vehicleControlAddon.mbClamp( self.vcaKeepSpeed, -sl, sl )  )
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
		self.vcaCamIsInside   = false
		
		if camera.isInside then 
			rotIsOn = self.vcaCamRotInside
		  revIsOn = self.vcaCamRevInside
			self.vcaCamIsInside = true 
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
			self.vcaCamRotWorld  = nil
			
			if self.vcaCamIsInside then 
				self.vcaKeepCamRot = self.vcaKRToggleIn 
			else 
				self.vcaKeepCamRot = self.vcaKRToggleOut 
			end 
						
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
				or revIsOn
				or self.vcaKeepCamRot
				or lastWorldRotation ~= nil then 

			local pi2 = math.pi / 2
			local eps = 1e-6
			oldRotY = camera.rotY
			local diff = oldRotY - self.vcaLastCamRotY
			
			if     self.vcaKeepCamRot then 
				self.vcaCamRotWorld = vehicleControlAddon.vcaGetRelativeYRotation(g_currentMission.terrainRootNode,self.spec_wheels.steeringCenterNode)
			elseif lastWorldRotation ~= nil then 
			-- reset to old rotation 	
			elseif newRotCursorKey ~= nil then
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
			
			if revIsOn and not ( self.vcaKeepCamRot ) then
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
			
			if self.vcaKeepCamRot then 
				if newRotCursorKey ~= nil then
					newRotY = vehicleControlAddon.normalizeAngle( camera.origRotY + newRotCursorKey )	
				else 
					newRotY = camera.rotY 
				end 
				if lastWorldRotation ~= nil then 
					newRotY = vehicleControlAddon.normalizeAngle( newRotY + ( self.vcaCamRotWorld - lastWorldRotation ) )
				end 
			elseif rotIsOn then
				
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
		self.vcaCamIsInside  = nil
		self.vcaKeepCamRot   = false  
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
			and ( math.abs( self.vcaLastRpmFactor - self.vcaRpmFactor ) > 0.01 or ( self.vcaRpmFactor == 1 and self.vcaLastRpmFactor ~= 1 ) )
			then 
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
		if self:vcaGetTransmissionActive() and self.vcaModifyPitch then 
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
	if self.isServer and self:getIsActive() and self.vcaIsLoaded and self.firstTimeRun then  
		if      self.vcaDiffManual 
				and not self.vcaDiffHasF
				and not self.vcaDiffHasM
				and not self.vcaDiffHasB then 
			self:vcaSetState( "vcaDiffManual", false )
		end 
	
		local spec = self.spec_motorized 
		local gearRatio = 0
		if spec.motor ~= nil and spec.motor.gearRatio ~= nil then 
			gearRatio = spec.motor.gearRatio
		end 
		
		if      VCAGlobals.turnOffAWDSpeed > 0
				and self.lastSpeed * 3600 > VCAGlobals.turnOffAWDSpeed
				and self:vcaIsVehicleControlledByPlayer() then 
			self:vcaSetState( "vcaDiffLockFront", false )
			self:vcaSetState( "vcaDiffLockBack",  false )
			if self.vcaDiffFrontAdv then  
				self:vcaSetState( "vcaDiffLockAWD", false )
			end 
		end 
		
		local a = false 
		if self:vcaIsVehicleControlledByPlayer() and self:getIsMotorStarted() and not self:vcaGetNeutral() then  
			a = self.vcaAntiSlip
		end 

		local f, m, b = self:vcaGetDiffState()
		
		local updateDiffs  = false 
		local vehicleSpeed = self.lastSpeedReal*1000*self.movingDirection
		local avgWheelSpeed,n=0,0
		local minWheelSpeed, maxWheelSpeed
		
		self.vcaDebugS = debugFormat("%6.3f",vehicleSpeed)
			
		for _,wheel in pairs(self.spec_wheels.wheels) do 
			wheel.vcaDiffBrake = nil 
			wheel.vcaMaxSpeed  = nil
			wheel.vcaAttached  = false 
		end 
			
		local function updateWheelSpeed( wheel )
			wheel.vcaDiffBrake = nil 
			wheel.vcaMaxSpeed  = nil
			local s = getWheelShapeAxleSpeed(wheel.node, wheel.wheelShape) * wheel.radius 
			if wheel.vcaSpeed == nil then 
				wheel.vcaSpeed = s 
			else 
				wheel.vcaSpeed = wheel.vcaSpeed + 0.08 * ( s - wheel.vcaSpeed )
			end 
			self.vcaDebugS = self.vcaDebugS..debugFormat(", %6.3f",wheel.vcaSpeed)
			avgWheelSpeed = avgWheelSpeed + wheel.vcaSpeed
			n = n + 1 
			if minWheelSpeed == nil or minWheelSpeed > wheel.vcaSpeed then 
				minWheelSpeed = wheel.vcaSpeed 
			end 
			if maxWheelSpeed == nil or maxWheelSpeed < wheel.vcaSpeed then 
				maxWheelSpeed = wheel.vcaSpeed 
			end 
		end 
		
		for d,diff in pairs(spec.differentials) do 
			diff.vcaEnabled = 3 
			if diff.diffIndex1IsWheel then
				local wheel = self:getWheelFromWheelIndex( diff.diffIndex1 )
				updateWheelSpeed( wheel )
			end
			if diff.diffIndex2IsWheel then
				local wheel = self:getWheelFromWheelIndex( diff.diffIndex2 )
				updateWheelSpeed( wheel )
			end 
		end 					
			
		if n > 1 then avgWheelSpeed = avgWheelSpeed / n end 	
			
		if minWheelSpeed ~= nil and avgWheelSpeed ~= nil and maxWheelSpeed ~= nil then 
			self.vcaDebugS = self.vcaDebugS..debugFormat("\n%6.3f .. %6.3f .. %6.3f",minWheelSpeed, avgWheelSpeed, maxWheelSpeed)
		end 
		
		if minWheelSpeed == nil or minWheelSpeed < 1 then 
			minWheelSpeed = 1 
		end 
		if maxWheelSpeed == nil or maxWheelSpeed > -1 then 
			maxWheelSpeed = -1 
		end 

		if a then  
			if     gearRatio > 0 then
				for _,wheel in pairs(self.spec_wheels.wheels) do
					wheel.vcaMaxSpeed = 1.1 * minWheelSpeed 
				end 
			elseif gearRatio < 0 then 
				for _,wheel in pairs(self.spec_wheels.wheels) do
					wheel.vcaMaxSpeed = 1.1 * maxWheelSpeed 
				end 
			end 
		end 
		
	
		
		local function setMaxSpeed( index, isWheel, maxSpeed, allWheels )
			if maxSpeed == nil then 
				return 
			end 
			if isWheel then
				local wheel = self:getWheelFromWheelIndex( index )
				if wheel.vcaMaxSpeed == nil or wheel.vcaMaxSpeed > maxSpeed then 
					wheel.vcaMaxSpeed = maxSpeed 
				end 
			else
				local diff = spec.differentials[index+1]
				diff.vcaMaxSpeed = maxSpeed 
				if allWheels then 
					setMaxSpeed( diff.diffIndex1, diff.diffIndex1IsWheel, maxSpeed, allWheels )
					setMaxSpeed( diff.diffIndex2, diff.diffIndex2IsWheel, maxSpeed, allWheels )
				end 
			end
		end			

    local function getDiffSpeed(index)
			local speed1, speed2
			local diff = spec.differentials[index]
			if diff.diffIndex1IsWheel then
				local wheel = self:getWheelFromWheelIndex( diff.diffIndex1 )
				speed1 = wheel.vcaSpeed
			else
				local s1,s2 = getDiffSpeed(diff.diffIndex1+1);
				speed1 = (s1+s2)/2
			end
			if diff.diffIndex2IsWheel then
				local wheel = self:getWheelFromWheelIndex( diff.diffIndex2 )
				speed2 = wheel.vcaSpeed
			else
				local s1,s2 = getDiffSpeed(diff.diffIndex2+1);
				speed2 = (s1+s2)/2
			end
			return speed1,speed2;
    end
		
		local function disableDiff( index, isWheel )
			if not isWheel then
			--vehicleControlAddon.debugPrint( "Disabling diff(3) "..tostring(index) )
				local diff = spec.differentials[index+1]
				diff.vcaEnabled = 0
				disableDiff( diff.diffIndex1, diff.diffIndex1IsWheel ) 
				disableDiff( diff.diffIndex2, diff.diffIndex2IsWheel ) 
			end 
		end 

    local function getClosedTorqueRatio(r0, s1, s2, m0)
			local r = r0 
			local m = Utils.getNoNil( m0, vehicleControlAddon.speedRatioClosed1 )
			
			if gearRatio < 0 then 
				s1 = -s1
				s2 = -s2 
			end 
				
			if     s1 < 0.1389 and s2 < 0.1389 then 
			elseif not ( -0.2778 < s1 and s1 < 90 
			         and -0.2778 < s2 and s2 < 90 ) then 
				m = math.max( m, vehicleControlAddon.speedRatioClosed1 )
			elseif s1 < s2 then  
				q = ( math.max( s1, 0 ) / s2 ) 
				r =  1 - q * ( 1 - r )
				m = math.max( m, 1 + ( vehicleControlAddon.speedRatioClosed1 - 1 ) * ( 1 - q ) )
			elseif s2 < s1 then 
				q = ( math.max( s2, 0 ) / s1 ) 
				r = r * q
				m = math.max( m, 1 + ( vehicleControlAddon.speedRatioClosed1 - 1 ) * ( 1 - q ) )
			end 
			
			if math.abs( r - r0 ) < 0.05 then 
				r = r0 
			end 
							
			return r, m
		end
		
		local function setDiff( index, newState, torqueRatioOpen, advanceSpeed )
		
			-- torqueRatio = 1 => all power goes to 1st part 
			-- torqueRatio = 0 => all power goes to 2nd part 
		
			if index <= 0 then 
				return 0
			end 
			
			local diff  = spec.differentials[index]		
			
			if newState == nil or diff.vcaEnabled <= 0 then 
				newState = 0 
			end 
			
			local r, m   = diff.vcaTorqueRatio, diff.vcaMaxSpeedRatio
			local r1, r2 = vehicleControlAddon.minTorqueRatio, 1-vehicleControlAddon.minTorqueRatio
			
			if     newState == 1 then 
				if torqueRatioOpen ~= nil then 
					r = torqueRatioOpen
				end 

				if r1 <= r and r <= r2 and vehicleControlAddon.distributeTorqueOpen then  
					-- inverse torque ratio => put more torque on turning wheel
					local s1,s2 = getDiffSpeed(index)
					r = vehicleControlAddon.mbClamp( getClosedTorqueRatio( r, s2, s1 ), r1, r2 )		
				end 				
				m = vehicleControlAddon.speedRatioOpen
			elseif newState == 2 then 			
				if vehicleControlAddon.speedRatioClosed0 >= 0 then 
					m = vehicleControlAddon.speedRatioClosed0 
				end 

				local s1,s2 = getDiffSpeed(index)
				
				-- advance speed by 7% (minus 2% error)
				if     torqueRatioOpen == nil or not self.vcaDiffFrontAdv then  
				elseif torqueRatioOpen > r2 then 
					m  = math.max( m, vehicleControlAddon.speedRatioClosed2 )
					s1 = s1 * 1.035
					s2 = s1 / 1.035
				elseif torqueRatioOpen < r1 then 
					m  = math.max( m, vehicleControlAddon.speedRatioClosed2 )
					s1 = s1 / 1.035
					s2 = s2 * 1.035
				end 
				
				r, m = getClosedTorqueRatio( r, s1, s2, m )
				r = vehicleControlAddon.mbClamp( r, r1, r2 )
			end 
			
			local ovr = "vcaOvrDT"..tostring(index) 
			if self[ovr] ~= nil and self[ovr] >= 0 then 
				r = self[ovr]
			end 
			local ovr = "vcaOvrDM"..tostring(index) 
			if self[ovr] ~= nil and self[ovr] >= 0 then 
				m = self[ovr] 
			end 
			
			if newState > 0 then 
				if     r > r2 then 
					if diff.diffIndex2IsWheel then
						r = r2
					else 
						r = 1
						diff.vcaEnabled = 1  						
						disableDiff( diff.diffIndex2, diff.diffIndex2IsWheel ) 
					end 
				elseif r < r1 then 
					if diff.diffIndex1IsWheel then                              
						r = r1
					else 
						r = 0
						diff.vcaEnabled = 2                            
						disableDiff( diff.diffIndex1, diff.diffIndex1IsWheel )
					end 			
				end 
				if m < 1 then 
					m = 1 
				end 
			end 			
			
			local eOld = ( r1 <= diff.torqueRatio and diff.torqueRatio <= r2 ) 
			local eNew = ( r1 <= r and r <= r2 )
			
			if     eOld ~= eNew then 
				diff.torqueRatio    = r 
				diff.maxSpeedRatio  = m
				updateDiffs        = true 
			elseif math.abs( diff.torqueRatio - r ) > 1e-3 or math.abs( diff.maxSpeedRatio - m ) > 1e-3 then 
				diff.torqueRatio   = r 
				diff.maxSpeedRatio = m
				if diff.vcaIndex ~= nil and diff.vcaIndex >= 0 then 
					updateDifferential( spec.motorizedNode, diff.vcaIndex, diff.torqueRatio, diff.maxSpeedRatio )
				end 
			end 
					
			return newState 
		end 
		
		local vanilla = false 
		if f <= 0 and m <= 0 and b <= 0 then 
			if self.vcaDiffHasF or self.vcaDiffHasM or self.vcaDiffHasB then
				for i=#spec.differentials,1,-1 do 
					setDiff( i, 0 )
				end 
			end 
		else 
			for i=#spec.differentials,1,-1 do 
				local diff = spec.differentials[i] 
				if     diff.vcaMode == 'M' then 
					local o = diff.vcaTorqueRatioOpen 
					if o ~= nil and self.vcaDiffLockSwap then 
						o = 1 - o 
					end 
					setDiff( i, m, o ) 
				elseif diff.vcaMode == 'B' then 
					setDiff( i, b ) 
				elseif diff.vcaMode == 'F' then 
					setDiff( i, f ) 
				else 
					setDiff( i, 0 )
				end 
			end 
		end 
				
		if updateDiffs then 		
			--re-create all diffs
			removeAllDifferentials( spec.motorizedNode ) 

			local diffMap = {}			
			local j = 0
			for i, differential in pairs(spec.differentials) do
				if     differential.vcaEnabled == 1 then 	
					if not differential.diffIndex1IsWheel then
						diffMap[i-1] = diffMap[differential.diffIndex1]
					else
						print("Error: VCA differential "..tostring(i-1).." is partly disabled ("..tostring(differential.vcaEnabled)..") but contains wheels")
					end 
				elseif differential.vcaEnabled == 2 then 
					if not differential.diffIndex2IsWheel then
						diffMap[i-1] = diffMap[differential.diffIndex2]
					else
						print("Error: VCA differential "..tostring(i-1).." is partly disabled ("..tostring(differential.vcaEnabled)..") but contains wheels")
					end 
				elseif differential.vcaEnabled == 3 then 
					diffMap[i-1] = j
					j = j + 1
				end 
			end 
			
			j = 0
			for i, differential in pairs(spec.differentials) do
				vehicleControlAddon.debugPrint("Diff "..tostring(i-1).." s: "..tostring(differential.vcaEnabled)
																														..", v: "..tostring(differential.vcaMode)
																														..", t: "..tostring(differential.torqueRatio)
																														..", m: "..tostring(differential.maxSpeedRatio))
				if differential.vcaEnabled == 3 then 
					local diffIndex1 = differential.diffIndex1
					local diffIndex2 = differential.diffIndex2
					if differential.diffIndex1IsWheel then
						local wheel = self:getWheelFromWheelIndex(diffIndex1)
						wheel.vcaAttached = true 
						diffIndex1 = wheel.wheelShape
					else 
						vehicleControlAddon.debugPrint("1: New index of "..tostring(diffIndex1).." is "..tostring(diffMap[diffIndex1]))
						diffIndex1 = diffMap[diffIndex1]
					end
					if differential.diffIndex2IsWheel then
						local wheel = self:getWheelFromWheelIndex(diffIndex2)
						wheel.vcaAttached = true 
						diffIndex2 = wheel.wheelShape
					else 
						vehicleControlAddon.debugPrint("2: New index of "..tostring(diffIndex2).." is "..tostring(diffMap[diffIndex2]))
						diffIndex2 = diffMap[diffIndex2]
					end
					if diffIndex1 == nil or diffIndex2 == nil then 
						print("Error: VCA calculation of differential "..tostring(i-1)
																				.." failed: "..tostring(diffIndex1)
																							.. ", "..tostring(differential.diffIndex1)
																							.. ", "..tostring(differential.diffIndex1IsWheel)
																							.. ", "..tostring(diffIndex2)
																							.. ", "..tostring(differential.diffIndex2)
																							.. ", "..tostring(differential.diffIndex2IsWheel))
					else 
						differential.vcaIndex = j
						j = j + 1 
						addDifferential( spec.motorizedNode,
														 diffIndex1,
														 differential.diffIndex1IsWheel,
														 diffIndex2,
														 differential.diffIndex2IsWheel,
														 differential.torqueRatio,
														 differential.maxSpeedRatio )
					end 
				else 
					differential.vcaIndex = -1
				end 
			end
			self:updateMotorProperties()
		else 
			-- mark wheels attached to diff
			for i, differential in pairs(spec.differentials) do
				if differential.vcaEnabled == 3 then 
					local diffIndex1 = differential.diffIndex1
					local diffIndex2 = differential.diffIndex2
					if differential.diffIndex1IsWheel then
						local wheel = self:getWheelFromWheelIndex(diffIndex1)
						wheel.vcaAttached = true 
					end
					if differential.diffIndex2IsWheel then
						local wheel = self:getWheelFromWheelIndex(diffIndex2)
						wheel.vcaAttached = true 
					end
				end 
			end
		end 
		
		self.vcaDebugD = nil
		if VCAGlobals.debugPrint then 
			for i, differential in pairs(spec.differentials) do
				if self.vcaDebugD == nil then 
					self.vcaDebugD = ""
				else 
					self.vcaDebugD = self.vcaDebugD .. string.format("\n")
				end 

				local s1,s2 = getDiffSpeed(i)
				
				self.vcaDebugD = self.vcaDebugD .. string.format( "%d: (%d, %d, %s), speed: %6.3f, %6.3f => tr: %6.3f sr: %6.1f",
																													i, 
																													Utils.getNoNil( differential.vcaEnabled, -1 ),
																													Utils.getNoNil( differential.vcaIndex, -1 ),
																													Utils.getNoNil( differential.vcaMode, '?' ),
																													s1, s2,
																													differential.torqueRatio,
																													differential.maxSpeedRatio )
			end 
		end 
		
		self.vcaDebugB = ""
		if not self:vcaGetNeutral() then 
			for _,wheel in pairs(self.spec_wheels.wheels) do 
				if     wheel.vcaMaxSpeed == nil or not ( wheel.vcaAttached ) then 
				elseif gearRatio > 0 and wheel.vcaSpeed > wheel.vcaMaxSpeed then 
					wheel.vcaDiffBrake = math.min( wheel.vcaSpeed - wheel.vcaMaxSpeed, 5 ) * 4
				elseif gearRatio < 0 and wheel.vcaSpeed < wheel.vcaMaxSpeed then     
					wheel.vcaDiffBrake = math.min( wheel.vcaMaxSpeed - wheel.vcaSpeed, 5 ) * 4
				end 
				if wheel.vcaDiffBrake == nil then 
					self.vcaDebugB = self.vcaDebugB.." nil   "
				else
					self.vcaDebugB = self.vcaDebugB..debugFormat("%6.3f ",wheel.vcaDiffBrake)
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
	                   "vcaLaunchSpeed",  
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
			and not ( self.spec_aiVehicle ~= nil and self.spec_aiVehicle.isActive )
			and not ( self.ad ~= nil and self.ad.isActive  ) 
			and not ( self.cp ~= nil and self.cp.isDriving )
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
		elseif ( self.vcaNeutral and not self.vcaShifterUsed ) or ( self.vcaShifterPark and self.vcaShifterUsed ) then 
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
			elseif math.abs( self.lastSpeed * 3600 ) < 0.5 then 
			elseif self.vcaCamFwd then 
				renderOverlay( vehicleControlAddon.ovArrowUpGray, x-0.5*w, y-0.5*h, w, h )
			else 
				renderOverlay( vehicleControlAddon.ovArrowDownGray, x-0.5*w, y-0.5*h, w, h )
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
			if self.vcaShifterUsed and not self.vcaShifterPark then 
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
		local curSnapAngle, curSnapOffset1, curSnapOffset2 = self:vcaGetCurrentSnapAngle( d )
		
		if self.vcaDrawHud then 
			if VCAGlobals.snapAngleHudX >= 0 then
				x = VCAGlobals.snapAngleHudX
				setTextAlignment( RenderText.ALIGN_LEFT ) 
			end 
			if VCAGlobals.snapAngleHudY >= 0 then
				y = VCAGlobals.snapAngleHudY
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
					maxSpeed = ratio * self.vcaMaxSpeed
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
				
		--if self.vcaDiffManual or self.vcaAntiSlip then 
		--	renderText(x, y, l, string.format( "Wheel slip: %3.0f%%", self.vcaWheelSlip*100))
		--	y = y + l * 1.2	
		--end 
			
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
				renderText(x, y, l, vehicleControlAddon.vcaSpeedToString( self.vcaKeepSpeed / 3.6, "%5.1f" ))
				y = y + l * 1.2	
			end
			
			local f, m, b = self:vcaGetDiffState()
			if f > 0 or m > 0 or b > 0 then
				local function getRenderColor( state )
					if     state == nil then 
						return 0,0,0,1
					elseif state == 0 then 
						return 0.25,0.25,0.25,1
					elseif state == 1 then 
						return 1,1,1,1
					elseif state == 2 then 
						return 0,1,0,1
					end 
					return 0,0,0,1
				end 
				
							
				setOverlayColor( vehicleControlAddon.ovDiffLockFront, getRenderColor( f ) )
				setOverlayColor( vehicleControlAddon.ovDiffLockMid  , getRenderColor( m ) )
				setOverlayColor( vehicleControlAddon.ovDiffLockBack , getRenderColor( b ) )
			
				local x = g_currentMission.inGameMenu.hud.speedMeter.gaugeCenterX + g_currentMission.inGameMenu.hud.speedMeter.fuelGaugeRadiusX
				local y = g_currentMission.inGameMenu.hud.speedMeter.gaugeCenterY - g_currentMission.inGameMenu.hud.speedMeter.fuelGaugeRadiusY * 1.333
				local w = 0.03 * vehicleControlAddon.getUiScale()
				local h = w * g_screenAspectRatio
				renderOverlay( vehicleControlAddon.ovDiffLockBg   , x, y, w, h )
				renderOverlay( vehicleControlAddon.ovDiffLockFront, x, y, w, h )
				renderOverlay( vehicleControlAddon.ovDiffLockMid  , x, y, w, h )
				renderOverlay( vehicleControlAddon.ovDiffLockBack , x, y, w, h )
			end 
			
			local text = ""
			if self.vcaKeepCamRot then 
				if text ~= "" then text = text ..", " end 
				text = text .. "keep rot."
			end 
			if self.vcaKSIsOn then 
				if text ~= "" then text = text ..", " end 
				text = text .. "keep speed"
			end 
			if self.vcaInchingIsOn then 
				if text ~= "" then text = text ..", " end 
				text = text .. "inching"
			end 
			if text ~= "" then 
				renderText(x, y, 0.5*l, text)
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
		elseif self.vcaSnapDraw == 2 or self.vcaSnapDraw >= 4 then 
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
			
			local dist  = distX * dz - distZ * dx + curSnapOffset2

			if self.vcaSnapIsOn then 
				dist = dist + self.vcaSnapFactor * self.vcaSnapDistance
				setTextColor(0, 1, 1, 0.5) 
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
			if ( self.vcaSnapDraw == 1 or self.vcaSnapDraw == 3 ) and self.vcaSnapIsOn and self.vcaSnapPosTimer == nil then 
				xMax = 0 
			end 
			local a = 0
			local t = "|"
			for x=-xMax,xMax do 
				for zi=-2,3,0.1 do
					local z = 10 
					if self.spec_reverseDriving  ~= nil and self.spec_reverseDriving.isReverseDriving then			
						if zi > 0 then 
							z = z - 10 * zi 
						else 
							z = z - 10 * zi * zi 
						end 
					else 
						if zi < 0 then 
							z = z + 10 * zi 
						else 
							z = z + 10 * zi * zi 
						end 
					end 
					local fx = 0
					if x ~= 0 then 
						fx = x * 0.5 * self.vcaSnapDistance + curSnapOffset1
					end
					local px = wx - dist * dz - fx * dz + z * dx 
					local pz = wz + dist * dx + fx * dx + z * dz 
					local py = getTerrainHeightAtWorldPos( g_currentMission.terrainRootNode, px, 0, pz ) 
					renderText3D( px,py,pz, 0,curSnapAngle-a,0, 0.5, t )
					if self.vcaSnapDraw > 2 then 
						renderText3D( px,py+0.48,pz, 0,curSnapAngle-a,0, 0.5, t )
						renderText3D( px,py+0.96,pz, 0,curSnapAngle-a,0, 0.5, t )
						renderText3D( px,py+1.44,pz, 0,curSnapAngle-a,0, 0.5, t )
					end 
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
		if not self.isServer then 
			rpm = self.vehicle.spec_motorized.motor:getEqualizedMotorRpm()
			if     self.vcaRpmFactor == nil then
			elseif self.vcaRpmFactor < 0.999 then
				rpm = self.vehicle.spec_motorized.motor.minRpm * self.vcaRpmFactor
			elseif self.vcaRpmFactor > 1.001 then
				rpm = self.vehicle.spec_motorized.motor.maxRpm * self.vcaRpmFactor
			end 
		elseif self.vehicle.spec_motorized.motor.vcaFakeRpm ~= nil then 
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

	self.vcaDiffHasF = streamReadBool( streamId )
	self.vcaDiffHasM = streamReadBool( streamId )
	self.vcaDiffHasB = streamReadBool( streamId )
		
	for _,prop in pairs( listOfProperties ) do 
		self:vcaSetState( prop.propName, prop.func.streamRead( streamId ), true )
	end 
	
end

function vehicleControlAddon:onWriteStream(streamId, connection)

	streamWriteBool( streamId, self.vcaDiffHasF )
	streamWriteBool( streamId, self.vcaDiffHasM )
	streamWriteBool( streamId, self.vcaDiffHasB )

	for _,prop in pairs( listOfProperties ) do 
		prop.func.streamWrite( streamId , self[prop.propName] )
	end 

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
			self.vcaWheelSlip  = streamReadUIntN(streamId, 6 ) / 63
			local autoStop = streamReadBool(streamId)
			local motor = self:getMotor()
			if     motor == nil then
			elseif autoStop     then 
				motor.vcaAutoStop = true 
			elseif self:vcaGetTransmissionActive() then 
				motor.vcaAutoStop = false 
			elseif motor.vcaAutoStop ~= nil then 
				motor.vcaAutoStop = nil 
			end
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
		local autoStop  = self:vcaGetAutoHold()
		if     math.abs( self.vcaClutchDisp - self.vcaClutchDispS ) > 0.001
				or math.abs( self.vcaRpmFactor  - self.vcaRpmFactorS  ) > 0.02 
				or math.abs( self.vcaWheelSlip  - self.vcaWheelSlipS  ) > 0.02 
				or autoStop ~= self.vcaAutoStopS
				then
			hasUpdate = true 
		end 
			
		if streamWriteBool(streamId, hasUpdate ) then
			streamWriteUIntN(streamId, vehicleControlAddon.mbClamp( math.floor( 0.5 + self.vcaClutchDisp * 1023 ), 0, 1023 ), 10)			
			-- 0 to 1.1 * maxRpm; 3723 * 1.1 = 4095.3
			streamWriteUIntN(streamId, vehicleControlAddon.mbClamp( math.floor( 0.5 + self.vcaRpmFactor * 43 ), 0, 63 ), 6)
			streamWriteUIntN(streamId, vehicleControlAddon.mbClamp( math.floor( 0.5 + self.vcaWheelSlip * 63 ), 0, 63 ), 6)
			streamWriteBool(streamId, autoStop )
			self.vcaClutchDispS = self.vcaClutchDisp  
			self.vcaRpmFactorS  = self.vcaRpmFactor 
			self.vcaWheelSlipS  = self.vcaWheelSlip
			self.vcaAutoStopS   = autoStop
		end
	end

end

function vehicleControlAddon:onStartReverseDirectionChange()
	if self.vcaShuttleCtrl then 
		self:vcaSetState( "vcaShuttleFwd", not self.vcaShuttleFwd )
	end 
end 

function vehicleControlAddon:vcaGetSteeringNode()
--if type( self.getAIVehicleSteeringNode ) == "function" then 
--	return self:getAIVehicleSteeringNode()
--end 
	return self.components[1].node  
end 

function vehicleControlAddon:vcaGetCurrentSnapAngle(curRot)

	if self.vcaLastSnapAngle == nil or curRot == nil then 
		return 0 
	end
	
	local a = self.vcaLastSnapAngle
	local o = self.vcaSnapOffset1
	local p = self.vcaSnapOffset2
	local d = 0
	local e = o + p 
	local c = curRot 
	local f = math.pi * 0.5 -- 0.5 for 180° and 0.25 for 90°

	while a - c <= -f do 
		a = a + f+f
		o,p = p,o
		d,e = e,d
	end 
	while a - c > f do 
		a = a - f-f
		o,p = p,o
		d,e = e,d
	end

	return a, o, d
end 

function vehicleControlAddon.getRelativeTranslation( refNode, node )
	local wx, wy, wz = getWorldTranslation( node )
	return worldToLocal( refNode, wx, wy, wz )
end

function vehicleControlAddon.getDistance( refNode, leftMarker, rightMarker )
	local lx, ly, lz = vehicleControlAddon.getRelativeTranslation( refNode, leftMarker )
	local rx, ry, rz = vehicleControlAddon.getRelativeTranslation( refNode, rightMarker )
	vehicleControlAddon.debugPrint(string.format( "(%5.2f, %5.2f, %5.2f) / (%5.2f, %5.2f, %5.2f)", lx, ly, lz, rx, ry, rz ))
	
	local d = 0.1 * math.floor( 10 * math.abs( lx - rx ) + 0.5 )
	local o = 0.1 * math.floor( 5 * ( lx + rx ) + 0.5 )
	return d, -o, o
end

function vehicleControlAddon:vcaGetSnapDistance()
	if     SpecializationUtil.hasSpecialization(AIVehicle, self.specializations) then
		for _, implement in ipairs(self:getAttachedAIImplements()) do
			local leftMarker, rightMarker, backMarker, _ = implement.object:getAIMarkers()
			if implement.object.steeringAxleNode ~= nil and leftMarker ~= nil and rightMarker  ~= nil then 
				return vehicleControlAddon.getDistance( implement.object.steeringAxleNode, leftMarker, rightMarker )
			end
		end
	elseif SpecializationUtil.hasSpecialization(AIImplement, self.specializations) then
		local leftMarker, rightMarker, backMarker, _ = self:getAIMarkers()
		if self.steeringAxleNode ~= nil and leftMarker ~= nil and rightMarker  ~= nil then 
			return vehicleControlAddon.getDistance( self.steeringAxleNode, leftMarker, rightMarker )
		end
	end
	
	return 0, 0, 0
end

function vehicleControlAddon:vcaSetCruiseSpeed( speed )
	local spec = self.spec_drivable 
	spec.cruiseControl.speed = speed
	spec.lastInputValues.cruiseControlValue = 0
	if spec.cruiseControl.speed ~= spec.cruiseControl.speedSent then
		if g_server ~= nil then
			g_server:broadcastEvent(SetCruiseControlSpeedEvent:new(self, spec.cruiseControl.speed), nil, nil, self)
		else
			g_client:getServerConnection():sendEvent(SetCruiseControlSpeedEvent:new(self, spec.cruiseControl.speed))
		end
		spec.cruiseControl.speedSent = spec.cruiseControl.speed
	end
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

function vehicleControlAddon:getDefaultLaunchSpeed()
	local m 
	local n = Utils.getNoNil( self.vcaMaxForwardSpeed, self.spec_motorized.motor.maxForwardSpeed )

	if     n <= 7.5 then 
	--25.2 km/h -> 10 km/h
		m = 10 / 3.6
	elseif n <= 9 then 
	--32 km/h -> 15 kmH
		m = 15 / 3.6
	elseif n <= 12.223 then 
	--43 km/h -> 18 km/h
		m = 5
	elseif n <= 18 then 
	--up to 64.8 km/h -> 20 km/h
		m = 20 / 3.6
	else
	--120 km/h for vehicles with 90 km/h max speed
		m = 30 / 3.6
	end 
	return m
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
		elseif ( self.spec_aiVehicle ~= nil and self.spec_aiVehicle.isActive )
				or ( self.ad ~= nil and self.ad.isActive  ) 
				or ( self.cp ~= nil and self.cp.isDriving )
				then 
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
			
			local curSnapAngle, _, curSnapOffset = self:vcaGetCurrentSnapAngle( rot )
			
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
				local dist  = dist + distX * dz - distZ * dx + f * self.vcaSnapDistance	+ curSnapOffset
				local alpha = math.asin( vehicleControlAddon.mbClamp( 0.1 * dist, -0.851, 0.851 ) )			
				diffR = diffR + alpha
			end 
			local a = vehicleControlAddon.mbClamp( diffR / 0.174, -1, 1 ) 
			if m < 0 then 
				a = -a 
			end
			if self.spec_reverseDriving  ~= nil and self.spec_reverseDriving.isReverseDriving then
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

	if self:vcaIsVehicleControlledByPlayer() then
		if     self.vcaAIEndTime ~= nil and g_currentMission.time < self.vcaAIEndTime + 500 then 
			acceleration = 0
			doHandbrake  = true 
			self:getMotor().vcaAutoStop = true 
			brake = true 
		elseif ( self.vcaNeutral and not self.vcaShifterUsed ) or ( self.vcaShifterPark and self.vcaShifterUsed ) then 
			acceleration = 0
			doHandbrake  = true 
		--elseif self.spec_drivable.cruiseControl.state > 0 then 
		elseif self.vcaKSIsOn then 
			if math.abs( self.vcaKeepSpeed ) < 0.5 then 
				acceleration = 0
				doHandbrake  = true 
				self:getMotor().vcaAutoStop = true 
				brake = self:getIsMotorStarted()  
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
		--elseif self.vcaHandthrottle > 0 and self:vcaGetShuttleCtrl() and self:vcaGetNoIVT() and not self:vcaGetNeutral() then 
		-- fixed gear transmission and hand throttle => treat like cruise control
		elseif self.vcaIsBlocked and self.vcaIsEnteredMP then
			acceleration = 0
			doHandbrake  = true 
			self:getMotor().vcaAutoStop = true 
			brake = true 
		end 
	
	
		if not self:getIsMotorStarted() then 
			acceleration       = 0
			doHandbrake        = true 
			self.vcaBrakePedal = 1
		elseif self:vcaGetShuttleCtrl() then 
			if     self.vcaShuttleFwd then 
				self.nextMovingDirection = 1 
			else 
				self.nextMovingDirection = -1 
			end 
			
			if acceleration < -0.01 then  
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
				if self.vcaBrakePedal ~= nil then 
					self.vcaBrakePedal = self.vcaBrakePedal * limitThrottleRatio
				end
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

function vehicleControlAddon:vcaUpdateWheelPhysics( superFunc, wheel, brakePedal, dt )
	if not (  self.vcaIsLoaded
				and self:vcaIsVehicleControlledByPlayer() 
				and self:getIsMotorStarted()
				and ( self.vcaAntiSlip or self.vcaDiffManual ) ) then 
		return superFunc( self, wheel, brakePedal, dt )
	end 
	
	WheelsUtil.updateWheelSteeringAngle(self, wheel, dt)
	if self.isServer and self.isAddedToPhysics then
		local brakeForce = self:getBrakeForce() * brakePedal * wheel.brakeFactor
		if wheel.vcaDiffBrake ~= nil then 
			brakeForce = brakeForce + wheel.vcaDiffBrake
			wheel.vcaDiffBrake = nil 
		end 
		setWheelShapeProps(wheel.node, wheel.wheelShape, wheel.torque, brakeForce, wheel.steeringAngle, wheel.rotationDamping)
	end
end
WheelsUtil.updateWheelPhysics = Utils.overwrittenFunction( WheelsUtil.updateWheelPhysics, vehicleControlAddon.vcaUpdateWheelPhysics )
--******************************************************************************************************************************************

--******************************************************************************************************************************************
-- getSmoothedAcceleratorAndBrakePedals
function vehicleControlAddon:vcaGetSmoothedAcceleratorAndBrakePedals( superFunc, acceleratorPedal, brakePedal, dt )
	if self.vcaIsLoaded and self:vcaIsVehicleControlledByPlayer() and self.vcaOldAcc ~= nil then 
		
		if     self.vcaBrakePedal ~= nil and self.vcaBrakePedal >= 0.001 then  
		-- shuttle control and braking 
			brakePedal = self.vcaBrakePedal
		elseif self.vcaBrakePedal ~= nil and self:vcaGetNeutral() then 
		-- neutral, shuttle control and not brakinng
			brakePedal = 0
		elseif math.abs( self.vcaOldAcc ) < 0.001 then
		-- neither accelerating nor braking 
			if self:vcaGetNeutral() or self.vcaBrakeForce <= 0 or brakePedal <= 0 then 
			-- neutral 
				brakePedal = 0
			else  
				brakePedal = brakePedal * self.vcaBrakeForce 
			end 
		end 
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
function vehicleControlAddon:getAccelerationLimit( superFunc )
	if not (  self.vehicle ~= nil
				and self.vehicle.vcaIsLoaded
				and self.vehicle.vcaLastTransmission ~= nil
				and self.vehicle.vcaLastTransmission >= 1
				and self.vcaMaxWheelAccE ~= nil ) then 
		return superFunc( self )
	end 
	return self.vcaMaxWheelAccE
end 

VehicleMotor.getAccelerationLimit = Utils.overwrittenFunction( VehicleMotor.getAccelerationLimit, vehicleControlAddon.getAccelerationLimit )
--******************************************************************************************************************************************

function vehicleControlAddon:getMotorRotAccLimit( superFunc )
	if not (  self.vehicle ~= nil
				and self.vehicle.vcaIsLoaded
				and self.vehicle.vcaLastTransmission ~= nil
				and self.vehicle.vcaLastTransmission >= 1
				and self.vcaMaxMotorAccE ~= nil ) then 
		return superFunc( self )
	end 
	return self.vcaMaxMotorAccE
end 

VehicleMotor.getMotorRotationAccelerationLimit = Utils.overwrittenFunction( VehicleMotor.getMotorRotationAccelerationLimit, vehicleControlAddon.getMotorRotAccLimit )

--******************************************************************************************************************************************
function vehicleControlAddon:hasActiveWorkArea()

  if self.spec_turnOnVehicle ~= nil and self.spec_turnOnVehicle.isTurnedOn then 
		return true 
	end 

	if self.spec_workArea ~= nil and type( self.spec_workArea.workAreas ) == "table" then 
		for _,w in pairs( self.spec_workArea.workAreas ) do 
			if self:getIsWorkAreaActive(w) then 	
				return true 
			end 
		end 
	end 
	
	if self.spec_attacherJoints ~= nil and type( self.spec_attacherJoints.attachedImplements ) == "table" then 
		for _,implement in pairs( self.spec_attacherJoints.attachedImplements ) do 
			if implement.object ~= nil and vehicleControlAddon.hasActiveWorkArea( implement.object ) then 
				return true 
			end 
		end 
	end 
	
	return false 
end 

--******************************************************************************************************************************************
--******************************************************************************************************************************************
-- max moving average calculateion
local maxMovingAverage = {}

function maxMovingAverage:new( timeMs, stepMs, avgMs )
	self = {}
	setmetatable( self, { __metatable = maxMovingAverage, __index  = maxMovingAverage } )
	
	self.timeMs = timeMs 
	self.stepMs = stepMs 
	self.skip   = math.max( math.floor( avgMs / stepMs ), 1 )
	
	local i = 0 
	local t = 0
	
	self.data = {}
	
	while t < timeMs do 
		i = i + 1
		t = t + stepMs 
		self.data[i] = { 0, 0 } 
	end 
	
	if self.skip > #self.data then 
		self.skip = #self.data 
	end 
	
	self.index = 1 
	self.value = 0
	self.count = 0
	self.sumDt = 0 
	
	self.mma   = 0
	
	return self
end 

function maxMovingAverage:collect( dt, value )

	self.sumDt = self.sumDt + dt 
	
	if self.sumDt > self.stepMs then 
		-- store avg. over 100 ms 
		while self.sumDt > self.stepMs do 
			self.data[self.index][1] = self.value
			self.data[self.index][2] = self.count
			self.sumDt = self.sumDt - self.stepMs 
			self.index = self.index + 1
			if self.index > #self.data then 
				self.index = 1 
			end 
		end 
		
		-- build average
		local j = self.index - 1
		local a = {}
		local v_cumul, n_cumul = 0, 0
		for i=1,#self.data do 
			if j < 1 then 
				j = #self.data
			end 
			local v, n = unpack( self.data[j] )
			v_cumul = v_cumul + v
			n_cumul = n_cumul + n
			if n_cumul > 1 then 	
				a[i] = v_cumul / n_cumul 
			else 
				a[i] = v_cumul
			end 
			j = j - 1
		end 

		-- get maximum
		self.mma = 0
				
		for i=self.skip,#a do 
			if self.mma < a[i] then 
				self.mma = a[i] 
			end 
		end 
		
		self.value = value 
		self.count = 1
		
		self.firstTimeRun = true 
	else
		self.value = self.value + value
		self.count = self.count + 1
		
		if not ( self.firstTimeRun ) then 
			self.mma = self.value / self.count 
		end 
	end 
		
end 

function maxMovingAverage:get() 
	return self.mma
end 

--******************************************************************************************************************************************
--******************************************************************************************************************************************

--******************************************************************************************************************************************
-- select gear
function vehicleControlAddon:vcaUpdateGear( superFunc, acceleratorPedal, dt )
	
	if not ( self.vehicle ~= nil and self.vehicle.vcaIsLoaded ) then 
		return superFunc( self, acceleratorPedal, dt )
	end

	self.vehicle.vcaUpdateGearDone    = true 
	if self.vehicle.vcaIsEnteredMP  then 
	  self.vehicle.vcaUpdateGearTimer = g_currentMission.time + 2500
	end 
		
	local lastMinRpm        = Utils.getNoNil( self.vcaMinRpm,   self.minRpm )
	local lastMaxRpm        = Utils.getNoNil( self.vcaMaxRpm,   self.maxRpm )
	local lastFakeRpm       = Utils.getNoNil( self.vcaFakeRpm,  math.max( self.equalizedMotorRpm, self.minRpm )) 
	local lastIdleAcc       = Utils.getNoNil( self.vcaIdleAcc,  0 )
	local lastAutoStopTimer = self.vcaAutoStopTimer
	local lastStallTimer    = self.vcaStallTimer
	local lastUsedPowerRatio= self.vcaUsedPowerRatioS
	local lastGearRatio     = self.vcaGearRatio
	local lastAccPedal      = self.vcaLastAcc 
	local lastCurGearRatio  = Utils.getNoNil( self.vcaCurGearRatio, math.abs( self.gearRatio ) )
	local lastRpmReduction  = self.vcaRpmReduction
	
	self.vcaMinRpm        = nil 
	self.vcaMaxRpm        = nil 
	self.vcaFakeRpm       = nil
	self.vcaIdleAcc       = nil
	self.vcaAutoStopTimer = nil 
	self.vcaStallTimer    = nil
	self.vcaGearRatio     = nil
	self.vcaLastAcc       = nil 
	self.vcaRpmReduction  = nil 
	self.vehicle.vcaDebugSL = ""
	
	if lastAccPedal == nil then   
		self.vcaLastAccS = nil
	elseif self.vcaLastAccS == nil then
		self.vcaLastAccS = lastAccPedal 
	else 
		self.vcaLastAccS = self.vcaLastAccS + 0.04 * ( lastAccPedal - self.vcaLastAccS )
	end 	
	
	local speed        = math.abs( self.vehicle.lastSpeedReal ) *3600
	local speedMS      = math.abs( self.vehicle.lastSpeedReal ) *1000
	local motorPtoRpm  = math.min(PowerConsumer.getMaxPtoRpm(self.vehicle)*self.ptoMotorRpmRatio, self.maxRpm)
	local motorRpm     = self.motorRotSpeed * vehicleControlAddon.factor30pi
	local rpmRange     = self.maxRpm - self.minRpm
	local autoNeutral  = self.vcaAutoStop or self.vehicle:vcaGetNeutral() or lastAutoStopTimer ~= nil or self.vehicle.vcaNewHandbrake	
	local wheelSpeed   = self.differentialRotSpeed 
	if self.gearRatio < 0 then 
		wheelSpeed       = -wheelSpeed 
	end 

	local hasActiveWorkArea = false 
	if vehicleControlAddon.hasActiveWorkArea( self.vehicle ) then 
		hasActiveWorkArea     = true 
		self.vcaActiveWATimer = g_currentMission.time 
	elseif self.vcaActiveWATimer == nil then 
	elseif g_currentMission.time < self.vcaActiveWATimer + 250 then 
		hasActiveWorkArea     = true 
	else 
		self.vcaActiveWATimer = nil 
	end 
	 
	local minMotorRot = math.max( self.minRpm, lastMinRpm ) * vehicleControlAddon.factorpi30
	local maxMotorRot = lastMaxRpm * vehicleControlAddon.factorpi30
	
	if self.vcaFakeTimer ~= nil then 
		minMotorRot = math.max( minMotorRot, lastFakeRpm * vehicleControlAddon.factorpi30 )
	end 
	
	self.vcaWheelAcc   = 0
	self.vcaMotorAcc   = 0 
	expectedWheelSpeed = math.max( wheelSpeed, speedMS )
	expectedMotorSpeed = math.max( minMotorRot, self.motorRotSpeed )
	
	if self.vcaLastWheelSpeed ~= nil and dt > 0 then 
		self.vcaWheelAcc      = ( wheelSpeed - self.vcaLastWheelSpeed ) / ( dt * 0.001 )
	end 
	if self.vcaLastMotorSpeed   ~= nil and dt > 0 then  
		self.vcaMotorAcc   = ( self.motorRotSpeed - self.vcaLastMotorSpeed ) / ( dt * 0.001 )
	end 
	
	local maxWheelAcc, maxMotorAcc = self.vcaWheelAcc, self.vcaMotorAcc
	local avgWheelAcc, avgMotorAcc = self.vcaWheelAcc, self.vcaMotorAcc
	if self.vcaLastNValues == nil then 
		self.vcaLastNValues = { { t = 0, w = expectedWheelSpeed, m = expectedMotorSpeed, a = self.vcaWheelAcc, b = self.vcaMotorAcc },
														{ t = 0, w = expectedWheelSpeed, m = expectedMotorSpeed, a = self.vcaWheelAcc, b = self.vcaMotorAcc },
														{ t = 0, w = expectedWheelSpeed, m = expectedMotorSpeed, a = self.vcaWheelAcc, b = self.vcaMotorAcc },
														{ t = 0, w = expectedWheelSpeed, m = expectedMotorSpeed, a = self.vcaWheelAcc, b = self.vcaMotorAcc },
														{ t = 0, w = expectedWheelSpeed, m = expectedMotorSpeed, a = self.vcaWheelAcc, b = self.vcaMotorAcc },
														{ t = 0, w = expectedWheelSpeed, m = expectedMotorSpeed, a = self.vcaWheelAcc, b = self.vcaMotorAcc },
														{ t = 0, w = expectedWheelSpeed, m = expectedMotorSpeed, a = self.vcaWheelAcc, b = self.vcaMotorAcc },
														{ t = 0, w = expectedWheelSpeed, m = expectedMotorSpeed, a = self.vcaWheelAcc, b = self.vcaMotorAcc },
														{ t = 0, w = expectedWheelSpeed, m = expectedMotorSpeed, a = self.vcaWheelAcc, b = self.vcaMotorAcc },
														{ t = 0, w = expectedWheelSpeed, m = expectedMotorSpeed, a = self.vcaWheelAcc, b = self.vcaMotorAcc } }
	elseif self.vcaMaxWheelAcc ~= nil and self.vcaMaxMotorAcc ~= nil then 
		local iMax = table.getn( self.vcaLastNValues ) 

		maxWheelAcc = self.vcaWheelAcc
		maxMotorAcc = self.vcaMotorAcc
		avgWheelAcc = ( self.vcaWheelAcc + self.vcaLastNValues[iMax].a + self.vcaLastNValues[iMax-1].a + self.vcaLastNValues[iMax-2].a + self.vcaLastNValues[iMax-3].a + self.vcaLastNValues[iMax-4].a ) / 6
		avgMotorAcc = ( self.vcaMotorAcc + self.vcaLastNValues[iMax].b + self.vcaLastNValues[iMax-1].b + self.vcaLastNValues[iMax-2].b + self.vcaLastNValues[iMax-3].b + self.vcaLastNValues[iMax-4].b ) / 6
		local w = self.vcaLastNValues[iMax].w + 0.001 * dt * self.vcaMaxWheelAcc
	  local m = self.vcaLastNValues[iMax].m + 0.001 * dt * self.vcaMaxMotorAcc
		local n = 1
		maxWheelAcc = math.max( maxWheelAcc, self.vcaLastNValues[iMax].a ) 
		maxMotorAcc = math.max( maxMotorAcc, self.vcaLastNValues[iMax].b ) 
		
		for i=1,iMax-1 do 
			if self.vcaLastNValues[i].t + dt < 200 then 
				w = w + ( self.vcaLastNValues[i].w + 0.001 * ( self.vcaLastNValues[i].t + dt ) * self.vcaMaxWheelAcc )
				m = m + ( self.vcaLastNValues[i].m + 0.001 * ( self.vcaLastNValues[i].t + dt ) * self.vcaMaxMotorAcc )
				n = n + 1
				
				maxWheelAcc = math.max( maxWheelAcc, self.vcaLastNValues[i].a ) 
				maxMotorAcc = math.max( maxMotorAcc, self.vcaLastNValues[i].b ) 
			end 
			
			self.vcaLastNValues[i].t = self.vcaLastNValues[i+1].t + dt
			self.vcaLastNValues[i].w = self.vcaLastNValues[i+1].w 
			self.vcaLastNValues[i].m = self.vcaLastNValues[i+1].m 
			self.vcaLastNValues[i].a = self.vcaLastNValues[i+1].a
			self.vcaLastNValues[i].b = self.vcaLastNValues[i+1].b
		end 
		
		self.vcaLastNValues[iMax].t = 0
		self.vcaLastNValues[iMax].w = expectedWheelSpeed
		self.vcaLastNValues[iMax].m = expectedMotorSpeed
		self.vcaLastNValues[iMax].a = self.vcaWheelAcc
		self.vcaLastNValues[iMax].b = self.vcaMotorAcc
		expectedWheelSpeed          = w / n
		expectedMotorSpeed          = m / n
	end 
	
	self.vcaLastWheelSpeed = wheelSpeed
	self.vcaLastMotorSpeed = self.motorRotSpeed
	
	if self.vcaDirTimer ~= nil or self.vcaWheelAccS == nil then 
		self.vcaWheelAccS = 0
		self.vcaWheelAccF = 0
		self.vcaMotorAccS = 0
		self.vcaMotorAccF = 0
	else 
		self.vcaWheelAccS = self.vcaWheelAccS + 0.02 * ( self.vcaWheelAcc - self.vcaWheelAccS )
		self.vcaWheelAccF = self.vcaWheelAccF + 0.10 * ( self.vcaWheelAcc - self.vcaWheelAccF )
		self.vcaMotorAccS = self.vcaMotorAccS + 0.02 * ( self.vcaMotorAcc - self.vcaMotorAccS )
		self.vcaMotorAccF = self.vcaMotorAccF + 0.10 * ( self.vcaMotorAcc - self.vcaMotorAccF )
	end 
	
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
	
	local fwd, curBrake, lastFwd
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
	
	self.vcaCurGearRatio = self.gearRatio 
	local minGearRatio   = self.minGearRatio
	local maxGearRatio   = self.maxGearRatio
	if not lastFwd then 
		self.vcaCurGearRatio = -self.vcaCurGearRatio
		minGearRatio = -minGearRatio
		maxGearRatio = -maxGearRatio
	end 
	if self.vcaGearRatioS == nil then 
		self.vcaGearRatioS = self.vcaCurGearRatio
	else 
		self.vcaGearRatioS = self.vcaGearRatioS + 0.02 * ( self.vcaCurGearRatio - self.vcaGearRatioS )
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
			self.vcaFakeRpm   = vehicleControlAddon.mbClamp( motorRpm, lastFakeRpm - 0.0005 * dt * rpmRange, lastFakeRpm + 0.001 * dt * rpmRange )	
			self.vcaFakeTimer = self.vcaFakeTimer - dt 
			if self.vcaFakeTimer <= 0 then 
				self.vcaFakeTimer = nil 
			end 
		end 
	end 
	
	local transmission = self.vehicle.vcaGearbox 

	--****************************************************************************
	-- power and torque ratio for IVT or automatic transmission
	if autoNeutral or curAcc < 1e-3 then 
		self.vcaUsedTorqueRatio = self.motorExternalTorque / math.max(self.motorAvailableTorque, 0.0001)
		self.vcaUsedPowerRatio  = self.motorExternalTorque * 1.07 * self.motorRotSpeed
	else 
		local t = self.motorAppliedTorque 
		if self.vcaClutchMinusTorque ~= nli then 
			t = math.max( t - self.vcaClutchMinusTorque )
		end 			
		
		self.vcaUsedTorqueRatio = t / math.max(self.motorAvailableTorque, 0.0001)
		self.vcaUsedPowerRatio  = t * self.motorRotSpeed
	end 
	self.vcaUsedClutchTorque  = math.max( 0, self.motorAppliedTorque - self.motorExternalTorque )
	
	if self.vcaUsedClutchTorqueL == nil then 
		self.vcaUsedClutchTorqueL = { self.vcaUsedClutchTorque, self.vcaUsedClutchTorque, self.vcaUsedClutchTorque, self.vcaUsedClutchTorque, self.vcaUsedClutchTorque,
																	self.vcaUsedClutchTorque, self.vcaUsedClutchTorque, self.vcaUsedClutchTorque, self.vcaUsedClutchTorque, self.vcaUsedClutchTorque }
		self.vcaUsedClutchTorqueS = self.vcaUsedClutchTorque			
		self.vcaUsedClutchTorqueI = 1 
	else 
		self.vcaUsedClutchTorqueI = self.vcaUsedClutchTorqueI + 1 
		if self.vcaUsedClutchTorqueI > #self.vcaUsedClutchTorqueL then 
			self.vcaUsedClutchTorqueI = 1 
		end 
		self.vcaUsedClutchTorqueL[self.vcaUsedClutchTorqueI] = self.vcaUsedClutchTorque
		self.vcaUsedClutchTorqueS = 0 
		for i,t in pairs( self.vcaUsedClutchTorqueL ) do 
			self.vcaUsedClutchTorqueS = self.vcaUsedClutchTorqueS + t 
		end 
		if #self.vcaUsedClutchTorqueL == 10 then 
			self.vcaUsedClutchTorqueS = self.vcaUsedClutchTorqueS * 0.1  
		elseif #self.vcaUsedClutchTorqueL > 0 then  
			self.vcaUsedClutchTorqueS = self.vcaUsedClutchTorqueS / #self.vcaUsedClutchTorqueL 
		else 
			self.vcaUsedClutchTorqueS = self.vcaUsedClutchTorque			
		end 
	end 
	
	if     self.vcaUsedPowerRatio <= 0 then 
		self.vcaUsedPowerRatio = 0
	elseif self.vcaUsedPowerRatio >= self.peakMotorPower then 
		self.vcaUsedPowerRatio = 1 
	else
		self.vcaUsedPowerRatio = self.vcaUsedPowerRatio / self.peakMotorPower
	end 
	
	if self.vcaUsedTorqueRatioF == nil then 
		self.vcaUsedTorqueRatioF = self.vcaUsedTorqueRatio
	else 
		self.vcaUsedTorqueRatioF = self.vcaUsedTorqueRatioF + 0.04 * ( self.vcaUsedTorqueRatio - self.vcaUsedTorqueRatioF )
	end 
	
	if self.vcaUsedTorqueRatioMMA == nil then 	
		self.vcaUsedTorqueRatioMMA = maxMovingAverage:new( 10000, 100, 1000 )
	end 	
	self.vcaUsedTorqueRatioMMA:collect( dt, self.vcaUsedTorqueRatio )
	self.vcaUsedTorqueRatioS = self.vcaUsedTorqueRatioMMA:get()
		
	if self.vcaUsedPowerRatioMMA == nil then 
		self.vcaUsedPowerRatioMMA = maxMovingAverage:new( 10000, 100, 1000 )
	end 
	self.vcaUsedPowerRatioMMA:collect( dt, self.vcaUsedPowerRatio )
	self.vcaUsedPowerRatioS = self.vcaUsedPowerRatioMMA:get()
	
	local autoShiftLoad = math.min( 1.07 * self.vcaUsedPowerRatioS, 1 )
	-- full power is requested
	if speedMS > 4 and self.motorExternalTorque > 0.99 * self.motorAvailableTorque then 
		autoShiftLoad = math.max( math.abs( newAcc ), autoShiftLoad )
	end 
	-- simulate high load for immediate down shift
	if curBrake >= 0.5 and speed > 10 and autoShiftLoad < 0.75 then 
		autoShiftLoad = 0.75
	end 
	if self.gearChangeTimer > 0 and autoShiftLoad < lastUsedPowerRatio then 
		autoShiftLoad = lastUsedPowerRatio
	end 
	
	--****************************************************************************
	
	local r = Utils.getNoNil( lastGearRatio, self.vcaCurGearRatio )
	local wheelRpm  = speedMS * r * vehicleControlAddon.factor30pi
	if r > 1000 then 
		wheelRpm = 0
	end 
	local clutchRpm = wheelRpm
	if self.gearChangeTimer <= 0 and not autoNeutral then 
		clutchRpm = self.differentialRotSpeed * self.gearRatio * vehicleControlAddon.factor30pi
	end 
	
	self.vcaWheelSlip = 0
	if speedMS > 0.5 and wheelSpeed > speedMS and not autoNeutral then 
		self.vcaWheelSlip = wheelSpeed / speedMS - 1
	end 

	if self.vcaSlipMMA == nil then 
		self.vcaSlipMMA = maxMovingAverage:new( 1000, 250, 0 )
	end 	
	self.vcaSlipMMA:collect( dt, self.vcaWheelSlip )	
	self.vehicle.vcaWheelSlip = self.vcaSlipMMA:get()
	
	local realSpeedLimit   = self.speedLimit 
	self.speedLimit        = self.speedLimit * ( 1 + self.vehicle.vcaWheelSlip )
	self.vcaLastSpeedLimit = self.speedLimit
	
	local curGearRatio
	
	if not self.vehicle:getIsMotorStarted() or dt < 0 or self.vehicle.vcaLastTransmission == nil or transmission == nil then 
--****************************************************************************************	
-- standard / motor off
--****************************************************************************************	
		self.vcaClutchTimer   = nil
		self.vcaAutoDownTimer = nil
		self.vcaAutoUpTimer   = nil
		self.vcaNoShiftTimer  = nil
		self.vcaAutoLowTimer  = nil
		self.vcaBrakeTimer    = nil
		self.vcaIncreaseRpm   = nil
		self.vcaAutoStop      = nil

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
			self.vcaLastAcc = 0
			return 0
		end 
		return newAcc		
		
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
			self.vehicle.vcaClutchDisp = 0
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
							
		if speed > 2 then 
			self.vcaIncreaseRpm = g_currentMission.time + 2000 
		end 
		
		local minReducedRpm = math.min( math.max( newMinRpm, 0.45*math.min( 2200, self.maxRpm ) ), newMaxRpm )
		if self.vehicle.spec_combine ~= nil then 
			minReducedRpm = math.min( math.max( newMinRpm, 0.8*math.min( 2200, self.maxRpm ) ), newMaxRpm )
		elseif hasActiveWorkArea then  
			minReducedRpm = math.min( math.max( newMinRpm, 0.7*math.min( 2200, self.maxRpm ) ), newMaxRpm )
		end 
		
		local noThrottle = ( curAcc <= 0.1 )
		if noThrottle then 
			minReducedRpm = math.max( minReducedRpm - 0.025 * self.maxRpm, newMinRpm )
		else 
			minReducedRpm = math.min( minReducedRpm + 0.025 * self.maxRpm, self.maxRpm )
		end 					
		if speed >= self:getSpeedLimit() - 0.2 then 
			if self.vehicle.vcaKSIsOn then 
				noThrottle = self.vehicle.vcaOldAcc <= 0.1
			else 
				noThrottle = true 
			end 
		end 
		
		if self.vcaIncreaseRpm ~= nil and g_currentMission.time < self.vcaIncreaseRpm then 
			if speed > 0.5 then 
				newMinRpm = vehicleControlAddon.mbClamp( minReducedRpm, newMinRpm, newMaxRpm )
			end 
			if self.vcaFakeRpm ~= nil then 
				self.vcaFakeRpm = math.max( self.vcaFakeRpm, minReducedRpm )
			end 
		end		
		
		minReducedRpm = math.min( minReducedRpm + 0.1*math.min( 2200, self.maxRpm ), newMaxRpm ) 
		
		local m1, m2 = newMinRpm, newMaxRpm 		
		
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
			local maxSpeedRpm = vehicleControlAddon.mbClamp( speedFactor * math.min( self.speedLimit, speed + 1 ), minReducedRpm, newMaxRpm )
			if speed > 0 then 
				newMinRpm = vehicleControlAddon.mbClamp( speedFactor * math.min( speed, 3.6 * maxSpeed ), newMinRpm, newMaxRpm )
			end 
			
			local m1, m2 = newMinRpm, newMaxRpm 
			
			local baseRpm   = math.min( m1, self.vcaMaxPowerRpmL )
			local basePR = self:getTorqueCurveValue( baseRpm * vehicleControlAddon.factorpi30 ) * baseRpm * vehicleControlAddon.factorpi30
			if     basePR <= 0 then 
				basePR = 0 
			elseif basePR >= self.peakMotorPower then 
				basePR = 1
			else 
				basePR = basePR / self.peakMotorPower
			end 
			
			local upr = self.vcaUsedPowerRatioS
			if self.motorExternalTorque > 0.99 * self.motorAvailableTorque then 
				upr = math.max( math.abs( newAcc ), upr )
			end 
			
			-- optimal load at 80%
			local maxR0 = 1.25
			local maxR1 = 1.1
			local maxR2 = 0.5 * ( maxR1 + maxR0 )
			upr = upr * maxR0 
			
			if     m1 >= m2 then 
			elseif curAcc <= 0.1 or ( noThrottle and not hasActiveWorkArea ) then  
				newMaxRpm = vehicleControlAddon.mbClamp( maxSpeedRpm, m1, m2 )
			elseif upr >= maxR1 or lastRpmReduction ~= nil then  
				local v = vehicleControlAddon.mbClamp( ( self.vcaUsedTorqueRatio * maxR0 - maxR2 ) / ( maxR0 - maxR2 ), -1, 1 )
				if lastRpmReduction == nil then 	
					lastRpmReduction = 0 
				end 
				self.vcaRpmReduction = vehicleControlAddon.mbClamp( lastRpmReduction + v * dt * 0.0002, 0, 1 )
				newMinRpm = vehicleControlAddon.mbClamp( self.vcaMaxPowerRpmH + self.vcaRpmReduction * ( self.vcaMaxPowerRpmL - self.vcaMaxPowerRpmH ), m1, m2 )
				newMaxRpm = vehicleControlAddon.mbClamp( self.maxRpm + self.vcaRpmReduction * ( self.vcaMaxPowerRpmL - self.maxRpm ), m1, m2 )
				if self.vcaRpmReduction <= 0 then 
					self.vcaRpmReduction = nil 
				end 
			elseif upr <= basePR then 
				newMaxRpm = vehicleControlAddon.mbClamp( maxSpeedRpm, m1, m2 )
			else 
				local v   = vehicleControlAddon.mbClamp( ( upr - basePR ) / ( maxR1 - basePR ), 0, 1 ) 
				newMinRpm = vehicleControlAddon.mbClamp( baseRpm + v * ( self.vcaMaxPowerRpmH - baseRpm ), m1, m2 )
				newMaxRpm = vehicleControlAddon.mbClamp( math.max( baseRpm + v * ( self.maxRpm - baseRpm ), maxSpeedRpm ), m1, m2 )
			end 
			
			self.vehicle.vcaDebugI = debugFormat( "%5.2f (%5.2f), %5.2f, %6.1f, %5s\n%6.1f..%6.1f (%6.1f..%6.1f)",
																							upr, basePR, Utils.getNoNil( self.vcaRpmReduction, 0 ),minReducedRpm,tostring(hasActiveWorkArea),
																							newMinRpm, newMaxRpm, m1, m2 )
		end 

		
		local deltaS, deltaF
		deltaS = rpmRange * 0.0001 * dt
		deltaF = rpmRange * 0.0002 * dt
		
		local lm = self.motorRotSpeed * vehicleControlAddon.factor30pi
		local le = expectedMotorSpeed * vehicleControlAddon.factor30pi
		self.vcaMinRpm = vehicleControlAddon.mbClamp( newMinRpm, lastMinRpm - deltaS, math.max( lastMinRpm, lm + deltaF ) )
		self.vcaMaxRpm = vehicleControlAddon.mbClamp( newMaxRpm, math.max( lastMaxRpm, lm ) - deltaS, math.max( lastMaxRpm + deltaS, le ) )
		if self.vcaMinRpm > self.vcaMaxRpm then 
			self.vcaMinRpm = self.vcaMaxRpm 
		end 

		self.minGearRatio = self.maxRpm / ( maxSpeed * vehicleControlAddon.factor30pi )
		self.maxGearRatio = math.min( 10000, math.max( 100, self.vcaMaxRpm / math.max( 1e-3, speedMS * vehicleControlAddon.factor30pi ) ) )
		
		if self.vehicle.vcaGearRatioF > 0 then 
			self.maxGearRatio = math.max( self.maxRpm / ( self.vehicle.vcaMaxSpeed * math.max( self.vehicle.vcaGearRatioT, self.vehicle.vcaGearRatioF ) * vehicleControlAddon.factor30pi ),
																		self.minRpm  / math.max( 1e-3, speedMS * vehicleControlAddon.factor30pi ) )
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
		
		if self.vehicle.vcaShifterUsed or not self.vehicle:vcaIsVehicleControlledByPlayer() then 
			self.vcaAutoStop = false 
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
					self.vehicle:vcaSetState("vcaBOVVolume",self.vcaUsedTorqueRatioF)
				end 
			end 
			if self.vcaLastGear ~= nil and self.vehicle.vcaGear ~= self.vcaLastGear and self.gearChangeTimer < gearTime then 
				self.gearChangeTimer = gearTime
				if self.vcaGearIndex ~= nil and self.vcaGearIndex < gear and gearTime > 0 then 
					self.vehicle:vcaSetState("vcaBOVVolume",self.vcaUsedTorqueRatioF)
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
		
	else
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
		
		if self.vehicle.vcaShifterUsed or not self.vehicle:vcaIsVehicleControlledByPlayer() then 
			self.vcaAutoStop = false 
		end 
		
		if self.gearChangeTimer == nil then 
			self.gearChangeTimer = 200
		elseif self.gearChangeTimer > 0 then 
			self.gearChangeTimer = self.gearChangeTimer - dt 
		end

		local clutchRpmInc = 0.25
		if self.vehicle.vcaTurboClutch then 
			clutchRpmInc = 0.4
		end
		local clutchCloseRpm = math.min( fakeRpm, math.max( self.minRpm + clutchRpmInc * rpmRange, 0.9 * motorPtoRpm, math.min( 1.1 * motorPtoRpm, fakeRpm ) ) )
					
		if self.vcaClutchTimer == nil then
			self.vcaClutchTimer = VCAGlobals.clutchTimer
		elseif self.vcaClutchTimer > 0 then 
			self.vcaClutchTimer = math.max( 0, math.min( self.vcaClutchTimer - dt, VCAGlobals.clutchTimer - 1 ) )
		end 
		
		if autoNeutral then 
		--self.vcaAutoDownTimer = 0
		--self.vcaAutoUpTimer   = VCAGlobals.clutchTimer
			self.vcaAutoDownTimer = VCAGlobals.clutchTimer
			self.vcaAutoUpTimer   = 0
		end 
						
		local gear  = transmission:getRatioIndex( self.vehicle.vcaGear, self.vehicle.vcaRange )		
		local ratio = transmission:getGearRatio( gear )
		if ratio == nil then 
			print("Error in vehicleControlAddonTransmission: ratio is nil")
			gear  = 1	
			ratio = 0.3
		end 
		local maxSpeed  = ratio * self.vehicle.vcaMaxSpeed 
		wheelRpm = self.vehicle.lastSpeedReal * 1000 * self.maxRpm / maxSpeed 
		
		self.vehicle.vcaDebugR = debugFormat("g: %2d, r: %5.3f, s: %5.1f, m: %4.0f, w: %4.0f, c: %4.0f",
																	gear, ratio, maxSpeed*3.6,
																	self.lastRealMotorRpm, wheelRpm, clutchRpm )
		
		
		--****************************************		
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
		if self.vcaAutoLowTimer == nil or lastFwd ~= fwd or self.vcaAutoStop then 
			self.vcaAutoLowTimer = 5000
		elseif self.vcaAutoLowTimer > 0 then 
			self.vcaAutoLowTimer = self.vcaAutoLowTimer - dt 
		end 
		if self.vcaNoShiftTimer == nil or self.gearChangeTimer > 0 then 
			self.vcaNoShiftTimer = 1000 
		elseif self.vcaNoShiftTimer > 0 then 
			self.vcaNoShiftTimer = self.vcaNoShiftTimer - dt 
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
		if self.gearChangeTimer > 0 and self.vcaAutoDownTimer < 1000 then 
			self.vcaAutoDownTimer = 1000 
		end 
		if self.vcaClutchTimer <= 0 and motorPtoRpm < self.minRpm and curAcc < 0.1 and curBrake < 0.1 and self.vcaAutoDownTimer < 1 then
			self.vcaAutoDownTimer = 1
		end 
		if motorPtoRpm < self.minRpm and autoShiftLoad < 0.667 then 
			self.vcaAutoLowTimer = 5000 
		end 
		if curAcc < 0.1 and self.vcaAutoLowTimer < 2000 then 
			self.vcaAutoLowTimer = 2000
		end 
		if lastStallTimer ~= nil and lastStallTimer >= 100 then
			self.vcaNoShiftTimer  = 0
			self.vcaAutoDownTimer = 0
			self.vcaAutoLowTimer  = 0
		end 
	--if maxSpeed > 0.41667 * self:getSpeedLimit() and self.vcaAutoDownTimer > 1000 then -- 0.41667 = 1.5 / 3.6
	--	self.vcaAutoDownTimer = 1000
	--end 
		
		local lastSetLaunchGear = self.vcaSetLaunchGear
		self.vcaSetLaunchGear   = false 
		local newGear           = gear 
		
		if initGear then 
			local delta    = math.huge
			for i,r in pairs(transmission.gearRatios) do 
				local d = math.abs( r * self.vehicle.vcaMaxSpeed - self.vehicle.vcaLaunchSpeed  )
				if d < delta then 
					newGear = i 
					delta   = d
				end 
			end 	
			self.vcaSetLaunchGear = true  
		elseif self.vehicle:vcaGetAutoShift() then
		
			local setLaunchGear  = ( lastFwd ~= fwd or self.vcaDirTimer ~= nil or self.vcaAutoStop )
			local setLaunchGear2 = ( self.vcaAutoStop and self.vcaGearIndex ~= nil and ( fwd or self.vehicle.vcaSingleReverse == 0 ) )
			local launchGear     = gear 
			local launchSpeed    = self.vehicle.vcaLaunchSpeed 
			if not ( self.vehicle:vcaIsVehicleControlledByPlayer()
			-- AutoDrive
					 or ( self.vehicle.ad ~= nil and self.vehicle.ad.isActive  ) 
			-- Courseplay
					 or ( self.vehicle.cp ~= nil and self.vehicle.cp.isDriving ) ) then 
				launchSpeed    = math.min( launchSpeed, 10 / 3.6 )
				setLaunchGear2 = false 
			end 
			
			if      self.speedLimit > 2
					and not setLaunchGear
					and self.gearChangeTimer <= 0
					and not self.vehicle:vcaGetNeutral()
					and launchSpeed * 3.6 * self.maxRpm > self.speedLimit * self.minRpm
					then 
				launchSpeed = self.speedLimit * self.minRpm / ( 3.6 * self.maxRpm ) 
			end 
			
			local gearlist = transmission:getAutoShiftIndeces( 0, 1, true, true )
			if gearlist ~= nil and #gearlist > 0 then 
				local target = launchSpeed
				launchSpeed  = ratio * self.vehicle.vcaMaxSpeed
				local delta  = math.abs( launchSpeed - target ) 
				for _,i in pairs(gearlist) do 
					local r = transmission:getGearRatio(i)
					if r ~= nil then 
						local s = r * self.vehicle.vcaMaxSpeed
						local d = math.abs( s - target )
						if d < delta then
							launchGear  = i 
							launchSpeed = s
							delta       = d
						end 
					end 
				end
				
				if setLaunchGear2 then
					if gear == gearlist[1]         and ratio * self.vehicle.vcaMaxSpeed > self.vehicle.vcaLaunchSpeed then 
					-- no inscrease of launch speed by 1st gear 
						setLaunchGear2 = false 
					end 
					if gear == gearlist[#gearlist] and ratio * self.vehicle.vcaMaxSpeed < self.vehicle.vcaLaunchSpeed then 
					-- no decrease of launch speed by last gear 
						setLaunchGear2 = false 
					end 
				end 

				self.vehicle.vcaDebugL = debugFormat( "%s, %s, %s, %s, %d, %d",
																								vehicleControlAddon.vcaSpeedInt2Ext( self.vehicle.vcaMaxSpeed ),
																								vehicleControlAddon.vcaSpeedInt2Ext( self.vehicle.vcaLaunchSpeed ),
																								vehicleControlAddon.vcaSpeedInt2Ext( self.speedLimit ),
																								vehicleControlAddon.vcaSpeedInt2Ext( launchSpeed ),
																								gear,
																								launchGear )
			end 		
			
			if setLaunchGear then
				if not ( lastSetLaunchGear ) then 
					if ratio * self.vehicle.vcaMaxSpeed > launchSpeed then 
						newGear = launchGear
					end 
				elseif setLaunchGear2 and self.vcaGearIndex ~= gear then 
					self.vehicle:vcaSetState("vcaLaunchSpeed", ratio * self.vehicle.vcaMaxSpeed)
				end 
				self.vcaSetLaunchGear = true 
			elseif self.gearChangeTimer <= 0 and not self.vehicle:vcaGetNeutral() then
				local m1 = self.minRpm + 0.1 * rpmRange
				local m4 = math.min( math.max( self.vehicle.vcaRatedRpm, motorPtoRpm * 1.025 ), 
														 math.max( self.vcaMaxPowerRpmL, self.vcaMaxPowerRpmH - rpmRange * 0.2 * math.max( 0, self.vcaWheelAccS ) ),
														 self.minRpm + rpmRange * 0.975 )
				if hasActiveWorkArea then  
					m1 = math.min( math.max( m1, 0.7*math.min( 2200, self.maxRpm ) ), m4 )
				end 
				if motorPtoRpm <= 0 and curBrake < 0.1 and curAcc > 0.1 and curAcc < 0.8 and self.gearChangeTimer <= 0 then 
					m4 = math.max( m1, math.min( m4, self.minRpm + curAcc * rpmRange * 0.975 ) )
				end 
				local m2 = vehicleControlAddon.mbClamp( self.vcaMaxPowerRpmL, m1, m4 )
				local m3 = math.max( m1, m4 * 0.72 )
				local autoMinRpm = m1 + autoShiftLoad * ( m2 - m1 )
				local autoMaxRpm = m3 + autoShiftLoad * ( m4 - m3 )
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
				
				local rpmHi = math.max( wheelRpm, clutchRpm )
				local rpmLo = math.min( wheelRpm, clutchRpm )
				
				if     rpmHi > 0.99 * self.maxRpm then 
					self.vcaAutoUpTimer = 0
				elseif rpmHi > m4 and self.vcaAutoUpTimer > 250 then 
					self.vcaAutoUpTimer = 250
				elseif rpmLo < autoMinRpm and self.vcaAutoUpTimer < 1000 then 
					self.vcaAutoUpTimer = 1000
				elseif rpmLo < autoMaxRpm and self.vcaAutoUpTimer < 250 then 
					self.vcaAutoUpTimer = 250
				end 
				if self.vcaClutchTimer <= 0 and wheelRpm < m1 and gear > launchGear and self.vcaAutoDownTimer > 2000 then 
					self.vcaAutoDownTimer = 2000
				end 
				
				local searchUp   = ( rpmHi > autoMaxRpm and self.vcaAutoUpTimer   <= 0 and self.vcaNoShiftTimer <= 0 )
				local searchDown = ( rpmLo < autoMinRpm and self.vcaAutoDownTimer <= 0 and self.vcaNoShiftTimer <= 0 )

				lowGear    = launchGear
				if self.vcaAutoStop or curBrake > 0.1 then
					searchUp = false 
				elseif self.vcaAutoLowTimer <= 0 then 
					if lastStallTimer == nil or lastStallTimer < 1000 then 
						lowGear = math.min( launchGear, gear ) - 1 
					else 
						lowGear  = 1
					end 
				end 
				
				local gearlist = transmission:getAutoShiftIndeces( gear, lowGear, searchDown, searchUp )
				
				if #gearlist <= 0 then
					self.vehicle.vcaDebugA = debugFormat( "%3.0f%%; %3.0f%%; %4.0f..%4.0f; %4.0f no gear\n%4d; %2d; %s; %s",
																									curAcc*100,autoShiftLoad*100,autoMinRpm,autoMaxRpm,wheelRpm,
																									self.vcaAutoLowTimer, lowGear, tostring( searchDown ), tostring( searchUp ))
				elseif wheelRpm <= 1 then 
					self.vehicle.vcaDebugA = debugFormat( "%3.0f%%; %3.0f%%; %4.0f..%4.0f; %4.0f stoppedn%4d; %2d; %s; %s",
																									curAcc*100,autoShiftLoad*100,autoMinRpm,autoMaxRpm,wheelRpm,
																									self.vcaAutoLowTimer, lowGear, tostring( searchDown ), tostring( searchUp ))
					newGear = gearlist[1]
				else 
					local d = 0
					if wheelRpm < autoMinRpm then 
						d = autoMinRpm - wheelRpm
					end 
					if wheelRpm > autoMaxRpm then 
						d = math.max( d, wheelRpm - autoMaxRpm )
					end 
					d = d - 1
					local d1 = d
					local rr = wheelRpm
					for _,i in pairs( gearlist ) do 
						local nr = transmission:getGearRatio( i )
						local rpm = rpmLo * ratio / nr
						local d2 = 0
						if rpm < autoMinRpm then 
							d2 = autoMinRpm - rpm
						end 
						rpm = rpmHi * ratio / nr
						if rpm > autoMaxRpm then 
							d2 = math.max( d2, rpm - autoMaxRpm )
						end 
						if 			( d2 < d or ( d2 == d and searchUp ) )
								and ( self.vehicle.vcaGearRatioF <= 0 or nr >= self.vehicle.vcaGearRatioF )
								and ( self.vehicle.vcaGearRatioT <= 0 or nr <= self.vehicle.vcaGearRatioT ) then 
							newGear = i 
							d = d2
							rr = rpm
						end 
					end 
					
					self.vehicle.vcaDebugA = debugFormat( "%3.0f%%; %3.0f%%; %4.0f..%4.0f; %4.0f -> %4.0f; %d -> %d; %5.0f -> %5.0f\n%4d; %2d; %s; %s",
																									curAcc*100,autoShiftLoad*100,autoMinRpm,autoMaxRpm,wheelRpm, rr,gear,newGear,d1,d,
																									self.vcaAutoLowTimer, lowGear, tostring( searchDown ), tostring( searchUp ))
				end 
			end
		end
		
		if gear ~= newGear then 
			if self.vehicle.vcaDebugA ~= nil then 
				vehicleControlAddon.debugPrint( g_currentMission.time.."; "..self.vehicle.vcaDebugA )
			end 
			
			local g, r = transmission:getBestGearRangeFromIndex( self.vehicle.vcaGear, self.vehicle.vcaRange, newGear )
			self.vehicle:vcaSetState( "vcaGear",  g )
			self.vehicle:vcaSetState( "vcaRange", r )
			
			gear     = transmission:getRatioIndex( g, r ) 
			ratio    = transmission:getGearRatio( gear )
			local m  = maxSpeed 
			maxSpeed = ratio * self.vehicle.vcaMaxSpeed 
		end 
		wheelRpm = self.vehicle.lastSpeedReal * 1000 * self.maxRpm / maxSpeed 
		
		self.vehicle:vcaSetState("vcaBOVVolume",0)
		if not autoNeutral then 
			local gearTime  = transmission:getChangeTimeGears()
			local rangeTime = transmission:getChangeTimeRanges()
			if not self.vehicle:vcaIsVehicleControlledByPlayer() then 
				gearTime, rangeTime = -1, -1  
			end 
			if lastStallTimer ~= nil and self.vehicle:vcaGetAutoClutch() then 
				gearTime  = math.max( 250, gearTime  )
				rangeTime = math.max( 250, rangeTime )
			end 
			if gearTime < 1 then	
				gearTime = -1 
			end 
			if rangeTime < 1 then 
				rangeTime = -1
			end 
			
			if self.vcaLastRange ~= nil and self.vehicle.vcaRange ~= self.vcaLastRange then 
				if self.gearChangeTimer < rangeTime then 
					self.gearChangeTimer = rangeTime
					if self.vcaGearIndex ~= nil and self.vcaGearIndex < gear and rangeTime > 2 then 
						self.vehicle:vcaSetState("vcaBOVVolume",self.vcaUsedTorqueRatioF)
					end 
				end 
				self.vcaGearChangeTime = g_currentMission.time 
			end 
			if self.vcaLastGear ~= nil and self.vehicle.vcaGear ~= self.vcaLastGear then 
				if self.gearChangeTimer < gearTime then 
					self.gearChangeTimer = gearTime
					if self.vcaGearIndex ~= nil and self.vcaGearIndex < gear and gearTime > 2 then 
						self.vehicle:vcaSetState("vcaBOVVolume",self.vcaUsedTorqueRatioF)
					end 
				end 
				self.vcaGearChangeTime = g_currentMission.time 
			end 
		end 
		
		local minRequiredRpm = math.max( self.minRpm, motorPtoRpm )
						
		if self.vcaGearIndex ~= nil and self.vcaGearIndex ~= gear then 
			if gear > self.vcaGearIndex then 
				self.vcaAutoUpTimer	  = math.max( self.vcaAutoUpTimer	 ,  500 + self.gearChangeTimer * 4 )
				self.vcaAutoDownTimer = math.max( self.vcaAutoDownTimer, 4000 + self.gearChangeTimer )
			else                                    
				self.vcaAutoUpTimer	  = math.max( self.vcaAutoUpTimer	 , 4000 + self.gearChangeTimer * 2 )
				self.vcaAutoDownTimer = math.max( self.vcaAutoDownTimer, 2000 + self.gearChangeTimer )
			end
			self.vcaNoShiftTimer = 1000 
		elseif autoNeutral then 
		elseif motorRpm < 0.7 * self.minRpm and not self.vcaAutoStop and self.vcaFakeRpm == nil then 
			if     curBrake > 0.1 then   
				self.vcaClutchTimer = math.max( self.vcaClutchTimer, VCAGlobals.clutchTimer - 1 )
			elseif self.vehicle.vcaTurboClutch then   
				self.vcaClutchTimer = math.max( self.vcaClutchTimer, 0.9 * VCAGlobals.clutchTimer )
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
		elseif wheelRpm < 0.74 * minRequiredRpm and curBrake > 0.1 then 
			self.vcaClutchTimer = VCAGlobals.clutchTimer - 1
		elseif wheelRpm < minRequiredRpm and curBrake > 0.1 then 
			self.vcaClutchTimer = math.max( self.vcaClutchTimer, math.min( self.vcaClutchTimer + dt + dt, VCAGlobals.clutchTimer - 1 ) )
		elseif wheelRpm < minRequiredRpm and self.vehicle.vcaTurboClutch then 
			self.vcaClutchTimer = math.max( self.vcaClutchTimer, math.min( self.vcaClutchTimer + dt + dt, 0.9 * VCAGlobals.clutchTimer ) )
		end 
		
		self.vehicle.vcaDebugM = debugFormat("%5.0f, %5.0f, %5.0f, %3.0f%%, %s, %5.0f", motorRpm, wheelRpm, minRequiredRpm, newAcc*100, tostring(self.vcaAutoStop), self.vcaClutchTimer )
		
		self.vcaGearIndex  = gear
		self.vcaLastGear   = self.vehicle.vcaGear
		self.vcaLastRange  = self.vehicle.vcaRange
		
		curGearRatio       = self.maxRpm / ( maxSpeed * vehicleControlAddon.factor30pi ) 
		self.minGearRatio  = curGearRatio
		self.maxGearRatio  = curGearRatio
		
		if lastGearRatio ~= nil and self.gearChangeTimer <= 0 and self.vcaClutchTimer <= 0 and self.vcaGearChangeTime ~= nil then 
			local t = 100
			if lastGearRatio < curGearRatio then 
				t = 500
			elseif maxSpeed < 3 then 
				t = t + ( 3 - maxSpeed ) * 100 
			end 
			if g_currentMission.time - self.vcaGearChangeTime < t then 
				local f = ( g_currentMission.time - self.vcaGearChangeTime ) / t
				self.minGearRatio      = f * curGearRatio + ( 1 - f ) * lastGearRatio
				self.maxGearRatio      = curGearRatio
				self.vcaGearRatio      = lastGearRatio
				if lastGearRatio > curGearRatio then
					newAcc               = 0
				end 
			else
				self.vcaGearRatio      = curGearRatio
				self.vcaGearChangeTime = nil 
			end 
		else 
			self.vcaGearRatio = curGearRatio
		end 
				
		-- *******************************************
		-- clutch
		local clutchFactor = 0 
		if self.vehicle:vcaGetAutoClutch() then 
			if self.vehicle.vcaClutchPercent > 0 then 
				self.vcaClutchTimer = math.max( self.vcaClutchTimer, self.vehicle.vcaClutchPercent * VCAGlobals.clutchTimer )
			end 
			if self.maxRpm * self.speedLimit < 3 * self.minRpm * maxSpeed then 
				self.vcaClutchTimer = vehicleControlAddon.mbClamp( ( 1 - self.maxRpm * self.speedLimit  / ( 3 * self.minRpm * maxSpeed ) ) * VCAGlobals.clutchTimer, self.vcaClutchTimer, VCAGlobals.clutchTimer - 1 )
				fakeRpm = 0.9 * self.minRpm 
			end 
			clutchFactor = math.max( self.vcaClutchTimer / VCAGlobals.clutchTimer, 0 )
			self.vehicle.vcaClutchDisp = clutchFactor 
			if     self.vehicle.vcaClutchDisp <= 0 then 
			elseif 0.99 * self.vcaCurGearRatio > curGearRatio then 
				self.vehicle.vcaClutchDisp = math.min( 1 - curGearRatio / self.vcaCurGearRatio, self.vcaClutchTimer / VCAGlobals.clutchTimer )
			elseif self.vcaCurGearRatio < 0.99 * curGearRatio then 
				self.vehicle.vcaClutchDisp = math.min( 1 - self.vcaCurGearRatio / curGearRatio, self.vcaClutchTimer / VCAGlobals.clutchTimer )
			end 
		else 
			self.vcaClutchTimer          = 0
			clutchFactor                 = self.vehicle.vcaClutchPercent
			self.vehicle.vcaClutchDisp   = self.vehicle.vcaClutchPercent
		end 
		
		self.vehicle.vcaDebugK = debugFormat( "%5.0f > 0 and %5.0f > %5.0f and %5.0f <= 0 and %4.0f < %4.0f = %s",
																						self.vcaClutchTimer,
																						wheelRpm,
																						self.minRpm,
																						self.gearChangeTimer,
																						self.vcaCurGearRatio,
																						1.1 * curGearRatio,
																						tostring( self.vcaClutchTimer > 0 and wheelRpm > self.minRpm and self.gearChangeTimer <= 0 and self.vcaCurGearRatio < 1.1 * curGearRatio ) )

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
			
			self.vcaClutchTimer        = VCAGlobals.clutchTimer
			self.vcaMinRpm             = vehicleControlAddon.mbClamp( wheelRpm, self.minRpm, self.maxRpm ) --self.vcaFakeRpm
			self.vcaMaxRpm             = vehicleControlAddon.mbClamp( wheelRpm, self.minRpm, self.maxRpm ) --self.vcaFakeRpm
			self.minGearRatio          = 1
			self.maxGearRatio          = 1000000
			self.vehicle.vcaClutchDisp = 1
		else

			if      self.vcaClutchTimer   > 0
					and self.vcaFakeRpm      == nil
					and 0.9 * curGearRatio < self.vcaCurGearRatio and self.vcaCurGearRatio < 1.1 * curGearRatio
					and wheelRpm             >= 0.8 * self.minRpm then 
				self.vcaClutchTimer = 0
			end 
		
			if     clutchFactor > 0 then 
				local c = clutchFactor ^2 
				local m
				
				m = c * fakeRpm + ( 1 - c ) * vehicleControlAddon.maxRpmF1 * self.maxRpm
				if self.vehicle:vcaGetAutoClutch() and m > clutchCloseRpm then
					m = clutchCloseRpm
				end 
				if m < wheelRpm then 
					m = wheelRpm 
				end 
				if m > vehicleControlAddon.maxRpmF1 * self.maxRpm then 
					m = vehicleControlAddon.maxRpmF1 * self.maxRpm 
				end 
				if lastMaxRpm <= self.maxRpm then 
					m = math.max( m, lastMaxRpm - 0.0005 * dt * rpmRange )
				end 
				self.vcaMaxRpm = m
				
				m = c * fakeRpm 
				if m > self.vcaMaxRpm then 
					m = self.vcaMaxRpm 
				end 
				if lastMinRpm >= self.minRpm then 
					m = math.min( m, lastMinRpm + 0.002 * dt * rpmRange )
				end 
				self.vcaMinRpm = m
				
				self.maxGearRatio = math.min( curGearRatio / ( 1 - c ), 30 * curGearRatio, 300 )
				self.minGearRatio = math.max( curGearRatio * ( 1 - c )^0.1, 0.1 * curGearRatio, 1 )
 			else
				self.vcaMinRpm      = 0
				self.vcaMaxRpm      = vehicleControlAddon.maxRpmF1 * self.maxRpm
			end  
			
			-- *******************************************
			-- idle acceleration
			local fullRpm = idleRpm - 0.25 * self.minRpm
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
	end 
	
	if autoNeutral then 
		self.vcaLastAcc = 0 
		return 0
	end 

	if lastAccPedal == nil then 
		lastAccPedal = 0 
	end 
	
	--****************************************************************************	
	
	self.vcaMaxWheelAccE = nil
	self.vcaMaxMotorAccE = nil

	if self.vcaDirTimer ~= nil or self.vcaMaxAccFactor == nil then  
		self.vcaMaxAccFactor  = 0.01
		self.vcaMaxWheelAcc   = self.accelerationLimit
		self.vcaMaxMotorAcc   = self.motorRotationAccelerationLimit

		self.vcaLastNValues   = nil 
		self.vcaMaxWheelSpeed = math.huge
		self.vcaMaxMotorSpeed = math.huge
	else
		local maxAccFactor    = vehicleControlAddon.mbClamp( 3 * ( 1 - self.vcaUsedTorqueRatioF ), 0.01, 1 )
		self.vcaMaxAccFactor  = math.min( maxAccFactor, self.vcaMaxAccFactor + 0.004 * dt )
		self.vcaMaxWheelAcc   = self.vcaMaxAccFactor * self.accelerationLimit
		self.vcaMaxMotorAcc   = self.vcaMaxAccFactor * self.motorRotationAccelerationLimit

		local acc = self.vcaMaxWheelAcc 
		if curGearRatio ~= nil then 
			acc = math.min( acc, self.vcaMaxMotorAcc / curGearRatio )
		end 
		
		self.vcaMaxWheelSpeed = math.max( 0.2, expectedWheelSpeed + math.max( dt, 40 ) * 0.001 * acc )
		self.vcaMaxMotorSpeed = math.max( self.minRpm * vehicleControlAddon.factorpi30, expectedMotorSpeed + math.max( dt, 40 ) * 0.001 * self.vcaMaxMotorAcc )
		
		self.vcaMaxWheelAccE  = 2 * self.accelerationLimit
		self.vcaMaxMotorAccE  = 2 * self.motorRotationAccelerationLimit
		local sl = self.vcaMaxWheelSpeed
		if curGearRatio ~= nil and self.vcaFakeTimer == nil and self.gearChangeTimer <= 0 and self.vcaClutchTimer ~= nil and self.vcaClutchTimer <= 0 then 
			sl = math.min( sl, math.max( speedMS, self.vcaMaxMotorSpeed / curGearRatio ) )
		end 
		self.speedLimit       = math.min( self.speedLimit, sl * 3.6 )
	end 

	self.vehicle.vcaDebugSL = debugFormat("a:%5.3f, p:%5.3f, l:%7.3f, l1:%7.3f, l2:%7.3f\nw:%7.3f, s:%7.3f, s2:%7.3f, e:%7.3f\n aw:%7.3f, a1:%7.3f, a2:%7.3f, am:%7.3f, a1:%7.3f, a2:%7.3f", 
																				newAcc, self.vehicle.vcaWheelSlip, self.speedLimit, self.vcaLastSpeedLimit, self.vcaMaxWheelSpeed * 3.6, 
																				wheelSpeed*3.6, speed, speed * ( 1 + self.vehicle.vcaWheelSlip ), expectedWheelSpeed*3.6, 
																				self.vcaMaxWheelAcc, maxWheelAcc, avgWheelAcc, self.vcaMaxMotorAcc, maxMotorAcc, avgMotorAcc )
	if curGearRatio ~= nil then 
		self.vehicle.vcaDebugSL = self.vehicle.vcaDebugSL .. debugFormat( ", amw:%7.3f", self.vcaMaxMotorAcc / curGearRatio )
	end 
	
	self.vcaLastAcc = newAcc 
	return newAcc
	
end 

VehicleMotor.updateGear = Utils.overwrittenFunction( VehicleMotor.updateGear, vehicleControlAddon.vcaUpdateGear )

function vehicleControlAddon:vcaGetMaxClutchTorque( superFunc, ... )
	if not ( self.vehicle ~= nil and self.vehicle.vcaIsLoaded ) then 
		return superFunc( self, ... )
	end 
	if not ( self.vehicle.vcaIsLoaded and self.vehicle:vcaGetTransmissionActive() and self.vcaClutchTimer ~= nil and self.vcaGearRatio ~= nil ) then 
		return superFunc( self, ... )
	end 
	if self.vehicle:vcaGetNeutral() or self.gearChangeTimer > 0 or self.vcaClutchTimer >= VCAGlobals.clutchTimer then 
		return 0
	end 		
	return superFunc( self, ... )
end 

VehicleMotor.getMaxClutchTorque = Utils.overwrittenFunction( VehicleMotor.getMaxClutchTorque, vehicleControlAddon.vcaGetMaxClutchTorque )

function vehicleControlAddon:vcaGetTotalConsumedPtoTorque( superFunc, excludeVehicle, ... )

	-- getTotalConsumedPtoTorque is called twice:
	-- 1. WheelsUtil.updateWheelsPhysics
	-- 2. PowerConsumer:getCanBeTurnedOn
	if excludeVehicle ~= nil then 
	-- exclude case 2
		return superFunc( self, excludeVehicle, ... )
	end 

	if      self.spec_motorized ~= nil
			and self.spec_motorized.motor ~= nil
			and self.spec_motorized.motor.vcaClutchMinusTorque ~= nil 
			then 
		self.spec_motorized.motor.vcaClutchMinusTorque = nil 
		self.vcaDebugT = ""
	end 
	
	if not ( self.vcaIsLoaded 
			 and self:vcaGetTransmissionActive()
			 and self:vcaGetNoIVT() 
			 and self.spec_motorized ~= nil 
			 and self.spec_motorized.motor ~= nil
			 and self.spec_motorized.motor.gearRatio ~= nil
			 and self.spec_motorized.motor.vcaGearRatio ~= nil
			 and self.spec_motorized.motor.vcaUsedClutchTorqueS ~= nil 
			 and self.spec_motorized.motor.vcaUsedClutchTorqueS > 0 )
			then 
		return superFunc( self, excludeVehicle, ... )
	end 
	
	local motor = self.spec_motorized.motor 
	
	if     self:vcaGetNeutral()
			or motor.gearChangeTimer > 0
			or motor.ptoMotorRpmRatio <= 0
			or self.vcaClutchDisp >= 1 then 
		return superFunc( self, excludeVehicle, ... )
	end 
	
	local f = math.abs( motor.gearRatio ) / motor.vcaGearRatio 	
	if self.vcaTurboClutch then 
		f = f / 3 
	end 
	if f <= 1.01 then 
		return superFunc( self, excludeVehicle, ... )
	end 
	
	local p = superFunc( self, excludeVehicle, ... )
	if p > 0 then 
		p = p / motor.ptoMotorRpmRatio 
	end 
	motor.vcaClutchMinusTorque = math.max( 0, ( motor.motorAvailableTorque - p ) ) * math.min( 0.99, 1 - 1 / f )
	
	self.vcaDebugT = debugFormat( "%7.1f: (%5.3f, %5.3f, %7.1f, %7.1f, %7.1f)", motor.vcaClutchMinusTorque*1000, f, motor.ptoMotorRpmRatio, 
																		motor.motorAvailableTorque*1000, 
																		(motor.motorAppliedTorque-motor.motorExternalTorque)*1000,
																		(motor.motorAvailableTorque-motor.vcaClutchMinusTorque-p)*1000)
	
	return motor.ptoMotorRpmRatio * math.min( 0.99 * motor.motorAvailableTorque, motor.vcaClutchMinusTorque + p )
end 

PowerConsumer.getTotalConsumedPtoTorque = Utils.overwrittenFunction( PowerConsumer.getTotalConsumedPtoTorque, vehicleControlAddon.vcaGetTotalConsumedPtoTorque )

function vehicleControlAddon:vcaGetCanMotorRun( superFunc, ... )
	if self.vcaForceStopMotor ~= nil and self.vcaForceStopMotor > 0 then 
		return false 
	end 
	return superFunc( self, ... )
end

Motorized.getCanMotorRun = Utils.overwrittenFunction( Motorized.getCanMotorRun, vehicleControlAddon.vcaGetCanMotorRun )
--******************************************************************************************************************************************

function vehicleControlAddon:vcaUpdateMotorProperties( superFunc, ... )

	local motor = self:getMotor()	
	
	local reset = false 
	if motor ~= nil and self.vcaGearbox ~= nil then 
		reset = true 
	
		motor.vcaMinRpm = motor.minRpm 
		motor.vcaMaxRpm = motor.maxRpm 

		motor.minRpm = 0
		motor.maxRpm = vehicleControlAddon.maxRpmF1 * motor.vcaMaxRpm
	end 
	
	superFunc( self, ... )
	
	if reset then 
		motor.minRpm = motor.vcaMinRpm
		motor.maxRpm = motor.vcaMaxRpm
	end 
	
end 

Motorized.updateMotorProperties = Utils.overwrittenFunction( Motorized.updateMotorProperties, vehicleControlAddon.vcaUpdateMotorProperties )
--******************************************************************************************************************************************

function vehicleControlAddon:vcaGetTorqueAndSpeedValues( superFunc )

	if self.vehicle.vcaGearbox ~= nil then 
		local rotationSpeeds = {}
		local torques = {}

		local numKeyFrames = #self.torqueCurve.keyframes
		if numKeyFrames < 1 then 
			self.vcaMaxPowerRpmL = self.minRpm 
			self.vcaMaxPowerRpmH = self.maxRpm 
		else
			local listL, listH
			local tMax, vLast  = 0, 0
			local tOver, vOver
			
			for i,v in ipairs(self.torqueCurve.keyframes) do
				local rotSpeed = v.time * vehicleControlAddon.factorpi30
				local torque = self:getTorqueCurveValue(v.time)
				local p = rotSpeed*torque

				if i == 1 then 
					table.insert(rotationSpeeds, 0)
					table.insert(torques, torque)
				end 
				if i == 1 or self.vcaMaxRpm == nil or v.time <= self.vcaMaxRpm then  
					table.insert(rotationSpeeds, rotSpeed)
					table.insert(torques, torque)
					tMax  = v.time
					vLast = torque 
					if i == 2 and torques[3] > torques[2] and rotationSpeeds[3] > rotationSpeeds[2] then
						torques[1] = math.max( 0, torques[3] - rotationSpeeds[3] * ( torques[3] - torques[2] ) / ( rotationSpeeds[3] - rotationSpeeds[2] ) ) 
					end 

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
				elseif tOver == nil then 
					tOver = v.time
					vOver = torque 
				end 
			end 
		
			-- last real torque value at vcaMaxRpm 
			if self.vcaMaxRpm ~= nil and tMax < self.vcaMaxRpm - 1 and tOver ~= nil then  			
				vLast = vLast + ( self.vcaMaxRpm - tMax ) * ( vOver - vLast ) / ( tOver - tMax )
				tMax  = self.vcaMaxRpm
				table.insert(rotationSpeeds, tMax*vehicleControlAddon.factorpi30)
				table.insert(torques, vLast )
			end 
			-- at a smooth ending
			if tMax * vehicleControlAddon.maxRpmF0 < self.maxRpm then 
				tMax  = tMax * vehicleControlAddon.maxRpmF0
				vLast = 0
				table.insert(rotationSpeeds, tMax*vehicleControlAddon.factorpi30)
				table.insert(torques, vLast)
			end 
			-- 0 torque at maxRpm 
			if tMax < self.maxRpm then 	
				tMax = self.maxRpm
				table.insert(rotationSpeeds, tMax*vehicleControlAddon.factorpi30)
				table.insert(torques, 0)
			end 
		
			numKeyFrames = #listL
			self.vcaMaxPowerRpmL = listL[numKeyFrames].r
			if numKeyFrames > 1 then 
				local i = numKeyFrames - 1 
				local p = 0.97 * listL[numKeyFrames].p
				while i > 1 and listL[i].p > p do 
					i = i - 1
				end 
				if listL[i].p < p then 
					self.vcaMaxPowerRpmL = listL[i].r + ( p - listL[i].p ) * ( listL[numKeyFrames].r - listL[i].r ) / ( listL[numKeyFrames].p - listL[i].p )
				else 
					self.vcaMaxPowerRpmL = listL[i].r
				end 
			end 
			
			numKeyFrames = #listH
			self.vcaMaxPowerRpmH = listH[1].r
			if numKeyFrames > 1 then 
				local i = 2 
				local p = 0.97 * listH[1].p
				while i < numKeyFrames and listH[i].p > p do 
					i = i + 1
				end 
				if listH[i].p < p then 
					self.vcaMaxPowerRpmH = listH[i].r + ( p - listH[i].p ) * ( listH[1].r - listH[i].r ) / ( listH[1].p - listH[i].p )
				else 
					self.vcaMaxPowerRpmH = listH[i].r
				end 
			end 
		end 
		
		for i=1,#rotationSpeeds do	
			vehicleControlAddon.debugPrint(string.format("%5.0f, %5.0f",rotationSpeeds[i]*30/math.pi, torques[i]*1000))
		end 
		
		vehicleControlAddon.debugPrint(string.format("%5.0f .. %5.0f", self.vcaMaxPowerRpmL, self.vcaMaxPowerRpmH ))
		vehicleControlAddon.debugPrint(string.format("%5.0f .. %5.0f", self.vcaMinRpm, self.vcaMaxRpm ))
		vehicleControlAddon.debugPrint(string.format("%5.0f .. %5.0f", self.minRpm, self.maxRpm ))
		
		return torques, rotationSpeeds
	end 
	return superFunc( self )
end 

VehicleMotor.getTorqueAndSpeedValues = Utils.overwrittenFunction( VehicleMotor.getTorqueAndSpeedValues, vehicleControlAddon.vcaGetTorqueAndSpeedValues )
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
	local t = superFunc( self )
	if self.vcaClutchMinusTorque ~= nil then 
		t = math.max( t - self.vcaClutchMinusTorque ) 
	end 
	return t
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
		
		if self.isServer and new and self.vcaSnapDistance < 0.1 then
			local d, o, p = self:vcaGetSnapDistance()
			self:vcaSetState( "vcaSnapDistance", d, noEventSend )
			self:vcaSetState( "vcaSnapOffset1",  o, noEventSend )
			self:vcaSetState( "vcaSnapOffset2",  p, noEventSend )
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
--	vehicleControlAddon.debugPrint("vcaOnSetLastSnapAngle: "..tostring(new))
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
		local v = 0.4 * self.vcaBlowOffVolume * new 
		if v > 0 then
			if isSamplePlaying( vehicleControlAddon.bovSample ) then
				setSampleVolume( vehicleControlAddon.bovSample, v )
			else 
				playSample( vehicleControlAddon.bovSample, 1, v, 0, 0, 0)
			end 
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
	vehicleControlAddon.debugPrint("vcaOnSetGear: "..string(old).."->"..tostring(new))
	self.vcaGear = new 
	printCallstack()
end
 
function vehicleControlAddon:vcaOnSetRange( old, new, noEventSend )
	vehicleControlAddon.debugPrint("vcaOnSetRange: "..string(old).."->"..tostring(new))
	self.vcaRange = new 
	printCallstack()
end

function vehicleControlAddon:vcaOnSetWarningText( old, new, noEventSend )
	self.vcaWarningText  = new
  self.vcaWarningTimer = 2000
end

function vehicleControlAddon:vcaOnSetOwn( name, old, new, noEventSend )
	self[name] = new 
  if self.vcaGearbox ~= nil then 
		self.vcaGearbox:delete() 
	end 
	self.vcaGearbox = nil 
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

function vehicleControlAddon.vcaSpeedInt2Ext( speed )
	if not ( type( speed ) == "number" ) then 
		return -1
	end 
	local s = speed * 3.6 
	if g_gameSettings.useMiles then 
		s = s * 0.621371
	end 
	return 0.1 * math.floor( 10 * s + 0.5 )
end 
function vehicleControlAddon.vcaSpeedExt2Int( speed )
	if not ( type( speed ) == "number" ) then 
		return -1
	end 
	local s = speed / 3.6 
	if g_gameSettings.useMiles then 
		s = s / 0.621371
	end 
	return s
end 
function vehicleControlAddon.vcaSpeedToString( speed, numberFormat )
	if speed == nil then	
		return "nil" 
	end 
	local s = vehicleControlAddon.vcaSpeedInt2Ext( speed )
	local u = "km/h" 
	if g_gameSettings.useMiles then 
		u = "mph"
	end 
	local f = numberFormat
	if f == nil then 
		if math.abs( s ) < 9.95 then 
			f = "%3.1f" 
		else 
			f = "%3.0f"
		end 
	end 
	return string.format( f, s ).." "..u 	
end 


function vehicleControlAddon:vcaShowSettingsUI()

	if g_gui:getIsGuiVisible() then
		return 
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
	self.vcaUI.vcaBrakeForce_V = { 0, 0.05, 0.10, 0.15, 0.2, 0.25, 0.4, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2 }
	self.vcaUI.vcaBrakeForce = {}
	for i,e in pairs( self.vcaUI.vcaBrakeForce_V ) do
		self.vcaUI.vcaBrakeForce[i] = string.format("%3.0f %%", 100 * e )
	end
	self.vcaUI.vcaTransmission = { "off" }
	for i,t in pairs(vehicleControlAddonTransmissionBase.transmissionList) do 
		table.insert( self.vcaUI.vcaTransmission , t.text )
	end 
	
	self.vcaUI.oldTransmission = self.vcaTransmission
	
	self.vcaUI.vcaSnapDraw = { vehicleControlAddon.getText("vcaValueNever", "NEVER"), 
														 vehicleControlAddon.getText("vcaValueInactive", "INACTIVE"), 
														 vehicleControlAddon.getText("vcaValueAlways", "ALWAYS"), 
														 vehicleControlAddon.getText("vcaValueInactiveH", "INACTIVE HIGH"), 
														 vehicleControlAddon.getText("vcaValueAlwaysH", "ALWAYS HIGH"), 
													 }
	
	self.vcaUI.vcaHandthrottle = { vehicleControlAddon.getText("vcaValueOff", "OFF"), "PTO ECO", "90% PTO", "100% PTO" } 
	self.vcaUI.vcaHandthrottle_V = { 0, -0.7, -0.9, -1 }
	local m1 = self.spec_motorized.motor.minRpm 
	local m2 = self.spec_motorized.motor.maxRpm 
	local md = m2 - m1
	
	local r = m1 + 100 
	while r <= m2 do 
		h = ( r - m1 ) / md 
		table.insert( self.vcaUI.vcaHandthrottle, string.format( "%4d %s", r, vehicleControlAddon.getText( "vcaValueRPM", "RPM" ) ) )
		table.insert( self.vcaUI.vcaHandthrottle_V, h )
		r = r + 100
	end 
	
	self.vcaUI.vcaPitchFactor   = {}
	self.vcaUI.vcaPitchFactor_V = {}
	for i=1,15 do 
		local v = 0.8 + ( i - 1 ) * 0.05
		table.insert( self.vcaUI.vcaPitchFactor, string.format( "%3.0f%%", v*100 ) )
		table.insert( self.vcaUI.vcaPitchFactor_V, v )
	end 

	self.vcaUI.vcaPitchExponent   = { "- - - -", "- - -", "- -", "-", vehicleControlAddon.getText( "vcaValueNormal", "NORMAL" ), "+", "+ +" , "+ + +", "+ + + +" }
	self.vcaUI.vcaPitchExponent_V = { 
																		0.609622719,
																		0.681892937,
																		0.761056004,
																		0.871964982,
																		1.000000000,
																		1.118857206,
																		1.257609580,
																		1.424283358,
																		1.633020986,
																	}
	
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

	self.vcaUI.vcaBlowOffVolume = { "0%", "10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%" }
	self.vcaUI.vcaHiredWorker = { vehicleControlAddon.getText("vcaValueOff", "OFF"), 
																vehicleControlAddon.getText("vcaValueEntered", "ENTERED"), 
																vehicleControlAddon.getText("vcaValueAlways", "ALWAYS"), 
															}
														
	self.vcaUI.vcaMaxSpeed     = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed ) )
	self.vcaUI.vcaLaunchSpeed  = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaLaunchSpeed ) )
	
	if self.vcaSnapDistance < 0.1 then
		local d, o, p = self:vcaGetSnapDistance()
		self:vcaSetState( "vcaSnapDistance", d )
		self:vcaSetState( "vcaSnapOffset1", o )
		self:vcaSetState( "vcaSnapOffset2", p )
	end
	self.vcaUI.vcaSnapDistance = tostring( self.vcaSnapDistance )
	self.vcaUI.vcaSnapOffset1  = tostring( self.vcaSnapOffset1 )
	self.vcaUI.vcaSnapOffset2  = tostring( self.vcaSnapOffset2 )
	
	
	self.vcaUI.vcaOwnGears   = {}
	self.vcaUI.vcaOwnRanges  = {}
	self.vcaUI.vcaOwnGearFactor   = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed * self.vcaOwnGearFactor ) )
	self.vcaUI.vcaOwnRangeFactor  = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed * self.vcaOwnGearFactor * self.vcaOwnRangeFactor ) )
	self.vcaUI.vcaOwnRangeFactor2 = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed * self.vcaOwnRangeFactor ) )
	
	for i=1,30 do 
		table.insert( self.vcaUI.vcaOwnGears  , string.format("%d", i ) )
		table.insert( self.vcaUI.vcaOwnRanges , string.format("%d", i ) )
	end 
	
	self.vcaUI.vcaOwnGearTime  = {}
	self.vcaUI.vcaOwnRangeTime = {}
	for i=0,2000,125 do 
		table.insert( self.vcaUI.vcaOwnGearTime,  string.format( "%4d ms", i ) )
		table.insert( self.vcaUI.vcaOwnRangeTime, string.format( "%4d ms", i ) )
	end 
	
	if g_vehicleControlAddonTabbedFrame6.vcaElements.vcaDiffManual ~= nil then 
		local disabled = false 
		if not self.vcaDiffHasF and not self.vcaDiffHasM and not self.vcaDiffHasB then 
			disabled = true 
		end 
		g_vehicleControlAddonTabbedFrame6.vcaElements.vcaDiffManual.element:setDisabled( disabled )
	end 

	if g_vehicleControlAddonTabbedFrame6.vcaElements.vcaDiffFrontAdv ~= nil then 
		g_vehicleControlAddonTabbedFrame6.vcaElements.vcaDiffFrontAdv.element:setDisabled( not self.vcaDiffHasM )
	end 
	
	if g_vehicleControlAddonTabbedFrame6.vcaElements.vcaDiffLockSwap ~= nil then 
		local disabled = false 
		if not self.vcaDiffHasF and not self.vcaDiffHasM and not self.vcaDiffHasB then 
			disabled = true 
		end 
		g_vehicleControlAddonTabbedFrame6.vcaElements.vcaDiffLockSwap.element:setDisabled( disabled )
	end 

	g_vehicleControlAddonTabbedMenu:setShowOwnTransmission( self.vcaTransmission == vehicleControlAddonTransmissionBase.ownTransmission )
	g_gui:showGui( "vehicleControlAddonMenu" )	
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

function vehicleControlAddon:vcaUIGetvcaLaunchSpeed()
	return self.vcaUI.vcaLaunchSpeed
end 
function vehicleControlAddon:vcaUISetvcaLaunchSpeed( value )
	local v = vehicleControlAddon.vcaSpeedExt2Int( tonumber( value ) )
	if type( v ) == "number" and v > 0 and math.abs( v - self.vcaLaunchSpeed ) > 0.01 then
		self:vcaSetState( "vcaLaunchSpeed", v )
	end 
	self.vcaUI.vcaLaunchSpeed = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaLaunchSpeed ) )
end 

function vehicleControlAddon:vcaUIGetvcaMaxSpeed()
	return self.vcaUI.vcaMaxSpeed
end 
function vehicleControlAddon:vcaUISetvcaMaxSpeed( value )
	local v = vehicleControlAddon.vcaSpeedExt2Int( tonumber( value ) )
	if type( v ) == "number" and v > 0 and math.abs( v - self.vcaMaxSpeed ) > 0.01 then
		local g = self.vcaMaxSpeed * self.vcaOwnGearFactor
		local r = self.vcaMaxSpeed * self.vcaOwnRangeFactor
		self:vcaSetState( "vcaMaxSpeed", v )
		self:vcaSetState( "vcaOwnGearFactor",  math.min( g / v, 0.99 ) )
		self:vcaSetState( "vcaOwnRangeFactor", math.min( r / v, 0.99 ) )
		self.vcaUI.vcaOwnGearFactor   = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed * self.vcaOwnGearFactor ) )
		self.vcaUI.vcaOwnRangeFactor2 = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed * self.vcaOwnRangeFactor ) )
		self.vcaUI.vcaOwnRangeFactor  = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed * self.vcaOwnGearFactor * self.vcaOwnRangeFactor ) )
	end 
	self.vcaUI.vcaMaxSpeed = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed ) )
end

function vehicleControlAddon:vcaUIGetvcaOwnGearFactor( isCapturingInput )
	return self.vcaUI.vcaOwnGearFactor
end 
function vehicleControlAddon:vcaUISetvcaOwnGearFactor( value )
	local g = vehicleControlAddon.vcaSpeedExt2Int( tonumber( value  ) )
	if type( g ) == "number" and g > 0 then
		self:vcaSetState( "vcaOwnGearFactor",  math.min( g / self.vcaMaxSpeed, 0.99 ) )
		self.vcaUI.vcaOwnRangeFactor  = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed * self.vcaOwnGearFactor * self.vcaOwnRangeFactor ) )
	end 
	self.vcaUI.vcaOwnGearFactor = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed * self.vcaOwnGearFactor ) )
end 

function vehicleControlAddon:vcaUIGetvcaOwnRangeFactor()
	return self.vcaUI.vcaOwnRangeFactor
end 
function vehicleControlAddon:vcaUISetvcaOwnRangeFactor( value )
	local r = vehicleControlAddon.vcaSpeedExt2Int( tonumber( value ) )
	if type( r ) == "number" and r > 0 then
		self:vcaSetState( "vcaOwnRangeFactor", math.min( r / ( self.vcaMaxSpeed * self.vcaOwnGearFactor ), 0.99 ) )
		self.vcaUI.vcaOwnRangeFactor2 = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed * self.vcaOwnRangeFactor ) )
	end 
	self.vcaUI.vcaOwnRangeFactor = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed * self.vcaOwnGearFactor * self.vcaOwnRangeFactor ) )
end 

function vehicleControlAddon:vcaUIGetvcaOwnRangeFactor2()
	return self.vcaUI.vcaOwnRangeFactor2
end 
function vehicleControlAddon:vcaUISetvcaOwnRangeFactor2( value )
	local r = vehicleControlAddon.vcaSpeedExt2Int( tonumber( value ) )
	if type( r ) == "number" and r > 0 then
		self:vcaSetState( "vcaOwnRangeFactor", math.min( r / self.vcaMaxSpeed, 0.99 ) )
		self.vcaUI.vcaOwnRangeFactor  = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed * self.vcaOwnGearFactor * self.vcaOwnRangeFactor ) )
	end 
	self.vcaUI.vcaOwnRangeFactor2 = tostring( vehicleControlAddon.vcaSpeedInt2Ext( self.vcaMaxSpeed * self.vcaOwnRangeFactor ) )
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
	local v = self.vcaUI.vcaPitchExponent_V[value]
	if v ~= nil then 
		self:vcaSetState( "vcaPitchExponent", v )
	end 
end 

function vehicleControlAddon:setUIGearSpeed( name, value )
	if self == nil then print("setUIGearSpeed nil error 1 ("..tostring(name)..")") return end 
	if value <= 1 then 
		self:vcaSetState( name, 0 )
		return 
	end 
	local speed = self.vcaMaxSpeed * 3.6
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
	local speed = self.vcaMaxSpeed * 3.6
	local v = self[name]
	if v == nil then print("getUIGearSpeed nil error 3 ("..tostring(name)..")") return 1 end 
	if v <= 0 then return 1 end 
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
	local speed = self.vcaMaxSpeed * 3.6
	local s = 5
	while s < speed do 
		table.insert( res, vehicleControlAddon.vcaSpeedToString( s / 3.6 ) ) 
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
	return self.vcaUI.vcaSnapDistance
end 
function vehicleControlAddon:vcaUISetvcaSnapDistance( value )
	local v = tonumber( value )
	if type( v ) == "number" then 
		if v < 0.1 then 
			local d, o, p = self:vcaGetSnapDistance()
			self:vcaSetState( "vcaSnapDistance", d )
			self:vcaSetState( "vcaSnapOffset1", o )
			self:vcaSetState( "vcaSnapOffset2", p )
			self.vcaUI.vcaSnapOffset1 = tostring( self.vcaSnapOffset1 )
			self.vcaUI.vcaSnapOffset2 = tostring( self.vcaSnapOffset2 )
		else 
			self:vcaSetState( "vcaSnapDistance", v )
		end 
	end 
	self.vcaUI.vcaSnapDistance = tostring( self.vcaSnapDistance )
end 

function vehicleControlAddon:vcaUIGetvcaSnapOffset1()
	return self.vcaUI.vcaSnapOffset1
end 
function vehicleControlAddon:vcaUIGetvcaSnapOffset2()
	return self.vcaUI.vcaSnapOffset2
end 
function vehicleControlAddon:vcaUISetvcaSnapOffset1( value )
	local v = tonumber( value )
	if type( v ) == "number" then 
		self:vcaSetState( "vcaSnapOffset1", v )
		if     math.abs( v ) < 0.01 then 
			self:vcaSetState( "vcaSnapOffset2", 0 )
		elseif v * self.vcaSnapOffset2 > 0 then
			self:vcaSetState( "vcaSnapOffset2", v )
		else 
			self:vcaSetState( "vcaSnapOffset2",-v )
		end
	end 
	self.vcaUI.vcaSnapOffset1 = tostring( self.vcaSnapOffset1 )
	self.vcaUI.vcaSnapOffset2 = tostring( self.vcaSnapOffset2 )
end 
function vehicleControlAddon:vcaUISetvcaSnapOffset2( value )
	local v = tonumber( value )
	if type( v ) == "number" then 
		self:vcaSetState( "vcaSnapOffset2", v )
	end
	self.vcaUI.vcaSnapOffset2 = tostring( self.vcaSnapOffset2 )
end 

function vehicleControlAddon:vcaUISetvcaTransmission( value )
	self:vcaSetState("vcaTransmission", value )
	g_vehicleControlAddonTabbedMenu:setShowOwnTransmission( self.vcaTransmission == vehicleControlAddonTransmissionBase.ownTransmission )
end 

function vehicleControlAddon:vcaUIGetvcaBlowOffVolume()
	return vehicleControlAddon.mbClamp( math.floor( self.vcaBlowOffVolume * 10 + 0.5 ), 0, 10 )
end 

function vehicleControlAddon:vcaUISetvcaBlowOffVolume( value )
	self:vcaSetState( "vcaBlowOffVolume", 0.1 * value )
end 

function vehicleControlAddon:vcaUIGetvcaOwnGearTime() 
	return vehicleControlAddon.mbClamp( math.floor( self.vcaOwnGearTime / 125 + 0.5 ), 0, 16 )
end 
function vehicleControlAddon:vcaUISetvcaOwnGearTime( value )
	self:vcaSetState( "vcaOwnGearTime", value * 125 )
end 

function vehicleControlAddon:vcaUIGetvcaOwnRangeTime() 
	return vehicleControlAddon.mbClamp( math.floor( self.vcaOwnRangeTime / 125 + 0.5 ), 0, 16 )
end 
function vehicleControlAddon:vcaUISetvcaOwnRangeTime( value )
	self:vcaSetState( "vcaOwnRangeTime", value * 125 )
end 

function vehicleControlAddon:vcaUIGetvcaOwnInfo() 
	return tostring(self.vcaOwnGears).." x "..tostring(self.vcaOwnRanges)
end 

function vehicleControlAddon:vcaGetNumberOfGears()
	if self.vcaTransmission == vehicleControlAddonTransmissionBase.ownTransmission then 
		return self.vcaOwnGears, self.vcaOwnRanges
	end 
	
	local def = vehicleControlAddonTransmissionBase.transmissionList[self.vcaTransmission]
	if def ~= nil and def.params ~= nil then 
		if def.params.isIVT then
			return 1, 1 + #def.params.rangeGearOverlap
		end 
		return def.params.noGears, 1 + #def.params.rangeGearOverlap
	end 
	return 0, 0
end

function vehicleControlAddon:vcaUIDrawvcaSingleReverse()
	local texts = { "off" }
	local ng, nr = vehicleControlAddon.vcaGetNumberOfGears( self )
	if ng > 1 then 
		for i =1,ng do 
			table.insert( texts, "Gear "..tostring(i) )
		end 
	end 
	if nr > 1 then 
		for i =1,nr do 
			table.insert( texts, "Range "..tostring(i) )
		end 
	end 
	return texts 
end 
function vehicleControlAddon:vcaUIGetvcaSingleReverse()
	if self.vcaSingleReverse >= 0 then 
		return 1 + self.vcaSingleReverse
	end 
	local ng, nr = vehicleControlAddon.vcaGetNumberOfGears( self )
	if ng > 1 then 
		return 1 + ng - self.vcaSingleReverse
	end
	return 1 - self.vcaSingleReverse
end 
function vehicleControlAddon:vcaUISetvcaSingleReverse( value )
	if value <= 1 then 
		self:vcaSetState( "vcaSingleReverse", 0 )
	else 
		local ng, nr = vehicleControlAddon.vcaGetNumberOfGears( self )
		if     ng <= 1 then 
			self:vcaSetState( "vcaSingleReverse", 1 - value )
		elseif value <= 1 + ng then 
			self:vcaSetState( "vcaSingleReverse", value - 1 )
		else
			self:vcaSetState( "vcaSingleReverse", 1 + ng - value )
		end 
	end 
end 

