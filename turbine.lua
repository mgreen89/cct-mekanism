-- Industrial Turbine

energy = require "energy"

local modems = { peripheral.find("modem", function(name, modem)
    return true
end) }

-- Must be connected to a turbine value block.
local turbine = peripheral.find("turbineValve")

local function getInfo()
    -- Other available APIs:
    --  - isFormed
    --  - getMinPos
    --  - getMaxPos
    --  - getHeight
    --  - getLength
    --  - getWidth
    --  - getBlades
    --  - getCoils
    --  - getCondensers
    --  - getDispersers
    --  - getVents
    --  - getEnergy
    --  - getEnergyNeeded
    --  - getMaxEnergy
    --  - getFlowRate
    --  - getMaxFlowRate
    --  - getDumpingMode
    --  - setDumpingMode
    --  - incrementDumpingMode
    --  - decrementDumpingMode
    --  - getSteam
    --  - getSteamNeeded
    --  - getSteamCapacity
    --  - getSteamFilledPercentage
    --  - getLastSteamInputRate
    --  - getMaxWaterOutput
    --  - getComparatorLevel
    --  - getMaxProduction
    --  - getProductionRate
end