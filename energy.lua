local PROTOCOL_NAME = "energy"

local function getInfo()
    local svr = rednet.lookup(PROTOCOL_NAME, "server")
    sent = rednet.send(svr, "getInfo", PROTOCOL_NAME)
    if not sent then
        printError("Message not sent - rednet not opened")
        return {}
    end
    id, msg = rednet.receive(PROTOCOL_NAME, 2)
    return msg
end

-- Test override
--local function getInfo()
--    return {
--        energy = 128032000,
--        maxEnergy = 1380000,
--        fillPercent = 0.3,
--        inputRate = 131999,
--        outputRate = 132000,
--        transferCap = 512000,
--    }
--end

return {
    PROTOCOL_NAME = PROTOCOL_NAME,
    getInfo = getInfo,
}
