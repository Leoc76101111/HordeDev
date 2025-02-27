local enums = {
    quests = {
        pit_ongoing = 1815152,
        pit_started = 1922713
    },
    portal_names = {
        horde_portal = "Portal_Dungeon_Generic",
        horde_gate = "QST_Caldeum_GatesToHell_Seal"
    },
    misc = {
        obelisk = "TWN_Kehj_IronWolves_PitKey_Crafter",
        blacksmith = "TWN_Scos_Cerrigar_Crafter_Blacksmith",
        jeweler = "TWN_Scos_Cerrigar_Vendor_Weapons",
        portal = "TownPortal"
    },
    positions = {
        obelisk_position = vec3:new(-1659.1735839844, -613.06573486328, 37.2822265625),
        blacksmith_position = vec3:new(-1685.5394287109, -596.86566162109, 37.6484375),
        jeweler_position = vec3:new(-1658.699219, -620.020508, 37.888672), 
        portal_position = vec3:new(-1656.7141113281, -598.21716308594, 36.28515625), 
        portal_door = vec3:new(28.782243728638, -479.67123413086, -24.51171875) 
    },
    chest_types = {
        MATERIALS = "BSK_UniqueOpChest_Materials",
        GOLD = "BSK_UniqueOpChest_Gold",
        GREATER_AFFIX = "BSK_UniqueOpChest_GreaterAffix"
    },
    waypoints = {
        CERRIGAR = 0x76D58,
        LIBRARY = 0x10D63D
    },
}

return enums