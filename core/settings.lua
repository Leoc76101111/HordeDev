local gui = require "gui"
local settings = {
    enabled = false,
    use_keybind = false,
    elites_only = false,
    run_pit = false,
    party_mode = false,
    pit_level = 1,
    salvage = true,
    aggresive_movement = true, 
    path_angle = 10,
    reset_time = 1,
    selected_chest_type = 0,
    always_open_ga_chest = true,
    merry_go_round = true,
    movement_spell_to_objective = true,
    use_evade_as_movement_spell = true,
    use_teleport = true,
    use_teleport_enchanted = true,
    use_dash = true,
    use_shadow_step = true,
    use_the_hunter = true,
    use_rushing_claw = true,
    use_soar = true,
    open_chest_delay = 1.5,
    open_ga_chest_delay = 3,
    wait_loot_delay = 10,
    boss_kill_delay = 6,
    chest_move_attempts = 40,
    use_salvage_filter_toggle = false,
    affix_salvage_count = 0,
    greater_affix_count = 0,
    use_alfred = true,
}

function settings:update_settings()
    settings.enabled = gui.elements.main_toggle:get()
    settings.use_keybind = gui.elements.use_keybind:get()
    settings.salvage = gui.elements.salvage_toggle:get()
    settings.run_pit = gui.elements.run_pit_toggle:get()
    settings.party_mode = gui.elements.party_mode_toggle:get()
    settings.aggresive_movement = gui.elements.aggresive_movement_toggle:get() -- Finn's movement logic
    settings.path_angle = gui.elements.path_angle_slider:get()
    settings.selected_chest_type = gui.elements.chest_type_selector:get()
    settings.always_open_ga_chest = gui.elements.always_open_ga_chest:get()
    settings.merry_go_round = gui.elements.merry_go_round:get()
    settings.movement_spell_to_objective = gui.elements.movement_spell_to_objective:get()
    settings.use_evade_as_movement_spell = gui.elements.use_evade_as_movement_spell:get()
    settings.use_teleport = gui.elements.use_teleport:get()
    settings.use_teleport_enchanted = gui.elements.use_teleport_enchanted:get()
    settings.use_dash = gui.elements.use_dash:get()
    settings.use_shadow_step = gui.elements.use_shadow_step:get()
    settings.use_the_hunter = gui.elements.use_the_hunter:get()
    settings.use_soar = gui.elements.use_soar:get()
    settings.use_rushing_claw = gui.elements.use_rushing_claw:get()
    settings.open_chest_delay = gui.elements.open_chest_delay:get()
    settings.open_ga_chest_delay = gui.elements.open_ga_chest_delay:get()
    settings.wait_loot_delay = gui.elements.wait_loot_delay:get()
    settings.boss_kill_delay = gui.elements.boss_kill_delay:get()
    settings.chest_move_attempts = gui.elements.chest_move_attempts:get()
    settings.use_salvage_filter_toggle = gui.elements.use_salvage_filter_toggle:get()
    settings.affix_salvage_count = gui.elements.affix_salvage_count:get()
    settings.greater_affix_count = gui.elements.greater_affix_count:get()
    settings.use_alfred = gui.elements.use_alfred:get()
end

return settings