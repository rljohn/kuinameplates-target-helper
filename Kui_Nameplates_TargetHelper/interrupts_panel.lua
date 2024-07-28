local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod

opt.currentInterruptId = ''
local currentRemoveSpell = nil
local lastFrame = nil
local pending_spell_ids = {}

local function onEnterCallback(self)
    opt.ui.interrupt_button:Click();
end

local function onEscapeCallback()
	opt.ui.interrupt_text:ClearFocus()
end

local function onClickCallback()
	local text = opt.ui.interrupt_text:GetText()
	if (not text or text == "") then return end
	
	-- check if the text was a number
	local number = tonumber(text)
    if not number then 
        rlPrintf("Invalid Spell ID")
        return
    end

	mod:AddInterrupt(number, opt.env.NewInterruptColor, nil, nil)
end

local function setInterruptId(id)
	opt.ui.interrupt_text:SetText(id)
	opt.ui.interrupt_text:SetCursorPosition(0)
	opt.ui.interrupt_text:ClearFocus()
end

local function setInterruptColor(color)
	if not color then return end
	opt.env.NewInterruptColor = color
	local tmp = opt.env.NewInterruptColor
	opt.ui.interrupt_color:SetBackdropColor(tmp.r, tmp.g, tmp.b, tmp.a)
end

function mod:InterruptsWidgets(parent)

    local season1 = opt:CreateIcon(parent, nil, 4734167, 32, 32)
	season1:SetPoint('BOTTOMRIGHT', opt.ui.interruptsArea, 'TOPRIGHT', 28, 16)
	season1:SetScript('OnClick', function(self)
		local dialog = StaticPopup_Show("KUI_TargetHelper_InterruptsConfirm")
	end)
	opt:AddTooltip(season1, opt.titles.SeasonTooltip, opt.titles.SeasonTooltipInterruptsText)

    local clear = opt:CreateIcon(parent, nil, 4200126, 32, 32)
	clear:SetPoint('TOPRIGHT', season1, 'TOPLEFT', -8, 0)
	clear:SetScript('OnClick', function(self)
		local dialog = StaticPopup_Show("KUI_TargetHelper_ClearInterruptsConfirm")
	end)
	opt:AddTooltip(clear, opt.titles.ClearInterrupts, opt.titles.ClearInterruptsTooltip)

    -- add/update interrupts

    local add_panel = opt:CreatePanel(parent, nil, 320 , 80)
	add_panel:SetPoint('TOPLEFT', opt.ui.interruptsArea, 'BOTTOMLEFT', 0, -55)

    local add_title = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	add_title:SetText(opt.titles.AddInterrupt)
	add_title:SetPoint('TOPLEFT', add_panel, 'TOPLEFT', 2, 32)

    opt.ui.interrupt_color = opt:CreateColorTexture(add_panel, 'NewInterruptColor', 32, 32, opt.env.NewInterruptColor.r, opt.env.NewInterruptColor.g, opt.env.NewInterruptColor.b, opt.env.NewInterruptColor.a)
	opt.ui.interrupt_color:SetPoint("TOPLEFT", add_panel, "TOPLEFT", 6, -8)
	opt:AddTooltip(opt.ui.interrupt_color, opt.titles.CustomColorTooltipTitle, opt.titles.CustomColorInterruptTooltipText)

    opt.ui.interrupt_text = opt:CreateEditBox(add_panel, "AddInterruptText", 150, 180, 30)
	opt.ui.interrupt_text:SetPoint('TOPLEFT', opt.ui.interrupt_color, "TOPRIGHT", 22, 0)
	opt.ui.interrupt_text:SetScript('OnEnterPressed', onEnterCallback)
	opt.ui.interrupt_text:SetScript('OnEscapePressed', onEscapeCallback)
	opt:AddTooltip(opt.ui.interrupt_text, opt.titles.AddInterruptTooltipTitle, opt.titles.AddInterruptTooltipText)
	
	opt.ui.interrupt_button = opt:CreateButton(add_panel, 'AddInterrupt', 80, 30, opt.titles.AddInterruptBtn)
	opt.ui.interrupt_button:SetPoint("TOPLEFT", opt.ui.interrupt_text, "TOPRIGHT", 8, 0)
	opt.ui.interrupt_button:SetScript("OnClick", function(self, event, ...)
			onClickCallback()
		end)
	opt:AddTooltip(opt.ui.interrupt_button, opt.titles.AddInterrupt, opt.titles.AddInterruptBtnTooltip)

    -- saved colors

    local side_panel = opt:CreatePanel(parent, nil, 200 , 78)
	side_panel:SetPoint('TOPLEFT', add_panel, 'TOPRIGHT', 64, 0)

	local side_title = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	side_title:SetText(opt.titles.SavedColors)
	side_title:SetPoint('TOPLEFT', side_panel, 'TOPLEFT', 2, 32)

    mod:AddInterruptsSavedColors(side_panel)

	-- show enemy cast target:

	opt.ui.ShowCastTarget = opt:CreateCheckBox(parent, 'ShowCastTarget')
	opt.ui.ShowCastTarget:SetPoint("TOPLEFT", add_panel, "BOTTOMLEFT", 0, -12)
	opt:AddTooltip(opt.ui.ShowCastTarget, opt.titles.ShowCastTarget, opt.titles.ShowCastTargetTooltip)

end

function mod:AddInterrupt(spellId, color, context, context_color)
	
	local existing = opt.env.CustomInterrupts[spellId]

	local entry = {}
	entry.r = color.r
	entry.g = color.g
	entry.b = color.b
	entry.a = color.a

	if (context) then
		entry.context = context
	elseif (existing) then
		entry.context = existing.context
	else
		entry.context = nil
	end

	if (context_color) then
		entry.context_color = context_color
	elseif (existing) then
		entry.context_color = context_color
	else
		entry.context_color = nil
	end

	opt.env.CustomInterrupts[spellId] = entry
	table.insert(pending_spell_ids, spellId)
	opt.PendingInterrupts = true
end

function mod:CreateInterruptFrame(spellId, color)

	local f = nil
		
	-- look for a previously removed frame to use
	if opt.ui.interrupt_frames then
		for _,frame in pairs(opt.ui.interrupt_frames) do
			if not frame.active then
				f = frame
				break
			end
		end
	end
		
	if not f then
		f = CreateFrame('Frame', nil, opt.ui.interruptsArea.panel );
		tinsert( opt.ui.interrupt_frames, f );

		f:EnableMouse(true)
		f:SetSize(520, 20)
		
        f.highlight = f:CreateTexture('HIGHLIGHT')
        f.highlight:SetTexture('Interface/BUTTONS/UI-Listbox-Highlight')
        f.highlight:SetBlendMode('add')
        f.highlight:SetAlpha(.5)
        f.highlight:Hide()
		f.highlight:SetAllPoints(f);
		
		f.icon = CreateFrame("Button", nil, f, "BackdropTemplate");
		f.icon:SetSize(30,16);
		f.icon:SetPoint('LEFT');
		f.icon:SetScript("OnClick", function(self, event, ...)
			opt:CustomInterruptsOnClick(self)
		end)
		f.icon:SetBackdrop({
            bgFile='interface/buttons/white8x8',
            edgeFile='interface/buttons/white8x8',
            edgeSize=1,
            insets={top=2,right=2,bottom=2,left=2}
        })
		opt:AddTooltip(f.icon, opt.titles.CustomColorTooltipTitle, opt.titles.CustomColorTooltipText)
		
		f.name = f:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		f.name:SetSize(520, 18)
        f.name:SetPoint('LEFT', f.icon, 'RIGHT', 10, 0)
        f.name:SetJustifyH('LEFT')
				
		f:SetScript('OnMouseUp', function(self, button)
			if button == 'LeftButton' then
				setInterruptId(self.id)
			elseif button == 'RightButton' then
				currentRemoveSpell = self.id
				StaticPopup_Show("KUI_TargetHelper_DeleteInterruptConfirm", self.id)
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
	
	local spell_name = GetSpellInfo(spellId)
	local text = string.format("%d (%s)", spellId, spell_name)

	f.id = spellId;
	f.name:SetText(text);
	f.name:SetTextColor(color.r, color.g, color.b)
	f.icon:SetBackdropBorderColor(.5,.5,.5)
	f.icon:SetBackdropColor (color.r, color.g, color.b, 1)
	f.active = true
	return f;
	
end

function mod:ClearInterrupts()
	opt.env.CustomInterrupts = {}
	self:RefreshInterrupts()
end

function mod:HideInterruptEntry(f)
	f:Hide()
	f.highlight:Hide()
	f.active = false
	f.next_frame = nil
	f.previous_frame = nil
end

function mod:HideInterruptList()

	lastFrame = nil

	if opt.ui.interrupt_frames == nil then
		return
	end
	
    for _,frame in pairs(opt.ui.interrupt_frames) do
		self:HideInterruptEntry(frame)
    end
end

local function HasPendingInterrupts()
	if next(pending_spell_ids) == nil then
		return false
	else
		return true
	end
end

function mod:RefreshInterrupts()

	self:HideInterruptList()

	if opt.env.CustomInterrupts == nil then return end
	pending_spell_ids = {}

	for spellId,_ in pairs ( opt.env.CustomInterrupts ) do
		table.insert(pending_spell_ids, spellId)
	end

	opt.PendingInterrupts = HasPendingInterrupts()
end

function mod:InterruptPanelUpdate()

	local count = #pending_spell_ids
	local iter = math.min(count, 8)

	for i = 1, iter do

		local spellId = pending_spell_ids[1]
		local interrupt = opt.env.CustomInterrupts[spellId]

		if interrupt then

			local f = nil
			
			-- iterate through all frames. find and update existing frame
			if opt.ui.interrupt_frames then
				for _,frame in pairs(opt.ui.interrupt_frames) do
					if (frame.active) then
						if (frame.id == spellId) then
							frame.name:SetTextColor(interrupt.r, interrupt.g, interrupt.b)
							frame.icon:SetBackdropBorderColor(.5,.5,.5)
							frame.icon:SetBackdropColor(interrupt.r, interrupt.g, interrupt.b, 1)
							f = frame
							break
						end
					end
				end
			end

			if not f then

				f = self:CreateInterruptFrame(spellId, interrupt)

				if f then
					if lastFrame and f ~= lastFrame then
						f:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -2)
						f.previous_frame = lastFrame
						lastFrame.next_frame = f
					else
						f:SetPoint('TOPLEFT', opt.ui.interruptsArea.panel, 'TOPLEFT')
						f.previous_frame = nil
						f.next_frame = nil
					end
	
					mod:UpdateInterruptTooltip(f, interrupt.context, interrupt.context_color)
					lastFrame = f
					f:Show()
				end
			end
		end

		table.remove(pending_spell_ids, 1)
	end

	opt.PendingInterrupts = HasPendingInterrupts()
end

function mod:AddSeasonalInterrupts()
	mod:AddWarWithinCastsSeasonOne()
end

function opt:ConfirmInterruptDelete()
    mod:RemoveInterrupt(currentRemoveSpell)
end

function mod:UpdateInterruptTooltip(f, context, context_color)

	local name = f.name:GetText()
	local displayName
	if (context and context_color) then
		displayName = name .. ' |c' .. context_color .. '[' .. context .. ']|r'
	elseif (context) then
		displayName = name .. ' |cff40c0f7[' .. context .. ']|r'
	else
		displayName = name .. ' |cffc8d975[' .. opt.titles.ContextCustom .. ']|r'
	end

	if (f.tooltipTitle) then
		f.tooltipTitle = displayName
	else
		opt:AddTooltip(f, displayName, opt.titles.RemoveInterruptTooltip)
	end
end

function mod:RemoveInterrupt(spellId)

	table.remove(pending_spell_ids, spellId)
	if (opt.env.CustomInterrupts[spellId]) then
		opt.env.CustomInterrupts[spellId] = nil;
	end

	for _,f in pairs(opt.ui.interrupt_frames) do

		-- find the existing interrupt spell id
		if (f.id == spellId) then
			
			local prev_frame = f.previous_frame
			local next_frame = f.next_frame

			-- re-build the linked list
			if (next_frame) then
				if (prev_frame) then
					prev_frame.next_frame = next_frame
					next_frame.previous_frame = prev_frame
					next_frame:SetPoint('TOPLEFT', prev_frame, 'BOTTOMLEFT', 0, -2)
				else
					next_frame:SetPoint('TOPLEFT', opt.ui.interruptsArea.panel, 'TOPLEFT')
					next_frame.previous_frame = nil
				end
			elseif (prev_frame) then
				prev_frame.next_frame = nil
			end

			-- update the last frame ptr
			if (lastFrame and lastFrame == f) then
				if prev_frame then
					lastFrame = prev_frame
				else
					lastFrame = nil
				end
			end

			mod:HideInterruptEntry(f)
			break
		end
	end
end

function mod:AddInterruptsSavedColors(parent)

    local basex = 16
	local basey = -12
	local x = basex
	local y = basey
	for i=1,12 do
		local key = 'SavedInterruptColor' .. i
		local color = opt.env[key]
		
		local saved_color = CreateFrame("Button", key, parent, "BackdropTemplate")
		saved_color:SetSize(20, 20)
		saved_color:SetBackdrop({
            bgFile='interface/buttons/white8x8',
            edgeFile='interface/buttons/white8x8',
            edgeSize=1,
            insets={top=2,right=2,bottom=2,left=2}
        })
		saved_color:RegisterForClicks("AnyUp", "AnyDown")
		saved_color:SetScript("OnClick", function(self, event, ...)
			if (event == "RightButton") then
				opt:ColorPickerOnClick(self)
			elseif (event == "LeftButton") then
				setInterruptColor(opt.env[key])
			end
		end)
		saved_color:SetBackdropBorderColor(.5,.5,.5)
		saved_color:SetBackdropColor(color.r, color.g, color.b, color.a)
		saved_color:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
		opt:AddTooltip(saved_color, opt.titles.SavedColors, opt.titles.SavedColor)

		opt.ui[key] = saved_color

		x = x + 32
		if (i % 6 == 0) then
			x = basex
			y = y - 32
		end
	end

end