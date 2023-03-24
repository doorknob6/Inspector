--------------------------------------------------------------------------------------------------------
--                                                Misc                                                --
--------------------------------------------------------------------------------------------------------

BINDING_HEADER_INSPECTOR_HEADER = "Inspector"
BINDING_NAME_INSPECT_TARGET_BINDING = "Inspect target"

Inspector.StatsButtonText = "Stats";
Inspector.Classification = {
	["worldboss"] = "Boss",
	["rareelite"] = "RareElite",
	["elite"] = "Elite",
	["rare"] = "Rare",
};

Inspector.constants.STATS_FRAME_SETS_HEADER_TEXT = "Sets";

Inspector.scanner.SetBonusToken = "^%((%d)%) Set:%s(.+)";
Inspector.scanner.SetBonusTokenActive = "^Set:%s(.+)";

--------------------------------------------------------------------------------------------------------
--                                           Stat Patterns                                            --
--------------------------------------------------------------------------------------------------------

Inspector.scanner.Patterns = {
	-- Equipment: Base Stats --
	{ p = "%+(%d+) Strength", s = "STR" },
	{ p = "%+(%d+) Agility", s = "AGI" },
	{ p = "%+(%d+) Stamina", s = "STA" },
	{ p = "%+(%d+) Intellect", s = "INT" },
	{ p = "%+(%d+) Spirit", s = "SPI" },
	{ p = "(%d+) Armor", s = "ARMOR" },

	-- Equipment: Speed --
	{ p = "^Run speed increased slightly%.", s = "SPEED_RUN", v = 8 },
	{ p = "Increases run speed by (%d+)%%%.", s = "SPEED_RUN" },
	{ p = "Minor increase to running and swimming speed.", s = { "SPEED_RUN", "SPEED_SWIM" }, v = { 8, 8 } },
	{ p = "Increases swim speed by (%d+)%%%.", s = "SPEED_SWIM" },
	{ p = "Increases mount speed by (%d+)%%%.", s = "SPEED_MOUNT" },

	-- Equipment: Resistances (also catches enchants) --
	{ p = "%+(%d+) Arcane Resistance", s = "ARCANERESIST" },
	{ p = "%+(%d+) Fire Resistance", s = "FIRERESIST" },
	{ p = "%+(%d+) Nature Resistance", s = "NATURERESIST" },
	{ p = "%+(%d+) Frost Resistance", s = "FROSTRESIST" },
	{ p = "%+(%d+) Shadow Resistance", s = "SHADOWRESIST" },

	-- Equipment: Avoidance --
	{ p = "Increased Defense %+(%d+)%.", s = "DEFENSE" },
	{ p = "Increases your chance to dodge an attack by (%d+)%%%.", s = "DODGE" },
	{ p = "Increases your chance to parry an attack by (%d+)%%%.", s = "PARRY" },
	{ p = "Increases your chance to block attacks with a shield by (%d+)%%%.", s = "BLOCK" },

	{ p = "Increases the block value of your shield by (%d+)%.", s = "BLOCKVALUE" },
	{ p = "^(%d+) Block$", s = "BLOCKVALUE" }, -- Should catch only base block value from a shield

	-- Equipment: Stealth --
	{ p = "Increases your effective stealth level.", s = "STEALTH", v = 1.66 },

	-- Equipment: Melee/Ranged --
	{ p = "Improves your chance to get a critical strike by (%d+)%%%.", s = "CRIT" },
	{ p = "Improves your chance to hit by (%d+)%%%.", s = "HIT" },
	{ p = "Increases your attack and casting speed by (%d+)%%%.", s = { "HASTE", "SPELLHASTE", "RANGEDHASTE" } },
	{ p = "%+(%d+) Weapon Damage", s = "WPNDMG" },
	{ p = "Your attacks ignore (%d+) of your opponent's armor%.", s = "ARMORPENETRATION" },

	{ p = "%+(%d+) Attack Power%.", s = "AP" },
	{ p = "%+(%d+) Attack Power in Cat, Bear, Dire Bear, and Moonkin forms only%.", s = "APFERAL" },
	{ p = "%+(%d+) Attack Power when fighting Undead%.", s = "UNDEAD_AP" },
	{ p = "%+(%d+) Attack Power when fighting Dragonkin%.", s = "DRAGON_AP" },
	{ p = "%+(%d+) Attack Power when fighting Demons%.", s = "DEMON_AP" },
	{ p = "%+(%d+) Attack Power when fighting Beasts%.", s = "BEAST_AP" },

	-- Equipment: Ranged --
	{ p = "%+(%d+) ranged Attack Power%.", s = "RAP" },
	{ p = "Improves your chance to get a critical strike with missile weapons by (%d+)%%%.", s = "RANGEDCRIT" },
	{ p = "Increases ranged attack speed by (%d+)%%%.", s = "RANGEDHASTE" },

	-- Equipment: Weapon Skills --
	{ p = "Increased Swords %+(%d+)%.", s = "WPNSKILL_SWORD" },
	{ p = "Increased Maces %+(%d+)%.", s = "WPNSKILL_MACE" },
	{ p = "Increased Axes %+(%d+)%.", s = "WPNSKILL_AXE" },
	{ p = "Increased Daggers %+(%d+)%.", s = "WPNSKILL_DAGGER" },
	{ p = "Increased Fist Weapons %+(%d+)%.", s = "WPNSKILL_FIST" },

	{ p = "Increased Two%-handed Swords %+(%d+)%.", s = "WPNSKILL_SWORD_2H" },
	{ p = "Increased Two%-handed Maces %+(%d+)%.", s = "WPNSKILL_MACE_2H" },
	{ p = "Increased Two%-handed Axes %+(%d+)%.", s = "WPNSKILL_AXE_2H" },

	{ p = "Increased Bows %+(%d+)%.", s = "WPNSKILL_BOW" },
	{ p = "Increased Guns %+(%d+)%.", s = "WPNSKILL_GUN" },
	{ p = "Increased Crossbows %+(%d+)%.", s = "WPNSKILL_CROSSBOW" },

	-- Equipment: Magic --
	{ p = "Improves your chance to get a critical strike with spells by (%d+)%%%.", s = "SPELLCRIT" },
	{ p = "Improves your chance to hit with spells by (%d+)%%%.", s = "SPELLHIT" },

	{ p = "Decreases the magical resistances of your spell targets by (%d+)%.", s = "SPELLPENETRATION" },

	{ p = "Increases healing done by spells and effects by up to (%d+)%.", s = "HEAL" },
	{ p = "Increases damage and healing done by magical spells and effects by up to (%d+)%.", s = { "SPELLDMG", "HEAL" } },

	{ p = "Increases damage done by Arcane spells and effects by up to (%d+)%.", s = "ARCANEDMG" },
	{ p = "Increases damage done by Fire spells and effects by up to (%d+)%.", s = "FIREDMG" },
	{ p = "Increases damage done by Nature spells and effects by up to (%d+)%.", s = "NATUREDMG" },
	{ p = "Increases damage done by Frost spells and effects by up to (%d+)%.", s = "FROSTDMG" },
	{ p = "Increases damage done by Shadow spells and effects by up to (%d+)%.", s = "SHADOWDMG" },
	{ p = "Increases damage done by Holy spells and effects by up to (%d+)%.", s = "HOLYDMG" },

	-- Equipment: Health & Mana Per 5 Sec --
	{ p = "(%d+) health per 5 sec", s = "HP5" },
	{ p = "Restores (%d+) health every 5 sec%.", s = "HP5" }, -- Resurgence Rod
	{ p = "(%d+) mana per 5 sec%.", s = "MP5" }, -- Matches equipment + Resilience of the Scourge

	-- Equipment: Professions --
	{ p = "Fishing %+(%d+)", s = "FISHING" }, -- also matches the enchant
	{ p = "Herbalism %+(%d+)", s = "HERBALISM" }, -- also matches the enchant
	{ p = "Skinning %+(%d+)", s = "SKINNING" }, -- also matches the enchant
	{ p = "Mining %+(%d+)", s = "MINING" }, -- also matches the enchant

	-- Enchants: Base Stats --
	{ p = "Strength %+(%d+)", s = "STR" },
	{ p = "Agility %+(%d+)", s = "AGI" },
	{ p = "Stamina %+(%d+)", s = "STA" },
	{ p = "Intellect %+(%d+)", s = "INT" },
	{ p = "Spirit %+(%d+)", s = "SPI" },
	{ p = "Armor %+(%d+)", s = "ARMOR" }, -- Armor enchants, Armor kits
	{ p = "^Health %+(%d+)$", s = "HP" },
	{ p = "^HP %+(%d+)$", s = "HP" }, -- Lesser Arcanum of Constitution
	{ p = "^Mana %+(%d+)$", s = "MP" },

	{ p = "All Stats %+(%d+)", s = { "STR", "AGI", "STA", "INT", "SPI" } }, -- Chest + Bracer Enchant

	-- Enchants: Speed --
	{ p = "Mithril Spurs", s = "SPEED_MOUNT", v = 4 },
	{ p = "Minor Mount Speed Increase", s = "SPEED_MOUNT", v = 2 },
	{ p = "Minor Speed Increase", s = "SPEED_RUN", v = 8 },

	-- Enchants: Resistances --
	{ p = "%+(%d+) All Resistances", s = { "ARCANERESIST", "FIRERESIST", "NATURERESIST", "FROSTRESIST", "SHADOWRESIST" } },

	-- Enchants: Avoidance --
	{ p = "Defense %+(%d+)/", s = "DEFENSE" }, -- ZG warrior Head/Leg, ZG paladin Head/Leg
	{ p = "Dodge %+(%d+)%%", s = "DODGE" },
	{ p = "Blocking %+(%d+)%%", s = "BLOCK" },
	{ p = "Block Value %+(%d+)", s = "BLOCKVALUE" },

	-- Enchants: Threat --
	{ p = "Threat %+(%d+)%%", s = "THREAT" },
	{ p = "Subtlety", s = "THREAT", v = -2 },

	-- Enchants: Stealth --
	{ p = "Increased Stealth", s = "STEALTH", v = 1 },

	-- Enchants: Melee/Ranged --
	{ p = "%+(%d+)%% Critical Strike", s = "CRIT" }, -- Might of the Scourge
	{ p = "Weapon Damage %+(%d+)", s = "WPNDMG" },
	{ p = "^Attack Power %+(%d+)", s = "AP" }, -- Might of the Scourge, ZG rogue Head/Leg
	{ p = "^%+(%d+) Attack Power$", s = "AP" }, -- Zandalar Signet of Might
	{ p = "Attack Speed %+(%d+)%%", s = { "HASTE", "SPELLHASTE", "RANGEDHASTE" } }, -- Turtle-WoW: Appears to be applied to all kinds of attacks

	-- Enchants: Melee --
	{ p = "Counterweight %+(%d+)%% Attack Speed", s = "HASTE" },

	-- Enchants: Ranged --
	{ p = "Ranged Attack Power %+(%d+)", s = "RAP" }, -- ZG hunter Head/Leg
	{ p = "^%+(%d+)%% Hit$", s = "RANGEDHIT" }, -- Biznicks 247x128 Accurascope
	{ p = "/Hit +(%d+)%%", s = "RANGEDHIT" }, -- ZG hunter Head/Leg
	{ p = "^Scope %(%+(%d+) Damage%)$", s = "RANGEDDMG" },

	-- Enchants: Magic --
	{ p = "%+(%d+)%% Spell Critical Strike", s = "SPELLCRIT" }, -- Power of the Scourge
	{ p = "Spell Hit %+(%d+)%%", s = "SPELLHIT" }, -- ZG mage Head/Leg

	{ p = "Healing Spells %+(%d+)", s = "HEAL" }, -- enchanting recipes
	{ p = "%+(%d+) Healing Spells", s = "HEAL" }, -- ZG shoulder enchant
	{ p = "Healing %+(%d+)", s = "HEAL" }, -- Resilience of the Scourge
	{ p = "^Spell Damage %+(%d+)", s = { "SPELLDMG", "HEAL" } }, -- enchanting recipes, Power of the Scourge
	{ p = "%+(%d+) Spell Damage and Healing", s = { "SPELLDMG", "HEAL" } }, -- ZG shoulder enchant
	{ p = "Healing and Spell Damage %+(%d+)", s = { "SPELLDMG", "HEAL" } }, -- Arcanum of Focus

	{ p = "Arcane Damage %+(%d+)", s = "ARCANEDMG" },
	{ p = "Fire Damage %+(%d+)", s = "FIREDMG" },
	{ p = "Nature Damage %+(%d+)", s = "NATUREDMG" },
	{ p = "Frost Damage %+(%d+)", s = "FROSTDMG" },
	{ p = "Frost Spell Damage %+(%d+)", s = "FROSTDMG" }, -- Enchant Weapon - Winter's Might
	{ p = "Shadow Damage %+(%d+)", s = "SHADOWDMG" },
	{ p = "Holy Damage %+(%d+)", s = "HOLYDMG" },

	-- Enchants: Health & Mana Per 5 Sec  --
	{ p = "Mana Regen (%d+) per 5 sec%.", s = "MP5" }, -- Bracer Enchant
	{ p = "Mana Regen (%d+)/", s = "MP5" }, -- ZG priest Head/Leg

	-- Rare effect items
	-- Demon's Blood
	{ p = "Increases Defense by 3, Shadow resistance by 10 and your normal health regeneration by 3%.",
		s = { "DEFENSE", "SHADOWRESIST", "HP5" }, v = { 3, 10, 3 } },
	-- Runeblade of Baron Rivendare
	{ p = "Increases movement speed and life regeneration rate%.", s = { "HP5", "SPEED_RUN" }, v = { 20, 8 } },


	-- Future Patterns (Disabled)
	--{ p = "When struck in combat inflicts (%d+) .+ damage to the attacker.", s = "DMGSHIELD" },
};

--------------------------------------------------------------------------------------------------------
--                                        Stat Order & Naming                                         --
--------------------------------------------------------------------------------------------------------

Inspector.stats.StatEntryOrder = {
	{ token = "BASIC", name = "Basic Stats", stats = { "STR", "AGI", "STA", "INT", "SPI", "ARMOR" } },
	{ token = "HEALTHMANA", name = "Health & Mana", stats = { "HP", "MP", "HP5", "MP5" } },
	{ token = "MELEERANGED", name = "Melee & Ranged Stats",
		stats = { "AP", "APFERAL", "UNDEAD_AP", "DRAGON_AP", "DEMON_AP", "BEAST_AP", "CRIT", "HIT", "HASTE", "WPNDMG", "RAP",
			"RANGEDCRIT", "RANGEDHIT", "RANGEDHASTE", "RANGEDDMG", "ARMORPENETRATION" } },
	{ token = "WPNSKILLS", name = "Weapon Skills",
		stats = { "WPNSKILL_SWORD", "WPNSKILL_MACE", "WPNSKILL_AXE", "WPNSKILL_DAGGER", "WPNSKILL_FIST", "WPNSKILL_SWORD_2H",
			"WPNSKILL_MACE_2H", "WPNSKILL_AXE_2H", "WPNSKILL_FERAL", "WPNSKILL_BOW", "WPNSKILL_GUN", "WPNSKILL_CROSSBOW" } },
	{ token = "SPELLSTATS", name = "Spell Stats",
		stats = { "HEAL", "SPELLDMG", "ARCANEDMG", "FIREDMG", "NATUREDMG", "FROSTDMG", "SHADOWDMG", "HOLYDMG", "SPELLCRIT",
			"SPELLHIT", "SPELLHASTE", "SPELLPENETRATION" } },
	{ token = "DEFENSESTATS", name = "Defensive Stats",
		stats = { "DEFENSE", "DODGE", "PARRY", "BLOCK", "BLOCKVALUE", "THREAT", "STEALTH" } },
	{ token = "SPEEDMODS", name = "Speed Modifiers", stats = { "SPEED_RUN", "SPEED_MOUNT", "SPEED_SWIM" } },
	{ token = "PROFS", name = "Professions", stats = { "FISHING", "HERBALISM", "MINING", "SKINNING" } },
};

Inspector.stats.StatNames = {
	["STR"] = { name = "Strength", unit = "" },
	["AGI"] = { name = "Agility", unit = "" },
	["STA"] = { name = "Stamina", unit = "" },
	["INT"] = { name = "Intellect", unit = "" },
	["SPI"] = { name = "Spirit", unit = "" },

	["ARMOR"] = { name = "Armor", unit = "" },

	["SPEED_RUN"] = { name = "Run Speed", unit = " %" },
	["SPEED_MOUNT"] = { name = "Mount Speed", unit = " %" },
	["SPEED_SWIM"] = { name = "Swim Speed", unit = " %" },

	["HP"] = { name = "Health Points", unit = "" },
	["MP"] = { name = "Mana Points", unit = "" },

	["HP5"] = { name = "Health Regen Per 5 Sec", unit = "" },
	["MP5"] = { name = "Mana Regen Per 5 Sec", unit = "" },

	["ARCANERESIST"] = { name = "Arcane Resistance", unit = "" },
	["FIRERESIST"] = { name = "Fire Resistance", unit = "" },
	["NATURERESIST"] = { name = "Nature Resistance", unit = "" },
	["FROSTRESIST"] = { name = "Frost Resistance", unit = "" },
	["SHADOWRESIST"] = { name = "Shadow Resistance", unit = "" },

	["DODGE"] = { name = "Dodge", unit = " %" },
	["PARRY"] = { name = "Parry", unit = " %" },
	["DEFENSE"] = { name = "Defense", unit = "" },
	["BLOCK"] = { name = "Block", unit = " %" },
	["BLOCKVALUE"] = { name = "Block Value", unit = "" },
	["THREAT"] = { name = "Threat", unit = " %" },
	["STEALTH"] = { name = "Stealth", unit = " lvls" },

	["AP"] = { name = "Attack Power", unit = "" },
	["APFERAL"] = { name = "Attack Power (Feral)", unit = "" },
	["UNDEAD_AP"] = { name = "Attack Power vs Undead", unit = "" },
	["DRAGON_AP"] = { name = "Attack Power vs Dragons", unit = "" },
	["DEMON_AP"] = { name = "Attack Power vs Demons", unit = "" },
	["BEAST_AP"] = { name = "Attack Power vs Beasts", unit = "" },
	["CRIT"] = { name = "Crit", unit = " %" },
	["HIT"] = { name = "Hit", unit = " %" },
	["HASTE"] = { name = "Haste", unit = " %" },
	["WPNDMG"] = { name = "Weapon Damage", unit = "" },

	["ARMORPENETRATION"] = { name = "Armor Penetration", unit = "" },

	["RAP"] = { name = "Ranged Attack Power", unit = "" },
	["RANGEDCRIT"] = { name = "Ranged Crit", unit = " %" },
	["RANEDHIT"] = { name = "Ranged Hit", unit = " %" },
	["RANGEDHASTE"] = { name = "Ranged Haste", unit = " %" },
	["RANGEDDMG"] = { name = "Ranged Damage", unit = "" },

	["WPNSKILL_SWORD"] = { name = "Sword Skill", unit = "" },
	["WPNSKILL_MACE"] = { name = "Mace Skill", unit = "" },
	["WPNSKILL_AXE"] = { name = "Axe Skill", unit = "" },
	["WPNSKILL_DAGGER"] = { name = "Dagger Skill", unit = "" },
	["WPNSKILL_FIST"] = { name = "Fist Skill", unit = "" },
	["WPNSKILL_SWORD_2H"] = { name = "Two-Handed Sword Skill", unit = "" },
	["WPNSKILL_MACE_2H"] = { name = "Two-Handed Mace Skill", unit = "" },
	["WPNSKILL_AXE_2H"] = { name = "Two-Handed Axe Skill", unit = "" },
	["WPNSKILL_FERAL"] = { name = "Feral Combat Skill", unit = "" },
	["WPNSKILL_BOW"] = { name = "Bow Skill", unit = "" },
	["WPNSKILL_GUN"] = { name = "Gun Skill", unit = "" },
	["WPNSKILL_CROSSBOW"] = { name = "Crossbow Skill", unit = "" },

	["SPELLCRIT"] = { name = "Spell Crit", unit = " %" },
	["SPELLHIT"] = { name = "Spell Hit", unit = " %" },
	["SPELLHASTE"] = { name = "Spell Haste", unit = " %" },
	["SPELLPENETRATION"] = { name = "Spell Penetration", unit = "" },

	["HEAL"] = { name = "Healing", unit = "" },
	["SPELLDMG"] = { name = "Spell Damage", unit = "" },
	["ARCANEDMG"] = { name = "Spell Damage (Arcane)", unit = "" },
	["FIREDMG"] = { name = "Spell Damage (Fire)", unit = "" },
	["NATUREDMG"] = { name = "Spell Damage (Nature)", unit = "" },
	["FROSTDMG"] = { name = "Spell Damage (Frost)", unit = "" },
	["SHADOWDMG"] = { name = "Spell Damage (Shadow)", unit = "" },
	["HOLYDMG"] = { name = "Spell Damage (Holy)", unit = "" },

	["FISHING"] = { name = "Fishing", unit = "" },
	["HERBALISM"] = { name = "Herbalism", unit = "" },
	["SKINNING"] = { name = "Skinning", unit = "" },
	["MINING"] = { name = "Mining", unit = "" },
};
