local tempStorageCompact = {}
local timer = 0
local darknessForce = 0
function FuCompact_update_madnessModiff(dt, madnessPercent)
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
			D8Madness_modiff = D8Madness_modiff + -(freudBonus * (1.75 * 2)) -- Maddening Idea Resource modifier
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

function FuCompact_update_darkness(dt, madnessPercent)
	local darklevel, darkpriority = (status.statusProperty("darklevel") or 0), (status.statusProperty("darkpriority") or 0)
	local darknessImmunity = (status.stat("darknessImmunity") or 0)
	if (darklevel <= 0) or (darknessImmunity > 0) then
		if darknessForce > 0 then darknessForce = darknessForce - dt end
		if darknessForce < 0 then darknessForce = 0 end
		return 
	else
		if darknessForce < 1 then darknessForce = darknessForce + dt end
		if darknessForce > 1 then darknessForce = 1 end
	end
	local levelConversion = {
		2,
		4,
		6,
		7
	}
	local foundEffect
	for i, a in pairs(madnessEffects) do 
		if a.name then
			if string.find(a.name, "d8Madness_darkenView") then
				foundEffect = true
				local str = string.gsub(a.name, "d8Madness_darkenView", "")
				local _level = tonumber(str)
				if _level <= levelConversion[darklevel] then
					madnessEffects[i].force = (madnessEffects[i].force or 0) + darknessForce
				else
					madnessEffects[i].force = nil
				end
			end
		end
	end
	D8Madness_modiff = D8Madness_modiff + (darklevel * darknessForce)
end
local insanityImmunityApplied = false
local insanityModiff = 0
function FuCompact_update_insanityImmunity(dt, madnessPercent)
	local insanityImmunity = (status.stat("insanityImmunity") or 0)
	if (insanityImmunity > 0) then
		if (not insanityImmunityApplied) then
			if insanityModiff < 1 then insanityModiff = math.min(insanityModiff + (dt * 0.25), 1) end
			effectStrenghtModifier = effectStrenghtModifier - ((math.max(math.abs(0 - effectStrenghtModifier), 0)) * insanityModiff)
			if insanityModiff >= 1 then insanityImmunityApplied = true end
		end
		
	elseif insanityImmunityApplied then
		if insanityModiff > 0 then insanityModiff = math.max(insanityModiff - (dt * 0.25), 0) end
		effectStrenghtModifier = effectStrenghtModifier + (math.max(math.abs(1 - effectStrenghtModifier), 0) * insanityModiff)
		if insanityModiff <= 0 then insanityImmunityApplied = false end
	end
	sb.setLogMap("D8:Madness FU insanityImmunity", "%s|%s : %s", insanityImmunity, effectStrenghtModifier, insanityModiff)
end

function load()
    D8Madness.addCompact("update", FuCompact_update_madnessModiff)
    D8Madness.addCompact("update", FuCompact_update_insanityImmunity)
    D8Madness.addCompact("update", FuCompact_update_darkness)
end