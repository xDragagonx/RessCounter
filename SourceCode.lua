-- counter keeps adding to targets when mounting || Solved, was using https://alloder.pro/md/LuaApi/FunctionCommonUnRegisterEventHandler.html instead of https://alloder.pro/md/LuaApi/FunctionCommonUnRegisterEvent.html, so it would always register still. Ask pasidaips how it works with the if name == gift of tensess.
-- Make it only work when out of combat
--Use common.LogInfo("common", "-"..name.."-") --Log to mods.txt
--Use tostring() to concatenate non-string values in ChatLog()
-- Solved:
--  Error while running the chunk
--   [string "Mods/Addons/RessCounter/Script.luac"]:0: attempt to perform arithmetic on a nil value
--   func: __sub, metamethod, line: -1, defined: C, line: -1, [C]
--     func: ?, ?, line: 0, defined: Lua, line: 0, [string "Mods/Addons/RessCounter/Script.luac"]
local ressCounter={}
local raidMemberName
local spellName
local raidExists = false
local targetName
local inCombat = false
local avatarId
local spellFailed = false
local spellFinished = false
function Main()
	avatarId = avatar.GetId()
	ressCounter = userMods.GetGlobalConfigSection("RessCounter_settings")
	common.RegisterEventHandler(OnChat, "EVENT_UNKNOWN_SLASH_COMMAND")
	common.RegisterEventHandler(EVENT_ACTION_PROGRESS_START, "EVENT_ACTION_PROGRESS_START") --https://alloder.pro/md/LuaApi/EventActionProgressStart.html
	common.RegisterEventHandler(EVENT_ACTION_FAILED_SPELL, "EVENT_ACTION_FAILED_SPELL") --https://alloder.pro/md/LuaApi/EventActionFailedSpell.html
	common.RegisterEventHandler(EVENT_ACTION_PROGRESS_FINISH, "EVENT_ACTION_PROGRESS_FINISH") --https://alloder.pro/md/LuaApi/EventActionProgressFinish.html
	common.RegisterEventHandler(InCombat, "EVENT_OBJECT_COMBAT_STATUS_CHANGED")
end
function EVENT_ACTION_PROGRESS_START(params)
	if params.progress == 0 then --Prevent this event from doing everything twice, cause it does so by default
		return
	end
	-- local duration = params.duration
	-- local progress = params.progress
	spellName = userMods.FromWString(params.name)
	-- local launchWhenReady = params.launchWhenReady
	-- local spellId = params.spellId
	-- local isPrecast = params.isPrecast
	-- local isChannel = params.isChannel
	--ChatLog(duration, spellName, progress, launchWhenReady, spellId, isPrecast, isChannel)

	--Getting target name
	local targetId = avatar.GetTarget()
	if targetId then
		targetName = userMods.FromWString(object.GetName(targetId))
		--ChatLog(target)
	else
		targetName = nil
	end

	--Getting raid members and giving the playername that is also in my target a start value of 0
	local foundTarget = false
	raidExists = raid.IsExist()
	if raidExists then
		local raidMembers = raid.GetMembers()
		for k, v in pairs(raidMembers) do
			for kk, vv in pairs (v) do
				--ChatLog("vv: ",vv)
				raidMemberName = userMods.FromWString(vv.name)
				--ChatLog("raidMemberName: ",raidMemberName)
				--ChatLog("We're now comparing if targetName:",targetName,"is the same as raidMemberName:",raidMemberName)
				if targetName == raidMemberName then
					--ChatLog("inside when targetname is same as raidMemberName")
					if not ressCounter[raidMemberName] then
						ressCounter[raidMemberName] = 0
						--ChatLog("Player table created")
					end
					foundTarget = true
					break
				end
			end
			if foundTarget then
				break
			end
		end
	end
end
function EVENT_ACTION_PROGRESS_FINISH()
	spellFinished = true
	--ChatLog("Entering finish func")
	--ChatLog(inCombat, spellName, raidExists, targetName,"=", raidMemberName)
	--ChatLog("in finished. in combat is ",inCombat,". spellName is",spellName,". the raid exists: ",raidExists,". and targetname is: ",targetName,". raidMemberName is: ", raidMemberName)
	if not inCombat and spellName == locales["ressName"] and raidExists and targetName == raidMemberName then
		--ChatLog("in finished. in combat is ",inCombat,". spellName is",spellName,". the raid exists: ",raidExists,". and targetname is: ",targetName,". raidMemberName is: ", raidMemberName)
		ressCounter[raidMemberName] = ressCounter[raidMemberName] + 1
		RessedFeedback(spellFinished,false)
	end
end
function EVENT_ACTION_FAILED_SPELL(params)
	--ChatLog("entering fail func")
	spellFinished = false
	spellFailed = true
	local sysId = params.sysId
	local unitId = params.unitId
	local spellId = params.spellId
	local isInNotPredicate = params.isInNotPredicate
	--ChatLog(sysId, unitId, spellId, isInNotPredicate)
	--sysId when too late ressing: ENUM_ActionFailCause_NotDead
	--ChatLog("in failed. in combat is ",inCombat,". spellName is",spellName,". the raid exists: ",raidExists,". and targetname is: ",targetName,". raidMemberName is: ", raidMemberName)
	if not inCombat and spellName == locales["ressName"] and raidExists and targetName == raidMemberName then
	--	ChatLog("in failed. in combat is ",inCombat,". spellName is",spellName,". the raid exists: ",raidExists,". and targetname is: ",targetName,". raidMemberName is: ", raidMemberName)
		if ressCounter[raidMemberName] >= 1 then
			ressCounter[raidMemberName] = ressCounter[raidMemberName] - 1
			spellName = nil
			targetName = nil
			RessedFeedback(false, spellFailed)
		end
	end
end
-- function RessedFeedback(finished, failed)
-- 	if finished == true then
-- 		ChatLog(tostring(ressCounter[raidMemberName].name),"has been ressed",tostring(ressCounter[raidMemberName].value),"times.")
-- 	end
-- 	if failed == true then
-- 		ChatLog("Failed ressing the player")
-- 	end
-- 	spellFailed = false
-- 	spellFinished = false
-- end
function RessedFeedback(finished, failed)
    if finished and not failed then
        -- Display message for function 1 only
        ChatLog(tostring(ressCounter[raidMemberName].name).." has been ressed "..tostring(ressCounter[raidMemberName].value).." times.")
    elseif failed and not finished then
        -- Display message for function 2 only
        ChatLog("Failed ressing the player")
    end
    spellFailed = false
    spellFinished = false
end
function InCombat(params)
	local objectId = params.objectId
	if avatarId == objectId then
		inCombat = params.inCombat
	end
end
function OnChat(params)
	--common.UnRegisterEvent("EVENT_UNKNOWN_SLASH_COMMAND")
	local inputText = userMods.FromWString(params.text)
	if inputText == "/rcreset" then
		ressCounter = {}
		userMods.SetGlobalConfigSection("RessCounter_settings", ressCounter)
		ChatLog("RessCounter resetted.")
	end
	if inputText == "/rclist" then
		if next(ressCounter) == nil then
			ChatLog(locales["noData"])
		else
			for name, count in pairs(ressCounter) do
				ChatLog(name,locales["chatLogMid"],count,locales["chatLogEnd"])
			end
			userMods.SetGlobalConfigSection("RessCounter_settings", ressCounter)
		end
	end
end

if (avatar.IsExist()) then
	ChatLog("Loaded.")
	Main()
else
	ChatLog("Loaded.")
	common.RegisterEventHandler(Main, "EVENT_AVATAR_CREATED")
end