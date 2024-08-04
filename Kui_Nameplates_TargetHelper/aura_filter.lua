local addon = KuiNameplates
local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod
local KSL = LibStub('KuiSpellList-2.0')
local currentRemoveSpellId

function mod:HideAuraFilters()

    if opt.ui.aurafilters == nil then
		return
	end
	
    for _,frame in pairs(opt.ui.aurafilters) do
        if (frame) then
            frame:Hide()
        end

        if frame.highlight then
            frame.highlight:Hide()
        end
    end
end

local function ToggleCheck(check)
    check:SetChecked(not check:GetChecked())
end

local function UpdateSpellList(spell_id)
    aura = opt.env.FilterAuras[spell_id]
    if (KSL and aura) then
        if (aura.deny) then
            KSL:RemoveSpell(spell_id, true, false)
            KSL:AddSpell(spell_id, false, false)
        elseif (aura.active) then
            KSL:AddSpell(spell_id, true, false)
            KSL:RemoveSpell(spell_id, false, false)
        end
    end
end

local function ShowAuraOnClick(self)
		
	if self:GetChecked() then
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) 
	else
		PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	end
	
    ToggleCheck(self.main.deny)
	opt.env.FilterAuras[self.spell_id].active = self.main.check:GetChecked()
    opt.env.FilterAuras[self.spell_id].deny = self.main.deny:GetChecked()
    UpdateSpellList(self.spell_id)
    
end

local function DenyAuraOnClick(self)

    if self:GetChecked() then
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON) 
    else
        PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
    end

    ToggleCheck(self.main.check)
	opt.env.FilterAuras[self.spell_id].active = self.main.check:GetChecked()
    opt.env.FilterAuras[self.spell_id].deny = self.main.deny:GetChecked()
    UpdateSpellList(self.spell_id)

end

function mod:CreateAuraFilter(key,aura)

    local f
	
	for _,frame in pairs(opt.ui.aurafilters) do
        if not frame:IsShown() then
            -- recycle an old frame
            f = frame
        end
    end
	
	if not f then

		f = CreateFrame('Frame', nil, opt.ui.auraFilterScrollArea.panel );
		f:EnableMouse(true)
		f:SetSize(520, 40)
		opt:AddTooltip(f, aura.spell_name, opt.titles.RemoveAuraFilterTooltip)
		
        f.highlight = f:CreateTexture('HIGHLIGHT')
        f.highlight:SetTexture('Interface/BUTTONS/UI-Listbox-Highlight')
        f.highlight:SetBlendMode('add')
        f.highlight:SetAlpha(.5)
        f.highlight:Hide()
		f.highlight:SetAllPoints(f);

        f.icon = f:CreateTexture('ARTWORK')
        f.icon:SetPoint('LEFT')
        f.icon:SetSize(32, 32)
		
		f.label = f:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
		f.label:SetPoint('LEFT', f.icon, 'RIGHT', 4, 0)
        		
		f.check = CreateFrame('CheckButton', nil, f, 'OptionsBaseCheckButtonTemplate')
		f.check:SetPoint('LEFT', f.icon, 'RIGHT', 200, 0)
		f.check:SetScript('OnClick',ShowAuraOnClick)
		f.check.main = f
        f.check.spell_id = key

        f.check.label = f.check:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
		f.check.label:SetPoint('LEFT', f.check, 'RIGHT', 4, 0)
        f.check.label:SetText('Show')

        f.deny = CreateFrame('CheckButton', nil, f, 'OptionsBaseCheckButtonTemplate')
		f.deny:SetPoint('LEFT', f.check.label, 'RIGHT', 16, 0)
		f.deny:SetScript('OnClick', DenyAuraOnClick)
		f.deny.main = f
        f.deny.spell_id = key

        f.deny.label = f.check:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
		f.deny.label:SetPoint('LEFT', f.deny, 'RIGHT', 4, 0)
        f.deny.label:SetText('Hide')
		
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
				currentRemoveSpellId = self.spell_id
				StaticPopup_Show("KUI_TargetHelper_DeleteAuraFilterConfirm", self.main.label:GetText())
			end
		end)

        -- setup scripts for the deny checkbox
        f.deny:SetScript('OnEnter', function(self)
			self.main.highlight:Show()
			opt:OnTooltipEnter(self.main)
		end)
        f.deny:SetScript('OnLeave', function(self)
			self.main.highlight:Hide()
			opt:OnTooltipLeave(self.main)
		end)
		f.deny:SetScript('OnMouseUp', function(self, button)
			if button == 'RightButton' then
				currentRemoveSpellId = self.spell_id
				StaticPopup_Show("KUI_TargetHelper_DeleteAuraFilterConfirm", self.main.label:GetText())
			end
		end)
		
		-- setup scripts for the main frame
		f:SetScript('OnMouseUp', function(self, button)
			if button == 'RightButton' then
				currentRemoveSpellId = self.check.spell_id
				StaticPopup_Show("KUI_TargetHelper_DeleteAuraFilterConfirm", self.label:GetText())
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

    local spell_icon = key and C_Spell.GetSpellTexture(key)
    if spell_icon then
        f.icon:SetTexture(spell_icon)
    end

	f.check.spell_id = key;
    f.deny.spell_id = key;
	f.label:SetText(aura.spell_name)
	f.check:SetChecked(aura.active)
    f.deny:SetChecked(aura.deny)
	tinsert( opt.ui.aurafilters, f )

    if (KSL) then
        if (aura.deny) then
            KSL:AddSpell(key, false, false)
        elseif (aura.active) then
            KSL:AddSpell(key, true, false)
        end
    end

	return f
end

function mod:RefreshAuraFilter()
    if (KuiSpellListConfig) then return end

    mod:HideAuraFilters()

    if (KSL) then
        KSL:Clear()
    end

    if (opt.env.FilterAuras == nil) then
		return
	end

    local previousFrame = nil;
	
	for key,aura in pairs ( opt.env.FilterAuras ) do
        
		local f = mod:CreateAuraFilter(key, aura);
		
		if previousFrame then
            f:SetPoint('TOPLEFT', previousFrame, 'BOTTOMLEFT', 0, -2)
        else
            f:SetPoint('TOPLEFT')
        end
		
		f:Show();
		previousFrame = f;
	end
    
end

local function FilterAura(id_or_name)

    local spell_name = nil
    local spell_id = tonumber(id_or_name)

    if not spell_id then
        spell_id = select(7,GetSpellInfo(id_or_name))
        if not spell_id then
            print('Unknown spell: ' .. id_or_name)
        end
    end

    spell_name = C_Spell.GetSpellInfo(spell_id)
    if not spell_name then return end

	opt.env.FilterAuras[spell_id] = {}
    opt.env.FilterAuras[spell_id].spell_name = spell_name
	opt.env.FilterAuras[spell_id].active = true
    opt.env.FilterAuras[spell_id].deny = false
    
	mod:RefreshAuraFilter();
end

local function RemoveFilter(spell_id)

    local aura = opt.env.FilterAuras[spell_id]
    if (aura) then
        if (KSL) then
            KSL:RemoveSpell(spell_id, true, false)
            KSL:RemoveSpell(spell_id, false, false)
        end
    end

	if (opt.env.FilterAuras[spell_id] ~= nil) then
		opt.env.FilterAuras[spell_id] = nil;
	end

	mod:RefreshAuraFilter()
end

function opt:ConfirmAuraFilterDelete()
    RemoveFilter(currentRemoveSpellId)
end

local function filterAuraEnterCallback(self)
    opt.ui.filterAuraBtn:Click();
	opt.ui.aurafilterText:ClearFocus()
end

local function filterAuraEscapeCallback()
	opt.ui.aurafilterText:ClearFocus()
end

local function ClearFilterBoxAuraName()
	opt.ui.aurafilterText:SetText('')
	opt.ui.aurafilterText:ClearFocus()
end

local function addFilterAuraBtnOnClick()
	FilterAura(opt.ui.aurafilterText:GetText())
	ClearFilterBoxAuraName()
end

function mod:AddAuraFilterWidgets(parent)
    if not KSL then return print(' no KSL ' ) end

    opt.ui.aurafilterText = opt:CreateEditBox(parent, "AuraFilterText", 150, 200, 30)
	opt.ui.aurafilterText:SetPoint('TOPLEFT', opt.ui.auraFilterScrollArea, "BOTTOMLEFT", 0, -12)
	opt.ui.aurafilterText:SetScript('OnEnterPressed', filterAuraEnterCallback)
	opt.ui.aurafilterText:SetScript('OnEscapePressed', filterAuraEscapeCallback)
	opt:AddTooltip(opt.ui.aurafilterText, opt.titles.AuraFilterTitle, opt.titles.AuraFilterTooltip)
	
	opt.ui.filterAuraBtn = opt:CreateButton(parent, 'FilterTarget', 100, 30, opt.titles.AuraFilterBtn)
	opt.ui.filterAuraBtn:SetPoint("TOPLEFT", opt.ui.aurafilterText, "TOPRIGHT", 4, 0)
	opt.ui.filterAuraBtn:SetScript("OnClick", addFilterAuraBtnOnClick)
	opt:AddTooltip(opt.ui.filterAuraBtn, opt.titles.AuraFilterTitle, opt.titles.AuraFilterTooltip)

end