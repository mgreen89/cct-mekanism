-- API for an information source serving information over rednet.

local P = nil

local function handleRednet(protocol_name, hostname, apis)
    rednet.host(protocol_name, hostname)

    while true do
        local id, msg = rednet.receive(protocol_name)
        local fn = apis[msg]
        if fn ~= nil then
            if P ~= nil then
                rednet.send(id, fn(P), protocol_name)
            else
                print(("Got %s request but have no peripheral"):format(msg))
                rednet.send(id, nil, protocol_name)
            end
        else
            print("Received unknown message:", msg)
        end
    end
end

local function handleEvents(peripheral_type)
    while true do
        local eventData = { os.pullEvent() }
        local event = eventData[1]

        if event == "peripheral" then
            side = eventData[2]
            local newType = peripheral.getType(side)
            if newType == "modem" then
                -- Open the modem.
                rednet.open(side)
            elseif newType == peripheral_type then
                -- If an existing peripheral is present, keep it and log
                -- an error. Otherwise, store this peripheral.
                if P ~= nil then
                    P = peripheral_type
                else
                    print(("Already got a peripheral of type %s, ignoring"):format(peripheral_type))
                end
            end

        elseif event == "peripheral_detach" then
            side = eventData[2]
            local removedType = peripheral.getType(side)
            if removedType == peripheral_type then
                print("Peripheral removed")
                P = nil
            end
        end
    end
end

local function runServer(protocol_name, hostname, peripheral_type, apis)
    -- Run a server.
    -- This runs over rednet with the given protocol and host names.
    -- Events for supplied peripheral type are watched - when peripherals
    -- are removed events are logged and when added requests will go to them.
    -- N.B Maximum one connected peripheral - otherwise will error!
    -- APIs is a table of message to API call that will be called on
    -- message receipt. The peripheral will be passed to the API.

    -- Initialize all the current modems.
    local modems = { peripheral.find("modem") }

    for _, m in pairs(modems) do
        rednet.open(peripheral.getName(m))
    end

    p = { peripheral.find(peripheral_type) }
    if #p > 1 then
        print(("Error: more than one peripheral of type %s"):format(peripheral_type))
    elseif #p == 1 then
        P = p[1]
    else
        print(("No peripheral found of type %s"):format(peripheral_type))
    end

    -- No partial application, so create locals to parallelize.
    local function hr()
        handleRednet(protocol_name, hostname, apis)
    end

    local function he()
        handleEvents(peripheral_type)
    end

    parallel.waitForAny(hr, he)
end

return {
    runServer = runServer,
}