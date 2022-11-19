local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod

function mod:addDefaultTargets(keys, source)

	-- early out for empty keys
	if (keys == nil) then
		return
	end
	
	-- add any targets not already tracked
	table.foreach(keys, function(k,v)
	
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
			opt:AddTarget(v, { r = 0.64, g = 1.0, b = 0.63, a = 1.0 }, source)
		end
	end)
end

function opt:addShadowlandsTargets()

	local LOCALE = GetLocale()	
	local keys = (LOCALE and ShadowlandsDungeonTargets[LOCALE]) or ShadowlandsDungeonTargets.enUS
	
	mod:addDefaultTargets(keys, "Shadowlands Dungeons")
end