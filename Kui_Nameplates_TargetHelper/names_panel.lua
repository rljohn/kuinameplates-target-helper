local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod

local addon = KuiNameplates
local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod
local currentRemoveName

-- add/remove entry

function mod:AddRename(source, dest)
	opt.env.Renames[source] = dest
	mod:RefreshRenameTargets()
	opt:ResetFrames()
end

function mod:RemoveName(name)
	if (opt.env.Renames[name] ~= nil) then
		opt.env.Renames[name] = nil;
	end
	mod:RefreshRenameTargets();
	opt:ResetFrames()
end

function opt:ConfirmRenameDelete()
    mod:RemoveName(currentRemoveName)
end

-- hide all renames

function mod:HideRenames() 
	if opt.ui.renames == nil then
		return
	end
	
    for _,frame in pairs(opt.ui.renames) do
        frame:Hide()
        frame.highlight:Hide()
    end
end

-- create frame

function mod:CreateRenameFrame(source, dest) 

	local f
	
	for _,frame in pairs(opt.ui.renames) do
        if not frame:IsShown() then
            -- recycle an old frame
            f = frame
        end
    end
	
	local tooltipText1 = string.format("Renamed to |cffc8d975%s|r.", dest)
	if not f then
	
		f = CreateFrame('Frame', nil, opt.ui.renameScrollArea.panel );
		f:EnableMouse(true)
		f:SetSize(520, 20)
		opt:AddTooltip2(f, source, tooltipText1, opt.titles.RemoveUnitTooltip)
		
        f.highlight = f:CreateTexture('HIGHLIGHT')
        f.highlight:SetTexture('Interface/BUTTONS/UI-Listbox-Highlight')
        f.highlight:SetBlendMode('add')
        f.highlight:SetAlpha(.5)
        f.highlight:Hide()
		f.highlight:SetAllPoints(f);
		
		f.text = f:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
		f.text:SetPoint('LEFT')
		
		f:SetScript('OnMouseUp', function(self, button)
			if button == 'RightButton' then
				currentRemoveName = self.source
				StaticPopup_Show("KUI_TargetHelper_DeleteRenameConfirm", self.source)
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
	
	f.source = source;
	f.tooltipTitle = source
	f.tooltipText1 = tooltipText1
	f.text:SetText(string.format("%s |cffc8d975->|r %s", source, dest))
	tinsert( opt.ui.renames, f )
	return f
	
end

-- refresh

function mod:RefreshRenameTargets()

	mod:HideRenames()
	
	if (opt.env.Renames == nil) then
		return
	end
	
	local previousFrame = nil;
	
	for key,unit in pairs ( opt.env.Renames ) do
	
		local f = mod:CreateRenameFrame(key, unit);
		
		if (f == nil) then
			break
		end
		
		if previousFrame then
            f:SetPoint('TOPLEFT', previousFrame, 'BOTTOMLEFT', 0, -2)
        else
            f:SetPoint('TOPLEFT')
        end
		
		f:Show();
		previousFrame = f;
	end
	
end

-- rename source handlers

local function renameSourceEnterCallback(self)
    opt.ui.renameUnitBtn:Click();
end

local function renameSourceEscapeCallback()
	opt.ui.renameSourceText:ClearFocus()
end

local function renameSourceTabCallback()
	opt.ui.renameDestText:SetFocus()
end

-- rename dest handlers

local function renameDestEnterCallback(self)
    opt.ui.renameUnitBtn:Click();
end

local function renameDestEscapeCallback()
	opt.ui.renameDestText:ClearFocus()
end

local function renameDestTabCallback()
	opt.ui.renameSourceText:SetFocus()
end

-- clears

function mod:ClearRenameSourceText()
	opt.ui.renameSourceText:SetText('')
end

function mod:ClearRenameTargetText()
	opt.ui.renameDestText:SetText('')
end

local function RenameUnitBtnOnClick()
	local source = opt.ui.renameSourceText:GetText()
	local dest = opt.ui.renameDestText:GetText()
	if (not source or source == "" or not dest or dest == "") then
		rlPrintf("Cannot add unit rename with missing fields.")
		return
	end
	mod:AddRename(source, dest)
	mod:ClearRenameSourceText()
	mod:ClearRenameTargetText()
end

function mod:AddRenameWidgets(parent)

	opt.ui.renameSourceLbl = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	opt.ui.renameSourceLbl:SetText(opt.titles["UnitNamesTxtOriginal"])
	opt.ui.renameSourceLbl:SetPoint('TOPLEFT', opt.ui.renameScrollArea, 'BOTTOMLEFT', 0, -20)
	
	opt.ui.renameSourceText = opt:CreateEditBox(parent, "RenameSourceText", 150, 180, 30)
	opt.ui.renameSourceText:SetPoint('TOPLEFT', opt.ui.renameSourceLbl, "TOPRIGHT", 12, 9)
	opt.ui.renameSourceText:SetScript('OnEnterPressed', renameSourceEnterCallback)
	opt.ui.renameSourceText:SetScript('OnEscapePressed', renameSourceEscapeCallback)
	opt.ui.renameSourceText:SetScript('OnTabPressed', renameSourceTabCallback)
	
	opt.ui.renameDestLbl = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
	opt.ui.renameDestLbl:SetText(opt.titles["UnitNamesTxtNew"])
	opt.ui.renameDestLbl:SetPoint('TOPLEFT', opt.ui.renameSourceText, 'TOPRIGHT', 12, -9)
	
	opt.ui.renameDestText = opt:CreateEditBox(parent, "RenameDestText", 150, 180, 30)
	opt.ui.renameDestText:SetPoint('TOPLEFT', opt.ui.renameDestLbl, "TOPRIGHT", 12, 9)
	opt.ui.renameDestText:SetScript('OnEnterPressed', renameDestEnterCallback)
	opt.ui.renameDestText:SetScript('OnEscapePressed', renameDestEscapeCallback)
	opt.ui.renameDestText:SetScript('OnTabPressed', renameDestTabCallback)
	
	opt.ui.renameUnitBtn = opt:CreateButton(parent, 'RenameBtn', 100, 30, opt.titles.UnitNamesBtn)
	opt.ui.renameUnitBtn:SetPoint("TOPLEFT", opt.ui.renameDestText, "TOPRIGHT", 6, 0)
	opt.ui.renameUnitBtn:SetScript("OnClick", RenameUnitBtnOnClick)
	
end