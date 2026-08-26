require"/shared/darkcraft8/localScript/deployment/rendererUtil.lua"

local test = {
    overlay = function()
        local overlays = {
            {
                type = "music",
                require = 0.5,
                transitionSpeed = 2.5,
                exitTransitionSpeed = 1,
                pool = {"/sfx/environmental/tundra_underground.ogg", "/sfx/environmental/crystal_underground.ogg", "/sfx/environmental/moon_underground.ogg"}
            },
            {
                type = "bark",
                require = 0.5,
                chance = 0.01,
                pool = {"Do your ear the whistle ?", "~Audible Heartbeat~", "Was that tree always there ?", "Augh! did i hallucinate that?", "Did you heard that ?!", "...", "They all slumber when we wake and wake when we slumber...", ";_;"}
            },
            {
                type = "bark",
                require = 0.5,
                chance = 0.005,
                pool = {"There Crawling under my skin!!!"}
            },
            {
                type = "overlay",
                priority = -10,
                require = {0.5, 1},
                zoom = 4,
                texture = "/objects/mission/bossweb/bossweb.png?hueshift=-100?saturation=50?brightness=-70",
                name = "d8Madness_vein",
                xSine = {
                    intensity = 0.75,
                    range = 1.5 + math.random(-1, 1)
                },
                ySine = {
                    intensity = -1.75,
                    range = 1.5 + math.random(-1, 1)
                },
                alpha = {0, 50},
                alphaSine = {
                    intensity = 0.25,
                    range = 50
                }
            },
            {
                type = "overlay",
                priority = -10,
                require = {0.5, 1},
                zoom = 4,
                texture = "/objects/mission/bossweb/bossweb.png?hueshift=-100?saturation=50?brightness=-70",
                name = "d8Madness_vein2",
                xSine = {
                    intensity = -1.75,
                    range = 1.5 + math.random(-1, 1)
                },
                ySine = {
                    intensity = 0.75,
                    range = 1.5 + math.random(-1, 1)
                },
                alpha = {0, 50},
                alphaSine = {
                    intensity = -0.25,
                    range = 50
                }
            },
            {
                type = "overlay",
                require = {0.1, 1},
                zoom = {60, 4},
                texture = "/cinematics/story/blackcircle.png?setcolor=000?multiply=fff8",
                name = "d8Madness_darkenView7",
                xSine = {
                    intensity = 1.75,
                    range = 1
                },
                ySine = {
                    intensity = -1 + math.random(-1, 1),
                    range = 1.5
                }
            },
            {
                type = "overlay",
                require = {0.1, 0.9},
                zoom = {60, 6},
                texture = "/cinematics/story/blackcircle.png?setcolor=000?multiply=fff8",
                name = "d8Madness_darkenView6",
                xSine = {
                    intensity = -1.5,
                    range = 1
                },
                ySine = {
                    intensity = 1 + math.random(-1, 1),
                    range = 1.5
                }
            },
            {
                type = "overlay",
                require = {0.1, 0.8},
                zoom = {60, 8},
                texture = "/cinematics/story/blackcircle.png?setcolor=000?multiply=fff8",
                name = "d8Madness_darkenView5",
                xSine = {
                    intensity = 1.25,
                    range = 1
                },
                ySine = {
                    intensity = -1 + math.random(-1, 1),
                    range = 1.5
                }
            },
            {
                type = "overlay",
                require = {0.1, 0.7},
                zoom = {60, 10},
                texture = "/cinematics/story/blackcircle.png?setcolor=000?multiply=fff8",
                name = "d8Madness_darkenView4",
                xSine = {
                    intensity = -1,
                    range = 1
                },
                ySine = {
                    intensity = 1 + math.random(-1, 1),
                    range = 1.5
                }
            },
            {
                type = "overlay",
                require = {0.1, 0.6},
                zoom = {60, 12.5},
                texture = "/cinematics/story/blackcircle.png?setcolor=000?multiply=fff8",
                name = "d8Madness_darkenView3",
                xSine = {
                    intensity = 0.75,
                    range = 1
                },
                ySine = {
                    intensity = -1 + math.random(-1, 1),
                    range = 1.5
                }
            },
            {
                type = "overlay",
                require = {0.1, 0.5},
                zoom = {60, 15},
                texture = "/cinematics/story/blackcircle.png?setcolor=000?multiply=fff8",
                name = "d8Madness_darkenView2",
                xSine = {
                    intensity = -0.5,
                    range = 1
                },
                ySine = {
                    intensity = 1 + math.random(-1, 1),
                    range = 1.5
                }
            },
            {
                type = "overlay",
                require = {0.1, 0.45},
                zoom = {60, 18},
                texture = "/cinematics/story/blackcircle.png?setcolor=000?multiply=fff8",
                name = "d8Madness_darkenView1",
                xSine = {
                    intensity = 0.25,
                    range = 1
                },
                ySine = {
                    intensity = -1 + math.random(-1, 1),
                    range = 1.5
                }
            }
        }
        for _, a in pairs(overlays) do 
            table.insert(madnessEffects, a)
        end
    end
}
local tempStorage = {}
local time = 0
D8Madness_max = 1000
D8Madness_count = 0
D8Madness_modiff = 0
local scriptConfig = "/stats/d8Madness/madnessScript.config"
D8Madness = {
    parameters = {
        renderDefaultIcon = true
    },
    compact = {
        init = {},
        update = {},
        uninit = {},
        effect = {}
    }
}
madnessEffects = {}
function D8Madness.addCompact(category, _function, _priority)
    D8Madness.compact[category] = D8Madness.compact[category] or {}
    table.insert(D8Madness.compact[category], {callback = _function, priority = _priority or 0})
	table.sort(D8Madness.compact[category], function(a, b)
		return a.priority > b.priority
	end)
end

function D8Madness.getParameter(paramName, defaultValue)
    return D8Madness.parameters[paramName] or defaultValue
end
function D8Madness.setParameter(paramName, value)
    D8Madness.parameters[paramName] = value
end

function D8Madness.init()
    if type(scriptConfig) == "string" then scriptConfig = root.assetJson(scriptConfig) end
    for _, path in pairs(scriptConfig.load) do 
        require(path)
        load()
    end
    test.overlay()
    D8Madness_count = status.statusProperty("D8_MadnessCount", 0)
    message.setHandler("D8Madness_modifyCount", function(_, _, amount)
        if amount then
            D8Madness_count = util.clamp((D8Madness_count + amount), 0, D8Madness_max)
        end
    end)
    message.setHandler("D8Madness_getCount", function(_, _, requestedBy)
        return D8Madness_count
    end)
    message.setHandler("D8Madness_hideIcon", function(isLocal, _, bool)
        if isLocal then D8Madness.setParameter("hideIcon", bool) end
    end)
    
    for _, a in pairs(D8Madness.compact.init) do 
        a.callback()
    end
end

function D8Madness.update(dt)
    local madnessPercent = (D8Madness_count / D8Madness_max)
    time = time + dt
    D8Madness_count = util.clamp(math.min(D8Madness_count + ((dt * 0.25) * (D8Madness_modiff)), D8Madness_max), 0, D8Madness_max)
    sb.setLogMap("D8:Madness Lunacy Percent", "%s : %s%s", util.round(D8Madness_count), "%", madnessPercent)
    if D8Madness.getParameter("renderDefaultIcon") and (not D8Madness.getParameter("hideIcon")) then D8Madness.renderIcon(madnessPercent) else D8Madness.clearIcon() end
    D8Madness.effect(dt, madnessPercent)
    D8Madness.modifier(dt)
    for _, a in pairs(D8Madness.compact.update) do 
        a.callback(dt, madnessPercent)
    end
	sb.setLogMap("D8:Madness Total Modiff", "%s", D8Madness_modiff)
end

function D8Madness.uninit()
    D8Madness.clearIcon()

    if not status.resourcePositive("health") then
        local deathPenalty = (D8Madness_max/2 * (D8Madness_count / (D8Madness_max/2))) / 4
        D8Madness_count = math.min(D8Madness_count + deathPenalty, D8Madness_max/2)
    end
    sb.setLogMap("D8:Madness Lunacy Percent", "%s : %s%s", util.round(D8Madness_count), "%", (D8Madness_count / D8Madness_max))
    for _, a in pairs(D8Madness.compact.uninit) do 
        D8Madness_count = a.callback(D8Madness_count) or D8Madness_count
    end
    --status.addPersistentEffect("D8_Madness", {})
    status.setStatusProperty("D8_MadnessCount", D8Madness_count)
end

function D8Madness.renderIcon(madnessPercent)
    local iconTexture = "/items/generic/crafting/inferiorbrain.png"
    local fillTexture = "/items/generic/crafting/brain.png"
    local drawable = {
        image = iconTexture,
        position = {1.125, 1.125},
        scale = 1,
        fullbright = true,
        centered = false,
        color = {255, 255, 255, 255}
    }
    if not d8SharedRendererUtil.hasDrawable("d8Madness_Icon") then
        local addedIcon = d8SharedRendererUtil.addDrawable(drawable, 0, "d8Madness_Icon")
        drawable.image = "/objects/floran/huntingtrophy1/huntingtrophy1.png"
        drawable.position = {1, 1}
        local addedIconBackground = d8SharedRendererUtil.addDrawable(drawable, -1, "d8Madness_IconBackground")
        local imageSize = root.imageSize(fillTexture)
        drawable.image = fillTexture .. string.format("?crop;0;0;%s;%s", imageSize[1], util.clamp(imageSize[2] - math.floor(imageSize[2] * madnessPercent), 0, imageSize[2]))
        drawable.position = {1.125, 1.125}
        local addedFillIcon = d8SharedRendererUtil.addDrawable(drawable, 1, "d8Madness_IconFill")
    else
        d8SharedRendererUtil.updateDrawable(drawable, "d8Madness_Icon")
        drawable.image = "/objects/floran/huntingtrophy1/huntingtrophy1.png"
        drawable.position = {1, 1}
        d8SharedRendererUtil.updateDrawable(drawable, "d8Madness_IconBackground")
        local imageSize = root.imageSize(fillTexture)
        drawable.image = fillTexture .. string.format("?crop;0;0;%s;%s", imageSize[1], util.clamp(imageSize[2] - math.floor(imageSize[2] * madnessPercent), 0, imageSize[2]))
        drawable.position = {1.125, 1.125}
        d8SharedRendererUtil.updateDrawable(drawable, "d8Madness_IconFill")
    end

end

function D8Madness.clearIcon()
    d8SharedRendererUtil.removeDrawable("d8Madness_Icon")
    d8SharedRendererUtil.removeDrawable("d8Madness_IconFill")
    d8SharedRendererUtil.removeDrawable("d8Madness_IconBackground")
end

effectStrenghtModifier = 1
local prevtoBeRendered = {}
function D8Madness.effect(dt, madnessPercent)
    --sb.logInfo("localAnimator %s", localAnimator)
    --effectStrenghtModifier = math.sin(time * 0.1)
    --sb.setLogMap("D8:Madness effect Strenght Modifier", "%s, %s : %s", effectStrenghtModifier, (1 - effectStrenghtModifier), (4 * (1 - effectStrenghtModifier)))
    local toBeRendered = {}
    for _, _effect in pairs(copy(madnessEffects)) do 
        local add = false
        if _effect.force then
            if type(_effect.require) == "table" then
                _effect.require = vec2.sub(_effect.require, {_effect.force, _effect.force})
                _effect.require[1] = math.max(_effect.require[1], 0)
                _effect.require[2] = math.max(_effect.require[2], 0)
            else
                _effect.require = math.max(_effect.require - _effect.force, 0)
            end
        end
        
        if type(_effect.require) == "table" then
            _effect.require = vec2.add(_effect.require, vec2.mul({(4), (4)}, (1 - effectStrenghtModifier)))
        else
            _effect.require = _effect.require + (4 * (1 - effectStrenghtModifier))
        end
        --sb.logInfo("%s : _effect.require %s", _effect.name or _, _effect.require)
        
        if _effect.type == "overlay" then
            local r = 0
            local requireBypass = false
            if type(_effect.require) == "number" then
                requireBypass = true
                if (_effect.require <= 0) then
                    add = true
                else
                    add = madnessPercent >= _effect.require
                    r = _effect.require
                end
            elseif type(_effect.require) == "table" then
                requireBypass = true
                if (_effect.require[1] <= 0) then
                    add = true
                else
                    add = (madnessPercent >= _effect.require[1]) and (madnessPercent <= _effect.require[2])
                    if (madnessPercent >= _effect.require[1]) then
                        requireBypass = true
                    end
                    --sb.setLogMap("-1 D8Madness_count test", "madnessPercent %s, [%s, %s] %s", madnessPercent, _effect.require[1], _effect.require[2], add)
                    --sb.logInfo("-1 D8Madness_count test madnessPercent %s, [%s, %s] %s", madnessPercent, _effect.require[1], _effect.require[2], add)
                    r = _effect.require[2] + _effect.require[1]
                end
            else
                requireBypass = true
            end
            if requireBypass and ( (type(_effect.zoom) == "table") or (type(_effect.alpha) == "table") ) then
                add = true
            end
            --sb.logInfo("%s", add)
            if add then
                local drawable = {
                    image = _effect.texture,
                    position = {0, 0},
                    scale = _effect.zoom,
                    fullbright = true,
                    centered = true,
                    color = {255, 255, 255, 255},
                    layer = "Overlay"
                }
                if _effect.alpha then
                    if type(_effect.alpha) == "table" then
                        local alpha = util.lerp(util.clamp(madnessPercent / r, 0, 1), _effect.alpha[1], _effect.alpha[2])
                        drawable.color[4] = alpha
                    else
                        drawable.color[4] = _effect.alpha
                    end
                end
                if _effect.alphaSine then
                    if type(_effect.alphaSine) == "number" then
                        local sine = math.sin(time) * _effect.alphaSine
                        drawable.color[4] = (drawable.color[4] - _effect.alphaSine) + sine
                    elseif type(_effect.alphaSine) == "table" then
                        local sine = math.sin(time * _effect.alphaSine.intensity) * _effect.alphaSine.range
                        drawable.color[4] = util.clamp((drawable.color[4] - _effect.alphaSine.range) + sine, 0, 255)
                    end
                end
                if type(_effect.zoom) == "table" then
                    local ratio = 0
                    if not ((madnessPercent == 0) or (r == 0)) then
                        ratio = madnessPercent / r
                    elseif r == 0 then
                        ratio = 1
                    end
                    drawable.scale = util.lerp(util.clamp(madnessPercent / r, 0, 1), _effect.zoom[1], _effect.zoom[2])
                end
                if type(_effect.xSine) == "number" then
                    local sine = math.sin(time) * _effect.xSine
                    drawable.position[1] = drawable.position[1] + sine
                elseif type(_effect.xSine) == "table" then
                    local sine = math.sin(time * _effect.xSine.intensity) * _effect.xSine.range
                    drawable.position[1] = drawable.position[1] + sine
                end
                if type(_effect.ySine) == "number" then
                    local sine = math.sin(time) * _effect.ySine
                    drawable.position[2] = drawable.position[2] + sine
                elseif type(_effect.ySine) == "table" then
                    local sine = math.sin(time * _effect.ySine.intensity) * _effect.ySine.range
                    drawable.position[2] = drawable.position[2] + sine
                end
                table.insert(toBeRendered, {name = _effect.name, drawable = drawable, priority = _effect.priority or 0})
            end
        elseif _effect.type == "sound" then
            --localAnimator.playAudio()
        elseif _effect.type == "music" then
            if type(_effect.require) == "number" then
                if (_effect.require == 0) then
                    add = true
                else
                    add = madnessPercent >= _effect.require
                end
            elseif type(_effect.require) == "table" then
                if (_effect.require[1] == 0) then
                    add = true
                else
                    add = (madnessPercent >= _effect.require[1]) and (madnessPercent <= _effect.require[2])
                end
            end
            if add then
				currentlyPlayingMusic = true
                world.sendEntityMessage(entity.id(), "playAltMusic", _effect.pool or {}, _effect.transitionSpeed or 1)
            elseif currentlyPlayingMusic then -- only clear once in case their is a musicplayer or other script playing alt music
				currentlyPlayingMusic = false
                world.sendEntityMessage(entity.id(), "stopAltMusic", _effect.exitTransitionSpeed or _effect.transitionSpeed or 1)
            end
        elseif _effect.type == "bark" then
            if type(_effect.require) == "number" then
                if (_effect.require == 0) then
                    add = true
                else
                    add = madnessPercent >= _effect.require
                end
            elseif type(_effect.require) == "table" then
                if (_effect.require[1] == 0) then
                    add = true
                else
                    add = (madnessPercent >= _effect.require[1]) and (madnessPercent <= _effect.require[2])
                end
            end
            if add then
                local roll = math.random()
                --sb.setLogMap("D8:Madness Roll", "%s, %s", math.floor(roll * 100), _effect.chance)
                if roll <= (_effect.chance / 100) then
                    local bark = util.randomFromList(_effect.pool)
                    world.sendEntityMessage(entity.id(), "say", "^shadow,darkgray;~-~".. bark .."~-~^reset;")
                end
            end
        end
    end
    for i, cfg in pairs(toBeRendered) do
        if not disableDrawableRender then
            if d8SharedRendererUtil.hasDrawable(cfg.name) then
                d8SharedRendererUtil.updateDrawable(cfg.drawable, cfg.name)
            else
                d8SharedRendererUtil.addDrawable(cfg.drawable, cfg.priority, cfg.name)
            end
        end
    end
    for i, cfg in pairs(prevtoBeRendered) do
        local remove = true
        for _i, _cfg in pairs(toBeRendered) do
            if _cfg.name == cfg.name then remove = false break end
        end
        if remove then
            if d8SharedRendererUtil.hasDrawable(cfg.name) then
                d8SharedRendererUtil.removeDrawable(cfg.name)
            end
        end
    end
    for _, a in pairs(D8Madness.compact.effect) do 
        a.callback(dt, madnessPercent * effectStrenghtModifier, toBeRendered)
    end
    prevtoBeRendered = toBeRendered
end

local lightTimer = 0
local lightModiff = 0
local species
D8Madness.modifierStep = {
    dungeonAndArea = function(dt, speciesCfg, species, pos)
        local speciesModiff = function(paramName)
            if (speciesCfg[species] or {})[paramName] then
                return (speciesCfg[species] or {})[paramName]
            end
            return speciesCfg.default[paramName]
        end

        local dungId = world.dungeonId(pos)
        if dungId == 65535 then -- lose slowly when in the wilderness
            local primaryBiome = world.type()
            local biomeCfg = tempStorage[primaryBiome] or root.createBiome(primaryBiome, 0, 1, 1) or {}
            D8Madness_modiff = D8Madness_modiff + (biomeCfg.madnessModifier or 0.25)
            --sb.setLogMap("D8:Madness Area Modiff", "%s", (biomeCfg.madnessModifier or 0.25))
            if not tempStorage[primaryBiome] then tempStorage[primaryBiome] = biomeCfg end
        elseif dungId == 65531 then -- lose slowly when mining underground
            local primaryBiome = world.type()
            local biomeCfg = tempStorage[primaryBiome] or root.createBiome(primaryBiome, 0, 1, 1) or {}
            local modiff = 0
            modiff = modiff + (biomeCfg.madnessModifier or 0.25)
            local depth = mcontroller.yPosition()
            --sb.setLogMap("D8:Madness Area Modiff Depth", "%s", depth)
            if world.underground(pos) then
                local _a = (1000 - depth)
                local pow = 1.5
                if _a ~= 0 then
                    modiff = modiff + (pow * (_a / 1000))
                else
                    modiff = modiff + pow
                end
            end
            D8Madness_modiff = D8Madness_modiff + modiff
            --sb.setLogMap("D8:Madness Area Modiff", "%s", modiff)
            if not tempStorage[primaryBiome] then tempStorage[primaryBiome] = biomeCfg end
        elseif dungId == 65532 then -- heal very slowly when in a player build
            D8Madness_modiff = D8Madness_modiff + -0.5
            --sb.setLogMap("D8:Madness Area Modiff", "%s", -0.5)
        else -- instanceWorld ?
            local instWorldCfg = tempStorage["instWorldCfg"] or root.assetJson("/instance_worlds.config")
            local worldName = world.type()
            if instWorldCfg[worldName] then
                D8Madness_modiff = D8Madness_modiff + (instWorldCfg[worldName].D8Madness_modiff or 0)
                --sb.setLogMap("D8:Madness Area Modiff", "%s", instWorldCfg[worldName].D8Madness_modiff or 0)
            else
                D8Madness_modiff = D8Madness_modiff + 0.05
                --sb.setLogMap("D8:Madness Area Modiff", "%s", 0.05)
            end
            if not tempStorage["instWorldCfg"] then tempStorage["instWorldCfg"] = instWorldCfg end
        end
    end,
    liquid = function(dt, speciesCfg, species, pos)
        local speciesModiff = function(paramName)
            if (speciesCfg[species] or {})[paramName] then
                return (speciesCfg[species] or {})[paramName]
            end
            return speciesCfg.default[paramName]
        end

        local LiqID = (world.liquidAt(pos) or {})[1]
        if LiqID then
            local LiqCfg = tempStorage["Liq"..tostring(LiqID)] or root.liquidConfig(LiqID).config
            local modiff = (LiqCfg.madnessModifier or 0.1) * speciesModiff("liquidModiff")
            D8Madness_modiff = D8Madness_modiff + modiff
            --sb.logInfo("LiqCfg %s", sb.printJson(LiqCfg, 1))
            --sb.setLogMap("D8:Madness Liquid Modiff", "%s, %s", modiff, sb.printJson(LiqCfg, 0))
            if not tempStorage["Liq"..tostring(LiqID)] then tempStorage["Liq"..tostring(LiqID)] = LiqCfg end
        else
            --sb.setLogMap("D8:Madness Liquid Modiff", "0, Not in liquid")
        end
    end,
    object = function(dt, speciesCfg, species, pos)
        local speciesModiff = function(paramName)
            if (speciesCfg[species] or {})[paramName] then
                return (speciesCfg[species] or {})[paramName]
            end
            return speciesCfg.default[paramName]
        end
        
        local obj = world.objectQuery(pos, 30, {
            order = "nearest"
        })
        local objModiff = 0
        --sb.logInfo("D8:Madness Object Modiff | Starting Objects Scan")
        for _, id in pairs(obj) do 
            local _pos = world.entityPosition(id)
            local _mod = world.getObjectParameter(id, "madnessModifier")
            local _range = world.getObjectParameter(id, "madnessModifierRange") or 4
            local notObstructed = (not world.lineTileCollision(pos, _pos, {"Dynamic", "Block", "Slippery"}))
            local inRange = (_range >= world.magnitude(pos, _pos))
            --sb.logInfo("D8:Madness Object Modiff | modiff %s, range %s, notObstructed %s, inRange %s", _mod, _range, notObstructed, inRange)
            if _mod and notObstructed and inRange then
                objModiff = objModiff + _mod
            end
        end
        sb.setLogMap("D8:Madness Object Modiff", "%s", objModiff)
        D8Madness_modiff = D8Madness_modiff + objModiff
    end,
    light = function(dt, speciesCfg, species, pos)
        local speciesModiff = function(paramName)
            if (speciesCfg[species] or {})[paramName] then
                return (speciesCfg[species] or {})[paramName]
            end
            return speciesCfg.default[paramName]
        end

        if lightTimer > 0 then 
            lightTimer = lightTimer - dt
            D8Madness_modiff = D8Madness_modiff + (lightModiff[1] or 0)
        else
            lightTimer = 0.1
            local lightLevel = world.lightLevel(pos)
            local shadeAndLum = lightLevel
            -- speciesCfg.liquidModiff
            -- "lightModiff" : 1,
            -- "shadowModiff" : -1
            local modiff = 0
            if shadeAndLum >= 0.25 then
                modiff = modiff + (1.5 * (shadeAndLum * speciesModiff("lightModiff")))
            else
                modiff = modiff + (2.5 * ((1 - shadeAndLum) * speciesModiff("shadowModiff")))
            end
            lightModiff = {modiff, shadeAndLum, lightLevel}
            D8Madness_modiff = D8Madness_modiff + modiff
        end
		--sb.setLogMap("D8:Madness Light Modiff", "%s, %s, %s", table.unpack(lightModiff))
    end
}
function D8Madness.modifier(dt)
    local speciesCfg = scriptConfig.species --root.assetJson("/stats/d8Madness/species.config") -- moved to madnessScript.config for consistency
    if not species then species = world.entitySpecies(entity.id()) end
    D8Madness_modiff = copy(speciesCfg.defaultModiff or 0)
    local pos = mcontroller.position()
    for funcName, funcCall in pairs(D8Madness.modifierStep) do 
        funcCall(dt, speciesCfg, species, pos)
    end
end


local _init = init
function init()
    if _init then _init() end
    D8Madness.init()
end
local _update = update
function update(dt)
    if _update then _update(dt) end
    D8Madness.update(dt)
end
local _uninit = uninit
function uninit()
    if _uninit then _uninit() end
    D8Madness.uninit()
end