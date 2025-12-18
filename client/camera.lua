-- MTJ2024_Kleidung - Camera and 3D Preview System
-- ESX LEGACY STYLE: Static camera with rotating player

local previewCamera = nil
local isPreviewActive = false
local rotationAngle = 0.0
local rotationSpeed = 0.5
local isPaused = false
local rotationThread = nil

-- Create preview camera (ESX Legacy Style)
function CreatePreviewCamera()
    if previewCamera then
        return
    end
    
    local playerPed = PlayerPedId()
    local pedCoords = GetEntityCoords(playerPed)
    
    -- Create camera at FIXED position
    previewCamera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    
    -- Position camera to show player on LEFT side of screen
    -- Camera slightly to right and front of player
    local camX = pedCoords.x + 2.0
    local camY = pedCoords.y + 0.5
    local camZ = pedCoords.z + 0.5
    
    SetCamCoord(previewCamera, camX, camY, camZ)
    PointCamAtCoord(previewCamera, pedCoords.x, pedCoords.y, pedCoords.z + 0.7)
    SetCamFov(previewCamera, 50.0)
    SetCamActive(previewCamera, true)
    RenderScriptCams(true, false, 0, true, true)
    
    isPreviewActive = true
    rotationAngle = 0.0
    isPaused = false
    
    -- Start player rotation
    StartPlayerRotation()
end

-- Start player rotation thread
function StartPlayerRotation()
    if rotationThread then
        return
    end
    
    rotationThread = CreateThread(function()
        while isPreviewActive do
            if not isPaused then
                local playerPed = PlayerPedId()
                if DoesEntityExist(playerPed) then
                    SetEntityHeading(playerPed, rotationAngle)
                    rotationAngle = rotationAngle + rotationSpeed
                    if rotationAngle >= 360.0 then
                        rotationAngle = 0.0
                    end
                end
            end
            Wait(16) -- ~60 FPS
        end
        rotationThread = nil
    end)
end

-- Stop player rotation
function StopPlayerRotation()
    isPreviewActive = false
    isPaused = true
    rotationAngle = 0.0
end

-- Destroy preview camera
function DestroyPreviewCamera()
    if previewCamera then
        -- Disable camera first
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(previewCamera, false)
        previewCamera = nil
        
        -- Small delay for cleanup
        Wait(100)
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

-- Export functions for use in main.lua
exports('CreatePreviewCamera', CreatePreviewCamera)
exports('DestroyPreviewCamera', DestroyPreviewCamera)
exports('StopPlayerRotation', StopPlayerRotation)
exports('ToggleRotationPause', ToggleRotationPause)
exports('ResetCameraView', ResetCameraView)
