
import DaVinciResolveScript as dvr

resolve = dvr.scriptapp("Resolve")
projectManager = resolve.GetProjectManager()
project = projectManager.GetCurrentProject()
projectSettings = project.GetSetting()

# Set Color Science to ACEScct
projectSettings['colorScienceMode'] = 'ACEScct'

# Set ACES Version
projectSettings['ACESVersion'] = '1.3'

# Set Input and Output Transforms
projectSettings['ACESInputTransform'] = 'ARRI'
projectSettings['ACESOutputTransform'] = 'Rec.709'

# Save the settings
project.SetSetting(projectSettings)
