local opt = KuiConfigTargetHelper

function opt:SetupLocale()

	local LOCALE = GetLocale()
	
	opt.titles = {
	
		-- main options
		TargetOptions = 'Nameplate Options',
		ColorTarget = 'Enable Target Color',
		ColorTargetTooltip = "Override the color of your target's health bar.",
		DisablePvP = "Disable colors in PvP",
		DisablePvPTooltip = "Disable target and debuff colors for player frames",
		NameText = "Name Color",
		NameTextTooltip = "Name text color will be updated for custom enemy colors. This is useful for tank mode and execute mode.",
		
		-- reset
		ResetAll = 'Reset',
		ResetTooltip = "Reset the |cff9966ffTarget Helper|r to base settings.",
		
		-- plugin priority
		PriorityText = "Plugin Priority",
		PriorityTooltip = "Plugins with a higher priority value will take precedence over lower priority plugins.",
		PriorityTankMode = "Set the priority for the Target Helper plugin.\n\nAny value over '5' will override KUI tank mode.\n\nAny value over '4' will override KUI execute mode.",
		
		-- cvar options
		CVarTitle = 'Nameplate CVars',
		CVarTitlePanel = 'Nameplate Console Variables',
		CVarTitleHeader = 'Modify console variables that change the behaviour of nameplates. Advanced users only.',
		EnableCVars = "Enable CVar Modification",
		EnableCVarsTooltip = "Enables the CVar panel, allowing KUI |cff9966ffTarget Helper|r to modify CVars.",
		
		-- profiles
		ProfilesTitle = 'Profile Settings',
		ProfilesHeader = "Select either per-character or per-account settings.",
		ProfilesInfo = "By default, each character will have their own configuration.\n\nYou can choose instead to share a configuration between all characters.",
		EnableGlobalData = "Enable Shared Settings",
		EnableGlobalDataTooltip = "When enabled, all characters will share the same global settings.",
		ImportExportTitle = 'Import / Export',
		ImportExportHeader = 'Save and load settings or share with others.',
		ImportExportInfo = 'Exporting will generate a string that you can use to share with others.',
		ImportExportInfo2 = "Enemy colors, debuff colors, unit renames and unit filters will be imported / exported.",
		ImportTitle = 'Import',
		ExportTitle = 'Export',
		ExportTooltip = 'Export to a string.',
		ImportTooltip = 'Import from a string.',
		
		-- borders
		BorderOptions = 'Border Options',

		-- elite border
		EnableEliteBorder = 'Enable Elite Border',
		EnableEliteBorderTooltip = 'Adds a border around Elite and Boss targets',
		EliteEdgeSize = "Width",
		EliteEdgeSizeTooltip = "Width of the elite border",

		-- focus border
		EnableFocusBorder = 'Enable Focus Border',
		EnableFocusBorderTooltip = 'Adds a border around Focus target',
		FocusEdgeSize = "Width",
		FocusEdgeSizeTooltip = "Width of the focus border",

		-- execute border
		EnableExecuteBorder = 'Enable Execute Border',
		EnableExecuteBorderTooltip = 'Adds a border around targets in execute range.\n\nYou must enable execute health bars in the KuiNameplates Core addon.',
		ExecuteEdgeSize = "Width",
		ExecuteEdgeSizeTooltip = "Width of the execute border",
		
		-- preferences
		PreferAura = "Prefer Debuff Colors over Target Color",
		PreferAuraTooltip = "When a target is debuffed, prefer to use the Debuff color over the Target color.",
		PreferAuraCustom = "Prefer Debuff Colors over Enemy Colors",
		PreferAuraCustomTooltip = "When a target is debuffed, prefer to use the Debuff color over the Custom Enemy color.",
		DisableAlpha = "Disable fade of tracked enemies",
		DisableAlphaTooltip = "Nameplates in your Enemy Color list will always be shown with full opacity.",
		
		-- custom target contexts
		ContextCustom = 'Custom',
		ContextBuiltIn = 'Default',
		ContextSLDungeons = 'Shadowlands Dungeons',
		ContextSLRaids = 'Shadowlands Raids',
		ClassAuras = 'Class Debuffs',
		ClassAurasNone = 'We do not currently support debuff colors for this talent specialization.\n\nIf you would like to request support for your class, please open an issue on Curseforge.',
		
		-- custom targets
		AddTarget = 'Add / Update Enemy',
		AddTargetTooltipTitle = "Add Enemy",
		AddTargetBtn = 'Apply',
		AddTargetBtnTooltip = "Add a new name to the enemy color list.\n\nIf this enemy already exists, it will be updated instead.",
		CustomColorTooltipTitle = "Custom Color",
		CustomColorTooltipText = "Select a color to apply to this enemy.",
		AddTargetTooltipText = "Enter the name of the enemy you wish to track and click 'Apply'.",
		RemoveTargetTooltip = 'Right click to remove this enemy.\nLeft click to modify.',
		EditTitle = "Edit Name",
		EditTooltip = "Change the name of this enemy.",
		CopyTarget = 'Copy Current Target',
		CopyTargetTooltip = 'Copy your current non-player target into the text box.',
		SavedColors = 'Saved Colors',
		SavedColor = 'Left click to select.\n\nRight click to modify.',
		
		-- names
		AddName = 'Custom Name',
		AddNameTooltipTitle = 'Custom Name',
		AddNameSourceTooltip = 'Enter the name of the enemy you wish to rename.',
		AddNameDestTooltip = 'Enter the new name for the enemy you wish to rename.',
		AddRename = 'Add Custom Name',
		AddNameEdit = 'Remove',

		-- custom target panel
		CustomTarget = 'Enemy Colors',
		CustomTargetHeader = "Configure custom colors to use for enemy nameplates based on their name.",
		
		-- class auras panel
		ClassAurasHeader = "Configure custom colors to use for enemy nameplates based on your debuffs.",
		SpellListWarning = 'This plugin only supports debuffs that are shown on KUI Nameplates.\n\nYou may need to download and configure KuiSpellListConfig to see them.',
		
		-- unit names panel
		UnitNamesTitle = "Rename Units",
		UnitNamesHeader = "Configure custom names for enemies to make them easier to identify in combat.",
		UnitNamesBtn = "Rename Unit",
		UnitNamesTxtOriginal = "Original:",
		UnitNamesTxtNew = "New:",
		
		-- unit filter panel
		UnitFilterTitle = "Unit Filter",
		UnitFilterHeader = "Configure a list of enemies which will have their nameplates automatically hidden.",
		UnitFilterTooltip = "Add the name of a unit to hide its name.",
		UnitFilterBtn = "Filter Unit",
		RemoveUnitTooltip = 'Right click to remove this unit.',
		
		-- footers
		ProfilesFooter = 'KuiNameplates: Target Helper (Profiles)',
		CustomTargetFooter = 'KuiNameplates: Target Helper (Enemy Colors)',
		ClassAurasFooter = "KuiNameplates: Target Helper (Debuff Colors)",
		UnitNamesFooter = "KuiNameplates: Target Helper (Rename Units)",
		UnitFilterFooter = "KuiNameplates: Target Helper (Unit Filter)",
		CVarsFooter  = 'KuiNameplates: Target Helper (Console Variables)',

		-- preset name lists

		ClearTargets = 'Clear Targets',
		ClearTargetsTooltip = 'Resets the enemy colors list.',
		
		SpecialTargets = 'Mythic+ and Raid Targets',
		SpecialTargetsTooltip = 'Explosive Orbs, Chaotic Essence, etc...',

		SeasonTooltip = 'Dragonflight: Season Three',
		SeasonTooltipText = 'Add enemies from Dragonflight Season Three dungeons',
	}
end

