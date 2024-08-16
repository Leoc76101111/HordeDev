local settings = require "core.settings"
local task_manager = {}
local tasks = {}
local current_task = nil
local finished_time = 0

function task_manager.set_finished_time(time)
    finished_time = time
end

function task_manager.get_finished_time()
    return finished_time
end

function task_manager.register_task(task)
    table.insert(tasks, task)
end

local last_call_time = 0.0
function task_manager.execute_tasks()
    
    local current_core_time = get_time_since_inject()
    if current_core_time - last_call_time < 0.2 then
        return -- quick ej slide frames
    end

    last_call_time = current_core_time

    local is_exit_or_finish_active = false
    for _, task in ipairs(tasks) do
        if task.shouldExecute() then
            current_task = task
            if task.name == "Exit Pit" or task.name == "Finish Pit" then
                is_exit_or_finish_active = true
            end
            task:Execute()
            break -- Execute only one task per pulse
        end
    end

    if not current_task then
        current_task = { name = "Idle" } -- Default state when no task is active
    end
end

function task_manager.get_current_task()
    return current_task or { name = "Idle" }
end

local task_files = { "open_chests" , "horde" }
for _, file in ipairs(task_files) do
    local task = require("tasks." .. file)
    task_manager.register_task(task)
end

return task_manager