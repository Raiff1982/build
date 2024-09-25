-- Connect to DaVinci Resolve
resolve = Resolve()
projectManager = resolve:GetProjectManager()
project = projectManager:GetCurrentProject()
mediaPool = project:GetMediaPool()
timeline = project:GetCurrentTimeline()

-- Set project color science to ACEScct
project:SetSetting('colorScienceMode', 'ACEScct')
project:SetSetting('ACESVersion', '1.3')
project:SetSetting('ACESInputTransform', 'ARRI')
project:SetSetting('ACESOutputTransform', 'Rec.709')

-- Function to set input color space for all clips
function setInputColorSpace(timeline, colorSpace)
    local clips = timeline:GetItemListInTrack('video', 1)
    for i, clip in ipairs(clips) do
        clip:SetClipProperty('Input Color Space', colorSpace)
    end
end

-- Function to apply color balance to all clips
function applyColorBalance(timeline)
    local clips = timeline:GetItemListInTrack('video', 1)
    for i, clip in ipairs(clips) do
        local colorCorrector = clip:GetColorCorrector()
        -- Adjust these values as needed for your project
        colorCorrector:SetLift({0.95, 0.95, 0.95})
        colorCorrector:SetGamma({1.0, 1.0, 1.0})
        colorCorrector:SetGain({1.05, 1.05, 1.05})
    end
end

-- Set input color space for all clips to ACES - adjust as needed
setInputColorSpace(timeline, 'ACES - ACEScg')

-- Apply color balance to all clips
applyColorBalance(timeline)

-- Save the settings
project:Save()

print("Color correction to ACES standards and color balance applied successfully!")

-- Environment variables for DaVinci Resolve API
os.setenv("RESOLVE_SCRIPT_API", "%PROGRAMDATA%\\Blackmagic Design\\DaVinci Resolve\\Support\\Developer\\Scripting")
os.setenv("RESOLVE_SCRIPT_LIB", "C:\\Program Files\\Blackmagic Design\\DaVinci Resolve\\fusionscript.dll")
os.setenv("PYTHONPATH", os.getenv("PYTHONPATH") .. ";%RESOLVE_SCRIPT_API%\\Modules\\")

-- Paths for scripts
allUsersPath = "%PROGRAMDATA%\\Blackmagic Design\\DaVinci Resolve\\Fusion\\Scripts"
specificUserPath = "%APPDATA%\\Roaming\\Blackmagic Design\\DaVinci Resolve\\Support\\Fusion\\Scripts"

print("Environment variables and paths set successfully!")
