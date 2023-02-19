-- Fission Reactor

local modems = { peripheral.find("modem", function(name, modem)
    return true
end) }

-- Must be connected to an SPS port block.
local reactor = peripheral.find("spsPort")

local function getInfo()
    -- Other available APIs:
    --  - isFormed
    --  - getMinPos
    --  - getMaxPos
    --  - getHeight
    --  - getLength
    --  - getWidth

    --  - getInput
    --  - getInputNeeded
    --  - getInputCapacity
    --  - getInputFilledPercentage
    --  - getEnergy
    --  - getMaxEnergy
    --  - getEnergyNeeded
    --  - getEnergyFilledPercentage
    --  - getOutput
    --  - getOutputNeeded
    --  - getOutputCapacity
    --  - getOutputFilledPercentage
    --  - getCoils
    --  - getProcessesRate
    --  - getMode
    --  - setMode
    --  - getComparatorLevel
end