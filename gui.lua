local gui = {}
local plugin_label = "infernal_horde"

local function create_checkbox(value, key)
    return checkbox:new(value, get_hash(plugin_label .. "_" .. key))
end

-- Add chest types enum
gui.chest_types_enum = {
    MATERIALS = 0,
    GOLD = 1,
}

gui.chest_types_options = {
    "Materials",
    "Gold",
}

gui.failover_chest_types_options = {
    "Materials",
    "Gold",
}

gui.elements = {
    main_tree = tree_node:new(0),
    main_toggle = create_checkbox(false, "main_toggle"),
    use_keybind = create_checkbox(false, "use_keybind"),
    keybind_toggle = keybind:new(0x0A, true, get_hash(plugin_label .. "_keybind_toggle" )),
    settings_tree = tree_node:new(1),
    party_mode_toggle = create_checkbox(false, "party_mode"),
    salvage_toggle = create_checkbox(true, "salvage_toggle"),
    aggresive_movement_toggle = create_checkbox(true, "aggresive_movement_toggle"),
    path_angle_slider = slider_int:new(0, 360, 10, get_hash(plugin_label .. "path_angle_slider")), -- 10 is a default value
    chest_type_selector = combo_box:new(0, get_hash(plugin_label .. "chest_type_selector")),
    failover_chest_type_selector = combo_box:new(0, get_hash(plugin_label .. "failover_chest_type_selector")),
    always_open_ga_chest = create_checkbox(true, "always_open_ga_chest"),
    merry_go_round = create_checkbox(true, "merry_go_round"),
    open_ga_chest_delay = slider_float:new(3, 10.0, 3.0, get_hash(plugin_label .. "open_ga_chest_delay")), -- 3.0 is the default value
    open_chest_delay = slider_float:new(1.0, 3.0, 1.5, get_hash(plugin_label .. "open_chest_delay")), -- 1.5 is the default value
    wait_loot_delay = slider_int:new(1, 20, 10, get_hash(plugin_label .. "wait_loot_delay")), -- 10 is a default value
    boss_kill_delay = slider_int:new(1, 15, 6, get_hash(plugin_label .. "boss_kill_delay")), -- 6 is a default value
    chest_move_attempts = slider_int:new(20, 400, 40, get_hash(plugin_label .. "chest_move_attempts")), -- 40 is a default value
    use_salvage_filter_toggle = create_checkbox(false, "use_salvage_filter_toggle"),
    greater_affix_count = slider_int:new(0, 3, 0, get_hash(plugin_label .. "greater_affix_count")), -- 0 is the default value
    affix_salvage_count = slider_int:new(0, 3, 1, get_hash(plugin_label .. "affix_salvage_count")), -- 0 is a default value
    movement_spell_to_objective = create_checkbox(true, "movement_spell_to_objective"),
    use_evade_as_movement_spell = create_checkbox(true, "use_evade_as_movement_spell"),
}

function gui.render()
    if not gui.elements.main_tree:push("Infernal Horde | Letrico | v1.2.7") then return end

    gui.elements.main_toggle:render("Enable", "Enable the bot")
    gui.elements.use_keybind:render("Use keybind", "Keybind to quick toggle the bot");
    if gui.elements.use_keybind:get() then
        gui.elements.keybind_toggle:render("Toggle Keybind", "Toggle the bot for quick enable");
    end
    if gui.elements.settings_tree:push("Settings") then
        gui.elements.party_mode_toggle:render("Party mode (Does not pick pylon)", "Does not activate Pylon");
        gui.elements.aggresive_movement_toggle:render("Aggresive movement", "Move directly to target, will fight close to target")
        if not gui.elements.aggresive_movement_toggle:get() then
            gui.elements.path_angle_slider:render("Path Angle", "Adjust the angle for path filtering (0-360 degrees)")
        end
        gui.elements.movement_spell_to_objective:render("Attempt to use movement spell for objective", "Will attempt to use movement spell towards objective")
        if gui.elements.movement_spell_to_objective:get() then
            gui.elements.use_evade_as_movement_spell:render("Use evade as movement spell", "Will attempt to use evade as movement spell")
        end
        gui.elements.salvage_toggle:render("Salvage", "Enable salvaging items")
        if gui.elements.salvage_toggle:get() then
            gui.elements.use_salvage_filter_toggle:render("Use salvage filter logic (update filter)", "Salvage based on filter logic. Update filter") 
            gui.elements.greater_affix_count:render("Min Greater Affixes to Keep", "Select minimum number of Greater Affixes to keep an item (0-3, 0 = off)")
            if gui.elements.salvage_toggle:get() and gui.elements.use_salvage_filter_toggle:get() then
                gui.elements.affix_salvage_count:render("Min No. affixes to keep", "Minimum number of matching affixes to keep")
            end
        end
        -- Updated chest type selector to use the new enum structure
        gui.elements.chest_type_selector:render("Chest Type", gui.chest_types_options, "Select the type of chest to open")
        if not gui.elements.salvage_toggle:get() then
            gui.elements.failover_chest_type_selector:render("Failover Chest Type When Inventory is full", gui.failover_chest_types_options, "Select the failover type of chest to open when inventory is full")
        end
        gui.elements.always_open_ga_chest:render("Always Open GA Chest", "Toggle to always open Greater Affix chest when available")
        gui.elements.merry_go_round:render("Circle arena when wave completes", "Toggle to circle arene when wave completes to pick up stray Aethers")
        gui.elements.open_ga_chest_delay:render("GA Chest open delay", "Adjust delay for the chest opening (1.0-3.0)", 1)
        gui.elements.open_chest_delay:render("Chest open delay", "Adjust delay for the chest opening (1.0-3.0)", 1)
        gui.elements.wait_loot_delay:render("Wait loot delay", "Adjust delay for the waiting loot (12)", 1)
        gui.elements.boss_kill_delay:render("Boss kill delay", "Adjust delay after killing boss (1-15)")
        gui.elements.chest_move_attempts:render("Chest move attempts", "Adjust the amount of times it tries to reach a chest (20-400)")
        
        gui.elements.settings_tree:pop()
    end

    gui.elements.main_tree:pop()
end

return gui