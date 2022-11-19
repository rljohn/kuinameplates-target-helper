local folder,ns = ...
local addon = KuiNameplates
local core = KuiNameplatesCore
local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod

local nameplatecvars = 
{
	["nameplateMaxDistance"] =	{
		name = "Max Distance",
		minv = 0, 
		maxv = 100,
		desc = "The maximum distance to show nameplates."
	},
	["nameplateMinAlpha"] =	{ 
		name = "Min Alpha",
		minv = 0, 
		maxv = 1,
		desc = "The minimum alpha of nameplates."
	},
	["nameplateMinAlphaDistance"] =	{ 
		name = "Min Alpha Distance",
		minv = 0, 
		maxv = 60,
		desc = "The distance from the max distance that nameplates will reach their minimum alpha."
	},
	["nameplateMaxAlpha"] =	{ 
		name = "Max Alpha",
		minv = 0, 
		maxv = 1,
		desc = "The maximum alpha of nameplates."
	},
	["nameplateMaxAlphaDistance"] =	{ 
		name = "Max Alpha Distance",
		minv = 0, 
		maxv = 60,
		desc = "The distance from the camera that nameplates will reach their maximum alpha."
	},
	["nameplateOccludedAlphaMult"] =	{ 
		name = "Occluded Alpha Multi",
		minv = 0, 
		maxv = 1,
		desc = "Alpha multiplier of nameplates for occluded targets."
	},
	["nameplateOverlapH"] =	{ 
		name = "Horizontal Overlap",
		minv = 0, 
		maxv = 3,
		step = 0.05,
		desc = "Percentage amount for horizontal overlap of nameplates"
	},
	["nameplateOverlapV"] =	{ 
		name = "Vertical Overlap",
		minv = 0, 
		maxv = 3,
		step = 0.05,
		desc = "Percentage amount for vertical overlap of nameplates"
	},
	["nameplateMotionSpeed"] =	{ 
		name = "Motion Speed",
		minv = 0, 
		maxv = 0.2,
		step = 0.005,
		desc = "Controls the rate at which nameplate animates into their target locations",
	}
}

local updatingCvars = false

local function cvar_OnValueChanged(self, value)
	
	local strval
	if (self.step < 0.01) then
		strval = string.format("%.3f", value)
	else
		strval = string.format("%.2f", value)
	end
	self.label:SetText(strval)
		
	-- prevent loopback
	if (updatingCvars) then
		return
	end
			
	if opt.env.EnableCVars then
		SetCVar(self.title, value)
	end
end

local function SliderOnDisable(self)
	self.label:SetFontObject('GameFontDisable')
	getglobal(self.id .. 'Low'):SetAlpha(.5)
	getglobal(self.id .. 'High'):SetAlpha(.5)
	getglobal(self.id .. 'Text'):SetAlpha(.5)
end

local function SliderOnEnable(self)
	self.label:SetFontObject('GameFontHighlight')
	getglobal(self.id .. 'Low'):SetAlpha(1)
	getglobal(self.id .. 'High'):SetAlpha(1)
	getglobal(self.id .. 'Text'):SetAlpha(1)
end
	
local function GetCvarElemWidth()
	if (opt.IsDragonFlight) then
		return 200
	else
		return 160
	end
end

function opt:AddCVarSlider(parent, name, x, y)
	
	local sliderName = 'thcv' .. name
	local slider = CreateFrame("Slider", sliderName, parent, "OptionsSliderTemplate")
	slider:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
	
	local minval = nameplatecvars[name].minv
	local maxval = nameplatecvars[name].maxv
	
	slider:SetOrientation("HORIZONTAL")
	slider:SetThumbTexture([[Interface\Buttons\UI-SliderBar-Button-Vertical]])
	slider:SetMinMaxValues(minval, maxval)
	slider:SetWidth(GetCvarElemWidth())
	slider:SetHeight(16)
	
	local step = 1
	if (nameplatecvars[name].step) then
		step = nameplatecvars[name].step
		slider:SetValueStep(nameplatecvars[name].step)
		slider:SetObeyStepOnDrag(false)
	elseif (maxval - minval <= 1) then
		slider:SetValueStep(0.05)
		slider:SetObeyStepOnDrag(true)
	else
		slider:SetValueStep(1)
		slider:SetObeyStepOnDrag(true)
	end
	
	slider.title = name
	slider.id = sliderName
	slider.step = step
		
	getglobal(sliderName .. 'Low'):SetText(tostring(minval)); --Sets the left-side slider text (default is "Low").
	getglobal(sliderName .. 'High'):SetText(tostring(maxval)); --Sets the right-side slider text (default is "High").
	getglobal(sliderName .. 'Text'):SetText(nameplatecvars[name].name); --Sets the "title" text (top-centre of slider).
	
	local current = GetCVar(name)
	
	slider:HookScript('OnEnable',SliderOnEnable)
    slider:HookScript('OnDisable',SliderOnDisable)
		
	if current then
		local currentValue = tonumber(current)
		
		slider:SetValue(currentValue)
		slider:SetScript("OnValueChanged", cvar_OnValueChanged)
		
		local strval 
		if (currentValue >= 0 and currentValue <= 1) then
			if (slider.step < 0.01) then
				strval = string.format("%.3f", currentValue)
			else
				strval = string.format("%.2f", currentValue)
			end
		else
			strval = tostring(currentValue)
		end
		
		slider.label = slider:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
		slider.label:SetText(strval)
		slider.label:SetPoint('BOTTOM', slider, 0, -10)
	end
	
	local tooltipDefault = '|cff9966ffDefault|r: ' .. GetCVarDefault(name)
	opt:AddTooltip2(slider, name, nameplatecvars[name].desc, tooltipDefault)
		
	return slider;
end

function opt:EnableCVars()
	if opt.ui.cvarframes == nil then
		return
	end
	for _,frame in pairs(opt.ui.cvarframes) do
        frame:Enable()
    end
end

function opt:DisableCVars()
	if opt.ui.cvarframes == nil then
		return
	end
	for _,frame in pairs(opt.ui.cvarframes) do
        frame:Disable()
    end
end

function opt:AddCVarSliders(parent)

	local basex = 16
	local basey = -24
	local x = basex
	local y = basey
	local f = nil
	local i = 0
	for k,v in pairs ( nameplatecvars ) do
		f = opt:AddCVarSlider(parent, k, x, y)
		tinsert( opt.ui.cvarframes, f );

		-- move em around
		x = x + 250
		i = i + 1
		if (i % 2 == 0) then
			x = basex
			y = y - 64
		end
	end
	
	if (opt.env.EnableCVars == false) then
		opt:DisableCVars()
	end
end

function opt:UpdateCVars()
	updatingCvars = true
	for k,v in pairs ( nameplatecvars ) do
		for _,frame in pairs(opt.ui.cvarframes) do
			if frame.title == k then
				
				local current = GetCVar(frame.title)
				
				if current then
					local currentValue = tonumber(current)
					frame:SetValue(currentValue)
				end
			end
		end
	end
	updatingCvars = false
end

function GetCvarWidth()
	if (opt.IsDragonFlight) then
		return 200
	else
		return 160
	end
end

function GetCvarHeight()
	if (opt.IsDragonFlight) then
		return 490
	else
		return 455
	end
end

function mod:AddCVarWidgets(parent)

	opt.ui.EnableCVars = opt:CreateCheckBox(parent, 'EnableCVars')
	opt.ui.EnableCVars:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -16)
	opt:AddTooltip(opt.ui.EnableCVars, opt.titles.EnableCVars, opt.titles.EnableCVarsTooltip)
	
	opt:AddCVarSliders(parent)

end