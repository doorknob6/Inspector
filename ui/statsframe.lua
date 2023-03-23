Inspector.ui.statsFrame = {};

function Inspector.ui.statsFrame:Create()
    if (self.scrollParent) then return; end
    self.scrollParent = CreateFrame("ScrollFrame",
        "Inspector_StatsFrameScrollParent",
        InspectModelFrame,
        "UIPanelScrollFrameTemplate");
    local statsFrameMargin = Inspector.constants.STATS_FRAME_MARGIN;
    local scrollParentMargin = Inspector.constants.STATS_FRAME_SCROLL_PARENT_MARGIN;
    self.scrollParent:SetPoint("TOPLEFT",
        InspectModelFrame,
        "TOPLEFT",
        scrollParentMargin.left,
        -scrollParentMargin.top);
    self.scrollParent:SetWidth(InspectModelFrame:GetWidth() - scrollParentMargin.left - scrollParentMargin.right);
    self.scrollParent:SetHeight(InspectModelFrame:GetHeight() - scrollParentMargin.top - scrollParentMargin.bottom);
    self.scrollParent:SetScript("OnShow", function() self:Update(); end);
    self.scrollParent:SetScript("OnHide", function() self:Empty(); end);

    self.background = self.scrollParent:CreateTexture("Inspector_StatsFrameScrollParentBackground",
        "BACKGROUND");
    local bgColor = Inspector.constants.STATS_FRAME_SCROLL_PARENT_BG_COLOR;
    self.background:SetTexture(bgColor.r, bgColor.g, bgColor.b, bgColor.a); ---@diagnostic disable-line: param-type-mismatch
    self.background:SetPoint("TOPLEFT", self.scrollParent, "TOPLEFT", 0, 0); ---@diagnostic disable-line: param-type-mismatch
    self.background:SetPoint("BOTTOMRIGHT", self.scrollParent, "BOTTOMRIGHT", scrollParentMargin.right, 0); ---@diagnostic disable-line: param-type-mismatch
    self.background:Show();

    self.scrollChild = CreateFrame("Frame", "Inspector_StatsFrameScrollChild", self.scrollParent);
    self.scrollParent:SetScrollChild(self.scrollChild);
    self.scrollChild:SetPoint("TOPLEFT",
        self.scrollParent, ---@diagnostic disable-line: param-type-mismatch
        "TOPLEFT",
        statsFrameMargin,
        -statsFrameMargin);
    self.scrollChild:SetWidth(self.scrollParent:GetWidth());
    self.scrollChild:SetHeight(self.scrollParent:GetHeight() - 2 * statsFrameMargin);

    -- prepare stats items
    self.items = {};
    for _, category in ipairs(Inspector.stats.StatEntryOrder) do
        self:CreateCategoryFrame(category)
    end
    -- prepare sets table
    self.sets = {};
    self:CreateSetsFrame();

    self.scrollParent:Hide();
end

function Inspector.ui.statsFrame:CreateCategoryFrame(category)
    local font = Inspector.constants.STATS_FRAME_CATEGORY_FONT;
    local layer = "OVERLAY";
    self.items[category.token] = CreateFrame("Frame",
        "Inspector_StatsFrameCategory_" .. category.token,
        self.scrollChild);
    self.items[category.token]:Hide();
    local categoryString = self.items[category.token]:CreateFontString(nil, layer, font);
    categoryString:SetText(category.name);
    categoryString:SetPoint("TOPLEFT", self.items[category.token], "TOPLEFT");
    for _, statToken in ipairs(category.stats) do
        self:CreateStatFrame(category, statToken);
    end
end

function Inspector.ui.statsFrame:CreateStatFrame(category, statToken)
    local margin = Inspector.constants.STATS_FRAME_STATS_MARGIN;
    local font = Inspector.constants.STATS_FRAME_STATS_FONT;
    local layer = "OVERLAY";
    self.items[statToken] = CreateFrame("Frame",
        "Inspector_StatsFrameStat_" .. statToken,
        self.items[category.token]);
    self.items[statToken]:SetHeight(14);

    local statName = self.items[statToken]:CreateFontString(nil, layer, font);
    statName:SetText(Inspector.stats:GetStatName(statToken));
    statName:SetPoint("TOPLEFT", self.items[statToken], "TOPLEFT");

    local statUnit = self.items[statToken]:CreateFontString(nil, layer, font);
    statUnit:SetText(Inspector.stats:GetStatUnit(statToken));
    statUnit:SetWidth(20);
    statUnit:SetPoint("TOPRIGHT", self.items[statToken], "TOPRIGHT", 0, 0);

    local statValue = statToken .. "_Value";
    self.items[statValue] = self.items[statToken]:CreateFontString(statValue, layer, font);
    self.items[statValue]:SetPoint("TOPRIGHT", statUnit, "TOPLEFT", -margin);
end

function Inspector.ui.statsFrame:CreateSetsFrame()
    local font = Inspector.constants.STATS_FRAME_CATEGORY_FONT;
    local layer = "OVERLAY";
    self.sets["Header"] = CreateFrame("Frame", "Inspector_StatsFrameSet_Header", self.scrollChild);
    self.sets["Header"]:Hide();
    local headerString = self.sets["Header"]:CreateFontString(nil, layer, font);
    headerString:SetText(Inspector.constants.STATS_FRAME_SETS_HEADER_TEXT);
    headerString:SetPoint("TOPLEFT", self.sets["Header"], "TOPLEFT");
    local i = 1;
    for _, _ in pairs(Inspector.constants.PAPER_DOLL_ITEM_SLOT_BUTTON_PLACEMENT) do
        self:CreateSetFrame(i);
        i = i + 1;
    end
end

function Inspector.ui.statsFrame:CreateSetFrame(index)
    local font = Inspector.constants.STATS_FRAME_STATS_FONT;
    local layer = "OVERLAY";
    local name = self:GetSetFrameName(index);
    self.sets[name] = CreateFrame("Frame", name, self.sets["Header"]);
    self.sets[name]:SetHeight(14);
    self.sets[name]:Hide();
    local valueName = self:GetSetValueName(index);
    self.sets[valueName] = self.sets[name]:CreateFontString(valueName, layer, font);
    self.sets[valueName]:SetPoint("TOPLEFT", self.sets[name], "TOPLEFT");
end

function Inspector.ui.statsFrame:GetSetFrameName(index)
    return "Inspector_StatsFrameSet_" .. index;
end

function Inspector.ui.statsFrame:GetSetValueName(index)
    return "Inspector_StatsFrameSetValue_" .. index;
end

function Inspector.ui.statsFrame:Update()
    if (not self.scrollChild) then self:Create(); end
    if (not self.items) then return; end

    self:Empty();
    local stats = Inspector.stats:GetStats();
    self.lastCategory = nil;
    self.lastStat = nil;
    for _, category in ipairs(Inspector.stats.StatEntryOrder) do
        self:UpdateCategory(stats, category);
    end
    self:UpdateSets();

    self.scrollParent:UpdateScrollChildRect();
end

function Inspector.ui.statsFrame:UpdateCategory(stats, category)
    if (not stats[category.token]) then return; end
    if (not self.items[category.token]) then return; end
    local newCategory = self.items[category.token];
    local margin = Inspector.constants.STATS_FRAME_STATS_MARGIN;
    if (not self.lastCategory) then
        newCategory:SetPoint("TOP", self.scrollChild, "TOP", 0, -margin);
    else
        newCategory:SetPoint("TOP", self.lastCategory, "BOTTOM", 0, -4);
    end
    newCategory:SetPoint("LEFT", self.scrollChild, "LEFT", margin, 0);
    newCategory:SetPoint("RIGHT", self.scrollChild, "RIGHT", -margin, 0);
    newCategory:Show();

    self.lastCategory = newCategory;
    self.lastStat = nil;
    for _, statToken in ipairs(category.stats) do
        self:UpdateStat(stats[category.token], statToken);
    end
    local categoryHeight = 16;
    for _, _ in pairs(stats[category.token]) do categoryHeight = categoryHeight + 16; end
    newCategory:SetHeight(categoryHeight);
end

function Inspector.ui.statsFrame:UpdateStat(stats, statToken)
    if (not stats[statToken]) then return; end
    local stat = stats[statToken];
    local margin = Inspector.constants.STATS_FRAME_STATS_MARGIN;
    if (not self.lastStat) then
        self.items[statToken]:SetPoint("TOP", self.lastCategory, "TOP", 0, -14);
    else
        self.items[statToken]:SetPoint("TOP", self.lastStat, "BOTTOM", 0, -2);
    end
    self.items[statToken]:SetPoint("LEFT", self.lastCategory, "LEFT", margin, 0);
    self.items[statToken]:SetPoint("RIGHT", self.lastCategory, "RIGHT", 0, 0);
    self.items[statToken]:Show();
    self.lastStat = self.items[statToken];

    local statRound = 1;
    if (stat.unit == " lvls") then
        statRound = 0.1;
    end

    local statValue = statToken .. "_Value";
    self.items[statValue]:SetText(tostring(stat.value - math.mod(stat.value, statRound)));
    self.items[statValue]:Show();
end

function Inspector.ui.statsFrame:UpdateSets()
    if (not Inspector.sets or not next(Inspector.sets)) then return; end
    local margin = Inspector.constants.STATS_FRAME_STATS_MARGIN;
    if (not self.lastCategory) then
        self.sets["Header"]:SetPoint("TOP", self.scrollChild, "TOP", 0, -margin);
    else
        self.sets["Header"]:SetPoint("TOP", self.lastCategory, "BOTTOM", 0, -4);
    end
    self.sets["Header"]:SetPoint("LEFT", self.scrollChild, "LEFT", margin, 0);
    self.sets["Header"]:SetPoint("RIGHT", self.scrollChild, "RIGHT", -margin, 0);
    self.sets["Header"]:Show();

    self.lastSet = nil;

    local index = 1;
    for setName, setData in pairs(Inspector.sets) do
        self:UpdateSet(index, setName, setData);
        index = index + 1;
    end
    local setsHeight = 16 + index * 16;
    self.sets["Header"]:SetHeight(setsHeight);
end

function Inspector.ui.statsFrame:UpdateSet(index, setName, setData)
    local margin = Inspector.constants.STATS_FRAME_STATS_MARGIN;
    local name = self:GetSetFrameName(index);
    if (not self.lastSet) then
        self.sets[name]:SetPoint("TOP", self.sets["Header"], "TOP", 0, -14);
    else
        self.sets[name]:SetPoint("TOP", self.lastSet, "BOTTOM", 0, -2);
    end
    self.sets[name]:SetPoint("LEFT", self.sets["Header"], "LEFT", margin, 0);
    self.sets[name]:SetPoint("RIGHT", self.sets["Header"], "RIGHT", 0, 0);
    self.sets[name]:Show();
    self.lastSet = self.sets[name];

    local valueName = self:GetSetValueName(index);
    self.sets[valueName]:SetText(setName .. " (" .. setData.count .. "/" .. setData.max .. ")");
    self.sets[valueName]:Show();
end

function Inspector.ui.statsFrame:Empty()
    for name, item in pairs(self.items) do
        self:EmptyItem(name, item, "_Value");
    end
    for name, item in pairs(self.sets) do
        self:EmptyItem(name, item, "StatsFrameSetValue");
    end
end

function Inspector.ui.statsFrame:EmptyItem(name, item, valuePattern)
    if (string.find(name, valuePattern)) then
        item:SetText("");
    else
        item:ClearAllPoints();
    end
    item:Hide();
end
