-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	if LoadTexture("circlemap") then
		AddReplaceTexture("platform:/textures/graphics","radarmasksm","circlemap","radarmasksm")

		SetMinimapClipType(1)
		SetMinimapComponentPosition("minimap","L","B",-0.0045,0.002-0.025,0.150,0.188888)
		SetMinimapComponentPosition("minimap_mask","L","B",0.020,0.032-0.025,0.111,0.159)
		SetMinimapComponentPosition("minimap_blur","L","B",-0.025,0.022-0.025,0.266,0.237)
	end
end)