local folder,ns = ...
local addon = KuiNameplates
local core = KuiNameplatesCore
local opt = KuiConfigTargetHelper

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
		desc = "The distance from the camera that nameplates wil lreach their maximum alpha."
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
		maxv = 1,
		step = 0.01,
		desc = "Controls the rate at which nameplate animates into their target locations",
	}
}

local updatingCvars = false

function cvar_OnValueChanged(self, value)
	
	local strval = string.format("%.2f", value)
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
	
function AddCVarSlider(name, last)
	
	local sliderName = 'thcv' .. name
	local slider = CreateFrame("Slider", sliderName, opt.ui.cvarpanel.panel, "OptionsSliderTemplate")
	
	if last then
		slider:SetPoint("TOPLEFT", last, "BOTTOMLEFT", 0, -36)
	else
		slider:SetPoint("TOPLEFT", opt.ui.cvarpanel.panel, "TOPLEFT", 5, -14)
	end
	
	local minval = nameplatecvars[name].minv
	local maxval = nameplatecvars[name].maxv
	
	slider:SetOrientation("HORIZONTAL")
	slider:SetThumbTexture([[Interface\Buttons\UI-SliderBar-Button-Vertical]])
	slider:SetMinMaxValues(minval, maxval)
	slider:SetWidth(170)
	slider:SetHeight(16)
	
	if (nameplatecvars[name].step) then
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
		
	getglobal(sliderName .. 'Low'):SetText(tostring(minval)); --Sets the left-side slider text (default is "Low").
	getglobal(sliderName .. 'High'):SetText(tostring(maxval)); --Sets the right-side slider text (default is "High").
	getglobal(sliderName .. 'Text'):SetText(nameplatecvars[name].name); --Sets the "title" text (top-centre of slider).
	
	local current = GetCVar(name)
	
	slider:HookScript('OnEnable',SliderOnEnable)
    slider:HookScript('OnDisable',SliderOnDisable)
		
	if current then
		currentValue = tonumber(current)
		
		slider:SetValue(currentValue)
		slider:SetScript("OnValueChanged", cvar_OnValueChanged)
		
		local strval 
		if (currentValue >= 0 and currentValue <= 1) then
			strval = string.format("%.2f", currentValue)
		else
			strval = tostring(currentValue)
		end
		
		slider.label = slider:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
		slider.label:SetText(strval)
		slider.label:SetPoint('BOTTOM', slider, 0, -10)
	end
	
	local tooltipDefault = '|cff9966ffDefault|r: ' .. GetCVarDefault(name)
	AddTooltip2(slider, name, nameplatecvars[name].desc, tooltipDefault)
		
	return slider;
end

function EnableCVars()
	if opt.ui.cvarframes == nil then
		return
	end
	for _,frame in pairs(opt.ui.cvarframes) do
        frame:Enable()
    end
end

function DisableCVars()
	if opt.ui.cvarframes == nil then
		return
	end
	for _,frame in pairs(opt.ui.cvarframes) do
        frame:Disable()
    end
end

function AddCVarSliders(parent)
	local f = nil
	for k,v in pairsByKeys ( nameplatecvars ) do
		f = AddCVarSlider(k,f)
		tinsert( opt.ui.cvarframes, f );
	end
	
	if (opt.env.EnableCVars == false) then
		DisableCVars()
	end
end

function UpdateCVars()
	updatingCvars = true
	for k,v in pairsByKeys ( nameplatecvars ) do
		for _,frame in pairs(opt.ui.cvarframes) do
			if frame.title == k then
				
				local current = GetCVar(frame.title)
				
				if current then
					currentValue = tonumber(current)
					frame:SetValue(currentValue)
				end
			end
		end
	end
	updatingCvars = false
end
