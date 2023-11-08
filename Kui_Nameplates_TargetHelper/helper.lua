local folder,ns = ...
local addon = KuiNameplates
local core = KuiNameplatesCore
local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod
local ReloadWarningShown = false

local ENABLE_LOGGING=false
local ENABLE_DIAG=ENABLE_LOGGING and true

-- LOGGING
function rlPrintf(...)
	if not ENABLE_LOGGING then return end
	local status, res = pcall(format, ...)
	if status then
		print('|cff9966ffKUI TargetHelper:|r', res)
	end
end

function rlDiagf(...)
	if not ENABLE_DIAG then return end
	local status, res = pcall(format, ...)
	if status then
		print('|cff9966ffKUI TargetHelper:|r', res)
	end
end

function mod:SortedPairs(t)

	-- collect the keys
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end

	-- sort the keys
	table.sort(keys, function(a, b) return a:upper() < b:upper() end)

	-- create an indexed array
	local results = {}
	for i=0,#keys do
		results[i] = { keys[i], t[keys[i]] }
	end

	return results
end

-- HELPER FUNCTIONS
function opt:ShouldFilterUnit(name)
	if (not name or name == "") then return false end

	for k,v in pairs ( opt.env.FilterTargets ) do
		if (k == name and v.active) then
			return true
		end
	end
	
	return false
end

-- When unfiltering units, re-add any nameplate back into KUI
function opt:EvaluateFilter()


	-- iterate all active namepaltes
	for _, f in pairs(C_NamePlate.GetNamePlates()) do
		
		-- get the unit name, see if we are meant to unfilter
		local unit = f.namePlateUnitToken
		local name = GetUnitName(unit)

		-- hide
		opt.original_kui_hide_function(addon, unit)

		-- check if we are meant to filter this unit.
		if (opt:ShouldFilterUnit(name)) then
			-- hide default frame as well if necessary
			if (f.UnitFrame) then
				f.UnitFrame:Hide()
			end
		else
			-- show the nameplate again
			opt.original_kui_show_function(addon, unit)
		end
	end
end

-- hide all KUI frames and then re-add them
function opt:ResetFrames()
	for i, f in addon:Frames() do
		if f:IsShown() then
			local unit = f.unit
			f.handler:OnHide()
			f.handler:OnUnitAdded(unit)
		end
	end
end

-- Tooltips

function opt:OnTooltipEnter(self)
	
	if not self.tooltipText then
		return
	end
	
	GameTooltip:SetOwner(self,'ANCHOR_TOPLEFT')
    GameTooltip:SetWidth(400)
	
	if self.tooltipTitle then
		GameTooltip:AddLine(self.tooltipTitle)
	end
	
	GameTooltip:AddLine(self.tooltipText, 1, 1, 1, true)
	
	if self.tooltipText2 then
		GameTooltip:AddLine(self.tooltipText2, 1, 1, 1, true)
	end
	
	GameTooltip:Show()
end

function opt:OnTooltipLeave(self)
	if not self.tooltipText then
		return
	end
	
    GameTooltip:Hide()
end

function opt:AddTooltip2(frame, title, text, text2)
	if not frame then return end
	frame:EnableMouse(true)
	frame.tooltipTitle = title
	frame.tooltipText = text
	frame.tooltipText2 = text2
	frame:SetScript('OnEnter',function(self)
			opt:OnTooltipEnter(self)
		end)
    frame:SetScript('OnLeave',function(self)
			opt:OnTooltipLeave(self)
		end)

	if (frame.label) then
		opt:AddTooltip2(frame.label, title, text, text2)
	end
end

function opt:AddTooltip(frame, title, text)
	opt:AddTooltip2(frame, title, text, nil)
end

-- Check Box

local function CheckBoxOnClick(self)
	opt.env[self:GetName()] = self:GetChecked()
		
	if self:GetChecked() then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) 
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end
	
	if (self:GetName() == "EnableCVars") then
		if self:GetChecked() then
			opt:EnableCVars()
		else
			opt:DisableCVars()
		end
	end
	
	if (self:GetName() == "EnableGlobalData") then
		if self:GetChecked() then
			opt:ReloadGlobalData()
		end
	end
	
	opt:ResetFrames()
end
	
function opt:CreateCheckBox(parent, name)
	local check = CreateFrame('CheckButton', name, parent, 'OptionsBaseCheckButtonTemplate')
	check:SetScript('OnClick',CheckBoxOnClick)
	check:Raise()
	
	check.label = check:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	check.label:SetText(opt.titles[name] or name or '!MissingTitle')
	check.label:SetPoint('LEFT', check, 'RIGHT')
	check.label.check = check
	check.label:SetScript('OnMouseDown', function(self, button, ...)
		if (button == 'LeftButton' and self.check:IsEnabled()) then
			self.check:Click()
		end
	end)
	
	check:SetChecked(opt.env[name])
	
	return check
end

function opt:EnsureSpecEnabledValid(spellid)
	
	local entry = opt.env.CustomAuraColors[spellid]
	if (entry[opt.class.specId] == nil) then
		entry[opt.class.specId] = {}

		if (entry.enabled) then
			entry[opt.class.specId].enabled = entry.enabled
		else
			entry[opt.class.specId].enabled = false
		end
	end
end

local KSL = LibStub('KuiSpellList-2.0')

function opt:NeedsSpellListConfig(spellid)

	-- todo: obviously this sucks\
	-- holy paladin support for now
	if spellid == 287280 then
		return true
	end

	return false
end

function opt:AddToSpellList(spellid)
	local name, rank, icon, castTime, minRange, maxRange  = GetSpellInfo(spellid)
	if KSL then
		if not KSL:SpellExcluded(spellid) then
			KSL:AddSpell(spellid, true, false)
		end
	end
end

function ClassAuraCheckboxOnClick(self)
	
	local spellid = self.spellid
	opt:EnsureSpecEnabledValid(spellid)

	if self:GetChecked() then
		opt.env.CustomAuraColors[self.spellid][opt.class.specId].enabled = true
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) 
	else
		opt.env.CustomAuraColors[self.spellid][opt.class.specId].enabled = false
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end

	if self:GetChecked() then
		if opt:NeedsSpellListConfig(spellid) then
			opt:AddToSpellList(spellid)
		end
	end
end

function opt:SetClassAuraChecked(check, spellid)
	local enabled = false
	local entry = opt.env.CustomAuraColors[spellid]
	if (entry[opt.class.specId]) then
		if (entry[opt.class.specId].enabled) then
			check:SetChecked(true)
			enabled = true
		else
			check:SetChecked(false)
		end
	elseif (entry.enabled == true) then
		check:SetChecked(true)
		enabled = true
	else
		check:SetChecked(false)
	end

	if enabled then
		if opt:NeedsSpellListConfig(spellid) then
			opt:AddToSpellList(spellid)
		end
	end
end

function opt:CreateClassAuraCheckBox(parent, spellid, spellname)

	local frameName = "check_" .. spellname
	local check = CreateFrame('CheckButton', frameName, parent, 'OptionsBaseCheckButtonTemplate')
	check.spellid = spellid
	check:SetScript('OnClick',ClassAuraCheckboxOnClick)
	check:Raise()
	
	check.label = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite', 7)
	check.label:SetText(spellname)
	check.label:SetPoint('LEFT', check, 'RIGHT')
	
	opt:EnsureSpecEnabledValid(spellid)
	return check
end

-- Sliders

local function slider_OnValueChanged(self, value)
	local strval = string.format("%.2f", value)
	
	opt.env[self:GetName()] = value
	self.label:SetText(strval)
	
	opt.ShouldResetFrames = true
end
	
function opt:CreateSlider(parent, name, minval, maxval, stepvalue, width, notitle)
	local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
	slider:SetOrientation("HORIZONTAL")
	slider:SetThumbTexture([[Interface\Buttons\UI-SliderBar-Button-Vertical]])
	slider:SetMinMaxValues(minval, maxval)
	slider:SetWidth(width)
	slider:SetHeight(16)
	slider:SetValueStep(stepvalue)
	slider:SetObeyStepOnDrag(true)
	
	if (notitle == false) then
		slider.title = opt.titles[name]
	end
	
	getglobal(name .. 'Low'):SetText(tostring(minval)); --Sets the left-side slider text (default is "Low").
	getglobal(name .. 'High'):SetText(tostring(maxval)); --Sets the right-side slider text (default is "High").
	
	if (notitle == false) then
		getglobal(name .. 'Text'):SetText(opt.titles[name] or name or '!MissingTitle'); --Sets the "title" text (top-centre of slider).
	end
 
 	slider:SetValue(opt.env[name])
	slider:SetScript("OnValueChanged", slider_OnValueChanged)
	
	local strval = string.format("%.2f", opt.env[name])
	slider.label = parent:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	slider.label:SetText(strval)
	slider.label:SetPoint('BOTTOM', slider, 0, -10)
	return slider;
end

-- Color Picker

local r,g,b,a = 1, 0, 0, 1;
local colorPicker
local colorEdit
local auraEdit

local function myColorCallback(restore)
 local newR, newG, newB, newA;
 if restore then
  -- The user bailed, we extract the old color from the table created by ShowColorPicker.
  newR, newG, newB, newA = unpack(restore);
 else
  -- Something changed
  newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
 end
 
 -- Update our internal storage.
 r, g, b, a = newR, newG, newB, 1.0 - newA;
 
 -- And update any UI elements that use this color...
 if (colorPicker) then	
	colorPicker:SetBackdropColor(r, g, b, a)
	opt.env[colorPicker:GetName()].r = r
	opt.env[colorPicker:GetName()].g = g
	opt.env[colorPicker:GetName()].b = b
	opt.env[colorPicker:GetName()].a = a
 end
 
 opt.ShouldResetFrames = true
end

function opt:ShowColorPicker(r, g, b, a, changedCallback)
 ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, changedCallback;
 ColorPickerFrame:SetColorRGB(r,g,b);
 ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
 ColorPickerFrame.previousValues = {r,g,b,a};
 ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
 ColorPickerFrame:Show();
end

function opt:ColorPickerOnClick(self)
	colorPicker = self;
	colorEdit = nil
	
	r = opt.env[colorPicker:GetName()].r
	g = opt.env[colorPicker:GetName()].g
	b = opt.env[colorPicker:GetName()].b
	a = opt.env[colorPicker:GetName()].a
	
	opt:ShowColorPicker(r, g, b, 1.0 - a, myColorCallback)
end

local function editColorCallback(restore)
	local newR, newG, newB, newA;
	
	if restore then
		-- The user bailed, we extract the old color from the table created by ShowColorPicker.
		newR, newG, newB, newA = unpack(restore);
	else
		-- Something changed
		newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
	end

	-- Update our internal storage.
	r, g, b, a = newR, newG, newB, 1.0 - newA;
	
	if colorEdit then
		-- And update any UI elements that use this color...
		colorEdit:SetBackdropColor(r, g, b, a)
		
		if colorEdit:GetParent() then

			if opt.env.CustomTargets[colorEdit:GetParent().id] then

				opt.env.CustomTargets[colorEdit:GetParent().id].r = r
				opt.env.CustomTargets[colorEdit:GetParent().id].g = g
				opt.env.CustomTargets[colorEdit:GetParent().id].b = b
				opt.env.CustomTargets[colorEdit:GetParent().id].a = a
				colorEdit:GetParent().name:SetTextColor(r, g, b)
				
				opt.env.NewColor.r = r
				opt.env.NewColor.g = g
				opt.env.NewColor.b = b
				opt.env.NewColor.a = a
				opt.ui.addtargetcolor:SetBackdropColor(r, g, b, a)

			elseif opt.env.CustomInterrupts[colorEdit:GetParent().id] then
				
				opt.env.CustomInterrupts[colorEdit:GetParent().id].r = r
				opt.env.CustomInterrupts[colorEdit:GetParent().id].g = g
				opt.env.CustomInterrupts[colorEdit:GetParent().id].b = b
				opt.env.CustomInterrupts[colorEdit:GetParent().id].a = a
				colorEdit:GetParent().name:SetTextColor(r, g, b)
				
				opt.env.NewInterruptColor.r = r
				opt.env.NewInterruptColor.g = g
				opt.env.NewInterruptColor.b = b
				opt.env.NewInterruptColor.a = a
				opt.ui.interrupt_color:SetBackdropColor(r, g, b, a)

			end

		end
	end
	
	opt.ShouldResetFrames = true
end

function opt:CustomTargetColorOnClick(self)
	colorPicker = nil
	colorEdit = self
	
	local clr = opt.env.CustomTargets[self:GetParent().id]
	opt:ShowColorPicker(clr.r, clr.g, clr.b, 1.0 - clr.a, editColorCallback)
end

function opt:CustomInterruptsOnClick(self)
	colorPicker = nil
	colorEdit = self
	
	local clr = opt.env.CustomInterrupts[self:GetParent().id]
	opt:ShowColorPicker(clr.r, clr.g, clr.b, 1.0 - clr.a, editColorCallback)
end

local function editAuraColorCallback(restore)

	local newR, newG, newB, newA;
	
	if restore then
		-- The user bailed, we extract the old color from the table created by ShowColorPicker.
		newR, newG, newB, newA = unpack(restore);
	else
		-- Something changed
		newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB();
	end

	-- Update our internal storage.
	r, g, b, a = newR, newG, newB, 1.0 - newA;
	
	local id = auraEdit:GetParent().id
	if auraEdit then
		-- And update any UI elements that use this color...
		auraEdit:SetBackdropColor(r, g, b, a)
		
		if auraEdit:GetParent() then
			if (opt.env.CustomAuraColors[id].color == nil) then
				opt.env.CustomAuraColors[id].color = {}
			end
		
			opt.env.CustomAuraColors[id].color.r = r
			opt.env.CustomAuraColors[id].color.g = g
			opt.env.CustomAuraColors[id].color.b = b
			opt.env.CustomAuraColors[id].color.a = a
		end
	end
	
	opt.ShouldResetFrames = true
end

function opt:AuraColorOnClick(self)
	colorPicker = nil
	auraEdit = self
	
	local clr
	if (opt.env.CustomAuraColors[self:GetParent().id] == nil or opt.env.CustomAuraColors[self:GetParent().id].color == nil) then
		clr = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 }
	else
		clr = opt.env.CustomAuraColors[self:GetParent().id].color
	end
	
	opt:ShowColorPicker(clr.r, clr.g, clr.b, 1.0 - clr.a, editAuraColorCallback)
end

-- Textures

function opt:CreateColorTexture(parent, name, w, h, red, green, blue, alpha)

	local frame = CreateFrame("Button", name, parent, "BackdropTemplate")
	frame:SetSize (w, h)
	frame:SetScript("OnClick", function(self, event, ...)
			opt:ColorPickerOnClick(self)
		end)
	
	frame:SetBackdrop({
            bgFile='interface/buttons/white8x8',
            edgeFile='interface/buttons/white8x8',
            edgeSize=1,
            insets={top=2,right=2,bottom=2,left=2}
        })
	frame:SetBackdropBorderColor(.5,.5,.5)
	frame:SetBackdropColor(red, green, blue, alpha)
	
	frame:Show()
	
	return frame;
end

-- Scroll Area

function opt:CreateScrollArea(parent, name, width, height)
	
	local panel = CreateFrame('Frame', nil, parent)
	panel:SetSize(width, height);
	
	local scroll = CreateFrame("ScrollFrame", name, parent, 'UIPanelScrollFrameTemplate')
	scroll:SetSize(width, height)
	scroll:SetScrollChild(panel)
	scroll.panel = panel
	
	local bg = CreateFrame('Frame', nil, parent, "BackdropTemplate")
	bg:SetBackdrop({
        bgFile = 'interface/buttons/white8x8',
        edgeFile = 'Interface/Tooltips/UI-Tooltip-border',
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	bg:SetBackdropColor(.1,.1,.1,.3)
	bg:SetBackdropBorderColor(1, 1, 1)
	bg:SetPoint('TOPLEFT', scroll, -10, 10)
	bg:SetPoint('BOTTOMRIGHT', scroll, 30, -10)
	bg:SetFrameStrata("MEDIUM")
	
	return scroll
end

-- Button

function opt:CreateButton(parent, name, width, height, text)
	local button = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
	button:SetWidth(width)
	button:SetHeight(height)
	button:SetText(text)
	return button
end

-- Edit Box

function opt:CreateEditBox(parent, name, maxLetters, width, height)
	local box = CreateFrame("EditBox", name, parent, "InputBoxTemplate")
	box:SetAutoFocus(false)
	box:EnableMouse(true)
	box:SetMaxLetters(maxLetters)
	box:SetSize(width, height)
	return box
end

-- Panel

function opt:CreatePanel(parent, name, width, height)
	local panel = CreateFrame("Frame", name, parent)
	panel:SetSize(width, height)
	
	local bg = CreateFrame('Frame', nil, panel, "BackdropTemplate")
	bg:SetBackdrop({
        bgFile = 'interface/buttons/white8x8',
        edgeFile = 'Interface/Tooltips/UI-Tooltip-border',
		edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})
	
	bg:SetBackdropColor(.1,.1,.1,.3)
	bg:SetBackdropBorderColor(1, 1, 1)
	bg:SetPoint('TOPLEFT', panel, -10, 10)
	bg:SetPoint('BOTTOMRIGHT', panel, 30, -10)
	bg:SetFrameStrata("MEDIUM")
	--bg:SetFrameLevel(1)
	
	return panel
end

local function ConfirmReloadUI()
	ReloadWarningShown = false
	ReloadUI();
end

local function CancelReloadUI()
	ReloadWarningShown = false
end

-- Static Dialogs

StaticPopupDialogs["KUI_TargetHelper_EditBox"] = {
  text = "Enter new name for target: %s",
  button1 = "Confirm",
  button2 = "Cancel",
  OnShow = function (self, data)
    self.editBox:SetText(opt.currentEditName)
	self.editBox:SetWidth(200)
  end,
  OnAccept = function(self, data, data2)
	local text = self.editBox:GetText()
	opt:TargetEdit(text)
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
  hasEditBox = true
}

StaticPopupDialogs["KUI_TargetHelper_DeleteConfirm"] = {
  text = "Are you sure you want to reset the |cff9966ffKui Nameplates - Target Helper|r settings? This cannot be undone!",
  button1 = "Yes",
  button2 = "No",
  OnAccept = function(self, data, data2)
      opt:ConfirmDelete()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
}

StaticPopupDialogs["KUI_TargetHelper_LoadFromGlobal"] = {
  text = "Would you like to override this character's settings with the Global Settings? WARNING: This cannot be undone.",
  button1 = "Yes",
  button2 = "No",
  OnAccept = function(self, data, data2)
      opt:ConfirmGlobalLoad()
  end,
  OnCancel = function(self, data, data2)
      StaticPopup_Show("KUI_TargetHelper_SetNewGlobal")
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = false,
  preferredIndex = 3,
}

StaticPopupDialogs["KUI_TargetHelper_SetNewGlobal"] = {
  text = "Would you like to use this profile's settings for Global Settings? WARNING: This will override existing global settings.",
  button1 = "Yes",
  button2 = "No",
  OnAccept = function(self, data, data2)
      opt:ConfirmGlobalSave()
  end,
  OnCancel = function(self, data, data2)
      opt:CancelGlobal()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = false,
  preferredIndex = 3,
}

StaticPopupDialogs["KUI_TargetHelper_DeleteTargetConfirm"] = {
  text = "Are you sure you want to remove |cff9966ff%s|r? This cannot be undone!",
  button1 = "Yes",
  button2 = "No",
  OnAccept = function(self, data, data2)
      opt:ConfirmTargetDelete()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
}

StaticPopupDialogs["KUI_TargetHelper_ReloadUiConfirm"] = {
  text = "A UI reload is required to apply this value. Reload now?",
  button1 = "Yes",
  button2 = "No",
  OnAccept = function(self, data, data2)
     ConfirmReloadUI()
  end,
  OnCancel = function(self, data, data2)
     CancelReloadUI()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
}

StaticPopupDialogs["KUI_TargetHelper_DeleteFilterConfirm"] = {
  text = "Are you sure you want to remove |cff9966ff%s|r? This cannot be undone!",
  button1 = "Yes",
  button2 = "No",
  OnAccept = function(self, data, data2)
      opt:ConfirmFilterDelete()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
}

StaticPopupDialogs["KUI_TargetHelper_DeleteRenameConfirm"] = {
  text = "Are you sure you want to remove custom name for |cff9966ff%s|r? This cannot be undone!",
  button1 = "Yes",
  button2 = "No",
  OnAccept = function(self, data, data2)
      opt:ConfirmRenameDelete()
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,
}

StaticPopupDialogs["KUI_TargetHelper_ImportConfirm"] = {
	text = "Are you sure you wish to import these |cff9966ffKUI Target Helper|r custom settings?\n\nWARNING: This will overwrite your custom configuration and cannot be undone.",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function(self, data, data2)
		mod:ImportProfileData(data)
	end,
	timeout = 0,
  	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

StaticPopupDialogs["KUI_TargetHelper_ClearEnemiesConfirm"] = {
	text = "Do you want to clear all enemy colors?\n\nWARNING: This can not be undone.",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function(self, data, data2)
		mod:ClearCustomTargets(data)
	end,
	timeout = 0,
  	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}


StaticPopupDialogs["KUI_TargetHelper_MPlusConfirm"] = {
	text = "Do you want to import seasonal affix enemies from Mythic+ and Raids?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function(self, data, data2)
		mod:AddMythicPlusTargets(data)
	end,
	timeout = 0,
  	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

StaticPopupDialogs["KUI_TargetHelper_S3Confirm"] = {
	text = "Do you want to import enemies from Dragonflight Season Three?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function(self, data, data2)
		mod:AddDragonFlightTargetsSeasonThree(data)
	end,
	timeout = 0,
  	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

StaticPopupDialogs["KUI_TargetHelper_InterruptsConfirm"] = {
	text = "Do you want to import interrupts from Dragonflight Season Three?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function(self, data, data2)
		mod:AddSeasonalInterrupts()
	end,
	timeout = 0,
  	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

StaticPopupDialogs["KUI_TargetHelper_ClearInterruptsConfirm"] = {
	text = "Do you want to clear all interrupts?\n\nWARNING: This can not be undone.",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function(self, data, data2)
		mod:ClearInterrupts()
	end,
	timeout = 0,
  	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
}

StaticPopupDialogs["KUI_TargetHelper_DeleteInterruptConfirm"] = {
	text = "Are you sure you want to remove |cff9966ff%s|r? This cannot be undone!",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function(self, data, data2)
		opt:ConfirmInterruptDelete()
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3,
  }

-- Slider with Reload Required

local function slider_OnValueChangedReload(self, value)
	local strval = string.format("%.2f", value)
	
	opt.env[self:GetName()] = value
	self.label:SetText(strval)
	
	if (ReloadWarningShown == false) then
		ReloadWarningShown = true
		StaticPopup_Show("KUI_TargetHelper_ReloadUiConfirm")
	end
end
	
function opt:CreateSliderWithReload(parent, name, minval, maxval, stepvalue, width)
	local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
	slider:SetOrientation("HORIZONTAL")
	slider:SetThumbTexture([[Interface\Buttons\UI-SliderBar-Button-Vertical]])
	slider:SetMinMaxValues(minval, maxval)
	slider:SetWidth(width)
	slider:SetHeight(16)
	slider:SetValueStep(stepvalue)
	slider:SetObeyStepOnDrag(true)
	slider.title = opt.titles[name]
	
	getglobal(name .. 'Low'):SetText(tostring(minval)); --Sets the left-side slider text (default is "Low").
	getglobal(name .. 'High'):SetText(tostring(maxval)); --Sets the right-side slider text (default is "High").
	getglobal(name .. 'Text'):SetText(opt.titles[name] or name or '!MissingTitle'); --Sets the "title" text (top-centre of slider).
 
 	slider:SetValue(opt.env[name])
	slider:SetScript("OnValueChanged", slider_OnValueChangedReload)
	
	local strval = string.format("%.2f", opt.env[name])
	slider.label = parent:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	slider.label:SetText(strval)
	slider.label:SetPoint('BOTTOM', slider, 0, -10)
	return slider;
end

-- clickable icon

function opt:CreateIcon(parent, name, icon, w, h)

	local frame = CreateFrame("Button", name, parent, "BackdropTemplate")
	frame:SetSize (w, h)
	frame:SetBackdrop({
            bgFile=icon,
			edgeFile='interface/buttons/white8x8',
            edgeSize=1,
            --insets={top=2,right=2,bottom=2,left=2}
        })
	frame:SetBackdropBorderColor(1, 1, 1, 0.25)
	frame:SetBackdropColor(1, 1, 1, 1)
	frame:Show()
	
	return frame;
end