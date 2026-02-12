-- =============================================================================
-- Configuration System
-- =============================================================================

-- Default settings
local DEFAULTS = {
    turtlogsCompatibility = true,
    autoCombatLogToggle = true,
    disableCombatlogReminder = false,
    debugMode = false,
    debugChatFrame = 1,
    combatLogRangeDefault = 40,
    combatLogRangeInstance = 200,
}

-- =============================================================================
-- SavedVariables Management
-- =============================================================================

function Chronicle:InitializeConfig()
    -- Initialize saved variables with defaults
    if not ChronicleCompanionDB then
        ChronicleCompanionDB = {}
    end
    
    -- Merge defaults (preserves existing values, adds missing ones)
    for key, value in pairs(DEFAULTS) do
        if ChronicleCompanionDB[key] == nil then
            ChronicleCompanionDB[key] = value
        end
    end
end

function Chronicle:GetSetting(key)
    if ChronicleCompanionDB and ChronicleCompanionDB[key] ~= nil then
        return ChronicleCompanionDB[key]
    end
    return DEFAULTS[key]
end

function Chronicle:SetSetting(key, value)
    if not ChronicleCompanionDB then
        ChronicleCompanionDB = {}
    end
    ChronicleCompanionDB[key] = value
end

-- =============================================================================
-- Debug Output
-- =============================================================================

function Chronicle:DebugPrint(msg)
    if not self:GetSetting("debugMode") then
        return
    end
    
    local frameIndex = self:GetSetting("debugChatFrame") or 1
    local frame = getglobal("ChatFrame" .. frameIndex)
    if not frame then
        frame = DEFAULT_CHAT_FRAME
    end
    
    frame:AddMessage("|cff88ffff[Chronicle Debug]|r " .. tostring(msg))
end

-- =============================================================================
-- Options Panel UI (Vanilla-compatible standalone frame)
-- =============================================================================

function Chronicle:CreateOptionsPanel()
    -- Main frame
    local panel = CreateFrame("Frame", "ChronicleOptionsPanel", UIParent)
    panel:SetWidth(350)
    panel:SetHeight(470)
    panel:SetPoint("CENTER", 0, 0)
    panel:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    panel:SetMovable(true)
    panel:EnableMouse(true)
    panel:RegisterForDrag("LeftButton")
    panel:SetScript("OnDragStart", function() this:StartMoving() end)
    panel:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
    panel:Hide()
    
    -- Close button
    local closeButton = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", -5, -5)
    
    -- Title
    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -20)
    title:SetText("ChronicleCompanion Options")
    
    -- Subtitle
    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    subtitle:SetPoint("TOP", title, "BOTTOM", 0, -4)
    subtitle:SetText("Configure combat logging behavior")
    
    local yOffset = -65
    
    -- =============================================================================
    -- Checkbox: Turtlogs Compatibility
    -- =============================================================================
    local turtlogsCheck = CreateFrame("CheckButton", "ChronicleOptionsTurtlogs", panel, "UICheckButtonTemplate")
    turtlogsCheck:SetPoint("TOPLEFT", 20, yOffset)
    getglobal(turtlogsCheck:GetName() .. "Text"):SetText("Turtlogs Compatibility")
    turtlogsCheck:SetChecked(self:GetSetting("turtlogsCompatibility"))
    turtlogsCheck:SetScript("OnClick", function()
        Chronicle:SetSetting("turtlogsCompatibility", this:GetChecked() == 1)
    end)
    
    local turtlogsDesc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    turtlogsDesc:SetPoint("TOPLEFT", turtlogsCheck, "BOTTOMLEFT", 26, 2)
    turtlogsDesc:SetText("Keep enabled for Turtlogs upload support.")
    turtlogsDesc:SetTextColor(0.5, 0.5, 0.5)
    
    yOffset = yOffset - 45
    
    -- =============================================================================
    -- Checkbox: Automatic Combat Log Toggle
    -- =============================================================================
    local autoLogCheck = CreateFrame("CheckButton", "ChronicleOptionsAutoLog", panel, "UICheckButtonTemplate")
    autoLogCheck:SetPoint("TOPLEFT", 20, yOffset)
    getglobal(autoLogCheck:GetName() .. "Text"):SetText("Automatic Combat Log Toggle")
    autoLogCheck:SetChecked(self:GetSetting("autoCombatLogToggle"))
    autoLogCheck:SetScript("OnClick", function()
        Chronicle:SetSetting("autoCombatLogToggle", this:GetChecked() == 1)
    end)
    
    local autoLogDesc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    autoLogDesc:SetPoint("TOPLEFT", autoLogCheck, "BOTTOMLEFT", 26, 2)
    autoLogDesc:SetText("Auto-enable logging when entering instances.")
    autoLogDesc:SetTextColor(0.5, 0.5, 0.5)
    
    yOffset = yOffset - 45
    
    -- =============================================================================
    -- Checkbox: Disable Combat Log Reminder
    -- =============================================================================
    local disableReminderCheck = CreateFrame("CheckButton", "ChronicleOptionsDisableReminder", panel, "UICheckButtonTemplate")
    disableReminderCheck:SetPoint("TOPLEFT", 20, yOffset)
    getglobal(disableReminderCheck:GetName() .. "Text"):SetText("Disable Combat Log Reminder")
    disableReminderCheck:SetChecked(self:GetSetting("disableCombatlogReminder"))
    disableReminderCheck:SetScript("OnClick", function()
        Chronicle:SetSetting("disableCombatlogReminder", this:GetChecked() == 1)
    end)
    
    local disableReminderDesc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    disableReminderDesc:SetPoint("TOPLEFT", disableReminderCheck, "BOTTOMLEFT", 26, 2)
    disableReminderDesc:SetText("Suppress the instance entry popup.")
    disableReminderDesc:SetTextColor(0.5, 0.5, 0.5)
    
    yOffset = yOffset - 45
    
    -- =============================================================================
    -- Checkbox: Debug Mode
    -- =============================================================================
    local debugCheck = CreateFrame("CheckButton", "ChronicleOptionsDebug", panel, "UICheckButtonTemplate")
    debugCheck:SetPoint("TOPLEFT", 20, yOffset)
    getglobal(debugCheck:GetName() .. "Text"):SetText("Debug Mode")
    debugCheck:SetChecked(self:GetSetting("debugMode"))
    debugCheck:SetScript("OnClick", function()
        Chronicle:SetSetting("debugMode", this:GetChecked() == 1)
    end)
    
    local debugDesc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    debugDesc:SetPoint("TOPLEFT", debugCheck, "BOTTOMLEFT", 26, 2)
    debugDesc:SetText("Show debug statistics and output.")
    debugDesc:SetTextColor(0.5, 0.5, 0.5)
    
    yOffset = yOffset - 45
    
    -- =============================================================================
    -- Dropdown: Debug Chat Window
    -- =============================================================================
    local debugChatLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    debugChatLabel:SetPoint("TOPLEFT", 20, yOffset)
    debugChatLabel:SetText("Debug Output Window:")
    
    local debugChatDropdown = CreateFrame("Frame", "ChronicleOptionsDebugChat", panel, "UIDropDownMenuTemplate")
    debugChatDropdown:SetPoint("TOPLEFT", debugChatLabel, "BOTTOMLEFT", -15, -2)
    
    local function GetChatWindowName(index)
        local tab = getglobal("ChatFrame" .. index .. "Tab")
        if tab then
            return tab:GetText() or ("Chat " .. index)
        end
        return "Chat " .. index
    end
    
    local function DebugChatDropdown_Initialize()
        for i = 1, NUM_CHAT_WINDOWS do
            local frame = getglobal("ChatFrame" .. i)
            if frame then
                local info = {}
                info.text = GetChatWindowName(i)
                info.value = i
                info.func = function()
                    Chronicle:SetSetting("debugChatFrame", this.value)
                    UIDropDownMenu_SetSelectedValue(debugChatDropdown, this.value)
                    UIDropDownMenu_SetText(GetChatWindowName(this.value), debugChatDropdown)
                end
                info.checked = (Chronicle:GetSetting("debugChatFrame") == i)
                UIDropDownMenu_AddButton(info)
            end
        end
    end
    
    UIDropDownMenu_Initialize(debugChatDropdown, DebugChatDropdown_Initialize)
    UIDropDownMenu_SetWidth(150, debugChatDropdown)
    UIDropDownMenu_SetSelectedValue(debugChatDropdown, self:GetSetting("debugChatFrame"))
    UIDropDownMenu_SetText(GetChatWindowName(self:GetSetting("debugChatFrame")), debugChatDropdown)
    
    yOffset = yOffset - 55
    
    -- =============================================================================
    -- Separator: Combat Log Range
    -- =============================================================================
    local separator = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    separator:SetPoint("TOPLEFT", 20, yOffset)
    separator:SetText("Combat Log Range")
    
    local separatorDesc = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    separatorDesc:SetPoint("TOPLEFT", separator, "BOTTOMLEFT", 0, -4)
    separatorDesc:SetText("Higher range = more complete logs (max 200).")
    separatorDesc:SetTextColor(0.5, 0.5, 0.5)
    
    yOffset = yOffset - 50
    
    -- =============================================================================
    -- Slider: Default Range
    -- =============================================================================
    local defaultRangeSlider = CreateFrame("Slider", "ChronicleOptionsDefaultRange", panel, "OptionsSliderTemplate")
    defaultRangeSlider:SetPoint("TOPLEFT", 25, yOffset)
    defaultRangeSlider:SetWidth(200)
    defaultRangeSlider:SetMinMaxValues(10, 200)
    defaultRangeSlider:SetValueStep(10)
    defaultRangeSlider:SetValue(self:GetSetting("combatLogRangeDefault"))
    getglobal(defaultRangeSlider:GetName() .. "Low"):SetText("10")
    getglobal(defaultRangeSlider:GetName() .. "High"):SetText("200")
    getglobal(defaultRangeSlider:GetName() .. "Text"):SetText("Default: " .. self:GetSetting("combatLogRangeDefault") .. " yards")
    
    defaultRangeSlider:SetScript("OnValueChanged", function()
        local value = math.floor(this:GetValue())
        Chronicle:SetSetting("combatLogRangeDefault", value)
        getglobal(this:GetName() .. "Text"):SetText("Default: " .. value .. " yards")
    end)
    
    yOffset = yOffset - 45
    
    -- =============================================================================
    -- Slider: Instance Range
    -- =============================================================================
    local instanceRangeSlider = CreateFrame("Slider", "ChronicleOptionsInstanceRange", panel, "OptionsSliderTemplate")
    instanceRangeSlider:SetPoint("TOPLEFT", 25, yOffset)
    instanceRangeSlider:SetWidth(200)
    instanceRangeSlider:SetMinMaxValues(10, 200)
    instanceRangeSlider:SetValueStep(10)
    instanceRangeSlider:SetValue(self:GetSetting("combatLogRangeInstance"))
    getglobal(instanceRangeSlider:GetName() .. "Low"):SetText("10")
    getglobal(instanceRangeSlider:GetName() .. "High"):SetText("200")
    getglobal(instanceRangeSlider:GetName() .. "Text"):SetText("In Instance: " .. self:GetSetting("combatLogRangeInstance") .. " yards")
    
    instanceRangeSlider:SetScript("OnValueChanged", function()
        local value = math.floor(this:GetValue())
        Chronicle:SetSetting("combatLogRangeInstance", value)
        getglobal(this:GetName() .. "Text"):SetText("In Instance: " .. value .. " yards")
    end)
    
    -- Store references for refreshing
    panel.turtlogsCheck = turtlogsCheck
    panel.autoLogCheck = autoLogCheck
    panel.disableReminderCheck = disableReminderCheck
    panel.debugCheck = debugCheck
    panel.debugChatDropdown = debugChatDropdown
    panel.defaultRangeSlider = defaultRangeSlider
    panel.instanceRangeSlider = instanceRangeSlider
    
    self.optionsPanel = panel
    
    -- Close on Escape
    tinsert(UISpecialFrames, "ChronicleOptionsPanel")
end

function Chronicle:OpenOptionsPanel()
    if not self.optionsPanel then
        self:CreateOptionsPanel()
    end
    
    -- Refresh checkbox states from saved variables
    local panel = self.optionsPanel
    panel.turtlogsCheck:SetChecked(self:GetSetting("turtlogsCompatibility"))
    panel.autoLogCheck:SetChecked(self:GetSetting("autoCombatLogToggle"))
    panel.disableReminderCheck:SetChecked(self:GetSetting("disableCombatlogReminder"))
    panel.debugCheck:SetChecked(self:GetSetting("debugMode"))
    panel.defaultRangeSlider:SetValue(self:GetSetting("combatLogRangeDefault"))
    panel.instanceRangeSlider:SetValue(self:GetSetting("combatLogRangeInstance"))
    
    -- Refresh debug chat dropdown
    local chatFrameIndex = self:GetSetting("debugChatFrame")
    UIDropDownMenu_SetSelectedValue(panel.debugChatDropdown, chatFrameIndex)
    local tab = getglobal("ChatFrame" .. chatFrameIndex .. "Tab")
    local chatName = tab and tab:GetText() or ("Chat " .. chatFrameIndex)
    UIDropDownMenu_SetText(chatName, panel.debugChatDropdown)
    
    panel:Show()
end
