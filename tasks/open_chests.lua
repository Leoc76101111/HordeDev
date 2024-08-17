local utils = require "core.utils"
local settings = require "core.settings"
local enums = require "data.enums"
local tracker = require "core.tracker"

local open_chests_task = {
    name = "Open Chests",
    shouldExecute = function()
        return utils.player_in_zone("S05_BSK_Prototype02") and utils.player_on_quest(2023962)
    end,
    
    Execute = function()
        local current_time = get_time_since_inject()
        console.print(string.format("Execute called at %.2f, tracker.ga_chest_open_time: %.2f, tracker.ga_chest_opened: %s", 
                                    current_time, tracker.ga_chest_open_time or 0, tostring(tracker.ga_chest_opened)))
        console.print(string.format("Current settings: always_open_ga_chest: %s, selected_chest_type: %s, chest_opening_time: %d", 
                                    tostring(settings.always_open_ga_chest), tostring(settings.selected_chest_type), settings.chest_opening_time))

        local function open_chest(chest)
            if chest then
                console.print(chest:get_skin_name() .. " found, interacting")
                if utils.distance_to(chest) > 2 then
                    pathfinder.request_move(chest:get_position())
                    return false
                else
                    local success = interact_object(chest)
                    console.print("Chest interaction result: " .. tostring(success))
                    return success
                end
            end
            return false
        end

        local function handle_chest_opening(chest_type)
            local chest_id = enums.chest_types[chest_type]
            local chest = utils.get_chest(chest_id)
            if chest then
                if tracker.check_time("peasant_chest_opening_time", 1) then
                    local success = open_chest(chest)
                    console.print(string.format("Attempting to open chest type: %s (ID: %s)", chest_type, chest_id))
                    if success then
                        console.print("Chest opened successfully.")
                    else
                        console.print("Failed to open chest.")
                    end
                end
            else
                console.print("Chest not found")
            end
        end

        -- Check if 10 seconds have passed since opening the GA chest
        if tracker.ga_chest_open_time > 0 and (current_time - tracker.ga_chest_open_time > 5) then
            tracker.ga_chest_opened = true
            console.print("GA chest looting time over. Will not attempt again this session.")
        end

        if settings.always_open_ga_chest and not tracker.ga_chest_opened then
            console.print("Attempting to open GA chest")
            if tracker.ga_chest_open_time == 0 or (current_time - tracker.ga_chest_open_time > 5) then
                local ga_chest = utils.get_chest("BSK_UniqueOpChest_GreaterAffix")
                if ga_chest then
                    local success = open_chest(ga_chest)
                    if success then
                        tracker.ga_chest_open_time = current_time
                        console.print(string.format("GA chest opened at %.2f. Waiting 10 seconds for looting.", tracker.ga_chest_open_time))
                    else
                        console.print("Failed to open GA chest")
                    end
                else
                    console.print("GA chest not found")
                end
            else
                console.print(string.format("Waiting for cooldown. Time since last open: %.2f", current_time - tracker.ga_chest_open_time))
            end
        else
            local chest_type_map = {"GEAR", "MATERIALS", "GOLD"}
            local selected_chest_type = chest_type_map[settings.selected_chest_type + 1]
            if tracker.peasant_chest_open_time == 0 then
                tracker.peasant_chest_open_time = current_time
            end

            if current_time - tracker.peasant_chest_open_time <= settings.chest_opening_time then
                handle_chest_opening(selected_chest_type)
            else
                console.print("Chest opening time exceeded. Stopping attempts.")
                tracker.peasant_chest_opening_stopped = true

                -- Check if the selected chest type isn't gold
                if selected_chest_type ~= "GOLD" and not tracker.gold_chest_opened then
                    console.print("Selected chest type isn't gold. Attempting to open gold chest for 5 seconds.")
                    if tracker.gold_chest_open_time == 0 then
                        tracker.gold_chest_open_time = current_time
                    end

                    if current_time - tracker.gold_chest_open_time <= 5 then
                        handle_chest_opening("GOLD")
                    else
                        console.print("Gold chest opening time exceeded. Stopping attempts.")
                        tracker.gold_chest_opened = true
                    end
                end
            end
        end

        console.print(string.format("Execute finished at %.2f, tracker.ga_chest_opened: %s", 
                                    get_time_since_inject(), tostring(tracker.ga_chest_opened)))
    end
}

return open_chests_task