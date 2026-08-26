require "/scripts/rect.lua"
local interfaceCanvas
local effect_render
local teamBar
local TeamBarCallback
local screenSize
function osb_icon(dt, madnessPercent)
    if interface then
        -- insert oSb support
        D8Madness.setParameter("renderDefaultIcon", false)
        if not teamBar then 
            TeamBarCallback = interface.bindRegisteredPane("TeamBar")
            teamBar = {
                pos = {0, interfaceCanvas:size()[2]},
                size = root.imageSize("/interface/party/playerbar.png")
            }
            teamBar.size[2] = 0
        end
        interfaceCanvas:clear()
        if D8Madness.getParameter("hideIcon") then return end
        local backTexture = "/objects/floran/huntingtrophy1/huntingtrophy1.png"
        local iconTexture = "/items/generic/crafting/inferiorbrain.png"
        local fillTexture = "/items/generic/crafting/brain.png"
        
        local imageSize = root.imageSize(fillTexture)
        teamBar.pos = {0, interfaceCanvas:size()[2]}
        teamBar.pos[2] = (teamBar.pos[2] - imageSize[2]) - 3
        fillTexture = fillTexture .. string.format("?crop;0;0;%s;%s", imageSize[1], util.clamp(imageSize[2] - math.floor(imageSize[2] * madnessPercent), 0, imageSize[2]))
        local offset = {2, 0}
        interfaceCanvas:drawImage(backTexture, vec2.add(offset, vec2.add(vec2.mul(({0, 0}), 8), vec2.add(teamBar.size, teamBar.pos))), 1, {255, 255, 255}, false)
        interfaceCanvas:drawImage(iconTexture, vec2.add(offset, vec2.add(vec2.mul(({0.125, 0.125}), 8), vec2.add(teamBar.size, teamBar.pos))), 1, {255, 255, 255}, false)
        interfaceCanvas:drawImage(fillTexture, vec2.add(offset, vec2.add(vec2.mul(({0.125, 0.125}), 8), vec2.add(teamBar.size, teamBar.pos))), 1, {255, 255, 255}, false)
        local _rect = rect.zero()
        _rect[3] = imageSize[1]
        _rect[4] = imageSize[2]
        _rect = rect.translate(_rect, vec2.add(offset, vec2.add(vec2.mul(({0, 0}), 8), vec2.add(teamBar.size, teamBar.pos))))
        
        if rect.contains(_rect ,interfaceCanvas:mousePosition()) then
            local state = "Sane\n"
            if madnessPercent >= 0.95 then
                state = "Lunatic\n"
            elseif madnessPercent >= 0.75 then
                state = "Insane\n"
            elseif madnessPercent >= 0.5 then
                state = "Mad\n"
            elseif madnessPercent >= 0.3 then
                state = "Inhinged\n"
            end
			local color = {255 - (150 * madnessPercent), 255 - (255 * madnessPercent), 255 - (255 * madnessPercent)}
			if D8Madness_modiff < 0 then color = {255 - (255 * madnessPercent), 255 - (150 * madnessPercent), 255 - (255 * madnessPercent)} end
            interfaceCanvas:drawText("^shadow;".. state .. tostring(util.round((1 - madnessPercent) * 100).."^reset;"), {
                position = vec2.add(offset, vec2.add(vec2.mul(({1.25, 0}), 8), vec2.add(teamBar.size, teamBar.pos))),
                horizontalAnchor = "mid", -- left, mid, right
                verticalAnchor = "top", -- top, mid, bottom
                wrapWidth = nil -- wrap width, pixels or nil
            }, 7, color)
        end
    end
end
--exist primarily so that having the scanner equiped doesn't cause massive fps loss, sadly(or not) it ins't affected by shaders
function osb_rendering_conversion(dt, madnessPercent, toBeRendered)
    if interface.bindCanvas then
        effect_render:clear()
        table.sort(toBeRendered or {}, function(a, b)
            return a.priority < b.priority
        end)
        local zoom = camera.pixelRatio()
        for i, cfg in pairs(toBeRendered or {}) do
            local pos = vec2.add(cfg.drawable.position or {0, 0}, entity.position())
            effect_render:drawImageDrawable(cfg.drawable.image or "/assetmissing.png", camera.worldToScreen(pos), (cfg.drawable.scale or 1) * zoom, cfg.drawable.color or {255, 255, 255, 255}, cfg.drawable.rotation or 0)
        end
    end
end

function osb_shader(dt, madnessPercent)
    if renderer then 
        local shader = renderer.getEffectParameter("madnessSaturation", "satMult")
        renderer.setEffectParameter("madnessSaturation", "satMult", madnessPercent)
    end
end

function osb_uninit()
    if interfaceCanvas then interfaceCanvas:clear() end
end

function load()
    if not (interface and renderer) then return end
    if not effect_render then effect_render = interface.bindCanvas("-10000, D8Madness_effect_render", true) end
    if not interfaceCanvas then interfaceCanvas = interface.bindCanvas("0, D8Madness_Icon") end
    D8Madness.addCompact("update", osb_icon, -999999)
    D8Madness.addCompact("effect", osb_rendering_conversion)
    D8Madness.addCompact("effect", osb_shader)
    D8Madness.addCompact("uninit", osb_uninit)
    disableDrawableRender = true
end