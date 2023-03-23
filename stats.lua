Inspector.stats = { itemSlots = {}, MAGICSCHOOLS = { "ARCANE", "FIRE", "NATURE", "FROST", "SHADOW", "HOLY" }; }

-- Returns the stat name for the token, or the token if it can't be found
function Inspector.stats:GetStatName(statToken)
    local statName = statToken;
    if self.StatNames[statToken] then
        statName = self.StatNames[statToken].name;
    end
    return statName;
end

-- Returns the stat unit for the token, or an empty string if it can't be found
function Inspector.stats:GetStatUnit(statToken)
    local statUnit = "";
    if self.StatNames[statToken] then
        statUnit = self.StatNames[statToken].unit;
    end
    return statUnit;
end

-- Returns a modified Token Value from the given statTable (value might be modified by certain options)
function Inspector.stats:GetStatValue(statToken, statTable)
    local value = (statTable[statToken] or 0);
    -- OPTION: Add spell damage to each spell school
    if (Inspector_Config.SpellDmgToSchools) and (statTable["SPELLDMG"]) then
        for _, schoolToken in ipairs(self.MAGICSCHOOLS) do
            if (statToken == schoolToken .. "DMG") then
                value = (value + statTable["SPELLDMG"]);
                break;
            end
        end
    end
    return value;
end

-- Gets a stat table for all the inspected unit's stats
function Inspector.stats:GetStats()
    local statTable = {};
    local statName, statValue, statUnit;
    for _, category in ipairs(self.StatEntryOrder) do
        for _, statToken in ipairs(category.stats) do
            statName = statToken;
            statUnit = "";
            if (self.StatNames[statToken]) then
                statName = self.StatNames[statToken].name;
                statUnit = self.StatNames[statToken].unit;
            end
            statValue = 0;
            for _, itemSlotStats in pairs(self.itemSlots) do
                statValue = statValue + (itemSlotStats[statToken] or 0);
            end
            if (statValue ~= 0) then
                if (not statTable[category.token]) then
                    statTable[category.token] = {};
                end
                statTable[category.token][statToken] = { name = statName, value = statValue, unit = statUnit };
            end
        end
    end
    return statTable;
end
