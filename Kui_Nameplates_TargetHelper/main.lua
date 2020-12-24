--[[
-- Custom code injector template for Kui_Nameplates_Core
--]]
local folder,ns=...
local addon = KuiNameplates
local core = KuiNameplatesCore
local opt = KuiConfigTargetHelper

-- enable this to use 'DevTools_Dump'
-- LoadAddOn("Blizzard_DebugTools")
	
local PRIORITY = 2

--------- Plugin Registration -----------------
-- priority         = Any number. Defines the load order. Default of 5. Plugins with a higher priority are executed later.
-- [max_minor]      = Maximum NKP minor this plugin is known to support. Ignored if nil.
-- [enable_on_load] = Enable this plugin upon initialise. True if nil.
local mod = addon:NewPlugin('KUI_TargetHelper',100,nil)
if not mod then return end

-- UTILITIES ####################################################

local function CanOverwriteHealthColor(f)
    return not f.state.health_colour_priority or
           f.state.health_colour_priority <= PRIORITY
end

function mod:LoadClassData()
	opt.class.name, _, _ = UnitClass("player");
	opt.class.spec = GetSpecialization()
	opt.class.specId, opt.class.specName = GetSpecializationInfo(opt.class.spec)
	
	rlPrintf('Now loading aura data for ' .. opt.class.specName .. ' ' .. opt.class.name  .. ' ( ' .. opt.class.specId .. ').')
end

function mod.Fading_FadeRulesReset()
    plugin_fading:AddFadeRule(function(f)
		
		-- non-targets with aura should be drawn
		if (f.state.hasAura == 1) then
			return 1
		end
		
		-- custom targets should be drawn at 100% opacity if in range.
        if f.state.name and opt.env.CustomTargets[f.state.name] then
			if (UnitInRange("unit") == nil) then
				return
			end
			
			return 1
		end
		
    end,1)
end

-- returns true if the nameplate has any aura frames
function mod:hasAura(frame)

	-- if our current spec does not have any auras to track, return
	if KuiTargetAuraList[opt.class.specId] == nil then
		return 0
	end
	
	-- if aura colors disabled
	if (opt == nil) or (opt.env == nil) or (opt.env.ColorAuras == false) then
		return 0
	end
	
	if not frame.Auras or not frame.Auras.frames then 
		return 0
	end
		
	for _,auras_frame in pairs(frame.Auras.frames) do
		if (auras_frame.visible) then
			if (auras_frame.visible > 0) then
				for _,button in ipairs(auras_frame.buttons) do
					if IsInTable(KuiTargetAuraList[opt.class.specId], button.spellid) then
						return 1
					end
				end
			end
		end
	end
	
	return 0
end

-- NAME #############################################################
function mod:UpdateTargetFrame(frame)
	
	-- only adjust non-target (we have a bespoke colour for our target)
	if opt.env.ColorTarget and frame.handler:IsTarget() then 
		--DevTools_Dump(frame.state)
		return
	end
		
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

	-- if colour was not set - check for auras?
	if not col then
		if frame.state.hasAura == 1 then
			col = { opt.env['AuraColor'].r,opt.env['AuraColor'].g,opt.env['AuraColor'].b }
			plugin_fading:UpdateFrame(frame)
		end
	end

	-- no matching colour - clear our our colour data?
	if not col and frame.state.bar_is_name_coloured then
        frame.state.bar_is_name_coloured = nil
        if CanOverwriteHealthColor(frame) then
            frame.state.health_colour_priority = nil
            frame.HealthBar:SetStatusBarColor(unpack(frame.state.healthColour))
        end
    elseif col then
        if CanOverwriteHealthColor(frame) then
            frame.state.bar_is_name_coloured = true
            frame.state.health_colour_priority = PRIORITY
            frame.HealthBar:SetStatusBarColor(unpack(col))
        end
    end
end

function mod:EvaluateBorder(frame)

	if (frame.elite_border == nil) then

		frame.HealthBar:SetFrameLevel(0)

		frame.elite_border = CreateFrame("Frame", "custom_border", frame.HealthBar, "BackdropTemplate")
		frame.elite_border:SetAllPoints(frame.HealthBar);
		frame.elite_border:SetBackdrop({
			edgeFile='interface/buttons/white8x8',
			edgeSize=1
		})
		
		frame.LevelText:SetParent(frame.elite_border)
		frame.HealthText:SetParent(frame.elite_border)
		frame.elite_border:SetFrameLevel(1)
	end
	
	
	if (frame.elite_border) then
	
		if (opt.env.EnableEliteBorder == false) then
			HideEliteBorder(frame)
			return
		end
		
		if frame.handler:IsTarget() then
			HideEliteBorder(frame)
			return
		end

		local classification = UnitClassification(frame.unit);
	
		if (classification == "worldboss") or (classification == "rareelite") or (classification == "elite") then
			frame.elite_border:SetBackdropBorderColor(opt.env.EliteBorderColor.r, opt.env.EliteBorderColor.g, opt.env.EliteBorderColor.b, opt.env.EliteBorderColor.a);	
		else
			HideEliteBorder(frame)
		end
	end
end

function mod:GainedTarget(frame)
	
	if opt.env.ColorTarget then
		
		-- disable pvp 
		if (opt.env.DisablePvP) then
			if (UnitPlayerControlled(frame.unit) or frame.state.player == true) then
				return
			end
		end
		
		if CanOverwriteHealthColor(frame) then
			frame.state.bar_is_name_coloured = true
			frame.state.health_colour_priority = PRIORITY
			frame.HealthBar:SetStatusBarColor(opt.env['TargetColor'].r,opt.env['TargetColor'].g,opt.env['TargetColor'].b)
		end
	end
	
	mod:EvaluateBorder(frame)
	
end

function mod:LostTarget(frame)		
	mod:EvaluateBorder(frame)
	self:UpdateTargetFrame(frame)
end

function mod:UNIT_NAME_UPDATE(event,frame)
    self:UpdateTargetFrame(frame)
end

function mod:PLAYER_SPECIALIZATION_CHANGED()
	mod:LoadClassData()
end

function mod:Show(frame)
	frame.state.hasAura = mod:hasAura(frame)
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

function mod:Create(frame)
    local this = frame:CreateAnimationGroup()
    	
    this:SetScript('OnFinished',AnimStop)
    this:SetScript('OnStop',AnimStop)
	self:UpdateTargetFrame(frame)
end

function mod:UNIT_AURA(event,frame)
	frame.state.hasAura = mod:hasAura(frame)
    self:UpdateTargetFrame(frame)
end

function mod:Initialise()

	mod:LoadClassData()
	
	self:RegisterMessage('Create')
	self:RegisterMessage('Show')
	
	-- fade update
    self:RegisterMessage('HealthColourChange','UpdateTargetFrame')
	self:RegisterUnitEvent('UNIT_NAME_UPDATE')
	self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED')
	
	-- targets
    self:RegisterMessage('GainedTarget')
    self:RegisterMessage('LostTarget')
    self:RegisterMessage('Hide','LostTarget')
		
	-- auras
	self:RegisterUnitEvent('UNIT_AURA')

	-- fades
	plugin_fading = addon:GetPlugin('Fading')
    self:AddCallback('Fading','FadeRulesReset',self.Fading_FadeRulesReset)
    self.Fading_FadeRulesReset()
	
end