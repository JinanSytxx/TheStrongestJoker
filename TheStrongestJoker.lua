--- STEAMODDED HEADER
--- MOD_NAME: The Strongest Joker
--- MOD_ID: TheStrongestJoker
--- MOD_AUTHOR: [jinansytx]
--- MOD_DESCRIPTION: Adds The Strongest joker to the game.
----------------------------------------------
------------MOD CODE -------------------------
local MOD_ID = "TheStrongestJoker";

function SMODS.INIT.TheStrongestJoker()
    init_localization()

    -- Define the joker
    local joker = {
        the_strongest = {
            name = "The Strongest",
            text = {
                "Aktifkan secara otomatis.",
                "Tambah {C:mult}x1001001{} Mult dan {C:chips}+5000{} Chips."
            },
            ability = {
                extra = {}
            },
            pos = {
                x = 0,
                y = 0
            },
            rarity = 3,
            cost = 20,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
            effect = nil,
            soul_pos = nil,
            calculate = function(self, context)
                if context.individual then
                    return {
                        mult_mod = 1001001,
                        chips = 5000,
                        message = "The Strongest activated!",
                        colour = G.C.FILTER,
                        card = self
                    }
                end
                return nil
            end,
            loc_def = function(self)
                return {}
            end
        }
    }

    -- Create and register joker
    for k, v in pairs(joker) do
        local joker_obj = SMODS.Joker:new(
            v.name,
            k,
            v.ability,
            v.pos,
            {
                name = v.name,
                text = v.text
            },
            v.rarity,
            v.cost,
            v.unlocked,
            v.discovered,
            v.blueprint_compat,
            v.eternal_compat,
            v.effect,
            "TheStrongestJoker",
            v.soul_pos
        )
        joker_obj:register()
        SMODS.Jokers[joker_obj.slug].calculate = v.calculate
        SMODS.Jokers[joker_obj.slug].loc_def = v.loc_def
    end

    -- Create sprite atlas
    local mod_path = SMODS.findModByID("TheStrongestJoker").path
    SMODS.Sprite:new(
        "TheStrongestJoker",
        mod_path,
        "TheStrongestJoker.png",
        71,
        95,
        "asset_atli"
    ):register()
end

----------------------------------------------
------------MOD CODE END----------------------
