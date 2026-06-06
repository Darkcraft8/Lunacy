-- Primary Script don't have acces to player table
function init()
    message.setHandler("say", function(_, isLocal, str)
        if isLocal then
            if player.say then player.say(str) else
                
            end
        end
    end)
	message.setHandler("giveItem", function(_, isLocal, _item)
        if isLocal then
			if type(_item) == "table" then
				player.giveItem(_item)
			else
				player.giveItem(_item)
			end
        end
    end)
	message.setHandler("modiffCurrency", function(_, isLocal, _item)
        if isLocal then
			if type(_item) == "table" then
				if _item.count >= 1 then
					player.addCurrency(_item.name, _item.count)
				elseif _item.count <= -1 then
					player.consumeCurrency(_item.name, _item.count * -1)
				end
			else
				player.addCurrency(_item, 1)
			end
        end
    end)
end