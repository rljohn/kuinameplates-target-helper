local folder,ns = ...
local addon = KuiNameplates
local core = KuiNameplatesCore

local frame_name = 'KuiConfigTargetHelper'
local mod = addon:NewPlugin(frame_name,101)
local opt = CreateFrame('FRAME',frame_name,InterfaceOptionsFramePanelContainer)
local events = {}
local currentEditName = nil
local currentRemoveName

opt.name = 'Kui |cff9966ffTarget Helper'
opt.ShouldResetFrames = false
opt.UpdateInterval = 1.0
opt.TimeSinceLastUpdate = 0

InterfaceOptions_AddCategory(opt)

-- addon info
opt.info = {
	name = 'KuiNameplates: Target Helper',
	version = '1.0.10',
	header = '%s (%s) by rljohn'
}

-- class info
opt.class = {}

-- global data
opt.global = {}

-- character environment data
opt.env = {}

opt.titles = {
	TargetOptions = 'Target Options',
	EnlargeTarget = 'Enlarge Target Frame',
	EnlargeTargetTooltip = 'Scale the target frame by a percentage.',
	TargetScale = 'Target Frame Scale',
	ColorTarget = 'Enable Target Color',
	ColorTargetTooltip = "Override the color of your target's health bar.",
	ColorAuras = 'Enable Debuff Color',
	ColorAurasTooltip = 'Override the color of enemies that have an Debuff applied by your class.',
	ColorAurasTooltip2 = '|cff9966ffNote:|r This is not implemented for all classes.',
	ContextCustom = 'Custom',
	ContextSLDungeons = 'Shadowlands Dungeons',
	ContextSLRaids = 'Shadowlands Raids',
	CustomTarget = 'Custom Target Colors',
	AddTarget = 'Add Target',
	AddTargetTooltipTitle = "Add Target",
	AddTargetBtnTooltip = "Add a target to the custom target list.",
	CustomColorTooltipTitle = "Custom Color",
	CustomColorTooltipText = "Select a color for the custom target.",
	AddTargetTooltipText = "Enter the name of the target you wish to track and click 'Add Target'.",
	RemoveTargetTooltip = 'Right click to remove this target.',
	CVarTitle = 'Nameplate CVars',
	OtherOptions = 'Other Options',
	ResetAll = 'Reset',
	AddSLTargets = '+ Dungeon Targets',
	AddSLTooltipTitle = 'Dungeon Targets',
	AddSLTooltipText = 'Add important targets from |cff40c0f7Shadowlands|r dungeons.',
	AddSLRaidTargets = '+ Raid Targets',
	AddSLRaidTooltipTitle = 'Raid Targets',
	AddSLRaidTooltipText = 'Add important targets from |cff40c0f7Shadowlands|r raids.',
	EnableEliteBorder = 'Enable Elite Border',
	EnableEliteBorderTooltip = 'Adds a border around Elite and Boss targets',
	EnableCVars = "Enable CVar Modification",
	EnableCVarsTooltip = "Enables the CVar panel, allowing KUI |cff9966ffTarget Helper|r to modify CVars.",
	ResetTooltip = "Reset the |cff9966ffTarget Helper|r to base settings.",
	EditTitle = "Edit Target",
	EditTooltip = "Change the name of this target",
	DisablePvP = "Disable colors in PvP",
	DisablePvPTooltip = "Disable target and debuff colors for player frames"
}

opt.ui = {
	enlargetarget = nil,
	colortarget = nil,
	colorauras = nil,
	targetscale = nil,
	targetcolor = nil,
	auracolor = nil,
	addtargetcolor = nil,
	elitebordercolor = nil,
	disablepvp = nil,
	targets = {},
	cvarframes = {}
}

-- Ensure default values are present - when we add new values, they might be missing
function mod:LoadMissingValues()
	if (opt.env['TargetColor'] == nil) then
		opt.env['TargetColor'] = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
	end
	
	if (opt.env['AuraColor'] == nil) then
		opt.env['AuraColor'] = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
	end
	
	if (opt.env['NewColor'] == nil) then
		opt.env['NewColor'] = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
	end
	
	if (opt.env['EliteBorderColor'] == nil) then
		opt.env['EliteBorderColor'] = { r = 1.0, g = 1.0, b = 1.0, a = 0.5 }
	end
	
	if (opt.env.CustomTargets == nil) then
		opt.env.CustomTargets = {}
	end
	
	if (opt.env.TargetScale == nil) then
		opt.env.TargetScale = 1.0
	end
	
	if (opt.env.EnlargeTarget == nil) then
		opt.env.EnlargeTarget = false
	end
	if (opt.env.ColorTarget == nil) then
		opt.env.ColorTarget = false
	end
	if (opt.env.ColorAuras == nil) then
		opt.env.ColorAuras = false
	end
	if (opt.env.EnableEliteBorder == nil) then
		opt.env.EnableEliteBorder = false
	end
	if (opt.env.UseCustomTargets == nil) then
		opt.env.UseCustomTargets = false
	end
	if (opt.env.DisablePvp == nil) then
		opt.env.DisablePvp = false
	end
	if (opt.env.EnableCVars == nil) then
		opt.env.EnableCVars = false
	end
end

function mod:SetDefaultValues()
	opt.env = {}
	mod:LoadMissingValues()
end

function mod:ResetUi()
	opt.ui.enlargetarget:SetChecked(false)
	opt.ui.colortarget:SetChecked(false)
	opt.ui.colorauras:SetChecked(false)
	opt.ui.disablepvp:SetChecked(false)
	opt.ui.enableeliteborder:SetChecked(false)
	opt.ui.targetscale:SetValue(1.0)
	opt.ui.targetcolor:SetBackdropColor(1, 1, 1, 1)
	opt.ui.auracolor:SetBackdropColor(1, 1, 1, 1)
	opt.ui.addtargetcolor:SetBackdropColor(1, 1, 1, 1)
	opt.ui.elitebordercolor:SetBackdropColor(1, 1, 1, 0.5)
	
	opt.ui.EnableCVars:SetChecked(false)
	
	mod:RefreshCustomTargets()
	DisableCVars()
	-- opt.ui.targets
end

-- Load saved data, or fall back to default data
function mod:LoadSavedData()
	if KuiTargetHelperConfigCharSaved == nil then
		mod:SetDefaultValues()
		KuiTargetHelperConfigCharSaved = opt.env
	else
		opt.env = KuiTargetHelperConfigCharSaved
	end
end

function mod:ClearEditBoxTargetName()
	opt.ui.addtargettext:SetText('')
end

function mod:HideTargets()
	if opt.ui.targets == nil then
		return
	end
	
    for _,frame in pairs(opt.ui.targets) do
        frame:Hide()
        frame.highlight:Hide()
    end
end

function mod:CreateTargetFrame(name, color, active)

	local f
	
	local alpha = 1;
	if (not active) then alpha = .5 end
	
	for _,frame in pairs(opt.ui.targets) do
        if not frame:IsShown() then
            -- recycle an old frame
            f = frame
        end
    end
	
	local displayName
	if (color.context) then
		displayName = name .. ' |cff40c0f7[' .. color.context .. ']|r'
	else
		displayName = name .. ' |cffc8d975[' .. opt.titles.ContextCustom .. ']|r'
	end
		
	if not f then
		f = CreateFrame('Frame', nil, opt.ui.scroll.panel );
		
		f:EnableMouse(true)
	
		f:SetSize(280, 20)
		AddTooltip(f, displayName, opt.titles.RemoveTargetTooltip)
		
        f.highlight = f:CreateTexture('HIGHLIGHT')
        f.highlight:SetTexture('Interface/BUTTONS/UI-Listbox-Highlight')
        f.highlight:SetBlendMode('add')
        f.highlight:SetAlpha(.5)
        f.highlight:Hide()
		f.highlight:SetAllPoints(f);
		
		f.icon = CreateFrame("Button", nil, f, "BackdropTemplate");
		f.icon:SetSize(30,16);
		f.icon:SetPoint('LEFT');
		f.icon:SetScript("OnClick", CustomTargetColorOnClick)
		f.icon:SetBackdrop({
            bgFile='interface/buttons/white8x8',
            edgeFile='interface/buttons/white8x8',
            edgeSize=1,
            insets={top=2,right=2,bottom=2,left=2}
        })
		AddTooltip(f.icon, opt.titles.CustomColorTooltipTitle, opt.titles.CustomColorTooltipText)
		
		f.name = f:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
        -- f.name:SetFont(STANDARD_TEXT_FONT, 12)
		f.name:SetSize(260, 18)
        f.name:SetPoint('LEFT', f.icon, 'RIGHT', 10, 0)
        f.name:SetJustifyH('LEFT')
		
		local editBtn = CreateButton(f, nil, 40, 20, "Edit")
		editBtn:SetPoint('LEFT', f, 'RIGHT', 10, 0)
		editBtn:SetScript('OnClick', function(self, arg1)
			currentEditName = self:GetParent().id
			StaticPopup_Show("KUI_TargetHelper_EditBox", self:GetParent().id)
		end)
		AddTooltip(editBtn, opt.titles.EditTitle, opt.titles.EditTooltip)
		
		f:SetScript('OnMouseUp', function(self, button)
			if button == 'RightButton' then
				currentRemoveName = self.id
				StaticPopup_Show("KUI_TargetHelper_DeleteTargetConfirm", self.id)
			end
		end)
		
		f:SetScript('OnEnter', function(self)
			self.highlight:Show()
			OnTooltipEnter(self)
		end)
        f:SetScript('OnLeave', function(self)
			self.highlight:Hide()
			OnTooltipLeave(self)
		end)
	end
	
	f.id = name;
	f.name:SetText(name);
	f.tooltipTitle = displayName
	f.name:SetTextColor(color.r, color.g, color.b)
	f.icon:SetBackdropBorderColor(.5,.5,.5)
	f.icon:SetBackdropColor (color.r, color.g, color.b, 1)
	tinsert( opt.ui.targets, f );
	return f;
	
end

function mod:RefreshCustomTargets()
	
	mod:HideTargets()
	
	if (opt.env.CustomTargets == nil) then
		return
	end
	
	local previousFrame = nil;
	
	for k,v in pairsByKeys ( opt.env.CustomTargets ) do
	
		local f = mod:CreateTargetFrame ( k, v, opt.env.UseCustomTargets );
		
		if previousFrame then
            f:SetPoint('TOPLEFT', previousFrame, 'BOTTOMLEFT', 0, -2)
        else
            f:SetPoint('TOPLEFT')
        end
		
		f:Show();
		previousFrame = f;
	end
	
end

function mod:AddTarget(name,color,context)
	opt.env.CustomTargets[name] = {}
	opt.env.CustomTargets[name].r = color.r
	opt.env.CustomTargets[name].g = color.g
	opt.env.CustomTargets[name].b = color.b
	opt.env.CustomTargets[name].a = color.a
	opt.env.CustomTargets[name].context = context
	mod:RefreshCustomTargets();
	ResetFrames()
end

function mod:RemoveTarget(name)
	opt.env.CustomTargets[name] = nil;
	mod:RefreshCustomTargets();
	ResetFrames()
end

-- mouse and keyboard events

function addTargetEnterCallback(self)
    opt.ui.addtargetbtn:Click();
end

function addTargetEscapeCallback()
	opt.ui.addtargettext:ClearFocus()
end

function addTargetOnClick()
	mod:AddTarget(opt.ui.addtargettext:GetText(), opt.env.NewColor, nil)
	mod:ClearEditBoxTargetName()
end

local printSlText = true
function addShadowlandsTargets()

	if printSlText then
		print("|cff9966ffShadowlands Dungeon Targets|r are a work in progress, please report more targets to track!")
		printSlText = false
	end
	
	local LOCALE = GetLocale()	
	local keys = (LOCALE and ShadowlandsDungeonTargets[LOCALE]) or ShadowlandsDungeonTargets.enUS
	
	table.foreach(keys, function(k,v)
		local exists = false
		
		for ck,cv in pairsByKeys ( opt.env.CustomTargets ) do	
			if (v == ck) then
				exists = true
				break
			end
		end
		
		if (exists == false) then
			mod:AddTarget(v, { r = 0.64, g = 1.0, b = 0.63, a = 1.0 }, "Shadowlands Dungeons")
		end
	end)
	
end

local printSlRaidText = true
function addShadowlandsRaidTargets()

	if printSlRaidText then
		print("|cff9966ffShadowlands Raid Targets|r are coming soon, check back for updates!")
		printSlRaidText = false
	end
	
	-- local LOCALE = GetLocale()	
	-- local keys = (LOCALE and ShadowlandsRaidTargets[LOCALE]) or ShadowlandsRaidTargets.enUS
	-- 
	-- table.foreach(keys, function(k,v)
	-- 	local exists = false
	-- 	
	-- 	for ck,cv in pairsByKeys ( opt.env.CustomTargets ) do	
	-- 		if (v == ck) then
	-- 			exists = true
	-- 			break
	-- 		end
	-- 	end
	-- 	
	-- 	if (exists == false) then
	-- 		mod:AddTarget(v, { r = 0.64, g = 1.0, b = 0.63, a = 1.0 }, "Shadowlands Raids")
	-- 	end
	-- end)
	
end

function mod:Update()
	if (opt.ShouldResetFrames) then
		ResetFrames()
		opt.ShouldResetFrames = false
	end
end

function ShowEvent(frame)
	-- refresh cvars when this screen displays
	UpdateCVars()
end

function UpdateTick(self, elapsed)
	opt.TimeSinceLastUpdate = opt.TimeSinceLastUpdate + elapsed; 	

	if (opt.TimeSinceLastUpdate > opt.UpdateInterval) then
		mod:Update()
		opt.TimeSinceLastUpdate = 0;
	end
end

-- Configuration Setup
function events:ADDON_LOADED(addon_name)
	if addon_name == 'Kui_Nameplates_TargetHelper' then
		
		SetupLocale()
		mod:LoadSavedData()
		--mod:SetDefaultValues()
		mod:LoadMissingValues()
		
		local version = opt:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
		version:SetFontObject("GameFontNormalSmall")
		version:SetTextColor(1,1,1,0.5)
		version:SetPoint('TOPRIGHT',-12,13)
		version:SetText(string.format(
			opt.info.header,
			opt.info.name,
			opt.info.version
		))
		
		-- top panel
		opt.ui.toppanel = CreatePanel(opt, "TopFrame", 330, 120)
		opt.ui.toppanel:SetPoint('TOPLEFT', 25, -40)
		
		opt.ui.topPanelTitle = opt:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		opt.ui.topPanelTitle:SetText(opt.titles.TargetOptions)
		opt.ui.topPanelTitle:SetPoint('BOTTOMLEFT', opt.ui.toppanel, 'TOPLEFT', 0, 12)
		
		-- top options
		
		--opt.ui.enlargetarget = CreateCheckBox(opt, 'EnlargeTarget')
		--opt.ui.enlargetarget:SetPoint("TOPLEFT", opt.ui.toppanel, "TOPLEFT", 0, -5)
		--AddTooltip(opt.ui.enlargetarget, opt.titles.EnlargeTarget, opt.titles.EnlargeTargetTooltip)
		
		-- opt.ui.targetscale = CreateSlider(opt, 'TargetScale', 0.5, 1.5)
		-- opt.ui.targetscale:SetPoint("TOPLEFT", opt.ui.enlargetarget.label, "TOPRIGHT", 20, 0)
		-- AddTooltip(opt.ui.targetscale, opt.titles.EnlargeTarget, opt.titles.EnlargeTargetTooltip)
		
		opt.ui.colortarget = CreateCheckBox(opt, 'ColorTarget')
		opt.ui.colortarget:SetPoint("TOPLEFT", opt.ui.toppanel, "TOPLEFT", 0, -5)
		AddTooltip(opt.ui.colortarget, opt.titles.ColorTarget, opt.titles.ColorTargetTooltip)
		
		opt.ui.targetcolor = CreateColorTexture(opt, 'TargetColor', 160, 24,opt.env.TargetColor.r, opt.env.TargetColor.g, opt.env.TargetColor.b, opt.env.TargetColor.a)
		opt.ui.targetcolor:SetPoint("TOPLEFT", opt.ui.colortarget, "TOPRIGHT", 160, -2)
		
		opt.ui.colorauras = CreateCheckBox(opt, 'ColorAuras')
		opt.ui.colorauras:SetPoint("TOPLEFT", opt.ui.colortarget, "BOTTOMLEFT", 0, -15)
		AddTooltip2(opt.ui.colorauras, opt.titles.ColorAuras, opt.titles.ColorAurasTooltip, opt.titles.ColorAurasTooltip2)
		
		opt.ui.auracolor = CreateColorTexture(opt, 'AuraColor', 160, 24, opt.env.AuraColor.r, opt.env.AuraColor.g, opt.env.AuraColor.b, opt.env.AuraColor.a)
		opt.ui.auracolor:SetPoint("TOPLEFT", opt.ui.colorauras, "TOPRIGHT", 160, -2)
		
		opt.ui.disablepvp = CreateCheckBox(opt, 'DisablePvP')
		opt.ui.disablepvp:SetPoint("TOPLEFT", opt.ui.colorauras, "BOTTOMLEFT", 0, -15)
		AddTooltip2(opt.ui.disablepvp, opt.titles.DisablePvP, opt.titles.DisablePvPTooltip)
				
		-- custom enemies
		
		opt.ui.scroll = CreateScrollArea(opt, 'NameArea', 330, 310)
		opt.ui.scroll:SetPoint('TOPLEFT', opt.ui.toppanel, 'BOTTOMLEFT', 0, -44)
		
		opt.ui.listEnemiesTitle = opt:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		opt.ui.listEnemiesTitle:SetText(opt.titles["CustomTarget"])
		opt.ui.listEnemiesTitle:SetPoint('BOTTOMLEFT', opt.ui.scroll, 'TOPLEFT', 0, 12)
		
		opt.ui.addtargetcolor = CreateColorTexture(opt, 'NewColor', 20, 20, opt.env.NewColor.r, opt.env.NewColor.g, opt.env.NewColor.b, opt.env.NewColor.a)
		opt.ui.addtargetcolor:SetPoint("TOPLEFT", opt.ui.scroll, "BOTTOMLEFT", 0, -18)
		AddTooltip(opt.ui.addtargetcolor, opt.titles.CustomColorTooltipTitle, opt.titles.CustomColorTooltipText)
		
		opt.ui.addtargettext = CreateEditBox(opt, "AddTargetText", 100, 220, 25)
		opt.ui.addtargettext:SetPoint('TOPLEFT', opt.ui.addtargetcolor, "TOPRIGHT", 15, 4)
		opt.ui.addtargettext:SetScript('OnEnterPressed', addTargetEnterCallback)
		opt.ui.addtargettext:SetScript('OnEscapePressed', addTargetEscapeCallback)
		AddTooltip(opt.ui.addtargettext, opt.titles.AddTargetTooltipTitle, opt.titles.AddTargetTooltipText)
		
		opt.ui.addtargetbtn = CreateButton(opt, 'AddTarget', 100, 30, opt.titles.AddTarget)
		opt.ui.addtargetbtn:SetPoint("TOPLEFT", opt.ui.addtargettext, "TOPRIGHT", 4, 0)
		opt.ui.addtargetbtn:SetScript("OnClick", addTargetOnClick)
		AddTooltip(opt.ui.addtargetbtn, opt.titles.AddTarget, opt.titles.AddTargetBtnTooltip)
		
		-- side panel
		
		opt.ui.sidepanel = CreatePanel(opt, "SideFrame", 180, 120)
		opt.ui.sidepanel:SetPoint('TOPLEFT', opt.ui.toppanel, 'TOPRIGHT', 45, 0)
	
		opt.ui.sidePanelTitle = opt:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		opt.ui.sidePanelTitle:SetText(opt.titles.OtherOptions)
		opt.ui.sidePanelTitle:SetPoint('BOTTOMLEFT', opt.ui.sidepanel, 'TOPLEFT', 0, 12)
		
		-- sl mobs
		
		opt.ui.addSlBtn = CreateButton(opt, nil, 200, 24, opt.titles.AddSLTargets)
		opt.ui.addSlBtn:SetPoint('TOPLEFT', opt.ui.sidepanel, 'TOPLEFT', 0, 0)
		opt.ui.addSlBtn:SetScript("OnClick", addShadowlandsTargets)
		AddTooltip(opt.ui.addSlBtn, opt.titles.AddSLTooltipTitle, opt.titles.AddSLTooltipText)
		
		-- opt.ui.addSlRaidBtn = CreateButton(opt, nil, 200, 24, opt.titles.AddSLRaidTargets)
		-- opt.ui.addSlRaidBtn:SetPoint('TOPLEFT', opt.ui.addSlBtn, 'BOTTOMLEFT', 0, -4)
		-- opt.ui.addSlRaidBtn:SetScript("OnClick", addShadowlandsRaidTargets)
		-- AddTooltip(opt.ui.addSlRaidBtn, opt.titles.AddSLRaidTooltipTitle, opt.titles.AddSLRaidTooltipText)
		
		-- elite/boss borders
		
		opt.ui.enableeliteborder = CreateCheckBox(opt, "EnableEliteBorder")
		opt.ui.enableeliteborder:SetPoint('TOPLEFT', opt.ui.addSlBtn, "BOTTOMLEFT", 0, -4)
		AddTooltip(opt.ui.enableeliteborder, opt.titles.EnableEliteBorder, opt.titles.EnableEliteBorderTooltip)
		
		opt.ui.elitebordercolor = CreateColorTexture(opt, 'EliteBorderColor', 20, 20, opt.env.EliteBorderColor.r, opt.env.EliteBorderColor.g, opt.env.EliteBorderColor.b, opt.env.EliteBorderColor.a)
		opt.ui.elitebordercolor:SetPoint("TOPLEFT", opt.ui.enableeliteborder, "TOPLEFT", 160, -4)
		AddTooltip(opt.ui.elitebordercolor, opt.titles.EnableEliteBorder, opt.titles.EnableEliteBorderTooltip)
		
		-- enable cvars
		
		opt.ui.EnableCVars = CreateCheckBox(opt, 'EnableCVars')
		opt.ui.EnableCVars:SetPoint("TOPLEFT", opt.ui.enableeliteborder, "BOTTOMLEFT", 0, -4)
		AddTooltip(opt.ui.EnableCVars, opt.titles.EnableCVars, opt.titles.EnableCVarsTooltip)
		
		-- cvar frame
		
		opt.ui.cvarpanel = CreateScrollArea(opt, "CVarFrame", 180, 310)
		opt.ui.cvarpanel:SetPoint('TOPLEFT', opt.ui.sidepanel, 'BOTTOMLEFT', 0, -44)
		
		opt.ui.cvarpanelTitle = opt:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
		opt.ui.cvarpanelTitle:SetText(opt.titles.CVarTitle)
		opt.ui.cvarpanelTitle:SetPoint('BOTTOMLEFT', opt.ui.cvarpanel, 'TOPLEFT', 0, 12)
		
		
		AddCVarSliders(opt.ui.cvarpanel)
		
		local f = CreateFrame("Button", "test2", opt, "UIPanelButtonTemplate")
		f:SetPoint("BOTTOMRIGHT", -10, 10)
		f:SetWidth(90)
		f:SetHeight(30)
		f:SetText(opt.titles.ResetAll)
		AddTooltip(f, "", opt.titles.ResetTooltip)
		
		f:SetScript("OnClick", function(self, arg1)
			StaticPopup_Show("KUI_TargetHelper_DeleteConfirm")
		end)
		
		mod:RefreshCustomTargets()
		
		opt:HookScript("OnUpdate", UpdateTick)
		opt:HookScript("OnShow", ShowEvent)
	end                          
end

function TargetEdit(new)

	if (currentEditName == new) then
		return
	end
	
	if (opt.env.CustomTargets[currentEditName]) then
		opt.env.CustomTargets[new] = opt.env.CustomTargets[currentEditName]
		opt.env.CustomTargets[new].context = nil
		opt.env.CustomTargets[currentEditName] = nil
	end
	
	local LOCALE = GetLocale()
	
	local dungeons = (LOCALE and ShadowlandsDungeonTargets[LOCALE]) or ShadowlandsDungeonTargets.enUS
	table.foreach(dungeons, function(k,v)
		if (v == new) then
			opt.env.CustomTargets[new].context = opt.titles.ContextSLDungeons
		end
	end)
	
	local raids = (LOCALE and ShadowlandsRaidTargets[LOCALE]) or ShadowlandsRaidTargets.enUS
	table.foreach(raids, function(k,v)
		if (v == new) then
			opt.env.CustomTargets[new].context = opt.titles.ContextSLRaids
		end
	end)
	
	mod:RefreshCustomTargets()
	ResetFrames()
end

function ConfirmDelete()
	opt.env = {}
	mod:SetDefaultValues()
	mod:ResetUi()
end

function ConfirmTargetDelete()
    mod:RemoveTarget(currentRemoveName)
end

-- Save Player data on logout
function events:PLAYER_LOGOUT()
	KuiTargetHelperConfigCharSaved = opt.env
end

function events:CVAR_UPDATE(eventName, value)
	-- disable this - seems to only fire on default values
	-- instead reload values from the show event
	--UpdateCVars()
end

-- Event Registration
opt:SetScript('OnEvent', function(self, event, ...)
	events[event](self, ...)
end)

for k, v in pairs(events) do
	opt:RegisterEvent(k)
end