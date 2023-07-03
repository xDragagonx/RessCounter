--------------------------------------------------------------------------------
-- String functions
--------------------------------------------------------------------------------

local _lower = string.lower
local _upper = string.upper

function string.lower(s)
    return _lower(s:gsub("([�-�])",function(c) return string.char(c:byte()+32) end):gsub("�", "�"))
end

function string.upper(s)
    return _upper(s:gsub("([�-�])",function(c) return string.char(c:byte()-32) end):gsub("�", "�"))
end

function toWString(text)
	if not text then return nil end
	if not common.IsWString(text) then
		text=userMods.ToWString(tostring(text))
	end
	return text
end

local function toStringUtils(text)
	if not text then return nil end
	if common.IsWString(text) then
		text=userMods.FromWString(text)
	end
	return tostring(text)
end

function toString(text)
	return userMods.FromWString(text)
end

function toLowerString(text)
	text=toString(text)
	if not text then
		return nil
	end
	return string.lower(text)
end

function toLowerWString(text)
	text=toString(text)
	if not text then
		return nil
	end
	text=string.lower(text)
	return toWString(text)
end

function find(text, word)
	text=toStringUtils(text)
	word=toStringUtils(word)
	if text and word and word~="" then
		text=string.lower(text)
		word=string.lower(word)
		return string.find(text, word)
	end
	return false
end

function findSimpleString(text, word)
	if text and word and word~="" then
		return string.find(text, word)
	end
	return false
end

function findWord(text)
	if not text then return {} end
	if string.gmatch then return string.gmatch(toString(text), "([^,]+),*%s*") end
	return pairs({toString(text)})
end

function formatText(text, align, fontSize, shadow, outline, fontName)
	return "<body fontname='"..(toStringUtils(fontName) or "AllodsWest").."' alignx = '"..(toStringUtils(align) or "left").."' fontsize='"..(toStringUtils(fontSize) or "14").."' shadow='"..(toStringUtils(shadow) or "0").."' outline='"..(toStringUtils(outline) or "1").."'><rs class='color'>"..(toStringUtils(text) or "").."</rs></body>"
end

function toValuedText(text, color, align, fontSize, shadow, outline, fontName)
	local valuedText=common.CreateValuedText()
	text=toWString(text)
	if not valuedText or not text then return nil end
	valuedText:SetFormat(toWString(formatText(text, align, fontSize, shadow, outline, fontName)))
	if color then
		valuedText:SetClassVal( "color", color )
	else
		valuedText:SetClassVal( "color", "LogColorYellow" )
	end
	return valuedText
end

function compareStrWithConvert(aName1, aName2)
	local name1=toWString(aName1)
	local name2=toWString(aName2)
	if not name1 or not name2 then return nil end
	return common.CompareWString(name1, name2)==0
end

function compare(name1, name2)
	name1=toWString(name1)
	name2=toWString(name2)
	if not name1 or not name2 then return nil end
	return common.CompareWStringEx(name1, name2)==0
end

function getTimeString(ms)
	if		ms<1000	then return "0."..tostring(round(ms/100)).."s"
	else   	ms=round(ms/1000) end
	if		ms<60	then return tostring(ms).."s"
	else    ms=math.floor(ms/60) end
	if		ms<60	then return tostring(ms).."m"
	else    ms=round(ms/60) end
	if		ms<24	then return tostring(ms).."h"
	else    ms=round(ms/24) end
	return tostring(ms).."d"
end

function makeColorMoreGray(aColor)
	local grayedColor = {}
	grayedColor.r = aColor.r - 0.3
	grayedColor.g = aColor.g - 0.3
	grayedColor.b = aColor.b - 0.3
	grayedColor.a = aColor.a
	grayedColor.r = grayedColor.r > 0 and grayedColor.r or 0
	grayedColor.g = grayedColor.g > 0 and grayedColor.g or 0
	grayedColor.b = grayedColor.b > 0 and grayedColor.b or 0
	
	return grayedColor
end

function makeColorMoreTransparent(aColor)
	local grayedColor = {}
	grayedColor.r = aColor.r
	grayedColor.g = aColor.g
	grayedColor.b = aColor.b
	grayedColor.a = aColor.a - 0.4
	grayedColor.a = grayedColor.a > 0 and grayedColor.a or 0
	
	return grayedColor
end

function compareColor(aColor1, aColor2)
	if not aColor1 or not aColor2 then
		return false
	end
	if aColor1.r ~= aColor2.r or aColor1.g ~= aColor2.g or aColor1.b ~= aColor2.b or aColor1.a ~= aColor2.a then
		return false
	end
	return true
end

--------------------------------------------------------------------------------
-- Widget funtions
--------------------------------------------------------------------------------

Global("WIDGET_ALIGN_LOW", 0)
Global("WIDGET_ALIGN_HIGH", 1)
Global("WIDGET_ALIGN_CENTER", 2)
Global("WIDGET_ALIGN_BOTH", 3)
Global("WIDGET_ALIGN_LOW_ABS", 4)

function destroy(widget)
	if widget and widget.DestroyWidget then widget:DestroyWidget() end
end

function isVisible(widget)
	if widget and widget.IsVisible then return widget:IsVisible() end
	return nil
end

function getChild(widget, name, g)
	if g==nil then g=false end
	if not widget or not widget.GetChildUnchecked or not name then return nil end
	return widget:GetChildUnchecked(name, g)
end

function move(widget, posX, posY)
	if not widget then return end
	local BarPlace=widget.GetPlacementPlain and widget:GetPlacementPlain()
	if not BarPlace then return nil end
	if posX then
		BarPlace.posX = posX
		BarPlace.highPosX = posX
	end
	if posY then
		BarPlace.posY = posY
		BarPlace.highPosY = posY
	end
	if widget.SetPlacementPlain then widget:SetPlacementPlain(BarPlace) end
end

function setFade(widget, fade)
	if widget and fade and widget.SetFade then
		widget:SetFade(fade)
	end
end

function resize(widget, width, height)
	if not widget then return end
	local BarPlace=widget.GetPlacementPlain and widget:GetPlacementPlain()
	if not BarPlace then return nil end
	if width then BarPlace.sizeX = width end
	if height then BarPlace.sizeY = height end
	if widget.SetPlacementPlain then widget:SetPlacementPlain(BarPlace) end
end

function align(widget, alignX, alingY)
	if not widget then return end
	local BarPlace=widget.GetPlacementPlain and widget:GetPlacementPlain()
	if not BarPlace then return nil end
	if alignX then BarPlace.alignX = alignX end
	if alingY then BarPlace.alignY = alingY end
	if widget.SetPlacementPlain then widget:SetPlacementPlain(BarPlace) end
end

function priority(widget, priority)
	if not widget or not priority then return nil end
	if widget.SetPriority then widget:SetPriority(priority) end
end

function show(widget)
	if not widget  then return nil end
	if widget:IsVisible() then return nil end
	widget:Show(true)
end

function hide(widget)
	if not widget  then return nil end
	if not widget:IsVisible()  then return nil end
	widget:Show(false)
end

function setName(widget, name)
	if not widget or not name then return nil end
	if widget.SetName then widget:SetName(name) end
end

function getName(widget)
	return widget and widget.GetName and widget:GetName() or nil
end

function getText(widget)
	return widget and widget.GetText and widget:GetText() or nil
end

function getTextString(widget)
	return widget and widget.GetText and toStringUtils(widget:GetText()) or nil
end

function setText(widget, text, color, align, fontSize, shadow, outline, fontName)
	if not widget then return nil end
	text=toWString(text or "")
	if widget.SetVal 		then widget:SetVal("button_label", text)  end
	--if widget.SetTextColor	then widget:SetTextColor("button_label", { a = 1, r = 1, g = 0, b = 0 } ) end --ENUM_ColorType_SHADOW
	if widget.SetText		then widget:SetText(text) end
	if widget.SetValuedText then widget:SetValuedText(toValuedText(text, color or "ColorWhite", align, fontSize, shadow, outline, fontName)) end
end

function setBackgroundTexture(widget, texture)
	if not widget or not widget.SetBackgroundTexture then return nil end
	widget:SetBackgroundTexture(texture)
end

function setBackgroundColor(widget, color)
	if not widget or not widget.SetBackgroundColor then return nil end
	if not color then color={ r = 0; g = 0, b = 0; a = 0 } end
	widget:SetBackgroundColor(color)
end

local templateWidget=nil
local form=nil

function getDesc(name)
	local widget=templateWidget and name and templateWidget.GetChildUnchecked and templateWidget:GetChildUnchecked(name, false)
	return widget and widget.GetWidgetDesc and widget:GetWidgetDesc() or nil
end

function getParent(widget, num)
	if not num or num<1 then num=1 end
	if not widget or not widget.GetParent then return nil end
	local parent=widget:GetParent()
	if num==1 then return parent end
	return getParent(parent, num-1)
end

function getForm(widget)
	if not widget then return nil end
	if not widget.CreateWidgetByDesc then
		return getForm(getParent(widget))
	end
	return widget
end

function createWidget(parent, widgetName, templateName, alignX, alignY, width, height, posX, posY, noParent)
	local desc=getDesc(templateName)
	if not desc and parent then return nil end
	local owner=getForm(parent)
	local widget=owner and owner:CreateWidgetByDesc(desc) or common.AddonCreateChildForm(templateName)
	if parent and widget and not noParent then parent:AddChild(widget) end --
	setName(widget, widgetName)
	align(widget, alignX, alignY)
	move(widget, posX, posY)
	resize(widget, width, height)
	return widget
end

function setTemplateWidget(widget)
	templateWidget=widget
end

function equals(widget1, widget2)
	if not widget1 or not widget2 then return nil end
	return widget1.IsEqual and widget1:IsEqual(widget2) or widget2.IsEqual and widget2:IsEqual(widget1) or nil
end

function swap(widget)
	if widget and widget.IsVisible and not widget:IsVisible() then
		show(widget)
	else
		hide(widget)
	end
end

function changeCheckBox(widget)
	if not widget or not widget.GetVariantCount then return end
	if not widget.GetVariant or not widget.SetVariant then return end

	if 0==widget:GetVariant() then 	widget:SetVariant(1)
	else 							widget:SetVariant(0) end
end

function setCheckBox(widget, value)
	if not widget or not widget.SetVariant or not widget.GetVariantCount then return end
	if widget:GetVariantCount()<2 then return end
	if 		value 	then 	widget:SetVariant(1) return end
	widget:SetVariant(0)
end

function getCheckBoxState(widget)
	if not widget or not widget.GetVariant then return end
	return widget:GetVariant()==1 and true or false
end

function getModFromFlags(flags)
	local ctrl=flags>3
	if ctrl then flags=flags-4 end
	local alt=flags>1
	if alt then flags=flags-2 end
	local shift=flags>0
	return ctrl, alt, shift
end

--------------------------------------------------------------------------------
-- Timers functions
--------------------------------------------------------------------------------

local template=createWidget(nil, "Template", "Template")
local timers={}

function timer(params)
	if not params.effectType == ET_FADE then return end
	local name=nil
	for i, j in pairs(timers) do
		if j and equals(params.wtOwner, j.widget) then
			name=i
		end
	end
	if not name then return end


	if timers[name] then
		if timers[name].widget and not timers[name].one then
			timers[name].widget:PlayFadeEffect( 1.0, 1.0, timers[name].speed*1000, EA_MONOTONOUS_INCREASE )
		end
		userMods.SendEvent( timers[name].event, {sender = common.GetAddonName()} )
	end
end

function startTimer(name, eventname, speed, one)
	if name and timers[name] then destroy(timers[name].widget) end
	setTemplateWidget(template)
	local timerWidget=createWidget(mainForm, name, "Timer")
	if not timerWidget or not name or not eventname then return nil end
	timers[name]={}
	timers[name].event=eventname
	timers[name].widget=timerWidget
	timers[name].one=one
	timers[name].speed=tonumber(speed) or 1

	common.RegisterEventHandler(timer, "EVENT_EFFECT_FINISHED")
    timerWidget:PlayFadeEffect(1.0, 1.0, timers[name].speed*1000, EA_MONOTONOUS_INCREASE)
	return true
end

function stopTimer(name)
    common.UnRegisterEventHandler( timer, "EVENT_EFFECT_FINISHED" )
end

function setTimeout(name, speed)
	if name and timers[name] and speed then
		timers[name].speed=tonumber(speed) or 1
	end
end

function destroyTimer(name)
	if timers[name] then destroy(timers[name].widget) end
	timers[name]=nil
end

--------------------------------------------------------------------------------
-- Table functions
--------------------------------------------------------------------------------

function GetTableSize( t )
	if not t then
		return 0
	end
	local count = 0
	for k, v in pairs( t ) do
		count = count + 1
	end
	return count
end

--------------------------------------------------------------------------------
-- Table functions
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- EventHandlers
--------------------------------------------------------------------------------
local _events = {}
function ToggleEventHandlers( handlers, state )
	local foo = state and common.RegisterEventHandler or common.UnRegisterEventHandler
	for eventId, handler in pairs(handlers) do
	
		if not _events[eventId] then
		
			_events[eventId] = {}
		
		end

		if _events[eventId][handler] == nil then 
		
			_events[eventId][handler] = false
			
		end

		if _events[eventId][handler] ~= state then
		
			foo( handler, eventId )
			_events[eventId][handler] = state
		
		end
	
	end
end
--------------------------------------------------------------------------------
-- EventHandlers
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- ReactionHandlers
--------------------------------------------------------------------------------
function ToggleReactionHandlers( handlers, state )
	local foo = state and common.RegisterReactionHandler or common.UnRegisterReactionHandler
	for reactionId, handler in pairs(handlers) do foo( handler, reactionId ) end
end
--------------------------------------------------------------------------------
-- ReactionHandlers
--------------------------------------------------------------------------------

function GetConfig( name )
	local cfg = userMods.GetGlobalConfigSection( common.GetAddonName() )
	if not name then return cfg end
	return cfg and cfg[ name ]
end
function SetConfig( name, value )
	local cfg = userMods.GetGlobalConfigSection( common.GetAddonName() ) or {}
	if type( name ) == "table" then
		for i, v in pairs( name ) do cfg[ i ] = v end
	elseif name ~= nil then
		cfg[ name ] = value
	end
	userMods.SetGlobalConfigSection( common.GetAddonName(), cfg )
end

--------------------------------------------------------------------------------
-- Log functions
--------------------------------------------------------------------------------

function logMemoryUsage()
	common.LogInfo( common.GetAddonName(), "usage "..tostring(gcinfo()).."kb" )
	ChatLog(common.GetAddonName(), "usage "..tostring(gcinfo()).."kb")
end

function logText(text)
	common.LogInfo("common", toWString(text))
end

function message(text, color, fontSize)
	local chat=stateMainForm:GetChildUnchecked("ChatLog", false)
	if not chat then
		chat=stateMainForm:GetChildUnchecked("Chat", true)
	else
		chat=chat:GetChildUnchecked("Container", true)
	end
	if not chat then return end

	text=common.GetAddonName()..": "..(toStringUtils(text) or "nil")
	chat:PushFrontValuedText(toValuedText(text, nil, nil, 16, nil, nil, "AllodsSystem"))
end