local folder,ns = ...
local addon = KuiNameplates
local core = KuiNameplatesCore

-- create mod 
local frame_name = 'KuiConfigTargetHelper'
local mod = addon:NewPlugin(frame_name,101)
KuiConfigTargetHelperMod = mod

-- parent frame for all options
local opt = CreateFrame('FRAME',frame_name,InterfaceOptionsFramePanelContainer)
opt.name = 'Kui |cff9966ffTarget Helper'
opt.ShouldResetFrames = false
opt.UpdateInterval = 1.0
opt.TimeSinceLastUpdate = 0

-- addon info
opt.info = {
	name = 'KuiNameplates: Target Helper',
	version = '1.2.11',
	header = '%s (%s) by rljohn'
}

-- child frame for profiles
local profiles = CreateFrame('FRAME', 'knpthprofiles', opt)
profiles.parent = opt.name
profiles.name = 'Profiles'

-- child frame for custom targets
local custom_targets = CreateFrame('FRAME', 'knpthcustomtargets', opt)
custom_targets.parent = opt.name
custom_targets.name = 'Enemy Colors'

-- child frame for class auras
local aura_colors = CreateFrame('FRAME', 'knpthauracolors', opt)
aura_colors.parent = opt.name
aura_colors.name = 'Debuff Colors'

-- child frame for renames
local unit_names = CreateFrame('FRAME', 'knpthunitnames', opt)
unit_names.parent = opt.name
unit_names.name = 'Rename Units'

-- child frame for unit filter
local unit_filter = CreateFrame('FRAME', 'knpthunitfilter', opt)
unit_filter.parent = opt.name
unit_filter.name = 'Unit Filter'

-- child frame for console variables
local cvars = CreateFrame('FRAME', 'knpthcvars', opt)
cvars.parent = opt.name
cvars.name = 'CVars'

-- class info
opt.class = {}

-- global data
opt.global = {}

-- character environment data
opt.env = {}

-- ui frames
opt.ui = {
	colortarget = nil,
	disablepvp = nil,
	preferaura = nil,
	preferauracustom = nil,
	disablealpha = nil,
	nametext = nil,
	elitebordercolor = nil,
	focustargetcolor = nil,
	eliteedgesize = nil,
	focusedgesize = nil,
	targetcolor = nil,
	addtargetcolor = nil,
	priority = nil,
	targets = {},
	auras = {},
	renames = {},
	filters = {},
	cvarframes = {}
}

-- misc local vars
local events = {}

local function SetDefaultValue(key, value)
	if (opt.env[key] == nil) then
		opt.env[key] = value
	end
end

-- Ensure default values are present - when we add new values, they might be missing
function mod:LoadMissingValues()
	SetDefaultValue('TargetColor', { r = 1.0, g = 1.0, b = 1.0, a = 1.0 })
	SetDefaultValue('NewColor', { r = 1.0, g = 1.0, b = 1.0, a = 1.0 })
	SetDefaultValue('EliteBorderColor', { r = 1.0, g = 1.0, b = 1.0, a = 0.7 })
	SetDefaultValue('FocusBorderColor', { r = 1.0, g = 1.0, b = 0.0, a = 1.0 })
	SetDefaultValue('ExecuteBorderColor', { r = 1.0, g = 0.0, b = 0.0, a = 1.0 })
	SetDefaultValue('SavedColor1', 	{ r = 0.03, g = 0.48, b = 1.0, a = 1.0 })
	SetDefaultValue('SavedColor2', 	{ r = 0, g = 0.94, b = 1.0, a = 1.0 })
	SetDefaultValue('SavedColor3', 	{ r = 0.25, g = 1.0, b = 0.62, a = 1.0 })
	SetDefaultValue('SavedColor4', 	{ r = 0.52, g = 1.0, b = 0, a = 1.0 })
	SetDefaultValue('SavedColor5', 	{ r = 0.89, g = 1.0, b = 0, a = 1.0 })
	SetDefaultValue('SavedColor6', 	{ r = 1.0, g = 0.8, b = 0, a = 1.0 })
	SetDefaultValue('SavedColor7', 	{ r = 1.0, g = 0.38, b = 0, a = 1.0 })
	SetDefaultValue('SavedColor8', 	{ r = 1.0, g = 0, b = 0.03, a = 1.0 })
	SetDefaultValue('SavedColor9', 	{ r = 1.0, g = 0, b = 0.58, a = 1.0 })
	SetDefaultValue('SavedColor10', { r = 0.92, g = 0, b = 1.0, a = 1.0 })
	SetDefaultValue('SavedColor11', { r = 0.60, g = 0.03, b = 1.0, a = 1.0 })
	SetDefaultValue('SavedColor12', { r = 1.0, g = 1.0, b = 1.0, a = 1.0 })
	SetDefaultValue('CustomTargets', {})
	SetDefaultValue('CustomAuraColors', {})
	SetDefaultValue('Renames', {})
	SetDefaultValue('FilterTargets', {})
	SetDefaultValue('TargetScale', 1.0)
	SetDefaultValue('Priority', 3)
	SetDefaultValue('DisableAlpha', true)
	SetDefaultValue('ColorTarget', false)
	SetDefaultValue('EnableEliteBorder', true)
	SetDefaultValue('EnableFocusBorder', true)
	SetDefaultValue('EnableExecuteBorder', false)
	SetDefaultValue('EliteEdgeSize', 1.0)
	SetDefaultValue('FocusEdgeSize', 1.0)
	SetDefaultValue('ExecuteEdgeSize', 1.0)
	SetDefaultValue('UseCustomTargets', false)
	SetDefaultValue('DisablePvp', true)
	SetDefaultValue('PreferAura', true)
	SetDefaultValue('PreferAuraCustom', true)
	SetDefaultValue('NameText', true)
	SetDefaultValue('EnableCVars', false)
	SetDefaultValue('EnableGlobalData', false)
	SetDefaultValue('HasSetGlobalData', false)
end

function mod:SetDefaultValues()
	opt.env = {}
	mod:LoadMissingValues()
end

function mod:ResetUi()
	opt.ui.colortarget:SetChecked(false)
	opt.ui.disablepvp:SetChecked(false)
	opt.ui.preferaura:SetChecked(false)
	opt.ui.preferauracustom:SetChecked(false)
	opt.ui.disablealpha:SetChecked(false)
	opt.ui.nametext:SetChecked(false)
	opt.ui.enableeliteborder:SetChecked(false)
	opt.ui.enablefocusborder:SetChecked(false)
	opt.ui.eliteedgesize:SetValue(1)
	opt.ui.focusedgesize:SetValue(1)
	opt.ui.execute_edgesize:SetValue(1)
	opt.ui.targetcolor:SetBackdropColor(1, 1, 1, 1)
	opt.ui.addtargetcolor:SetBackdropColor(1, 1, 1, 1)
	opt.ui.elitebordercolor:SetBackdropColor(1, 1, 1, 0.7)
	opt.ui.focusbordercolor:SetBackdropColor(1, 1, 0, 1)
	opt.ui.execute_border_color:SetBackdropColor(1, 0, 0, 1)
	opt.ui.priority:SetValue(6)
	
	opt.ui.EnableCVars:SetChecked(false)
	opt.ui.EnableGlobalData:SetChecked(false)
	
	mod:RefreshCustomTargets()
	mod:RefreshClassAuras()
	
	opt:DisableCVars()
end

function mod:ReloadValues()
	mod:LoadMissingValues()
	
	opt.ui.colortarget:SetChecked(opt.env.ColorTarget)
	opt.ui.disablepvp:SetChecked(opt.env.DisablePvP)
	opt.ui.preferaura:SetChecked(opt.env.PreferAura)
	opt.ui.preferauracustom:SetChecked(opt.env.PreferAuraCustom)
	opt.ui.disablealpha:SetChecked(opt.env.DisableAlpha)
	opt.ui.nametext:SetChecked(opt.env.NameText)
	opt.ui.enableeliteborder:SetChecked(opt.env.EnableEliteBorder)
	opt.ui.enablefocusborder:SetChecked(opt.env.EnableFocusBorder)
	opt.ui.eliteedgesize:SetValue(opt.env.EliteEdgeSize)
	opt.ui.focusedgesize:SetValue(opt.env.FocusEdgeSize)
	opt.ui.targetcolor:SetBackdropColor(opt.env.TargetColor.r, opt.env.TargetColor.g, opt.env.TargetColor.b, opt.env.TargetColor.a)
	opt.ui.addtargetcolor:SetBackdropColor(opt.env.NewColor.r, opt.env.NewColor.g, opt.env.NewColor.b, opt.env.NewColor.a)
	opt.ui.elitebordercolor:SetBackdropColor(opt.env.EliteBorderColor.r, opt.env.EliteBorderColor.g, opt.env.EliteBorderColor.b, opt.env.EliteBorderColor.a)
	opt.ui.focusbordercolor:SetBackdropColor(opt.env.FocusBorderColor.r, opt.env.FocusBorderColor.g, opt.env.FocusBorderColor.b, opt.env.FocusBorderColor.a)
	opt.ui.execute_border_color:SetBackdropColor(opt.env.ExecuteBorderColor.r, opt.env.ExecuteBorderColor.g, opt.env.ExecuteBorderColor.b, opt.env.ExecuteBorderColor.a)
	opt.ui.priority:SetValue(opt.env.Priority)
	
	opt.ui.EnableCVars:SetChecked(opt.env.EnableCVars)
	opt.ui.EnableGlobalData:SetChecked(opt.env.EnableGlobalData)
	
	mod:RefreshCustomTargets()
	mod:RefreshClassAuras()
	
	opt:UpdateCVars()
	
	if (opt.env.EnableCVars) then
		opt:EnableCVars()
	else
		opt:DisableCVars()
	end
end

function mod:LoadPerCharacterData()
	-- per character
	if KuiTargetHelperConfigCharSaved == nil then
		mod:SetDefaultValues()
		KuiTargetHelperConfigCharSaved = opt.env
	else
		opt.env = KuiTargetHelperConfigCharSaved
	end
end

function mod:LoadGlobalData()
	-- global, already nil checked
	opt.env = KuiTargetHelperConfigSaved
end

-- Load saved data, or fall back to default data
function mod:LoadSavedData()

	-- check if we have any global data yet
	if KuiTargetHelperConfigSaved == nil then
		KuiTargetHelperConfigSaved = {}
		KuiTargetHelperConfigSaved.HasSetGlobalData = false
	end
	
	-- global data wasn't valid, disable any local opt-in to global data
	if (KuiTargetHelperConfigSaved.HasSetGlobalData == nil) then
		if (KuiTargetHelperConfigCharSaved ~= nil) then
			KuiTargetHelperConfigCharSaved.EnableGlobalData = false
		end
	end
	
	-- global data wasn't set, disable any local opt-in to global data
	if (KuiTargetHelperConfigSaved.HasSetGlobalData == false) then
		if (KuiTargetHelperConfigCharSaved ~= nil) then
			KuiTargetHelperConfigCharSaved.EnableGlobalData = false
		end
	end
	
	-- if nil, or unset, just load per-character data
	-- otherwise, load global data
	if ((KuiTargetHelperConfigCharSaved == nil) or 
		(KuiTargetHelperConfigCharSaved.EnableGlobalData == nil) or 
		(KuiTargetHelperConfigCharSaved.EnableGlobalData == false)) then
		mod:LoadPerCharacterData()
	else
		mod:LoadGlobalData()
	end
	
end

function opt:Update()
	if (opt.ShouldResetFrames) then
		opt:ResetFrames()
		opt.ShouldResetFrames = false
	end
end

function ShowEvent(frame)
	-- refresh cvars when this screen displays
	opt:UpdateCVars()
end

function UpdateTick(self, elapsed)
	opt.TimeSinceLastUpdate = opt.TimeSinceLastUpdate + elapsed; 	

	if (opt.TimeSinceLastUpdate > opt.UpdateInterval) then
		opt:Update()
		opt.TimeSinceLastUpdate = 0;
	end
end

-- Configuration Setup
function mod:Initialised()

	local buildid = select(4, GetBuildInfo())
	if (buildid >= 100000) then
		opt.IsDragonFlight = true
	else
		opt.IsDragonFlight = false
	end

	opt:SetupLocale()
	mod:LoadSavedData()
	mod:LoadMissingValues()
	mod:LoadConfigUi()
	
	-- finish initialization
	mod:RefreshCustomTargets()
	mod:RefreshClassAuras()
	mod:RefreshRenameTargets()
	mod:RefreshFilterTargets()
	
	-- hook scripts
	opt:HookScript("OnUpdate", UpdateTick)
	opt:HookScript("OnShow", ShowEvent)
		
	-- end  
	opt.Initialized = true
end

function mod:LoadConfigUi()

	-- add the main config
	InterfaceOptions_AddCategory(opt)

	-- add sub-categories
	InterfaceOptions_AddCategory(profiles)
	InterfaceOptions_AddCategory(custom_targets)
	InterfaceOptions_AddCategory(aura_colors)
	InterfaceOptions_AddCategory(unit_names)
	InterfaceOptions_AddCategory(unit_filter)
	InterfaceOptions_AddCategory(cvars)
	
	-- create main panel
	mod:CreateMainPanel(opt)

	-- create subpanels
	mod:CreateProfilesPanel(profiles)
	mod:CreateCustomTargetsPanel(custom_targets)
	mod:CreateCustomAurasPanel(aura_colors)
	mod:CreateRenamesPanel(unit_names)
	mod:CreateFilterPanel(unit_filter)
	mod:CreateCVarPanel(cvars)
end

function opt:ReloadGlobalData()

	-- no global data set, so nothing to do
	if (KuiTargetHelperConfigSaved.HasSetGlobalData == false) then
		rlPrintf("Global data settings saved.");
		KuiTargetHelperConfigSaved.HasSetGlobalData = true
		return
	end
	
	-- ask the user to load from global.
	-- if they decline, we'll ask them to save from global instead
	StaticPopup_Show("KUI_TargetHelper_LoadFromGlobal")	
end

function opt:ConfirmGlobalLoad()
	-- use global values
	opt.env = KuiTargetHelperConfigSaved
	KuiTargetHelperConfigCharSaved = KuiTargetHelperConfigSaved

	rlPrintf("Global data settings loaded.");
	opt.env.EnableGlobalData = true
	mod:ReloadValues()
end

function opt:ConfirmGlobalSave()
	KuiTargetHelperConfigSaved = opt.env
	KuiTargetHelperConfigSaved.HasSetGlobalData = true
	
	rlPrintf("Global data settings saved.");
	opt.env.EnableGlobalData = true
	mod:ReloadValues()
end

function opt:CancelGlobal()
	rlPrintf("Global data settings not applied.");
	opt.env.EnableGlobalData = false
	mod:ReloadValues()
end

function opt:ConfirmDelete()
	mod:SetDefaultValues()
	mod:ResetUi()
end

-- Save Player data on logout
function events:PLAYER_LOGOUT()

	-- don't save anything if we failed to load
	if not opt.Initialized then return end

	-- ensure global data is a valid object
	if (KuiTargetHelperConfigSaved == nil) then
		KuiTargetHelperConfigSaved = {}
		HasSetGlobalData = false
	end
	
	-- store the 'enable global data' flag in both locations. we'll only read from per-character.
	KuiTargetHelperConfigCharSaved.EnableGlobalData = opt.env.EnableGlobalData
	KuiTargetHelperConfigSaved.EnableGlobalData = opt.env.EnableGlobalData
	
	-- do we need to save global data?
	if (opt.env.EnableGlobalData == true) then
		KuiTargetHelperConfigSaved = opt.env
		KuiTargetHelperConfigSaved.HasSetGlobalData = true
	end
	
	-- always save a copy out to local character data too
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