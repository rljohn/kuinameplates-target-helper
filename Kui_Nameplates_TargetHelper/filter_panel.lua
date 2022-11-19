local addon = KuiNameplates
local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod
local currentRemoveName

function mod:HideFilters()

	if opt.ui.filters == nil then
		return
	end
	
    for _,frame in pairs(opt.ui.filters) do
        frame:Hide()
        frame.highlight:Hide()
    end
end

local function FilterTargetOnClick(self)
		
	if self:GetChecked() then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) 
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end
	
	opt.env.FilterTargets[self.id].active = self:GetChecked()
	opt:EvaluateFilter()
end

function mod:CreateFilterFrame(name, unit)

	local f
	
	for _,frame in pairs(opt.ui.filters) do
        if not frame:IsShown() then
            -- recycle an old frame
            f = frame
        end
    end
	
	if not f then
		f = CreateFrame('Frame', nil, opt.ui.filterScrollArea.panel );
		f:EnableMouse(true)
		f:SetSize(520, 20)
		opt:AddTooltip(f, name, opt.titles.RemoveUnitTooltip)
		
        f.highlight = f:CreateTexture('HIGHLIGHT')
        f.highlight:SetTexture('Interface/BUTTONS/UI-Listbox-Highlight')
        f.highlight:SetBlendMode('add')
        f.highlight:SetAlpha(.5)
        f.highlight:Hide()
		f.highlight:SetAllPoints(f);
		
		f.check = CreateFrame('CheckButton', name, f, 'OptionsBaseCheckButtonTemplate')
		f.check:SetPoint('LEFT')
		f.check:SetScript('OnClick',FilterTargetOnClick)
		f.check.main = f
		
		f.label = f.check:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
		f.label:SetPoint('LEFT', f.check, 'RIGHT', 4, 0)
		
		-- setup scripts for the checkbox
		f.check:SetScript('OnEnter', function(self)
			self.main.highlight:Show()
			opt:OnTooltipEnter(self.main)
		end)
        f.check:SetScript('OnLeave', function(self)
			self.main.highlight:Hide()
			opt:OnTooltipLeave(self.main)
		end)
		f.check:SetScript('OnMouseUp', function(self, button)
			if button == 'RightButton' then
				currentRemoveName = self.id
				StaticPopup_Show("KUI_TargetHelper_DeleteFilterConfirm", self.id)
			end
		end)
		
		-- setup scripts for the main frame
		f:SetScript('OnMouseUp', function(self, button)
			if button == 'RightButton' then
				currentRemoveName = self.check.id
				StaticPopup_Show("KUI_TargetHelper_DeleteFilterConfirm", self.check.id)
			end
		end)		
		f:SetScript('OnEnter', function(self)
			self.highlight:Show()
			opt:OnTooltipEnter(self)
		end)
        f:SetScript('OnLeave', function(self)
			self.highlight:Hide()
			opt:OnTooltipLeave(self)
		end)
	end
	
	f.check.id = name;
	f.label:SetText(name)
	f.check:SetChecked(unit.active)
	tinsert( opt.ui.filters, f )
	return f

end

function mod:RefreshFilterTargets()

	mod:HideFilters()
	
	if (opt.env.FilterTargets == nil) then
		return
	end
	
	local previousFrame = nil;
	
	for key,unit in pairs ( opt.env.FilterTargets ) do
	
		local f = mod:CreateFilterFrame(key, unit);
		
		if previousFrame then
            f:SetPoint('TOPLEFT', previousFrame, 'BOTTOMLEFT', 0, -2)
        else
            f:SetPoint('TOPLEFT')
        end
		
		f:Show();
		previousFrame = f;
	end
	
end

local function FilterTarget(name)
	opt.env.FilterTargets[name] = {}
	opt.env.FilterTargets[name].active = true
	mod:RefreshFilterTargets();
	opt:EvaluateFilter()
end

local function RemoveFilter(name)
	if (opt.env.FilterTargets[name] ~= nil) then
		opt.env.FilterTargets[name] = nil;
	end
	mod:RefreshFilterTargets()
	opt:EvaluateFilter()
end

function opt:ConfirmFilterDelete()
    RemoveFilter(currentRemoveName)
end

local function filterTargetEnterCallback(self)
    opt.ui.filterTargetBtn:Click();
	opt.ui.namefilterText:ClearFocus()
end

local function filterTargetEscapeCallback()
	opt.ui.namefilterText:ClearFocus()
end

local function ClearFilterBoxUnitName()
	opt.ui.namefilterText:SetText('')
	opt.ui.namefilterText:ClearFocus()
end

local function addFilterTargetBtnOnClick()
	FilterTarget(opt.ui.namefilterText:GetText())
	ClearFilterBoxUnitName()
end


function mod:AddNameFilterWidgets(parent)

	opt.ui.namefilterText = opt:CreateEditBox(parent, "NameFilterText", 150, 200, 30)
	opt.ui.namefilterText:SetPoint('TOPLEFT', opt.ui.filterScrollArea, "BOTTOMLEFT", 0, -12)
	opt.ui.namefilterText:SetScript('OnEnterPressed', filterTargetEnterCallback)
	opt.ui.namefilterText:SetScript('OnEscapePressed', filterTargetEscapeCallback)
	opt:AddTooltip(opt.ui.namefilterText, opt.titles.UnitFilterTitle, opt.titles.UnitFilterTooltip)
	
	opt.ui.filterTargetBtn = opt:CreateButton(parent, 'FilterTarget', 100, 30, opt.titles.UnitFilterBtn)
	opt.ui.filterTargetBtn:SetPoint("TOPLEFT", opt.ui.namefilterText, "TOPRIGHT", 4, 0)
	opt.ui.filterTargetBtn:SetScript("OnClick", addFilterTargetBtnOnClick)
	opt:AddTooltip(opt.ui.filterTargetBtn, opt.titles.UnitFilterTitle, opt.titles.UnitFilterTooltip)

end