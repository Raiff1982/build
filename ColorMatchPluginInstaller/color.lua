-- Import DaVinci Resolve API
package.path = package.path .. ";C:/Program Files/Blackmagic Design/DaVinci Resolve/Developer/Scripting/Modules/?.lua"
local Resolve = require('Resolve') -- Ensure Resolve is defined or imported

-- Connect to DaVinci Resolve
local resolve = Resolve()
if not resolve then
    error("Failed to connect to DaVinci Resolve")
end

local projectManager = resolve:GetProjectManager()
if not projectManager then
    error("Failed to get Project Manager")
end

local project = projectManager:GetCurrentProject()
if not project then
    error("Failed to get Current Project")
end

local mediaPool = project:GetMediaPool()
if not mediaPool then
    error("Failed to get Media Pool")
end

local timeline = project:GetCurrentTimeline()
if not timeline then
    error("Failed to get Current Timeline")
end

-- Set project color science to ACEScct
if not project:SetSetting('colorScienceMode', 'ACEScct') then
    error("Failed to set color science mode to ACEScct")
end
if not project:SetSetting('ACESVersion', '1.3') then
    error("Failed to set ACES version to 1.3")
end
if not project:SetSetting('ACESInputTransform', 'ARRI') then
    error("Failed to set ACES input transform to ARRI")
end
if not project:SetSetting('ACESOutputTransform', 'Rec.709') then
    error("Failed to set ACES output transform to Rec.709")
end

-- Function to set input color space for all clips
local function setInputColorSpace(colorSpace)
    local clips = timeline:GetItemListInTrack('video', 1)
    if not clips then
        error("Failed to get clips from timeline")
    end
    for i, clip in ipairs(clips) do
        if not clip:SetClipProperty('Input Color Space', colorSpace) then
            error("Failed to set input color space for clip " .. i)
        end
    end
end

-- Function to apply color balance to all clips
local function applyColorBalance()
    local clips = timeline:GetItemListInTrack('video', 1)
    if not clips then
        error("Failed to get clips from timeline")
    end
    for i, clip in ipairs(clips) do
        local colorCorrector = clip:GetColorCorrector()
        if not colorCorrector then
            error("Failed to get color corrector for clip " .. i)
        end
        -- Adjust these values as needed for your project
        if not colorCorrector:SetLift({0.95, 0.95, 0.95}) then
            error("Failed to set lift for clip " .. i)
        end
        if not colorCorrector:SetGamma({1.0, 1.0, 1.0}) then
            error("Failed to set gamma for clip " .. i)
        end
        if not colorCorrector:SetGain({1.05, 1.05, 1.05}) then
            error("Failed to set gain for clip " .. i)
        end
    end
end

-- Set input color space for all clips to ACES - adjust as needed
setInputColorSpace(timeline, 'ACES - ACEScg')

-- Apply color balance to all clips
applyColorBalance()

-- Save the settings
if not project:Save() then
    error("Failed to save project")
end

print("Color correction to ACES standards and color balance applied successfully!")

-- Environment variables for DaVinci Resolve API
os.execute('setx RESOLVE_SCRIPT_API "%PROGRAMDATA%\\Blackmagic Design\\DaVinci Resolve\\Support\\Developer\\Scripting"')
os.execute('setx RESOLVE_SCRIPT_LIB "C:\\Program Files\\Blackmagic Design\\DaVinci Resolve\\fusionscript.dll"')
os.execute('setx PYTHONPATH "' .. os.getenv("PYTHONPATH") .. ';%RESOLVE_SCRIPT_API%\\Modules\\"')

print("Environment variables set successfully!")
