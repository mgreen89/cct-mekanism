-- Fusion Reactor

local modems = { peripheral.find("modem", function(name, modem)
    return true
end) }

-- Must be connected to a fusion reactor logic adaptor block.
local reactor = peripheral.find("fusionReactorLogicAdapter")

local function getInfo()
    -- Other available APIs:
    --  - isFormed
    --  - getMinPos
    --  - getMaxPos
    --  - getHeight
    --  - getLength
    --  - getWidth
    --  - getDTFuel
    --  - getDTFuelNeeded
    --  - getDTFuelCapacity
    --  - getDTFuelFilledPercentage
    --  - getDeuterium
    --  - getDeuteriumNeeded
    --  - getDeuteriumCapacity
    --  - getDeuteriumFilledPercentage
    --  - getTritium
    --  - getTritiumNeeded
    --  - getTritiumCapacity
    --  - getTritiumFilledPercentage
    --  - getWater
    --  - getWaterNeeded
    --  - getWaterCapacity
    --  - getWaterFilledPercentage
    --  - getSteam
    --  - getSteamNeeded
    --  - getSteamCapacity
    --  - getSteamFilledPercentage
    --  - getHohlraum
    --  - getInjectionRate
    --  - setInjectionRate
    --  - getPassiveGeneration
    --  - getTransferLoss
    --  - getProductionRate
    --  - getPlasmaTemperature
    --  - getCaseTemperature
    --  - getEnvironmentalLoss
    --  - getIgnitionTemperature
    --  - getMinInjectionRate
    --  - getMaxPlasmaTemperature
    --  - getMaxCasingTemperature
    --  - getLogicMode
    --  - setLogicMode
    --  - isActiveCooledLogic
    --  - setActiveCooledLogic
end