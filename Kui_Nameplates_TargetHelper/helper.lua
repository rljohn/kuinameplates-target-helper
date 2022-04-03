local folder,ns = ...
local addon = KuiNameplates
local core = KuiNameplatesCore
local opt = KuiConfigTargetHelper
local ReloadWarningShown = false

-- LOGGING
function rlPrintf(...)
 local status, res = pcall(format, ...)
 if status then
    if DLAPI then DLAPI.DebugLog("KUI TargetHelper", res) end
  end
end

-- HELPER FUNCTIONS
function ResetFrames()
	for i, f in addon:Frames() do
		if f:IsShown() then
			local unit = f.unit
			f.handler:OnHide()
			f.handler:OnUnitAdded(unit)
		end
	end
end

function IsInTable(t, val)
	for i, v in pairs(t) do
		if v == val then return true end
	end
	return false
end

function pairsByKeys (t, f)
  local a = {}
  for n in pairs(t) do table.insert(a, n) end
  table.sort(a, f)
  local i = 0      -- iterator variable
  local iter = function ()   -- iterator function
	i = i + 1
	if a[i] == nil then return nil
	else return a[i], t[a[i]]
	end
  end
  return iter
end

-- Tooltips

function OnTooltipEnter(self)
	
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

function OnTooltipLeave(self)
	if not self.tooltipText then
		return
	end
	
    GameTooltip:Hide()
end

function AddTooltip2(frame, title, text, text2)
	frame.tooltipTitle = title
	frame.tooltipText = text
	frame.tooltipText2 = text2
	frame:SetScript('OnEnter',OnTooltipEnter)
    frame:SetScript('OnLeave',OnTooltipLeave)
end

function AddTooltip(frame, title, text)
	AddTooltip2(frame, title, text, nil)
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
			EnableCVars()
		else
			DisableCVars()
		end
	end
	
	if (self:GetName() == "EnableGlobalData") then
		if self:GetChecked() then
			ReloadGlobalData()
		end
	end
	
	ResetFrames()
end

function CreateCheckBox(parent, name)
	local check = CreateFrame('CheckButton', name, parent, 'OptionsBaseCheckButtonTemplate')
	check:SetScript('OnClick',CheckBoxOnClick)
	check:Raise()
	
	check.label = parent:CreateFontString(nil, 'OVERLAY', 'GameFontWhite', 7)
	check.label:SetText(opt.titles[name] or name or '!MissingTitle')
	check.label:SetPoint('LEFT', check, 'RIGHT')
	
	check:SetChecked(opt.env[name])

	return check
end

-- Sliders

local function slider_OnValueChanged(self, value)
	local strval = string.format("%.2f", value)
	
	opt.env[self:GetName()] = value
	self.label:SetText(strval)
end
	
function CreateSlider(parent, name, minval, maxval, stepvalue, width)
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
	slider:SetScript("OnValueChanged", slider_OnValueChanged)
	
	local strval = string.format("%.2f", opt.env[name])
	slider.label = parent:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	slider.label:SetText(strval)
	slider.label:SetPoint('BOTTOM', slider, 0, -10)
	return slider;
end



-- Color Picker

local r,g,b,a = 1, 0, 0, 1;
local colorPicker
local colorEdit

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

function ShowColorPicker(r, g, b, a, changedCallback)
 ColorPickerFrame:SetColorRGB(r,g,b);
 ColorPickerFrame.hasOpacity, ColorPickerFrame.opacity = (a ~= nil), a;
 ColorPickerFrame.previousValues = {r,g,b,a};
 ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, changedCallback;
 ColorPickerFrame:Hide(); -- Need to run the OnShow handler.
 ColorPickerFrame:Show();
end

function ColorPickerOnClick(self)
	colorPicker = self;
	colorEdit = nil
	
	r = opt.env[colorPicker:GetName()].r
	g = opt.env[colorPicker:GetName()].g
	b = opt.env[colorPicker:GetName()].b
	a = opt.env[colorPicker:GetName()].a
	
	ShowColorPicker(r, g, b, 1.0 - a, myColorCallback)
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
		
		if colorEdit:GetParent() and opt.env.CustomTargets[colorEdit:GetParent().id] then
			opt.env.CustomTargets[colorEdit:GetParent().id].r = r
			opt.env.CustomTargets[colorEdit:GetParent().id].g = g
			opt.env.CustomTargets[colorEdit:GetParent().id].b = b
			opt.env.CustomTargets[colorEdit:GetParent().id].a = a
			colorEdit:GetParent().name:SetTextColor(r, g, b)
		end
	end
	
	opt.ShouldResetFrames = true
end

function CustomTargetColorOnClick(self)
	colorPicker = nil
	colorEdit = self
	
	local clr = opt.env.CustomTargets[self:GetParent().id]
	ShowColorPicker(clr.r, clr.g, clr.b, 1.0 - clr.a, editColorCallback)
end

-- Textures

function CreateColorTexture(parent, name, w, h, red, green, blue, alpha)

	local frame = CreateFrame("Button", name, parent, "BackdropTemplate")
	frame:SetSize (w, h)
	frame:SetScript("OnClick", ColorPickerOnClick)
	
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

function CreateScrollArea(parent, name, width, height)
	
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

function CreateButton(parent, name, width, height, text)
	local button = CreateFrame("Button", name, parent, "UIPanelButtonTemplate")
	button:SetWidth(width)
	button:SetHeight(height)
	button:SetText(text)
	return button
end

-- Edit Box

function CreateEditBox(parent, name, maxLetters, width, height)
	local box = CreateFrame("EditBox", name, parent, "InputBoxTemplate")
	box:SetAutoFocus(false)
	box:EnableMouse(true)
	box:SetMaxLetters(maxLetters)
	box:SetSize(width, height)
	return box
end

-- Panel

function CreatePanel(parent, name, width, height)
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
	
	return panel
end

function ConfirmReloadUI()
	ReloadWarningShown = false
	ReloadUI();
end

function CancelReloadUI()
	ReloadWarningShown = false
end

-- Static Dialogs

StaticPopupDialogs["KUI_TargetHelper_EditBox"] = {
  text = "Enter new name for target: %s",
  button1 = "Confirm",
  button2 = "Cancel",
  OnAccept = function(self, data, data2)
	local text = self.editBox:GetText()
	TargetEdit(text)
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
      ConfirmDelete()
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
      ConfirmGlobalLoad()
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
      ConfirmGlobalSave()
  end,
  OnCancel = function(self, data, data2)
      CancelGlobal()
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
      ConfirmTargetDelete()
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
	
function CreateSliderWithReload(parent, name, minval, maxval, stepvalue, width)
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
	slider.label = parent:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
	slider.label:SetText(strval)
	slider.label:SetPoint('BOTTOM', slider, 0, -10)
	return slider;
end