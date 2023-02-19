-- Fission Reactor

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