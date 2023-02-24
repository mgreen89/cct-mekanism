-- AE2 AutoStock

-- Add the parent folder to the path.
package.path = package.path .. ";../?.lua"
du = require "display.utils"

local function log(s, display)
    display.write(s)
    local _, lY = display.getCursorPos()
    display.scroll(1)
    display.setCursorPos(1, lY)
end

local function requestCraft(meBridge, item, amount, logDisplay)
    -- Returns true if crafting requested.
    if not meBridge.isItemCrafting({name = item[2]}) then
        local crafting = meBridge.craftItem({name = item[2], count = amount})
        if crafting then
            log(("Crafting %d x %s\n"):format(amount, item[1]), logDisplay)
        end
        return crafting
    end
    return false
end

local function stock(meBridge, item, meItem, monitorDisplay, monitorRow, logDisplay)
    -- Check if an item should be crafted, and if so, craft it.
    -- Put the appropriate lines to the two display.
    local itemName, itemColor, reqCount = item[1], colors.gray, item[3]
    local itemCount, countColor
    local status, statusColor = "   ", colors.red

    if not meItem then
        itemColor = colors.darkGray
        itemCount, countColor = 0, colors.darkGray
        status = " E "
    else
        itemCount = meItem.amount
        if meItem.amount < item[3] then
            local crafting = requestCraft(meBridge, item, item[3] - meItem.amount, logDisplay)
            if crafting then
                countColor, status, statusColor = colors.blue, " * ", colors.blue
            else
                countColor, status = colors.red, "   "
            end
        else
            countColor = colors.green
        end
    end

    monitorDisplay.setCursorPos(1, monitorRow)
    du.justify{itemName, "left", display=monitorDisplay, fgColor=itemColor}
    du.justify{("   %d/%d   "):format(itemCount, reqCount), "right", display=monitorDisplay, fgColor=countColor}
    du.justify{status, "right", display=monitorDisplay, fgColor=statusColor}
end

local function getAll(meBridge, items)
    local itemPairs = {}
    for i = 1, #items do
        local item = items[i]
        table.insert(itemPairs, {item, meBridge.getItem(item[2])})
    end
    return itemPairs
end

local function updateAll(meBridge, items, monitorDisplay, logDisplay)
    local itemPairs = getAll(meBridge, items)
    for i = 1, #itemPairs do
        local item, meItem = itemPairs[i][1], itemPairs[i][2]
        stock(meBridge, item, meItem, monitorDisplay, 2 + i, logDisplay)
    end
end

local function run(items, monitorDisplay, logDisplay)
    if logDisplay == nil then
        logDisplay = term.current()
    end

    -- Clear the monitor display and set the title.
    monitorDisplay.setBackgroundColor(colors.black)
    monitorDisplay.clear()
    justify{"AutoStock", "center", y=1, display=monitorDisplay, fgColor=colors.white}
    monitorDisplay.setCursorPos(1, 3)

    -- Find the ME bridge.
    local meBridge = peripheral.find("meBridge")
    if not meBridge then
        log("Failed to find ME bridge. Aborting.", logDisplay)
        monitorDisplay.write("Failed to find ME bridge. Aborting")
        return
    end

    -- Loop. Maybe make this a real event loop and watch for ME bridge
    -- detaching.
    while true do
        updateAll(meBridge, items, monitorDisplay, logDisplay)
        sleep(3)
    end
end

local function sample()
    -- List of the items which should be checked
    -- Display Name - Minecraft Name - Stock Amount
    local meItems = {
        {"Oak Planks", "minecraft:oak_planks", 180},
        {"Diorite", "minecraft:polished_diorite", 100},
        {"Wind Generator", "mekanismgenerators:wind_generator", 20},
        {"Glass", "minecraft:glass", 500},
        {"Stick", "minecraft:stick", 100},
    }

    local monitor = peripheral.find("monitor")
    monitor.setBackgroundColor(colors.lime)
    monitor.clear()
    -- Lets have a 1 pixel border.
    local mX, mY = monitor.getSize()
    local monitorWindow = window.create(monitor, 2, 2, mX - 2, mY - 2)

    run(meItems, monitorWindow)
end

return {
    run = run,
}