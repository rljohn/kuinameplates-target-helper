
-- Auras for DOT Tracking
-- https://wowpedia.fandom.com/wiki/SpecializationID
KuiTargetAuraList = {
	[256] = {	-- DISC PRIEST
		204213,	--	Purge the Wicked
		214621,	--	Schism
	},
	[257] = {	-- HOLY PRIEST
		589,	--  Shadow Word: Pain
		14914,  --  Holy Fire
		{589,14914} -- Holy Fire + Shadow Word: Pain
	},
	[258] = { 	-- SHADOW PRIEST
		{589,34914,335467}, -- Vampiric Touch + Shadow Word: Pain + Devouring Plague
		{589,34914}, -- Vampiric Touch + Shadow Word: Pain
		335467, -- Devouring Plague
		589,	-- Shadow Word: Pain
		34914, 	-- Vampiric Touch
	},
	[265] = {	-- AFFLICTION WARLOCK
		{146739,980,316099,48181}, -- Corruption + Agony + UA + Haunt
		{146739,980,316099}, -- Corruption + Agony + Unstable Affliction
		{146739,980,48181}, -- Corruption + Agony + Haunt
		{146739,980}, -- Corruption + Agony
		146739,	--	Corruption
		980,	--	Agony
		316099,	-- 	Unstable Affliction
		48181,	-- 	Haunt
		27243,	-- 	Seed of Corruption		
	},
	[266] = {	-- DEMONOLOGY WARLOCK
		423583, -- Doom Brand
	},
	[267] = {	-- DESTRUCTION WARLOCK
		157736,	-- Immolate
		80240,	-- Havoc
	},
	[102] = {	-- BALANCE DRUID
		{164815,164812,202347}, -- Moon Fire, Sunfire, Stellar Flare
		{164815,202347}, -- Moon Fire, Stellar Flare
		{164815,164812}, -- Moon Fire, Sunfire
		202347,	-- 	Stellar Flare
		164815,	--	Sunfire
		164812,	-- 	Moonfire
		{155722,1079}, -- Rake, Rip
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
	[105] = {	-- RESTO DRUID
		{164815,164812}, -- Moon Fire, Sunfire
		164812,	-- 	Moonfire
		164815,	--	Sunfire
		{155722,1079}, -- Rake, Rip
		155722,	-- 	Rake
		1079,	--	Rip
	},
	[250] = { 	-- BLOOD DK
		55078,	-- 	Blood Plague,
		391568,	--  Insidious Chill
	},
	[251] = { 	-- Frost DK
		391568,	--  Insidious Chill
	},
	[252] = { 	-- Unholy DK
		391568,	--  Insidious Chill
		191587,	-- 	Viralent Plague
		194310,	-- Festering Wound
	},
	[253] = {	-- BEAST MASTERY HUNTER
		217200,
	},
	[254] = {	-- MARKSMAN HUNTER
		271788,	-- Serpent Sting
		385638, -- Razor Fragments
		378015,	-- Latent Poison
	},
	[255] = {	-- SURVIVAL HUNTER
		271788,	--  Serpent Sting
		378015,	-- Latent Poison
	},
	[63] = {	-- FIRE MAGE
		12846,	--	Mastery: Ignite
		12654	--	Ignite
	},
	[64] = {	-- FROST MAGE
		228358,	--  Winter's Chill
	},
	[259] = {	-- ASSASSINATION ROGUE
		703,	--	Garrote
		1943,	--	Rupture
		{703,1943}, -- Garrote + Rupture
		394036,	-- Serrated Bone Spike
	},
	[261] = { 	-- SUBLETY ROGUE
		316220, -- Find Weakness
		1943,	-- Rupture
		385408, -- Sepsis
		384631, -- Flagellation
	},
	[262] = {	-- ELEMENTAL SHAMAN
		188389,	--	Flame Shock
		197209,	-- 	Lightning Rod
		382089,	-- 	Electrified Shocks
		{188389,197209}, -- Flame Shock + Lightning Rod
		{188389,382089}, -- Flame Shock + Electrified Shocks
		{188389,197209,382089} -- Flame Shock + Lightning Rod + Electrified Shocks

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
	[269] = {	-- MONK (WW)
		228287,	-- 	Mark of the Crane
		393050, -- Skytouch Exhaustion
	},
	[581] = {	-- DEMON HUNTER (VENGEANCE)
		207771	-- Fiery Brand
	},
	[65] = {	-- Paladin (HOLY)
		287280	-- Glimmer of Light
	}
}