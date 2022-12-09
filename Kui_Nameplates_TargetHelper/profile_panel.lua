local addon = KuiNameplates
local opt = KuiConfigTargetHelper
local mod = KuiConfigTargetHelperMod

local LibSerialize = LibStub("LibSerialize")
local LibDeflate = LibStub("LibDeflate")

local import_export_version = 1
local import_export_identifier = 'kth-data'

local messageid = 0

local function ShowStatus(text)
	opt.ui.import_export_status:SetText(text)

	-- if multiple messages show, the 'after' function only deletes the most recent
	messageid = messageid + 1
	local my_message_id = messageid

	C_Timer.After(5, function() 
		if (messageid == my_message_id) then
			opt.ui.import_export_status:SetText('')
		end
	end)
end

local function ExportSettings()

	local data = {}
	data.version = import_export_version
	data.id = import_export_identifier
	data.targets = opt.env.CustomTargets
	data.renames = opt.env.Renames
	data.auras = opt.env.CustomAuraColors
	data.filters = opt.env.FilterTargets

	local serialized = LibSerialize:Serialize(data)
    local compressed = LibDeflate:CompressDeflate(serialized)
    local encoded = LibDeflate:EncodeForPrint(compressed)

	opt.ui.import_export_box:SetText(encoded)
	opt.ui.import_export_box:HighlightText(0)

	ShowStatus("Successfully exported profile")

end

local function ImportSettings()

	local text = opt.ui.import_export_box:GetText()
	if not text or text == "" then 
		ShowStatus("Failed to import profile, no data.")
		return 
	end

	local decoded = LibDeflate:DecodeForPrint(text)
	local uncompressed = LibDeflate:DecompressDeflate(decoded)
	local result, data = LibSerialize:Deserialize(uncompressed)

	if (not result) then
		ShowStatus("Failed to import profile, invalid data.")
		return
	end

	if (data.version ~= import_export_version) then
		ShowStatus("Failed to import profile, invalid version.")
		return
	end

	if (data.id ~= import_export_identifier) then
		ShowStatus("Failed to import profile, invalid identifier.")
		return
	end

	local dialog = StaticPopup_Show("KUI_TargetHelper_ImportConfirm", data)
	dialog.data = data
end

local function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
  end

function mod:ImportProfileData(data)

	if (not data) then 
		ShowStatus("No profile data to import.")
		return 
	end

	opt.env.CustomTargets = data.targets
	opt.env.Renames = data.renames
	opt.env.CustomAuraColors = data.auras
	opt.env.FilterTargets = data.filters
	rlPrintf("Imported %d enemy colors.", tablelength(opt.env.CustomTargets))
	rlPrintf("Imported %d unit renames.", tablelength(opt.env.Renames))
	rlPrintf("Imported %d debuff colors.", tablelength(opt.env.CustomAuraColors))
	rlPrintf("Imported %d filtered units.", tablelength(opt.env.FilterTargets))

	mod:RefreshCustomTargets()
	mod:RefreshClassAuras()
	mod:RefreshRenameTargets()
	mod:RefreshFilterTargets()

	opt:EvaluateFilter()
	opt:ResetFrames()

	ShowStatus("Successfully imported profile.")
end

function mod:AddProfileWidgets(menu, parent, subpanel)

	-- profile management

	local global_info = parent:CreateFontString(nil, 'ARTWORK', 'GameFontWhite')
	global_info:SetText(opt.titles["ProfilesInfo"])
	global_info:SetJustifyH("LEFT")
	global_info:SetPoint('BOTTOMLEFT', parent, 'TOPLEFT', 4, -40)

    opt.ui.EnableGlobalData = opt:CreateCheckBox(parent, 'EnableGlobalData')
	opt.ui.EnableGlobalData:SetPoint("TOPLEFT", global_info, "BOTTOMLEFT", 0, -8)
	opt:AddTooltip(opt.ui.EnableGlobalData, opt.titles.EnableGlobalData, opt.titles.EnableGlobalDataTooltip)

	-- import/export

    local editBox = CreateFrame("EditBox", nil, subpanel.panel)
	editBox:SetSize(570,150)
	editBox:SetPoint("TOPLEFT", subpanel.panel, "TOPLEFT")
	editBox:SetFontObject('ChatFontNormal')
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(16384)
	editBox:SetCursorPosition(0)
	editBox:SetAutoFocus(false)
	editBox:SetJustifyH("LEFT")
	editBox:SetJustifyV("MIDDLE")
	editBox:SetTextInsets(10, 10, 10, 10)
    opt.ui.import_export_box = editBox

	editBox:SetScript('OnEscapePressed', function(self)
		editBox:ClearFocus()
		editBox:HighlightText(0,0)
	end)

	local status = subpanel:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
	status:SetText('')
	status:SetPoint('TOPLEFT', subpanel, 'BOTTOMLEFT', 8, -16)
	opt.ui.import_export_status = status

    opt.ui.export_button = opt:CreateButton(subpanel, nil, 100, 30, opt.titles.ExportTitle)
	opt.ui.export_button:SetPoint("TOPLEFT", subpanel, "BOTTOMLEFT", 400, -16)
	opt.ui.export_button:SetScript("OnClick", function(self, event, ...)
            ExportSettings()
		end)
	opt:AddTooltip(opt.ui.export_button, opt.titles.ExportTitle, opt.titles.ExportTooltip)

    opt.ui.import_button = opt:CreateButton(subpanel, nil, 100, 30, opt.titles.ImportTitle)
	opt.ui.import_button:SetPoint("TOPLEFT", opt.ui.export_button, "TOPRIGHT", 8, 0)
	opt.ui.import_button:SetScript("OnClick", function(self, event, ...)
            local text = editBox:GetText()
            ImportSettings(text)
		end)
	opt:AddTooltip(opt.ui.import_button, opt.titles.ImportTitle, opt.titles.ImportTooltip)
end