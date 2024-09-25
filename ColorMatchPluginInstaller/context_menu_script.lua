-- Import DaVinci Resolve script module
import DaVinciResolveScript as dvr

-- Initialize Resolve and get the current project
resolve = dvr.scriptapp("Resolve")
projectManager = resolve.GetProjectManager()
project = projectManager.GetCurrentProject()
projectSettings = project.GetSetting()

-- Function to set color science to ACEScct
function setColorScienceToACEScct()
    projectSettings['colorScienceMode'] = 'ACEScct'
    projectSettings['ACESVersion'] = '1.3'
    projectSettings['ACESInputTransform'] = 'ARRI'
    projectSettings['ACESOutputTransform'] = 'Rec.709'
    project.SetSetting(projectSettings)
end

-- Add the function to the context menu
resolve.AddCustomMenuItem("Set Color Science to ACEScct", setColorScienceToACEScct)
