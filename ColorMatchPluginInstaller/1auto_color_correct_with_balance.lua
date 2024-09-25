-- Import DaVinci Resolve script module
local status, dvr = pcall(require, 'DaVinciResolveScript')
if not status then
    print("Failed to load DaVinciResolveScript module. Please ensure it is installed and accessible.")
    return
end

-- Initialize Resolve and get the current project
local resolve = dvr.scriptapp("Resolve")
local projectManager = resolve:GetProjectManager()
local project = projectManager:GetCurrentProject()

-- Function to set color science to ACEScct
local function setColorScienceToACEScct()
    if project then
        project:SetSetting('colorScienceMode', 'ACEScct')
        project:SetSetting('ACESVersion', '1.3')
        project:SetSetting('ACESInputTransform', 'ARRI')
        project:SetSetting('ACESOutputTransform', 'Rec.709')
        print("Color science set to ACEScct.")
    else
        print("No project found.")
    end
end

-- Execute the function if the project is valid
if project then
    setColorScienceToACEScct()
else
    print("Cannot execute function: No project found.")
end

-- Environment variables for DaVinci Resolve API
local ffi = require("ffi")
ffi.cdef[[
    int setenv(const char *name, const char *value, int overwrite);
]]

-- Set environment variables safely
local function setEnvVariable(name, value)
    if value then
        ffi.C.setenv(name, value, 1)
    else
        error("Environment variable " .. name .. " is nil")
    end
end

-- Set necessary environment variables
setEnvVariable("RESOLVE_SCRIPT_API", os.getenv("PROGRAMDATA") .. "\\Blackmagic Design\\DaVinci Resolve\\Support\\Developer\\Scripting")
setEnvVariable("RESOLVE_SCRIPT_LIB", "C:\\Program Files\\Blackmagic Design\\DaVinci Resolve\\fusionscript.dll")
setEnvVariable("PYTHONPATH", os.getenv("PYTHONPATH") .. ";" .. os.getenv("RESOLVE_SCRIPT_API") .. "\\Modules\\")

print("Environment variables and paths set successfully!")

-- Connect to DaVinci Resolve
local bmd = require('Resolve')
local resolve = bmd.scriptapp('Resolve')

local projectManager = resolve:GetProjectManager()
local project = projectManager:GetCurrentProject()
if not project then
    error("No project found")
end

local timeline = project:GetCurrentTimeline()
if not timeline then
    error("No timeline found")
end

-- Set project color science to ACEScct
local function setColorScienceToACEScct()
    project:SetSetting('colorScienceMode', 'ACEScct')
    project:SetSetting('ACESVersion', '1.3')
    project:SetSetting('ACESInputTransform', 'ARRI')
    project:SetSetting('ACESOutputTransform', 'Rec.709')
end

-- Function to set input color space for all clips
local function setInputColorSpace(currentTimeline, colorSpace)
    local clips = currentTimeline:GetItemListInTrack('video', 1)
    if not clips then
        error("No clips found in the timeline")
    end
    for _, clip in ipairs(clips) do
        clip:SetProperty('Input Color Space', colorSpace)
    end
end

-- Function to apply color balance to all clips
local function applyColorBalance(currentTimeline)
    local clips = currentTimeline:GetItemListInTrack('video', 1)
    if not clips then
        error("No clips found in the timeline")
    end
    for _, clip in ipairs(clips) do
        local colorCorrector = clip:GetFusionCompByIndex(1)
        if colorCorrector then
            -- Adjust these values as needed for your project
            colorCorrector:SetParameter('Lift', {0.95, 0.95, 0.95})
            colorCorrector:SetParameter('Gamma', {1.0, 1.0, 1.0})
            colorCorrector:SetParameter('Gain', {1.05, 1.05, 1.05})
        else
            print("No color corrector found for clip: " .. clip:GetName())
        end
    end
end

-- Execute the function if the project is valid
if project then
    setColorScienceToACEScct()
else
    print("Cannot execute function: No project found.")
end

-- Call the function to set input color space for all clips in the timeline
setInputColorSpace(timeline, 'ARRI LogC')

-- Call the function to apply color balance to all clips in the timeline
applyColorBalance(timeline)

-- Save the settings
project:Save()

print("Color correction to ACES standards and color balance applied successfully!")