local tempStorageCompact = {}
local timer = 0
function FuCompact_update(dt, madnessPercent)
    -- capping minimum Maddening Idea(madness) resources
        local currencyConfig = tempStorageCompact["fumadnessresource"] or root.assetJson("/currencies.config")["fumadnessresource"]
        if not currencyConfig then return end
		if not (D8Madness_count and D8Madness_max and D8Madness_modiff) then return end
        local resourceName = "fumadnessresource"
        local count = world.entityCurrency(entity.id(), resourceName)
        local cap = (1000 * madnessPercent)
		local reduction, freudBonus = status.stat("mentalProtection"), status.stat("freudBonus")
		local currenciesDist = math.floor(cap - count) * 0.25
		sb.setLogMap("D8:Madness FU Capper Time", "(%s > 0) : %s | timer : %s", freudBonus, (freudBonus > 0), timer)
		if timer > 0 then timer = timer - dt else
			if not (freudBonus > 0) then
				if currenciesDist > 0 then
					sb.setLogMap("D8:Madness FU Capper", "adding madness resource %s", currenciesDist)
					world.sendEntityMessage(entity.id(), "modiffCurrency", {name = "fumadnessresource", count = currenciesDist})
				end
			else
				sb.setLogMap("D8:Madness FU Capper", "moving madness resource %s", currenciesDist)
				world.sendEntityMessage(entity.id(), "modiffCurrency", {name = "fumadnessresource", count = currenciesDist})
			end
			timer = 0.25
		end
		
		if (freudBonus > 0) then
			sb.setLogMap("D8:Madness FU Modifier", "count %s, cap %s, healing %s, currenciesDist : %s", count, cap, freudBonus * 1.75, currenciesDist)
			D8Madness_modiff = D8Madness_modiff + -(freudBonus * 1.75) -- Maddening Idea Resource modifier
		else
			-- D8Madness_count modifier based on amount of Maddening Idea
				local fuModiff = (100 * (count / currencyConfig.playerMax)) * (1 - reduction)
				sb.setLogMap("D8:Madness FU Modifier", "count %s, cap %s, modiff %s, reduction %s, currenciesDist : %s", count, cap, fuModiff, reduction, currenciesDist)
				D8Madness_modiff = D8Madness_modiff + fuModiff -- Maddening Idea Resource modifier
			--
        end
        if not tempStorageCompact["fumadnessresource"] then tempStorageCompact["fumadnessresource"] = currencyConfig end
    --
end

function load()
    D8Madness.addCompact("update", FuCompact_update)
end