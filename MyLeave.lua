_addon.name     = 'MyLeave'
_addon.author   = 'Nsane'
_addon.version  = '2025.09.05'
_addon.commands = {'myleave', 'leave', 'ml'}

require('sets')
local res = require('resources')

-- Bag 0 = inventory
local INVENTORY_BAG = 0

-- Fast lookup of inventory by item id
local function get_inventory()
    return windower.ffxi.get_items(INVENTORY_BAG) or {}
end

local function inventory_has_item_name(wanted_name)
    if not wanted_name then return false end
    local items = get_inventory()
    for index, slot in pairs(items) do
        if type(slot) == 'table' and slot.id and slot.status == 0 then
            local r = res.items[slot.id]
            if r and r.en and r.en:lower() == wanted_name:lower() then
                return true
            end
        end
    end
    return false
end

local function drop_all_by_ids(id_set)
    local items = get_inventory()
    for index, slot in pairs(items) do
        if type(slot) == 'table' and slot.id and slot.status == 0 and id_set:contains(slot.id) then
            windower.ffxi.drop_item(index, slot.count)
        end
    end
end

local function use_if_owned(names)
    for _, name in ipairs(names) do
        if inventory_has_item_name(name) then
            windower.send_command(('input /item "%s" <me>'):format(name))
        end
    end
end

local SALVAGE_CELL_IDS = T{
    5365,5366,5367,5368,5369,5370,5371,5372,5373,5374,
    5375,5376,5377,5378,5379,5380,5381,5382,5383,5384
}

local function leave_zone()
    local zone = windower.ffxi.get_info().zone

    -- Assaults
    if T{55,56,63,66,69}:contains(zone) then
        use_if_owned{
            'Azouph Fireflies','Bhaflau Fireflies','Dvucca Fireflies',
            'Reef Fireflies','Zhayolm Fireflies'
        }

    -- Periqia (Peach in your note)
    elseif T{60}:contains(zone) then
        use_if_owned{'Cutter Fireflies'}

    -- Salvage
    elseif T{73,74,75,76}:contains(zone) then
        drop_all_by_ids(SALVAGE_CELL_IDS)
        use_if_owned{
            'A. Rem. Fireflies','B. Rem. Fireflies','S. Rem. Fireflies','Z. Rem. Fireflies'
        }

    -- Nyzul Isle (kept commented in original)
    -- elseif T{77}:contains(zone) then
    --     use_if_owned{'Un. Ruins Fireflies'}

    -- Einherjar
    elseif T{78}:contains(zone) then
        -- Drop all Glowing Lamps (5414)
        drop_all_by_ids(T{5414})

    -- Meebles & MMM
    elseif T{129}:contains(zone) then
        use_if_owned{'Hiatus Whistle','Maze Compass'}

    -- Sortie & Vagary
    elseif T{133,189,275}:contains(zone) then
        use_if_owned{'Obsid. Wing','Ontic Extremity'}

    -- Skirmish (SR)
    elseif T{259}:contains(zone) then
        use_if_owned{'Arena Fireflies'}

    -- Delve & Incursion
    elseif T{264,271}:contains(zone) then
        use_if_owned{'Ontic Extremity'}

    -- Omen
    elseif T{292}:contains(zone) then
        use_if_owned{'Reisenjima Cage'}

    -- Dynamis [D]
    elseif T{294,295,296,297}:contains(zone) then
        use_if_owned{'Black Hourglass'}

    -- HTMB & Odyssey
    elseif T{279,298}:contains(zone) then
        use_if_owned{'Moglophone','Moglophone II','V. Con. Shard'}
    end
end

windower.register_event('addon command', function(...)
    local args = T{...}
    local cmd = args[1] and args[1]:lower()

    if cmd == 'all' then
        windower.chat.input('//myleave')
        windower.send_ipc_message('myleave')
    else
        leave_zone()
    end
end)

windower.register_event('ipc message', function(msg)
    if msg == 'myleave' then
        windower.chat.input('//myleave')
    end
end)
