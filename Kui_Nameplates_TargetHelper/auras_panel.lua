local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod

function mod:HideAuras()

	if opt.ui.auras == nil then
		return
	end
	
    for _,frame in pairs(opt.ui.auras) do
        frame:Hide()
        frame.highlight:Hide()
    end
end

function mod:CreateAbilityFrame(spellid, name, icon, icon2, icon3, icon4)
	
	local f
	
	for _,frame in pairs(opt.ui.auras) do
        if not frame:IsShown() then
            -- recycle an old frame
            f = frame
        end
    end
	
	if (opt.env.CustomAuraColors[spellid] == nil) then
		opt.env.CustomAuraColors[spellid] = {}
	end

	opt:EnsureSpecEnabledValid(spellid)
	
	local color
	
	if (opt.env.CustomAuraColors[spellid].color == nil) then
		if (opt.env['AuraColor'] ~= nil) then
			color = { r = opt.env['AuraColor'].r, g = opt.env['AuraColor'].g, b = opt.env['AuraColor'].b, a = opt.env['AuraColor'].a }
		else
			color = { r = 1, g = 1, b = 1, a = 1 }
		end
		opt.env.CustomAuraColors[spellid].color = color
	else
		color = opt.env.CustomAuraColors[spellid].color
	end
		
	if not f then
	
		f = CreateFrame('Frame', nil, opt.ui.auralist.panel );
		
		f:EnableMouse(true)
	
		f:SetSize(520, 52)
		
        f.highlight = f:CreateTexture('HIGHLIGHT')
        f.highlight:SetTexture('Interface/BUTTONS/UI-Listbox-Highlight')
        f.highlight:SetBlendMode('add')
        f.highlight:SetAlpha(.5)
        f.highlight:Hide()
		f.highlight:SetAllPoints(f);
		
		f.icon = CreateFrame("Button", nil, f, "BackdropTemplate");
		f.icon:SetSize(42,42);
		f.icon:SetPoint('LEFT');
		f.icon:SetScript("OnClick", function(self, event, ...)
			opt:AuraColorOnClick(self)
		end)
		f.icon:SetBackdrop({
            bgFile='interface/buttons/white8x8',
            edgeFile='interface/buttons/white8x8',
            edgeSize=1,
            insets={top=2,right=2,bottom=2,left=2}
        })
		f.icon:SetScript('OnEnter', function(self)
			f.highlight:Show()
			opt:OnTooltipEnter(f)
		end)
		f.icon:SetScript('OnLeave', function(self)
			f.highlight:Hide()
			opt:OnTooltipLeave(f)
		end)
		
		f.auraicon = CreateFrame("Button", nil, f, "BackdropTemplate");
		f.auraicon:SetSize(48,48);
		f.auraicon:SetPoint('LEFT');
		f.auraicon:SetBackdrop({
            bgFile=icon,
            edgeFile=nil,
            edgeSize=1,
            insets={top=2,right=2,bottom=2,left=2}
        })
		f.auraicon:SetPoint('LEFT', f.icon, 'RIGHT', 4, 0)
		f.auraicon:SetScript('OnEnter', function(self)
			f.highlight:Show()
			opt:OnTooltipEnter(f)
		end)
		f.auraicon:SetScript('OnLeave', function(self)
			f.highlight:Hide()
			opt:OnTooltipLeave(f)
		end)

		if (icon2 ~= nil) then
			f.auraicon2 = CreateFrame("Button", nil, f, "BackdropTemplate");
			f.auraicon2:SetSize(48,48);
			f.auraicon2:SetPoint('LEFT');
			f.auraicon2:SetBackdrop({
				bgFile=icon2,
				edgeFile=nil,
				edgeSize=1,
				insets={top=2,right=2,bottom=2,left=2}
			})
			f.auraicon2:SetPoint('LEFT', f.auraicon, 'RIGHT', 4, 0)
			f.auraicon2:SetScript('OnEnter', function(self)
				f.highlight:Show()
				opt:OnTooltipEnter(f)
			end)
			f.auraicon2:SetScript('OnLeave', function(self)
				f.highlight:Hide()
				opt:OnTooltipLeave(f)
			end)
		end

		if (icon3 ~= nil) then
			f.auraicon3 = CreateFrame("Button", nil, f, "BackdropTemplate");
			f.auraicon3:SetSize(48,48);
			f.auraicon3:SetPoint('LEFT');
			f.auraicon3:SetBackdrop({
				bgFile=icon3,
				edgeFile=nil,
				edgeSize=1,
				insets={top=2,right=2,bottom=2,left=2}
			})
			f.auraicon3:SetPoint('LEFT', f.auraicon2, 'RIGHT', 4, 0)
			f.auraicon3:SetScript('OnEnter', function(self)
				f.highlight:Show()
				opt:OnTooltipEnter(f)
			end)
			f.auraicon3:SetScript('OnLeave', function(self)
				f.highlight:Hide()
				opt:OnTooltipLeave(f)
			end)
		end
		
		if (icon4 ~= nil) then
			f.auraicon4 = CreateFrame("Button", nil, f, "BackdropTemplate");
			f.auraicon4:SetSize(48,48);
			f.auraicon4:SetPoint('LEFT');
			f.auraicon4:SetBackdrop({
				bgFile=icon4,
				edgeFile=nil,
				edgeSize=1,
				insets={top=2,right=2,bottom=2,left=2}
			})
			f.auraicon4:SetPoint('LEFT', f.auraicon3, 'RIGHT', 4, 0)
			f.auraicon4:SetScript('OnEnter', function(self)
				f.highlight:Show()
				opt:OnTooltipEnter(f)
			end)
			f.auraicon4:SetScript('OnLeave', function(self)
				f.highlight:Hide()
				opt:OnTooltipLeave(f)
			end)
		end
		
		f.check = opt:CreateClassAuraCheckBox(f, spellid, name)

		f.check:SetScript('OnEnter', function(self)
			f.highlight:Show()
			opt:OnTooltipEnter(f)
		end)
        f.check:SetScript('OnLeave', function(self)
			f.highlight:Hide()
			opt:OnTooltipLeave(f)
		end)
		
		f:SetScript('OnEnter', function(self)
			self.highlight:Show()
			opt:OnTooltipEnter(f)
		end)
        f:SetScript('OnLeave', function(self)
			self.highlight:Hide()
			opt:OnTooltipLeave(f)
		end)
		
	end
	
	opt.env.CustomAuraColors[spellid].name = name
	
	local tt_text = 'Modify the color of your enemy health bars when your |cff9966ff' .. name .. '|r is applied. \n\nMake sure |cff9966ffKUI Spell List|r is tracking this ability.'
	f.id = spellid;
	f.tooltipTitle = name
	f.icon:SetBackdropBorderColor(.5,.5,.5)
	f.icon:SetBackdropColor (color.r, color.g, color.b, 1)
	f.tooltipText = tt_text
	f.check.label:SetText(name)
	f.check.spellid = spellid
	opt:SetClassAuraChecked(f.check, spellid)
	
	-- update aura icon 1
	f.auraicon:SetBackdrop({
		bgFile=icon,
		edgeFile=nil,
		edgeSize=1,
		insets={top=2,right=2,bottom=2,left=2}
	})
	
	-- update icon2 if needed
	if (icon2 ~= nil) then
	
		-- create aura icon 2 if needed
		if (f.auraicon2 == nil) then
			f.auraicon2 = CreateFrame("Button", nil, f, "BackdropTemplate");
			f.auraicon2:SetSize(48,48);
			f.auraicon2:SetPoint('LEFT');
			f.auraicon2:SetBackdrop({
				bgFile=icon2,
				edgeFile=nil,
				edgeSize=1,
				insets={top=2,right=2,bottom=2,left=2}
			})
			f.auraicon2:SetPoint('LEFT', f.auraicon, 'RIGHT', 4, 0)
			f.auraicon2:SetScript('OnEnter', function(self)
				f.highlight:Show()
				opt:OnTooltipEnter(f)
			end)
			f.auraicon2:SetScript('OnLeave', function(self)
				f.highlight:Hide()
				opt:OnTooltipLeave(f)
			end)
		end
		
		-- update aura icon 2
		f.auraicon2:SetBackdrop({
			bgFile=icon2,
			edgeFile=nil,
			edgeSize=1,
			insets={top=2,right=2,bottom=2,left=2}
		})
		
		-- show aura icon 2
		f.auraicon2:Show()
	else 
		-- hide aura icon 2 if needed
		if f.auraicon2 ~= nil then
			f.auraicon2:Hide()
		end
	end

	-- update icon3 if needed
	if (icon3 ~= nil) then
	
		-- create aura icon 2 if needed
		if (f.auraicon3 == nil) then
			f.auraicon3 = CreateFrame("Button", nil, f, "BackdropTemplate");
			f.auraicon3:SetSize(48,48);
			f.auraicon3:SetPoint('LEFT');
			f.auraicon3:SetBackdrop({
				bgFile=icon3,
				edgeFile=nil,
				edgeSize=1,
				insets={top=2,right=2,bottom=2,left=2}
			})
			f.auraicon3:SetPoint('LEFT', f.auraicon2, 'RIGHT', 4, 0)
			f.auraicon3:SetScript('OnEnter', function(self)
				f.highlight:Show()
				opt:OnTooltipEnter(f)
			end)
			f.auraicon3:SetScript('OnLeave', function(self)
				f.highlight:Hide()
				opt:OnTooltipLeave(f)
			end)
		end
		
		-- update aura icon 3
		f.auraicon3:SetBackdrop({
			bgFile=icon3,
			edgeFile=nil,
			edgeSize=1,
			insets={top=2,right=2,bottom=2,left=2}
		})
		
		-- show aura icon 3
		f.auraicon3:Show()
	else 
		-- hide aura icon 3 if needed
		if f.auraicon3 ~= nil then
			f.auraicon3:Hide()
		end
	end

	-- update icon4 if needed
	if (icon4 ~= nil) then
	
		-- create aura icon 2 if needed
		if (f.auraicon4 == nil) then
			f.auraicon4 = CreateFrame("Button", nil, f, "BackdropTemplate");
			f.auraicon4:SetSize(48,48);
			f.auraicon4:SetPoint('LEFT');
			f.auraicon4:SetBackdrop({
				bgFile=icon4,
				edgeFile=nil,
				edgeSize=1,
				insets={top=2,right=2,bottom=2,left=2}
			})
			f.auraicon4:SetPoint('LEFT', f.auraicon3, 'RIGHT', 4, 0)
			f.auraicon4:SetScript('OnEnter', function(self)
				f.highlight:Show()
				opt:OnTooltipEnter(f)
			end)
			f.auraicon4:SetScript('OnLeave', function(self)
				f.highlight:Hide()
				opt:OnTooltipLeave(f)
			end)
		end
		
		-- update aura icon 3
		f.auraicon4:SetBackdrop({
			bgFile=icon4,
			edgeFile=nil,
			edgeSize=1,
			insets={top=2,right=2,bottom=2,left=2}
		})
		
		-- show aura icon 3
		f.auraicon4:Show()
	else 
		-- hide aura icon 3 if needed
		if f.auraicon4 ~= nil then
			f.auraicon4:Hide()
		end
	end
		
	-- update checkpoint pos
	if (icon4 ~= nil) then
		f.check:SetPoint('LEFT', f.auraicon4, 'RIGHT', 4, 0)
	elseif (icon3 ~= nil) then
		f.check:SetPoint('LEFT', f.auraicon3, 'RIGHT', 4, 0)
	elseif (icon2 ~= nil) then
		f.check:SetPoint('LEFT', f.auraicon2, 'RIGHT', 4, 0)
	else
		f.check:SetPoint('LEFT', f.auraicon, 'RIGHT', 4, 0)
	end
		
	tinsert( opt.ui.auras, f );
	return f;
end

function mod:AddClassAuras(specId, abilities)	

	local previousFrame = nil;
	table.foreach(abilities, function(k,v)
	
		local ability = v
		local abilityString = ''
		local first = true
		
		local abilityNum = tonumber(ability)
		
		local f
		
		if (abilityNum == nil) then
		
			local icon1 = nil
			local icon2 = nil
			local icon3 = nil
			local icon4 = nil

			local abilitySum = 0
			
			table.foreach(ability, function(k, v)
				if (first == false) then
					abilityString = abilityString .. ' + '
				end
				
				abilitySum = abilitySum + v
				
				local name = C_Spell.GetSpellName(v)
				local icon = C_Spell.GetSpellTexture(v)
				abilityString = abilityString .. name
				
				if (icon1 == nil) then
					icon1 = icon
				elseif (icon2 == nil) then
					icon2 = icon
				elseif (icon3 == nil) then
					icon3 = icon
				else
					icon4 = icon
				end
				
				first = false
			end)
			
			f = mod:CreateAbilityFrame ( abilitySum, abilityString, icon1, icon2, icon3, icon4);
			
		else
			local name = C_Spell.GetSpellName(abilityNum)
			local icon = C_Spell.GetSpellTexture(abilityNum)
			abilityString = abilityString .. name
			
			f = mod:CreateAbilityFrame ( abilityNum, name, icon, nil);
			
		end
				
		if previousFrame then
			f:SetPoint('TOPLEFT', previousFrame, 'BOTTOMLEFT', 0, -2)
		else
			f:SetPoint('TOPLEFT')
		end
		
		f:Show();
		previousFrame = f;
			
	end)
end

function mod:RefreshClassAuras()

	mod:HideAuras()
		
	if opt.class.specId == nil then
		opt.ui.auralistTitle:SetText(opt.titles["ClassAuras"])
		return
	end
	
	opt.ui.auralistTitle:SetText( opt.class.name .. ' (' .. opt.class.specName .. ')' .. ' - Debuffs')
	
	local found = false
	
	table.foreach(KuiTargetAuraList, function(k,v)
		if (k == opt.class.specId) then
			mod:AddClassAuras(k, v)
			found = true
		end
	end)
	
	if (found) then
		opt.ui.aurasNone:Hide()
	else
		opt.ui.aurasNone:Show()
	end
	
end