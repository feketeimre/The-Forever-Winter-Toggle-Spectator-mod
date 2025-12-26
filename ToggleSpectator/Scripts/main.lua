local UEHelpers = require("UEHelpers")

local IsActive = false
local pawn  -- to keep track of the original
local photomode

local function ToggleSpectator()
	local gameplayStatics = UEHelpers.GetGameplayStatics()
	local engine = UEHelpers:GetEngine()
	local playerController = gameplayStatics:GetPlayerController(engine.GameViewport.World, 0)

    if not IsActive then
        --print(string.format("[SpectatorMode] PlayerController: %s",playerController, playerController:GetFullName()))
        if playerController and playerController:IsValid() then
            ---@class ABP_PlayerBase_C
            pawn = playerController:K2_GetPawn()
            if pawn and pawn:IsValid() then
                --print(string.format("[SpectatorMode] Pawn: %s",  pawn, pawn:GetFullName()))
                pawn:SpawnSpectator()
                IsActive = true
                --print("[SpectatorMode] Enabled SpectatorMode")
            end
        end
    else
		local spectatorPawn = playerController:K2_GetPawn()
		playerController:Possess(pawn)  -- playerController posesses the original pawn
		pawn.PossesBack()
		spectatorPawn:K2_DestroyActor() -- get rid of spectator
		IsActive = false
		--print("[SpectatorMode] Disabled SpectatorMode")
    end
end

RegisterKeyBind(Key.F8, {}, function()
    ExecuteInGameThread(function()
        ToggleSpectator()
    end)
end)


RegisterKeyBind(Key.F7, {}, function()
    ExecuteInGameThread(function()
		for _, pm in ipairs(FindAllOf("BPC_PhotoMode_C")) do
			photomode = pm
		end
		photomode.UpdateReferences(true)
		photomode.InitWidgets()
		photomode.ResetPhotoMode()
		--print ("photomode", photomode, photomode:GetFullName())
    end)
end)



