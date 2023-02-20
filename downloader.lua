-- Download all the scripts here.

local scripts = {
    "displayutils",
    "energy",
    "energydisplay",
    "fission",
    "fusion",
    "induction",
    "sps",
    "turbine",
}

local REPO = "https://raw.githubusercontent.com/mgreen89/cct-mekanism/main/"

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
