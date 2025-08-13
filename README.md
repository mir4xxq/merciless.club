# Loadstring: | Строки запуска:

```lua
printidentity()
getgenv().LicenseKey = "" -- put your license key there

loadstring(game:HttpGet("https://raw.githubusercontent.com/nox1fy/merciless.club/refs/heads/main/main.lua", true))()
```


## Сhangelogs: | Изменения:

### Beta - V1:

```
ENG:
[$] Global Changes
    [+] New and fully rewriten library of User Interface

[$] Rage Tab Changes
    [+] Added Bullet Redirection
        [+] Hitchance
        [+] Show Hitlogs
        [+] Show FOV
            [+] Fill Transperency
            [+] Follow Target
            [+] Radius
            [+] Rotate FOV Gradient
            [+] FOV Type
                [+] Circle
                [+] Square
            [+] FOV Thickness
        [+] Hitpart Picker
    [+] Added Gun Modifications
        [+] Infinite Ammo
        [+] No Recoil
        [+] Rapid Fire
    [+] Added Ignore Armor
    [-] Removed Invisible Exploit
        [#] Reason: Invisible Exploit turned out to be a complete flop, the same functionality can be done using Anti-Aim.


[$] Visuals Tab Changes
    [+] Added ability to change labels position on ESP
    [+] Added Target ESP
        [+] Animation
        [+] Rotate Gradient
        [+] Type
            [+] Expensive Client
            [+] Nursultan Client
            [+] Svaston
    [+] Added Target Info
        [+] X Scale
        [+] X Offset
        [+] Y Scale
        [+] Y Offset
    [-] Removed Team Color
        [#] Reason: Team Color is simply not needed until I make the ESP interact with the Player List.

[$] Misc Tab Changes
    [+] Added Bunnyhop
    [+] Added Flyhack
        [+] Amount
    [+] Added Chat Spam
        [+] Delay
        [+] Type
        [+] Language
            [+] English
            [+] Russian
        [+] Multiple
        [+] Emojis
    [+] Added ability to disable vignette while aiming in-game
    [+] Added Hitsounds
        [+] Hit in armour
            [+] Volume
        [+] Hit in body
            [+] Volume
        [+] Killsound
            [+] Volume
        [#] All Available Sounds
            [+] default  
            [+] neverlose  
            [+] gamesense  
            [+] 1 sit nn dog  
            [+] bell  
            [+] rust headshot  
            [+] tf2  
            [+] slime  
            [+] among us  
            [+] minecraft  
            [+] csgo headshot  
            [+] saber  
            [+] baimware  
            [+] osu  
            [+] tf2 critical  
            [+] bat  
            [+] call of duty  
            [+] bubble  
            [+] pick  
            [+] pop  
            [+] bruh  
            [+] bamboo  
            [+] crowbar  
            [+] weeb
            [+] beep
            [+] bambi
            [+] stone
            [+] old fatality
            [+] click
            [+] ding
            [+] snow
            [+] laser
            [+] mario
            [+] steve
            [+] snowdrake

RU:
[$] Глобальные изменения
    [+] Новая и полностью переписанная библиотека пользовательского интерфейса

[$] Изменения во вкладке Rage
    [+] Добавлен Bullet Redirection
        [+] Шанс попадания
        [+] Показывать Hitlogs
        [+] Показывать FOV
            [+] Прозрачность заполнености
            [+] Преследовать цель
            [+] Радиус
            [+] Поворот градиента FOV
            [+] Тип FOV
                [+] Круг
                [+] Квадрат
            [+] Толщина FOV
        [+] Выбор поражающей части тела
    [+] Добавлены модификации оружия
        [+] Бесконечные патроны
        [+] Без отдачи
        [+] Быстрый огонь
    [+] Добавлено игнорирование брони
    [-] Убран Invisible Exploit
        [#] Причина: Invisible Exploit оказался полной шляпой, тот же функционал можно реализовать с помощью Anti-Aim.


[$] Изменения во вкладке Visuals
    [+] Добавлена возможность изменять положение текста в ESP
    [+] Добавлен ESP Цели
        [+] Анимация
        [+] Поворот градиента
        [+] Type
            [+] Expensive Client
            [+] Nursultan Client
            [+] Svaston
    [+] Добавлена Информация о Цели
        [+] Масштаб
            [+] по X
            [+] по Y
        [+] Смещение
            [+] по X
            [+] по Y
    [-] Убраны Team Color
        [#] Reason: Team Color попросто не нужен, пока я не добавлю возможность взаимодействовать ESP со списком игроков.

[$] Misc Tab Changes
    [+] Добавлен Баннихоп
    [+] Добавлен Flyhack
        [+] Множитель
    [+] Добавлен Спам в чат
        [+] Задержка
        [+] Тип
        [+] Язык
            [+] Английский
            [+] Русский
        [+] Множественный
        [+] Эмодзи
    [+] Добавлена возможность отключать виньетку когда целишься с оружия
    [+] Добавлены Hitsounds
        [+] Попадение в броню
            [+] Громкость
        [+] Попадение в одну из частей тела
            [+] Громкость
        [+] Killsound
            [+] Громкость
        [#] Все доступные звуки
            [+] default  
            [+] neverlose  
            [+] gamesense  
            [+] 1 sit nn dog  
            [+] bell  
            [+] rust headshot  
            [+] tf2  
            [+] slime  
            [+] among us  
            [+] minecraft  
            [+] csgo headshot  
            [+] saber  
            [+] baimware  
            [+] osu  
            [+] tf2 critical  
            [+] bat  
            [+] call of duty  
            [+] bubble  
            [+] pick  
            [+] pop  
            [+] bruh  
            [+] bamboo  
            [+] crowbar  
            [+] weeb
            [+] beep
            [+] bambi
            [+] stone
            [+] old fatality
            [+] click
            [+] ding
            [+] snow
            [+] laser
            [+] mario
            [+] steve
            [+] snowdrake
```

### Beta - V0.3:

```
ENG:
[+] Added the function of changing the color of ESP elements to the color of the player team (Team Color)
[+] Added Anti-Aim
    [+] Custom
        [+] Custom X
        [+] Custom Y
        [+] Custom Z
    [+] Random
        [+] Random Range
    [+] Strafe
        [+] Strafe Speed
        [+] Strafe Distance
        [+] Strafe Height
[+] Added Network Massive Tag
    [+] Walking Check
    [+] Amount
[+] Added Speedhack (CFrame Speed)
    [+] Amount
[+] Added Invisible Exploit
    [+] Spoof Position
    [+] Massive Spoof
[+] Added Teleport (list of locations will be supplemented)
    [+] CoR Base
[+] The authorization system is fully rewritten
[~] Small changes in UI (again)
[~] Fixes of bugs with binds, color pickers and other UI elements

RU:
[+] Добавлена функция изменения цвета элементов ESP на цвет команды игроков (Team Color)
[+] Добавлен Anti-Aim
    [+] Custom
        [+] Custom X
        [+] Custom Y
        [+] Custom Z
    [+] Random
        [+] Random Range
    [+] Strafe
        [+] Strafe Speed
        [+] Strafe Distance
        [+] Strafe Height
[+] Добавлен Network Massive Tag
    [+] Walking Check
    [+] Amount
[+] Добавлен Speedhack (CFrame Speed)
    [+] Amount
[+] Добавлен Invisible Exploit
    [+] Spoof Position
    [+] Massive Spoof
[+] Добавлен Teleport (список локаций будет дополнятся)
    [+] CoR Base
[+] Полностью переписана система авторизации
[~] Мелкие изменения в пользовательском интерфейсе (опять)
[~] Фиксы багов с биндами, средствами выбора цвета и другими элементами пользовательского интерфейса
```

### Beta - V0.2:
```
ENG:
[~] Fixed some colors that didnt work at visuals tab
[~] Small ui changes

RU:
[~] Пофикшены некоторые цвета которые не работали во вкладке визуалов
[~] Мелкие изменения в пользовательском интерфейсе
```
