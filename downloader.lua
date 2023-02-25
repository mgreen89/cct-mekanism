-- Download all the scripts here.

local dirs = {
    "ae2",
    "display",
    "mekanism",
}

local scripts = {
    "ae2/autostock",
    "display/utils",
    "mekanism/fission",
    "mekanism/fusion",
    "mekanism/induction",
    "mekanism/sps",
    "mekanism/turbine",
    "autostock",
    "energydisplay",
}

local REPO = "https://raw.githubusercontent.com/mgreen89/cct-mekanism/main/"

for _, d in pairs(dirs) do
    fs.makeDir(d)
end

for _, s in pairs(scripts) do
    local name = s .. ".lua"
    local url = REPO .. name
    print("Downloading " .. name)
    d = http.get(url)
    if d == nil then
        print(string.format("Error getting %s", url))
    else
        local h = d.readAll()
        f = fs.open(name, "w")
        f.write(h)
        f.close()
        d.close()
    end
end
