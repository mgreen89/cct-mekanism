
local function drawTextBox(minX, minY, maxX, maxY, bgColor, text, textColor)
    paintutils.drawFilledBox(minX, minY, maxX, maxY, bgColor)
    term.setCursorPos(
        math.floor((maxX - minX + 1 - string.len(text)) / 2) + minX,
        math.floor((maxY - minY) / 2) + minY
    )
    term.setTextColor(textColor)
    term.write(text)
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
}