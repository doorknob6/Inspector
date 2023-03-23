Inspector.ui = {};

function Inspector.ui:Initialise()
    -- set up the ui

    -- set up the PaperDollFrame textures
    Inspector.ui:InitialiseInspectPaperDollFrame();
    -- set up ModelFrame scrolling, panning and zooming
    Inspector.ui.modelFrame:InitialiseModelFrame();
    -- set the ItemSlotButtons spacing and set up the stats data tables
    Inspector.ui.itemSlotButton:InitialiseButtons();
    -- create the stats button
    self:CreateStatsButton();
    -- create the stats frame
    self.statsFrame:Create();

    -- set dynamic behaviours
    self.originalColorsSet = false;
    self.originalHandlersSet = false;

    -- post-hook `InspectFrame:OnShow`
    Inspector:PostHookScript(InspectFrame, "OnShow", function()
        self:InspectFrameSetDynamicElements();
    end);
    -- override `InspectFrame:OnUpdate`
    InspectFrame:SetScript("OnUpdate", function()
        self:InspectFrame_OnUpdate(arg1) ---@diagnostic disable-line: undefined-global
    end);
    -- post-hook `InspectFrame_OnEvent` to manage frame elements on target changes
    InspectFrame:SetScript("OnEvent", function()
        self:InspectFrame_OnEvent(event, arg1); ---@diagnostic disable-line: undefined-global
    end);
    -- override `InspectPaperDollFrame:OnShow`, to wrap standard itemslot updating
    InspectPaperDollFrame:SetScript("OnShow", function()
        Inspector.ui:InspectPaperDollFrame_OnShow();
    end);
end

-- re-inspects target on interval if necessary, sets up disabling of talent tab button
function Inspector.ui:InspectFrame_OnUpdate(elapsedTime)
    if (not InspectFrame:IsVisible()) then return; end
    if (not InspectFrame.unit) then
        HideUIPanel(InspectFrame);
        return;
    end
    self.elapsed = (self.elapsed or 0) + elapsedTime;
    if (Inspector.updateInspect and
        Inspector:CanInspectUnit(InspectFrame.unit) and
        CheckInteractDistance(InspectFrame.unit, 1) and
        self.elapsed > Inspector.constants.INSPECTFRAME_ON_UPDATE_COOLDOWN_INTERVAL) then
        InspectFrame_Show(InspectFrame.unit);
        self.elapsed = 0;
    end

    if (not InspectTalentsFrame and not InspectFrameTab3) then return; end

    if (self.originalColorsSet) then
        self.originalRed, self.originalGreen, self.originalBlue = InspectFrameTab3:GetTextColor();
        self.originalHRed, self.originalHGreen, self.originalHBlue = InspectFrameTab3:GetHighlightTextColor();
        self.originalColorsSet = true;
    end
    if (not self.originalHandlersSet) then
        self.originalOnClick = InspectFrameTab3:GetScript("OnClick");
        self.originalOnEnter = InspectFrameTab3:GetScript("OnEnter");
        self.originalHandlersSet = true;
    end
    if (not UnitExists("target")) then
        InspectFrameTab3:SetTextColor(0.5, 0.5, 0.5);
        InspectFrameTab3:SetHighlightTextColor(0.5, 0.5, 0.5);

        InspectFrameTab3HighlightTexture:Hide();

        InspectFrameTab3:SetScript("OnClick", function()
            message("Select a target to view talents.");
        end);

        InspectFrameTab3:SetScript("OnEnter", function()
            GameTooltip:SetOwner(InspectFrameTab3, "ANCHOR_RIGHT");
            GameTooltip:SetText("Select a target to view talents", 1.0, 1.0, 1.0);
        end)
    else
        InspectFrameTab3HighlightTexture:Show();
        if (self.originalRed and self.originalGreen and self.originalBlue) then
            InspectFrameTab3:SetTextColor(self.originalRed, self.originalGreen, self.originalBlue);
        else
            InspectFrameTab3:SetTextColor(1.0, 0.82, 0.0);
        end
        if (self.originalHRed and self.originalHGreen and self.originalHBlue) then
            InspectFrameTab3:SetHighlightTextColor(self.originalHRed, self.originalHGreen, self.originalHBlue);
        else
            InspectFrameTab3:SetHighlightTextColor(1.0, 1.0, 1.0);
        end

        if (self.originalOnEnter) then
            InspectFrameTab3:SetScript("OnEnter", self.originalOnEnter);
        end
        if (self.originalOnClick) then
            InspectFrameTab3:SetScript("OnClick", self.originalOnClick);
        end
    end
end

-- hides or unhides frame elements when the target changes
function Inspector.ui:InspectFrame_OnEvent(event, unit)
    if (not InspectFrame:IsShown()) then
        return;
    end
    if (event == "PARTY_MEMBERS_CHANGED") then
        InspectFrame_Show("target");
        return;
    elseif (event == "PLAYER_TARGET_CHANGED") then
        -- keep the frame open if nothing is targeted
        if (InspectFrame.unit and not UnitExists("target")) then
            return;
        end
        InspectFrame_Show("target");
        return;
    elseif (event == "UNIT_PORTRAIT_UPDATE") then
        if (unit == InspectFrame.unit) then
            SetPortraitTexture(InspectFramePortrait, unit);
        end
        return;
    elseif (event == "UNIT_NAME_UPDATE") then
        if (unit == InspectFrame.unit) then
            InspectNameText:SetText(UnitName(unit));
        end
        return;
    end
end

-- hides or shows dynamic elements
function Inspector.ui:InspectFrameSetDynamicElements()
    if (not InspectFrame:IsVisible()) then return; end
    if (not Inspector.canInspect) then
        self:FrameTabsChangeShown(InspectFrame, true);
        self.statsButton:Hide();
        self.statsFrame:Empty();
        self.statsFrame.scrollParent:Hide();

        if (not PanelTemplates_GetSelectedTab(InspectFrame) == 1) then
            PanelTemplates_SetTab(InspectFrame, 1);
            ToggleInspect("InspectPaperDollFrame");
        end

        if (InspectTalentsFrame and InspectTalentsFrame:IsVisible()) then
            InspectTalentsFrame:Hide();
        end
    else
        self:FrameTabsChangeShown(InspectFrame, false);
        self.statsButton:Show();
        if (self.statsFrame.scrollParent:IsShown()) then
            self.statsFrame:Update();
        end

        if (InspectTalentsFrame and
            InspectFrameTalentsTab_OnClick and
            PanelTemplates_GetSelectedTab(InspectFrame) == 3) then
            InspectTalentsFrame:Hide();
            -- Turtle WoW inspect talents always runs on a selected target
            if (UnitExists("target")) then
                InspectFrameTalentsTab_OnClick();
            else
                PanelTemplates_SetTab(InspectFrame, 1);
                ToggleInspect("InspectPaperDollFrame");
            end
        end
    end
end

-- switches out the `InspectPaperDollFrame` textures
function Inspector.ui:InitialiseInspectPaperDollFrame()
    local texturePath, textureName, textureData;
    for _, region in ipairs({ InspectPaperDollFrame:GetRegions() }) do
        if (region.SetTexture) then
            texturePath = (region:GetTexture() or "");
            if (string.find(texturePath, "UI%-Character%-CharacterTab")) then
                textureName = string.sub(texturePath, 30);
                textureData = Inspector.constants.PAPER_DOLL_FRAME_TEXTURE_MAPPINGS[textureName];
                texturePath = string.gsub(texturePath, textureData.pattern, textureData.replacement);
                region:SetTexture(texturePath);
                region:SetPoint(textureData.offSetPoint,
                    textureData.offSetRelativeTo,
                    textureData.offSetRelativePoint,
                    textureData.offSetX,
                    textureData.offSetY);
            end
        end
    end
end

-- own implementation of `InspectPaperDollFrame_OnShow`, uses `Inspector.ui:InspectPaperDollItemSlotButton_Update`
function Inspector.ui:InspectPaperDollFrame_OnShow()
    InspectModelFrame:SetUnit(InspectFrame.unit);
    if (Inspector.canInspect) then
        InspectPaperDollFrame_SetLevel();
    else
        InspectLevelText:SetText("");
    end
    for _, itemSlotData in pairs(Inspector.constants.PAPER_DOLL_ITEM_SLOT_BUTTON_PLACEMENT) do
        Inspector.ui:InspectPaperDollItemSlotButton_Update(itemSlotData.button);
    end
end

-- wraps `InspectPaperDollItemSlotButton_Update`. Hides the ItemSlotButton if the target
-- can't be inspected. Scans the contained item for stats if it can be.
-- Restores items from cache if available.
function Inspector.ui:InspectPaperDollItemSlotButton_Update(button)
    Inspector:ItemSlotButtonResetStats(button);
    if (not Inspector.canInspect) then
        self.itemSlotButton:Reset(button);
        button:Hide();
        return;
    end
    if (not button:IsShown()) then button:Show(); end
    InspectPaperDollItemSlotButton_Update(button);
    local link = Inspector:ItemSlotButtonGetStats(button);
    Inspector.ui.itemSlotButton:SetItemLink(button, link);
end

function Inspector.ui:CreateStatsButton()
    if (self.statsButton) then return; end
    self.statsButton = CreateFrame("Button", "Inspector_statsButton", InspectModelFrame, "UIPanelButtonTemplate");
    self.statsButton:SetText(Inspector.StatsButtonText);
    self.statsButton:SetPoint(Inspector.constants.STATS_BUTTON_CONFIG.offSetPoint,
        Inspector.constants.STATS_BUTTON_CONFIG.offSetRelativeTo,
        Inspector.constants.STATS_BUTTON_CONFIG.offSetRelativePoint,
        Inspector.constants.STATS_BUTTON_CONFIG.offSetX,
        Inspector.constants.STATS_BUTTON_CONFIG.offSetY);
    self.statsButton:SetWidth(Inspector.constants.STATS_BUTTON_CONFIG.width);
    self.statsButton:SetHeight(Inspector.constants.STATS_BUTTON_CONFIG.height);
    self.statsButton:SetScript("OnClick", function()
        if (self.statsFrame.scrollParent:IsShown()) then
            self.statsFrame.scrollParent:Hide();
        else
            self.statsFrame.scrollParent:Show();
        end
    end);
end

function Inspector.ui:FrameTabsChangeShown(frame, hide)
    if (not frame.numTabs) then
        return;
    end
    if (hide) then
        PanelTemplates_SetTab(frame, 1);
        for tabIndex = 1, frame.numTabs, 1 do
            getglobal(frame:GetName() .. "Tab" .. tabIndex):Hide();
        end
    else
        for tabIndex = 1, frame.numTabs, 1 do
            getglobal(frame:GetName() .. "Tab" .. tabIndex):Show();
        end
    end
end
