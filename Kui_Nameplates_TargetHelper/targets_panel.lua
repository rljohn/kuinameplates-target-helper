local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod

opt.currentEditName = ''

local currentRemoveName
local lastFrame = nil

function mod:ClearCustomTargets()
	opt.env.CustomTargets = {}
	mod:RefreshCustomTargets()
end

function mod:HideTargetFrame(f)
	f:Hide()
	f.highlight:Hide()
	f.active = false
	f.next_frame = nil
	f.previous_frame = nil
end

function mod:HideTargets()

	lastFrame = nil

	if opt.ui.targets == nil then
		return
	end
	
    for _,frame in pairs(opt.ui.targets) do
		self:HideTargetFrame(frame)
    end
end

function mod:ClearEditBoxTargetName()
	opt.ui.addtargettext:SetText('')
end

local function GetTargetWidth()
	if (opt.IsDragonFlight) then
		return 520
	else
		return 480
	end
end

local function setTargetName(name)
	opt.ui.addtargettext:SetText(name)
	opt.ui.addtargettext:SetCursorPosition(0)
	opt.ui.addtargettext:ClearFocus()
end

local function setTargetColor(color)
	if not color then return end
	opt.env.NewColor = color
	local tmp = opt.env.NewColor
	opt.ui.addtargetcolor:SetBackdropColor(tmp.r, tmp.g, tmp.b, tmp.a)
end

function mod:UpdateTooltip(f, name, context, context_color)
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
		opt:AddTooltip(f, displayName, opt.titles.RemoveTargetTooltip)
	end
end

function mod:CreateTargetFrame(name, color)

	local f
		
	-- look for a previously removed frame to use
	for _,frame in pairs(opt.ui.targets) do
        if not frame.active then
            f = frame
			break
        end
    end	
		
	if not f then
		f = CreateFrame('Frame', nil, opt.ui.scroll.panel );
		tinsert( opt.ui.targets, f );

		f:EnableMouse(true)
		f:SetSize(GetTargetWidth(), 20)
		
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
			opt:CustomTargetColorOnClick(self)
		end)
		f.icon:SetBackdrop({
            bgFile='interface/buttons/white8x8',
            edgeFile='interface/buttons/white8x8',
            edgeSize=1,
            insets={top=2,right=2,bottom=2,left=2}
        })
		opt:AddTooltip(f.icon, opt.titles.CustomColorTooltipTitle, opt.titles.CustomColorTooltipText)
		
		f.name = f:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
        -- f.name:SetFont(STANDARD_TEXT_FONT, 12)
		f.name:SetSize(GetTargetWidth(), 18)
        f.name:SetPoint('LEFT', f.icon, 'RIGHT', 10, 0)
        f.name:SetJustifyH('LEFT')
		
		local editBtn = opt:CreateButton(f, nil, 50, 20, "Edit")
		editBtn:SetPoint('LEFT', f, 'RIGHT', 0, 0)
		editBtn:SetScript('OnClick', function(self, arg1)
			opt.currentEditName = self:GetParent().id
			StaticPopup_Show("KUI_TargetHelper_EditBox", self:GetParent().id)
		end)
		opt:AddTooltip(editBtn, opt.titles.EditTitle, opt.titles.EditTooltip)
		
		f:SetScript('OnMouseUp', function(self, button)
			if button == 'LeftButton' then
				setTargetName(self.id)
			elseif button == 'RightButton' then
				currentRemoveName = self.id
				StaticPopup_Show("KUI_TargetHelper_DeleteTargetConfirm", self.id)
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
	
	f.id = name;
	f.name:SetText(name);
	f.name:SetTextColor(color.r, color.g, color.b)
	f.icon:SetBackdropBorderColor(.5,.5,.5)
	f.icon:SetBackdropColor (color.r, color.g, color.b, 1)
	f.active = true
	return f;
	
end

local in_progress = false
local queued = false

function mod:RefreshCustomTargets()
	
	if (opt.env.CustomTargets == nil) then
		return
	end
	
	-- sometimes a couple events can queue this up
	-- don't queue 2 refreshes at once
	-- and queue it up on the next frame preferably
	-- wait for all frames to be created
	if not in_progress and not queued then
		mod:HideTargets()
		queued = true
		RunNextFrame(function()
			mod:StartBuildingCustomFrames()
			queued = false
		end)
	end

	for i=1,12 do
		local key = 'SavedColor' .. i
		local setting = opt.env[key]
		local frame = opt.ui[key]
		if (setting and frame) then
			frame:SetBackdropColor(setting.r, setting.g, setting.b, setting.a)
		end
	end
end

function mod:BuildTargetFrames(targets, first, size, total)

	for i=first,first+size-1 do

		if (i <= total) then
			local entry = targets[i]
			local k = entry[1]
			local v = entry[2]

			local f = mod:CreateTargetFrame ( k, v );
				
			if lastFrame and f ~= lastFrame then
				f:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -2)
				f.previous_frame = lastFrame
				lastFrame.next_frame = f
			else
				f:SetPoint('TOPLEFT', opt.ui.scroll.panel, 'TOPLEFT')
				f.previous_frame = nil
				f.next_frame = nil
			end

			mod:UpdateTooltip(f, k, v.context, v.context_color)
			lastFrame = f
		end

	end

	if (first+size < total) then
		local newFirst = first + size
		RunNextFrame(function()
			mod:BuildTargetFrames(targets, newFirst, size, total)
			queued = false
		end)
	else
		in_progress = false
	end
end

function mod:StartBuildingCustomFrames()

	-- created a sorted 
	local copy = mod:SortedPairs( opt.env.CustomTargets )
	local total = #copy
	in_progress = true
	local per_frame = 10
	mod:BuildTargetFrames(copy, 1, per_frame, total)
end

function opt:TargetEdit(newName)

	if (opt.currentEditName == newName) then
		return
	end
	
	if (opt.env.CustomTargets[opt.currentEditName]) then
		local previous = opt.env.CustomTargets[opt.currentEditName]
		opt.env.CustomTargets[newName] = opt.env.CustomTargets[opt.currentEditName]
		opt.env.CustomTargets[newName].context = previous.context
		opt.env.CustomTargets[newName].context_color = previous.context_color
		opt.env.CustomTargets[opt.currentEditName] = nil
	end

	-- update frame
	for _,frame in pairs(opt.ui.targets) do
		if frame.active then
			if (frame.id == opt.currentEditName) then
				frame.id = newName
				frame.name:SetText(newName);
				break
			end
		end
	end
	
	opt:ResetFrames()
end


function mod:AddTarget(name,color,context,context_color)

	if (not name or name == "") then
		rlDiagf("Tried to add invalid name")
		return
	end

	local existing = opt.env.CustomTargets[name]

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

	opt.env.CustomTargets[name] = entry

	local f = nil

	-- iterate through all frames. find and update existing frame
	for _,frame in pairs(opt.ui.targets) do
		if (frame.active) then
			if (frame.id == name) then
				frame.name:SetTextColor(color.r, color.g, color.b)
				frame.icon:SetBackdropBorderColor(.5,.5,.5)
				frame.icon:SetBackdropColor(color.r, color.g, color.b, 1)
				return
			end
		end
	end

	-- this is a new target, build (or recycle) a frame
	if not f then
		f = mod:CreateTargetFrame ( name, color );
	end

	-- update tooltip
	mod:UpdateTooltip(f, name, context, context_color)

	if f then
		if lastFrame and f ~= lastFrame then
			f:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -2)
			f.previous_frame = lastFrame
			lastFrame.next_frame = f
		else
			f:SetPoint('TOPLEFT', opt.ui.scroll.panel, 'TOPLEFT')
			f.previous_frame = nil
			f.next_frame = nil
		end
		lastFrame = f
		f:Show()
	end

	opt:ResetFrames()
end

function opt:ConfirmTargetDelete()
    mod:RemoveTarget(currentRemoveName)
end

function mod:RemoveTarget(name)

	if (opt.env.CustomTargets[name]) then
		opt.env.CustomTargets[name] = nil;
	end

	for _,f in pairs(opt.ui.targets) do

		-- find the existing target
		if (f.id == name) then
			
			local prev_frame = f.previous_frame
			local next_frame = f.next_frame

			-- re-build the linked list
			if (next_frame) then
				if (prev_frame) then
					prev_frame.next_frame = next_frame
					next_frame.previous_frame = prev_frame
					next_frame:SetPoint('TOPLEFT', prev_frame, 'BOTTOMLEFT', 0, -2)
				else
					next_frame:SetPoint('TOPLEFT', opt.ui.scroll.panel, 'TOPLEFT')
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

			mod:HideTargetFrame(f)
			break
		end
	end

	opt:ResetFrames()
end

-- mouse and keyboard events

local function addTargetEnterCallback(self)
    opt.ui.addtargetbtn:Click();
end

local function addTargetEscapeCallback()
	opt.ui.addtargettext:ClearFocus()
end

local function finallyAddTargetName(name)
	opt.ui.addtargettext:SetText(name)
	mod:AddTarget(name, opt.env.NewColor, nil, nil)
end

local function addTargetOnClick()
	local text = opt.ui.addtargettext:GetText()
	if (not text or text == "") then return end
	
	-- check if the text was a number
	local number = tonumber(text)

	-- was an NPC id entered?
	if (number) then

		-- convert npc ID to name
		local name = mod:ConvertNpcIdToName(number)

		if not name or name == "" then
			C_Timer.After(1, function()
				local inner_name = mod:ConvertNpcIdToName(number)
				if (inner_name and inner_name ~= "") then
					finallyAddTargetName(inner_name)
				else
					print("Could not convert %u to NPC id. Try again!", number)
				end
			end)
			return
		else
			finallyAddTargetName(name)
		end
	else
		finallyAddTargetName(text)
	end
end

local function copyTargetOnClick()
	if not UnitExists("target") then return end
	if UnitIsPlayer("target") then return end

	local name = UnitName("target")
	setTargetName(name)
end

-- widgets

function mod:CustomTargetWidgets(parent)

	local season1 = opt:CreateIcon(parent, nil, 4734167, 32, 32)
	season1:SetPoint('BOTTOMRIGHT', opt.ui.scroll, 'TOPRIGHT', 28, 16)
	season1:SetScript('OnClick', function(self)
		local dialog = StaticPopup_Show("KUI_TargetHelper_SeasonConfirm")
	end)
	opt:AddTooltip(season1, opt.titles.SeasonTooltip, opt.titles.SeasonTooltipText)

	local season3 = opt:CreateIcon(parent, nil, 4734167, 32, 32)
	season3:SetPoint('TOPRIGHT', season1, 'TOPLEFT', -8, 0)
	season3:SetScript('OnClick', function(self)
		local dialog = StaticPopup_Show("KUI_TargetHelper_SeasonThreeConfirm")
	end)
	opt:AddTooltip(season3, opt.titles.SeasonThreeTooltip, opt.titles.SeasonThreeTooltipText)

	-- local mplus = opt:CreateIcon(parent, nil, 2175503, 32, 32)
	-- mplus:SetPoint('TOPRIGHT', season1, 'TOPLEFT', -8, 0)
	-- mplus:SetScript('OnClick', function(self)
	--   local dialog = StaticPopup_Show("KUI_TargetHelper_MPlusConfirm")
	-- end)
	-- opt:AddTooltip(mplus, opt.titles.SpecialTargets, opt.titles.SpecialTargetsTooltip)

	local clear = opt:CreateIcon(parent, nil, 4200126, 32, 32)
	clear:SetPoint('TOPRIGHT', season3, 'TOPLEFT', -8, 0)
	clear:SetScript('OnClick', function(self)
		local dialog = StaticPopup_Show("KUI_TargetHelper_ClearEnemiesConfirm")
	end)
	opt:AddTooltip(clear, opt.titles.ClearTargets, opt.titles.ClearTargetsTooltip)

	local add_panel = opt:CreatePanel(parent, nil, 320 , 80)
	add_panel:SetPoint('TOPLEFT', opt.ui.scroll, 'BOTTOMLEFT', 0, -55)

	local add_title = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	add_title:SetText(opt.titles.AddTarget)
	add_title:SetPoint('TOPLEFT', add_panel, 'TOPLEFT', 2, 32)

	opt.ui.addtargetcolor = opt:CreateColorTexture(add_panel, 'NewColor', 32, 32, opt.env.NewColor.r, opt.env.NewColor.g, opt.env.NewColor.b, opt.env.NewColor.a)
	opt.ui.addtargetcolor:SetPoint("TOPLEFT", add_panel, "TOPLEFT", 6, -8)
	opt:AddTooltip(opt.ui.addtargetcolor, opt.titles.CustomColorTooltipTitle, opt.titles.CustomColorTooltipText)
	
	opt.ui.addtargettext = opt:CreateEditBox(add_panel, "AddTargetText", 150, 180, 30)
	opt.ui.addtargettext:SetPoint('TOPLEFT', opt.ui.addtargetcolor, "TOPRIGHT", 22, 0)
	opt.ui.addtargettext:SetScript('OnEnterPressed', addTargetEnterCallback)
	opt.ui.addtargettext:SetScript('OnEscapePressed', addTargetEscapeCallback)
	opt:AddTooltip(opt.ui.addtargettext, opt.titles.AddTargetTooltipTitle, opt.titles.AddTargetTooltipText)
	
	opt.ui.addtargetbtn = opt:CreateButton(add_panel, 'AddTarget', 80, 30, opt.titles.AddTargetBtn)
	opt.ui.addtargetbtn:SetPoint("TOPLEFT", opt.ui.addtargettext, "TOPRIGHT", 8, 0)
	opt.ui.addtargetbtn:SetScript("OnClick", function(self, event, ...)
			addTargetOnClick()
		end)
	opt:AddTooltip(opt.ui.addtargetbtn, opt.titles.AddTarget, opt.titles.AddTargetBtnTooltip)

	opt.ui.copytargetbtn = opt:CreateButton(add_panel, nil, 150, 30, opt.titles.CopyTarget)
	opt.ui.copytargetbtn:SetPoint("TOPLEFT", opt.ui.addtargettext, "BOTTOMLEFT", -6, -8)
	opt.ui.copytargetbtn:SetScript("OnClick", function(self, event, ...)
			copyTargetOnClick()
		end)
	opt:AddTooltip(opt.ui.copytargetbtn, opt.titles.CopyTarget, opt.titles.CopyTargetTooltip)

	local side_panel = opt:CreatePanel(parent, nil, 200 , 78)
	side_panel:SetPoint('TOPLEFT', add_panel, 'TOPRIGHT', 64, 0)

	local side_title = parent:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	side_title:SetText(opt.titles.SavedColors)
	side_title:SetPoint('TOPLEFT', side_panel, 'TOPLEFT', 2, 32)

	local basex = 16
	local basey = -12
	local x = basex
	local y = basey
	for i=1,12 do
		local key = 'SavedColor' .. i
		local color = opt.env[key]
		
		local saved_color = CreateFrame("Button", key, side_panel, "BackdropTemplate")
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
				setTargetColor(opt.env[key])
			end
		end)
		saved_color:SetBackdropBorderColor(.5,.5,.5)
		saved_color:SetBackdropColor(color.r, color.g, color.b, color.a)
		saved_color:SetPoint("TOPLEFT", side_panel, "TOPLEFT", x, y)
		opt:AddTooltip(saved_color, opt.titles.SavedColors, opt.titles.SavedColor)

		opt.ui[key] = saved_color

		x = x + 32
		if (i % 6 == 0) then
			x = basex
			y = y - 32
		end
	end
	
end