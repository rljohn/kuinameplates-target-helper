PriorityInteruptCasts = {
	[167385] = true, -- Training Dummy, Uber Strike
}

MythicPlusTargets = {
	[1] = {
		name = "Mythic+",
		npcs = {
			-- 120651, -- Explosives
			-- 189706, -- Chaotic Essence
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

DragonFlightS4Targets =  {
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

WarWithinS1Targets = {
	[1] = {
		name = "Ara-Kara - The War Within - Season One",
		frontals = {
			218324, -- Nakt
			217533, -- Atik
			215405 -- Anub'zekt
		},
		notable = {
			213860, -- Stagshell
			223207 -- Black Blood
		},
		casters = {
			216293, -- Trilling Attendant
			217531 -- Ixin
		},
		cast_interrupt = {
			434802, -- Horrifying Shrill
			434793, -- Resonant Barrage
			433841, -- Venom Volley
			448239 -- Web Wrap
		},
		cast_heal = {
		},
		cast_stop = {
			432967, -- Alarm Shrill
			432031 -- Grasping Blood
		}
	},
	[2] = {
		name = "City of Threads - The War Within - Season One",
		frontals = {
			220197, -- Royal Swarmguard
			216619, -- Orator Krix'vizk
			220003, -- Eye of the Queen (Hollows Resident?)
			220423, -- Retired Lord Vul'azak
			216648, -- Nx
			216649, -- Vx
			220730, -- Venomshell
			216339 -- Sureki Unnaturaler
		},
		notable = {
		},
		casters = {
			220195, -- Sureki Silkbinder
			220196, -- Herald of Ansurek
			224732 -- Covert Webmancer
		},
		cast_interrupt = {
			443430, -- Silk Binding
			443433, -- Twist Thoughts
			442536 -- Grimweave Blast
		},
		cast_heal = {
			442536, -- Mending Web
		},
		cast_stop = {
		}
	},
	[3] = {
		name = "The Stonevault - The War Within - Season One",
		frontals = {
			210109, -- Earth Infused Golem
			213343, -- Forge Loader
			214264 -- Cursedforge Honor Guard
		},
		notable = {
			212453, -- Ghastly Voidsoul
			214287 -- Earth Burst Totem
		},
		casters = {
			212389, -- Cursedheart Invader
			214350, -- Turned Speaker
			221979, -- Void Bound Howler
			214066 -- Cursedforge Stoneshaper
		},
		cast_interrupt = {
			426283, -- Arcing Void
			429545, -- Censoring Gear
			449455 -- Howling Fear
		},
		cast_heal = {
			429109 -- Restoring Metals
		},
		cast_stop = {
			429427 -- Earth Burst Totem
		}
	},
	[4] = {
		name = "The Dawnbreaker - The War Within - Season One",
		frontals = {
			213934, -- Nightfall Tactician
			211263, -- Iken'tak
			211089 -- Anub'ikkaj
		},
		notable = {
			229451, -- Nightfall Darkcaster
		},
		casters = {
			213892, -- Nightfall Shadowmage
			214762, -- Nightfall Commander
			213932, -- Sureki Militant
		},
		cast_interrupt = {
			431309, -- Ensnaring Shadows
			450756, -- Abyssal Howl
		},
		cast_heal = {
			451097 -- Silken Shell
		},
		cast_stop = {
			432520 -- Umbral Barrier
		}
	},
	[5] = {
		name = "Mists of Tirna Scithe - The War Within - Season One",
		frontals = {
			165120, -- Tirnenn Villager
			173655, -- Mistveil Matriarch
		},
		notable = {
			166299, -- Mistveil Tender
			167111 -- Spinemaw Staghorn
		},
		casters = {
			164921, -- Drust Harvester
			166275 -- Mistveil Shaper
		},
		cast_interrupt = {
			322938, -- Harvest Essence
			324776, -- Bramblethorn Coat
			326046, -- Stimulate Resistance
		},
		cast_heal = {
			324914, -- Nourish the Forest
			340544 -- Stimulate Regeneration
		},
		cast_stop = {
		}
	},
	[6] = {
		name = "The Necrotic Wake - The War Within - Season One",
		frontals = {
			162691, -- Blightbone
			163621 -- Goregrind
		},
		notable = {
			165222, -- Zolramus Bonemender
			165872 -- Flesh Crafter
		},
		casters = {
			166302, -- Corpse Harvester
			165919, -- Skeletal Marauder
			173016 -- Corpse Collector
		},
		cast_interrupt = {
			334748, -- Drain Fluids
			324293, -- Rasping Scream
			338353 -- Goresplatter
		},
		cast_heal = {
			335143, -- Bonemend
			327127 -- Repair Flesh
		},
		cast_stop = {
			320822 -- Final Bargain
		}
	},
	[7] = {
		name = "Siege of Boralus - The War Within - Season One",
		frontals = {
			129374, -- Scrimshaw Enforcer
			129879, -- Irontide Cleaver
			129208, -- Dread Captain Lockwood
			130836, -- Hadal Darkfathom
			136549, -- Ashvane Cannoneer
		},
		notable = {
			144169 -- Ashvane Commander
		},
		casters = {
			135241, -- Bilge Rat Pillager
			129367 -- Bilge Rat Tempest
		},
		cast_interrupt = {
			256957, -- Watertight Shell
			275826, -- Bolstering Shout
			454440, -- Stinky Vomit
			272571 -- Choking Waters
		},
		cast_heal = {
		},
		cast_stop = {
		}
	},
	[8] = {
		name = "Grim Batol - The War Within - Season One",
		frontals = {
			224240, -- Flamerender
			40177, -- Forgemaster Throngus
			224249, -- Twilight Lavabender
			45992 -- Valiona
		},
		notable = {
		},
		casters = {
			224219, -- Twilight Earthcaller
			40167 -- Twilight Beguiler
		},
		cast_interrupt = {
			451871, -- Mass Tremor
			76711 -- Sear Mind
		},
		cast_heal = {
		},
		cast_stop = {
		}
	},
}


WarWithinS2MobClassifications = {
    [1] = {
        name = "Operation: Floodgate",
        classification_1 = {
            229251, -- Venture Co. Architect
            231197, -- Bubbles
            231325, -- Darkfuse Jumpstarter
        },
        classification_2 = {
            231176, -- Scaffolding
        },
        classification_3 = {
        },
        classification_4 = {
            230740, -- Shreddinator 3000
            230748, -- Darkfuse Bloodwarper
        },
        classification_5 = {
            228424, -- Darkfuse Mechadrone
            229069, -- Mechadrone Sniper
            229686, -- Venture Co. Surveyor
            231223, -- Disturbed Kelp
            231312, -- Venture Co. Electrician
            231380, -- Undercrawler
        },
        classification_6 = {
            229252, -- Darkfuse Hyena
            231496, -- Venture Co. Diver
        },
    },
    [2] = {
        name = "Priory of the Sacred Flame",
        classification_1 = {
            206696, -- Arathi Knight
            206704, -- Ardent Paladin
        },
        classification_2 = {
        },
        classification_3 = {
        },
        classification_4 = {
            211289, -- Taener Duelmal
            211290, -- Elaena Emberlanz
            211291, -- Sergeant Shaynemail
            212826, -- Guard Captain Suleyman
            212827, -- High Priest Aemya
            212831, -- Forge Master Damian
            217658, -- Sir Braunpyke
            239833, -- Elaena Emberlanz
            239834, -- Taener Duelmal
            239836, -- Sergeant Shaynemail
        },
        classification_5 = {
            206697, -- Devout Priest
        },
        classification_6 = {
            206698, -- Fanatical Conjuror
            221760, -- Risen Mage
        },
    },
    [3] = {
        name = "The Rookery",
        classification_1 = {
            212739, -- Radiating Voidstone
            212786, -- Voidrider
            214421, -- Coalescing Void Diffuser
        },
        classification_2 = {
        },
        classification_3 = {
        },
        classification_4 = {
            209801, -- Quartermaster Koratite
            212793, -- Void Ascendant
        },
        classification_5 = {
            207198, -- Cursed Thunderer
            207202, -- Void Fragment
            214439, -- Corrupted Oracle
        },
        classification_6 = {
            207199, -- Cursed Rooktender
        },
    },
    [4] = {
        name = "Darkflame Cleft",
        classification_1 = {
            208450, -- Wandering Candle
            210539, -- Corridor Creeper
            211121, -- Rank Overseer
            212411, -- Torchsnarl
            220616, -- Corridor Sleeper
        },
        classification_2 = {
            213751, -- Dynamite Mine Cart
        },
        classification_3 = {
        },
        classification_4 = {
            212412, -- Sootsnout
        },
        classification_5 = {
            210812, -- Royal Wicklighter
            213913, -- Kobold Flametender
        },
        classification_6 = {
            208456, -- Shuffling Horror
            210818, -- Lowly Moleherd
            211228, -- Blazing Fiend
            220815, -- Blazing Fiend
            223770, -- Blazing Fiend
            223772, -- Blazing Fiend
            223773, -- Blazing Fiend
            223774, -- Blazing Fiend
            223775, -- Blazing Fiend
            223776, -- Blazing Fiend
            223777, -- Blazing Fiend
        },
    },
    [5] = {
        name = "Cinderbrew Meadery",
        classification_1 = {
            210269, -- Hired Muscle
            220946, -- Venture Co. Honey Harvester
            223423, -- Careless Hopgoblin
        },
        classification_2 = {
            220368, -- Failed Batch
        },
        classification_3 = {
        },
        classification_4 = {
            214697, -- Chef Chewie
        },
        classification_5 = {
            220060, -- Taste Tester
            220141, -- Royal Jelly Purveyor
        },
        classification_6 = {
            210264, -- Bee Wrangler
            214673, -- Flavor Scientist
            218671, -- Venture Co. Pyromaniac
            222964, -- Flavor Scientist
        },
    },
    [6] = {
        name = "Theater of Pain",
        classification_1 = {
            162744, -- Nekthara the Mangler
            162763, -- Soulforged Bonereaver
            163086, -- Rancid Gasbag
            164451, -- Dessia the Decapitator
            167532, -- Heavin the Breaker
            167533, -- Advent Nevermore
            167534, -- Rek the Hardened
            167536, -- Harugia the Bloodthirsty
            167538, -- Dokigg the Brutalizer
            167998, -- Portal Guardian
        },
        classification_2 = {
        },
        classification_3 = {
        },
        classification_4 = {
            164506, -- Ancient Captain
            169893, -- Nefarious Darkspeaker
            169927, -- Putrid Butcher
            170234, -- Oppressive Banner
            170850, -- Raging Bloodhorn
            234443, -- Jundies
        },
        classification_5 = {
            160495, -- Maniacal Soulbinder
            164461, -- Sathel the Accursed
            166524, -- Deathwalker
            174197, -- Battlefield Ritualist
            174210, -- Blighted Sludge-Spewer
        },
        classification_6 = {
            164510, -- Shambling Arbalest
            169875, -- Shackled Soul
            170690, -- Diseased Horror
            170882, -- Bone Magus
        },
    },
    [7] = {
        name = "Operation: Mechagon",
        classification_1 = {
            144293, -- Waste Processing Unit
            144296, -- Spider Tank
            150160, -- Scrapbone Bully
            150253, -- Weaponized Crawler
            151476, -- Blastatron X-80
        },
        classification_2 = {
            189878, -- Nathrezim Infiltrator
        },
        classification_3 = {
            120651, -- Explosives
        },
        classification_4 = {
            144298, -- Defense Bot Mk III
            150146, -- Scrapbone Shaman
            150168, -- Toxic Monstrosity
            150292, -- Mechagon Cavalry
            151325, -- Alarm-o-Bot
            152033, -- Inconspicuous Plant
            154744, -- Toxic Monstrosity
            154758, -- Toxic Monstrosity
            190174, -- Hypnosis Bat
        },
        classification_5 = {
            144294, -- Mechagon Tinkerer
            150142, -- Scrapbone Trashtosser
            150165, -- Slime Elemental
            150250, -- Pistonhead Blaster
            151657, -- Bomb Tonk
            155090, -- Anodized Coilbearer
        },
        classification_6 = {
            144295, -- Mechagon Mechanic
            150143, -- Scrapbone Grinder
            150169, -- Toxic Lurker
            150251, -- Pistonhead Mechanic
            150297, -- Mechagon Renormalizer
        },
    },
    [8] = {
        name = "The MOTHERLODE!!",
        classification_1 = {
            130435, -- Addled Thug
            133430, -- Venture Co. Mastermind
            133463, -- Venture Co. War Machine
            134012, -- Taskmaster Askari
            136643, -- Azerite Extractor
        },
        classification_2 = {
        },
        classification_3 = {
        },
        classification_4 = {
            130485, -- Mechanized Peacekeeper
            136139, -- Mechanized Peacekeeper
        },
        classification_5 = {
            130635, -- Stonefury
            133432, -- Venture Co. Alchemist
            136470, -- Refreshment Vendor
        },
        classification_6 = {
            130661, -- Venture Co. Earthshaper
            134232, -- Hired Assassin
        },
    },
}
