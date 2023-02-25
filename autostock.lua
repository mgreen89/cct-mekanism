as = require "ae2.autostock"

--List of the items which should be checked
--Display Name - Technical Name - Minimum Amount
items = {
    {"Glass", "minecraft:glass", 512},
    {"Certus Quartz Dust", "ae2:certus_quartz_dust", 1024},
    {"Charged Certus Quartz", "ae2:charged_certus_quartz_crystal", 1024},
    {"Logic Processor", "ae2:logic_processor", 4096},
    {"Calculation Processor", "ae2:calculation_processor", 4096},
    {"Engineering Processor", "ae2:engineering_processor", 512},
    {"Enriched Iron", "mekanism:enriched_iron", 2048},
    {"Steel Dust", "alltheores:steel_dust", 2048},
    {"Steel Ingot", "alltheores:steel_ingot", 2048},
    {"Basic Control Circuit", "mekanism:basic_control_circuit", 4096},
    {"Advanced Control Circuit", "mekanism:advanced_control_circuit", 2048},
    {"Elite Control Circuit", "mekanism:elite_control_circuit", 1024},
    {"Ultimate Control Circuit", "mekanism:ultimate_control_circuit", 512},
    {"Infused Alloy", "mekanism:alloy_infused", 4096},
    {"Reinforced Alloy", "mekanism:alloy_reinforced", 2048},
    {"Atomic Alloy", "mekanism:alloy_atomic", 1024},
}

monitor = peripheral.find("monitor")
mX, mY = monitor.getSize()
mWindow = window.create(monitor, 2, 1, mX - 2, mY - 1)
as.run(items, mWindow, term.current())