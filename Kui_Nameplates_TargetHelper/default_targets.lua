local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod

function mod:addDefaultTargets(color, context_color, keys, source)

	-- early out for empty keys
	if (keys == nil) then
		return
	end
	
	-- add any targets not already tracked
	table.foreach(keys, function(k,v)
	
		local id = v
		local name = mod:ConvertNpcIdToName(id)

		-- search to see if we tracked this already
		local exists = false
		for ck,cv in pairs ( opt.env.CustomTargets ) do
			if (v == ck) then
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
	end)
end

function mod:ConvertNpcIdToName(npcid)
	
	local info = C_TooltipInfo.GetHyperlink(("unit:Creature-0-0-0-0-%d"):format(npcid))

	if info and info.lines and info.lines[1] then
		TooltipUtil.SurfaceArgs(info.lines[1])
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