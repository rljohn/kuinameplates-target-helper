local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod

function mod:addDefaultTarget(id, name, color, source, context_color)
	-- search to see if we tracked this already
	local exists = false
	for ck,cv in pairs ( opt.env.CustomTargets ) do
		if (id == ck or name == ck) then
			exists = true
			break
		end
	end

	-- if it wasn't tracked already, add it
	if (exists == false) then
		mod:AddTarget(name, color, source, context_color)
	else
		opt.env.CustomTargets[name].context = source
		opt.env.CustomTargets[name].context_color = context_color
	end
end

function mod:preloadDefaultTarget(keys)
	table.foreach(keys, function(k,v)
		local id = v
		mod:ConvertNpcIdToName(id)
	end)
end

function mod:addDefaultTargets(color, context_color, keys, source)

	-- early out for empty keys
	if (keys == nil) then
		return
	end

	self:preloadDefaultTarget(keys)

	C_Timer.After(1, function()
		-- add any targets not already tracked
		table.foreach(keys, function(k,v)
			
			local id = v
			local name = mod:ConvertNpcIdToName(id)

			if not name or name =="" then
				rlPrintf("Could not convert NPC ID: %d", id)
			else
				mod:addDefaultTarget(id, name, color, source, context_color)
			end
		end)
	end)
end

function mod:ConvertNpcIdToName(npcid)
	
	local info = C_TooltipInfo.GetHyperlink(("unit:Creature-0-0-0-0-%d"):format(npcid))

	if info and info.lines and info.lines[1] then
		if info.lines[1].type == Enum.TooltipDataType.Unit then
			return info.lines[1].leftText
		end
	end

	return ""
end

function mod:AddMythicPlusTargets()
	local color = {
		r = 1,
		g = 0.42,
		b = 0.21,
		a = 1
	}
	local context_color = 'ffff6b36'
	for count,dungeon in ipairs(MythicPlusTargets) do
		mod:addDefaultTargets(color, context_color, dungeon.npcs, dungeon.name)
	end
end

function mod:AddDragonFlightTargetsSeasonOne()
	local color = { 
		r = 0.66,
		g = 0.89,
		b = 1,
		a = 1
	}
	local context_color = 'ffa8e2ff'
	for count,dungeon in ipairs(DragonFlightS1Targets) do
		mod:addDefaultTargets(color, context_color, dungeon.npcs, dungeon.name)
	end
end

function mod:AddDragonFlightTargetsSeasonTwo()

	local scary_color = {  r = 1.0, g = 0.57, b = 0, a = 1 }
	local caster_color = {  r = 0.66, g = 0.89, b = 1, a = 1 }
	local notable_color = { r = 0.8,  g = 0.13,  b = 0.67,  a = 1.0 }

	for count,dungeon in ipairs(DragonFlightS2Targets) do
		local color_context = 'ffa8e2ff'
		mod:addDefaultTargets(scary_color, color_context, dungeon.scary_npcs, dungeon.name)
		mod:addDefaultTargets(caster_color, color_context, dungeon.casters, dungeon.name)
		mod:addDefaultTargets(notable_color, color_context, dungeon.notable, dungeon.name)
	end
end

function mod:AddDragonFlightTargetsSeasonThree()

	local frontal_color = {  r = 1.0, g = 0.57, b = 0, a = 1 }
	local interupt_color = {  r = 0.66, g = 0.89, b = 1, a = 1 }
	local cc_color = { r = 0.8,  g = 0.13,  b = 0.67,  a = 1.0 }

	for count,dungeon in ipairs(DragonFlightS3Targets) do
		local color_context = 'FF8E89F3'
		mod:addDefaultTargets(frontal_color, color_context, dungeon.frontal, dungeon.name)
		mod:addDefaultTargets(interupt_color, color_context, dungeon.interupt, dungeon.name)
		mod:addDefaultTargets(cc_color, color_context, dungeon.cc, dungeon.name)
	end
end

function mod:AddWarWithinCastsSeasonOne()

	mod:LoadInterruptData()
	
	C_Timer.After(1, function()
		local heal_color = { r = 0.49, g = 0.89, b = 0.28, a = 1 }
		local interrupt_color = { r = 0.5, g = 1, b = 0.96, a = 1 }
		local stop_color = { r = 0.929, g = 0.243, b = 0, a = 1}

		for count,dungeon in ipairs(WarWithinS0Targets) do
			local color_context = 'FF8E89F3'
			mod:addDefaultInterrupts(heal_color, color_context, dungeon.cast_heal, dungeon.name)
			mod:addDefaultInterrupts(interrupt_color, color_context, dungeon.cast_interrupt, dungeon.name)
			mod:addDefaultInterrupts(stop_color, color_context, dungeon.cast_stop, dungeon.name)
		end
		for count,dungeon in ipairs(WarWithinS1Targets) do
			local color_context = 'FF8E89F3'
			mod:addDefaultInterrupts(heal_color, color_context, dungeon.cast_heal, dungeon.name)
			mod:addDefaultInterrupts(interrupt_color, color_context, dungeon.cast_interrupt, dungeon.name)
			mod:addDefaultInterrupts(stop_color, color_context, dungeon.cast_stop, dungeon.name)
		end
	end)
end

function mod:AddDragonFlightTargetsSeasonFour()

	local scary_color = {  r = 1.0, g = 0.57, b = 0, a = 1 }
	local caster_color = {  r = 0.66, g = 0.89, b = 1, a = 1 }
	local notable_color = { r = 0.8,  g = 0.13,  b = 0.67,  a = 1.0 }

	for count,dungeon in ipairs(DragonFlightS4Targets) do
		local color_context = 'ffa8e2ff'
		mod:addDefaultTargets(scary_color, color_context, dungeon.scary_npcs, dungeon.name)
		mod:addDefaultTargets(caster_color, color_context, dungeon.casters, dungeon.name)
		mod:addDefaultTargets(notable_color, color_context, dungeon.notable, dungeon.name)
	end
end

function mod:AddTheWarWithinTargetsSeasonOne()

	local frontal_color = {  r = 1.0, g = 0.57, b = 0, a = 1 }
	local caster_color = {  r = 0.66, g = 0.89, b = 1, a = 1 }
	local notable_color = { r = 0.8,  g = 0.13,  b = 0.67,  a = 1.0 }

	for count,dungeon in ipairs(WarWithinS0Targets) do
		local color_context = 'FFDDAF30'
		mod:addDefaultTargets(frontal_color, color_context, dungeon.frontals, dungeon.name)
		mod:addDefaultTargets(caster_color, color_context, dungeon.casters, dungeon.name)
		mod:addDefaultTargets(notable_color, color_context, dungeon.notable, dungeon.name)
	end
	for count,dungeon in ipairs(WarWithinS1Targets) do
		local color_context = 'FFDDAF30'
		mod:addDefaultTargets(frontal_color, color_context, dungeon.frontals, dungeon.name)
		mod:addDefaultTargets(caster_color, color_context, dungeon.casters, dungeon.name)
		mod:addDefaultTargets(notable_color, color_context, dungeon.notable, dungeon.name)
	end
end

function mod:AddTheWarWithinCastsSeasonOne()

	mod:LoadInterruptData()
	
	C_Timer.After(1, function()
		local heal_color = { r = 0.49, g = 0.89, b = 0.28, a = 1 }
		local interrupt_color = { r = 0.5, g = 1, b = 0.96, a = 1 }

		for count,dungeon in ipairs(WarWithinS0Targets) do
			local color_context = 'FFDDAF30'
			mod:addDefaultInterrupts(heal_color, color_context, dungeon.cast_heal, dungeon.name)
			mod:addDefaultInterrupts(interrupt_color, color_context, dungeon.cast_interrupt, dungeon.name)
			mod:addDefaultInterrupts(stop_color, color_context, dungeon.cast_stop, dungeon.name)
		end
		for count,dungeon in ipairs(WarWithinS1Targets) do
			local color_context = 'FFDDAF30'
			mod:addDefaultInterrupts(heal_color, color_context, dungeon.cast_heal, dungeon.name)
			mod:addDefaultInterrupts(interrupt_color, color_context, dungeon.cast_interrupt, dungeon.name)
			mod:addDefaultInterrupts(stop_color, color_context, dungeon.cast_stop, dungeon.name)
		end
	end)
end

function mod:AddTheWarWithinTargetsSeasonThree()
	
	local scary_color = {  r = 1.0, g = 0.57, b = 0, a = 1 }
	local frontal_color = {  r = 1.0, g = 0.57, b = 0, a = 1 }
	local caster_color = {  r = 0.66, g = 0.89, b = 1, a = 1 }
	local notable_color = { r = 0.8,  g = 0.13,  b = 0.67,  a = 1.0 }

	for count,dungeon in ipairs(WarWithinS3Targets) do
		local color_context = 'FFDDAF30'
		mod:addDefaultTargets(scary_color, color_context, dungeon.scary_npcs, dungeon.name)
		mod:addDefaultTargets(frontal_color, color_context, dungeon.frontals, dungeon.name)
		mod:addDefaultTargets(caster_color, color_context, dungeon.casters, dungeon.name)
		mod:addDefaultTargets(notable_color, color_context, dungeon.notable, dungeon.name)
	end
end

function mod:AddTheWarWithinCastsSeasonThree()

	mod:LoadInterruptData()
	
	C_Timer.After(1, function()
		local heal_color = { r = 0.49, g = 0.89, b = 0.28, a = 1 }
		local interrupt_color = { r = 0.5, g = 1, b = 0.96, a = 1 }
		local stop_color = { r = 0.929, g = 0.243, b = 0, a = 1}

		for count,dungeon in ipairs(WarWithinS3Targets) do
			local color_context = 'FFDDAF30'
			mod:addDefaultInterrupts(heal_color, color_context, dungeon.cast_heal, dungeon.name)
			mod:addDefaultInterrupts(interrupt_color, color_context, dungeon.cast_interrupt, dungeon.name)
			mod:addDefaultInterrupts(stop_color, color_context, dungeon.cast_stop, dungeon.name)
		end
	end)
end


function mod:addDefaultInterrupts(color, context_color, keys, source)
	if (keys == nil) then return end
	table.foreach(keys, function(k,v)
		local spellId = v
		mod:AddInterrupt(spellId, color, source, context_color)
	end)
end

function mod:LoadInterruptsFor(keys)
	if (keys == nil) then return end
	table.foreach(keys, function(k,v)
		local spellId = v
		C_Spell.RequestLoadSpellData(spellId)
	end)
end

function mod:LoadInterruptData()
	for count,dungeon in ipairs(WarWithinS0Targets) do
		self:LoadInterruptsFor(dungeon.cast_heal)
		self:LoadInterruptsFor(dungeon.cast_interrupt)
		self:LoadInterruptsFor(dungeon.cast_stop)
	end
	for count,dungeon in ipairs(WarWithinS1Targets) do
		self:LoadInterruptsFor(dungeon.cast_heal)
		self:LoadInterruptsFor(dungeon.cast_interrupt)
		self:LoadInterruptsFor(dungeon.cast_stop)
	end
	for count,dungeon in ipairs(WarWithinS3Targets) do
		self:LoadInterruptsFor(dungeon.cast_heal)
		self:LoadInterruptsFor(dungeon.cast_interrupt)
		self:LoadInterruptsFor(dungeon.cast_stop)
	end
end