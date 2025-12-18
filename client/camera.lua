-- MTJ2024_Kleidung - Camera and 3D Preview System
-- GARAGE STYLE: Static camera with rotating player (like car preview)

local previewCamera = nil
local isPreviewActive = false
local rotationAngle = 0.0
local rotationSpeed = 0.5
local isPaused = false
local cameraDistance = 2.5
local cameraHeight = 0.5

-- Create preview camera (STATIC POSITION)
function CreatePreviewCamera()
    if previewCamera then
        return
    end
    
    local playerPed = PlayerPedId()
    local pedCoords = GetEntityCoords(playerPed)
    
    -- Create camera at FIXED position in front of player
    previewCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    
    -- Set camera to fixed position (like garage view)
    local camX = pedCoords.x + cameraDistance
    local camY = pedCoords.y
    local camZ = pedCoords.z + cameraHeight
    
    SetCamCoord(previewCamera, camX, camY, camZ)
    PointCamAtCoord(previewCamera, pedCoords.x, pedCoords.y, pedCoords.z + 0.7)
    
    -- Activate camera
    SetCamActive(previewCamera, true)
    RenderScriptCams(true, false, 0, true, true)
    
    isPreviewActive = true
    rotationAngle = 0.0
    isPaused = false
    
    -- Start PLAYER rotation thread (not camera!)
    CreateThread(function()
        while isPreviewActive do
            if not isPaused then
                RotatePlayer()
                rotationAngle = rotationAngle + rotationSpeed
                if rotationAngle >= 360.0 then
                    rotationAngle = 0.0
                end
            end
            Wait(16) -- ~60 FPS
        end
    end)
end

-- Rotate PLAYER (not camera!) - Garage Style
function RotatePlayer()
    if not isPreviewActive then
        return
    end
    
    local playerPed = PlayerPedId()
    if not DoesEntityExist(playerPed) then
        return
    end
    
    -- Simply rotate the player's heading (like garage car rotation)
    SetEntityHeading(playerPed, rotationAngle)
end

-- Destroy preview camera
function DestroyPreviewCamera()
    if previewCamera then
        -- Stop rotation immediately
        isPreviewActive = false
        isPaused = true
        
        -- Disable camera
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(previewCamera, false)
        previewCamera = nil
        
        -- Reset rotation angle
        rotationAngle = 0.0
        
        -- Small delay to ensure camera is fully destroyed
        Wait(50)
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
    
    -- Update camera position if active
    if previewCamera and isPreviewActive then
        local playerPed = PlayerPedId()
        local pedCoords = GetEntityCoords(playerPed)
        
        local camX = pedCoords.x + cameraDistance
        local camY = pedCoords.y
        local camZ = pedCoords.z + cameraHeight
        
        SetCamCoord(previewCamera, camX, camY, camZ)
        PointCamAtCoord(previewCamera, pedCoords.x, pedCoords.y, pedCoords.z + 0.7)
    end
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
