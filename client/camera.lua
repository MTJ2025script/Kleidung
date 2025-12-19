-- MTJ2024_Kleidung - Camera and 3D Preview System
-- SIMPLE STATIC CAMERA - NO ROTATION

local previewCamera = nil
local currentView = 'front'

-- Camera views (3 different angles)
local cameraViews = {
    front = {
        offset = vector3(2.0, 0.0, 0.5),  -- In front of player
        heading = 0.0
    },
    left = {
        offset = vector3(0.0, -2.0, 0.5),  -- Left side
        heading = 90.0
    },
    right = {
        offset = vector3(0.0, 2.0, 0.5),  -- Right side
        heading = 270.0
    }
}

-- Create preview camera
function CreatePreviewCamera()
    if previewCamera then
        return
    end
    
    local playerPed = PlayerPedId()
    local pedCoords = GetEntityCoords(playerPed)
    
    -- Create camera
    previewCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    
    -- Set initial view (front)
    SetCameraView('front')
    
    SetCamActive(previewCamera, true)
    RenderScriptCams(true, false, 0, true, true)
end

-- Set camera view
function SetCameraView(view)
    if not previewCamera or not cameraViews[view] then
        return
    end
    
    currentView = view
    local viewData = cameraViews[view]
    
    local playerPed = PlayerPedId()
    local pedCoords = GetEntityCoords(playerPed)
    
    -- Position camera based on view
    local camX = pedCoords.x + viewData.offset.x
    local camY = pedCoords.y + viewData.offset.y
    local camZ = pedCoords.z + viewData.offset.z
    
    SetCamCoord(previewCamera, camX, camY, camZ)
    PointCamAtCoord(previewCamera, pedCoords.x, pedCoords.y, pedCoords.z + 0.7)
    SetCamFov(previewCamera, 50.0)
end

-- Destroy preview camera
function DestroyPreviewCamera()
    if previewCamera then
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(previewCamera, false)
        previewCamera = nil
        currentView = 'front'
    end
end

-- Switch camera view
function SwitchCameraView(view)
    SetCameraView(view)
end

-- Export functions
exports('CreatePreviewCamera', CreatePreviewCamera)
exports('DestroyPreviewCamera', DestroyPreviewCamera)
exports('SwitchCameraView', SwitchCameraView)
