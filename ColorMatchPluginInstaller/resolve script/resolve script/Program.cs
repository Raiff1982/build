using static System.Runtime.InteropServices.JavaScript.JSType;
using System.Collections.Generic;
using System;

internal class Program
{
    private static void Main(string[] args)
    {
        --Connect to DaVinci Resolve
resolve = Resolve()
projectManager = resolve:GetProjectManager()
project = projectManager:GetCurrentProject()
mediaPool = project:GetMediaPool()
timeline = project:GetCurrentTimeline()

-- Set project color science to ACEScct
project:SetSetting('colorScienceMode', 'ACEScct')
project: SetSetting('ACESInputTransform', 'ACES 1.3')
project: SetSetting('ACESOutputTransform', 'Rec.709')

-- Function to set input color space for all clips
function setInputColorSpace(timeline, colorSpace)
    local clips = timeline:GetItemListInTrack('video', 1)
    for i, clip in ipairs(clips) do
            clip: SetClipProperty('Input Color Space', colorSpace)
    end
end

-- Function to apply color balance to all clips
function applyColorBalance(timeline)
    local clips = timeline:GetItemListInTrack('video', 1)
    for i, clip in ipairs(clips) do
                local colorCorrector = clip:GetColorCorrector()
                -- Adjust these values as needed for your project
        colorCorrector:SetLift({ 0.95, 0.95, 0.95})
        colorCorrector: SetGamma({ 1.0, 1.0, 1.0})
        colorCorrector: SetGain({ 1.05, 1.05, 1.05})
    end
end

-- Set input color space for all clips to ACES - adjust as needed
setInputColorSpace(timeline, 'ACES - ACEScg')

-- Apply color balance to all clips
applyColorBalance(timeline)

print("Color correction to ACES standards and color balance applied successfully!")
}
}