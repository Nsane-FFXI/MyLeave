_addon.name     = 'MyLeave'
_addon.author   = 'Nsane'
_addon.version  = '23.11.9'
_addon.commands = {'myleave', 'leave', 'ml'}


require('resources')
res = require('resources')


function leave_zone()
	local items = windower.ffxi.get_items(0)
	local zone = windower.ffxi.get_info().zone

	-- Assaults
	if T{55, 56, 63, 66, 69}:contains (zone) then
		windower.send_command('Input /item "Azouph Fireflies" <me>')
		windower.send_command('Input /item "Bhaflau Fireflies" <me>')
		windower.send_command('Input /item "Dvucca Fireflies" <me>')
		windower.send_command('Input /item "Reef Fireflies" <me>')
		windower.send_command('Input /item "Zhayolm Fireflies" <me>')


	-- Peach
	elseif T{60}:contains (zone) then
		windower.send_command('Input /item "Cutter Fireflies" <me>')


	-- Salvage
	elseif T{73, 74, 75, 76}:contains (zone) then
	        for index, item in pairs(items) do
                if type(item) == 'table' and T{5365,5366,5367,5368,5369,5370,5371,5372,5373,5374,5375,5376,5377,5378,5379,5380,5381,5382,5383,5384}:contains (item.id) and item.status == 0 then -- Drop's all Cells at once.
                    windower.ffxi.drop_item(index, item.count)
                end
            end
		windower.send_command('Input /item "A. Rem. Fireflies" <me>')
		windower.send_command('Input /item "B. Rem. Fireflies" <me>')
		windower.send_command('Input /item "S. Rem. Fireflies" <me>')
		windower.send_command('Input /item "Z. Rem. Fireflies" <me>')
		
		
	-- Nyzul Battlefields, added this incase future battlefields
	-- elseif T{77}:contains (zone) then
		-- windower.send_command('Input /item "Un. Ruins Fireflies " <me>')


	-- Einhejar
	elseif T{78}:contains (zone) then
            for index, item in pairs(items) do
                if type(item) == 'table' and item.id == 5414 and item.status == 0 then -- Drop's all Glowing Lamps at once.
                    windower.ffxi.drop_item(index, item.count)
                end
            end


	-- Meebles & MMM
	elseif T{129}:contains (zone) then
		windower.send_command('Input /item "Hiatus Whistle" <me>')
		windower.send_command('Input /item "Maze Compass" <me>')


	-- Sortie & Vagary
	elseif T{133, 189, 275}:contains (zone) then
		windower.send_command('Input /item "Obsid. Wing" <me>')
		windower.send_command('Input /item "Ontic Extremity" <me>')


	-- SR
	elseif T{259}:contains (zone) then
		windower.send_command('Input /item "Arena Fireflies" <me>')


	-- Delve & Incursion
	elseif T{264, 271}:contains (zone) then
		windower.send_command('Input /item "Ontic Extremity" <me>')


	-- Omen
	elseif T{292}:contains (zone) then
		windower.send_command('Input /item "Reisenjima Cage" <me>')


	-- Dynamis(D)
	elseif T{294, 295, 296, 297}:contains (zone) then
		windower.send_command('Input /item "Black Hourglass" <me>')


	-- HTMB & Odyssey
	elseif T{279, 298}:contains (zone) then
		windower.send_command('Input /item "Moglophone" <me>')
		windower.send_command('Input /item "Moglophone II" <me>')
		windower.send_command('Input /item "V. Con. Shard" <me>')

	end

end


windower.register_event('addon command',function(...)
    local args = T{...}
    local cmd = args[1]

    if cmd == 'all' then
        windower.chat.input('//myleave')
        windower.send_ipc_message('myleave')
        else
            leave_zone()
        end

end)


windower.register_event('ipc message',function (msg)

    if msg == 'myleave' then
        windower.chat.input('//myleave')
    end

end)
