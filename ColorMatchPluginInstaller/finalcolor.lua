-- Import DaVinci Resolve API
package.path = package.path .. ";C:/Program Files/Blackmagic Design/DaVinci Resolve/Developer/Scripting/Modules/?.lua"
package.path = package.path .. ";C:/ProgramData/Blackmagic Design/DaVinci Resolve/Support/Developer/Scripting/Modules/?.lua"
local Resolve = require('DaVinciResolveScript') -- Ensure Resolve is defined or imported

-- Connect to DaVinci Resolve
local resolve-- Import DaVinci Resolve API
package.path = package.path .. ";C:/Program Files/Blackmagic Design/DaVinci Resolve/Developer/Scripting/Modules/?.lua"
package.path = package.path .. ";C:/ProgramData/Blackmagic Design/DaVinci Resolve/Support/Developer/Scripting/Modules/?.lua"
local Resolve = require('DaVinciResolveScript') -- Ensure Resolve is defined or imported

-- Connect to DaVinci Resolve
local resolve = Resolve()
if not resolve then
    error("Failed to connect to DaVinci Resolve")
end

-- Import DaVinci Resolve API
package.path = package.path .. ";C:/Program Files/Blackmagic Design/DaVinci Resolve/Developer/Scripting/Modules/?.lua"
package.path = package.path .. ";C:/ProgramData/Blackmagic Design/DaVinci Resolve/Support/Developer/Scripting/Modules/?.lua"
local Resolve = require('DaVinciResolveScript') -- Ensure Resolve is defined or imported

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
    error("Failed to get current project")
end

local timeline = project:GetCurrentTimeline()
if not timeline then
    error("Failed to get current timeline")
end

print("Current timeline retrieved successfully")

git commit --fixup {commit_id}

local mediaOut1 = timeline:GetItemByName("MediaOut1")
if not mediaOut1 then
    error("Failed to get MediaOut1 node")
end

local time = 601
local parameter = mediaOut1:GetParameterAtTime("Input", time)
if not parameter then
    error("MediaOut1 cannot get Parameter for Input at time " .. time)
end

print("Parameter for MediaOut1 at time " .. time .. " is: " .. tostring(parameter))

-- Import DaVinci Resolve API
package.path = package.path .. ";C:/Program Files/Blackmagic Design/DaVinci Resolve/Developer/Scripting/Modules/?.lua"
package.path = package.path .. ";C:/ProgramData/Blackmagic Design/DaVinci Resolve/Support/Developer/Scripting/Modules/?.lua"
local Resolve = require('DaVinciResolveScript') -- Ensure Resolve is defined or imported

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
    error("Failed to get current project")
end

local timeline = project:GetCurrentTimeline()
if not timeline then
    error("Failed to get current timeline")
end

local mediaOut1 = timeline:GetItemByName("MediaOut1")
if not mediaOut1 then
    error("Failed to get MediaOut1 node")
end

local time = 601
local parameter = mediaOut1:GetParameterAtTime("Input", time)
if not parameter then
    error("MediaOut1 cannot get Parameter for Input at time " .. time)
end

print("Parameter for MediaOut1 at time " .. time .. " is: " .. tostring(parameter))

-- Import DaVinci Resolve API
package.path = package.path .. ";C:/Program Files/Blackmagic Design/DaVinci Resolve/Developer/Scripting/Modules/?.lua"
package.path = package.path ..
    ";C:/ProgramData/Blackmagic Design/DaVinci Resolve/Support/Developer/Scripting/Modules/?.lua"
local Resolve = require('DaVinciResolveScript') -- Ensure Resolve is defined or imported

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
local function setInputColorSpace(timelineObj, colorSpace)
    local clips = timelineObj:GetItemListInTrack('video', 1)
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
local function applyColorBalance(timelineObj)
    local clips = timelineObj:GetItemListInTrack('video', 1)
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
applyColorBalance(timeline)

-- Save the settings
if not project:Save() then
    error("Failed to save project")
end

print("Color correction to ACES standards and color balance applied successfully!")

-- Function to set environment variables
local function setenv(name, value)
    local success, msg
    if package.config:sub(1,1) == '\\' then
        -- Windows
        success, msg = os.execute('set ' .. name .. '=' .. value)
    else
        -- Unix-based
        success, msg = os.execute('export ' .. name .. '="' .. value .. '"')
    end
    if not success then
        error("Failed to set environment variable " .. name .. ": " .. (msg or "unknown error"))
    end
end

-- Set environment variables for DaVinci Resolve API
setenv("RESOLVE_SCRIPT_API", "%PROGRAMDATA%\\Blackmagic Design\\DaVinci Resolve\\Support\\Developer\\Scripting")
setenv("RESOLVE_SCRIPT_LIB", "C:\\Program Files\\Blackmagic Design\\DaVinci Resolve\\fusionscript.dll")
setenv("PYTHONPATH", os.getenv("PYTHONPATH") .. ";%RESOLVE_SCRIPT_API%\\Modules\\")
npm install express@4.17.1

print("Environment variables set successfully!")

node -v
npm -v

node -v
npm -v

-- Get the Project Manager
local projectManager = resolve:GetProjectManager()
if not projectManager then
    error("Failed to get Project Manager")
end

-- Get the Current Project
local project = projectManager:GetCurrentProject()
if not project then
    error("Failed to get current project")
end

-- Get the Current Timeline
local timeline = project:GetCurrentTimeline()
if not timeline then
    error("Failed to get current timeline")
end

print("Current timeline retrieved successfully")
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
    error("Failed to get current project")
end

local timeline = project:GetCurrentTimeline()
if not timeline then
    error("Failed to get current timeline")
end

local mediaOut1 = timeline:GetItemByName("MediaOut1")
if not mediaOut1 then
    error("Failed to get MediaOut1 node")
end

local time = 601
local parameter = mediaOut1:GetParameterAtTime("Input", time)
if not parameter then
    error("MediaOut1 cannot get Parameter for Input at time " .. time)
end

print("Parameter for MediaOut1 at time " .. time .. " is: " .. tostring(parameter))

-- Import DaVinci Resolve API
package.path = package.path .. ";C:/Program Files/Blackmagic Design/DaVinci Resolve/Developer/Scripting/Modules/?.lua"
package.path = package.path .. ";C:/ProgramData/Blackmagic Design/DaVinci Resolve/Support/Developer/Scripting/Modules/?.lua"
local Resolve = require('DaVinciResolveScript') -- Ensure Resolve is defined or imported

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
    error("Failed to get current project")
end

local timeline = project:GetCurrentTimeline()
if not timeline then
    error("Failed to get current timeline")
end

local mediaOut1 = timeline:GetItemByName("MediaOut1")
if not mediaOut1 then
    error("Failed to get MediaOut1 node")
end

local time = 601
local parameter = mediaOut1:GetParameterAtTime("Input", time)
if not parameter then
    error("MediaOut1 cannot get Parameter for Input at time " .. time)
end

print("Parameter for MediaOut1 at time " .. time .. " is: " .. tostring(parameter))

-- Import DaVinci Resolve API
package.path = package.path .. ";C:/Program Files/Blackmagic Design/DaVinci Resolve/Developer/Scripting/Modules/?.lua"
package.path = package.path ..
    ";C:/ProgramData/Blackmagic Design/DaVinci Resolve/Support/Developer/Scripting/Modules/?.lua"
local Resolve = require('DaVinciResolveScript') -- Ensure Resolve is defined or imported

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
local function setInputColorSpace(timelineObj, colorSpace)
    local clips = timelineObj:GetItemListInTrack('video', 1)
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
local function applyColorBalance(timelineObj)
    local clips = timelineObj:GetItemListInTrack('video', 1)
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
applyColorBalance(timeline)

-- Save the settings
if not project:Save() then
    error("Failed to save project")
end

print("Color correction to ACES standards and color balance applied successfully!")

-- Function to set environment variables
local function setenv(name, value)
    local success, msg
    if package.config:sub(1,1) == '\\' then
        -- Windows
        success, msg = os.execute('set ' .. name .. '=' .. value)
    else
        -- Unix-based
        success, msg = os.execute('export ' .. name .. '="' .. value .. '"')
    end
    if not success then
        error("Failed to set environment variable " .. name .. ": " .. (msg or "unknown error"))
    end
end

-- Set environment variables for DaVinci Resolve API
setenv("RESOLVE_SCRIPT_API", "%PROGRAMDATA%\\Blackmagic Design\\DaVinci Resolve\\Support\\Developer\\Scripting")
setenv("RESOLVE_SCRIPT_LIB", "C:\\Program Files\\Blackmagic Design\\DaVinci Resolve\\fusionscript.dll")
setenv("PYTHONPATH", os.getenv("PYTHONPATH") .. ";%RESOLVE_SCRIPT_API%\\Modules\\")

print("Environment variables set successfully!")
-- Removed invalid Lua code-- Function to set environment variables
function setenv(name, value)
    local success, msg = pcall(function()
        os.setenv(name, value)
    end)
    if not success then
        error("Failed to set environment variable " .. name .. ": " .. (msg or "unknown error"))
    end
end

-- Set environment variables for DaVinci Resolve API
setenv("RESOLVE_SCRIPT_API", "%PROGRAMDATA%\\Blackmagic Design\\DaVinci Resolve\\Support\\Developer\\Scripting")
setenv("RESOLVE_SCRIPT_LIB", "C:\\Program Files\\Blackmagic Design\\DaVinci Resolve\\fusionscript.dll")
setenv("PYTHONPATH", os.getenv("PYTHONPATH") .. ";%RESOLVE_SCRIPT_API%\\Modules\\")

print("Environment variables set successfully!")
-- Install npm-check-updates globally
os.execute('npm install -g npm-check-updates')

-- Update package.json with the latest versions of all dependencies
os.execute('ncu -u')

-- Install the updated packages
os.execute('npm install')

-- Set environment variables for DaVinci Resolve API
setenv("RESOLVE_SCRIPT_API", "%PROGRAMDATA%\\Blackmagic Design\\DaVinci Resolve\\Support\\Developer\\Scripting")
setenv("RESOLVE_SCRIPT_LIB", "C:\\Program Files\\Blackmagic Design\\DaVinci Resolve\\fusionscript.dll")
setenv("PYTHONPATH", os.getenv("PYTHONPATH") .. ";%RESOLVE_SCRIPT_API%\\Modules\\")

print("Environment variables set successfully!")

-- Get the Project Manager
local projectManager = resolve:GetProjectManager()
if not projectManager then
    error("Failed to get Project Manager")
endelse
    -- Unix-based
    success, msg = os.execute('export ' .. name .. '="' .. value .. '"')
end
if not success then
    error("Failed to set environment variable " .. name .. ": " .. (msg or "unknown error"))
end

-- Set environment variables for DaVinci Resolve API
setenv("RESOLVE_SCRIPT_API", "%PROGRAMDATA%\\Blackmagic Design\\DaVinci Resolve\\Support\\Developer\\Scripting")
setenv("RESOLVE_SCRIPT_LIB", "C:\\Program Files\\Blackmagic Design\\DaVinci Resolve\\fusionscript.dll")
setenv("PYTHONPATH", os.getenv("PYTHONPATH") .. ";%RESOLVE_SCRIPT_API%\\Modules\\")

print("Environment variables set successfully!")

-- Get the Project Manager
local projectManager = resolve:GetProjectManager()
if not projectManager then
    error("Failed to get Project Manager")
end
lua C:\Users\Harri\OneDrive\Desktop\resolve scripts\finalcolor.lua
-- Remove this line
-- local success, msg = os.execute('cmd.exprint("Environment variables set successfully!")

-- Get the Project Manager
local projectManager = resolve:GetProjectManager()
if not projectManager then
    error("Failed to get Project Manager")
end

-- local success, msg = os.execute('cmd.exe /c npm start')
-- Uncomment the line above if you need to execute the npm start command
-- if not success then
--     error("Failed to run npm start: " .. (msg or "unknown error"))
-- ende /c npm start')
if not success then
    error("Failed to run npm start: " .. (msg or "unknown error"))
end
