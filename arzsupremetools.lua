local imgui = require("imgui")
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local sampev = require 'lib.samp.events'
require 'lib.sampfuncs'
local sw, sh = getScreenResolution()
local menu = imgui.ImBool(false)
local slet = imgui.ImBool(false)
local report = imgui.ImBool(false)
local tpreport = imgui.ImBool(false)
local vzaim = imgui.ImBool(false)
local inicfg = require("inicfg")
local d = require 'imgui_addons'
local font_flag = require('moonloader').font_flag
local font = renderCreateFont('Verdana', 10, font_flag.BOLD + font_flag.SHADOW)
local dlstatus = require('moonloader').download_status
local script_vers = 1.0
local script_vers_text = "v1.0" -- Название нашей версии. В будущем будем её выводить ползователю.
local update_url = 'https://raw.githubusercontent.com/NeilAvgust/auto-update/main/update.ini' -- Путь к ini файлу. Позже нам понадобиться.
local update_path = getWorkingDirectory() .. "/update.ini"
local script_url = 'https://github.com/NeilAvgust/auto-update/blob/main/arzsupremetools.luac?raw=true' -- Путь скрипту.
local script_path = thisScript().path
----
filename_ini = "ToolsSupreme/settings.ini"
ini = {
    adm = {
    autologin  = false,
    autoapanel = false,
    anticheat = false,
    recon = false,
    spawnaz = false,
    autoopra = false,
    proverka = true,
    password = '',
    apanel = ''
    }
	}
	ini = inicfg.load(ini, filename_ini)
----
autologin = imgui.ImBool(ini.adm.autologin)
proverka = imgui.ImBool(ini.adm.proverka)
jailslet = imgui.ImBool(false)
autoapanel = imgui.ImBool(ini.adm.autoapanel)
spawnaz = imgui.ImBool(ini.adm.spawnaz)
anticheat = imgui.ImBool(ini.adm.anticheat)
autoopra = imgui.ImBool(ini.adm.autoopra)
password = imgui.ImBuffer(u8(ini.adm.password), 256)
apanel = imgui.ImBuffer(u8(ini.adm.apanel), 256)
domslet = imgui.ImBuffer(256)
bizslet = imgui.ImBuffer(256)
otvetrep = imgui.ImBuffer(256)
tpbiz = imgui.ImBuffer(256)
tphouse = imgui.ImBuffer(256)
local nosave = imgui.ImInt(0)
local savelocal = imgui.ImInt(0)
local savebd = imgui.ImInt(0)
----

function check_update() -- Создаём функцию которая будет проверять наличие обновлений при запуске скрипта.
    downloadUrlToFile(update_url, update_path, function(id, status)
        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
            updateIni = inicfg.load(nil, update_path)
            if tonumber(updateIni.info.vers) > script_vers then -- Сверяем версию в скрипте и в ini файле на github
                sampAddChatMessage("{FFFFFF}Имеется {32CD32}новая {FFFFFF}версия скрипта. Версия: {32CD32}"..updateIni.info.vers_text..". {FFFFFF}/update что-бы обновить", 0xFF0000) -- Сообщаем о новой версии.
                update_found = true -- если обновление найдено, ставим переменной значение true
            end
            os.remove(update_path)
        end
    end)
end


function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end 
    local ip, port = sampGetCurrentServerAddress()
    if ip ~= '176.32.37.28' then thisScript():unload() end
    sampRegisterChatCommand('info',function()
    x,y,z = getCharCoordinates(PLAYER_PED)
    print(x..', '..y..' , '..z)
    end)
    sampRegisterChatCommand('gtcar', function()
    if chislo == nil or chislo == '%d+' then
    sampAddChatMessage('В репорте не было найдено айди ТС!',-1)
    else
        sampSendChat('/getherecar '..chislo)
    end
    end)
    sampRegisterChatCommand('slet',function()
        slet.v = not slet.v
    end)
    sampRegisterChatCommand('smenu',function()
    menu.v = not menu.v 
   end)
   check_update()

   if update_found then -- Если найдено обновление, регистрируем команду /update.
       sampRegisterChatCommand('update', function()  -- Если пользователь напишет команду, начнётся обновление.
           update_state = true -- Если человек пропишет /update, скрипт обновится.
       end)
   else
       sampAddChatMessage('{FFFFFF}Нету доступных обновлений!',-1)
   end

  while true do
      wait(0)
      if isKeyDown(18) and isKeyJustPressed(49) then
       sampSendChat('/ot')
      end
      if isKeyJustPressed(221) then
        sampSetChatInputEnabled(true)
        sampSetChatInputText("/getherecar ")
      end
      imgui.Process = menu.v or slet.v or report.v  or tpreport.v or vzaim.v
end
end
  
  function imgui.OnDrawFrame() 
      if menu.v then 
                          imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                          imgui.SetNextWindowSize(imgui.ImVec2(500, 400), imgui.Cond.FirstUseEver)
                          imgui.Begin('SupremeTools', menu, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
                          imgui.Text(u8'Авто-Логин: ') imgui.SetCursorPos(imgui.ImVec2(130,30)) if d.ToggleButton('##1', autologin) then ini.adm.autologin = autologin.v inicfg.save(ini,filename_ini) end imgui.SameLine() if imgui.NewInputText('##Password', password, 100, u8'Пароль', 2) then ini.adm.password = password.v inicfg.save(ini,filename_ini) end
                          imgui.Text(u8'Авто-Панель: ') imgui.SetCursorPos(imgui.ImVec2(130,55)) if d.ToggleButton('##2', autoapanel)then ini.adm.autoapanel = autoapanel.v inicfg.save(ini,filename_ini) end imgui.SameLine() if imgui.NewInputText('##Apanel', apanel, 100, u8'Админ-Пароль', 2) then ini.adm.apanel = apanel.v inicfg.save(ini,filename_ini) end
                          imgui.Text(u8'Скрыть Анти-Чит: ') imgui.SetCursorPos(imgui.ImVec2(130,80)) if d.ToggleButton('##4', anticheat)then ini.adm.anticheat = anticheat.v inicfg.save(ini,filename_ini) end imgui.SameLine() imgui.TextQuestion("(?)", u8"Убирает строки, о предупреждении о читерстве.")
                          imgui.Text(u8'Спавниться в AZ: ') imgui.SetCursorPos(imgui.ImVec2(130,105)) if d.ToggleButton('##5', spawnaz)then ini.adm.spawnaz = spawnaz.v inicfg.save(ini,filename_ini) end imgui.SameLine() imgui.TextQuestion("(?)", u8"При заходе на сервер, спавниться в Админ-Зоне.")
                          imgui.Text(u8'Авто-Опра: ') imgui.SetCursorPos(imgui.ImVec2(130,130)) if d.ToggleButton('##6', autoopra)then ini.adm.autoopra = autoopra.v inicfg.save(ini,filename_ini) end imgui.SameLine() imgui.TextQuestion("(?)", u8"Автоматически садить игроков в Деморган за Опру Дома/Бизнеса\n Советую включать перед PayDay.")
                         imgui.End()
                         end 
                         if slet.v then
                            imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                            imgui.SetNextWindowSize(imgui.ImVec2(230, 100), imgui.Cond.FirstUseEver)
                            imgui.Begin(u8'Хелпер Слётов', slet, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
                            imgui.Text(u8'Сажать за опру дома/бизнеса -') imgui.SameLine()
                            d.ToggleButton('##Slet',jailslet)
                            imgui.Text(u8'Айди Дома') imgui.PushItemWidth(35) imgui.SameLine() imgui.InputText('##Home', domslet) imgui.PopItemWidth() 
                            imgui.Text(u8'Айди Бизнеса') imgui.PushItemWidth(35) imgui.SameLine() imgui.InputText('##Biz', bizslet) imgui.PopItemWidth()           
                            imgui.End()
                         end
                         if report.v then
                            imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                            imgui.SetNextWindowSize(imgui.ImVec2(370, 230), imgui.Cond.FirstUseEver)
                            imgui.Begin(u8'Жалоба/Вопрос', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
                            imgui.Text(u8'Жалоба от: '..nick_rep..'['..id_rep..']') imgui.SameLine()
                            if imgui.Link(u8"<<Следить") then
                                sampSendChat('/re '..id_rep)
                            end
                            imgui.Separator()
                            imgui.TextWrapped(u8(text_rep))
                            imgui.Separator()
                            imgui.RadioButton(u8'Не сохранять',nosave,1) imgui.SameLine() imgui.RadioButton(u8'Сохранить локально',savelocal,2)
                            imgui.Separator()
                            imgui.PushItemWidth(350) imgui.InputText('##OtvetRep', otvetrep) imgui.PopItemWidth()
                            imgui.Separator()
                            if  imgui.Button(u8'Слежу за наруш', imgui.ImVec2(115, 20)) then
                            if text_rep:find('(%d+)') then
                            chislo = text_rep:match('(%d+)')
                            end
                            sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, слежу за нарушителем!')
                            if chislo then
                            sampSendChat('/re '..chislo) 
                            end
                            report.v = false
                            otvetrep.v = ''
                            end imgui.SameLine()
                            if imgui.Button(u8'Помочь автору', imgui.ImVec2(115, 20)) then
                            sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас попробую вам помочь!')
                            sampSendChat('/re '..id_rep)
                            report.v = false
                            otvetrep.v = ''
                            end imgui.SameLine()
                            if imgui.Button(u8'Переслать в /a чат', imgui.ImVec2(115, 20)) then
                            sampSendChat('/a Жалоба/Вопрос от: '..nick_rep..'['..id_rep..'] > '..text_rep)
                            end
                            if imgui.Button(u8'Взаимодействия', imgui.ImVec2(115, 20)) then 
                                vzaim.v = not vzaim.v
                            end imgui.SameLine() 
                            if imgui.Button(u8'Тп игрока', imgui.ImVec2(115, 20)) then 
                                tpreport.v = not tpreport.v
                            end imgui.SameLine()
                            if imgui.Button(u8'Тп Дом', imgui.ImVec2(115, 20)) then
                                lua_thread.create(function()
                                if text_rep:find('(%d+)') then
                                    chislo = text_rep:match('(%d+)')
                                    end
                                    sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас телепортирую!')
                                    if chislo then
                                    sampSendChat('/gotohouse '..chislo)
                                    wait(1000)
                                    sampSendChat('/gethere '..id_rep)
                                    end
                                    end)
                                    report.v = false
                                    otvetrep.v = ''
                            end imgui.SameLine()
                            imgui.Button(u8'', imgui.ImVec2(115, 20)) 
                            if imgui.Button(u8'Тп Биз', imgui.ImVec2(115, 20)) then 
                                lua_thread.create(function()
                                if text_rep:find('(%d+)') then
                                    chislo = text_rep:match('(%d+)')
                                    end
                                    sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас телепортирую!')
                                    if chislo then
                                    sampSendChat('/gotobiz '..chislo)
                                    wait(1000)
                                    sampSendChat('/gethere '..id_rep)
                                    end
                                    end)
                                    report.v = false
                                    otvetrep.v = ''
                            end imgui.SameLine()
                            imgui.Button(u8'', imgui.ImVec2(115, 20)) imgui.SameLine()
                            if imgui.Button(u8'Передать адм реп', imgui.ImVec2(115, 20)) then
                            sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, передал репорт другому администратору!')  
                            sampSendChat('/a Жалоба/Вопрос от: '..nick_rep..'['..id_rep..'] > '..text_rep)
                            report.v = false
                            otvetrep.v = ''
                            end
                            imgui.Separator()
                            if imgui.Button(u8'Отправить', imgui.ImVec2(115, 20)) then
                            sampSendDialogResponse(6370,1,nil,(u8:decode(otvetrep.v)))
                            report.v = false
                            otvetrep.v = ''
                            end
                            imgui.SetCursorPos(imgui.ImVec2(250,203)) if imgui.Button(u8'Закрыть', imgui.ImVec2(115, 20))  then
                            sampSendDialogResponse(6370,2,nil,nil)
                            otvetrep.v = false
                            end
                            imgui.End()
                         end
                         if tpreport.v then
                         imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                         imgui.SetNextWindowSize(imgui.ImVec2(200, 500), imgui.Cond.FirstUseEver)
                         imgui.Begin('TELEPORT', tpreport, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
                         if imgui.Button(u8'Банк ЛС', imgui.ImVec2(180, 20))  then
                         lua_thread.create(function()
                         sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас телепортирую!')
                         report.v = false
                         otvetrep.v = ''
                         setCharCoordinates(PLAYER_PED,1480.8314208984, -1740.7347412109 , 13.5468755)
                         wait(1000)
                         sampSendChat('/gethere '..id_rep)
                         tpreport.v = false
                         end)
                         end
                         if imgui.Button(u8'Мастерская Одежды', imgui.ImVec2(180, 20))  then 
                        lua_thread.create(function()
                        sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас телепортирую!')
                        report.v = false
                        otvetrep.v = ''
                        setCharCoordinates(PLAYER_PED,673.20123291016, -522.30450439453 , 16.328144073486)
                        wait(1000)
                        sampSendChat('/gethere '..id_rep)
                        tpreport.v = false
                         end)
                         end
                         if imgui.Button(u8'Авто-Базар', imgui.ImVec2(180, 20)) then
                         lua_thread.create(function()
                        sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас телепортирую!')
                        report.v = false
                        otvetrep.v = ''
                        setCharCoordinates(PLAYER_PED,-2142.2543945313, -766.55065917969 , 32.0234375)
                        wait(1000)
                        sampSendChat('/gethere '..id_rep)
                        tpreport.v = false
                         end)
                         end
                         if imgui.Button(u8'Банк ЛВ', imgui.ImVec2(180, 20)) then
                            lua_thread.create(function()
                           sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас телепортирую!')
                           report.v = false
                           otvetrep.v = ''
                           setCharCoordinates(PLAYER_PED,2375.4228515625, 2309.8149414063 , 8.140625)
                           wait(1000)
                           sampSendChat('/gethere '..id_rep)
                           tpreport.v = false
                            end)
                            end
                            if imgui.Button(u8'Контейнеры', imgui.ImVec2(180, 20)) then
                                lua_thread.create(function()
                               sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас телепортирую!')
                               report.v = false
                               otvetrep.v = ''
                               setCharCoordinates(PLAYER_PED,-1744.9382324219, 148.69653320313 , 3.5495557785034)
                               wait(1000)
                               sampSendChat('/gethere '..id_rep)
                               tpreport.v = false
                                end)
                                end
                                if imgui.Button(u8'Мерия', imgui.ImVec2(180, 20)) then
                                    lua_thread.create(function()
                                   sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас телепортирую!')
                                   report.v = false
                                   otvetrep.v = ''
                                   setCharCoordinates(PLAYER_PED,1495.6651611328, -1284.7728271484 , 14.516803741455)
                                   wait(1000)
                                   sampSendChat('/gethere '..id_rep)
                                   tpreport.v = false
                                    end)
                                    end
                                    if imgui.Button(u8'Авто-Салон СФ', imgui.ImVec2(180, 20)) then
                                        lua_thread.create(function()
                                       sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас телепортирую!')
                                       report.v = false
                                       otvetrep.v = ''
                                       setCharCoordinates(PLAYER_PED,-2671.8869628906, -23.813611984253 , 4.3267498016357)
                                       wait(1000)
                                       sampSendChat('/gethere '..id_rep)
                                       tpreport.v = false
                                        end)
                                        end
                                        if imgui.Button(u8'Авто-Салон ЛВ', imgui.ImVec2(180, 20)) then
                                            lua_thread.create(function()
                                           sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас телепортирую!')
                                           report.v = false
                                           otvetrep.v = ''
                                           setCharCoordinates(PLAYER_PED,971.7216796875, 2118.4558105469 , 10.83930015564)
                                           wait(1000)
                                           sampSendChat('/gethere '..id_rep)
                                           tpreport.v = false
                                            end)
                                            end
                                            if imgui.Button(u8'Авто-Салон ЛЮКС', imgui.ImVec2(180, 20)) then
                                                lua_thread.create(function()
                                               sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас телепортирую!')
                                               report.v = false
                                               otvetrep.v = ''
                                               setCharCoordinates(PLAYER_PED,-507.44470214844, 2592.9772949219 , 53.415424346924)
                                               wait(1000)
                                               sampSendChat('/gethere '..id_rep)
                                               tpreport.v = false
                                                end)
                                                end
                                                if imgui.Button(u8'Нелегалки', imgui.ImVec2(180, 20)) then
                                                    lua_thread.create(function()
                                                   sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас телепортирую!')
                                                   report.v = false
                                                   otvetrep.v = ''
                                                   setCharCoordinates(PLAYER_PED, -2463.3388671875, 2247.4084472656 , 4.7928237915039)
                                                   wait(1000)
                                                   sampSendChat('/gethere '..id_rep)
                                                   tpreport.v = false
                                                    end)
                                                    end
                         imgui.End()
                        end
                        if vzaim.v then
                            imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
                            imgui.SetNextWindowSize(imgui.ImVec2(200, 450), imgui.Cond.FirstUseEver)
                            imgui.Begin(u8'Взаимодействия с игроком', vzaim, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)
                            if imgui.Button(u8'Заспавнить игрока', imgui.ImVec2(180, 20)) then
                                sampSendChat('/spplayer '..id_rep)
                                sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, заспавнил вас!')
                                report.v = false
                                otvetrep.v = ''
                                vzaim.v = false
                            end
                            if imgui.Button(u8'Выдать ХП', imgui.ImVec2(180, 20)) then
                                sampSendChat('/sethp  '..id_rep..' 100')
                                sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, выдал вам хп!')
                                report.v = false
                                otvetrep.v = ''
                                vzaim.v = false
                            end
                            if imgui.Button(u8'Флипнуть', imgui.ImVec2(180, 20)) then
                                sampSendChat('/flip '..id_rep)
                                sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, флипнул вас!')
                                report.v = false
                                otvetrep.v = ''
                                vzaim.v = false
                            end
                            if imgui.Button(u8'Выдать NRG', imgui.ImVec2(180, 20)) then
                                sampSendChat('/plveh '..id_rep..' 522 1')
                                sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, выдал вам ТС!')
                                report.v = false
                                otvetrep.v = ''
                                vzaim.v = false
                            end
                            if imgui.Button(u8'ТП к Игроку', imgui.ImVec2(180, 20)) then
                                sampSendChat('/goto '..id_rep)
                                sampSendDialogResponse(6370,1,nil,'Уважаемый игрок, сейчас попробую вам помочь!')
                                report.v = false
                                otvetrep.v = ''
                                vzaim.v = false
                            end
                            imgui.End()
                        end
                    end

                    --1480.8314208984, -1740.7347412109 , 13.546875 - BANK
                    --673.20123291016, -522.30450439453 , 16.328144073486 - Мастрерская Одежды
                    --1125.4593505859, -1406.9426269531 , 13.433320045471 - ЦР
                    ----2141.66796875, -759.49615478516 , 32.0234375 - AB
                    --2375.4228515625, 2309.8149414063 , 8.140625 - BANK LV
                    ---507.44470214844, 2592.9772949219 , 53.415424346924 -- LUXE
                    ---2671.8869628906, -23.813611984253 , 4.3267498016357 - SF Salon
                    -- 971.7216796875, 2118.4558105469 , 10.83930015564 - LV SALON
                    --1495.6651611328, -1284.7728271484 , 14.516803741455 meriya
                    ---1744.9382324219, 148.69653320313 , 3.5495557785034 kont

                        --if text_rep:find('(%d+)') then
                            --chislo = text_rep:match('(%d+)')
                            --print(chislo)
                        --end
                        

              function sampev.onShowDialog(id, style, title, button1, button2, text)
              if id == 6377 then
              sampSendDialogResponse(6377,1,0,nil)
              return false
              end
              if autologin.v and id == 2 then
              sampSendDialogResponse(2,1,nil,password.v)
              return false
              end
              if autoapanel.v and id == 211 then
              sampSendDialogResponse(211,1,nil,apanel.v)
              return false
              end
              if id == 6370 then
              report.v = true
              if text:find('Жалоба/Вопрос от: (.+)%[(.+)%]') then
              nick_rep,id_rep,text_rep = text:match('Жалоба/Вопрос от: (.+)%[(.+)%]')
              end
              if text:find('%{c8e464%}(.+)%s+') then
              text_rep = text:match('%{c8e464%}(.+)%s+')
              return false
              end
              end
              end

              function sampev.onServerMessage(color, text)
              if text:find('%[KANTI%-CHEAT%] .+') and anticheat.v then
              return false
              end
              if text:find('%[A%] Вы успешно авторизовались как (.+)') and spawnaz.v then
              sampSendChat('/az')
              end
              if text:find('.+ %[(%d+)%] купил дом ID: (%d+) по гос. цене за (.+) ms! Капча: (.+)') and autoopra.v then -- Jail за все дома
              id,iddom,vrema = text:match('.+ %[(%d+)%] купил дом ID: (%d+) по гос. цене за (.+) ms! Капча: (.+)')
              sampSendChat('/jail '..id..' 3000 Опра Дом '..iddom..' | '..vrema)
              end
              if text:find('.+ %[(%d+)%] купил дом ID: '..domslet.v..' по гос. цене за (.+) ms! Капча: .+') and jailslet.v then -- Jail за определённый дом
                idd,vremasl = text:match('.+ %[(%d+)%] купил дом ID: '..domslet.v..' по гос. цене за (.+) ms! Капча: .+')
                sampSendChat('/jail '..idd..' 3000 Опра Дом '..domslet.v..' | '..vremasl)
              end
              if text:find('.+ %[(%d+)%] купил бизнес ID: (%d+) по гос. цене за (.+) ms! Капча: .+')  and autoopra.v then
              idplb,idb,ms = text:match('.+ %[(%d+)%] купил бизнес ID: (%d+) по гос. цене за (.+) ms! Капча: .+')
              sampSendChat('/jail '..idplb..' 3000 Опра Бизнес '..idb..' | '..ms)
              end
              if text:find('.+ %[(%d+)%] купил бизнес ID: '..bizslet.v..' по гос. цене за (.+) ms! Капча: .+') and jailslet.v then
                idsll,mss = text:match('.+ %[(%d+)%] купил бизнес ID: '..bizslet.v..' по гос. цене за (.+) ms! Капча: .+')
                sampSendChat('/jail '..idsll..' 3000 Опра Бизнес '..bizslet.v..' | '..mss)
            end
        end

              function theme()
                  imgui.SwitchContext()
                  local style = imgui.GetStyle()
                  local colors = style.Colors
                  local clr = imgui.Col
                  local ImVec4 = imgui.ImVec4
                  local ImVec2 = imgui.ImVec2
              
                  style.WindowPadding = imgui.ImVec2(8, 8)
                  style.WindowRounding = 6
                  style.ChildWindowRounding = 5
                  style.FramePadding = imgui.ImVec2(5, 3)
                  style.FrameRounding = 3.0
                  style.ItemSpacing = imgui.ImVec2(5, 4)
                  style.ItemInnerSpacing = imgui.ImVec2(4, 4)
                  style.IndentSpacing = 21
                  style.ScrollbarSize = 10.0
                  style.ScrollbarRounding = 13
                  style.GrabMinSize = 8
                  style.GrabRounding = 1
                  style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
                  style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
              
                  colors[clr.Text]                   = ImVec4(0.95, 0.96, 0.98, 1.00);
                  colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00);
                  colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 1.00);
                  colors[clr.ChildWindowBg]          = ImVec4(0.12, 0.12, 0.12, 1.00);
                  colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94);
                  colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00);
                  colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.10);
                  colors[clr.FrameBg]                = ImVec4(0.22, 0.22, 0.22, 1.00);
                  colors[clr.FrameBgHovered]         = ImVec4(0.18, 0.18, 0.18, 1.00);
                  colors[clr.FrameBgActive]          = ImVec4(0.09, 0.12, 0.14, 1.00);
                  colors[clr.TitleBg]                = ImVec4(0.14, 0.14, 0.14, 0.81);
                  colors[clr.TitleBgActive]          = ImVec4(0.14, 0.14, 0.14, 1.00);
                  colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51);
                  colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00);
                  colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39);
                  colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00);
                  colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00);
                  colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00);
                  colors[clr.ComboBg]                = ImVec4(0.24, 0.24, 0.24, 1.00);
                  colors[clr.CheckMark]              = ImVec4(1.00, 0.28, 0.28, 1.00);
                  colors[clr.SliderGrab]             = ImVec4(1.00, 0.28, 0.28, 1.00);
                  colors[clr.SliderGrabActive]       = ImVec4(1.00, 0.28, 0.28, 1.00);
                  colors[clr.Button]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
                  colors[clr.ButtonHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
                  colors[clr.ButtonActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
                  colors[clr.Header]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
                  colors[clr.HeaderHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
                  colors[clr.HeaderActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
                  colors[clr.ResizeGrip]             = ImVec4(1.00, 0.28, 0.28, 1.00);
                  colors[clr.ResizeGripHovered]      = ImVec4(1.00, 0.39, 0.39, 1.00);
                  colors[clr.ResizeGripActive]       = ImVec4(1.00, 0.19, 0.19, 1.00);
                  colors[clr.CloseButton]            = ImVec4(0.40, 0.39, 0.38, 0.16);
                  colors[clr.CloseButtonHovered]     = ImVec4(0.40, 0.39, 0.38, 0.39);
                  colors[clr.CloseButtonActive]      = ImVec4(0.40, 0.39, 0.38, 1.00);
                  colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
                  colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00);
                  colors[clr.PlotHistogram]          = ImVec4(1.00, 0.21, 0.21, 1.00);
                  colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.18, 0.18, 1.00);
                  colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.32, 0.32, 1.00);
                  colors[clr.ModalWindowDarkening]   = ImVec4(0.26, 0.26, 0.26, 0.60);
              end
              theme()

              function imgui.NewInputText(lable, val, width, hint, hintpos)
                local hint = hint and hint or ''
                local hintpos = tonumber(hintpos) and tonumber(hintpos) or 1
                local cPos = imgui.GetCursorPos()
                imgui.PushItemWidth(width)
                local result = imgui.InputText(lable, val)
                if #val.v == 0 then
                    local hintSize = imgui.CalcTextSize(hint)
                    if hintpos == 2 then imgui.SameLine(cPos.x + (width - hintSize.x) / 2)
                    elseif hintpos == 3 then imgui.SameLine(cPos.x + (width - hintSize.x - 5))
                    else imgui.SameLine(cPos.x + 5) end
                    imgui.TextColored(imgui.ImVec4(1.00, 1.00, 1.00, 0.40), tostring(hint))
                end
                imgui.PopItemWidth()
                return result
            end

            function imgui.TextQuestion(label, description)
                imgui.TextDisabled(label)
            
                if imgui.IsItemHovered() then
                    imgui.BeginTooltip()
                        imgui.PushTextWrapPos(600)
                            imgui.TextUnformatted(description)
                        imgui.PopTextWrapPos()
                    imgui.EndTooltip()
                end
            end

            function onSendRpc(id,bitStream,priority,reliability,orderingChannel,shiftTs)
                if id == RPC_SPAWN and proverka.v == true then
                if autoapanel.v then
                    sampSendChat('/apanel')
                    proverka.v = false
                end
                end  
                end

                function imgui.Link(label, description)

                    local size = imgui.CalcTextSize(label)
                    local p = imgui.GetCursorScreenPos()
                    local p2 = imgui.GetCursorPos()
                    local result = imgui.InvisibleButton(label, size)
                
                    imgui.SetCursorPos(p2)
                
                    if imgui.IsItemHovered() then
                        if description then
                            imgui.BeginTooltip()
                            imgui.PushTextWrapPos(600)
                            imgui.TextUnformatted(description)
                            imgui.PopTextWrapPos()
                            imgui.EndTooltip()
                
                        end
                
                        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.CheckMark], label)
                        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.CheckMark]))
                
                    else
                        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.CheckMark], label)
                    end
                
                    return result
                end




