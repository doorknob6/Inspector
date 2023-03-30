_G = getfenv(0);

Inspector = CreateFrame("Frame", nil, UIParent);
Inspector:RegisterEvent("ADDON_LOADED");
Inspector:RegisterEvent("VARIABLES_LOADED");

-- Load saved variables
Inspector_Cache = {};
Inspector_Config = {};
Inspector_Debug = true;

Inspector:SetScript("OnEvent", function()
    if (event == "ADDON_LOADED") then ---@diagnostic disable-line: undefined-global
        if (arg1 == "Inspector") then ---@diagnostic disable-line: undefined-global
            Inspector:Initialise();
        else
            if (not Inspector.initialised) then return; end
            for addon, compat in pairs(Inspector.compats) do
                if ((arg1 == addon or getglobal(addon)) and (not compat.hasRun)) then ---@diagnostic disable-line: undefined-global
                    compat:compatFunc();
                end
            end
        end
    elseif (event == "VARIABLES_LOADED") then ---@diagnostic disable-line: undefined-global
        Inspector:InitialiseConfig();
    end
end);

function Inspector:Initialise()
    if (self.initialised) then return; end

    self.sets = {};
    self.canInspect = nil;
    self.updateInspect = nil;
    self.inspected = {};
    self.talentsLoadedFor = nil;
    self.hooks = {};
    self.initialised = false;
    self.compats = {
        ["pfUI"] = { compatFunc = function() self:Compat_pfUI(); end, hasRun = false }
    };

    -- override CanInspect
    self:OverrideFunction("CanInspect", function(unit)
        return self:SetUpInspect(unit);
    end);

    self.ui:Initialise();

    self.initialised = true;
end

-- set default config
function Inspector:InitialiseConfig()
    if (not Inspector_Config) then Inspector_Config = {}; end
    for option, value in pairs(self.constants.DEFAULT_CONFIG) do
        if (Inspector_Config[option] == nil) then
            Inspector_Config[option] = value;
        end
    end
end

-- Inspects the given unit
function Inspector:InspectUnit(unit)
    HideUIPanel(InspectFrame);
    self:SetUpInspect(unit);
    NotifyInspect(unit);
    ShowUIPanel(InspectFrame);
end

-- Sets up the inspect for the given unit
function Inspector:SetUpInspect(unit)
    if (unit == "player" and UnitExists("target")) then
        InspectFrame_Show("target");
        return false;
    elseif (not unit or not UnitExists(unit)) then
        InspectFrame_Show("player");
        return false;
    end
    InspectFrame.unit = unit;
    self.canInspect = self:CanInspectUnit(unit);
    if (self.canInspect) then
        self.inspected.name = UnitName(InspectFrame.unit);
        self.updateInspect = (not CheckInteractDistance(InspectFrame.unit, 1));
    else
        self.updateInspect = false;
        self.inspected = {};
    end
    self.sets = {};
    return true;
end

-- Checks if the unit can be inspected
function Inspector:CanInspectUnit(unit)
    if (UnitExists(unit) and UnitIsPlayer(unit)) then
        return true;
    end
    return false;
end

-- Resets the saved stats for the given `ItemSlotButton` and returns the `itemSlot` name
function Inspector:ItemSlotButtonResetStats(button)
    local itemSlot = self:ItemSlotButtonGetItemSlot(button);
    self.stats.itemSlots[itemSlot] = {};
    return itemSlot;
end

-- gets the stats for the item slot. Returns the `itemLink` if found.
function Inspector:ItemSlotButtonGetStats(button)
    local itemSlot = self:ItemSlotButtonResetStats(button);
    local link = Inspector.scanner:ScanItemSlotButton(button,
        InspectFrame.unit,
        self.stats.itemSlots[itemSlot],
        self.sets);
    if (link) then -- scan successful
        self.stats.itemSlots[itemSlot].link = link;
        self:ItemSlotButtonSetCache(itemSlot);
    else -- scan unsuccesful, try to restory from cache.
        local cache = self:ItemSlotButtonGetCache(itemSlot);
        if (cache and next(cache)) then
            -- rescan cached item for set bonuses
            link = Inspector.scanner:ScanItemLink(cache.link,
                self.stats.itemSlots[itemSlot],
                self.sets);
        end
    end
    return link;
end

-- caches the currently available data for the itemslot, if caching is turned on
function Inspector:ItemSlotButtonSetCache(itemSlot)
    if (not Inspector_Config.EnableCache) then return; end
    if (self.inspected.name) then
        local name = self.inspected.name;
        if (not Inspector_Cache[name]) then
            Inspector_Cache[name] = {};
        end
        if (not Inspector_Cache[name]["itemSlots"]) then
            Inspector_Cache[name]["itemSlots"] = {};
        end
        Inspector_Cache[name].itemSlots[itemSlot] = self.stats.itemSlots[itemSlot];
    end
end

-- gets the cache for the given itemslot, if caching is turned on
function Inspector:ItemSlotButtonGetCache(itemSlot)
    if (not Inspector_Config.EnableCache) then return; end
    if (self.inspected.name) then
        local name = self.inspected.name;
        if (not Inspector_Cache[name]) then
            return;
        end
        if (not Inspector_Cache[name]["itemSlots"]) then
            return;
        end
        return Inspector_Cache[name].itemSlots[itemSlot];
    end
end

-- Gets the `itemSlot` the `ItemSlotButton` is defined for.
function Inspector:ItemSlotButtonGetItemSlot(button)
    return string.sub(button:GetName(), 8);
end

-- check if the `Inspect` skin is loaded in pfUI
function Inspector:Check_pfUI()
    return (pfUI and
        pfUI.skin and
        pfUI.skin["Inspect"] and
        not (pfUI_config["disabled"] and pfUI_config["disabled"]["skin_Inspect"] == "1"));
end

-- converts some UI items to match pfUI visual style
function Inspector:Compat_pfUI()
    if (not self:Check_pfUI()) then return; end
    if (self.ui and self.ui.statsButton) then
        pfUI.api.SkinButton(self.ui.statsButton);
    end
    if (self.ui and self.ui.statsFrame and self.ui.statsFrame.scrollParent) then
        pfUI.api.SkinScrollbar(getglobal(self.ui.statsFrame.scrollParent:GetName() .. "ScrollBar"));
    end
end

-- thanks Shagu
function Inspector:HookFunction(name, func, before)
    if (not _G[name]) then return; end
    self.hooks[tostring(func)] = {}
    self.hooks[tostring(func)]["original"] = _G[name]
    self.hooks[tostring(func)]["new"] = func

    if (before) then
        self.hooks[tostring(func)]["function"] = function(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10)
            self.hooks[tostring(func)]["new"](p1, p2, p3, p4, p5, p6, p7, p8, p9, p10)
            self.hooks[tostring(func)]["original"](p1, p2, p3, p4, p5, p6, p7, p8, p9, p10)
        end;
    else
        self.hooks[tostring(func)]["function"] = function(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10)
            self.hooks[tostring(func)]["original"](p1, p2, p3, p4, p5, p6, p7, p8, p9, p10)
            self.hooks[tostring(func)]["new"](p1, p2, p3, p4, p5, p6, p7, p8, p9, p10)
        end;
    end
    _G[name] = self.hooks[tostring(func)]["function"]
end

-- overrides the global function
function Inspector:OverrideFunction(name, func)
    if (not _G[name]) then return; end
    _G[name] = func;
end

-- thanks Shagu
function Inspector:PostHookScript(f, script, func)
    local prev = f:GetScript(script)
    f:SetScript(script, function(a1, a2, a3, a4, a5, a6, a7, a8, a9)
        if prev then prev(a1, a2, a3, a4, a5, a6, a7, a8, a9) end
        func(a1, a2, a3, a4, a5, a6, a7, a8, a9)
    end)
end

function Inspector:Debug(text, stack)
    if (not Inspector_Debug) then return; end
    if (stack) then
        DEFAULT_CHAT_FRAME:AddMessage("Inspector debug: " .. debugstack(), 0.5, 0.8, 1);
    end
    DEFAULT_CHAT_FRAME:AddMessage("Inspector debug: " .. (text or ""), 0.5, 0.8, 1);
end
