-- wxh 4x3 ->  78x38

local energy = require "energy"
local du = require "displayutils"

local function displayEnergyBar(eInfo)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(3, 4)
    term.write("Energy Storage")

    paintutils.drawBox(3, 6, 76, 10, colors.white)
    paintutils.drawFilledBox(4, 7, 75, 9, colors.black)

    local color
    local energyPc = eInfo.fillPercent
    if energyPc > 0.8 then
        color = colors.green
    elseif energyPc > 0.4 then
        color = colors.yellow
    elseif energyPc > 0.1 then
        color = colors.orange
    else
        color = colors.red
    end

    local barSize = energyPc * 71
    paintutils.drawFilledBox(4, 7, 4 + barSize, 9, color)

    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    term.setCursorPos(3, 12)
    prefix, val = du.siPrefix(eInfo.energy)
    term.write(string.format("Stored: %0.3f %sJ (%0.2f%%)", val, prefix, eInfo.fillPercent * 100))

    prefix, val = du.siPrefix(eInfo.maxEnergy)
    local capacityString = string.format("Capacity: %0.3f %sJ", val, prefix)
    term.setCursorPos(78 - 1 - string.len(capacityString), 12)
    term.write(capacityString)
end

local function displayTransfer(eInfo)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(3, 15)
    term.write("Energy Transfer")

    local transferPrefix, transferVal = du.siPrefix(eInfo.transferCap)
    local transferCapString = string.format("Max Transfer Rate: %0.3f %sJ/t", transferVal, transferPrefix)
    term.setCursorPos(78 - 1 - string.len(transferCapString), 15)
    term.write(transferCapString)

    paintutils.drawBox(3, 17, 39, 21, colors.white)
    paintutils.drawBox(40, 17, 76, 21, colors.white)
    local outputPc = eInfo.outputRate / eInfo.transferCap
    local inputPc = eInfo.inputRate / eInfo.transferCap
    paintutils.drawFilledBox(38, 18, math.ceil(38 - (outputPc * 34)), 20, colors.red)
    paintutils.drawFilledBox(41, 18, math.floor(41 + (inputPc * 34)), 20, colors.green)

    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    local outputPrefix, outputVal = du.siPrefix(eInfo.outputRate)
    local outputString = string.format("Output: %0.3f %sJ/t", outputVal, outputPrefix)
    term.setCursorPos(3, 23)
    term.write(outputString)
    local inputPrefix, inputVal = du.siPrefix(eInfo.inputRate)
    local inputString = string.format("Input: %0.3f %sJ/t", inputVal, inputPrefix)
    term.setCursorPos(78 - 1 - string.len(inputString), 23)
    term.write(inputString)
end

local function display(eInfo)
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(24, 1)
    term.write("-------------------------------")
    term.setCursorPos(24, 2)
    term.write("Induction Matrix Energy Monitor")
    term.setCursorPos(24, 3)
    term.write("-------------------------------")

    displayEnergyBar(eInfo)
    displayTransfer(eInfo)

    local status
    if eInfo.inputRate > eInfo.outputRate then
        status = "Charging"
    elseif eInfo.inputRate < eInfo.outputRate then
        status = "Discharging"
    else
        status = "Balanced"
    end

    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(3, 25)
    term.write(string.format("Status: %s", status))
    if status == "Charging" then
        term.write(
            string.format(
                " (%s until full)",
                du.humanTicks((eInfo.maxEnergy - eInfo.energy) / (eInfo.inputRate - eInfo.outputRate))
            )
        )
    elseif status == "Discharging" then
        term.write(
            string.format(
                " (%s remaining)",
                du.humanTicks(eInfo.energy / (eInfo.outputRate - eInfo.inputRate))
            )
        )
    end
end

function go()
    term.setCursorBlink(false)

    local pc
    while true do
        eInfo = energy.getInfo()
        if eInfo ~= nil then
            display(eInfo)
        else
            term.setBackgroundColor(colors.black)
            term.clear()
            term.setCursorPos(1, 1)
            printError("No response from energy server - is it running?")
        end
        os.sleep(10)
    end
end

local modems = { peripheral.find("modem", function(name, modem)
    return true -- modem.isWireless()
end) }

for _, m in pairs(modems) do
    rednet.open(peripheral.getName(m))
end

go()