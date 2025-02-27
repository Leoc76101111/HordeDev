local utils = require "core.utils"
local settings = require "core.settings"
local tracker = require "core.tracker"
local open_chests_task = require "tasks.open_chests"

local function reset_chest_flags()
    open_chests_task:reset()
    tracker.finished_looting_start_time = nil
    console.print("Chest flags reset for new dungeon run")
end

local function use_dungeon_sigil()
    if tracker.sigil_used then
        console.print("Horde already opened this session. Skipping.")
        return false
    end

    local local_player = get_local_player()
    local inventory = local_player:get_dungeon_key_items()
    
    -- List of valid sigil names
    local valid_sigils = {}

    if settings.use_6_wave then
        table.insert(valid_sigils, "S05_DungeonSigil_BSK_Wave6")
    end

    if settings.use_8_wave then
        table.insert(valid_sigils, "S05_DungeonSigil_BSK_Wave8")
    end

    if settings.use_10_wave then
        table.insert(valid_sigils, "S05_DungeonSigil_BSK_Wave10")
    end
    
    for _, item in pairs(inventory) do
        local item_info = utils.get_consumable_info(item)
        if item_info then
            for _, sigil_name in ipairs(valid_sigils) do
                if item_info.name == sigil_name then
                    console.print("Found Dungeon Sigil. Attempting to use it.")
                    local success, error = pcall(use_item, item)
                    if success then
                        console.print("Successfully used Dungeon Sigil.")
                        tracker.sigil_used = true
                        tracker.first_run = true
                        return true
                    else
                        console.print("Failed to use Dungeon Sigil: " .. tostring(error))
                        return false
                    end
                end
            end
        end
    end

    console.print("Dungeon Sigil not found in inventory.")
    
    -- Stop script and run pit
    if settings.run_pit then
        if PitPlugin then
            InfernalHordesPlugin.disable()
            PitPlugin.enable()
        else 
            console.print("Pit version does not support auto start")
        end
    end
    
    return false
end

local function accept_sigil_prompt()
    if tracker.sigil_used then
        -- Wait for 2 seconds for prompt to appear
        if not tracker.check_time("wait_for_start_dialog", 2) then
            console.print("Waiting for confirmation dialog")
        else
            utility.confirm_sigil_notification()
            console.print("Sigil confirmed. Time to farm!")
            tracker.horde_opened = true
        end
    end
end

local start_dungeon_task = {
    name = "Start Dungeon",
    shouldExecute = function()
        return utils.player_in_zone("Kehj_Caldeum") 
            and not tracker.horde_opened         
    end,

    Execute = function()
        local current_time = get_time_since_inject()
        if not tracker.start_dungeon_time then
            console.print("Stay a while and listen")
            tracker.start_dungeon_time = current_time
        end

        local elapsed_time = current_time - tracker.start_dungeon_time
        if elapsed_time >= 5 then
            if not tracker.sigil_used then
                console.print("Attempting to use Dungeon Sigil")
                tracker.teleported_from_town = false -- reset walk to horde
                reset_chest_flags() -- Reset chest flags at the start of the dungeon
                use_dungeon_sigil()
            else
                accept_sigil_prompt()
            end  
        else
            console.print(string.format("Waiting before using Dungeon Sigil... %.2f seconds remaining.", 5 - elapsed_time))
        end
    end
}

return start_dungeon_task
