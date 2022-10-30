-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	if LoadTexture("circlemap") then
		AddReplaceTexture("platform:/textures/graphics","radarmasksm","circlemap","radarmasksm")

		SetMinimapClipType(1)
		SetMinimapComponentPosition("minimap","L","B",0.0,-0.015,0.129,0.24)
		SetMinimapComponentPosition("minimap_mask","L","B",0.135,0.12,0.063,0.134)
		SetMinimapComponentPosition("minimap_blur","L","B",0.0,0.0,0.185,0.250)

		SetBigmapActive(true,false)

		Wait(5000)

		SetBigmapActive(false,false)
	end
end)