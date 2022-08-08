markerTrabajo = createMarker(-490.9091796875, -192.658203125, 77.327941894531, "cylinder", 2, 255,255,255, 255)
createBlipAttachedTo ( markerTrabajo ,56, 1, 255, 0, 0, 255, 0, 300 )

local sx,sy = guiGetScreenSize()
local px,py = 1440,900
local x,y =  (sx/px), (sy/py)

function PanelLenador()
	if not isElement(window) then
		window = guiCreateWindow(x*456, y*212, x*520, y*452, "Trabajo Leñador", false)
		guiWindowSetSizable(window, false)

		local playerName = getPlayerName(getLocalPlayer())	
		informacionTrabajo = guiCreateMemo(x*10, y*25, x*242, y*417, "" .. playerName ..  " a partir de ahora trabajaras como Leñador, tu decides si aceptar o no", false, window)
		guiMemoSetReadOnly(informacionTrabajo, true)
		btnAceptar = guiCreateButton(x*279, y*25, x*227, y*76, "Aceptar Trabajo", false, window)
		btnSalir = guiCreateButton(x*278, y*339, x*228, y*82, "Salir", false, window)
		
		showCursor(true)
		addEventHandler("onClientGUIClick", btnAceptar, function()
			triggerServerEvent("aceptarTrabajo",localPlayer)
		end, false)
		addEventHandler("onClientGUIClick", btnAceptar, salirPanel, false)	
		addEventHandler("onClientGUIClick", btnSalir, salirPanel, false)
	else
		outputChatBox("Ya tienes el panel abierto", localPlayer)
	end
end
addEventHandler("onClientMarkerHit", markerTrabajo, PanelLenador)

function salirPanel()
	destroyElement(window)
	showCursor(false)
end

setDevelopmentMode(true)

function createArbolInformation()
	arboles = getElementsByType("object",root,true)
	for num, arbol in ipairs(arboles) do
		if getElementData(arbol,"talando") then
			local carPosX, carPosY, carPosZ = getElementPosition(arbol)
			local cx, cy, cz = getCameraMatrix()
			carLocationX, carLocationY = getScreenFromWorldPosition(carPosX, carPosY, carPosZ, 100)
			local min_distance = getDistanceBetweenPoints3D(cx, cy, cz, carPosX, carPosY, carPosZ)
			local proceso = getElementData(arbol, "proceso") or 0
			if min_distance < 16 then
				if carLocationX then
					rect2 = dxDrawRectangle(carLocationX-102.5, carLocationY-50-52.5, 1025/4, 25, tocolor(0,0,0,255))
					dxDrawRectangle(carLocationX-100, carLocationY-50-50, proceso* 2.5, 20, tocolor(0,127.5,0,255))
					dxDrawText("Proceso : "..proceso.."%", carLocationX-50-35, carLocationY-50-50, 0, 0, tocolor(255,255,255,255), 1, "default-bold")
				end
			end
		end
	end
end
addEventHandler("onClientRender",getRootElement(),createArbolInformation)


