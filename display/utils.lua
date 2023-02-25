-- Display utilities.

local function drawTextBox(minX, minY, maxX, maxY, bgColor, text, textColor)
    paintutils.drawFilledBox(minX, minY, maxX, maxY, bgColor)
    if text then
        term.setCursorPos(
            math.floor((maxX - minX + 1 - string.len(text)) / 2) + minX,
            math.floor((maxY - minY) / 2) + minY
        )
        term.setTextColor(textColor)
        term.write(text)
    end
end

function justify(t)
    -- Justify text within the given area.
    local text = assert(t.text or t[1])
    local align = t.align or t[2] or "left"
    local y = t.y or t[3]
    local display = t.display or t[4]
    local textColor = t.textColor or t[5]
    local bgColor = t.bgColor or t[6]

    local d = display
    if display == nil then
        d = term.current()
    end
    local _, cY = d.getCursorPos()
    local line = y or cY
    local dX, _ = d.getSize()
    local length = string.len(text)

    if textColor then
        d.setTextColor(textColor)
    end
    if bgColor then
        d.setBackgroundColor(bgColor)
    end

    if align == "left" then
        d.setCursorPos(1, line)
    elseif align == "center" or align == "centre" then
        d.setCursorPos(math.floor((dX - length) / 2), line)
    elseif align == "right" then
        d.setCursorPos(dX - length, line)
    end
    d.write(text)
end

local function humanSeconds(secs)
    secs = math.floor(secs)

    local days = math.floor(secs / 86400)
    secs = secs - (86400 * days)

    local hours = math.floor(secs / 3600)
    secs = secs - (3600 * hours)

    local mins = math.floor(secs / 60)
    secs = secs - (60 * mins)

    local prefix = ""
    if days > 0 then
        prefix = string.format("%d days ", days)
    end

    return string.format("%s%02d:%02d:%02d", prefix, hours, mins, secs)
  end

local function humanTicks(ticks)
    return humanSeconds(ticks / 20)
end

local function siPrefix(num)
    local val = num
    local negate = false

    if val < 0 then
        val = -val
        negate = true
    end

    if val > 1000 then
        prefix = "k"
        val = val / 1000
    end

    if val > 1000 then
        prefix = "M"
        val = val / 1000
    end

    if val > 1000 then
        prefix = "G"
        val = val / 1000
    end

    if val > 1000 then
        prefix = "T"
        val = val / 1000
    end

    if val > 1000 then
        prefix = "P"
        val = val / 1000
    end

    if val > 1000 then
        prefix = "E"
        val = val / 1000
    end

    if val > 1000 then
        prefix = "Z"
        val = val / 1000
    end

    if negate then
        val = - val
    end

    return prefix, val
end

return {
    humanTicks = humanTicks,
    humanSeconds = humanSeconds,
    siPrefix = siPrefix,
    drawTextBox = drawTextBox,
    justify = justify,
}