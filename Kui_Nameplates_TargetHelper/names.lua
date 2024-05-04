PriorityInteruptCasts = {
	[167385] = true, -- Training Dummy, Uber Strike
}

MythicPlusTargets = {
	[1] = {
		name = "Mythic+",
		npcs = {
			120651, -- Explosives
			189706, -- Chaotic Essence
			174773, -- Spiteful Shade
		},
	},
}

DragonFlightS1Targets = {
	
	[1] = {
		name = "Algeth'ar Academy - Dragonflight Season One",
		npcs = {
			196671, -- Arcane Ravager
			192680, -- Guardian Sentry
			192333, -- Alpha Eagle
			196200, -- Algeth'ar Echoknight
		},
	},
	[2] = {
		name = "The Nokhud Offensive - Dragonflight Season One",
		npcs = {
			192796, -- Nokhud Hornsounder
			192800, -- Nokhud Lancemaster
			194897, -- Stormsurge Totem
			195877, -- Risen Mystic
			193462, -- Batak
		},
	},
	[3] = {
		name = "The Azure Vault - Dragonflight Season One",
		npcs = {
			196115, -- Arcane Tender
			187160, -- Crystal Fury
		},
	},
	[4] = {
		name = "Ruby Life Pools - Dragonflight Season One",
		npcs = {
			188067, -- Flashfrost Chillweaver
			197698, -- Thunderhead
			197985, -- Flame Channeler
		},
	},
	[5] = {
		name = "Court of Stars - Dragonflight Season One",
		npcs = {
			104251,	-- Duskwatch Sentry
			104247,	-- Duskwatch Arcanist
			104278, -- Felbound Enforcer
		},
	},
	[6] = {
		name = "Halls of Valor - Dragonflight Season One",
		npcs = {
			95834,	-- Valarjar Mystic
			101637,	-- Valarjar Aspirant
		},
	},
	[7] = {
		name = "Shadowmoon Burial Grounds - Dragonflight Season One",
		npcs = {
			75713,	-- Shadowmoon Bone-Mender
			75652,	-- Void Spawn
			77700,	-- Shadowmoon Exhumer
			76104,  -- Monstrous Corpse Spider
		},
	},
	[8] = {
		name = "Temple of the Jade Serpent - Dragonflight Season One",
		npcs = {
			59873,	-- Corrupt Living Water
			59546,	-- The Talking Fish
			200131,	-- Sha-Touched Guardian
		},
	},
}

DragonFlightS2Targets = {
	[1] = {
		name = "Halls of Infusion",
		scary_npcs = {
			190371, -- Primalist Earthshaker
		},
		notable = {
			190342, -- Containment Apparatus
		},
		casters = {
			190345, -- Primalist Geomancer
			190377, -- Primalist Icecaller
			190373, -- Primalist Galesinger
		}
	},
	[2] = {
		name = "Brackenhide Hollow",
		scary_npcs = {
			195135, -- Bracken Warscourge
			186208, -- Rotbow Stalker
			187033, -- Stinkbreath
			186229, -- Wilted Oak
			186226, -- Fetid Rotsinger
		},
		notable = {
			193799, -- Rotchanting Totem
			190426, -- Decay Totem
		},
		casters = {
			185534, -- Bonebolt Hunter
			186191, -- Decay Speaker
			185528, -- Trickclaw mystic
			185656, -- Filth Caller
			187224, -- Vile Rothexer
		}
	},
	[3] = {
		name = "Uldaman",
		scary_npcs = {
			184020, -- Hulking Berserker
			184300, -- Ebonstone Golem
		},
		casters = {
			184022, -- Stonevault Geomancer
			186420, -- Earthen Weaver
		}
	},
	[4] = {
		name = "Neltharus",
		scary_npcs = {
			189235, -- Overseer Lahar
			189464, -- Qalashi Irontorch
			189466, -- Irontorch Commander
		},
		casters = {
			189265, -- Qalashi Bonetender
			192788, -- Qalashi Thaumaturge
		}
	},
	[5] = {
		name = "Neltharion's Lair",
		scary_npcs = {
			91006, -- Rockback Gnasher
			90997, -- Mightstone Breaker
			113537, -- Emberhusk Dominator
		},
		notable = {
			92610, -- Understone Drummer
			94869, -- Tarspitter Grub
		},
		casters = {
			90998, -- Blightshard Shaper
			102232, -- Rockbound Trapper
		}
	},
	[6] = {
		name = "Freehold",
		scary_npcs = {
			129602, -- Irontide Enforcer
			130400, -- Irontide Crusher
		},
		notable = {
			130012, -- Irontide Ravager
		},
		casters = {
			127111, -- Irontide Oarsman
			129547, -- Blacktooth Knuckleduster
			126919, -- Irontide Stormcaller
		}
	},
	[7] = {
		name = "The Underrot",
		scary_npcs = {
			131436, -- Chosen Blood Matron
			133870, -- Diseased Lasher
		},
		notable = {
			133685, -- Befouled Spirit
			133835, -- Feral Bloodswarmer
			134284 -- Fallen Deathspeaker
		},
		casters = {
			131492, -- Devout Blood Priest
			133852, -- Living Rot
			133912, -- Bloodsworn Defiler
		}
	},
	[8] = {
		name = "Vortex Pinnacle",
		scary_npcs = {
			45928, -- Executor of the Caliph
		},
		notable = {
			45935, -- Temple Adept
		},
		casters = {
			45912, -- Wind Vortex
			45930, -- Minister of Air
		}
	}
}

DragonFlightS3Targets = {
	[1] = {
		name = "Atal'Dazar",
		frontal = {
			128455 -- T'lonja
		},
		interupt = {
			122973, -- Dazar'ai Confessor
			122969, -- Zanchuli Witch-Doctor
			128434, -- Feasting Skyscreamer

		},
		cc = {
			127879 -- Shieldbearer of Zul
		},
		cast_interrupt = {
			253544, -- Bwonsamdi's Mantle (Dazar'ai Confessor)
			253583, -- Fiery Enchant (Dazar'ai Augur)
			255041, -- Terrifying Screech (Feasting Skyscreamer)
			252781, -- Unstable Hex (Zanchuli Witch-Doctor)
		},
		cast_heal = {
			253517, -- Mending Word (Dazar'ai Confessor)
			256849, -- Dino Might (Dinomancer Kish'o)
		}
	},
	[2] = {
		name = "Darkheart Thicket",
		frontal = {
			95766, -- Crazed Razorbeak
			113398, -- Bloodtainted Fury
		},
		interupt = {
			95769, -- Mindshattered Screecher
			101991, -- Nightmare Dweller
			100532, -- Bloodtainted Burster
			100527, -- Dreadfire Imp
		},
		cc = {
		},
		cast_interrupt = {
			200658, -- Star Shower (Dreadsoul Ruiner)
			204243, -- Tormenting Eye (Nightmare Dweller)
			225562, -- Blood Metamorphosis (Bloodtainted Fury)
			225568, -- Curse of Isolation (Taintheart Summoner)
			201399, -- Dread Inferno (Dreadfire Imp)
		}
	},
	[3] = {
		name = "Waycrest Manor",
		frontal = {
			-- Bewitched Captain
		},
		interupt = {
			131685, -- Runic Disciple
			135049, -- Dreadwing Raven
			131812, -- Heartsbane Soulcharmer
			137830, -- Pallid Gorger
			134024, -- Devouring Maggot
			135365, -- Matron Alma
			131821, -- Faceless Maiden
			144324 -- Gorak Tul
		},
		cc = {
			131587 -- Deathtouched Slayer
		},
		cast_interrupt = {
			265368, -- Spirited Defense (Bewitched Captain)
			264050, -- Infected Thorn (Coven Thornshaper, Thistle Acolyte)
			263959, -- Soul Volley (Heartsbane Soulcharmer)
			265346, -- Pallid Glare (Dreadwing Raven)
			278444, -- Infest (Devouring Maggot)
			264407, -- Horrific Visage (Faceless Maiden)
			265876, -- Ruinous Volley (Matron Alma, Matron Christiane)
		},
		cast_stop = {

		}
	},
	[4] = {
		name = "Everbloom",
		frontal = {
			81522, -- Witherbark
			83846 -- Yalnu
		},
		interupt = {
			81819, -- Everbloom Naturalist
			81985, -- Everbloom Mender
			84957, -- Putrid Pyromancer
		},
		cc = {
		},
		cast_interrupt = {
			164965, -- Choking Vines (Everbloom Mender, Everbloom Naturalist)
			169839, -- Pyroblast (Putrid Pyromancer)
		},
		cast_heal = {
			164887, -- Healing Waters (Everbloom Mender)
		}
	},
	[5] = {
		name = "Throne of the Tides",
		frontal = {
			212673, -- Naz'jar Ravager
		},
		interupt = {
			41096, -- Naz'jar Oracle
		},
		cc = {
			40935, -- Gilgolbin Hunter
		},
		cast_interupt = {
			76820, -- Hex (Naz'jar Oracle)
		},
		cast_heal = {
			76813, -- Healing Wave (Naz'jar Oracle)
		}
	},
	[6] = {
		name = "Black Rook Hold",
		frontal = {
			98243, -- Soul-Torn Champion
			100485, -- Soul-Torn Vanguard
			98792, -- Wyrmtongue Scavenger
		},
		interupt = {
			102788, -- Felspite Dominator
		},
		cc = {
			98691, -- Risen Scout
			98275, -- Risen Archer
			98792, -- Wyrmtongue Scavenger
		},
		cast_interrupt = {
			243369, -- Drain Life (Bloodscent Felhound)
			227913, -- Felfrenzy (Felspite Dominator)
		},
		cast_stop = {
			200084, -- Soul Blade (Ghostly Retainer)
			200291, -- Knife Dance (Risen Scout)
		}
	},
	[7] = {
		name = "Galakrond's Fall",
		frontal = {
			199749, -- Timestream Anomaly
			201790, -- Loszkeleth
		},
		interupt = {
			206140, -- Coalesced Time
			206066, -- Timestream Leech
		},
		cc = {
			205408, -- Infinite Timeslicer
		},
		cast_interrupt = {
			415770, -- Infinite Bolt Volley (Coalesced Time)
			415437, -- Enervate (Timestream Leech)
		},
		cast_stop = {
			412012, -- Temposlice (Infinite Timeslicer)
		}
	},
	[8] = {
		name = "Murozond's Rise",
		frontal = {
			205152, -- Lerai, Timesworn Maiden
			205158, -- Spurlok, Timesworn Sentinel
			205151, -- Tyr's Vanguard
			208438, -- Infinite Saboteur
			208440, -- Infinite Slayer
		},
		interupt = {
			199748, -- Timeline Marauder
			208698, -- Infinite Riftmage
			205363, -- Time-Lost Waveshaper
			205337, -- Infinite Timebender
			205727, -- Time-Lost Rocketeer
			204206, -- Horde Farseer
		},
		cc = {
			201223, -- Infinite Twilight Magus
			205723 -- Time-Lost Aerobot
		},
		cast_interupt = {
			413607, -- Corroding Volley (Infinite Twilight Magus)
			412922, -- Binding Grasp (Spurlok, Timesworn Sentinel)
			417481, -- Displace Chronosequence (Timeline Marauder)
			411300, -- Fish Bolt Volley (Time-Lost Waveshaper)
		},
		cast_stop = {
		}
	}
}

DragonFlightS4Targets = 
{
	[1] = {
		name = "Algeth'ar Academy - Dragonflight Season Four",
		scary_npcs = {
			196671, -- Arcane Ravager
			192680, -- Guardian Sentry
			192333, -- Alpha Eagle
			196200, -- Algeth'ar Echoknight
		},
	},
	[2] = {
		name = "The Nokhud Offensive - Dragonflight Season Four",
		scary_npcs = {
			192800, -- Nokhud Lancemaster
			193462, -- Batak
		},
		casters = {
			195877, -- Risen Mystic
		},
		notable = {
			192796, -- Nokhud Hornsounder
			194897, -- Stormsurge Totem
		},
	},
	[3] = {
		name = "The Azure Vault - Dragonflight Season Four",
		scary_npcs = {
			187160, -- Crystal Fury
		},
		casters = {
			196115, -- Arcane Tender
		}
	},
	[4] = {
		name = "Ruby Life Pools - Dragonflight Season Four",
		scary_npcs = {
			188067, -- Flashfrost Chillweaver
			197698, -- Thunderhead
			197985, -- Flame Channeler
		},
	},
	[5] = {
		name = "Neltharus - Dragonflight Season Four",
		scary_npcs = {
			189235, -- Overseer Lahar
			189464, -- Qalashi Irontorch
			189466, -- Irontorch Commander
		},
		casters = {
			189265, -- Qalashi Bonetender
			192788, -- Qalashi Thaumaturge
		}
	},
	[6] = {
		name = "Neltharion's Lair - Dragonflight Season Four",
		scary_npcs = {
			91006, -- Rockback Gnasher
			90997, -- Mightstone Breaker
			113537, -- Emberhusk Dominator
		},
		notable = {
			92610, -- Understone Drummer
			94869, -- Tarspitter Grub
		},
		casters = {
			90998, -- Blightshard Shaper
			102232, -- Rockbound Trapper
		}
	},
	[7] = {
		name = "Brackenhide Hollow - Dragonflight Season Four",
		scary_npcs = {
			195135, -- Bracken Warscourge
			186208, -- Rotbow Stalker
			187033, -- Stinkbreath
			186229, -- Wilted Oak
			186226, -- Fetid Rotsinger
		},
		notable = {
			193799, -- Rotchanting Totem
			190426, -- Decay Totem
		},
		casters = {
			185534, -- Bonebolt Hunter
			186191, -- Decay Speaker
			185528, -- Trickclaw mystic
			185656, -- Filth Caller
			187224, -- Vile Rothexer
		}
	},
	[8] = {
		name = "Uldaman - Dragonflight Season Four",
		scary_npcs = {
			184020, -- Hulking Berserker
			184300, -- Ebonstone Golem
		},
		casters = {
			184022, -- Stonevault Geomancer
			186420, -- Earthen Weaver
		}
	}
}