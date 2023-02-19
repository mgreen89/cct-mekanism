-- Induction energy server.

energy = require "energy"

local modems = { peripheral.find("modem", function(name, modem)
    return true --modem.isWireless()
end) }

local matrix = peripheral.find("inductionPort")

local function getInfo()
    -- Other available APIs:
    --  - isFormed
    --  - getMinPos
    --  - getMaxPos
    --  - getHeight
    --  - getLength
    --  - getWidth
    --  - getInstalledProviders
    --  - getInstalledCells
    --  - getInputItem
    --  - getOutputItem
    --  - getComparatorLevel
    --  - getEnergyNeeded
    --  - getMode
    --  - setMode
    return {
        energy = matrix.getEnergy(),
        maxEnergy = matrix.getMaxEnergy(),
        fillPercent = matrix.getEnergyFilledPercentage(),
        inputRate = matrix.getLastInput(),
        outputRate = matrix.getLastOutput(),
        transferCap = matrix.getTransferCap(),
    }
end

local function runServer()
    local id, msg
    rednet.host(energy.PROTOCOL_NAME, "server")
    while true do
        id, msg = rednet.receive(energy.PROTOCOL_NAME)
        if msg == "getInfo" then
            rednet.send(id, getInfo(), energy.PROTOCOL_NAME)
        else
            print("Received unknown message:", msg)
        end
    end
end

for i, m in pairs(modems) do
    rednet.open(peripheral.getName(m))
end
runServer()
