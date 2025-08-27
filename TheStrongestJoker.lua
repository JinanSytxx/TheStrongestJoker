--- STEAMODDED HEADER
--- MOD_NAME: The Strongest Joker
--- MOD_ID: TheStrongestJoker
--- MOD_AUTHOR: [Jinan Sytx]
--- MOD_DESCRIPTION: Adds The Strongest joker to the game.

----------------------------------------------
------------MOD CODE -------------------------

local MOD_ID = "TheStrongestJoker";

-- Fungsi untuk efek Zawarudo
function activate_zawarudo_effect(card)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            -- Tampilkan teks "ZA WARUDO!"
            local text = G.VIEW:create_text("ZA WARUDO!", 48, G.CENTER_X, G.CENTER_Y - 100)
            text:set_color(1, 1, 1, 1)
            text:set_shadow(0, 0, 0, 1, 2)
            G.VIEW:add_element(text)
            
            -- Timer untuk menonaktifkan efek
            G.TIMER:after(2.0, function()
                G.VIEW:remove_element(text)
                card.ability.extra.zawarudo_active = false
            end)
            
            return true
        end
    }))
end

-- Fungsi untuk mengubah seluruh deck menjadi King Spade
function convert_deck_to_king_spade()
    for _, deck_card in ipairs(G.playing_cards) do
        deck_card:set_base("King", "Spades")
    end
end

-- Fungsi untuk retrigger kartu
function retrigger_cards()
    for _, deck_card in ipairs(G.playing_cards) do
        for i = 1, 5 do
            deck_card:trigger_effect()
            deck_card.ability.mult = (deck_card.ability.mult or 1) + 2.5
        end
    end
end

function SMODS.INIT.TheStrongestJoker()
    init_localization()

    -- Define the joker
    local joker = {
        the_strongest = {
            name = "The Strongest",
            text = {
                "Aktifkan dengan memainkan {C:attention}King Spade{} tunggal",
                "{C:attention}Nonaktifkan{} efek boss blind",
                "Ubah seluruh deck menjadi {C:attention}King Spade{}",
                "{C:green}+5{} retrigger dengan {C:mult}+2.5{} multi masing-masing",
                "Tambah {C:money}$10{} di akhir ronde"
            },
            ability = {
                extra = {
                    activated = false,
                    zawarudo_active = false,
                    zawarudo_timer = 0
                }
            },
            pos = { x = 0, y = 0 },
            rarity = 3, -- Legendary
            cost = 20,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
            calculate = function(self, context)
                -- Nonaktifkan boss blind
                if context.setting_blind and not context.blueprint then
                    if G.GAME.blind and G.GAME.blind.boss then
                        G.GAME.blind.disabled = true
                        self.ability.extra.activated = true
                        return {
                            message = "Boss blind disabled!",
                            colour = G.C.FILTER,
                            card = self
                        }
                    end
                end
                
                -- Aktifkan dengan memainkan King Spade tunggal
                if context.cardarea == G.play and #context.scoring_hand == 1 then
                    local played_card = context.scoring_hand[1]
                    if played_card.base.value == 13 and played_card.base.suit == "Spades" then
                        -- Aktifkan efek Zawarudo
                        self.ability.extra.zawarudo_active = true
                        self.ability.extra.zawarudo_timer = 0
                        
                        -- Tampilkan efek visual ZA WARUDO!
                        activate_zawarudo_effect(self)
                        
                        -- Ubah seluruh deck menjadi King Spade
                        convert_deck_to_king_spade()
                        
                        -- Retrigger setiap kartu 5x dengan bonus multi
                        retrigger_cards()
                        
                        self.ability.extra.activated = true
                        
                        return {
                            message = "The Strongest activated!",
                            colour = G.C.FILTER,
                            card = self
                        }
                    end
                end
                
                -- Tambah $10 di akhir ronde
                if context.end_of_round and not context.blueprint and self.ability.extra.activated then
                    ease_dollars(10)
                    self.ability.extra.activated = false
                    return {
                        message = "Added $10!",
                        colour = G.C.MONEY,
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
            { name = v.name, text = v.text }, 
            v.rarity, 
            v.cost, 
            v.unlocked, 
            v.discovered, 
            v.blueprint_compat, 
            v.eternal_compat,
            nil,  -- effect
            "TheStrongestJoker",  -- atlas
            nil   -- soul_pos
        )
        
        joker_obj:register()
        
        -- Add calculate function
        SMODS.Jokers[joker_obj.slug].calculate = v.calculate
        SMODS.Jokers[joker_obj.slug].loc_def = v.loc_def
    end
    
    -- Create sprite atlas
    SMODS.Sprite:new(
        "TheStrongestJoker", 
        SMODS.findModByID("TheStrongestJoker").path, 
        "TheStrongestJoker.png", 
        71, 
        95, 
        "asset_atli"
    ):register()
end

----------------------------------------------
------------MOD CODE END----------------------