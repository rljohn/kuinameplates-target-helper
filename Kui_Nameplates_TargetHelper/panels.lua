local folder,ns = ...
local addon = KuiNameplates
local core = KuiNameplatesCore
local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod

-- scroll area
local SCROLL_W = 580
local SCROLL_H = 450
local SCROLL_X = 25
local SCROLL_Y = -70

-- title offsets
local TITLE_X = -8
local TITLE_Y = 40

-- footers
local FOOTER_ANCHOR_POINT = 'BOTTOMRIGHT'
local FOOTER_X = -5
local FOOTER_Y = 10

-- dragonlands resizing
function GetScrollWidth()
	if (opt.IsDragonFlight) then
		return SCROLL_W
	else
		return SCROLL_W - 40
	end
end

function GetResetAnchor()
	if (opt.IsDragonFlight) then
		return "BOTTOMLEFT"
	else
		return "BOTTOMRIGHT"
	end
end

function GetResetOffsetX()
	if (opt.IsDragonFlight) then
		return 14
	else
		return -16
	end
end

function GetResetOffsetY()
	if (opt.IsDragonFlight) then
		return 14
	else
		return 26
	end
end

function mod:CreateMainPanel(parent)

	local version = parent:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	version:SetFontObject("GameFontNormalSmall")
	version:SetTextColor(1,1,1,0.5)
	version:SetPoint(FOOTER_ANCHOR_POINT, FOOTER_X, FOOTER_Y)
	version:SetText(string.format(
		opt.info.header,
		opt.info.name,
		opt.info.version
	))
	
	-- top panel
	opt.ui.toppanel = opt:CreatePanel(parent, "TopFrame", 330, 170)
	opt.ui.toppanel:SetPoint('TOPLEFT', 25, -40)
	
	opt.ui.topPanelTitle = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	opt.ui.topPanelTitle:SetText(opt.titles.TargetOptions)
	opt.ui.topPanelTitle:SetPoint('BOTTOMLEFT', opt.ui.toppanel, 'TOPLEFT', 0, 14)
	
	-- target color
	
	opt.ui.colortarget = opt:CreateCheckBox(opt.ui.toppanel, 'ColorTarget')
	opt.ui.colortarget:SetPoint("TOPLEFT", opt.ui.toppanel, "TOPLEFT", 0, -5)
	opt:AddTooltip(opt.ui.colortarget, opt.titles.ColorTarget, opt.titles.ColorTargetTooltip)
	
	opt.ui.targetcolor = opt:CreateColorTexture(opt.ui.toppanel, 'TargetColor', 160, 24,opt.env.TargetColor.r, opt.env.TargetColor.g, opt.env.TargetColor.b, opt.env.TargetColor.a)
	opt.ui.targetcolor:SetPoint("TOPLEFT", opt.ui.colortarget, "TOPRIGHT", 160, -2)
	
	-- disable in pvp
	
	opt.ui.disablepvp = opt:CreateCheckBox(opt.ui.toppanel, 'DisablePvP')
	opt.ui.disablepvp:SetPoint("TOPLEFT", opt.ui.colortarget, "BOTTOMLEFT", 0, -8)
	opt:AddTooltip2(opt.ui.disablepvp, opt.titles.DisablePvP, opt.titles.DisablePvPTooltip)
	
	-- recolor target name
	
	opt.ui.nametext = opt:CreateCheckBox(opt.ui.toppanel, 'NameText')
	opt.ui.nametext:SetPoint("TOPLEFT", opt.ui.disablepvp, "TOPRIGHT", 160, 0)
	opt:AddTooltip2(opt.ui.nametext, opt.titles.NameText, opt.titles.NameTextTooltip)
	
	-- prefer auras over target
	
	opt.ui.preferaura = opt:CreateCheckBox(opt.ui.toppanel, 'PreferAura')
	opt.ui.preferaura:SetPoint("TOPLEFT", opt.ui.disablepvp, "BOTTOMLEFT", 0, -8)
	opt:AddTooltip2(opt.ui.preferaura, opt.titles.PreferAura, opt.titles.PreferAuraTooltip)
	
	-- prefer auras over custom
	
	opt.ui.preferauracustom = opt:CreateCheckBox(opt.ui.toppanel, 'PreferAuraCustom')
	opt.ui.preferauracustom:SetPoint("TOPLEFT", opt.ui.preferaura, "BOTTOMLEFT", 0, -8)
	opt:AddTooltip2(opt.ui.preferauracustom, opt.titles.PreferAuraCustom, opt.titles.PreferAuraCustomTooltip)
	
	opt.ui.disablealpha = opt:CreateCheckBox(opt.ui.toppanel, 'DisableAlpha')
	opt.ui.disablealpha:SetPoint("TOPLEFT", opt.ui.preferauracustom, "BOTTOMLEFT", 0, -8)
	opt:AddTooltip2(opt.ui.disablealpha, opt.titles.DisableAlpha, opt.titles.DisableAlphaTooltip)
	
	-- 'border options' panel
	
	opt.ui.sidepanel = opt:CreatePanel(parent, "SideFrame", 380, 105)
	opt.ui.sidepanel:SetPoint('TOPLEFT', opt.ui.toppanel, 'BOTTOMLEFT', 0, -50)

	opt.ui.sidePanelTitle = opt.ui.sidepanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	opt.ui.sidePanelTitle:SetText(opt.titles.BorderOptions)
	opt.ui.sidePanelTitle:SetPoint('BOTTOMLEFT', opt.ui.sidepanel, 'TOPLEFT', 0, 14)

	-- elite/boss borders

	opt.ui.enableeliteborder = opt:CreateCheckBox(opt.ui.sidepanel, "EnableEliteBorder")
	opt.ui.enableeliteborder:SetPoint('TOPLEFT', opt.ui.sidepanel, "TOPLEFT", 0, -6)
	opt:AddTooltip(opt.ui.enableeliteborder, opt.titles.EnableEliteBorder, opt.titles.EnableEliteBorderTooltip)
	
	opt.ui.elitebordercolor = opt:CreateColorTexture(opt.ui.sidepanel, 'EliteBorderColor', 20, 20, opt.env.EliteBorderColor.r, opt.env.EliteBorderColor.g, opt.env.EliteBorderColor.b, opt.env.EliteBorderColor.a)
	opt.ui.elitebordercolor:SetPoint("TOPLEFT", opt.ui.enableeliteborder, "TOPLEFT", 190, -6)
	opt:AddTooltip(opt.ui.elitebordercolor, opt.titles.EnableEliteBorder, opt.titles.EnableEliteBorderTooltip)
	
	opt.ui.eliteedgesize = opt:CreateSlider(opt.ui.sidepanel, 'EliteEdgeSize', 1, 3, 1, 140, false)
	opt.ui.eliteedgesize:SetPoint("TOPLEFT", opt.ui.elitebordercolor, "TOPRIGHT", 25, 0)
	opt:AddTooltip(opt.ui.eliteedgesize, opt.titles.EliteEdgeSize, opt.titles.EliteEdgeSizeTooltip)
	
	-- focus borders
	
	opt.ui.enablefocusborder = opt:CreateCheckBox(opt.ui.sidepanel, "EnableFocusBorder")
	opt.ui.enablefocusborder:SetPoint('TOPLEFT', opt.ui.enableeliteborder, "BOTTOMLEFT", 0, -6)
	opt:AddTooltip(opt.ui.enablefocusborder, opt.titles.EnableFocusBorder, opt.titles.EnableFocusBorderTooltip)
	
	opt.ui.focusbordercolor = opt:CreateColorTexture(opt.ui.sidepanel, 'FocusBorderColor', 20, 20, opt.env.FocusBorderColor.r, opt.env.FocusBorderColor.g, opt.env.FocusBorderColor.b, opt.env.FocusBorderColor.a)
	opt.ui.focusbordercolor:SetPoint("TOPLEFT", opt.ui.enablefocusborder, "TOPLEFT", 190, -6)
	opt:AddTooltip(opt.ui.focusbordercolor, opt.titles.EnableFocusBorder, opt.titles.EnableFocusBorderTooltip)
	
	opt.ui.focusedgesize = opt:CreateSlider(opt.ui.sidepanel, 'FocusEdgeSize', 1, 3, 1, 140, true)
	opt.ui.focusedgesize:SetPoint("TOPLEFT", opt.ui.focusbordercolor, "TOPRIGHT", 25, 0)
	opt:AddTooltip(opt.ui.focusedgesize, opt.titles.FocusEdgeSize, opt.titles.FocusEdgeSizeTooltip)

	-- execute
	opt.ui.enable_execute_border = opt:CreateCheckBox(opt.ui.sidepanel, "EnableExecuteBorder")
	opt.ui.enable_execute_border:SetPoint('TOPLEFT', opt.ui.enablefocusborder, "BOTTOMLEFT", 0, -6)
	opt:AddTooltip(opt.ui.enable_execute_border, opt.titles.EnableExecuteBorder, opt.titles.EnableExecuteBorderTooltip)
	
	opt.ui.execute_border_color = opt:CreateColorTexture(opt.ui.sidepanel, 'ExecuteBorderColor', 20, 20, opt.env.ExecuteBorderColor.r, opt.env.ExecuteBorderColor.g, opt.env.ExecuteBorderColor.b, opt.env.ExecuteBorderColor.a)
	opt.ui.execute_border_color:SetPoint("TOPLEFT", opt.ui.enable_execute_border, "TOPLEFT", 190, -6)
	opt:AddTooltip(opt.ui.execute_border_color, opt.titles.EnableExecuteBorder, opt.titles.EnableExecuteBorderTooltip)
	
	opt.ui.execute_edgesize = opt:CreateSlider(opt.ui.sidepanel, 'ExecuteEdgeSize', 1, 3, 1, 140, true)
	opt.ui.execute_edgesize:SetPoint("TOPLEFT", opt.ui.execute_border_color, "TOPRIGHT", 25, 0)
	opt:AddTooltip(opt.ui.execute_edgesize, opt.titles.ExecuteEdgeSize, opt.titles.ExecuteEdgeSizeTooltip)

	if (opt.plugin_execute and not opt.plugin_execute.plugin_enabled) then
		opt:OnExecutePluginEnabled(opt.plugin_execute.plugin_enabled)
	end

	-- priority slider
	
	opt.ui.prioritypanel = opt:CreatePanel(parent, "PriorityFrame", 330, 110)
	opt.ui.prioritypanel:SetPoint('TOPLEFT', opt.ui.sidepanel, "BOTTOMLEFT", 0, -55)
	
	opt.ui.priorityPanelTitle = opt.ui.prioritypanel:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	opt.ui.priorityPanelTitle:SetText(opt.titles.PriorityText)
	opt.ui.priorityPanelTitle:SetPoint('BOTTOMLEFT', opt.ui.prioritypanel, 'TOPLEFT', 0, 14)
	
	opt.ui.priority = opt:CreateSliderWithReload(opt.ui.prioritypanel, 'Priority', 1, 50, 1, 330)
	opt.ui.priority:SetPoint("TOPLEFT", opt.ui.prioritypanel, "TOPLEFT", 12, -15)
	opt:AddTooltip(opt.ui.priority, opt.titles.PriorityText, opt.titles.PriorityTooltip)
	
	opt.ui.priorityhelp = opt.ui.prioritypanel:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	opt.ui.priorityhelp:SetText(opt.titles.PriorityTankMode)
	opt.ui.priorityhelp:SetPoint('TOPLEFT', opt.ui.priority, 'BOTTOMLEFT', -4, -16)
	opt.ui.priorityhelp:SetJustifyH("LEFT")
	
	-- reset button
	
	local f = CreateFrame("Button", "test2", opt, "UIPanelButtonTemplate")
	f:SetPoint(GetResetAnchor(), GetResetOffsetX(), GetResetOffsetY())
	f:SetWidth(90)
	f:SetHeight(30)
	f:SetText(opt.titles.ResetAll)
	opt:AddTooltip(f, "", opt.titles.ResetTooltip)
	
	f:SetScript("OnClick", function(self, arg1)
		StaticPopup_Show("KUI_TargetHelper_DeleteConfirm")
	end)
end

function opt:OnExecutePluginEnabled(enabled)

	if (not opt.ui.enable_execute_border) then return end
	if (not opt.ui.execute_edgesize) then return end
	if (not opt.ui.execute_border_color) then return end


	local alpha = 0.5
	if (enabled) then
		alpha = 1
		opt.ui.enable_execute_border:Enable()
		opt.ui.execute_border_color:Enable()
		opt.ui.execute_edgesize:Enable()
	else
		opt.ui.enable_execute_border:Disable()
		opt.ui.execute_border_color:Disable()
		opt.ui.execute_edgesize:Disable()
	end

	opt.ui.enable_execute_border:SetAlpha(alpha)
	opt.ui.execute_edgesize:SetAlpha(alpha)
	opt.ui.execute_border_color:SetAlpha(alpha)
end

function mod:CreateProfilesPanel(parent)

	local panel = opt:CreatePanel(parent, nil, GetScrollWidth(), 80)
	panel:SetPoint('TOPLEFT', parent, 'TOPLEFT', SCROLL_X, SCROLL_Y)

	-- profiles
	local title = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	title:SetText(opt.titles["ProfilesTitle"])
	title:SetPoint('BOTTOMLEFT', panel, 'TOPLEFT', TITLE_X, TITLE_Y)

	local header = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	header:SetText(opt.titles["ProfilesHeader"])
	header:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -8)

	local footer = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	footer:SetText(opt.titles["ProfilesFooter"])
	footer:SetTextColor(1,1,1,0.5)
	footer:SetPoint(FOOTER_ANCHOR_POINT,FOOTER_X, FOOTER_Y)

	-- import/export
	local subpanel = opt:CreateScrollArea(parent, nil, GetScrollWidth(), 260)
	subpanel:SetPoint('TOPLEFT', panel, 'TOPLEFT', 0, -180)
	subpanel:SetMouseClickEnabled(true)

	local subtitle = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	subtitle:SetText(opt.titles["ImportExportTitle"])
	subtitle:SetPoint('BOTTOMLEFT', subpanel, 'TOPLEFT', TITLE_X, TITLE_Y)

	local subheader = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	subheader:SetText(opt.titles["ImportExportInfo"])
	subheader:SetPoint('TOPLEFT', subtitle, 'BOTTOMLEFT', 0, -8)

	mod:AddProfileWidgets(parent, panel, subpanel)
end

function mod:CreateCustomTargetsPanel(parent)
	opt.ui.scroll = opt:CreateScrollArea(parent, 'NameArea', GetScrollWidth(), SCROLL_H - 95)
	opt.ui.scroll:SetPoint('TOPLEFT', parent, 'TOPLEFT', SCROLL_X, SCROLL_Y)
	
	opt.ui.listEnemiesTitle = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	opt.ui.listEnemiesTitle:SetText(opt.titles["CustomTarget"])
	opt.ui.listEnemiesTitle:SetPoint('BOTTOMLEFT', opt.ui.scroll, 'TOPLEFT', TITLE_X, TITLE_Y)
	
	opt.ui.listEnemiesHeader = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	opt.ui.listEnemiesHeader:SetText(opt.titles["CustomTargetHeader"])
	opt.ui.listEnemiesHeader:SetPoint('TOPLEFT', opt.ui.listEnemiesTitle, 'BOTTOMLEFT', 0, -8)
	
	opt.ui.listEnemiesFooter = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	opt.ui.listEnemiesFooter:SetText(opt.titles["CustomTargetFooter"])
	opt.ui.listEnemiesFooter:SetTextColor(1,1,1,0.5)
	opt.ui.listEnemiesFooter:SetPoint(FOOTER_ANCHOR_POINT, FOOTER_X, FOOTER_Y)
	
	mod:CustomTargetWidgets(parent)
	
end

function mod:CreateInterruptsPanel(parent)

	opt.ui.interruptsArea = opt:CreateScrollArea(parent, 'InterruptArea', GetScrollWidth(), SCROLL_H - 128)
	opt.ui.interruptsArea:SetPoint('TOPLEFT', parent, 'TOPLEFT', SCROLL_X, SCROLL_Y)

	opt.ui.interruptsTitle = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	opt.ui.interruptsTitle:SetText(opt.titles["Interrupts"])
	opt.ui.interruptsTitle:SetPoint('BOTTOMLEFT', opt.ui.interruptsArea, 'TOPLEFT', TITLE_X, TITLE_Y)

	opt.ui.interruptsHeader = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	opt.ui.interruptsHeader:SetText(opt.titles["InterruptsHeader"])
	opt.ui.interruptsHeader:SetPoint('TOPLEFT', opt.ui.interruptsTitle, 'BOTTOMLEFT', 0, -8)

	mod:InterruptsWidgets(parent)
	
end

function mod:CreateCustomAurasPanel(parent)
	
	opt.ui.auralist = opt:CreateScrollArea(parent, 'AuraArea', GetScrollWidth(), SCROLL_H)
	opt.ui.auralist:SetPoint('TOPLEFT', parent, 'TOPLEFT', SCROLL_X, SCROLL_Y)
	
	opt.ui.auralistTitle = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	opt.ui.auralistTitle:SetText(opt.titles["ClassAuras"])
	opt.ui.auralistTitle:SetPoint('BOTTOMLEFT', opt.ui.auralist, 'TOPLEFT', TITLE_X, TITLE_Y)
	
	opt.ui.auralistHeader = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	opt.ui.auralistHeader:SetText(opt.titles["ClassAurasHeader"])
	opt.ui.auralistHeader:SetPoint('TOPLEFT', opt.ui.auralistTitle, 'BOTTOMLEFT', 0, -8)
	
	opt.ui.auralistFooter = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	opt.ui.auralistFooter:SetText(opt.titles["ClassAurasFooter"])
	opt.ui.auralistFooter:SetTextColor(1,1,1,0.5)
	opt.ui.auralistFooter:SetPoint(FOOTER_ANCHOR_POINT,FOOTER_X, FOOTER_Y)
	
	opt.ui.aurasNone = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	opt.ui.aurasNone:SetText(opt.titles["ClassAurasNone"])
	opt.ui.aurasNone:SetPoint('TOPLEFT', opt.ui.auralist, 'TOPLEFT', 8, -8)
	opt.ui.aurasNone:SetJustifyH('LEFT')
	
	opt.ui.spellListWarning = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	opt.ui.spellListWarning:SetText(opt.titles.SpellListWarning)
	opt.ui.spellListWarning:SetPoint('TOPLEFT', opt.ui.auralist, 'BOTTOMLEFT', 4, -16)
	opt.ui.spellListWarning:SetJustifyH('LEFT')
	
end

function mod:CreateRenamesPanel(parent)

	opt.ui.renameScrollArea = opt:CreateScrollArea(parent, 'RenameArea', GetScrollWidth(), SCROLL_H)
	opt.ui.renameScrollArea:SetPoint('TOPLEFT', parent, 'TOPLEFT', SCROLL_X, SCROLL_Y)
	
	opt.ui.renameTitle = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	opt.ui.renameTitle:SetText(opt.titles["UnitNamesTitle"])
	opt.ui.renameTitle:SetPoint('BOTTOMLEFT', opt.ui.renameScrollArea, 'TOPLEFT', TITLE_X, TITLE_Y)
	
	opt.ui.renameHeader = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	opt.ui.renameHeader:SetText(opt.titles["UnitNamesHeader"])
	opt.ui.renameHeader:SetPoint('TOPLEFT', opt.ui.renameTitle, 'BOTTOMLEFT', 0, -8)
	
	if (opt.IsDragonFlight) then
		opt.ui.renameFooter = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
		opt.ui.renameFooter:SetText(opt.titles["UnitNamesFooter"])
		opt.ui.renameFooter:SetTextColor(1,1,1,0.5)
		opt.ui.renameFooter:SetPoint(FOOTER_ANCHOR_POINT, FOOTER_X, FOOTER_Y)
	end
	
	mod:AddRenameWidgets(parent)

end

function mod:CreateFilterPanel(parent)

	opt.ui.filterScrollArea = opt:CreateScrollArea(parent, 'FilterArea', GetScrollWidth(), SCROLL_H)
	opt.ui.filterScrollArea:SetPoint('TOPLEFT', parent, 'TOPLEFT', SCROLL_X, SCROLL_Y)
	
	opt.ui.filterTitle = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	opt.ui.filterTitle:SetText(opt.titles["UnitFilterTitle"])
	opt.ui.filterTitle:SetPoint('BOTTOMLEFT', opt.ui.filterScrollArea, 'TOPLEFT', TITLE_X, TITLE_Y)
	
	opt.ui.filterHeader = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	opt.ui.filterHeader:SetText(opt.titles["UnitFilterHeader"])
	opt.ui.filterHeader:SetPoint('TOPLEFT', opt.ui.filterTitle, 'BOTTOMLEFT', 0, -8)
	
	opt.ui.filterFooter = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	opt.ui.filterFooter:SetText(opt.titles["UnitFilterFooter"])
	opt.ui.filterFooter:SetTextColor(1,1,1,0.5)
	opt.ui.filterFooter:SetPoint(FOOTER_ANCHOR_POINT, FOOTER_X, FOOTER_Y)
	
	mod:AddNameFilterWidgets(parent)

end

function mod:CreateAuraFilterPanel(parent)

	-- if KUI spell list config is loaded, we dont need this feature
    if (KuiSpellListConfig) then
        local KSLText = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
        KSLText:SetText('This panel is incompatible with Kui SpellListConfig')
        KSLText:SetPoint('TOPLEFT', parent, 'TOPLEFT', SCROLL_X + TITLE_X, -16)
        return
    end

	opt.ui.auraFilterScrollArea = opt:CreateScrollArea(parent, 'AuraFilterArea', GetScrollWidth(), SCROLL_H)
	opt.ui.auraFilterScrollArea:SetPoint('TOPLEFT', parent, 'TOPLEFT', SCROLL_X, SCROLL_Y)
	
	opt.ui.auraFilterTitle = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	opt.ui.auraFilterTitle:SetText(opt.titles["AuraFilterTitle"])
	opt.ui.auraFilterTitle:SetPoint('BOTTOMLEFT', opt.ui.auraFilterScrollArea, 'TOPLEFT', TITLE_X, TITLE_Y)
	
	opt.ui.auraFilterHeader = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	opt.ui.auraFilterHeader:SetText(opt.titles["AuraFilterHeader"])
	opt.ui.auraFilterHeader:SetPoint('TOPLEFT', opt.ui.auraFilterTitle, 'BOTTOMLEFT', 0, -8)
	
	opt.ui.auraFilterFooter = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	opt.ui.auraFilterFooter:SetText(opt.titles["AuraFilterFooter"])
	opt.ui.auraFilterFooter:SetTextColor(1,1,1,0.5)
	opt.ui.auraFilterFooter:SetPoint(FOOTER_ANCHOR_POINT, FOOTER_X, FOOTER_Y)

	mod:AddAuraFilterWidgets(parent)

end

function mod:CreateCVarPanel(parent)

	local panel = opt:CreatePanel(parent, nil, GetScrollWidth(), SCROLL_H)
	panel:SetPoint('TOPLEFT', parent, 'TOPLEFT', SCROLL_X, SCROLL_Y)

	local title = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	title:SetText(opt.titles["CVarTitlePanel"])
	title:SetPoint('BOTTOMLEFT', panel, 'TOPLEFT', TITLE_X, TITLE_Y)

	local header = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	header:SetText(opt.titles["CVarTitleHeader"])
	header:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -8)

	local footer = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalSmall')
	footer:SetText(opt.titles["CVarsFooter"])
	footer:SetTextColor(1,1,1,0.5)
	footer:SetPoint(FOOTER_ANCHOR_POINT,FOOTER_X, FOOTER_Y)

	mod:AddCVarWidgets(panel)
end