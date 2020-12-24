local opt = KuiConfigTargetHelper

function SetupLocale()

	local LOCALE = GetLocale()

	if (LOCALE == "zhCN") then
		opt.titles =  {
			AddSLRaidTargets = "+  團隊目標",
			AddSLRaidTooltipText = "為|cff40c0f7暗影之境|r團隊加入重要目標。",
			AddSLTargets = "+ 暗影之境",
			AddSLTooltipText = "為|cffc8d975暗影之境|r資料片加入重要的目標。",
			AddSLTooltipTitle = "暗影之境目標",
			AddTarget = "加入目標",
			AddTargetBtnTooltip = "在當前目標清單加入一個目標。",
			AddTargetTooltipText = "輸入您想要追蹤的目標名稱然後點擊'加入目標'。",
			AddTargetTooltipTitle = "加入目標",
			ColorAuras = "啟用光環顏色",
			ColorAurasTooltip = "覆蓋敵對的顏色當有您職業施加的減益。",
			ColorAurasTooltip2 = "|cff9966ff注意:|r 此功能並非執行在所有職業。",
			ColorTarget = "啟用目標顏色",
			ColorTargetTooltip = "覆蓋您目標的血量條的顏色。",
			ContextCustom = "自訂",
			ContextSLDungeons = "暗影之境地下城",
			ContextSLRaids = "暗影之境團隊副本",
			CustomColorTooltipText = "為自訂目標選擇一種顏色。",
			CustomColorTooltipTitle = "自訂顏色",
			CustomTarget = "自訂目標顏色",
			CVarTitle = "名條CVars參數",
			EditTitle = "編輯目標",
			EditTooltip = "更改此目標的名稱",
			EnableCVars = "啟用CVar參數修改",
			EnableCVarsTooltip = "啟用CVar面板，允許KUI |cff9966ffTarget Helper|r來修改CVar參數。",
			EnableEliteBorder = "啟用精英外框",
			EnableEliteBorderTooltip = "在首領與精英目標周圍加入一個外框",
			EnlargeTarget = "放大目標框架",
			EnlargeTargetTooltip = "依照百分比縮放目標框架。",
			OtherOptions = "其他選項",
			RemoveTargetTooltip = "右鍵點擊來移除此目標。",
			ResetAll = "重置",
			ResetTooltip = "重置 |cff9966ffTarget Helper|r 回基礎設置。",
			TargetOptions = "目標選項",
			TargetScale = "目標框架縮放",
		}
	end
	
end

