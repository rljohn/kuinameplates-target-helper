
-- Auras for DOT Tracking
KuiTargetAuraList = {
	[256] = {	-- DISC PRIEST
		204213,	--	Purge the Wicked
	},
	[257] = {	-- HOLY PRIEST
		589,	--  Shadow Word: Pain
		14914,  --  Holy Fire
		{589,14914} -- Holy Fire + Shadow Word: Pain
	},
	[258] = { 	-- SHADOW PRIEST
		589,	-- Shadow Word: Pain
		34914, 	--  Vampiric Touch
		{589,34914} -- Vampiric Touch + Shadow Word: Pain
	}, 
	[265] = {	-- AFFLICTION WARLOCK
		172,	--	Corruption
		980,	--	Agony
		30108,	-- 	Unstable Affliction
		48181,	-- 	Haunt
		27243,	-- 	Seed of Corruption
		{172,980} -- Corruption + Agony
		{172,980,48181} -- Corruption + Agony + Haunt
		{172,980,30108} -- Corruption + Agony + Unstable Affliction
		{172,980,30108,48181} -- Corruption + Agony + UA + Haunt

	},
	[267] = {	-- DESTRUCTION WARLOCK
		157736,	-- Immolate
		80240,	-- Havoc
	},
	[102] = {	-- BALANCE DRUID
		164815,	--	Sunfire
		164812,	-- 	Moonfire
		{164815,164812}, -- Moon Fire, Sunfire
		155722,	-- 	Rake
		1079,	--	Rip
	},
	[103] = {	-- FERAL DRUID
		164815,	--	Sunfire
		164812,	-- 	Moonfire
		155722,	-- 	Rake
		1079,	--	Rip
		{155722,1079}, -- Rake, Rip
	},
	[250] = { 	-- BLOOD DK
		55078	-- 	Blood Plague
	},
	[252] = { 	-- Unholy DK
		191587,	-- 	Viralent Plague
		194310,	-- Festering Wound
	},
	[255] = {	-- SURVIVAL HUNTER
		185855,	-- 	Lacerate,
		259491	--  Serpent Sting
	},
	[63] = {	-- FIRE MAGE
		12846,	--	Mastery: Ignite
		12654	--	Ignite
	},
	[259] = {	-- ASSASSINATION ROGUE
		703,	--	Garrote
		1943,	--	Rupture
	},
	[261] = { 	-- SUBLETY ROGUE
		195452,	--	Nightblade
	},
	[262] = {	-- ELEMENTAL SHAMAN
		188389	--	Flame Shock
	},
	[263] = {	-- ENHANCE SHAMAN
		188389,	--	Flame Shock,
		334168, --  Lashing Flames
		{188389,334168} -- Flame Shock + Lashing Flames
	},
	[71] = {	-- ARMS WARRIOR
		262111,	--	Mastery: Deep Wounds
		262115	--  Deep Wounds
	},
	[269] = {		-- MONK (WW)
		228287	-- 	Mark of the Crane
	}
}