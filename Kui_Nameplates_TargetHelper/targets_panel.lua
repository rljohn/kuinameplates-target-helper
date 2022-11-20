local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod

opt.currentEditName = ''
local currentRemoveName

function mod:HideTargets()
	if opt.ui.targets == nil then
		return
	end
	
    for _,frame in pairs(opt.ui.targets) do
        frame:Hide()
        frame.highlight:Hide()
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

function mod:CreateTargetFrame(name, color, active)

	local f
	
	local alpha = 1;
	if (not active) then alpha = .5 end
	
	for _,frame in pairs(opt.ui.targets) do
        if not frame:IsShown() then
            -- recycle an old frame
            f = frame
        end
    end
	
	local displayName
	if (color.context) then
		displayName = name .. ' |cff40c0f7[' .. color.context .. ']|r'
	else
		displayName = name .. ' |cffc8d975[' .. opt.titles.ContextCustom .. ']|r'
	end
		
	if not f then
		f = CreateFrame('Frame', nil, opt.ui.scroll.panel );
		
		f:EnableMouse(true)
	
		f:SetSize(GetTargetWidth(), 20)
		opt:AddTooltip(f, displayName, opt.titles.RemoveTargetTooltip)
		
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
				--local entry = opt.env.CustomTargets[self.id]
				--setTargetColor(entry)
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
	f.tooltipTitle = displayName
	f.name:SetTextColor(color.r, color.g, color.b)
	f.icon:SetBackdropBorderColor(.5,.5,.5)
	f.icon:SetBackdropColor (color.r, color.g, color.b, 1)
	tinsert( opt.ui.targets, f );
	return f;
	
end

function mod:RefreshCustomTargets()
	
	mod:HideTargets()
	
	if (opt.env.CustomTargets == nil) then
		return
	end
	
	local previousFrame = nil;
	
	for k,v in pairs ( opt.env.CustomTargets ) do
	
		local f = mod:CreateTargetFrame ( k, v, opt.env.UseCustomTargets );
		
		if previousFrame then
            f:SetPoint('TOPLEFT', previousFrame, 'BOTTOMLEFT', 0, -2)
        else
            f:SetPoint('TOPLEFT')
        end
		
		f:Show();
		previousFrame = f;
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

function opt:CheckExistingContext(newName, source, context)

	if (source == nil) then
		return
	end
	
	local LOCALE = GetLocale()
	local dungeons = (LOCALE and source[LOCALE]) or source.enUS
	table.foreach(dungeons, function(k,v)
		if (v == newName) then
			opt.env.CustomTargets[newName].context = context
		end
	end)
	
end

function opt:TargetEdit(newName)

	if (opt.currentEditName == newName) then
		return
	end
	
	if (opt.env.CustomTargets[opt.currentEditName]) then
		opt.env.CustomTargets[newName] = opt.env.CustomTargets[opt.currentEditName]
		opt.env.CustomTargets[newName].context = nil
		opt.env.CustomTargets[opt.currentEditName] = nil
	end
	
	local LOCALE = GetLocale()
	opt:CheckExistingContext(newName, DefaultTargets, opt.titles.ContextBuiltIn)
	opt:CheckExistingContext(newName, ShadowlandsDungeonTargets, opt.titles.ContextSLDungeons)
	mod:RefreshCustomTargets()
	opt:ResetFrames()
end


function mod:AddTarget(name,color,context)
	opt.env.CustomTargets[name] = {}
	opt.env.CustomTargets[name].r = color.r
	opt.env.CustomTargets[name].g = color.g
	opt.env.CustomTargets[name].b = color.b
	opt.env.CustomTargets[name].a = color.a
	opt.env.CustomTargets[name].context = context
	mod:RefreshCustomTargets();
	opt:ResetFrames()
end

function opt:ConfirmTargetDelete()
    mod:RemoveTarget(currentRemoveName)
end

function mod:RemoveTarget(name)
	if (opt.env.CustomTargets[name] ~= nil) then
		opt.env.CustomTargets[name] = nil;
	end
	mod:RefreshCustomTargets();
	opt:ResetFrames()
end

-- mouse and keyboard events

local function addTargetEnterCallback(self)
    opt.ui.addtargetbtn:Click();
end

local function addTargetEscapeCallback()
	opt.ui.addtargettext:ClearFocus()
end

local function addTargetOnClick()
	local text = opt.ui.addtargettext:GetText()
	if (not text or text == "") then return end
	mod:AddTarget(opt.ui.addtargettext:GetText(), opt.env.NewColor, nil)
end

local function copyTargetOnClick()
	if not UnitExists("target") then return end
	if UnitIsPlayer("target") then return end

	local name = UnitName("target")
	setTargetName(name)
end

-- widgets

function mod:CustomTargetWidgets(parent)

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