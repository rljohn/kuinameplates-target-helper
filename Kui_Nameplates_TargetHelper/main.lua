--[[
-- Custom code injector template for Kui_Nameplates_Core
--]]
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local opt = KuiConfigTargetHelper
local config_mod = KuiConfigTargetHelperMod

-- enable this to use 'DevTools_Dump'
-- LoadAddOn("Blizzard_DebugTools")
	
local plugin_fading = nil
local plugin_tank = nil
local tank_spec

--------- Plugin Registration -----------------
-- priority         = Any number. Defines the load order. Default of 5. Plugins with a higher priority are executed later.
-- [max_minor]      = Maximum NKP minor this plugin is known to support. Ignored if nil.
-- [enable_on_load] = Enable this plugin upon initialise. True if nil.
local mod = addon:NewPlugin('KUI_TargetHelper',100,nil)
if not mod then return end

-- UTILITIES ####################################################

local function CanOverwriteHealthColor(f, priority)
    return not f.state.health_colour_priority or
           f.state.health_colour_priority <= priority
end

local function GetPriority()
	return opt.env.Priority + 0.1
end

function mod:LoadClassData()
	opt.class.name, _, _ = UnitClass("player");
	opt.class.spec = GetSpecialization()
	opt.class.specId, opt.class.specName = GetSpecializationInfo(opt.class.spec)
end

function mod:SpecUpdate()

    local was_enabled = tank_spec
	
    local spec = GetSpecialization()
    local role = spec and GetSpecializationRole(spec) or nil

    tank_spec = role == 'TANK'
end

function mod:NameTextColourChange(frame)

	-- early out if the option is disabled
	if (opt.env.NameText == false) then
		return
	end
	
	-- don't display for player frames in pvp
	if (opt.env.DisablePvP) then
		if (UnitPlayerControlled(frame.unit) or frame.state.player == true) then
			return
		end
	end
	
	local col = nil
	
	-- check if we defined a colour for this name
	if opt.env.CustomTargets[frame.state.name] then
		local tmpColor = opt.env.CustomTargets[frame.state.name]
		col = { tmpColor.r, tmpColor.g, tmpColor.b }
		plugin_fading:UpdateFrame(frame)
	end
		
	-- if we did, then lets apply it
	if (col) then
		frame.NameText:SetTextColor(unpack(col))
	end
end

function mod.Fading_FadeRulesReset()
    plugin_fading:AddFadeRule(function(f)
		
		-- non-targets with aura should be drawn
		if (f.state.hasAura == 1) then
			return 1
		end
		
		-- custom targets should be drawn at 100% opacity if in range.
        if f.state.name and opt.env.DisableAlpha == true and opt.env.CustomTargets[f.state.name] then
			if (UnitInRange("unit") == nil) then
				return 1
			end
			
			return 1
		end
		
    end,1)
end

-- returns true if the nameplate has any aura frames
function mod:hasAura(frame)

	-- if our current spec does not have any auras to track, return
	if KuiTargetAuraList[opt.class.specId] == nil then
		return nil
	end
	
	if not frame.Auras or not frame.Auras.frames then 
		return nil
	end

	local result = nil
	
	table.foreach(KuiTargetAuraList[opt.class.specId], function(k,v)

		local ability = v
		local abilityNum = tonumber(ability)
				
		-- it was a regular ability
		if (abilityNum) then

			local entry = opt.env.CustomAuraColors[abilityNum]
			if (entry) then
				local enabled = false
			
				if (entry[opt.class.specId]) then
					enabled = entry[opt.class.specId].enabled
				else
					enabled = entry.enabled
				end
				
				if (enabled) then
					-- iterate through all frames
					for _,auras_frame in pairs(frame.Auras.frames) do
						if (auras_frame.visible) then
							if (auras_frame.visible > 0) then
								-- iterate buttons on the visible frame
								for _,button in ipairs(auras_frame.buttons) do
									-- if button spellID matches our ability
									if (abilityNum == button.spellid) then
										result = entry.color
									end
								end -- for each button
							end -- visible count > 0
						end -- frame is visible
					end -- for each frame
				end -- valid entry
			end -- if enabled
		else
			-- complex ability, requiring multiple hits
			
			local foundCount = 0
			local abilitySum = 0
			
			-- iterate through all abilities
			local allFound = true

			table.foreach(ability, function(k2, v2)
			
				-- find a button that matches this ability
				local found = false

				-- sum up the abilities
				abilitySum = abilitySum + v2
				
				-- iterate through active frames
				for _,auras_frame in pairs(frame.Auras.frames) do
					if (auras_frame.visible and auras_frame.visible > 0) then
						for _,button in ipairs(auras_frame.buttons) do
							if (v2 == button.spellid) then
								found = true
								foundCount = foundCount + 1
								break
							end
						end
					end
				end

				-- if we didn't find a match, the set is invalid
				if (found == false) then
					allFound = false
				end
			end)
			
			-- all conditions were met
			if (allFound == true and foundCount > 0) then
				-- has entry
				local entry = opt.env.CustomAuraColors[abilitySum]
				if (entry) then
					-- is enabled
					local enabled = false
					if (entry[opt.class.specId]) then
						enabled = entry[opt.class.specId].enabled
					else
						enabled = entry.enabled
					end

					if (enabled) then
						-- has color
						if (entry.color ~= nil) then
							result = entry.color
							return result
						end
					end
				end
			end
		end -- if/else ability is singular
	end) -- foreach spectable
	
	return result
end

function mod:CheckAura(frame)

	local auraColor = mod:hasAura(frame)
	if (auraColor == nil) then
		frame.state.hasAura = 0
		frame.state.auraColor = nil
	else
		frame.state.hasAura = 1
		frame.state.auraColor = auraColor
	end	
end

-- NAME #############################################################
function mod:UpdateTargetFrame(frame)

	if (frame.HealthBar == nil) then
		return
	end
	
	CheckUpdateName(frame)
	
	self:NameTextColourChange(frame)
		
	-- disable pvp 
	if (opt.env.DisablePvP) then
		if (UnitPlayerControlled(frame.unit) or frame.state.player == true) then
			return
		end
	end
		
	local col = nil
	
	-- check if we defined a colour for this name
	if opt.env.CustomTargets[frame.state.name] then
		local tmpColor = opt.env.CustomTargets[frame.state.name]
		col = { tmpColor.r, tmpColor.g, tmpColor.b }
		plugin_fading:UpdateFrame(frame)
	end
	
	if not col or opt.env.PreferAuraCustom then
	
		-- is target?
		if opt.env.ColorTarget and frame.handler:IsTarget() then 
			col = { opt.env['TargetColor'].r,opt.env['TargetColor'].g,opt.env['TargetColor'].b }
		end
		
		-- if colour was not set - check for auras?
		if not col or opt.env.PreferAura then
			if frame.state.hasAura == 1 then
				col = frame.state.auraColor
				col = { frame.state.auraColor.r, frame.state.auraColor.g, frame.state.auraColor.b }
				plugin_fading:UpdateFrame(frame)
			end
		end
	end

	-- no matching colour - clear our our colour data?
	if not col and frame.state.bar_is_name_coloured then
        frame.state.bar_is_name_coloured = nil
        if CanOverwriteHealthColor(frame, GetPriority()) then
            frame.state.health_colour_priority = nil
			
			if (frame.HealthBar ~= nil) then
				frame.HealthBar:SetStatusBarColor(unpack(frame.state.healthColour))
			end
			
			-- let tank mode do its thing
			if (plugin_tank) then
				plugin_tank:GlowColourChange(frame)
			end
        end
    elseif col then
        if CanOverwriteHealthColor(frame, GetPriority()) then
            frame.state.bar_is_name_coloured = true
            frame.state.health_colour_priority = GetPriority()
			
			if (frame.HealthBar ~= nil) then
				frame.HealthBar:SetStatusBarColor(unpack(col))
			end
        end
    end
end

function mod:HealthColourChange(frame)
	self:UpdateTargetFrame(frame)
end

function mod:EvaluateBorder(frame)

	if frame.IN_NAMEONLY then return end

	if (frame.HealthBar == nil) then
		return
	end
	
	if (frame.elite_border == nil) then

		frame.HealthBar:SetFrameLevel(0)

		frame.elite_border = CreateFrame("Frame", "custom_border", frame.HealthBar, "BackdropTemplate")
		frame.elite_border:SetAllPoints(frame.HealthBar);
		frame.elite_border:SetBackdrop({
			edgeFile='interface/buttons/white8x8',
			edgeSize=1
		})
		
		if (frame.LevelText ~= nil) then
			frame.LevelText:SetParent(frame.elite_border)
		end
		
 		frame.HealthText:SetParent(frame.elite_border)
		frame.NameText:SetParent(frame.elite_border)
		frame.elite_border:SetFrameLevel(1)
	end
	
	
	if (frame.elite_border) then
	
		if (not opt.env.EnableEliteBorder and not opt.env.EnableFocusBorder and not opt.env.EnableExecuteBorder) then
			HideEliteBorder(frame)
			return
		end
		
		local classification = UnitClassification(frame.unit);
	
		if (opt.env.EnableFocusBorder and UnitIsUnit(frame.unit,"focus")) then
			frame.elite_border:SetBackdrop({
				edgeFile='interface/buttons/white8x8',
				edgeSize=opt.env.FocusEdgeSize
			})
			frame.elite_border:SetBackdropBorderColor(opt.env.FocusBorderColor.r, opt.env.FocusBorderColor.g, opt.env.FocusBorderColor.b, opt.env.FocusBorderColor.a);	
			frame.NameText:SetParent(frame.elite_border)
		elseif (opt.env.EnableExecuteBorder and opt.plugin_execute and opt.plugin_execute.plugin_enabled and frame.state.in_execute_range) then
			frame.elite_border:SetBackdrop({
				edgeFile='interface/buttons/white8x8',
				edgeSize=opt.env.ExecuteEdgeSize
			})
			frame.elite_border:SetBackdropBorderColor(opt.env.ExecuteBorderColor.r, opt.env.ExecuteBorderColor.g, opt.env.ExecuteBorderColor.b, opt.env.ExecuteBorderColor.a);	
			frame.NameText:SetParent(frame.elite_border)
		elseif opt.env.EnableEliteBorder and ((classification == "worldboss") or (classification == "rareelite") or (classification == "elite")) then
			frame.elite_border:SetBackdrop({
				edgeFile='interface/buttons/white8x8',
				edgeSize=opt.env.EliteEdgeSize
			})
			frame.elite_border:SetBackdropBorderColor(opt.env.EliteBorderColor.r, opt.env.EliteBorderColor.g, opt.env.EliteBorderColor.b, opt.env.EliteBorderColor.a);	
			frame.NameText:SetParent(frame.elite_border)
		else
			HideEliteBorder(frame)
		end
	end
end

function mod:GainedTarget(frame)
	mod:UpdateTargetFrame(frame)
	mod:EvaluateBorder(frame)
	
end

function mod:GlowColourChange(frame)
	if frame.handler:IsTarget() then
		mod:GainedTarget(frame)
	end
	self:NameTextColourChange(frame)
end

function mod:LostTarget(frame)		
	mod:EvaluateBorder(frame)
	self:UpdateTargetFrame(frame)
end

function CheckUpdateName(frame)
	
	local name = frame.state.name
	
	for k, v in pairs(opt.env.Renames) do
		if (k == name) then
			frame.state.name = v
			frame.NameText:SetText(v)
		end
	end
	
end

function mod:UNIT_NAME_UPDATE(event,frame)
    self:UpdateTargetFrame(frame)
end

function mod:RefreshFocusData()
	for i, f in addon:Frames() do
		if f:IsShown() then
			mod:EvaluateBorder(f)
		end
	end
end

function mod:RefreshClassData()
	mod:LoadClassData()
end

function mod:Show(frame)
	mod:CheckAura(frame)
	mod:EvaluateBorder(frame)
	self:UpdateTargetFrame(frame)
end

function HideEliteBorder(frame)
	if (frame.elite_border) then
		frame.elite_border:SetBackdropBorderColor(opt.env.EliteBorderColor.r, opt.env.EliteBorderColor.g, opt.env.EliteBorderColor.b, 0);	
	end
end

function mod:Hide(frame)
	self:UpdateTargetFrame(frame)
	HideEliteBorder(frame)
end

local function OverrideUpdateNameFunction(frame)

	-- cache original
	frame.OriginalUpdateNameText = frame.UpdateNameText

	-- override with a special callback
	frame.UpdateNameText = function(f)
		-- fire base function first
		f.OriginalUpdateNameText(f)
		-- then call our 'NameTextColourChange'
		mod:NameTextColourChange(f)
	end
end

function mod:Create(frame)
    local this = frame:CreateAnimationGroup()
    	
    this:SetScript('OnFinished',AnimStop)
    this:SetScript('OnStop',AnimStop)

	self:UpdateTargetFrame(frame)
	OverrideUpdateNameFunction(frame)
end

function mod:UNIT_AURA(event,frame)
	mod:CheckAura(frame)
    self:UpdateTargetFrame(frame)
end

function mod:PLAYER_SPECIALIZATION_CHANGED(event, unit)
	if (unit == "player") then
		mod:RefreshClassData()
		mod:SpecUpdate()
		config_mod:ReloadValues(true)
	end
end

function mod:CastBarShow(f)
	
	-- if not f.cast_state.interruptible then return end

	local name, spellId
	if f.cast_state.empowered or f.cast_state.channel then
		name, _, _, _, _, _, _, spellId = UnitChannelInfo(f.unit)
	else
		name, _, _, _, _, _, _, _, spellId = UnitCastingInfo(f.unit)
	end

	if not spellId then return end

	local custom = opt.env.CustomInterrupts[spellId]
	if custom then
		f.CastBar:SetStatusBarColor(custom.r, custom.g, custom.b, custom.a)
	end	
end

function mod:CastBarHide(frame)
end

opt.original_kui_show_function = nil

function mod:Initialise()
	-- before initialized

	-- we need to know about the execute plugin
	opt.plugin_execute = addon:GetPlugin('Execute')

	if (opt.plugin_execute) then
		-- cache function pointrs
		opt.plugin_execute.original_on_enabled = opt.plugin_execute.OnEnable
		opt.plugin_execute.original_on_disable = opt.plugin_execute.OnDisable

		-- override enable
		opt.plugin_execute.OnEnable = function()

			opt.plugin_execute.plugin_enabled = true
			if (opt.plugin_execute.original_on_enabled) then
				opt.plugin_execute:original_on_enabled()
			end

			if (opt.OnExecutePluginEnabled) then
				opt:OnExecutePluginEnabled(true)
			end
		end

		-- override disable
		opt.plugin_execute.OnDisable = function()

			opt.plugin_execute.plugin_enabled = true
			if (opt.plugin_execute.original_on_disable) then
				opt.plugin_execute:original_on_disable()
			end
			if (opt.OnExecutePluginEnabled) then
				opt:OnExecutePluginEnabled(false)
			end
		end
	end

	-- override NAME_PLATE_UNIT_ADDED
	-- allows us to stop KUI from showing a nameplate we wish to filter

	opt.original_kui_show_function = addon.NAME_PLATE_UNIT_ADDED
	opt.original_kui_hide_function = addon.NAME_PLATE_UNIT_REMOVED

	addon.NAME_PLATE_UNIT_ADDED = function(self, unit_token)
		local name = UnitName(unit_token)
		if (not opt:ShouldFilterUnit(name)) then
			opt.original_kui_show_function(addon, unit_token)
		else
			local f = C_NamePlate.GetNamePlateForUnit(unit_token)
			if (f and f.UnitFrame) then
				f.UnitFrame:Hide()
			end
		end
	end

	addon.NAME_PLATE_UNIT_REMOVED = function(self, unit_token)
		opt.original_kui_hide_function(addon, unit_token)
	end
end

function mod:Initialised()

	mod:LoadClassData()
	
	self:RegisterMessage('Create')
	self:RegisterMessage('Show')
	
	-- fade update
    self:RegisterMessage('HealthColourChange')
	self:RegisterUnitEvent('UNIT_NAME_UPDATE')
	
	-- events
	self:RegisterEvent('PLAYER_FOCUS_CHANGED', 'RefreshFocusData')
	
	-- targets
    self:RegisterMessage('GainedTarget')
    self:RegisterMessage('LostTarget')
    self:RegisterMessage('Hide','LostTarget')
	self:RegisterMessage('GlowColourChange')
		
	-- auras
	self:RegisterUnitEvent('UNIT_AURA')
	
	-- spec
	self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED','PLAYER_SPECIALIZATION_CHANGED')
    self:RegisterEvent('PLAYER_ENTERING_WORLD','SpecUpdate')
	self:SpecUpdate()
	
	-- fades
	plugin_fading = addon:GetPlugin('Fading')
   	self:AddCallback('Fading','FadeRulesReset',self.Fading_FadeRulesReset)
    self.Fading_FadeRulesReset()

	-- casting
	self:RegisterMessage('CastBarShow')
    self:RegisterMessage('CastBarHide')
	
	-- text
	self:RegisterMessage('NameTextColourChange')
	
	-- tank
	plugin_tank = addon:GetPlugin('TankMode')
	
end