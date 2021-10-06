local Keys = {["ESC"] = 322,["F1"] = 288,["F2"] = 289,["F3"] = 170,["F5"] = 166,["F6"] = 167,["F7"] = 168,["F8"] = 169,["F9"] = 56,["F10"] = 57,["~"] = 243,["1"] = 157,["2"] = 158,["3"] = 160,["4"] = 164,["5"] = 165,["6"] = 159,["7"] = 161,["8"] = 162,["9"] = 163,["-"] = 84,["="] = 83,["BACKSPACE"] = 177,["TAB"] = 37,["Q"] = 44,["W"] = 32,["E"] = 38,["R"] = 45,["T"] = 245,["Y"] = 246,["U"] = 303,["P"] = 199,["["] = 39,["]"] = 40,["ENTER"] = 18,["CAPS"] = 137,["A"] = 34,["S"] = 8,["D"] = 9,["F"] = 23,["G"] = 47,["H"] = 74,["K"] = 311,["L"] = 182,["LEFTSHIFT"] = 21,["Z"] = 20,["X"] = 73,["C"] = 26,["V"] = 0,["B"] = 29,["N"] = 249,["M"] = 244,[","] = 82,["."] = 81,["LEFTCTRL"] = 36,["LEFTALT"] = 19,["SPACE"] = 22,["RIGHTCTRL"] = 70,["HOME"] = 213,["PAGEUP"] = 10,["PAGEDOWN"] = 11,["DELETE"] = 178,["LEFT"] = 174,["RIGHT"] = 175,["TOP"] = 27,["DOWN"] = 173,["NENTER"] = 201,["N4"] = 108,["N5"] = 60,["N6"] = 107,["N+"] = 96,["N-"] = 97,["N7"] = 117,["N8"] = 61,["N9"] = 118}
local name = GetPlayerName(PlayerId())
-- ESX
ESX = nil

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end)
-- Fin ESX

-- Eventos
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
    trabajoActual = PlayerData.job.label
    trabajoActualGrado = PlayerData.job.grade_label
    trabajoActualGradoo = PlayerData.job.grade_name
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    trabajoNombre = PlayerData.job.name
    trabajoActual = PlayerData.job.label
    trabajoActualGrado = PlayerData.job.grade_label
    trabajoActualGradoo = PlayerData.job.grade_name
    if trabajoActualGradoo ~= nil and trabajoActualGradoo == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney',
            function(money) dineroSociedad = money end,
        trabajoNombre)
    end
end)


-- Eventos2
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)
-- Fin de eventos2

-- Inicio Funciones
function openMenu()
    local id = GetPlayerServerId(PlayerId())
    local elements = {}
    local ped = PlayerPedId()
    local trabajoActual = PlayerData.job.label
    local JobGrade = PlayerData.job.grade_label
    local JobGradeName = PlayerData.job.grade_name
    local name = GetPlayerName(PlayerId())
    
    table.insert(elements, {label = '<span style="color:#FF00EC;">-- INFORMACIÓN --'})

    table.insert(elements, {label = 'Trabajo : '..PlayerData.job.label..' - '..PlayerData.job.grade_label})

    table.insert(elements, {label = '<span style="color:#FF0000;">-- GENERAL --'})

    table.insert(elements, {label = '<span>Mostrar Información', value = 'mostrarinfo'})
    
    table.insert(elements, {label = '<span style="color:#00FFCD;">-- OOC --'})

    table.insert(elements, {label = 'Extras', value = 'extras'})

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_menu', {
        title = 'Trabajo : '..PlayerData.job.label..' - '..PlayerData.job.grade_label,
        align = Config.Alineacion,
        elements = elements
    }, function(data, menu)

        local val = data.current.value

        if val == 'interaccion_ciudadana' then

            OpenCitizenmenu()

        elseif val == 'extras' then
            Variado()

        elseif data.current.value == 'mostrarinfo' then
            openMenu_3()

        end
    end, function(data, menu) menu.close() end)
end

function openMenu_3()
    local id = GetPlayerServerId(PlayerId())
    local elements = {}
    local ped = PlayerPedId()
    local trabajoActual = PlayerData.job.label
    local JobGrade = PlayerData.job.grade_label
    local JobGradeName = PlayerData.job.grade_name

    table.insert(elements, {label = 'Mirar tu DNI', value = 'dnimirar'})
    table.insert(elements, {label = 'Enseñar tu DNI', value = 'ensenardni'})

    table.insert(elements, {label = 'Mirar tu carnet de conducir', value = 'carnetmirar'})
    table.insert(elements, {label = 'Enseñar tu carnet de conducir', value = 'ensenarcarnet'})

    table.insert(elements, {label = 'Mirar tu licencia de armas', value = 'weaponmostrar'})
    table.insert(elements, {label = 'Enseñar tu licencia de armas', value = 'weaponensenar'})


    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'citizen_menu_2', {
        title = trabajoActual,
        align = Config.Alineacion,
        elements = elements
    }, function(data3, menu2)

        if data3.current.value == 'dnimirar' then

            ExecuteCommand('me mira su dni')

            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))

        elseif data3.current.value == 'ensenardni' then

            ExecuteCommand('me le enseña el dni')
            
            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

              TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))

            else

              ESX.ShowNotification('No hay jugadores cerca')

            end

        elseif data3.current.value == 'carnetmirar' then

            ExecuteCommand('me mira su carnet de conducir')
            
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')

        elseif data3.current.value == 'ensenarcarnet' then

            ExecuteCommand('me le enseña el carnet de conducir')
            
            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')

            else

                ESX.ShowNotification('No hay jugadores cerca')

            end
        
        elseif data3.current.value == 'weaponmostrar' then

            ExecuteCommand('me mira su licencia de armas')
            
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')

        elseif data3.current.value == 'weaponensenar' then

            ExecuteCommand('me le enseña la licencia de armas')
            
            local player, distance = ESX.Game.GetClosestPlayer()

            if distance ~= -1 and distance <= 3.0 then

                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')

            else

                ESX.ShowNotification('No hay jugadores cerca')

            end

        else
            print("Error en el codigo")
        end
    end, function(data, menu) menu.close() end)
end

Variado = function()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'otros', {
        title = 'Opciones variadas',
        align = Config.Alineacion,
        elements = {
            {label = 'Activar/Desactivar graficos', value = 'graf'},
            {label = 'Resetear pj', value = 'pj'}, 
            {label = 'Gps Rápido', value = 'gps'},
            {label = '<span style = color:red; span>Cerrar</span>', value = 'cerrar'}
        }}, function(data, menu)
            local action = data.current.value 
            if action == 'graf' then
                if not graf then
                    graf = true
                    SetTimecycleModifier('MP_Powerplay_blend')
                    SetExtraTimecycleModifier('reflection_correct_ambient')
                    ESX.ShowNotification('~g~Graficos activados')
                else
                    graf = false
                    ClearTimecycleModifier()
                    ClearExtraTimecycleModifier()
                    ESX.ShowNotification('~r~Graficos desactivados')
                end
            elseif action == 'pj' then
                ExecuteCommand('fixpj')
            elseif action == 'gps' then
                GPS()
            elseif action == 'cerrar' then
                ESX.UI.Menu.CloseAll()
            end
        end, function(data, menu)
            menu.close()
    end)
end

-- Fix Pj Command

RegisterCommand('fixpj', function()
    local hp = GetEntityHealth(PlayerPedId())
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
        local isMale = skin.sex == 0
        TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
                TriggerEvent('esx:restoreLoadout')
                TriggerEvent('dpc:ApplyClothing')
                SetEntityHealth(PlayerPedId(), hp)
            end)
        end)
    end)
end, false)

-- End Fix Pj Command

-- GPS Rapido

GPS = function()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gps',{
        title = 'GPS Rápido',
		    align = Config.Alineacion,
		    elements = {
			  {label = 'Garage Cental', value = 'garajeea'},
			  {label = 'Comisaria', value = 'comisaria'}, 
			  {label = 'Hospital', value = 'hospital'}, 
			  {label = 'Concesionario', value = 'conce'},
			  {label = 'Mecánico', value = 'mecanico'},	
		 }
  },
	function(data, menu)
		local gpsrapido = data.current.value
		
		if gpsrapido == 'garajeea' then
			SetNewWaypoint(215.12, -815.74)
            ESX.UI.Menu.CloseAll()
		elseif gpsrapido == 'comisaria' then 
			SetNewWaypoint(411.28, -978.73)
            ESX.UI.Menu.CloseAll()
		elseif gpsrapido == 'hospital' then 
			SetNewWaypoint(291.37, -581.63)
            ESX.UI.Menu.CloseAll()
        elseif gpsrapido == 'conce' then
			SetNewWaypoint(-33.78, -1102.12)
            ESX.UI.Menu.CloseAll()
		elseif gpsrapido == 'mecanico' then
			SetNewWaypoint(-359.59, -133.44)
            ESX.UI.Menu.CloseAll()
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

-- Fin Gps Rapido

-- Command Open Menu

RegisterCommand('PersonalMenu', function(source)
    openMenu()
end)

-- End Command Open Menu

-- KEY CONTROL

RegisterKeyMapping("PersonalMenu", "Abrir menu personal", "keyboard", "F5")
