-- MTJ2024_Kleidung - Camera and 3D Preview System
-- Handles the rotating camera for player preview

local previewCamera = nil
local isPreviewActive = false
local rotationAngle = 0.0
local rotationSpeed = 0.5
local isPaused = false
local cameraDistance = 2.5
local cameraHeight = 0.5

-- Create preview camera
function CreatePreviewCamera()
    if previewCamera then
        return
    end
    
    local playerPed = PlayerPedId()
    local pedCoords = GetEntityCoords(playerPed)
    
    -- Create camera
    previewCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    
    -- Set camera properties
    SetCamActive(previewCamera, true)
    RenderScriptCams(true, false, 0, true, true)
    
    isPreviewActive = true
    rotationAngle = 0.0
    isPaused = false
    
    -- Start rotation thread
    CreateThread(function()
        while isPreviewActive do
            if not isPaused then
                UpdateCameraPosition()
                rotationAngle = rotationAngle + rotationSpeed
                if rotationAngle >= 360.0 then
                    rotationAngle = 0.0
                end
            end
            Wait(16) -- ~60 FPS
        end
    end)
end

-- Update camera position based on rotation
function UpdateCameraPosition()
    if not previewCamera or not isPreviewActive then
        return
    end
    
    local playerPed = PlayerPedId()
    local pedCoords = GetEntityCoords(playerPed)
    
    -- Calculate camera position in a circle around the player
    local radians = math.rad(rotationAngle)
    local camX = pedCoords.x + (math.cos(radians) * cameraDistance)
    local camY = pedCoords.y + (math.sin(radians) * cameraDistance)
    local camZ = pedCoords.z + cameraHeight
    
    -- Set camera position and point at player
    SetCamCoord(previewCamera, camX, camY, camZ)
    PointCamAtCoord(previewCamera, pedCoords.x, pedCoords.y, pedCoords.z + 0.7)
    
    -- Make player face the opposite direction of camera for better view
    local heading = (rotationAngle + 180.0) % 360.0
    SetEntityHeading(playerPed, heading)
end

-- Destroy preview camera
function DestroyPreviewCamera()
    if previewCamera then
        isPreviewActive = false
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(previewCamera, false)
        previewCamera = nil
    end
end

-- Toggle rotation pause
function ToggleRotationPause()
    isPaused = not isPaused
    return isPaused
end

-- Reset camera view
function ResetCameraView()
    rotationAngle = 0.0
    isPaused = false
end

-- Set rotation speed
function SetRotationSpeed(speed)
    rotationSpeed = speed
end

-- Set camera distance
function SetCameraDistance(distance)
    cameraDistance = distance
end

-- NUI Callbacks for camera controls
RegisterNUICallback('pauseRotation', function(data, cb)
    local paused = ToggleRotationPause()
    cb({ paused = paused })
end)

RegisterNUICallback('resetView', function(data, cb)
    ResetCameraView()
    cb('ok')
end)

RegisterNUICallback('setCameraDistance', function(data, cb)
    if data.distance then
        SetCameraDistance(data.distance)
    end
    cb('ok')
end)

-- Export functions for use in main.lua
exports('CreatePreviewCamera', CreatePreviewCamera)
exports('DestroyPreviewCamera', DestroyPreviewCamera)
exports('ToggleRotationPause', ToggleRotationPause)
exports('ResetCameraView', ResetCameraView)
