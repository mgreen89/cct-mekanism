-- Induction energy server.

local package = (...):match("(.-)[^%. ]+$")
local parentPackage = package:match("(.-)[^%.]+%.$")
local s = require(parentPackage .. "server")

local PROTOCOL_NAME = "induction"
local SERVER_HOSTNAME = "matrix"

local function getInfo(matrix)
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
    s.runServer(PROTOCOL_NAME, "matrix", "inductionPort", {getInfo = getInfo})
end

return {
    runServer = runServer,
    PROTOCOL_NAME = PROTOCOL_NAME,
    SERVER_HOSTNAME = SERVER_HOSTNAME,
}