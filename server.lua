entregaMarker = createMarker(-488.322265625, -180.4482421875, 77.2109375, "cylinder", 2, 255,255,255, 255)
arbol = createObject(615,-503.224609375, -198.6708984375, 77.40625)
colArbol = createColSphere(-503.224609375, -198.6708984375, 78.40625,1.7)
miMadera = {}
setElementData(arbol, "isArbol", true)
setElementData(arbol, "talando", false)
setElementData(arbol, "proceso", 0)

function aceptarTrabajo()
	setElementData(client, "Ocupacion","Leñador")
	team = getTeamFromName("Trabajadores")
    r, g, b = getTeamColor ( team )
	setPlayerTeam(client,team)
    setPlayerNametagColor ( client, r, g, b )
	outputChatBox("Bienvenido al trabajo", client)
end
addEvent( "aceptarTrabajo", true)
addEventHandler( "aceptarTrabajo", getRootElement(), aceptarTrabajo)

function talarArbol(source)
    if (isElementWithinColShape(source,colArbol)) then
        if(getElementData(source,"Ocupacion"):find "Leñador" ~= nil) and getPedWeapon ( source) == 9 then
            local px, py, pz = getElementPosition(source)
            setPedAnimation(source,"CHAINSAW","csaw_part",-1,true,false,false)
            setElementData(arbol, "talando", true)
            setAcciones(source, false)
            procesoArbol(arbol)
            setTimer(function()
                setElementData(arbol, "talando", false)
                setElementData(arbol, "proceso", 0)
                maderaGanada = math.random(1,4)
                setElementData(source, "maderaPos", maderaGanada)
                outputChatBox("Proceso terminado, ha ganado "..maderaGanada.." madera, entregalo!", source)
                setPedAnimation(source)
                setPedWeaponSlot(source, 0)
                setPedAnimation(source,"CARRY","crry_prtial",0,true,false,true,true)
                miMadera[source] = createObject(1463,px, py, pz)
                setElementCollisionsEnabled ( miMadera[source], false) 
                setObjectScale ( miMadera[source], 0.3)
                attachElements(miMadera[source], source, 0,0.5,0.3,0,0,0)
                setElementData(source, "llevaMadera", true)
                setAcciones(source, true)
            end, 6000, 1)
        end
    end
end
addCommandHandler("talar", talarArbol)

function procesoArbol(arbol)
    setTimer(function()
        procesoArbol = getElementData(arbol, "proceso") or 0
        setElementData(arbol, "proceso", procesoArbol + 20)
    end,1000, 5)
end

function setAcciones(player, status)
    toggleControl ( player, "accelerate", status )
    toggleControl ( player, "brake_reverse", status )
    toggleControl ( player, "handbrake", status )
    toggleControl ( player, "fire", status )
    toggleControl ( player, "next_weapon", status )
    toggleControl ( player, "previous_weapon", status )
    toggleControl ( player, "change_camera", status )
    toggleControl ( player, "jump", status )
    toggleControl ( player, "look_behind", status )
    toggleControl ( player, "crouch", status )
    toggleControl ( player, "sprint", status )
end

function entregarMaterialesMarker(source)
	if getElementData(source, "llevaMadera") and (getElementData(source,"Ocupacion"):find "Leñador" ~= nil) then
        setElementData(source, "llevaMadera", false)
        maderaJ = getElementData(source, "maderaPos")
        nivelLen = getElementData(source, "nivelLenador") or 0
        cantidadMadera = getElementData(source,"cantidadMaderaTotal") or 0
        setElementData(source, "cantidadMaderaTotal", cantidadMadera + maderaJ)
        setElementData(source, "nivelLenador", nivelLen + 1)
        cantidadPorNivel = nivelLen * 5
        valorTotalMadera = 500 * maderaJ
        cantidadTotal = 3000 + cantidadPorNivel + valorTotalMadera
        givePlayerMoney(source, cantidadTotal)
        destroyElement(miMadera[source])
        outputChatBox("Madera entregada, has ganado $"..cantidadTotal.." ", source)
	end
end
addEventHandler("onMarkerHit", entregaMarker, entregarMaterialesMarker)

function cantidadMadera(source)
    cantidadMadera = getElementData(source,"cantidadMaderaTotal") or 0
    outputChatBox("La cantidad de madera total entregada es:"..cantidadMadera.." ", source   )
end
addCommandHandler("cantidad", cantidadMadera)