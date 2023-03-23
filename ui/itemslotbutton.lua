Inspector.ui.itemSlotButton = {};

-- initialises all ItemSlotButtons
function Inspector.ui.itemSlotButton:InitialiseButtons()
    for _, itemSlotData in pairs(Inspector.constants.PAPER_DOLL_ITEM_SLOT_BUTTON_PLACEMENT) do
        self:Initialise(itemSlotData);
    end
end

-- sets the ItemSlotButton spacing, sets up the stats data tables and hooks `OnEnter`
function Inspector.ui.itemSlotButton:Initialise(itemSlotData)
    Inspector:ItemSlotButtonResetStats(itemSlotData.button);
    itemSlotData.button:SetPoint(itemSlotData.offSetPoint,
        itemSlotData.offSetRelativeTo,
        itemSlotData.offSetRelativePoint,
        itemSlotData.offSetX,
        itemSlotData.offSetY);
    local data = Inspector.constants.PAPER_DOLL_ITEM_SLOT_BUTTON_BORDER_TEXTURE;
    self:SetBorderTexture(itemSlotData.button, data.textureName);
    self:SetBorderTextureSize(itemSlotData.button, data.width, data.height);
    self:SetBorderTextureAnchor(itemSlotData.button, data);
    local previousOnEnter = itemSlotData.button:GetScript("OnEnter");
    itemSlotData.button:SetScript("OnEnter", function()
        previousOnEnter();
        self:OnEnter(this); ---@diagnostic disable-line: undefined-global
    end);
end

-- checks the shown `GameTooltip` or shows one from local or cached data
function Inspector.ui.itemSlotButton:OnEnter(button)
    local itemLink;
    local itemSlot = self:GetItemSlot(button);

    if (GameTooltip:IsShown()) then
        -- check the shown item locally
        if (Inspector.stats.itemSlots[itemSlot] and
            Inspector.stats.itemSlots[itemSlot].link) then
            if (Inspector.scanner:CompareTooltipToItemLink(GameTooltip,
                Inspector.stats.itemSlots[itemSlot].link, 1)) then
                return;
            end
            -- if our data doesn't match the tooltip, rescan
            Inspector.ui:InspectPaperDollItemSlotButton_Update(button);
            itemLink = Inspector.stats.itemSlots[itemSlot].link;
        end
    end
    if (not itemLink and Inspector_Config.EnableCache) then
        -- check the cache
        local cache = Inspector:ItemSlotButtonGetCache(itemSlot);
        if (cache) then
            itemLink = cache.link
        end
    end
    if (itemLink) then
        GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
        GameTooltip:SetHyperlink(itemLink);
        GameTooltip:Show();
    end
end

-- Gets the `itemSlot` the `ItemSlotButton` is defined for.
function Inspector.ui.itemSlotButton:GetItemSlot(button)
    return string.sub(button:GetName(), 8);
end

-- sets the item in the `button` by `link`. Resets the button if no `link` is given.
function Inspector.ui.itemSlotButton:SetItemLink(button, link)
    if (link) then
        local _, _, itemRarity, _, _, _, _, _, itemTexture = GetItemInfo(link);
        if (button.hasItem ~= 1) then
            SetItemButtonTexture(button, itemTexture or button.backgroundTextureName);
            SetItemButtonCount(button, 1);
        end
        if (itemRarity) and (itemRarity ~= -1) then
            local r, g, b = GetItemQualityColor(itemRarity);
            self:SetBorderTextureVertexColor(button, r, g, b)
        else
            self:SetBorderTextureVertexColor(button, 0.5, 0.5, 0.5);
        end
    else
        self:Reset(button);
    end
end

-- resets the button.
function Inspector.ui.itemSlotButton:Reset(button)
    SetItemButtonTexture(button, button.backgroundTextureName);
    SetItemButtonCount(button, 0);
    self:SetBorderTextureVertexColor(button, 0.5, 0.5, 0.5);
end

-- set the border texture.
function Inspector.ui.itemSlotButton:SetBorderTexture(button, textureName)
    if (not button) then return; end
    local border = button:CreateTexture(self:GetBorderTextureName(button), "OVERLAY");
    border:SetTexture(textureName);
    border:Show();
end

-- sets the border texture size.
function Inspector.ui.itemSlotButton:SetBorderTextureSize(button, width, height)
    local texture = self:GetBorderTexture(button);
    if (texture) then
        texture:SetWidth(width);
        texture:SetHeight(height);
    end
end

-- sets an anchor for the border texture.
function Inspector.ui.itemSlotButton:SetBorderTextureAnchor(button, offSetData)
    local texture = self:GetBorderTexture(button);
    if (texture) then
        texture:SetPoint(offSetData.offSetPoint,
            button,
            offSetData.offSetRelativePoint,
            offSetData.offSetX,
            offSetData.offSetY);
    end
end

-- sets the normal texture color.
function Inspector.ui.itemSlotButton:SetBorderTextureVertexColor(button, r, g, b)
    local texture = self:GetBorderTexture(button);
    if (texture) then
        texture:SetVertexColor(r, g, b, 1);
    end
end

-- gets the border texture.
function Inspector.ui.itemSlotButton:GetBorderTexture(button)
    if (not button) then return; end
    local borderName = self:GetBorderTextureName(button);
    for _, item in ipairs { button:GetRegions() } do
        if (item:GetName() == borderName) then
            return item;
        end
    end
    return nil;
end

-- gets the border texture name.
function Inspector.ui.itemSlotButton:GetBorderTextureName(button)
    if (not button) then return; end
    local name = button:GetName();
    return name .. "BorderTexture";
end
