-- Fission Reactor

local du = require "displayutils"

local modems = { peripheral.find("modem", function(name, modem)
    return true
end) }

-- Must be connected to a fission reactor logic adaptor block.
local reactor = peripheral.find("fissionReactorLogicAdapter")

local function getInfo()
    -- Other available APIs:
    --  - isFormed
    --  - getMinPos
    --  - getMaxPos
    --  - getHeight
    --  - getLength
    --  - getWidth
    --  - getCoolant
    --  - getCoolantNeeded
    --  - getCoolantCapacity
    --  - getCoolantFilledPercentage
    --  - getFuel
    --  - getFuelNeeded
    --  - getFuelCapacity
    --  - getFuelFilledPercentage
    --  - getFuelSurfaceArea
    --  - getHeatedCoolant
    --  - getHeatedCoolantNeeded
    --  - getHeatedCoolantCapacity
    --  - getHeatedCoolantFilledPercentage
    --  - getWaste
    --  - getWasteNeeded
    --  - getWasteCapacity
    --  - getWasteFilledPercentage
    --  - getStatus
    --  - getDamagePercent
    --  - getEnvironmentalLoss
    --  - getBurnRate
    --  - getActualBurnRate
    --  - setBurnRate
    --  - getMaxBurnRate
    --  - getHeatingRate
    --  - getBoilEfficieny
    --  - scram
    --  - activate
    --  - getFuelAssemblies
    --  - getHeatCapacity
    --  - getTemperature
    --  - getRedstoneLogicStatus
    --  - getRedstoneMode
    --  - setRedstoneMode
    --  - getLogicMode
    --  - setLogicMode
end

-- Run a fission reactor safely.
-- Possible modes:
--   AUTO    (run when safe)
--   MANUAL  (turn off when unsafe)
--   OFF     (keep off)
local AUTO = "AUTO"
local MANUAL = "MANUAL"
local OFF = "OFF"
local MODE = OFF

local function setMode(mode)
    MODE = mode
end

-- Alarm Reasons
--  DAMAGE
--  TEMP
--  WASTE
local DAMAGE = "DAMAGE"
local TEMP = "TEMP"
local WASTE = "WASTE"
local alarms = {
    DAMAGE = 0,
    TEMP = 0,
    WASTE = 0,
}

local function setAlarm(reason)
    if alarms[reason] ~= 2 then
        alarms[reason] = 1
    end
end

local function unsetAlarm(reason)
    alarms[reason] = 0
end

local function anyActiveAlarms()
    local anyAlarms = false
    for _, a in pairs(alarms) do
        if a == 1 then
            anyAlarms = true
        end
    end
    return anyAlarms
end

local function anySilencedAlarms()
    local anyAlarms = false
    for _, a in pairs(alarms) do
        if a == 2 then
            anyAlarms = true
        end
    end
    return anyAlarms
end

local function anyAlarms()
    -- Check if there are any active or silenced alarms.
    local anyAlarms = false
    for _, a in pairs(alarms) do
        if a ~= 0 then
            anyAlarms = true
        end
    end
    return anyAlarms
end

local function silenceAlarms()
    for t, v in pairs(alarms) do
        if v == 1 then
            alarms[t] = 2
        end
    end
end

local function checkSafety()
    -- Run all safety checks on the reactor.
    -- Sets alarms if any problems found.

    -- Never run when damaged.
    if reactor.getDamagePercent() > 0 then
        setAlarm(DAMAGE)
    else
        unsetAlarm(DAMAGE)
    end

    -- 1000K seems to be about the damage limit.
    if reactor.getTemperature() > 0 then
        setAlarm(TEMP)
    else
        unsetAlarm(TEMP)
    end

    -- Waste at 90% full is pushing it.
    if reactor.getWasteFilledPercentage() > 0.9 then
        setAlarm(WASTE)
    else
        unsetAlarm(WASTE)
    end
end

-- Assume the resolution is 51x19 - that of a computer.
-- --------------------------------------------------
--  -----------------------------      -------------
--  |  OFF  |  MANUAL  |  AUTO  |      |   ALARM   |
--  -----------------------------      -------------

local function displayModeSelect()
    local offText, offBg = colors.lightGray, colors.gray
    local manualText, manualBg = colors.lightGray, colors.gray
    local autoText, autoBg = colors.lightGray, colors.gray

    if MODE == OFF then
        offText, offBg = colors.white, colors.red
    elseif MODE == MANUAL then
        manualText, manualBg = colors.white, colors.cyan
    elseif MODE == AUTO then
        autoText, autoBg = colors.white, colors.green
    end

    term.setCursorPos(2, 4)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    term.write("Mode Select")
    du.drawTextBox(2, 5, 11, 7, offBg, "OFF", offText)
    du.drawTextBox(12, 5, 21, 7, manualBg, "MANUAL", manualText)
    du.drawTextBox(22, 5, 31, 7, autoBg, "AUTO", autoText)
end

local function displayStatus()
    term.setCursorPos(38, 4)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    term.write("Status")

    if reactor.getStatus() then
        du.drawTextBox(38, 5, 50, 7, colors.green, "RUNNING", colors.white)
    else
        du.drawTextBox(38, 5, 50, 7, colors.red, "SCRAMMED", colors.white)
    end
end

local function displayInfo()
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)

    term.setCursorPos(2, 13)
    term.write("Info:")

    term.setCursorPos(2, 14)
    term.write(string.format("Coolant : %dmB (%.0f%%)", reactor.getCoolant().amount, reactor.getCoolantFilledPercentage()))
    term.setCursorPos(2, 15)
    term.write(string.format("Fuel    : %dmB (%.0f%%)", reactor.getFuel().amount, reactor.getFuelFilledPercentage()))
    term.setCursorPos(2, 16)
    term.write(string.format("Heated C: %dmB (%.0f%%)", reactor.getHeatedCoolant().amount, reactor.getHeatedCoolantFilledPercentage()))
    term.setCursorPos(2, 17)
    term.write(string.format("Waste   : %dmB (%.0f%%)", reactor.getWaste().amount, reactor.getWasteFilledPercentage()))
    term.setCursorPos(2, 18)
    term.write(string.format("Requested Burn Rate: %dmB/t", reactor.getBurnRate()))
    term.setCursorPos(2, 19)
    term.write(string.format("Actual Burn Rate   : %dmB/t", reactor.getActualBurnRate()))
end

local function displayAlarms()
    local fg, bg, text
    if anyActiveAlarms() then
        fg, bg, text = colors.orange, colors.red, "ALARM"
    elseif anySilencedAlarms() then
        fg, bg, text = colors.orange, colors.brown, "SILENCED"
    else
        fg, bg, text = colors.lightGray, colors.gray, "NO ALARMS"
    end

    du.drawTextBox(38, 10, 50, 12, bg, text, fg)

    -- Blank out all the listed alarms.
    paintutils.drawFilledBox(39, 14, 51, 16, colors.black)
    local currY = 14
    term.setBackgroundColor(colors.black)
    for t, a in pairs(alarms) do
        if a == 1 then
            term.setCursorPos(39, currY)
            term.setTextColor(colors.orange)
            term.write(t)
            currY = currY + 1

        elseif a == 2 then
            term.setCursorPos(39, currY)
            term.setTextColor(colors.brown)
            term.write(t)
            currY = currY + 1
        end
    end
end

local function handleModeSelect(x, y)
    if x >= 2 and x <= 11 then
        setMode(OFF)
    elseif x >= 12 and x <= 21 then
        setMode(MANUAL)
    elseif x >= 22 and x <= 31 then
        setMode(AUTO)
    end
end

local function handleAlarmSilence()
    silenceAlarms()
end

local function handleClick(name, button, x, y)
    if x >= 2 and x <= 31 and y >= 5 and y <= 7 then
        -- Mode select.
        handleModeSelect(x, y)
    elseif x >= 38 and x <= 50 and y >= 10 and y <= 12 then
        -- Silence alarms.
        handleAlarmSilence()
    end
end


local function maybeStartStopReactor()
    if MODE == AUTO and not anyAlarms() then
        reactor.activate()
    elseif MODE == OFF then
        reactor.scram()
    end
end

local function initDisplay()
    -- Initialize the display.
    term.clear()
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    local title = "Fission Reactor Control"
    local w, h = term.getSize()
    if w < 51 or h < 19 then
        print("Monitor is too small (minimum resolution 51x19)")
        return
    end

    local titleX = math.floor((w - string.len(title)) / 2)
    term.setCursorPos(titleX, 1)
    term.write(title)
    term.setCursorPos(titleX, 2)
    term.write(string.rep("-", string.len(title)))
end

local function updateDisplay()
    -- Update all sub-parts of the display.
    displayModeSelect()
    displayStatus()
    displayInfo()
    displayAlarms()
end


local function runControlInternal()
    initDisplay()
    updateDisplay()

    local criticalTimer = os.startTimer(0.05)
    local normalTimer = os.startTimer(1)

    local doDisplayUpdate = true
    -- Event loop.
    while true do
        local eventData = {os.pullEvent()}
        local event = eventData[1]
        doDisplayUpdate = true

        if event == "timer" then
            -- Just set the time again.
            -- This ensure we get an update for safety at least once a
            -- second, so it's not going to work for really explosive
            -- scenarios.
            if eventData[2] == criticalTimer then
                -- Run the safety checks.
                checkSafety()

                -- If there are any alarms, display them.
                -- Otherwise, just handle them on the display update.
                if anyActiveAlarms() then
                    displayAlarms()
                end

                -- If there are any active or silenced alarms scram the
                -- reactor.
                if anyActiveAlarms() or anySilencedAlarms() then
                    reactor.scram()
                end

                -- Don't do the full display update.
                doDisplayUpdate = false
            elseif eventData[2] == normalTimer then
                -- Do all the normal updates.
                -- Check if the reactor should be running.
                maybeStartStopReactor()
            else
                print("unknown timer fired!")
            end
        elseif event == "mouse_click" then
            handleClick(eventData[1], eventData[2], eventData[3], eventData[4])

        elseif event == "monitor_touch" then
            -- Always a right click.
            handleClick(eventData[1], 2, eventData[3], eventData[4])

        elseif event == "key" then
            -- Debugging only
            if eventData[2] == keys["w"] then
                setAlarm(WASTE)
            elseif eventData[2] == keys["t"] then
                setAlarm(TEMP)
            elseif eventData[2] == keys["d"] then
                setAlarm(DAMAGE)
            elseif eventData[2] == keys["c"] then
                unsetAlarm(WASTE)
                unsetAlarm(TEMP)
                unsetAlarm(DAMAGE)
            end
        elseif event == "peripheral_detach" then
            -- Check if the reactor is still present.
            -- If not, exit.
            reactor = peripheral.find("fissionReactorLogicAdapter")
            if reactor == nil then
                term.setBackgroundColor(colors.black)
                term.setTextColor(colors.white)
                term.setCursorPos(1, 1)
                print("Reactor detached - exiting")
                return
            end

        end

        if doDisplayUpdate then
            updateDisplay()

        end

        -- Restart the critical timer and update timers.
        -- These can be thrown away by other APIs.
        -- *cough* *cough* OpenPeripheral *cough* *cough*
        criticalTimer = os.startTimer(0.05)
        normalTimer = os.startTimer(1)
    end
end

local function runControl()
    reactor = peripheral.find("fissionReactorLogicAdapter")

    if reactor == nil then
        print("No connected fission reactor.")
        print()
        print("Connect (either directly or via wired modem) to a fission \z
               reactor logic adapter and restart the program.")
        return
    end

    runControlInternal()
end

runControl()