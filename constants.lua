local PAPER_DOLL_ITEM_SLOT_TOP = -77;
local PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING = 3;

local PAPER_DOLL_ITEM_SLOT_BUTTON_MARGIN = 0;

Inspector.constants = {
    DEFAULT_CONFIG = {
        EnableCache = true,
        SpellDmgToSchools = true,
    },
    INSPECTFRAME_ON_UPDATE_COOLDOWN_INTERVAL = 0.5;
    PAPER_DOLL_FRAME_TEXTURE_MAPPINGS = {
        ["UI-Character-CharacterTab-L1"] = {
            pattern = "UI%-Character%-CharacterTab%-L1",
            replacement = "UI-Character-General-TopLeft",
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectPaperDollFrame,
            offSetRelativePoint = "TOPLEFT",
            offSetX = 2,
            offSetY = -1
        },
        ["UI-Character-CharacterTab-R1"] = {
            pattern = "UI%-Character%-CharacterTab%-R1",
            replacement = "UI-Character-General-TopRight",
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectPaperDollFrame,
            offSetRelativePoint = "TOPLEFT",
            offSetX = 258,
            offSetY = -1
        },
        ["UI-Character-CharacterTab-BottomLeft"] = {
            pattern = "UI%-Character%-CharacterTab%-BottomLeft",
            replacement = "UI-Character-General-BottomLeft",
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectPaperDollFrame,
            offSetRelativePoint = "TOPLEFT",
            offSetX = 2,
            offSetY = -257
        },
        ["UI-Character-CharacterTab-BottomRight"] = {
            pattern = "UI%-Character%-CharacterTab%-BottomRight",
            replacement = "UI-Character-General-BottomRight",
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectPaperDollFrame,
            offSetRelativePoint = "TOPLEFT",
            offSetX = 258,
            offSetY = -257
        },
    },
    PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING = PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING,
    PAPER_DOLL_ITEM_SLOT_BUTTON_MARGIN = PAPER_DOLL_ITEM_SLOT_BUTTON_MARGIN,
    PAPER_DOLL_ITEM_SLOT_BUTTON_PLACEMENT = {
        ["InspectHeadSlot"] = { button = InspectHeadSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectPaperDollFrame,
            offSetRelativePoint = "TOPLEFT",
            offSetX = 21 - PAPER_DOLL_ITEM_SLOT_BUTTON_MARGIN,
            offSetY = PAPER_DOLL_ITEM_SLOT_TOP
        },
        ["InspectNeckSlot"] = { button = InspectNeckSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectHeadSlot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectShoulderSlot"] = { button = InspectShoulderSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectNeckSlot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectBackSlot"] = { button = InspectBackSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectShoulderSlot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectChestSlot"] = { button = InspectChestSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectBackSlot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectShirtSlot"] = { button = InspectShirtSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectChestSlot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectTabardSlot"] = { button = InspectTabardSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectShirtSlot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectWristSlot"] = { button = InspectWristSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectTabardSlot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectHandsSlot"] = { button = InspectHandsSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectPaperDollFrame,
            offSetX = 305 + PAPER_DOLL_ITEM_SLOT_BUTTON_MARGIN,
            offSetRelativePoint = "TOPLEFT",
            offSetY = PAPER_DOLL_ITEM_SLOT_TOP
        },
        ["InspectWaistSlot"] = { button = InspectWaistSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectHandsSlot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectLegsSlot"] = { button = InspectLegsSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectWaistSlot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectFeetSlot"] = { button = InspectFeetSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectLegsSlot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectFinger0Slot"] = { button = InspectFinger0Slot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectFeetSlot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectFinger1Slot"] = { button = InspectFinger1Slot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectFinger0Slot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectTrinket0Slot"] = { button = InspectTrinket0Slot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectFinger1Slot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectTrinket1Slot"] = { button = InspectTrinket1Slot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectTrinket0Slot,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 0,
            offSetY = -PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING
        },
        ["InspectMainHandSlot"] = { button = InspectMainHandSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectPaperDollFrame,
            offSetRelativePoint = "BOTTOMLEFT",
            offSetX = 122 + (5 - PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING), -- re-center
            offSetY = 127 - PAPER_DOLL_ITEM_SLOT_BUTTON_MARGIN
        },
        ["InspectSecondaryHandSlot"] = { button = InspectSecondaryHandSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectMainHandSlot,
            offSetRelativePoint = "TOPRIGHT",
            offSetX = PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING,
            offSetY = 0
        },
        ["InspectRangedSlot"] = { button = InspectRangedSlot,
            offSetPoint = "TOPLEFT",
            offSetRelativeTo = InspectSecondaryHandSlot,
            offSetRelativePoint = "TOPRIGHT",
            offSetX = PAPER_DOLL_ITEM_SLOT_BUTTON_SPACING,
            offSetY = 0
        },
    },
    PAPER_DOLL_ITEM_SLOT_BUTTON_BORDER_TEXTURE = {
        textureName = "Interface\\AddOns\\Inspector\\textures\\border",
        offSetPoint = "CENTER",
        offSetRelativePoint = "CENTER",
        offSetX = 0,
        offSetY = 0,
        width = 41,
        height = 41,
    },
    STATS_BUTTON_CONFIG = {
        offSetPoint = "TOPRIGHT",
        offSetRelativeTo = InspectMainHandSlot,
        offSetRelativePoint = "TOPLEFT",
        offSetX = -13,
        offSetY = 0,
        width = 40,
        height = 16
    },
    MAGICSCHOOLS = { "ARCANE", "FIRE", "NATURE", "FROST", "SHADOW", "HOLY" },
    STATS_FRAME_MARGIN = 2,
    STATS_FRAME_SCROLL_PARENT_MARGIN = { top = 2, left = 2, right = 22, bottom = 2 },
    STATS_FRAME_SCROLL_PARENT_BG_COLOR = { r = 33 / 255, g = 33 / 255, b = 33 / 255, a = 0.8 },
    STATS_FRAME_CATEGORY_FONT = "GameFontHighlight",
    STATS_FRAME_STATS_FONT = "GameFontHighlight",
    STATS_FRAME_STATS_MARGIN = 12,
};
