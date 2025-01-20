--[[

        впервые вижу таких наглых людей, которые хотят спиздить мой код

]]

local License = "KEYAUTH-quantum.wtf-developer-license"

if (not LPH_OBFUSCATED) then
    LPH_NO_VIRTUALIZE = function(...) return (...) end;
end

local players = game.Players;
local localPlayer = players.LocalPlayer;
local CurrentCamera = game.Workspace.CurrentCamera;
local TweenService = game.TweenService;
local UIS = game.UserInputService;
local mouseLocation = UIS.GetMouseLocation;
local CoreGui = game:FindFirstChild("CoreGui");

do
    --// Library
    do
        function LibraryLoadstring()
            local InputService = game:GetService('UserInputService');
            local TextService = game:GetService('TextService');
            local CoreGui = game:GetService('CoreGui');
            local Teams = game:GetService('Teams');
            local Players = game:GetService('Players');
            local RunService = game:GetService('RunService')
            local TweenService = game:GetService('TweenService');
            local RenderStepped = RunService.RenderStepped;
            local LocalPlayer = Players.LocalPlayer;
            local Mouse = LocalPlayer:GetMouse();

            local ProtectGui = protectgui or (syn and syn.protect_gui) or (function() end);

            local ScreenGui = Instance.new('ScreenGui');
            ProtectGui(ScreenGui);

            ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
            ScreenGui.Parent = CoreGui;

            local Toggles = {};
            local Options = {};

            getgenv().Toggles = Toggles;
            getgenv().Options = Options;

            local Library = {
                Registry = {};
                RegistryMap = {};

                HudRegistry = {};

                FontColor = Color3.fromRGB(255, 255, 255);
                MainColor = Color3.fromRGB(28, 28, 28);
                BackgroundColor = Color3.fromRGB(20, 20, 20);
                AccentColor = Color3.fromRGB(115, 102, 189);
                OutlineColor = Color3.fromRGB(50, 50, 50);
                RiskColor = Color3.fromRGB(255, 50, 50),
                CursorOutlineColor = Color3.fromRGB(255, 255, 255),
                CursorFillColor = Color3.fromRGB(255, 165, 200),

                Black = Color3.new(0, 0, 0);
                Font = Enum.Font.Code,

                OpenedFrames = {};
                DependencyBoxes = {};

                Signals = {};
                ScreenGui = ScreenGui;
            };

            local RainbowStep = 0
            local Hue = 0

            table.insert(Library.Signals, RenderStepped:Connect(function(Delta)
                RainbowStep = RainbowStep + Delta

                if RainbowStep >= (1 / 60) then
                    RainbowStep = 0

                    Hue = Hue + (1 / 400);

                    if Hue > 1 then
                        Hue = 0;
                    end;

                    Library.CurrentRainbowHue = Hue;
                    Library.CurrentRainbowColor = Color3.fromHSV(Hue, 0.8, 1);
                end
            end))

            local function GetPlayersString()
                local PlayerList = Players:GetPlayers();

                for i = 1, #PlayerList do
                    PlayerList[i] = PlayerList[i].Name;
                end;

                table.sort(PlayerList, function(str1, str2) return str1 < str2 end);

                return PlayerList;
            end;

            local function GetTeamsString()
                local TeamList = Teams:GetTeams();

                for i = 1, #TeamList do
                    TeamList[i] = TeamList[i].Name;
                end;

                table.sort(TeamList, function(str1, str2) return str1 < str2 end);

                return TeamList;
            end;

            function Library:SafeCallback(f, ...)
                if (not f) then
                    return;
                end;

                if not Library.NotifyOnError then
                    return f(...);
                end;

                local success, event = pcall(f, ...);

                if not success then
                    local _, i = event:find(":%d+: ");

                    if not i then
                        return Library:Notify(event);
                    end;

                    return Library:Notify(event:sub(i + 1), 3);
                end;
            end;

            function Library:AttemptSave()
                if Library.SaveManager then
                    Library.SaveManager:Save();
                end;
            end;

            function Library:Create(Class, Properties)
                local _Instance = Class;

                if type(Class) == 'string' then
                    _Instance = Instance.new(Class);
                end;

                for Property, Value in next, Properties do
                    _Instance[Property] = Value;
                end;

                return _Instance;
            end;

            function Library:ApplyTextStroke(Inst)
                Inst.TextStrokeTransparency = 1;

                Library:Create('UIStroke', {
                    Color = Color3.new(0, 0, 0);
                    Thickness = 1;
                    LineJoinMode = Enum.LineJoinMode.Miter;
                    Parent = Inst;
                });
            end;

            function Library:CreateLabel(Properties, IsHud)
                local _Instance = Library:Create('TextLabel', {
                    BackgroundTransparency = 1;
                    Font = Library.Font;
                    TextColor3 = Library.FontColor;
                    TextSize = 14;
                    TextStrokeTransparency = 0;
                });

                Library:ApplyTextStroke(_Instance);

                Library:AddToRegistry(_Instance, {
                    TextColor3 = 'FontColor';
                }, IsHud);

                return Library:Create(_Instance, Properties);
            end;

            function Library:MakeDraggable(Instance, Cutoff)
                Instance.Active = true;

                Instance.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local ObjPos = Vector2.new(
                            Mouse.X - Instance.AbsolutePosition.X,
                            Mouse.Y - Instance.AbsolutePosition.Y
                        );

                        if ObjPos.Y > (Cutoff or 40) then
                            return;
                        end;

                        while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            Instance.Position = UDim2.new(
                                0,
                                Mouse.X - ObjPos.X + (Instance.Size.X.Offset * Instance.AnchorPoint.X),
                                0,
                                Mouse.Y - ObjPos.Y + (Instance.Size.Y.Offset * Instance.AnchorPoint.Y)
                            );

                            RenderStepped:Wait();
                        end;
                    end;
                end)
            end;

            function Library:AddToolTip(InfoStr, HoverInstance)
                local X, Y = Library:GetTextBounds(InfoStr, Library.Font, 14);
                local Tooltip = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor,
                    BorderColor3 = Library.OutlineColor,

                    Size = UDim2.fromOffset(X + 5, Y + 4),
                    ZIndex = 100,
                    Parent = Library.ScreenGui,

                    Visible = false,
                })

                local Label = Library:CreateLabel({
                    Position = UDim2.fromOffset(3, 1),
                    Size = UDim2.fromOffset(X, Y);
                    TextSize = 13;
                    Text = InfoStr,
                    TextColor3 = Library.FontColor,
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = Tooltip.ZIndex + 1,

                    Parent = Tooltip;
                });

                Library:AddToRegistry(Tooltip, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                Library:AddToRegistry(Label, {
                    TextColor3 = 'FontColor',
                });

                local IsHovering = false

                HoverInstance.MouseEnter:Connect(function()
                    if Library:MouseIsOverOpenedFrame() then
                        return
                    end

                    IsHovering = true

                    Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
                    Tooltip.Visible = true

                    while IsHovering do
                        RunService.Heartbeat:Wait()
                        Tooltip.Position = UDim2.fromOffset(Mouse.X + 15, Mouse.Y + 12)
                    end
                end)

                HoverInstance.MouseLeave:Connect(function()
                    IsHovering = false
                    Tooltip.Visible = false
                end)
            end

            function Library:OnHighlight(HighlightInstance, Instance, Properties, PropertiesDefault)
                HighlightInstance.MouseEnter:Connect(function()
                    local Reg = Library.RegistryMap[Instance];

                    for Property, ColorIdx in next, Properties do
                        Instance[Property] = Library[ColorIdx] or ColorIdx;

                        if Reg and Reg.Properties[Property] then
                            Reg.Properties[Property] = ColorIdx;
                        end;
                    end;
                end)

                HighlightInstance.MouseLeave:Connect(function()
                    local Reg = Library.RegistryMap[Instance];

                    for Property, ColorIdx in next, PropertiesDefault do
                        Instance[Property] = Library[ColorIdx] or ColorIdx;

                        if Reg and Reg.Properties[Property] then
                            Reg.Properties[Property] = ColorIdx;
                        end;
                    end;
                end)
            end;

            function Library:MouseIsOverOpenedFrame()
                for Frame, _ in next, Library.OpenedFrames do
                    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

                    if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
                        and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

                        return true;
                    end;
                end;
            end;

            function Library:IsMouseOverFrame(Frame)
                local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

                if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X
                    and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then

                    return true;
                end;
            end;

            function Library:UpdateDependencyBoxes()
                for _, Depbox in next, Library.DependencyBoxes do
                    Depbox:Update();
                end;
            end;

            function Library:MapValue(Value, MinA, MaxA, MinB, MaxB)
                return (1 - ((Value - MinA) / (MaxA - MinA))) * MinB + ((Value - MinA) / (MaxA - MinA)) * MaxB;
            end;

            function Library:GetTextBounds(Text, Font, Size, Resolution)
                local Bounds = TextService:GetTextSize(Text, Size, Font, Resolution or Vector2.new(1920, 1080))
                return Bounds.X, Bounds.Y
            end;

            function Library:GetDarkerColor(Color)
                local H, S, V = Color3.toHSV(Color);
                return Color3.fromHSV(H, S, V / 1.5);
            end;
            Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor);

            function Library:AddToRegistry(Instance, Properties, IsHud)
                local Idx = #Library.Registry + 1;
                local Data = {
                    Instance = Instance;
                    Properties = Properties;
                    Idx = Idx;
                };

                table.insert(Library.Registry, Data);
                Library.RegistryMap[Instance] = Data;

                if IsHud then
                    table.insert(Library.HudRegistry, Data);
                end;
            end;

            function Library:RemoveFromRegistry(Instance)
                local Data = Library.RegistryMap[Instance];

                if Data then
                    for Idx = #Library.Registry, 1, -1 do
                        if Library.Registry[Idx] == Data then
                            table.remove(Library.Registry, Idx);
                        end;
                    end;

                    for Idx = #Library.HudRegistry, 1, -1 do
                        if Library.HudRegistry[Idx] == Data then
                            table.remove(Library.HudRegistry, Idx);
                        end;
                    end;

                    Library.RegistryMap[Instance] = nil;
                end;
            end;

            function Library:UpdateColorsUsingRegistry()
                -- TODO: Could have an 'active' list of objects
                -- where the active list only contains Visible objects.

                -- IMPL: Could setup .Changed events on the AddToRegistry function
                -- that listens for the 'Visible' propert being changed.
                -- Visible: true => Add to active list, and call UpdateColors function
                -- Visible: false => Remove from active list.

                -- The above would be especially efficient for a rainbow menu color or live color-changing.

                for Idx, Object in next, Library.Registry do
                    for Property, ColorIdx in next, Object.Properties do
                        if type(ColorIdx) == 'string' then
                            Object.Instance[Property] = Library[ColorIdx];
                        elseif type(ColorIdx) == 'function' then
                            Object.Instance[Property] = ColorIdx()
                        end
                    end;
                end;
            end;

            function Library:GiveSignal(Signal)
                -- Only used for signals not attached to library instances, as those should be cleaned up on object destruction by Roblox
                table.insert(Library.Signals, Signal)
            end

            function Library:Unload()
                -- Unload all of the signals
                for Idx = #Library.Signals, 1, -1 do
                    local Connection = table.remove(Library.Signals, Idx)
                    Connection:Disconnect()
                end

                 -- Call our unload callback, maybe to undo some hooks etc
                if Library.OnUnload then
                    Library.OnUnload()
                end

                ScreenGui:Destroy()
            end

            function Library:OnUnload(Callback)
                Library.OnUnload = Callback
            end

            Library:GiveSignal(ScreenGui.DescendantRemoving:Connect(function(Instance)
                if Library.RegistryMap[Instance] then
                    Library:RemoveFromRegistry(Instance);
                end;
            end))

            local BaseAddons = {};

            do
                local Funcs = {};

                function Funcs:AddColorPicker(Idx, Info)
                    local ToggleLabel = self.TextLabel;
                    -- local Container = self.Container;

                    assert(Info.Default, 'AddColorPicker: Missing default value.');

                    local ColorPicker = {
                        Value = Info.Default;
                        Transparency = Info.Transparency or 0;
                        Type = 'ColorPicker';
                        Title = type(Info.Title) == 'string' and Info.Title or 'Color picker',
                        Callback = Info.Callback or function(Color) end;
                    };

                    function ColorPicker:SetHSVFromRGB(Color)
                        local H, S, V = Color3.toHSV(Color);

                        ColorPicker.Hue = H;
                        ColorPicker.Sat = S;
                        ColorPicker.Vib = V;
                    end;

                    ColorPicker:SetHSVFromRGB(ColorPicker.Value);

                    local DisplayFrame = Library:Create('Frame', {
                        BackgroundColor3 = ColorPicker.Value;
                        BorderColor3 = Library:GetDarkerColor(ColorPicker.Value);
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(0, 28, 0, 14);
                        ZIndex = 6;
                        Parent = ToggleLabel;
                    });

                    -- Transparency image taken from https://github.com/matas3535/SplixPrivateDrawingLibrary/blob/main/Library.lua cus i'm lazy
                    local CheckerFrame = Library:Create('ImageLabel', {
                        BorderSizePixel = 0;
                        Size = UDim2.new(0, 27, 0, 13);
                        ZIndex = 5;
                        Image = 'http://www.roblox.com/asset/?id=12977615774';
                        Visible = not not Info.Transparency;
                        Parent = DisplayFrame;
                    });

                    -- 1/16/23
                    -- Rewrote this to be placed inside the Library ScreenGui
                    -- There was some issue which caused RelativeOffset to be way off
                    -- Thus the color picker would never show

                    local PickerFrameOuter = Library:Create('Frame', {
                        Name = 'Color';
                        BackgroundColor3 = Color3.new(1, 1, 1);
                        BorderColor3 = Color3.new(0, 0, 0);
                        Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18),
                        Size = UDim2.fromOffset(230, Info.Transparency and 271 or 253);
                        Visible = false;
                        ZIndex = 15;
                        Parent = ScreenGui,
                    });

                    DisplayFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
                        PickerFrameOuter.Position = UDim2.fromOffset(DisplayFrame.AbsolutePosition.X, DisplayFrame.AbsolutePosition.Y + 18);
                    end)

                    local PickerFrameInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.BackgroundColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 16;
                        Parent = PickerFrameOuter;
                    });

                    local Highlight = Library:Create('Frame', {
                        BackgroundColor3 = Library.AccentColor;
                        BorderSizePixel = 0;
                        Size = UDim2.new(1, 0, 0, 2);
                        ZIndex = 17;
                        Parent = PickerFrameInner;
                    });

                    local SatVibMapOuter = Library:Create('Frame', {
                        BorderColor3 = Color3.new(0, 0, 0);
                        Position = UDim2.new(0, 4, 0, 25);
                        Size = UDim2.new(0, 200, 0, 200);
                        ZIndex = 17;
                        Parent = PickerFrameInner;
                    });

                    local SatVibMapInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.BackgroundColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 18;
                        Parent = SatVibMapOuter;
                    });

                    local SatVibMap = Library:Create('ImageLabel', {
                        BorderSizePixel = 0;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 18;
                        Image = 'rbxassetid://4155801252';
                        Parent = SatVibMapInner;
                    });

                    local CursorOuter = Library:Create('ImageLabel', {
                        AnchorPoint = Vector2.new(0.5, 0.5);
                        Size = UDim2.new(0, 6, 0, 6);
                        BackgroundTransparency = 1;
                        Image = 'http://www.roblox.com/asset/?id=9619665977';
                        ImageColor3 = Color3.new(0, 0, 0);
                        ZIndex = 19;
                        Parent = SatVibMap;
                    });

                    local CursorInner = Library:Create('ImageLabel', {
                        Size = UDim2.new(0, CursorOuter.Size.X.Offset - 2, 0, CursorOuter.Size.Y.Offset - 2);
                        Position = UDim2.new(0, 1, 0, 1);
                        BackgroundTransparency = 1;
                        Image = 'http://www.roblox.com/asset/?id=9619665977';
                        ZIndex = 20;
                        Parent = CursorOuter;
                    })

                    local HueSelectorOuter = Library:Create('Frame', {
                        BorderColor3 = Color3.new(0, 0, 0);
                        Position = UDim2.new(0, 208, 0, 25);
                        Size = UDim2.new(0, 15, 0, 200);
                        ZIndex = 17;
                        Parent = PickerFrameInner;
                    });

                    local HueSelectorInner = Library:Create('Frame', {
                        BackgroundColor3 = Color3.new(1, 1, 1);
                        BorderSizePixel = 0;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 18;
                        Parent = HueSelectorOuter;
                    });

                    local HueCursor = Library:Create('Frame', { 
                        BackgroundColor3 = Color3.new(1, 1, 1);
                        AnchorPoint = Vector2.new(0, 0.5);
                        BorderColor3 = Color3.new(0, 0, 0);
                        Size = UDim2.new(1, 0, 0, 1);
                        ZIndex = 18;
                        Parent = HueSelectorInner;
                    });

                    local HueBoxOuter = Library:Create('Frame', {
                        BorderColor3 = Color3.new(0, 0, 0);
                        Position = UDim2.fromOffset(4, 228),
                        Size = UDim2.new(0.5, -6, 0, 20),
                        ZIndex = 18,
                        Parent = PickerFrameInner;
                    });

                    local HueBoxInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.MainColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 18,
                        Parent = HueBoxOuter;
                    });

                    Library:Create('UIGradient', {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                        });
                        Rotation = 90;
                        Parent = HueBoxInner;
                    });

                    local HueBox = Library:Create('TextBox', {
                        BackgroundTransparency = 1;
                        Position = UDim2.new(0, 5, 0, 0);
                        Size = UDim2.new(1, -5, 1, 0);
                        Font = Library.Font;
                        PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
                        PlaceholderText = 'Hex color',
                        Text = '#FFFFFF',
                        TextColor3 = Library.FontColor;
                        TextSize = 13;
                        TextStrokeTransparency = 0;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        ZIndex = 20,
                        Parent = HueBoxInner;
                    });

                    Library:ApplyTextStroke(HueBox);

                    local RgbBoxBase = Library:Create(HueBoxOuter:Clone(), {
                        Position = UDim2.new(0.5, 2, 0, 228),
                        Size = UDim2.new(0.5, -6, 0, 20),
                        Parent = PickerFrameInner
                    });

                    local RgbBox = Library:Create(RgbBoxBase.Frame:FindFirstChild('TextBox'), {
                        Text = '255, 255, 255',
                        PlaceholderText = 'RGB color',
                        TextColor3 = Library.FontColor
                    });

                    local TransparencyBoxOuter, TransparencyBoxInner, TransparencyCursor;

                    if Info.Transparency then 
                        TransparencyBoxOuter = Library:Create('Frame', {
                            BorderColor3 = Color3.new(0, 0, 0);
                            Position = UDim2.fromOffset(4, 251);
                            Size = UDim2.new(1, -8, 0, 15);
                            ZIndex = 19;
                            Parent = PickerFrameInner;
                        });

                        TransparencyBoxInner = Library:Create('Frame', {
                            BackgroundColor3 = ColorPicker.Value;
                            BorderColor3 = Library.OutlineColor;
                            BorderMode = Enum.BorderMode.Inset;
                            Size = UDim2.new(1, 0, 1, 0);
                            ZIndex = 19;
                            Parent = TransparencyBoxOuter;
                        });

                        Library:AddToRegistry(TransparencyBoxInner, { BorderColor3 = 'OutlineColor' });

                        Library:Create('ImageLabel', {
                            BackgroundTransparency = 1;
                            Size = UDim2.new(1, 0, 1, 0);
                            Image = 'http://www.roblox.com/asset/?id=12978095818';
                            ZIndex = 20;
                            Parent = TransparencyBoxInner;
                        });

                        TransparencyCursor = Library:Create('Frame', { 
                            BackgroundColor3 = Color3.new(1, 1, 1);
                            AnchorPoint = Vector2.new(0.5, 0);
                            BorderColor3 = Color3.new(0, 0, 0);
                            Size = UDim2.new(0, 1, 1, 0);
                            ZIndex = 21;
                            Parent = TransparencyBoxInner;
                        });
                    end;

                    local DisplayLabel = Library:CreateLabel({
                        Size = UDim2.new(1, 0, 0, 14);
                        Position = UDim2.fromOffset(5, 5);
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextSize = 13;
                        Text = ColorPicker.Title,--Info.Default;
                        TextWrapped = false;
                        ZIndex = 16;
                        Parent = PickerFrameInner;
                    });


                    local ContextMenu = {}
                    do
                        ContextMenu.Options = {}
                        ContextMenu.Container = Library:Create('Frame', {
                            BorderColor3 = Color3.new(),
                            ZIndex = 14,

                            Visible = false,
                            Parent = ScreenGui
                        })

                        ContextMenu.Inner = Library:Create('Frame', {
                            BackgroundColor3 = Library.BackgroundColor;
                            BorderColor3 = Library.OutlineColor;
                            BorderMode = Enum.BorderMode.Inset;
                            Size = UDim2.fromScale(1, 1);
                            ZIndex = 15;
                            Parent = ContextMenu.Container;
                        });

                        Library:Create('UIListLayout', {
                            Name = 'Layout',
                            FillDirection = Enum.FillDirection.Vertical;
                            SortOrder = Enum.SortOrder.LayoutOrder;
                            Parent = ContextMenu.Inner;
                        });

                        Library:Create('UIPadding', {
                            Name = 'Padding',
                            PaddingLeft = UDim.new(0, 4),
                            Parent = ContextMenu.Inner,
                        });

                        local function updateMenuPosition()
                            ContextMenu.Container.Position = UDim2.fromOffset(
                                (DisplayFrame.AbsolutePosition.X + DisplayFrame.AbsoluteSize.X) + 4,
                                DisplayFrame.AbsolutePosition.Y + 1
                            )
                        end

                        local function updateMenuSize()
                            local menuWidth = 60
                            for i, label in next, ContextMenu.Inner:GetChildren() do
                                if label:IsA('TextLabel') then
                                    menuWidth = math.max(menuWidth, label.TextBounds.X)
                                end
                            end

                            ContextMenu.Container.Size = UDim2.fromOffset(
                                menuWidth + 8,
                                ContextMenu.Inner.Layout.AbsoluteContentSize.Y + 4
                            )
                        end

                        DisplayFrame:GetPropertyChangedSignal('AbsolutePosition'):Connect(updateMenuPosition)
                        ContextMenu.Inner.Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(updateMenuSize)

                        task.spawn(updateMenuPosition)
                        task.spawn(updateMenuSize)

                        Library:AddToRegistry(ContextMenu.Inner, {
                            BackgroundColor3 = 'BackgroundColor';
                            BorderColor3 = 'OutlineColor';
                        });

                        function ContextMenu:Show()
                            self.Container.Visible = true
                        end

                        function ContextMenu:Hide()
                            self.Container.Visible = false
                        end

                        function ContextMenu:AddOption(Str, Callback)
                            if type(Callback) ~= 'function' then
                                Callback = function() end
                            end

                            local Button = Library:CreateLabel({
                                Active = false;
                                Size = UDim2.new(1, 0, 0, 15);
                                TextSize = 13;
                                Text = Str;
                                ZIndex = 16;
                                Parent = self.Inner;
                                TextXAlignment = Enum.TextXAlignment.Left,
                            });

                            Library:OnHighlight(Button, Button, 
                                { TextColor3 = 'AccentColor' },
                                { TextColor3 = 'FontColor' }
                            );

                            Button.InputBegan:Connect(function(Input)
                                if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                                    return
                                end

                                Callback()
                            end)
                        end

                        ContextMenu:AddOption('Copy color', function()
                            Library.ColorClipboard = ColorPicker.Value
                            Library:Notify('Copied color!', 2)
                        end)

                        ContextMenu:AddOption('Paste color', function()
                            if not Library.ColorClipboard then
                                return Library:Notify('You have not copied a color!', 2)
                            end
                            ColorPicker:SetValueRGB(Library.ColorClipboard)
                        end)


                        ContextMenu:AddOption('Copy HEX', function()
                            pcall(setclipboard, ColorPicker.Value:ToHex())
                            Library:Notify('Copied hex code to clipboard!', 2)
                        end)

                        ContextMenu:AddOption('Copy RGB', function()
                            pcall(setclipboard, table.concat({ math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255) }, ', '))
                            Library:Notify('Copied RGB values to clipboard!', 2)
                        end)

                    end

                    Library:AddToRegistry(PickerFrameInner, { BackgroundColor3 = 'BackgroundColor'; BorderColor3 = 'OutlineColor'; });
                    Library:AddToRegistry(Highlight, { BackgroundColor3 = 'AccentColor'; });
                    Library:AddToRegistry(SatVibMapInner, { BackgroundColor3 = 'BackgroundColor'; BorderColor3 = 'OutlineColor'; });

                    Library:AddToRegistry(HueBoxInner, { BackgroundColor3 = 'MainColor'; BorderColor3 = 'OutlineColor'; });
                    Library:AddToRegistry(RgbBoxBase.Frame, { BackgroundColor3 = 'MainColor'; BorderColor3 = 'OutlineColor'; });
                    Library:AddToRegistry(RgbBox, { TextColor3 = 'FontColor', });
                    Library:AddToRegistry(HueBox, { TextColor3 = 'FontColor', });

                    local SequenceTable = {};

                    for Hue = 0, 1, 0.1 do
                        table.insert(SequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)));
                    end;

                    local HueSelectorGradient = Library:Create('UIGradient', {
                        Color = ColorSequence.new(SequenceTable);
                        Rotation = 90;
                        Parent = HueSelectorInner;
                    });

                    HueBox.FocusLost:Connect(function(enter)
                        if enter then
                            local success, result = pcall(Color3.fromHex, HueBox.Text)
                            if success and typeof(result) == 'Color3' then
                                ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(result)
                            end
                        end

                        ColorPicker:Display()
                    end)

                    RgbBox.FocusLost:Connect(function(enter)
                        if enter then
                            local r, g, b = RgbBox.Text:match('(%d+),%s*(%d+),%s*(%d+)')
                            if r and g and b then
                                ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color3.toHSV(Color3.fromRGB(r, g, b))
                            end
                        end

                        ColorPicker:Display()
                    end)

                    function ColorPicker:Display()
                        ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib);
                        SatVibMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1);

                        Library:Create(DisplayFrame, {
                            BackgroundColor3 = ColorPicker.Value;
                            BackgroundTransparency = ColorPicker.Transparency;
                            BorderColor3 = Library:GetDarkerColor(ColorPicker.Value);
                        });

                        if TransparencyBoxInner then
                            TransparencyBoxInner.BackgroundColor3 = ColorPicker.Value;
                            TransparencyCursor.Position = UDim2.new(1 - ColorPicker.Transparency, 0, 0, 0);
                        end;

                        CursorOuter.Position = UDim2.new(ColorPicker.Sat, 0, 1 - ColorPicker.Vib, 0);
                        HueCursor.Position = UDim2.new(0, 0, ColorPicker.Hue, 0);

                        HueBox.Text = '#' .. ColorPicker.Value:ToHex()
                        RgbBox.Text = table.concat({ math.floor(ColorPicker.Value.R * 255), math.floor(ColorPicker.Value.G * 255), math.floor(ColorPicker.Value.B * 255) }, ', ')

                        Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value);
                        Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value);
                    end;

                    function ColorPicker:OnChanged(Func)
                        ColorPicker.Changed = Func;
                        Func(ColorPicker.Value)
                    end;

                    function ColorPicker:Show()
                        for Frame, Val in next, Library.OpenedFrames do
                            if Frame.Name == 'Color' then
                                Frame.Visible = false;
                                Library.OpenedFrames[Frame] = nil;
                            end;
                        end;

                        PickerFrameOuter.Visible = true;
                        Library.OpenedFrames[PickerFrameOuter] = true;
                    end;

                    function ColorPicker:Hide()
                        PickerFrameOuter.Visible = false;
                        Library.OpenedFrames[PickerFrameOuter] = nil;
                    end;

                    function ColorPicker:SetValue(HSV, Transparency)
                        local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3]);

                        ColorPicker.Transparency = Transparency or 0;
                        ColorPicker:SetHSVFromRGB(Color);
                        ColorPicker:Display();
                    end;

                    function ColorPicker:SetValueRGB(Color, Transparency)
                        ColorPicker.Transparency = Transparency or 0;
                        ColorPicker:SetHSVFromRGB(Color);
                        ColorPicker:Display();
                    end;

                    SatVibMap.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                local MinX = SatVibMap.AbsolutePosition.X;
                                local MaxX = MinX + SatVibMap.AbsoluteSize.X;
                                local MouseX = math.clamp(Mouse.X, MinX, MaxX);

                                local MinY = SatVibMap.AbsolutePosition.Y;
                                local MaxY = MinY + SatVibMap.AbsoluteSize.Y;
                                local MouseY = math.clamp(Mouse.Y, MinY, MaxY);

                                ColorPicker.Sat = (MouseX - MinX) / (MaxX - MinX);
                                ColorPicker.Vib = 1 - ((MouseY - MinY) / (MaxY - MinY));
                                ColorPicker:Display();

                                RenderStepped:Wait();
                            end;

                            Library:AttemptSave();
                        end;
                    end);

                    HueSelectorInner.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                local MinY = HueSelectorInner.AbsolutePosition.Y;
                                local MaxY = MinY + HueSelectorInner.AbsoluteSize.Y;
                                local MouseY = math.clamp(Mouse.Y, MinY, MaxY);

                                ColorPicker.Hue = ((MouseY - MinY) / (MaxY - MinY));
                                ColorPicker:Display();

                                RenderStepped:Wait();
                            end;

                            Library:AttemptSave();
                        end;
                    end);

                    DisplayFrame.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                            if PickerFrameOuter.Visible then
                                ColorPicker:Hide()
                            else
                                ContextMenu:Hide()
                                ColorPicker:Show()
                            end;
                        elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
                            ContextMenu:Show()
                            ColorPicker:Hide()
                        end
                    end);

                    if TransparencyBoxInner then
                        TransparencyBoxInner.InputBegan:Connect(function(Input)
                            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                                while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                    local MinX = TransparencyBoxInner.AbsolutePosition.X;
                                    local MaxX = MinX + TransparencyBoxInner.AbsoluteSize.X;
                                    local MouseX = math.clamp(Mouse.X, MinX, MaxX);

                                    ColorPicker.Transparency = 1 - ((MouseX - MinX) / (MaxX - MinX));

                                    ColorPicker:Display();

                                    RenderStepped:Wait();
                                end;

                                Library:AttemptSave();
                            end;
                        end);
                    end;

                    Library:GiveSignal(InputService.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local AbsPos, AbsSize = PickerFrameOuter.AbsolutePosition, PickerFrameOuter.AbsoluteSize;

                            if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                                or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                                ColorPicker:Hide();
                            end;

                            if not Library:IsMouseOverFrame(ContextMenu.Container) then
                                ContextMenu:Hide()
                            end
                        end;

                        if Input.UserInputType == Enum.UserInputType.MouseButton2 and ContextMenu.Container.Visible then
                            if not Library:IsMouseOverFrame(ContextMenu.Container) and not Library:IsMouseOverFrame(DisplayFrame) then
                                ContextMenu:Hide()
                            end
                        end
                    end))

                    ColorPicker:Display();
                    ColorPicker.DisplayFrame = DisplayFrame

                    Options[Idx] = ColorPicker;

                    return self;
                end;

                function Funcs:AddKeyPicker(Idx, Info)
                    local ParentObj = self;
                    local ToggleLabel = self.TextLabel;
                    local Container = self.Container;

                    assert(Info.Default, 'AddKeyPicker: Missing default value.');

                    local KeyPicker = {
                        Value = Info.Default;
                        Toggled = false;
                        Mode = Info.Mode or 'Toggle'; -- Always, Toggle, Hold
                        Type = 'KeyPicker';
                        Callback = Info.Callback or function(Value) end;
                        ChangedCallback = Info.ChangedCallback or function(New) end;

                        SyncToggleState = Info.SyncToggleState or false;
                    };

                    if KeyPicker.SyncToggleState then
                        Info.Modes = { 'Toggle' }
                        Info.Mode = 'Toggle'
                    end

                    local PickOuter = Library:Create('Frame', {
                        BackgroundColor3 = Color3.new(0, 0, 0);
                        BorderColor3 = Color3.new(0, 0, 0);
                        Size = UDim2.new(0, 28, 0, 15);
                        ZIndex = 6;
                        Parent = ToggleLabel;
                    });

                    local PickInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.BackgroundColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 7;
                        Parent = PickOuter;
                    });

                    Library:AddToRegistry(PickInner, {
                        BackgroundColor3 = 'BackgroundColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    local DisplayLabel = Library:CreateLabel({
                        Size = UDim2.new(1, 0, 1, 0);
                        TextSize = 13;
                        Text = Info.Default;
                        TextWrapped = true;
                        ZIndex = 8;
                        Parent = PickInner;
                    });

                    local ModeSelectOuter = Library:Create('Frame', {
                        BorderColor3 = Color3.new(0, 0, 0);
                        Position = UDim2.fromOffset(ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4, ToggleLabel.AbsolutePosition.Y + 1);
                        Size = UDim2.new(0, 60, 0, 45 + 2);
                        Visible = false;
                        ZIndex = 14;
                        Parent = ScreenGui;
                    });

                    ToggleLabel:GetPropertyChangedSignal('AbsolutePosition'):Connect(function()
                        ModeSelectOuter.Position = UDim2.fromOffset(ToggleLabel.AbsolutePosition.X + ToggleLabel.AbsoluteSize.X + 4, ToggleLabel.AbsolutePosition.Y + 1);
                    end);

                    local ModeSelectInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.BackgroundColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 15;
                        Parent = ModeSelectOuter;
                    });

                    Library:AddToRegistry(ModeSelectInner, {
                        BackgroundColor3 = 'BackgroundColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    Library:Create('UIListLayout', {
                        FillDirection = Enum.FillDirection.Vertical;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        Parent = ModeSelectInner;
                    });

                    local ContainerLabel = Library:CreateLabel({
                        TextXAlignment = Enum.TextXAlignment.Left;
                        Size = UDim2.new(1, 0, 0, 18);
                        TextSize = 13;
                        Visible = false;
                        ZIndex = 110;
                        Parent = Library.KeybindContainer;
                    },  true);

                    local Modes = Info.Modes or { 'Always', 'Toggle', 'Hold' };
                    local ModeButtons = {};

                    for Idx, Mode in next, Modes do
                        local ModeButton = {};

                        local Label = Library:CreateLabel({
                            Active = false;
                            Size = UDim2.new(1, 0, 0, 15);
                            TextSize = 13;
                            Text = Mode;
                            ZIndex = 16;
                            Parent = ModeSelectInner;
                        });

                        function ModeButton:Select()
                            for _, Button in next, ModeButtons do
                                Button:Deselect();
                            end;

                            KeyPicker.Mode = Mode;

                            Label.TextColor3 = Library.AccentColor;
                            Library.RegistryMap[Label].Properties.TextColor3 = 'AccentColor';

                            ModeSelectOuter.Visible = false;
                        end;

                        function ModeButton:Deselect()
                            KeyPicker.Mode = nil;

                            Label.TextColor3 = Library.FontColor;
                            Library.RegistryMap[Label].Properties.TextColor3 = 'FontColor';
                        end;

                        Label.InputBegan:Connect(function(Input)
                            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                                ModeButton:Select();
                                Library:AttemptSave();
                            end;
                        end);

                        if Mode == KeyPicker.Mode then
                            ModeButton:Select();
                        end;

                        ModeButtons[Mode] = ModeButton;
                    end;

                    function KeyPicker:Update()
                        if Info.NoUI then
                            return;
                        end;

                        local State = KeyPicker:GetState();

                        ContainerLabel.Text = string.format('[%s] %s (%s)', KeyPicker.Value, Info.Text, KeyPicker.Mode);

                        ContainerLabel.Visible = true;
                        ContainerLabel.TextColor3 = State and Library.AccentColor or Library.FontColor;

                        Library.RegistryMap[ContainerLabel].Properties.TextColor3 = State and 'AccentColor' or 'FontColor';

                        local YSize = 0
                        local XSize = 0

                        for _, Label in next, Library.KeybindContainer:GetChildren() do
                            if Label:IsA('TextLabel') and Label.Visible then
                                YSize = YSize + 18;
                                if (Label.TextBounds.X > XSize) then
                                    XSize = Label.TextBounds.X
                                end
                            end;
                        end;

                        Library.KeybindFrame.Size = UDim2.new(0, math.max(XSize + 10, 210), 0, YSize + 23)
                    end;

                    function KeyPicker:GetState()
                        if KeyPicker.Mode == 'Always' then
                            return true;
                        elseif KeyPicker.Mode == 'Hold' then
                            if KeyPicker.Value == 'None' then
                                return false;
                            end

                            local Key = KeyPicker.Value;

                            if Key == 'MB1' or Key == 'MB2' then
                                return Key == 'MB1' and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                                    or Key == 'MB2' and InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2);
                            else
                                return InputService:IsKeyDown(Enum.KeyCode[KeyPicker.Value]);
                            end;
                        else
                            return KeyPicker.Toggled;
                        end;
                    end;

                    function KeyPicker:SetValue(Data)
                        local Key, Mode = Data[1], Data[2];
                        DisplayLabel.Text = Key;
                        KeyPicker.Value = Key;
                        ModeButtons[Mode]:Select();
                        KeyPicker:Update();
                    end;

                    function KeyPicker:OnClick(Callback)
                        KeyPicker.Clicked = Callback
                    end

                    function KeyPicker:OnChanged(Callback)
                        KeyPicker.Changed = Callback
                        Callback(KeyPicker.Value)
                    end

                    if ParentObj.Addons then
                        table.insert(ParentObj.Addons, KeyPicker)
                    end

                    function KeyPicker:DoClick()
                        if ParentObj.Type == 'Toggle' and KeyPicker.SyncToggleState then
                            ParentObj:SetValue(not ParentObj.Value)
                        end

                        Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
                        Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)
                    end

                    local Picking = false;

                    PickOuter.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                            Picking = true;

                            DisplayLabel.Text = '';

                            local Break;
                            local Text = '';

                            task.spawn(function()
                                while (not Break) do
                                    if Text == '...' then
                                        Text = '';
                                    end;

                                    Text = Text .. '.';
                                    DisplayLabel.Text = Text;

                                    wait(0.4);
                                end;
                            end);

                            wait(0.2);

                            local Event;
                            Event = InputService.InputBegan:Connect(function(Input)
                                local Key;

                                if Input.UserInputType == Enum.UserInputType.Keyboard then
                                    Key = Input.KeyCode.Name;
                                elseif Input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    Key = 'MB1';
                                elseif Input.UserInputType == Enum.UserInputType.MouseButton2 then
                                    Key = 'MB2';
                                end;

                                Break = true;
                                Picking = false;

                                DisplayLabel.Text = Key;
                                KeyPicker.Value = Key;

                                Library:SafeCallback(KeyPicker.ChangedCallback, Input.KeyCode or Input.UserInputType)
                                Library:SafeCallback(KeyPicker.Changed, Input.KeyCode or Input.UserInputType)

                                Library:AttemptSave();

                                Event:Disconnect();
                            end);
                        elseif Input.UserInputType == Enum.UserInputType.MouseButton2 and not Library:MouseIsOverOpenedFrame() then
                            ModeSelectOuter.Visible = true;
                        end;
                    end);

                    Library:GiveSignal(InputService.InputBegan:Connect(function(Input)
                        if (not Picking) then
                            if KeyPicker.Mode == 'Toggle' then
                                local Key = KeyPicker.Value;

                                if Key == 'MB1' or Key == 'MB2' then
                                    if Key == 'MB1' and Input.UserInputType == Enum.UserInputType.MouseButton1
                                    or Key == 'MB2' and Input.UserInputType == Enum.UserInputType.MouseButton2 then
                                        KeyPicker.Toggled = not KeyPicker.Toggled
                                        KeyPicker:DoClick()
                                    end;
                                elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                                    if Input.KeyCode.Name == Key then
                                        KeyPicker.Toggled = not KeyPicker.Toggled;
                                        KeyPicker:DoClick()
                                    end;
                                end;
                            end;

                            KeyPicker:Update();
                        end;

                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local AbsPos, AbsSize = ModeSelectOuter.AbsolutePosition, ModeSelectOuter.AbsoluteSize;

                            if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                                or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                                ModeSelectOuter.Visible = false;
                            end;
                        end;
                    end))

                    Library:GiveSignal(InputService.InputEnded:Connect(function(Input)
                        if (not Picking) then
                            KeyPicker:Update();
                        end;
                    end))

                    KeyPicker:Update();

                    Options[Idx] = KeyPicker;

                    return self;
                end;

                BaseAddons.__index = Funcs;
                BaseAddons.__namecall = function(Table, Key, ...)
                    return Funcs[Key](...);
                end;
            end;

            local BaseGroupbox = {};

            do
                local Funcs = {};

                function Funcs:AddBlank(Size)
                    local Groupbox = self;
                    local Container = Groupbox.Container;

                    Library:Create('Frame', {
                        BackgroundTransparency = 1;
                        Size = UDim2.new(1, 0, 0, Size);
                        ZIndex = 1;
                        Parent = Container;
                    });
                end;

                function Funcs:AddLabel(Text, DoesWrap)
                    local Label = {};

                    local Groupbox = self;
                    local Container = Groupbox.Container;

                    local TextLabel = Library:CreateLabel({
                        Size = UDim2.new(1, -4, 0, 15);
                        TextSize = 13;
                        Text = Text;
                        TextWrapped = DoesWrap or false,
                        TextXAlignment = Enum.TextXAlignment.Left;
                        ZIndex = 5;
                        Parent = Container;
                    });

                    if DoesWrap then
                        local Y = select(2, Library:GetTextBounds(Text, Library.Font, 14, Vector2.new(TextLabel.AbsoluteSize.X, math.huge)))
                        TextLabel.Size = UDim2.new(1, -4, 0, Y)
                    else
                        Library:Create('UIListLayout', {
                            Padding = UDim.new(0, 4);
                            FillDirection = Enum.FillDirection.Horizontal;
                            HorizontalAlignment = Enum.HorizontalAlignment.Right;
                            SortOrder = Enum.SortOrder.LayoutOrder;
                            Parent = TextLabel;
                        });
                    end

                    Label.TextLabel = TextLabel;
                    Label.Container = Container;

                    function Label:SetText(Text)
                        TextLabel.Text = Text

                        if DoesWrap then
                            local Y = select(2, Library:GetTextBounds(Text, Library.Font, 14, Vector2.new(TextLabel.AbsoluteSize.X, math.huge)))
                            TextLabel.Size = UDim2.new(1, -4, 0, Y)
                        end

                        Groupbox:Resize();
                    end

                    if (not DoesWrap) then
                        setmetatable(Label, BaseAddons);
                    end

                    Groupbox:AddBlank(5);
                    Groupbox:Resize();

                    return Label;
                end;

                function Funcs:AddButton(...)
                    -- TODO: Eventually redo this
                    local Button = {};
                    local function ProcessButtonParams(Class, Obj, ...)
                        local Props = select(1, ...)
                        if type(Props) == 'table' then
                            Obj.Text = Props.Text
                            Obj.Func = Props.Func
                            Obj.DoubleClick = Props.DoubleClick
                            Obj.Tooltip = Props.Tooltip
                        else
                            Obj.Text = select(1, ...)
                            Obj.Func = select(2, ...)
                        end

                        assert(type(Obj.Func) == 'function', 'AddButton: `Func` callback is missing.');
                    end

                    ProcessButtonParams('Button', Button, ...)

                    local Groupbox = self;
                    local Container = Groupbox.Container;

                    local function CreateBaseButton(Button)
                        local Outer = Library:Create('Frame', {
                            BackgroundColor3 = Color3.new(0, 0, 0);
                            BorderColor3 = Color3.new(0, 0, 0);
                            Size = UDim2.new(1, -4, 0, 20);
                            ZIndex = 5;
                        });

                        local Inner = Library:Create('Frame', {
                            BackgroundColor3 = Library.MainColor;
                            BorderColor3 = Library.OutlineColor;
                            BorderMode = Enum.BorderMode.Inset;
                            Size = UDim2.new(1, 0, 1, 0);
                            ZIndex = 6;
                            Parent = Outer;
                        });

                        local Label = Library:CreateLabel({
                            Size = UDim2.new(1, 0, 1, 0);
                            TextSize = 13;
                            Text = Button.Text;
                            ZIndex = 6;
                            Parent = Inner;
                        });

                        Library:Create('UIGradient', {
                            Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                            });
                            Rotation = 90;
                            Parent = Inner;
                        });

                        Library:AddToRegistry(Outer, {
                            BorderColor3 = 'Black';
                        });

                        Library:AddToRegistry(Inner, {
                            BackgroundColor3 = 'MainColor';
                            BorderColor3 = 'OutlineColor';
                        });

                        Library:OnHighlight(Outer, Outer,
                            { BorderColor3 = 'AccentColor' },
                            { BorderColor3 = 'Black' }
                        );

                        return Outer, Inner, Label
                    end

                    local function InitEvents(Button)
                        local function WaitForEvent(event, timeout, validator)
                            local bindable = Instance.new('BindableEvent')
                            local connection = event:Once(function(...)

                                if type(validator) == 'function' and validator(...) then
                                    bindable:Fire(true)
                                else
                                    bindable:Fire(false)
                                end
                            end)
                            task.delay(timeout, function()
                                connection:disconnect()
                                bindable:Fire(false)
                            end)
                            return bindable.Event:Wait()
                        end

                        local function ValidateClick(Input)
                            if Library:MouseIsOverOpenedFrame() then
                                return false
                            end

                            if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                                return false
                            end

                            return true
                        end

                        Button.Outer.InputBegan:Connect(function(Input)
                            if not ValidateClick(Input) then return end
                            if Button.Locked then return end

                            if Button.DoubleClick then
                                Library:RemoveFromRegistry(Button.Label)
                                Library:AddToRegistry(Button.Label, { TextColor3 = 'AccentColor' })

                                Button.Label.TextColor3 = Library.AccentColor
                                Button.Label.Text = 'Are you sure?'
                                Button.Locked = true

                                local clicked = WaitForEvent(Button.Outer.InputBegan, 0.5, ValidateClick)

                                Library:RemoveFromRegistry(Button.Label)
                                Library:AddToRegistry(Button.Label, { TextColor3 = 'FontColor' })

                                Button.Label.TextColor3 = Library.FontColor
                                Button.Label.Text = Button.Text
                                task.defer(rawset, Button, 'Locked', false)

                                if clicked then
                                    Library:SafeCallback(Button.Func)
                                end

                                return
                            end

                            Library:SafeCallback(Button.Func);
                        end)
                    end

                    Button.Outer, Button.Inner, Button.Label = CreateBaseButton(Button)
                    Button.Outer.Parent = Container

                    InitEvents(Button)

                    function Button:AddTooltip(tooltip)
                        if type(tooltip) == 'string' then
                            Library:AddToolTip(tooltip, self.Outer)
                        end
                        return self
                    end


                    function Button:AddButton(...)
                        local SubButton = {}

                        ProcessButtonParams('SubButton', SubButton, ...)

                        self.Outer.Size = UDim2.new(0.5, -2, 0, 20)

                        SubButton.Outer, SubButton.Inner, SubButton.Label = CreateBaseButton(SubButton)

                        SubButton.Outer.Position = UDim2.new(1, 3, 0, 0)
                        SubButton.Outer.Size = UDim2.fromOffset(self.Outer.AbsoluteSize.X - 2, self.Outer.AbsoluteSize.Y)
                        SubButton.Outer.Parent = self.Outer

                        function SubButton:AddTooltip(tooltip)
                            if type(tooltip) == 'string' then
                                Library:AddToolTip(tooltip, self.Outer)
                            end
                            return SubButton
                        end

                        if type(SubButton.Tooltip) == 'string' then
                            SubButton:AddTooltip(SubButton.Tooltip)
                        end

                        InitEvents(SubButton)
                        return SubButton
                    end

                    if type(Button.Tooltip) == 'string' then
                        Button:AddTooltip(Button.Tooltip)
                    end

                    Groupbox:AddBlank(5);
                    Groupbox:Resize();

                    return Button;
                end;

                function Funcs:AddDivider()
                    local Groupbox = self;
                    local Container = self.Container

                    local Divider = {
                        Type = 'Divider',
                    }

                    Groupbox:AddBlank(2);
                    local DividerOuter = Library:Create('Frame', {
                        BackgroundColor3 = Color3.new(0, 0, 0);
                        BorderColor3 = Color3.new(0, 0, 0);
                        Size = UDim2.new(1, -4, 0, 5);
                        ZIndex = 5;
                        Parent = Container;
                    });

                    local DividerInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.MainColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 6;
                        Parent = DividerOuter;
                    });

                    Library:AddToRegistry(DividerOuter, {
                        BorderColor3 = 'Black';
                    });

                    Library:AddToRegistry(DividerInner, {
                        BackgroundColor3 = 'MainColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    Groupbox:AddBlank(9);
                    Groupbox:Resize();
                end

                function Funcs:AddInput(Idx, Info)
                    assert(Info.Text, 'AddInput: Missing `Text` string.')

                    local Textbox = {
                        Value = Info.Default or '';
                        Numeric = Info.Numeric or false;
                        Finished = Info.Finished or false;
                        Type = 'Input';
                        Callback = Info.Callback or function(Value) end;
                    };

                    local Groupbox = self;
                    local Container = Groupbox.Container;

                    local InputLabel = Library:CreateLabel({
                        Size = UDim2.new(1, 0, 0, 15);
                        TextSize = 13;
                        Text = Info.Text;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        ZIndex = 5;
                        Parent = Container;
                    });

                    Groupbox:AddBlank(1);

                    local TextBoxOuter = Library:Create('Frame', {
                        BackgroundColor3 = Color3.new(0, 0, 0);
                        BorderColor3 = Color3.new(0, 0, 0);
                        Size = UDim2.new(1, -4, 0, 20);
                        ZIndex = 5;
                        Parent = Container;
                    });

                    local TextBoxInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.MainColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 6;
                        Parent = TextBoxOuter;
                    });

                    Library:AddToRegistry(TextBoxInner, {
                        BackgroundColor3 = 'MainColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    Library:OnHighlight(TextBoxOuter, TextBoxOuter,
                        { BorderColor3 = 'AccentColor' },
                        { BorderColor3 = 'Black' }
                    );

                    if type(Info.Tooltip) == 'string' then
                        Library:AddToolTip(Info.Tooltip, TextBoxOuter)
                    end

                    Library:Create('UIGradient', {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                        });
                        Rotation = 90;
                        Parent = TextBoxInner;
                    });

                    local Container = Library:Create('Frame', {
                        BackgroundTransparency = 1;
                        ClipsDescendants = true;

                        Position = UDim2.new(0, 5, 0, 0);
                        Size = UDim2.new(1, -5, 1, 0);

                        ZIndex = 7;
                        Parent = TextBoxInner;
                    })

                    local Box = Library:Create('TextBox', {
                        BackgroundTransparency = 1;

                        Position = UDim2.fromOffset(0, 0),
                        Size = UDim2.fromScale(5, 1),

                        Font = Library.Font;
                        PlaceholderColor3 = Color3.fromRGB(190, 190, 190);
                        PlaceholderText = Info.Placeholder or '';

                        Text = Info.Default or '';
                        TextColor3 = Library.FontColor;
                        TextSize = 13;
                        TextStrokeTransparency = 0;
                        TextXAlignment = Enum.TextXAlignment.Left;

                        ZIndex = 7;
                        Parent = Container;
                    });

                    Library:ApplyTextStroke(Box);

                    function Textbox:SetValue(Text)
                        if Info.MaxLength and #Text > Info.MaxLength then
                            Text = Text:sub(1, Info.MaxLength);
                        end;

                        if Textbox.Numeric then
                            if (not tonumber(Text)) and Text:len() > 0 then
                                Text = Textbox.Value
                            end
                        end

                        Textbox.Value = Text;
                        Box.Text = Text;

                        Library:SafeCallback(Textbox.Callback, Textbox.Value);
                        Library:SafeCallback(Textbox.Changed, Textbox.Value);
                    end;

                    if Textbox.Finished then
                        Box.FocusLost:Connect(function(enter)
                            if not enter then return end

                            Textbox:SetValue(Box.Text);
                            Library:AttemptSave();
                        end)
                    else
                        Box:GetPropertyChangedSignal('Text'):Connect(function()
                            Textbox:SetValue(Box.Text);
                            Library:AttemptSave();
                        end);
                    end

                    -- https://devforum.roblox.com/t/how-to-make-textboxes-follow-current-cursor-position/1368429/6
                    -- thank you nicemike40 :)

                    local function Update()
                        local PADDING = 2
                        local reveal = Container.AbsoluteSize.X

                        if not Box:IsFocused() or Box.TextBounds.X <= reveal - 2 * PADDING then
                            -- we aren't focused, or we fit so be normal
                            Box.Position = UDim2.new(0, PADDING, 0, 0)
                        else
                            -- we are focused and don't fit, so adjust position
                            local cursor = Box.CursorPosition
                            if cursor ~= -1 then
                                -- calculate pixel width of text from start to cursor
                                local subtext = string.sub(Box.Text, 1, cursor-1)
                                local width = TextService:GetTextSize(subtext, Box.TextSize, Box.Font, Vector2.new(math.huge, math.huge)).X

                                -- check if we're inside the box with the cursor
                                local currentCursorPos = Box.Position.X.Offset + width

                                -- adjust if necessary
                                if currentCursorPos < PADDING then
                                    Box.Position = UDim2.fromOffset(PADDING-width, 0)
                                elseif currentCursorPos > reveal - PADDING - 1 then
                                    Box.Position = UDim2.fromOffset(reveal-width-PADDING-1, 0)
                                end
                            end
                        end
                    end

                    task.spawn(Update)

                    Box:GetPropertyChangedSignal('Text'):Connect(Update)
                    Box:GetPropertyChangedSignal('CursorPosition'):Connect(Update)
                    Box.FocusLost:Connect(Update)
                    Box.Focused:Connect(Update)

                    Library:AddToRegistry(Box, {
                        TextColor3 = 'FontColor';
                    });

                    function Textbox:OnChanged(Func)
                        Textbox.Changed = Func;
                        Func(Textbox.Value);
                    end;

                    Groupbox:AddBlank(5);
                    Groupbox:Resize();

                    Options[Idx] = Textbox;

                    return Textbox;
                end;

                function Funcs:AddToggle(Idx, Info)
                    assert(Info.Text, 'AddInput: Missing `Text` string.')

                    local Toggle = {
                        Value = Info.Default or false;
                        Type = 'Toggle';

                        Callback = Info.Callback or function(Value) end;
                        Addons = {},
                        Risky = Info.Risky,
                    };

                    local Groupbox = self;
                    local Container = Groupbox.Container;

                    local ToggleOuter = Library:Create('Frame', {
                        BackgroundColor3 = Color3.new(0, 0, 0);
                        BorderColor3 = Color3.new(0, 0, 0);
                        Size = UDim2.new(0, 13, 0, 13);
                        ZIndex = 5;
                        Parent = Container;
                    });

                    Library:AddToRegistry(ToggleOuter, {
                        BorderColor3 = 'Black';
                    });

                    local ToggleInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.MainColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 6;
                        Parent = ToggleOuter;
                    });

                    Library:AddToRegistry(ToggleInner, {
                        BackgroundColor3 = 'MainColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    local ToggleLabel = Library:CreateLabel({
                        Size = UDim2.new(0, 216, 1, 0);
                        Position = UDim2.new(1, 6, 0, 0);
                        TextSize = 13;
                        Text = Info.Text;
                        TextXAlignment = Enum.TextXAlignment.Left;
                        ZIndex = 6;
                        Parent = ToggleInner;
                    });

                    Library:Create('UIListLayout', {
                        Padding = UDim.new(0, 4);
                        FillDirection = Enum.FillDirection.Horizontal;
                        HorizontalAlignment = Enum.HorizontalAlignment.Right;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        Parent = ToggleLabel;
                    });

                    local ToggleRegion = Library:Create('Frame', {
                        BackgroundTransparency = 1;
                        Size = UDim2.new(0, 170, 1, 0);
                        ZIndex = 8;
                        Parent = ToggleOuter;
                    });

                    Library:OnHighlight(ToggleRegion, ToggleOuter,
                        { BorderColor3 = 'AccentColor' },
                        { BorderColor3 = 'Black' }
                    );

                    function Toggle:UpdateColors()
                        Toggle:Display();
                    end;

                    if type(Info.Tooltip) == 'string' then
                        Library:AddToolTip(Info.Tooltip, ToggleRegion)
                    end

                    function Toggle:Display()
                        ToggleInner.BackgroundColor3 = Toggle.Value and Library.AccentColor or Library.MainColor;
                        ToggleInner.BorderColor3 = Toggle.Value and Library.AccentColorDark or Library.OutlineColor;

                        Library.RegistryMap[ToggleInner].Properties.BackgroundColor3 = Toggle.Value and 'AccentColor' or 'MainColor';
                        Library.RegistryMap[ToggleInner].Properties.BorderColor3 = Toggle.Value and 'AccentColorDark' or 'OutlineColor';
                    end;

                    function Toggle:OnChanged(Func)
                        Toggle.Changed = Func;
                        Func(Toggle.Value);
                    end;

                    function Toggle:SetValue(Bool)
                        Bool = (not not Bool);

                        Toggle.Value = Bool;
                        Toggle:Display();

                        for _, Addon in next, Toggle.Addons do
                            if Addon.Type == 'KeyPicker' and Addon.SyncToggleState then
                                Addon.Toggled = Bool
                                Addon:Update()
                            end
                        end

                        Library:SafeCallback(Toggle.Callback, Toggle.Value);
                        Library:SafeCallback(Toggle.Changed, Toggle.Value);
                        Library:UpdateDependencyBoxes();
                    end;

                    ToggleRegion.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                            Toggle:SetValue(not Toggle.Value) -- Why was it not like this from the start?
                            Library:AttemptSave();
                        end;
                    end);

                    if Toggle.Risky then
                        Library:RemoveFromRegistry(ToggleLabel)
                        ToggleLabel.TextColor3 = Library.RiskColor
                        Library:AddToRegistry(ToggleLabel, { TextColor3 = 'RiskColor' })
                    end

                    Toggle:Display();
                    Groupbox:AddBlank(Info.BlankSize or 5 + 2);
                    Groupbox:Resize();

                    Toggle.TextLabel = ToggleLabel;
                    Toggle.Container = Container;
                    setmetatable(Toggle, BaseAddons);

                    Toggles[Idx] = Toggle;

                    Library:UpdateDependencyBoxes();

                    return Toggle;
                end;

                function Funcs:AddSlider(Idx, Info)
                    assert(Info.Default, 'AddSlider: Missing default value.');
                    assert(Info.Text, 'AddSlider: Missing slider text.');
                    assert(Info.Min, 'AddSlider: Missing minimum value.');
                    assert(Info.Max, 'AddSlider: Missing maximum value.');
                    assert(Info.Rounding, 'AddSlider: Missing rounding value.');

                    local Slider = {
                        Value = Info.Default;
                        Min = Info.Min;
                        Max = Info.Max;
                        Rounding = Info.Rounding;
                        MaxSize = 232;
                        Type = 'Slider';
                        Callback = Info.Callback or function(Value) end;
                    };

                    local Groupbox = self;
                    local Container = Groupbox.Container;

                    if not Info.Compact then
                        Library:CreateLabel({
                            Size = UDim2.new(1, 0, 0, 10);
                            TextSize = 13;
                            Text = Info.Text;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            TextYAlignment = Enum.TextYAlignment.Bottom;
                            ZIndex = 5;
                            Parent = Container;
                        });

                        Groupbox:AddBlank(3);
                    end

                    local SliderOuter = Library:Create('Frame', {
                        BackgroundColor3 = Color3.new(0, 0, 0);
                        BorderColor3 = Color3.new(0, 0, 0);
                        Size = UDim2.new(1, -4, 0, 13);
                        ZIndex = 5;
                        Parent = Container;
                    });

                    Library:AddToRegistry(SliderOuter, {
                        BorderColor3 = 'Black';
                    });

                    local SliderInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.MainColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 6;
                        Parent = SliderOuter;
                    });

                    Library:AddToRegistry(SliderInner, {
                        BackgroundColor3 = 'MainColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    local Fill = Library:Create('Frame', {
                        BackgroundColor3 = Library.AccentColor;
                        BorderColor3 = Library.AccentColorDark;
                        Size = UDim2.new(0, 0, 1, 0);
                        ZIndex = 7;
                        Parent = SliderInner;
                    });

                    Library:AddToRegistry(Fill, {
                        BackgroundColor3 = 'AccentColor';
                        BorderColor3 = 'AccentColorDark';
                    });

                    local HideBorderRight = Library:Create('Frame', {
                        BackgroundColor3 = Library.AccentColor;
                        BorderSizePixel = 0;
                        Position = UDim2.new(1, 0, 0, 0);
                        Size = UDim2.new(0, 1, 1, 0);
                        ZIndex = 8;
                        Parent = Fill;
                    });

                    Library:AddToRegistry(HideBorderRight, {
                        BackgroundColor3 = 'AccentColor';
                    });

                    local DisplayLabel = Library:CreateLabel({
                        Size = UDim2.new(1, 0, 1, 0);
                        TextSize = 13;
                        Text = 'Infinite';
                        ZIndex = 9;
                        Parent = SliderInner;
                    });

                    Library:OnHighlight(SliderOuter, SliderOuter,
                        { BorderColor3 = 'AccentColor' },
                        { BorderColor3 = 'Black' }
                    );

                    if type(Info.Tooltip) == 'string' then
                        Library:AddToolTip(Info.Tooltip, SliderOuter)
                    end

                    function Slider:UpdateColors()
                        Fill.BackgroundColor3 = Library.AccentColor;
                        Fill.BorderColor3 = Library.AccentColorDark;
                    end;

                    function Slider:Display()
                        local Suffix = Info.Suffix or '';

                        if Info.Compact then
                            DisplayLabel.Text = Info.Text .. ': ' .. Slider.Value .. Suffix
                        elseif Info.HideMax then
                            DisplayLabel.Text = string.format('%s', Slider.Value .. Suffix)
                        else
                            DisplayLabel.Text = string.format('%s/%s', Slider.Value .. Suffix, Slider.Max .. Suffix);
                        end

                        local X = math.ceil(Library:MapValue(Slider.Value, Slider.Min, Slider.Max, 0, Slider.MaxSize));
                        Fill.Size = UDim2.new(0, X, 1, 0);

                        HideBorderRight.Visible = not (X == Slider.MaxSize or X == 0);
                    end;

                    function Slider:OnChanged(Func)
                        Slider.Changed = Func;
                        Func(Slider.Value);
                    end;

                    local function Round(Value)
                        if Slider.Rounding == 0 then
                            return math.floor(Value);
                        end;


                        return tonumber(string.format('%.' .. Slider.Rounding .. 'f', Value))
                    end;

                    function Slider:GetValueFromXOffset(X)
                        return Round(Library:MapValue(X, 0, Slider.MaxSize, Slider.Min, Slider.Max));
                    end;

                    function Slider:SetValue(Str)
                        local Num = tonumber(Str);

                        if (not Num) then
                            return;
                        end;

                        Num = math.clamp(Num, Slider.Min, Slider.Max);

                        Slider.Value = Num;
                        Slider:Display();

                        Library:SafeCallback(Slider.Callback, Slider.Value);
                        Library:SafeCallback(Slider.Changed, Slider.Value);
                    end;

                    SliderInner.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                            local mPos = Mouse.X;
                            local gPos = Fill.Size.X.Offset;
                            local Diff = mPos - (Fill.AbsolutePosition.X + gPos);

                            while InputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                local nMPos = Mouse.X;
                                local nX = math.clamp(gPos + (nMPos - mPos) + Diff, 0, Slider.MaxSize);

                                local nValue = Slider:GetValueFromXOffset(nX);
                                local OldValue = Slider.Value;
                                Slider.Value = nValue;

                                Slider:Display();

                                if nValue ~= OldValue then
                                    Library:SafeCallback(Slider.Callback, Slider.Value);
                                    Library:SafeCallback(Slider.Changed, Slider.Value);
                                end;

                                RenderStepped:Wait();
                            end;

                            Library:AttemptSave();
                        end;
                    end);

                    Slider:Display();
                    Groupbox:AddBlank(Info.BlankSize or 6);
                    Groupbox:Resize();

                    Options[Idx] = Slider;

                    return Slider;
                end;

                function Funcs:AddDropdown(Idx, Info)
                    if Info.SpecialType == 'Player' then
                        Info.Values = GetPlayersString();
                        Info.AllowNull = true;
                    elseif Info.SpecialType == 'Team' then
                        Info.Values = GetTeamsString();
                        Info.AllowNull = true;
                    end;

                    assert(Info.Values, 'AddDropdown: Missing dropdown value list.');
                    assert(Info.AllowNull or Info.Default, 'AddDropdown: Missing default value. Pass `AllowNull` as true if this was intentional.')

                    if (not Info.Text) then
                        Info.Compact = true;
                    end;

                    local Dropdown = {
                        Values = Info.Values;
                        Value = Info.Multi and {};
                        Multi = Info.Multi;
                        Type = 'Dropdown';
                        SpecialType = Info.SpecialType; -- can be either 'Player' or 'Team'
                        Callback = Info.Callback or function(Value) end;
                    };

                    local Groupbox = self;
                    local Container = Groupbox.Container;

                    local RelativeOffset = 0;

                    if not Info.Compact then
                        local DropdownLabel = Library:CreateLabel({
                            Size = UDim2.new(1, 0, 0, 10);
                            TextSize = 13;
                            Text = Info.Text;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            TextYAlignment = Enum.TextYAlignment.Bottom;
                            ZIndex = 5;
                            Parent = Container;
                        });

                        Groupbox:AddBlank(3);
                    end

                    for _, Element in next, Container:GetChildren() do
                        if not Element:IsA('UIListLayout') then
                            RelativeOffset = RelativeOffset + Element.Size.Y.Offset;
                        end;
                    end;

                    local DropdownOuter = Library:Create('Frame', {
                        BackgroundColor3 = Color3.new(0, 0, 0);
                        BorderColor3 = Color3.new(0, 0, 0);
                        Size = UDim2.new(1, -4, 0, 20);
                        ZIndex = 5;
                        Parent = Container;
                    });

                    Library:AddToRegistry(DropdownOuter, {
                        BorderColor3 = 'Black';
                    });

                    local DropdownInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.MainColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 6;
                        Parent = DropdownOuter;
                    });

                    Library:AddToRegistry(DropdownInner, {
                        BackgroundColor3 = 'MainColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    Library:Create('UIGradient', {
                        Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(212, 212, 212))
                        });
                        Rotation = 90;
                        Parent = DropdownInner;
                    });

                    local DropdownArrow = Library:Create('ImageLabel', {
                        AnchorPoint = Vector2.new(0, 0.5);
                        BackgroundTransparency = 1;
                        Position = UDim2.new(1, -16, 0.5, 0);
                        Size = UDim2.new(0, 12, 0, 12);
                        Image = 'http://www.roblox.com/asset/?id=6282522798';
                        ZIndex = 8;
                        Parent = DropdownInner;
                    });

                    local ItemList = Library:CreateLabel({
                        Position = UDim2.new(0, 5, 0, 0);
                        Size = UDim2.new(1, -5, 1, 0);
                        TextSize = 13;
                        Text = '--';
                        TextXAlignment = Enum.TextXAlignment.Left;
                        TextWrapped = true;
                        ZIndex = 7;
                        Parent = DropdownInner;
                    });

                    Library:OnHighlight(DropdownOuter, DropdownOuter,
                        { BorderColor3 = 'AccentColor' },
                        { BorderColor3 = 'Black' }
                    );

                    if type(Info.Tooltip) == 'string' then
                        Library:AddToolTip(Info.Tooltip, DropdownOuter)
                    end

                    local MAX_DROPDOWN_ITEMS = 8;

                    local ListOuter = Library:Create('Frame', {
                        BackgroundColor3 = Color3.new(0, 0, 0);
                        BorderColor3 = Color3.new(0, 0, 0);
                        ZIndex = 20;
                        Visible = false;
                        Parent = ScreenGui;
                    });

                    local function RecalculateListPosition()
                        ListOuter.Position = UDim2.fromOffset(DropdownOuter.AbsolutePosition.X, DropdownOuter.AbsolutePosition.Y + DropdownOuter.Size.Y.Offset + 1);
                    end;

                    local function RecalculateListSize(YSize)
                        ListOuter.Size = UDim2.fromOffset(DropdownOuter.AbsoluteSize.X, YSize or (MAX_DROPDOWN_ITEMS * 20 + 2))
                    end;

                    RecalculateListPosition();
                    RecalculateListSize();

                    DropdownOuter:GetPropertyChangedSignal('AbsolutePosition'):Connect(RecalculateListPosition);

                    local ListInner = Library:Create('Frame', {
                        BackgroundColor3 = Library.MainColor;
                        BorderColor3 = Library.OutlineColor;
                        BorderMode = Enum.BorderMode.Inset;
                        BorderSizePixel = 0;
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 21;
                        Parent = ListOuter;
                    });

                    Library:AddToRegistry(ListInner, {
                        BackgroundColor3 = 'MainColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    local Scrolling = Library:Create('ScrollingFrame', {
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        CanvasSize = UDim2.new(0, 0, 0, 0);
                        Size = UDim2.new(1, 0, 1, 0);
                        ZIndex = 21;
                        Parent = ListInner;

                        TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',
                        BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png',

                        ScrollBarThickness = 3,
                        ScrollBarImageColor3 = Library.AccentColor,
                    });

                    Library:AddToRegistry(Scrolling, {
                        ScrollBarImageColor3 = 'AccentColor'
                    })

                    Library:Create('UIListLayout', {
                        Padding = UDim.new(0, 0);
                        FillDirection = Enum.FillDirection.Vertical;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        Parent = Scrolling;
                    });

                    function Dropdown:Display()
                        local Values = Dropdown.Values;
                        local Str = '';

                        if Info.Multi then
                            for Idx, Value in next, Values do
                                if Dropdown.Value[Value] then
                                    Str = Str .. Value .. ', ';
                                end;
                            end;

                            Str = Str:sub(1, #Str - 2);
                        else
                            Str = Dropdown.Value or '';
                        end;

                        ItemList.Text = (Str == '' and '--' or Str);
                    end;

                    function Dropdown:GetActiveValues()
                        if Info.Multi then
                            local T = {};

                            for Value, Bool in next, Dropdown.Value do
                                table.insert(T, Value);
                            end;

                            return T;
                        else
                            return Dropdown.Value and 1 or 0;
                        end;
                    end;

                    function Dropdown:BuildDropdownList()
                        local Values = Dropdown.Values;
                        local Buttons = {};

                        for _, Element in next, Scrolling:GetChildren() do
                            if not Element:IsA('UIListLayout') then
                                Element:Destroy();
                            end;
                        end;

                        local Count = 0;

                        for Idx, Value in next, Values do
                            local Table = {};

                            Count = Count + 1;

                            local Button = Library:Create('Frame', {
                                BackgroundColor3 = Library.MainColor;
                                BorderColor3 = Library.OutlineColor;
                                BorderMode = Enum.BorderMode.Middle;
                                Size = UDim2.new(1, -1, 0, 20);
                                ZIndex = 23;
                                Active = true,
                                Parent = Scrolling;
                            });

                            Library:AddToRegistry(Button, {
                                BackgroundColor3 = 'MainColor';
                                BorderColor3 = 'OutlineColor';
                            });

                            local ButtonLabel = Library:CreateLabel({
                                Active = false;
                                Size = UDim2.new(1, -6, 1, 0);
                                Position = UDim2.new(0, 6, 0, 0);
                                TextSize = 13;
                                Text = Value;
                                TextXAlignment = Enum.TextXAlignment.Left;
                                ZIndex = 25;
                                Parent = Button;
                            });

                            Library:OnHighlight(Button, Button,
                                { BorderColor3 = 'AccentColor', ZIndex = 24 },
                                { BorderColor3 = 'OutlineColor', ZIndex = 23 }
                            );

                            local Selected;

                            if Info.Multi then
                                Selected = Dropdown.Value[Value];
                            else
                                Selected = Dropdown.Value == Value;
                            end;

                            function Table:UpdateButton()
                                if Info.Multi then
                                    Selected = Dropdown.Value[Value];
                                else
                                    Selected = Dropdown.Value == Value;
                                end;

                                ButtonLabel.TextColor3 = Selected and Library.AccentColor or Library.FontColor;
                                Library.RegistryMap[ButtonLabel].Properties.TextColor3 = Selected and 'AccentColor' or 'FontColor';
                            end;

                            ButtonLabel.InputBegan:Connect(function(Input)
                                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    local Try = not Selected;

                                    if Dropdown:GetActiveValues() == 1 and (not Try) and (not Info.AllowNull) then
                                    else
                                        if Info.Multi then
                                            Selected = Try;

                                            if Selected then
                                                Dropdown.Value[Value] = true;
                                            else
                                                Dropdown.Value[Value] = nil;
                                            end;
                                        else
                                            Selected = Try;

                                            if Selected then
                                                Dropdown.Value = Value;
                                            else
                                                Dropdown.Value = nil;
                                            end;

                                            for _, OtherButton in next, Buttons do
                                                OtherButton:UpdateButton();
                                            end;
                                        end;

                                        Table:UpdateButton();
                                        Dropdown:Display();

                                        Library:SafeCallback(Dropdown.Callback, Dropdown.Value);
                                        Library:SafeCallback(Dropdown.Changed, Dropdown.Value);

                                        Library:AttemptSave();
                                    end;
                                end;
                            end);

                            Table:UpdateButton();
                            Dropdown:Display();

                            Buttons[Button] = Table;
                        end;

                        Scrolling.CanvasSize = UDim2.fromOffset(0, (Count * 20) + 1);

                        local Y = math.clamp(Count * 20, 0, MAX_DROPDOWN_ITEMS * 20) + 1;
                        RecalculateListSize(Y);
                    end;

                    function Dropdown:SetValues(NewValues)
                        if NewValues then
                            Dropdown.Values = NewValues;
                        end;

                        Dropdown:BuildDropdownList();
                    end;

                    function Dropdown:OpenDropdown()
                        ListOuter.Visible = true;
                        Library.OpenedFrames[ListOuter] = true;
                        DropdownArrow.Rotation = 180;
                    end;

                    function Dropdown:CloseDropdown()
                        ListOuter.Visible = false;
                        Library.OpenedFrames[ListOuter] = nil;
                        DropdownArrow.Rotation = 0;
                    end;

                    function Dropdown:OnChanged(Func)
                        Dropdown.Changed = Func;
                        Func(Dropdown.Value);
                    end;

                    function Dropdown:SetValue(Val)
                        if Dropdown.Multi then
                            local nTable = {};

                            for Value, Bool in next, Val do
                                if table.find(Dropdown.Values, Value) then
                                    nTable[Value] = true
                                end;
                            end;

                            Dropdown.Value = nTable;
                        else
                            if (not Val) then
                                Dropdown.Value = nil;
                            elseif table.find(Dropdown.Values, Val) then
                                Dropdown.Value = Val;
                            end;
                        end;

                        Dropdown:BuildDropdownList();

                        Library:SafeCallback(Dropdown.Callback, Dropdown.Value);
                        Library:SafeCallback(Dropdown.Changed, Dropdown.Value);
                    end;

                    DropdownOuter.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                            if ListOuter.Visible then
                                Dropdown:CloseDropdown();
                            else
                                Dropdown:OpenDropdown();
                            end;
                        end;
                    end);

                    InputService.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            local AbsPos, AbsSize = ListOuter.AbsolutePosition, ListOuter.AbsoluteSize;

                            if Mouse.X < AbsPos.X or Mouse.X > AbsPos.X + AbsSize.X
                                or Mouse.Y < (AbsPos.Y - 20 - 1) or Mouse.Y > AbsPos.Y + AbsSize.Y then

                                Dropdown:CloseDropdown();
                            end;
                        end;
                    end);

                    Dropdown:BuildDropdownList();
                    Dropdown:Display();

                    local Defaults = {}

                    if type(Info.Default) == 'string' then
                        local Idx = table.find(Dropdown.Values, Info.Default)
                        if Idx then
                            table.insert(Defaults, Idx)
                        end
                    elseif type(Info.Default) == 'table' then
                        for _, Value in next, Info.Default do
                            local Idx = table.find(Dropdown.Values, Value)
                            if Idx then
                                table.insert(Defaults, Idx)
                            end
                        end
                    elseif type(Info.Default) == 'number' and Dropdown.Values[Info.Default] ~= nil then
                        table.insert(Defaults, Info.Default)
                    end

                    if next(Defaults) then
                        for i = 1, #Defaults do
                            local Index = Defaults[i]
                            if Info.Multi then
                                Dropdown.Value[Dropdown.Values[Index]] = true
                            else
                                Dropdown.Value = Dropdown.Values[Index];
                            end

                            if (not Info.Multi) then break end
                        end

                        Dropdown:BuildDropdownList();
                        Dropdown:Display();
                    end

                    Groupbox:AddBlank(Info.BlankSize or 5);
                    Groupbox:Resize();

                    Options[Idx] = Dropdown;

                    return Dropdown;
                end;

                function Funcs:AddDependencyBox()
                    local Depbox = {
                        Dependencies = {};
                    };

                    local Groupbox = self;
                    local Container = Groupbox.Container;

                    local Holder = Library:Create('Frame', {
                        BackgroundTransparency = 1;
                        Size = UDim2.new(1, 0, 0, 0);
                        Visible = false;
                        Parent = Container;
                    });

                    local Frame = Library:Create('Frame', {
                        BackgroundTransparency = 1;
                        Size = UDim2.new(1, 0, 1, 0);
                        Visible = true;
                        Parent = Holder;
                    });

                    local Layout = Library:Create('UIListLayout', {
                        FillDirection = Enum.FillDirection.Vertical;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        Parent = Frame;
                    });

                    function Depbox:Resize()
                        Holder.Size = UDim2.new(1, 0, 0, Layout.AbsoluteContentSize.Y);
                        Groupbox:Resize();
                    end;

                    Layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                        Depbox:Resize();
                    end);

                    Holder:GetPropertyChangedSignal('Visible'):Connect(function()
                        Depbox:Resize();
                    end);

                    function Depbox:Update()
                        for _, Dependency in next, Depbox.Dependencies do
                            local Elem = Dependency[1];
                            local Value = Dependency[2];

                            if Elem.Type == 'Toggle' and Elem.Value ~= Value then
                                Holder.Visible = false;
                                Depbox:Resize();
                                return;
                            end;
                        end;

                        Holder.Visible = true;
                        Depbox:Resize();
                    end;

                    function Depbox:SetupDependencies(Dependencies)
                        for _, Dependency in next, Dependencies do
                            assert(type(Dependency) == 'table', 'SetupDependencies: Dependency is not of type `table`.');
                            assert(Dependency[1], 'SetupDependencies: Dependency is missing element argument.');
                            assert(Dependency[2] ~= nil, 'SetupDependencies: Dependency is missing value argument.');
                        end;

                        Depbox.Dependencies = Dependencies;
                        Depbox:Update();
                    end;

                    Depbox.Container = Frame;

                    setmetatable(Depbox, BaseGroupbox);

                    table.insert(Library.DependencyBoxes, Depbox);

                    return Depbox;
                end;

                BaseGroupbox.__index = Funcs;
                BaseGroupbox.__namecall = function(Table, Key, ...)
                    return Funcs[Key](...);
                end;
            end;

            -- < Create other UI elements >
            do
                Library.NotificationArea = Library:Create('Frame', {
                    BackgroundTransparency = 1;
                    Position = UDim2.new(0, 0, 0, 40);
                    Size = UDim2.new(0, 300, 0, 200);
                    ZIndex = 100;
                    Parent = ScreenGui;
                });

                Library:Create('UIListLayout', {
                    Padding = UDim.new(0, 4);
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Parent = Library.NotificationArea;
                });

                local WatermarkOuter = Library:Create('Frame', {
                    BorderColor3 = Color3.new(0, 0, 0);
                    Position = UDim2.new(0, 100, 0, -25);
                    Size = UDim2.new(0, 213, 0, 20);
                    ZIndex = 200;
                    Visible = false;
                    Parent = ScreenGui;
                });

                local WatermarkInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.AccentColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 201;
                    Parent = WatermarkOuter;
                });

                Library:AddToRegistry(WatermarkInner, {
                    BorderColor3 = 'AccentColor';
                });

                local InnerFrame = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(1, 1, 1);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 1, 0, 1);
                    Size = UDim2.new(1, -2, 1, -2);
                    ZIndex = 202;
                    Parent = WatermarkInner;
                });

                local Gradient = Library:Create('UIGradient', {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                        ColorSequenceKeypoint.new(1, Library.MainColor),
                    });
                    Rotation = -90;
                    Parent = InnerFrame;
                });

                Library:AddToRegistry(Gradient, {
                    Color = function()
                        return ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                            ColorSequenceKeypoint.new(1, Library.MainColor),
                        });
                    end
                });

                local WatermarkLabel = Library:CreateLabel({
                    Position = UDim2.new(0, 5, 0, 0);
                    Size = UDim2.new(1, -4, 1, 0);
                    TextSize = 13;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 203;
                    Parent = InnerFrame;
                });

                Library.Watermark = WatermarkOuter;
                Library.WatermarkText = WatermarkLabel;
                Library:MakeDraggable(Library.Watermark);



                local KeybindOuter = Library:Create('Frame', {
                    AnchorPoint = Vector2.new(0, 0.5);
                    BorderColor3 = Color3.new(0, 0, 0);
                    Position = UDim2.new(0, 10, 0.5, 0);
                    Size = UDim2.new(0, 210, 0, 20);
                    Visible = false;
                    ZIndex = 100;
                    Parent = ScreenGui;
                });

                local KeybindInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 101;
                    Parent = KeybindOuter;
                });

                Library:AddToRegistry(KeybindInner, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                }, true);

                local ColorFrame = Library:Create('Frame', {
                    BackgroundColor3 = Library.AccentColor;
                    BorderSizePixel = 0;
                    Size = UDim2.new(1, 0, 0, 2);
                    ZIndex = 102;
                    Parent = KeybindInner;
                });

                Library:AddToRegistry(ColorFrame, {
                    BackgroundColor3 = 'AccentColor';
                }, true);

                local KeybindLabel = Library:CreateLabel({
                    Size = UDim2.new(1, 0, 0, 20);
                    Position = UDim2.fromOffset(5, 2),
                    TextXAlignment = Enum.TextXAlignment.Left,

                    Text = 'Keybinds';
                    ZIndex = 104;
                    Parent = KeybindInner;
                });

                local KeybindContainer = Library:Create('Frame', {
                    BackgroundTransparency = 1;
                    Size = UDim2.new(1, 0, 1, -20);
                    Position = UDim2.new(0, 0, 0, 20);
                    ZIndex = 1;
                    Parent = KeybindInner;
                });

                Library:Create('UIListLayout', {
                    FillDirection = Enum.FillDirection.Vertical;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Parent = KeybindContainer;
                });

                Library:Create('UIPadding', {
                    PaddingLeft = UDim.new(0, 5),
                    Parent = KeybindContainer,
                })

                Library.KeybindFrame = KeybindOuter;
                Library.KeybindContainer = KeybindContainer;
                Library:MakeDraggable(KeybindOuter);
            end;

            function Library:SetWatermarkVisibility(Bool)
                Library.Watermark.Visible = Bool;
            end;

            function Library:SetWatermark(Text)
                local X, Y = Library:GetTextBounds(Text, Library.Font, 14);
                Library.Watermark.Size = UDim2.new(0, X + 15, 0, (Y * 1.5) + 3);
                Library:SetWatermarkVisibility(true)

                Library.WatermarkText.Text = Text;
            end;

            function Library:Notify(Text, Time)
                local XSize, YSize = Library:GetTextBounds(Text, Library.Font, 14);

                YSize = YSize + 7

                local NotifyOuter = Library:Create('Frame', {
                    BorderColor3 = Color3.new(0, 0, 0);
                    Position = UDim2.new(0, 100, 0, 10);
                    Size = UDim2.new(0, 0, 0, YSize);
                    ClipsDescendants = true;
                    ZIndex = 100;
                    Parent = Library.NotificationArea;
                });

                local NotifyInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 101;
                    Parent = NotifyOuter;
                });

                Library:AddToRegistry(NotifyInner, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                }, true);

                local InnerFrame = Library:Create('Frame', {
                    BackgroundColor3 = Color3.new(1, 1, 1);
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, 1, 0, 1);
                    Size = UDim2.new(1, -2, 1, -2);
                    ZIndex = 102;
                    Parent = NotifyInner;
                });

                local Gradient = Library:Create('UIGradient', {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                        ColorSequenceKeypoint.new(1, Library.MainColor),
                    });
                    Rotation = -90;
                    Parent = InnerFrame;
                });

                Library:AddToRegistry(Gradient, {
                    Color = function()
                        return ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Library:GetDarkerColor(Library.MainColor)),
                            ColorSequenceKeypoint.new(1, Library.MainColor),
                        });
                    end
                });

                local NotifyLabel = Library:CreateLabel({
                    Position = UDim2.new(0, 4, 0, 0);
                    Size = UDim2.new(1, -4, 1, 0);
                    Text = Text;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextSize = 13;
                    ZIndex = 103;
                    Parent = InnerFrame;
                });

                local LeftColor = Library:Create('Frame', {
                    BackgroundColor3 = Library.AccentColor;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0, -1, 0, -1);
                    Size = UDim2.new(0, 3, 1, 2);
                    ZIndex = 104;
                    Parent = NotifyOuter;
                });

                Library:AddToRegistry(LeftColor, {
                    BackgroundColor3 = 'AccentColor';
                }, true);

                pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, XSize + 8 + 4, 0, YSize), 'Out', 'Quad', 0.4, true);

                task.spawn(function()
                    wait(Time or 5);

                    pcall(NotifyOuter.TweenSize, NotifyOuter, UDim2.new(0, 0, 0, YSize), 'Out', 'Quad', 0.4, true);

                    wait(0.4);

                    NotifyOuter:Destroy();
                end);
            end;

            function Library:CreateWindow(...)
                local Arguments = { ... }
                local Config = { AnchorPoint = Vector2.zero }

                if type(...) == 'table' then
                    Config = ...;
                else
                    Config.Title = Arguments[1]
                    Config.AutoShow = Arguments[2] or false;
                end

                if type(Config.Title) ~= 'string' then Config.Title = 'No title' end
                if type(Config.TabPadding) ~= 'number' then Config.TabPadding = 0 end
                if type(Config.MenuFadeTime) ~= 'number' then Config.MenuFadeTime = 0.2 end

                if typeof(Config.Position) ~= 'UDim2' then Config.Position = UDim2.fromOffset(175, 50) end
                if typeof(Config.Size) ~= 'UDim2' then Config.Size = UDim2.fromOffset(550, 600) end

                if Config.Center then
                    Config.AnchorPoint = Vector2.new(0.5, 0.5)
                    Config.Position = UDim2.fromScale(0.5, 0.5)
                end

                local Window = {
                    Tabs = {};
                };

                local Outer = Library:Create('Frame', {
                    AnchorPoint = Config.AnchorPoint,
                    BackgroundColor3 = Color3.new(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = Config.Position,
                    Size = Config.Size,
                    Visible = false;
                    ZIndex = 1;
                    Parent = ScreenGui;
                });

                Library:MakeDraggable(Outer, 25);

                local Inner = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.AccentColor;
                    BorderMode = Enum.BorderMode.Inset;
                    Position = UDim2.new(0, 1, 0, 1);
                    Size = UDim2.new(1, -2, 1, -2);
                    ZIndex = 1;
                    Parent = Outer;
                });

                Library:AddToRegistry(Inner, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'AccentColor';
                });

                local WindowLabel = Library:CreateLabel({
                    Position = UDim2.new(0, 7, 0, 0);
                    Size = UDim2.new(0, 0, 0, 25);
                    Text = Config.Title or '';
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 1;
                    Parent = Inner;
                });

                local MainSectionOuter = Library:Create('Frame', {
                    BackgroundColor3 = Library.BackgroundColor;
                    BorderColor3 = Library.OutlineColor;
                    Position = UDim2.new(0, 8, 0, 25);
                    Size = UDim2.new(1, -16, 1, -33);
                    ZIndex = 1;
                    Parent = Inner;
                });

                Library:AddToRegistry(MainSectionOuter, {
                    BackgroundColor3 = 'BackgroundColor';
                    BorderColor3 = 'OutlineColor';
                });

                local MainSectionInner = Library:Create('Frame', {
                    BackgroundColor3 = Library.BackgroundColor;
                    BorderColor3 = Color3.new(0, 0, 0);
                    BorderMode = Enum.BorderMode.Inset;
                    Position = UDim2.new(0, 0, 0, 0);
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 1;
                    Parent = MainSectionOuter;
                });

                Library:AddToRegistry(MainSectionInner, {
                    BackgroundColor3 = 'BackgroundColor';
                });

                local TabArea = Library:Create('Frame', {
                    BackgroundTransparency = 1;
                    Position = UDim2.new(0, 8, 0, 8);
                    Size = UDim2.new(1, -16, 0, 21);
                    ZIndex = 1;
                    Parent = MainSectionInner;
                });

                local TabListLayout = Library:Create('UIListLayout', {
                    Padding = UDim.new(0, Config.TabPadding);
                    FillDirection = Enum.FillDirection.Horizontal;
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    Parent = TabArea;
                });

                local TabContainer = Library:Create('Frame', {
                    BackgroundColor3 = Library.MainColor;
                    BorderColor3 = Library.OutlineColor;
                    Position = UDim2.new(0, 8, 0, 30);
                    Size = UDim2.new(1, -16, 1, -38);
                    ZIndex = 2;
                    Parent = MainSectionInner;
                });


                Library:AddToRegistry(TabContainer, {
                    BackgroundColor3 = 'MainColor';
                    BorderColor3 = 'OutlineColor';
                });

                function Window:SetWindowTitle(Title)
                    WindowLabel.Text = Title;
                end;

                function Window:AddTab(Name)
                    local Tab = {
                        Groupboxes = {};
                        Tabboxes = {};
                    };

                    local TabButtonWidth = Library:GetTextBounds(Name, Library.Font, 16);

                    local TabButton = Library:Create('Frame', {
                        BackgroundColor3 = Library.BackgroundColor;
                        BorderColor3 = Library.OutlineColor;
                        Size = UDim2.new(0, TabButtonWidth + 8 + 4, 1, 0);
                        ZIndex = 1;
                        Parent = TabArea;
                    });

                    Library:AddToRegistry(TabButton, {
                        BackgroundColor3 = 'BackgroundColor';
                        BorderColor3 = 'OutlineColor';
                    });

                    local TabButtonLabel = Library:CreateLabel({
                        Position = UDim2.new(0, 0, 0, 0);
                        Size = UDim2.new(1, 0, 1, -1);
                        Text = Name;
                        ZIndex = 1;
                        Parent = TabButton;
                    });

                    local Blocker = Library:Create('Frame', {
                        BackgroundColor3 = Library.MainColor;
                        BorderSizePixel = 0;
                        Position = UDim2.new(0, 0, 1, 0);
                        Size = UDim2.new(1, 0, 0, 1);
                        BackgroundTransparency = 1;
                        ZIndex = 3;
                        Parent = TabButton;
                    });

                    Library:AddToRegistry(Blocker, {
                        BackgroundColor3 = 'MainColor';
                    });

                    local TabFrame = Library:Create('Frame', {
                        Name = 'TabFrame',
                        BackgroundTransparency = 1;
                        Position = UDim2.new(0, 0, 0, 0);
                        Size = UDim2.new(1, 0, 1, 0);
                        Visible = false;
                        ZIndex = 2;
                        Parent = TabContainer;
                    });

                    local LeftSide = Library:Create('ScrollingFrame', {
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        Position = UDim2.new(0, 8 - 1, 0, 8 - 1);
                        Size = UDim2.new(0.5, -12 + 2, 0, 507 + 2);
                        CanvasSize = UDim2.new(0, 0, 0, 0);
                        BottomImage = '';
                        TopImage = '';
                        ScrollBarThickness = 0;
                        ZIndex = 2;
                        Parent = TabFrame;
                    });

                    local RightSide = Library:Create('ScrollingFrame', {
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        Position = UDim2.new(0.5, 4 + 1, 0, 8 - 1);
                        Size = UDim2.new(0.5, -12 + 2, 0, 507 + 2);
                        CanvasSize = UDim2.new(0, 0, 0, 0);
                        BottomImage = '';
                        TopImage = '';
                        ScrollBarThickness = 0;
                        ZIndex = 2;
                        Parent = TabFrame;
                    });

                    Library:Create('UIListLayout', {
                        Padding = UDim.new(0, 8);
                        FillDirection = Enum.FillDirection.Vertical;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        HorizontalAlignment = Enum.HorizontalAlignment.Center;
                        Parent = LeftSide;
                    });

                    Library:Create('UIListLayout', {
                        Padding = UDim.new(0, 8);
                        FillDirection = Enum.FillDirection.Vertical;
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        HorizontalAlignment = Enum.HorizontalAlignment.Center;
                        Parent = RightSide;
                    });

                    for _, Side in next, { LeftSide, RightSide } do
                        Side:WaitForChild('UIListLayout'):GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
                            Side.CanvasSize = UDim2.fromOffset(0, Side.UIListLayout.AbsoluteContentSize.Y);
                        end);
                    end;

                    function Tab:ShowTab()
                        for _, Tab in next, Window.Tabs do
                            Tab:HideTab();
                        end;

                        Blocker.BackgroundTransparency = 0;
                        TabButton.BackgroundColor3 = Library.MainColor;
                        Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'MainColor';
                        TabFrame.Visible = true;
                    end;

                    function Tab:HideTab()
                        Blocker.BackgroundTransparency = 1;
                        TabButton.BackgroundColor3 = Library.BackgroundColor;
                        Library.RegistryMap[TabButton].Properties.BackgroundColor3 = 'BackgroundColor';
                        TabFrame.Visible = false;
                    end;

                    function Tab:SetLayoutOrder(Position)
                        TabButton.LayoutOrder = Position;
                        TabListLayout:ApplyLayout();
                    end;

                    function Tab:AddGroupbox(Info)
                        local Groupbox = {};

                        local BoxOuter = Library:Create('Frame', {
                            BackgroundColor3 = Library.BackgroundColor;
                            BorderColor3 = Library.OutlineColor;
                            BorderMode = Enum.BorderMode.Inset;
                            Size = UDim2.new(1, 0, 0, 507 + 2);
                            ZIndex = 2;
                            Parent = Info.Side == 1 and LeftSide or RightSide;
                        });

                        Library:AddToRegistry(BoxOuter, {
                            BackgroundColor3 = 'BackgroundColor';
                            BorderColor3 = 'OutlineColor';
                        });

                        local BoxInner = Library:Create('Frame', {
                            BackgroundColor3 = Library.BackgroundColor;
                            BorderColor3 = Color3.new(0, 0, 0);
                            -- BorderMode = Enum.BorderMode.Inset;
                            Size = UDim2.new(1, -2, 1, -2);
                            Position = UDim2.new(0, 1, 0, 1);
                            ZIndex = 4;
                            Parent = BoxOuter;
                        });

                        Library:AddToRegistry(BoxInner, {
                            BackgroundColor3 = 'BackgroundColor';
                        });

                        local Highlight = Library:Create('Frame', {
                            BackgroundColor3 = Library.AccentColor;
                            BorderSizePixel = 0;
                            Size = UDim2.new(1, 0, 0, 2);
                            ZIndex = 5;
                            Parent = BoxInner;
                        });

                        Library:AddToRegistry(Highlight, {
                            BackgroundColor3 = 'AccentColor';
                        });

                        local GroupboxLabel = Library:CreateLabel({
                            Size = UDim2.new(1, 0, 0, 18);
                            Position = UDim2.new(0, 4, 0, 2);
                            TextSize = 13;
                            Text = Info.Name;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            ZIndex = 5;
                            Parent = BoxInner;
                        });

                        local Container = Library:Create('Frame', {
                            BackgroundTransparency = 1;
                            Position = UDim2.new(0, 4, 0, 20);
                            Size = UDim2.new(1, -4, 1, -20);
                            ZIndex = 1;
                            Parent = BoxInner;
                        });

                        Library:Create('UIListLayout', {
                            FillDirection = Enum.FillDirection.Vertical;
                            SortOrder = Enum.SortOrder.LayoutOrder;
                            Parent = Container;
                        });

                        function Groupbox:Resize()
                            local Size = 0;

                            for _, Element in next, Groupbox.Container:GetChildren() do
                                if (not Element:IsA('UIListLayout')) and Element.Visible then
                                    Size = Size + Element.Size.Y.Offset;
                                end;
                            end;

                            BoxOuter.Size = UDim2.new(1, 0, 0, 20 + Size + 2 + 2);
                        end;

                        Groupbox.Container = Container;
                        setmetatable(Groupbox, BaseGroupbox);

                        Groupbox:AddBlank(3);
                        Groupbox:Resize();

                        Tab.Groupboxes[Info.Name] = Groupbox;

                        return Groupbox;
                    end;

                    function Tab:AddLeftGroupbox(Name)
                        return Tab:AddGroupbox({ Side = 1; Name = Name; });
                    end;

                    function Tab:AddRightGroupbox(Name)
                        return Tab:AddGroupbox({ Side = 2; Name = Name; });
                    end;

                    function Tab:AddTabbox(Info)
                        local Tabbox = {
                            Tabs = {};
                        };

                        local BoxOuter = Library:Create('Frame', {
                            BackgroundColor3 = Library.BackgroundColor;
                            BorderColor3 = Library.OutlineColor;
                            BorderMode = Enum.BorderMode.Inset;
                            Size = UDim2.new(1, 0, 0, 0);
                            ZIndex = 2;
                            Parent = Info.Side == 1 and LeftSide or RightSide;
                        });

                        Library:AddToRegistry(BoxOuter, {
                            BackgroundColor3 = 'BackgroundColor';
                            BorderColor3 = 'OutlineColor';
                        });

                        local BoxInner = Library:Create('Frame', {
                            BackgroundColor3 = Library.BackgroundColor;
                            BorderColor3 = Color3.new(0, 0, 0);
                            -- BorderMode = Enum.BorderMode.Inset;
                            Size = UDim2.new(1, -2, 1, -2);
                            Position = UDim2.new(0, 1, 0, 1);
                            ZIndex = 4;
                            Parent = BoxOuter;
                        });

                        Library:AddToRegistry(BoxInner, {
                            BackgroundColor3 = 'BackgroundColor';
                        });

                        local Highlight = Library:Create('Frame', {
                            BackgroundColor3 = Library.AccentColor;
                            BorderSizePixel = 0;
                            Size = UDim2.new(1, 0, 0, 2);
                            ZIndex = 10;
                            Parent = BoxInner;
                        });

                        Library:AddToRegistry(Highlight, {
                            BackgroundColor3 = 'AccentColor';
                        });

                        local TabboxButtons = Library:Create('Frame', {
                            BackgroundTransparency = 1;
                            Position = UDim2.new(0, 0, 0, 1);
                            Size = UDim2.new(1, 0, 0, 18);
                            ZIndex = 5;
                            Parent = BoxInner;
                        });

                        Library:Create('UIListLayout', {
                            FillDirection = Enum.FillDirection.Horizontal;
                            HorizontalAlignment = Enum.HorizontalAlignment.Left;
                            SortOrder = Enum.SortOrder.LayoutOrder;
                            Parent = TabboxButtons;
                        });

                        function Tabbox:AddTab(Name)
                            local Tab = {};

                            local Button = Library:Create('Frame', {
                                BackgroundColor3 = Library.MainColor;
                                BorderColor3 = Color3.new(0, 0, 0);
                                Size = UDim2.new(0.5, 0, 1, 0);
                                ZIndex = 6;
                                Parent = TabboxButtons;
                            });

                            Library:AddToRegistry(Button, {
                                BackgroundColor3 = 'MainColor';
                            });

                            local ButtonLabel = Library:CreateLabel({
                                Size = UDim2.new(1, 0, 1, 0);
                                TextSize = 13;
                                Text = Name;
                                TextXAlignment = Enum.TextXAlignment.Center;
                                ZIndex = 7;
                                Parent = Button;
                            });

                            local Block = Library:Create('Frame', {
                                BackgroundColor3 = Library.BackgroundColor;
                                BorderSizePixel = 0;
                                Position = UDim2.new(0, 0, 1, 0);
                                Size = UDim2.new(1, 0, 0, 1);
                                Visible = false;
                                ZIndex = 9;
                                Parent = Button;
                            });

                            Library:AddToRegistry(Block, {
                                BackgroundColor3 = 'BackgroundColor';
                            });

                            local Container = Library:Create('Frame', {
                                BackgroundTransparency = 1;
                                Position = UDim2.new(0, 4, 0, 20);
                                Size = UDim2.new(1, -4, 1, -20);
                                ZIndex = 1;
                                Visible = false;
                                Parent = BoxInner;
                            });

                            Library:Create('UIListLayout', {
                                FillDirection = Enum.FillDirection.Vertical;
                                SortOrder = Enum.SortOrder.LayoutOrder;
                                Parent = Container;
                            });

                            function Tab:Show()
                                for _, Tab in next, Tabbox.Tabs do
                                    Tab:Hide();
                                end;

                                Container.Visible = true;
                                Block.Visible = true;

                                Button.BackgroundColor3 = Library.BackgroundColor;
                                Library.RegistryMap[Button].Properties.BackgroundColor3 = 'BackgroundColor';

                                Tab:Resize();
                            end;

                            function Tab:Hide()
                                Container.Visible = false;
                                Block.Visible = false;

                                Button.BackgroundColor3 = Library.MainColor;
                                Library.RegistryMap[Button].Properties.BackgroundColor3 = 'MainColor';
                            end;

                            function Tab:Resize()
                                local TabCount = 0;

                                for _, Tab in next, Tabbox.Tabs do
                                    TabCount = TabCount + 1;
                                end;

                                for _, Button in next, TabboxButtons:GetChildren() do
                                    if not Button:IsA('UIListLayout') then
                                        Button.Size = UDim2.new(1 / TabCount, 0, 1, 0);
                                    end;
                                end;

                                if (not Container.Visible) then
                                    return;
                                end;

                                local Size = 0;

                                for _, Element in next, Tab.Container:GetChildren() do
                                    if (not Element:IsA('UIListLayout')) and Element.Visible then
                                        Size = Size + Element.Size.Y.Offset;
                                    end;
                                end;

                                BoxOuter.Size = UDim2.new(1, 0, 0, 20 + Size + 2 + 2);
                            end;

                            Button.InputBegan:Connect(function(Input)
                                if Input.UserInputType == Enum.UserInputType.MouseButton1 and not Library:MouseIsOverOpenedFrame() then
                                    Tab:Show();
                                    Tab:Resize();
                                end;
                            end);

                            Tab.Container = Container;
                            Tabbox.Tabs[Name] = Tab;

                            setmetatable(Tab, BaseGroupbox);

                            Tab:AddBlank(3);
                            Tab:Resize();

                            -- Show first tab (number is 2 cus of the UIListLayout that also sits in that instance)
                            if #TabboxButtons:GetChildren() == 2 then
                                Tab:Show();
                            end;

                            return Tab;
                        end;

                        Tab.Tabboxes[Info.Name or ''] = Tabbox;

                        return Tabbox;
                    end;

                    function Tab:AddLeftTabbox(Name)
                        return Tab:AddTabbox({ Name = Name, Side = 1; });
                    end;

                    function Tab:AddRightTabbox(Name)
                        return Tab:AddTabbox({ Name = Name, Side = 2; });
                    end;

                    TabButton.InputBegan:Connect(function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Tab:ShowTab();
                        end;
                    end);

                    -- This was the first tab added, so we show it by default.
                    if #TabContainer:GetChildren() == 1 then
                        Tab:ShowTab();
                    end;

                    Window.Tabs[Name] = Tab;
                    return Tab;
                end;

                local ModalElement = Library:Create('TextButton', {
                    BackgroundTransparency = 1;
                    Size = UDim2.new(0, 0, 0, 0);
                    Visible = true;
                    Text = '';
                    Modal = false;
                    Parent = ScreenGui;
                });

                local TransparencyCache = {};
                local Toggled = false;
                local Fading = false;

                function Library:Toggle()
                    if Fading then
                        return;
                    end;

                    local FadeTime = Config.MenuFadeTime;
                    Fading = true;
                    Toggled = (not Toggled);
                    ModalElement.Modal = Toggled;

                    if Toggled then
                        -- A bit scuffed, but if we're going from not toggled -> toggled we want to show the frame immediately so that the fade is visible.
                        Outer.Visible = true;

                        task.spawn(function()
                            -- TODO: add cursor fade?
                            local State = InputService.MouseIconEnabled;

                            local Cursor = Drawing.new('Triangle');
                            Cursor.Thickness = 1;
                            Cursor.Filled = true;
                            Cursor.Visible = true;

                            local CursorOutline = Drawing.new('Triangle');
                            CursorOutline.Thickness = 1;
                            CursorOutline.Filled = false;
                            CursorOutline.Color = Library.CursorOutlineColor;
                            CursorOutline.Visible = true;

                            while Toggled and ScreenGui.Parent do
                                InputService.MouseIconEnabled = false;

                                local mPos = InputService:GetMouseLocation();

                                Cursor.Color = Library.AccentColor;
                                CursorOutline.Color = Library.CursorOutlineColor;

                                Cursor.PointA = Vector2.new(mPos.X, mPos.Y);
                                Cursor.PointB = Vector2.new(mPos.X + 16, mPos.Y + 6);
                                Cursor.PointC = Vector2.new(mPos.X + 6, mPos.Y + 16);

                                CursorOutline.PointA = Cursor.PointA;
                                CursorOutline.PointB = Cursor.PointB;
                                CursorOutline.PointC = Cursor.PointC;

                                RenderStepped:Wait();
                            end;

                            InputService.MouseIconEnabled = State;

                            Cursor:Remove();
                            CursorOutline:Remove();
                        end);
                    end;

                    for _, Desc in next, Outer:GetDescendants() do
                        local Properties = {};

                        if Desc:IsA('ImageLabel') then
                            table.insert(Properties, 'ImageTransparency');
                            table.insert(Properties, 'BackgroundTransparency');
                        elseif Desc:IsA('TextLabel') or Desc:IsA('TextBox') then
                            table.insert(Properties, 'TextTransparency');
                        elseif Desc:IsA('Frame') or Desc:IsA('ScrollingFrame') then
                            table.insert(Properties, 'BackgroundTransparency');
                        elseif Desc:IsA('UIStroke') then
                            table.insert(Properties, 'Transparency');
                        end;

                        local Cache = TransparencyCache[Desc];

                        if (not Cache) then
                            Cache = {};
                            TransparencyCache[Desc] = Cache;
                        end;

                        for _, Prop in next, Properties do
                            if not Cache[Prop] then
                                Cache[Prop] = Desc[Prop];
                            end;

                            if Cache[Prop] == 1 then
                                continue;
                            end;

                            TweenService:Create(Desc, TweenInfo.new(FadeTime, Enum.EasingStyle.Linear), { [Prop] = Toggled and Cache[Prop] or 1 }):Play();
                        end;
                    end;

                    task.wait(FadeTime);

                    Outer.Visible = Toggled;

                    Fading = false;
                end

                Library:GiveSignal(InputService.InputBegan:Connect(function(Input, Processed)
                    if type(Library.ToggleKeybind) == 'table' and Library.ToggleKeybind.Type == 'KeyPicker' then
                        if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Library.ToggleKeybind.Value then
                            task.spawn(Library.Toggle)
                        end
                    elseif Input.KeyCode == Enum.KeyCode.RightControl or (Input.KeyCode == Enum.KeyCode.RightShift and (not Processed)) then
                        task.spawn(Library.Toggle)
                    end
                end))

                if Config.AutoShow then task.spawn(Library.Toggle) end

                Window.Holder = Outer;

                return Window;
            end;

            local function OnPlayerChange()
                local PlayerList = GetPlayersString();

                for _, Value in next, Options do
                    if Value.Type == 'Dropdown' and Value.SpecialType == 'Player' then
                        Value:SetValues(PlayerList);
                    end;
                end;
            end;

            Players.PlayerAdded:Connect(OnPlayerChange);
            Players.PlayerRemoving:Connect(OnPlayerChange);

            getgenv().Library = Library
            return Library
        end

        --// ThemeManager
        do
            function LibraryThemeManagerLoadstring()
                local httpService = game:GetService('HttpService')
                local ThemeManager = {} do
                	ThemeManager.Folder = 'LinoriaLibSettings'
                	-- if not isfolder(ThemeManager.Folder) then makefolder(ThemeManager.Folder) end
                
                	ThemeManager.Library = nil
                	ThemeManager.BuiltInThemes = {
                        ['Default'] 		= { 1, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"7366bd","BackgroundColor":"141414","OutlineColor":"323232"}') },
                		['smurfik.edition'] = { 2, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"468dff","BackgroundColor":"141414","OutlineColor":"323232"}') },
                        ['celestial.lol'] 	= { 3, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1c1c1c","AccentColor":"ffa5c8","BackgroundColor":"141414","OutlineColor":"323232"}') },
                		['neverlose.cc'] 	= { 4, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"08080d","AccentColor":"02a6f5","BackgroundColor":"000d1b","OutlineColor":"324552"}') },
                        ['onetap.su'] 	    = { 5, httpService:JSONDecode('{"FontColor":"fefefc","MainColor":"191921","AccentColor":"f6a814","BackgroundColor":"16161e","OutlineColor":"37373f"}') },
                        ['gamesense.pub']	= { 6, httpService:JSONDecode('{"FontColor":"919191","MainColor":"101010","AccentColor":"9CB819","BackgroundColor":"111111","OutlineColor":"2D2D2D"}') },
                		['fatality.win']	= { 7, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1842","AccentColor":"c50754","BackgroundColor":"191335","OutlineColor":"3c355d"}') },
                		['comet.pub'] 		= { 8, httpService:JSONDecode('{"FontColor":"5E5E5E","MainColor":"0F0F0F","AccentColor":"5D589D","BackgroundColor":"0F0F0F","OutlineColor":"191919"}') },
                		['tokyohook.cc'] 	= { 9, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"433e58"}') },
                		['pandahook.cc'] 	= { 10, httpService:JSONDecode('{"FontColor":"AEAEAE","MainColor":"0F0F0F","AccentColor":"30406A","BackgroundColor":"0F0F0F","OutlineColor":"171717"}') },
                		['Mae.lua'] 	    = { 11, httpService:JSONDecode('{"FontColor":"c5c5c5","MainColor":"0F0F0F","AccentColor":"ffc6fe","BackgroundColor":"0f0f0f","OutlineColor":"191919"}') },
                		['BBot'] 			= { 12, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"1e1e1e","AccentColor":"7e48a3","BackgroundColor":"232323","OutlineColor":"141414"}') },
                		['Jester'] 			= { 13, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242424","AccentColor":"db4467","BackgroundColor":"1c1c1c","OutlineColor":"373737"}') },
                		['Mint'] 			= { 14, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"242424","AccentColor":"3db488","BackgroundColor":"1c1c1c","OutlineColor":"373737"}') },
                		['Tokyo Night'] 	= { 15, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"191925","AccentColor":"6759b3","BackgroundColor":"16161f","OutlineColor":"323232"}') },
                		['Ubuntu'] 			= { 16, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"3e3e3e","AccentColor":"e2581e","BackgroundColor":"323232","OutlineColor":"191919"}') },
                		['Quartz'] 			= { 17, httpService:JSONDecode('{"FontColor":"ffffff","MainColor":"232330","AccentColor":"426e87","BackgroundColor":"1d1b26","OutlineColor":"27232f"}') },
                	}
                
                	function ThemeManager:ApplyTheme(theme)
                		local customThemeData = self:GetCustomTheme(theme)
                		local data = customThemeData or self.BuiltInThemes[theme]
                    
                		if not data then return end
                    
                		-- custom themes are just regular dictionaries instead of an array with { index, dictionary }
                    
                		local scheme = data[2]
                		for idx, col in next, customThemeData or scheme do
                			self.Library[idx] = Color3.fromHex(col)
                        
                			if Options[idx] then
                				Options[idx]:SetValueRGB(Color3.fromHex(col))
                			end
                		end
                    
                		self:ThemeUpdate()
                	end
                
                	function ThemeManager:ThemeUpdate()
                		-- This allows us to force apply themes without loading the themes tab :)
                		local options = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
                		for i, field in next, options do
                			if Options and Options[field] then
                				self.Library[field] = Options[field].Value
                			end
                		end
                    
                		self.Library.AccentColorDark = self.Library:GetDarkerColor(self.Library.AccentColor);
                		self.Library:UpdateColorsUsingRegistry()
                	end
                
                	function ThemeManager:LoadDefault()		
                		local theme = 'Default'
                		local content = isfile(self.Folder .. '/themes/default.txt') and readfile(self.Folder .. '/themes/default.txt')
                    
                		local isDefault = true
                		if content then
                			if self.BuiltInThemes[content] then
                				theme = content
                			elseif self:GetCustomTheme(content) then
                				theme = content
                				isDefault = false;
                			end
                		elseif self.BuiltInThemes[self.DefaultTheme] then
                		 	theme = self.DefaultTheme
                		end
                    
                		if isDefault then
                			Options.ThemeManager_ThemeList:SetValue(theme)
                		else
                			self:ApplyTheme(theme)
                		end
                	end
                
                	function ThemeManager:SaveDefault(theme)
                		writefile(self.Folder .. '/themes/default.txt', theme)
                	end
                
                	function ThemeManager:CreateThemeManager(groupbox)
                		groupbox:AddLabel('Background color'):AddColorPicker('BackgroundColor', { Default = self.Library.BackgroundColor });
                		groupbox:AddLabel('Main color'):AddColorPicker('MainColor', { Default = self.Library.MainColor });
                		groupbox:AddLabel('Accent color'):AddColorPicker('AccentColor', { Default = self.Library.AccentColor });
                		groupbox:AddLabel('Outline color'):AddColorPicker('OutlineColor', { Default = self.Library.OutlineColor });
                		groupbox:AddLabel('Font color'):AddColorPicker('FontColor', { Default = self.Library.FontColor });
                		groupbox:AddLabel('Cursor Outline color'):AddColorPicker('CursorOutlineColor', { Default = self.Library.CursorOutlineColor });
                    
                		local ThemesArray = {}
                		for Name, Theme in next, self.BuiltInThemes do
                			table.insert(ThemesArray, Name)
                		end
                    
                		table.sort(ThemesArray, function(a, b) return self.BuiltInThemes[a][1] < self.BuiltInThemes[b][1] end)
                    
                		groupbox:AddDivider()
                		groupbox:AddDropdown('ThemeManager_ThemeList', { Text = 'Theme list', Values = ThemesArray, Default = 1 })
                    
                		groupbox:AddButton('Set as default', function()
                			self:SaveDefault(Options.ThemeManager_ThemeList.Value)
                			self.Library:Notify(string.format('Set default theme to %q', Options.ThemeManager_ThemeList.Value))
                		end)
                    
                		Options.ThemeManager_ThemeList:OnChanged(function()
                			self:ApplyTheme(Options.ThemeManager_ThemeList.Value)
                		end)
                    
                		groupbox:AddDivider()
                		groupbox:AddInput('ThemeManager_CustomThemeName', { Text = 'Custom theme name' })
                		groupbox:AddDropdown('ThemeManager_CustomThemeList', { Text = 'Custom themes', Values = self:ReloadCustomThemes(), AllowNull = true, Default = 1 })
                		groupbox:AddDivider()
                    
                		groupbox:AddButton('Save theme', function() 
                			self:SaveCustomTheme(Options.ThemeManager_CustomThemeName.Value)
                        
                			Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                			Options.ThemeManager_CustomThemeList:SetValue(nil)
                		end):AddButton('Load theme', function() 
                			self:ApplyTheme(Options.ThemeManager_CustomThemeList.Value) 
                		end)
                    
                		groupbox:AddButton('Refresh list', function()
                			Options.ThemeManager_CustomThemeList:SetValues(self:ReloadCustomThemes())
                			Options.ThemeManager_CustomThemeList:SetValue(nil)
                		end)
                    
                		groupbox:AddButton('Set as default', function()
                			if Options.ThemeManager_CustomThemeList.Value ~= nil and Options.ThemeManager_CustomThemeList.Value ~= '' then
                				self:SaveDefault(Options.ThemeManager_CustomThemeList.Value)
                				self.Library:Notify(string.format('Set default theme to %q', Options.ThemeManager_CustomThemeList.Value))
                			end
                		end)
                    
                		ThemeManager:LoadDefault()
                    
                		local function UpdateTheme()
                			self:ThemeUpdate()
                		end
                    
                		Options.BackgroundColor:OnChanged(UpdateTheme)
                		Options.MainColor:OnChanged(UpdateTheme)
                		Options.AccentColor:OnChanged(UpdateTheme)
                		Options.OutlineColor:OnChanged(UpdateTheme)
                		Options.FontColor:OnChanged(UpdateTheme)
                		Options.CursorOutlineColor:OnChanged(UpdateTheme)
                	end
                
                	function ThemeManager:GetCustomTheme(file)
                		local path = self.Folder .. '/themes/' .. file
                		if not isfile(path) then
                			return nil
                		end
                    
                		local data = readfile(path)
                		local success, decoded = pcall(httpService.JSONDecode, httpService, data)
                    
                		if not success then
                			return nil
                		end
                    
                		return decoded
                	end
                
                	function ThemeManager:SaveCustomTheme(file)
                		if file:gsub(' ', '') == '' then
                			return self.Library:Notify('Invalid file name for theme (empty)', 3)
                		end
                    
                		local theme = {}
                		local fields = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }
                    
                		for _, field in next, fields do
                			theme[field] = Options[field].Value:ToHex()
                		end
                    
                		writefile(self.Folder .. '/themes/' .. file .. '.json', httpService:JSONEncode(theme))
                	end
                
                	function ThemeManager:ReloadCustomThemes()
                		local list = listfiles(self.Folder .. '/themes')
                    
                		local out = {}
                		for i = 1, #list do
                			local file = list[i]
                			if file:sub(-5) == '.json' then
                				-- i hate this but it has to be done ...
                            
                				local pos = file:find('.json', 1, true)
                				local char = file:sub(pos, pos)
                            
                				while char ~= '/' and char ~= '\\' and char ~= '' do
                					pos = pos - 1
                					char = file:sub(pos, pos)
                				end
                            
                				if char == '/' or char == '\\' then
                					table.insert(out, file:sub(pos + 1))
                				end
                			end
                		end
                    
                		return out
                	end
                
                	function ThemeManager:SetLibrary(lib)
                		self.Library = lib
                	end
                
                	function ThemeManager:BuildFolderTree()
                		local paths = {}
                    
                		-- build the entire tree if a path is like some-hub/phantom-forces
                		-- makefolder builds the entire tree on Synapse X but not other exploits
                    
                		local parts = self.Folder:split('/')
                		for idx = 1, #parts do
                			paths[#paths + 1] = table.concat(parts, '/', 1, idx)
                		end
                    
                		table.insert(paths, self.Folder .. '/themes')
                		table.insert(paths, self.Folder .. '/settings')
                    
                		for i = 1, #paths do
                			local str = paths[i]
                			if not isfolder(str) then
                				makefolder(str)
                			end
                		end
                	end
                
                	function ThemeManager:SetFolder(folder)
                		self.Folder = folder
                		self:BuildFolderTree()
                	end
                
                	function ThemeManager:CreateGroupBox(tab)
                		assert(self.Library, 'Must set ThemeManager.Library first!')
                		return tab:AddLeftGroupbox('Themes')
                	end
                
                	function ThemeManager:ApplyToTab(tab)
                		assert(self.Library, 'Must set ThemeManager.Library first!')
                		local groupbox = self:CreateGroupBox(tab)
                		self:CreateThemeManager(groupbox)
                	end
                
                	function ThemeManager:ApplyToGroupbox(groupbox)
                		assert(self.Library, 'Must set ThemeManager.Library first!')
                		self:CreateThemeManager(groupbox)
                	end
                
                	ThemeManager:BuildFolderTree()
                end

                return ThemeManager
            end
        end

        --// SaveManager
        do
            function LibrarySaveManagerLoadstring()
                local httpService = game:GetService('HttpService')

                local SaveManager = {} do
                	SaveManager.Folder = 'LinoriaLibSettings'
                	SaveManager.Ignore = {}
                	SaveManager.Parser = {
                		Toggle = {
                			Save = function(idx, object) 
                				return { type = 'Toggle', idx = idx, value = object.Value } 
                			end,
                			Load = function(idx, data)
                				if Toggles[idx] then 
                					Toggles[idx]:SetValue(data.value)
                				end
                			end,
                		},
                		Slider = {
                			Save = function(idx, object)
                				return { type = 'Slider', idx = idx, value = tostring(object.Value) }
                			end,
                			Load = function(idx, data)
                				if Options[idx] then 
                					Options[idx]:SetValue(data.value)
                				end
                			end,
                		},
                		Dropdown = {
                			Save = function(idx, object)
                				return { type = 'Dropdown', idx = idx, value = object.Value, mutli = object.Multi }
                			end,
                			Load = function(idx, data)
                				if Options[idx] then 
                					Options[idx]:SetValue(data.value)
                				end
                			end,
                		},
                		ColorPicker = {
                			Save = function(idx, object)
                				return { type = 'ColorPicker', idx = idx, value = object.Value:ToHex(), transparency = object.Transparency }
                			end,
                			Load = function(idx, data)
                				if Options[idx] then 
                					Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
                				end
                			end,
                		},
                		KeyPicker = {
                			Save = function(idx, object)
                				return { type = 'KeyPicker', idx = idx, mode = object.Mode, key = object.Value }
                			end,
                			Load = function(idx, data)
                				if Options[idx] then 
                					Options[idx]:SetValue({ data.key, data.mode })
                				end
                			end,
                		},
                    
                		Input = {
                			Save = function(idx, object)
                				return { type = 'Input', idx = idx, text = object.Value }
                			end,
                			Load = function(idx, data)
                				if Options[idx] and type(data.text) == 'string' then
                					Options[idx]:SetValue(data.text)
                				end
                			end,
                		},
                	}
                
                	function SaveManager:SetIgnoreIndexes(list)
                		for _, key in next, list do
                			self.Ignore[key] = true
                		end
                	end
                
                	function SaveManager:SetFolder(folder)
                		self.Folder = folder;
                		self:BuildFolderTree()
                	end
                
                	function SaveManager:Save(name)
                		if (not name) then
                			return false, 'no config file is selected'
                		end
                    
                		local fullPath = self.Folder .. '/settings/' .. name .. '.json'
                    
                		local data = {
                			objects = {}
                		}
                    
                		for idx, toggle in next, Toggles do
                			if self.Ignore[idx] then continue end
                        
                			table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
                		end
                    
                		for idx, option in next, Options do
                			if not self.Parser[option.Type] then continue end
                			if self.Ignore[idx] then continue end
                        
                			table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
                		end	
                    
                		local success, encoded = pcall(httpService.JSONEncode, httpService, data)
                		if not success then
                			return false, 'failed to encode data'
                		end
                    
                		writefile(fullPath, encoded)
                		return true
                	end
                
                	function SaveManager:Load(name)
                		if (not name) then
                			return false, 'no config file is selected'
                		end
                    
                		local file = self.Folder .. '/settings/' .. name .. '.json'
                		if not isfile(file) then return false, 'invalid file' end
                    
                		local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
                		if not success then return false, 'decode error' end
                    
                		for _, option in next, decoded.objects do
                			if self.Parser[option.type] then
                				task.spawn(function() self.Parser[option.type].Load(option.idx, option) end) -- task.spawn() so the config loading wont get stuck.
                			end
                		end
                    
                		return true
                	end
                
                	function SaveManager:IgnoreThemeSettings()
                		self:SetIgnoreIndexes({ 
                			"BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", -- themes
                			"ThemeManager_ThemeList", 'ThemeManager_CustomThemeList', 'ThemeManager_CustomThemeName', -- themes
                		})
                	end
                
                	function SaveManager:BuildFolderTree()
                		local paths = {
                			self.Folder,
                			self.Folder .. '/themes',
                			self.Folder .. '/settings'
                		}
                    
                		for i = 1, #paths do
                			local str = paths[i]
                			if not isfolder(str) then
                				makefolder(str)
                			end
                		end
                	end
                
                	function SaveManager:RefreshConfigList()
                		local list = listfiles(self.Folder .. '/settings')
                    
                		local out = {}
                		for i = 1, #list do
                			local file = list[i]
                			if file:sub(-5) == '.json' then
                				-- i hate this but it has to be done ...
                            
                				local pos = file:find('.json', 1, true)
                				local start = pos
                            
                				local char = file:sub(pos, pos)
                				while char ~= '/' and char ~= '\\' and char ~= '' do
                					pos = pos - 1
                					char = file:sub(pos, pos)
                				end
                            
                				if char == '/' or char == '\\' then
                					table.insert(out, file:sub(pos + 1, start - 1))
                				end
                			end
                		end
                    
                		return out
                	end
                
                	function SaveManager:SetLibrary(library)
                		self.Library = library
                	end
                
                	function SaveManager:LoadAutoloadConfig()
                		if isfile(self.Folder .. '/settings/autoload.txt') then
                			local name = readfile(self.Folder .. '/settings/autoload.txt')
                        
                			local success, err = self:Load(name)
                			if not success then
                				return self.Library:Notify('Failed to load autoload config: ' .. err)
                			end
                        
                			self.Library:Notify(string.format('Auto loaded config %q', name))
                		end
                	end
                
                
                	function SaveManager:BuildConfigSection(tab)
                		assert(self.Library, 'Must set SaveManager.Library')
                    
                		local section = tab:AddRightGroupbox('Configuration')
                    
                		section:AddInput('SaveManager_ConfigName',    { Text = 'Config name' })
                		section:AddDropdown('SaveManager_ConfigList', { Text = 'Config list', Values = self:RefreshConfigList(), AllowNull = true })
                    
                		section:AddDivider()
                    
                		section:AddButton('Create config', function()
                			local name = Options.SaveManager_ConfigName.Value
                        
                			if name:gsub(' ', '') == '' then 
                				return self.Library:Notify('Invalid config name (empty)', 2)
                			end
                        
                			local success, err = self:Save(name)
                			if not success then
                				return self.Library:Notify('Failed to save config: ' .. err)
                			end
                        
                			self.Library:Notify(string.format('Created config %q', name))
                        
                			Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                			Options.SaveManager_ConfigList:SetValue(nil)
                		end):AddButton('Load config', function()
                			local name = Options.SaveManager_ConfigList.Value
                        
                			local success, err = self:Load(name)
                			if not success then
                				return self.Library:Notify('Failed to load config: ' .. err)
                			end
                        
                			self.Library:Notify(string.format('Loaded config %q', name))
                		end)
                    
                		section:AddButton('Overwrite config', function()
                			local name = Options.SaveManager_ConfigList.Value
                        
                			local success, err = self:Save(name)
                			if not success then
                				return self.Library:Notify('Failed to overwrite config: ' .. err)
                			end
                        
                			self.Library:Notify(string.format('Overwrote config %q', name))
                		end)
                    
                		section:AddButton('Refresh list', function()
                			Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
                			Options.SaveManager_ConfigList:SetValue(nil)
                		end)
                    
                		section:AddButton('Set as autoload', function()
                			local name = Options.SaveManager_ConfigList.Value
                			writefile(self.Folder .. '/settings/autoload.txt', name)
                			SaveManager.AutoloadLabel:SetText('Current autoload config: ' .. name)
                			self.Library:Notify(string.format('Set %q to auto load', name))
                		end)
                    
                		SaveManager.AutoloadLabel = section:AddLabel('Current autoload config: none', true)
                    
                		if isfile(self.Folder .. '/settings/autoload.txt') then
                			local name = readfile(self.Folder .. '/settings/autoload.txt')
                			SaveManager.AutoloadLabel:SetText('Current autoload config: ' .. name)
                		end
                    
                		SaveManager:SetIgnoreIndexes({ 'SaveManager_ConfigList', 'SaveManager_ConfigName' })
                	end
                
                	SaveManager:BuildFolderTree()
                end

                return SaveManager
            end
        end
    end

    --// ESP Library
    do
        function ESPSenseLibraryLoadstringInFunctionType()
            -- services
            local runService = game:GetService("RunService");
            local players = game:GetService("Players");
            local workspace = game:GetService("Workspace");

            -- variables
            local localPlayer = players.LocalPlayer;
            local camera = workspace.CurrentCamera;
            local viewportSize = camera.ViewportSize;
            local container = Instance.new("Folder",
            	gethui and gethui() or game:GetService("CoreGui"));

            -- locals
            local floor = math.floor;
            local round = math.round;
            local sin = math.sin;
            local cos = math.cos;
            local clear = table.clear;
            local unpack = table.unpack;
            local find = table.find;
            local create = table.create;
            local fromMatrix = CFrame.fromMatrix;

            -- methods
            local wtvp = camera.WorldToViewportPoint;
            local isA = workspace.IsA;
            local getPivot = workspace.GetPivot;
            local findFirstChild = workspace.FindFirstChild;
            local findFirstChildOfClass = workspace.FindFirstChildOfClass;
            local getChildren = workspace.GetChildren;
            local toOrientation = CFrame.identity.ToOrientation;
            local pointToObjectSpace = CFrame.identity.PointToObjectSpace;
            local lerpColor = Color3.new().Lerp;
            local min2 = Vector2.zero.Min;
            local max2 = Vector2.zero.Max;
            local lerp2 = Vector2.zero.Lerp;
            local min3 = Vector3.zero.Min;
            local max3 = Vector3.zero.Max;

            -- constants
            local HEALTH_BAR_OFFSET = Vector2.new(5, 0);
            local HEALTH_TEXT_OFFSET = Vector2.new(3, 0);
            local HEALTH_BAR_OUTLINE_OFFSET = Vector2.new(0, 1);
            local NAME_OFFSET = Vector2.new(0, 2);
            local DISTANCE_OFFSET = Vector2.new(0, 2);
            local VERTICES = {
            	Vector3.new(-1, -1, -1),
            	Vector3.new(-1, 1, -1),
            	Vector3.new(-1, 1, 1),
            	Vector3.new(-1, -1, 1),
            	Vector3.new(1, -1, -1),
            	Vector3.new(1, 1, -1),
            	Vector3.new(1, 1, 1),
            	Vector3.new(1, -1, 1)
            };

            -- functions
            local function isBodyPart(name)
            	return name == "Head" or name:find("Torso") or name:find("Leg") or name:find("Arm");
            end

            local function getBoundingBox(parts)
            	local min, max;
            	for i = 1, #parts do
            		local part = parts[i];
            		local cframe, size = part.CFrame, part.Size;
                
            		min = min3(min or cframe.Position, (cframe - size*0.5).Position);
            		max = max3(max or cframe.Position, (cframe + size*0.5).Position);
            	end
            
            	local center = (min + max)*0.5;
            	local front = Vector3.new(center.X, center.Y, max.Z);
            	return CFrame.new(center, front), max - min;
            end

            local function worldToScreen(world)
            	local screen, inBounds = wtvp(camera, world);
            	return Vector2.new(screen.X, screen.Y), inBounds, screen.Z;
            end

            local function calculateCorners(cframe, size)
            	local corners = create(#VERTICES);
            	for i = 1, #VERTICES do
            		corners[i] = worldToScreen((cframe + size*0.5*VERTICES[i]).Position);
            	end
            
            	local min = min2(viewportSize, unpack(corners));
            	local max = max2(Vector2.zero, unpack(corners));
            	return {
            		corners = corners,
            		topLeft = Vector2.new(floor(min.X), floor(min.Y)),
            		topRight = Vector2.new(floor(max.X), floor(min.Y)),
            		bottomLeft = Vector2.new(floor(min.X), floor(max.Y)),
            		bottomRight = Vector2.new(floor(max.X), floor(max.Y))
            	};
            end

            local function rotateVector(vector, radians)
            	-- https://stackoverflow.com/questions/28112315/how-do-i-rotate-a-vector
            	local x, y = vector.X, vector.Y;
            	local c, s = cos(radians), sin(radians);
            	return Vector2.new(x*c - y*s, x*s + y*c);
            end

            local function parseColor(self, color, isOutline)
            	if color == "Team Color" or (self.interface.sharedSettings.useTeamColor and not isOutline) then
            		return self.interface.getTeamColor(self.player) or Color3.new(1,1,1);
            	end
            	return color;
            end

            -- esp object
            local EspObject = {};
            EspObject.__index = EspObject;

            function EspObject.new(player, interface)
            	local self = setmetatable({}, EspObject);
            	self.player = assert(player, "Missing argument #1 (Player expected)");
            	self.interface = assert(interface, "Missing argument #2 (table expected)");
            	self:Construct();
            	return self;
            end

            function EspObject:_create(class, properties)
            	local drawing = Drawing.new(class);
            	for property, value in next, properties do
            		pcall(function() drawing[property] = value; end);
            	end
            	self.bin[#self.bin + 1] = drawing;
            	return drawing;
            end

            function EspObject:Construct()
            	self.charCache = {};
            	self.childCount = 0;
            	self.bin = {};
            	self.drawings = {
            		box3d = {
            			{
            				self:_create("Line", { Thickness = 1, Visible = false }),
            				self:_create("Line", { Thickness = 1, Visible = false }),
            				self:_create("Line", { Thickness = 1, Visible = false })
            			},
            			{
            				self:_create("Line", { Thickness = 1, Visible = false }),
            				self:_create("Line", { Thickness = 1, Visible = false }),
            				self:_create("Line", { Thickness = 1, Visible = false })
            			},
            			{
            				self:_create("Line", { Thickness = 1, Visible = false }),
            				self:_create("Line", { Thickness = 1, Visible = false }),
            				self:_create("Line", { Thickness = 1, Visible = false })
            			},
            			{
            				self:_create("Line", { Thickness = 1, Visible = false }),
            				self:_create("Line", { Thickness = 1, Visible = false }),
            				self:_create("Line", { Thickness = 1, Visible = false })
            			}
            		},
            		visible = {
            			tracerOutline = self:_create("Line", { Thickness = 2, Visible = false }),
            			tracer = self:_create("Line", { Thickness = 1, Visible = false }),
            			boxFill = self:_create("Square", { Filled = true, Visible = false }),
            			boxOutline = self:_create("Square", { Thickness = 2, Visible = false }),
            			box = self:_create("Square", { Thickness = 1, Visible = false }),
            			healthBarOutline = self:_create("Line", { Thickness = 2, Visible = false }),
            			healthBar = self:_create("Line", { Thickness = 1, Visible = false }),
            			healthText = self:_create("Text", { Center = true, Visible = false }),
            			name = self:_create("Text", { Text = self.player.DisplayName, Center = true, Visible = false }),
            			distance = self:_create("Text", { Center = true, Visible = false }),
            			weapon = self:_create("Text", { Center = true, Visible = false }),
            		},
            		hidden = {
            			arrowOutline = self:_create("Triangle", { Thickness = 3, Visible = false }),
            			arrow = self:_create("Triangle", { Filled = true, Visible = false })
            		}
            	};
            
            	self.renderConnection = runService.Heartbeat:Connect(function(deltaTime)
            		self:Update(deltaTime);
            		self:Render(deltaTime);
            	end);
            end

            function EspObject:Destruct()
            	self.renderConnection:Disconnect();
            
            	for i = 1, #self.bin do
            		self.bin[i]:Remove();
            	end
            
            	clear(self);
            end

            function EspObject:Update()
            	local interface = self.interface;
            
            	self.options = interface.teamSettings[interface.isFriendly(self.player) and "friendly" or "enemy"];
            	self.character = interface.getCharacter(self.player);
            	self.health, self.maxHealth = interface.getHealth(self.player);
            	self.weapon = interface.getWeapon(self.player);
            	self.enabled = self.options.enabled and self.character and not
            		(#interface.whitelist > 0 and not find(interface.whitelist, self.player.UserId));
            
            	local head = self.enabled and findFirstChild(self.character, "Head");
            	if not head then
            		self.charCache = {};
            		self.onScreen = false;
            		return;
            	end
            
            	local _, onScreen, depth = worldToScreen(head.Position);
            	self.onScreen = onScreen;
            	self.distance = depth;
            
            	if interface.sharedSettings.limitDistance and depth > interface.sharedSettings.maxDistance then
            		self.onScreen = false;
            	end
            
            	if self.onScreen then
            		local cache = self.charCache;
            		local children = getChildren(self.character);
            		if not cache[1] or self.childCount ~= #children then
            			clear(cache);
                    
            			for i = 1, #children do
            				local part = children[i];
            				if isA(part, "BasePart") and isBodyPart(part.Name) then
            					cache[#cache + 1] = part;
            				end
            			end
                    
            			self.childCount = #children;
            		end
                
            		self.corners = calculateCorners(getBoundingBox(cache));
            	elseif self.options.offScreenArrow then
            		local cframe = camera.CFrame;
            		local flat = fromMatrix(cframe.Position, cframe.RightVector, Vector3.yAxis);
            		local objectSpace = pointToObjectSpace(flat, head.Position);
            		self.direction = Vector2.new(objectSpace.X, objectSpace.Z).Unit;
            	end
            end

            function EspObject:Render()
            	local onScreen = self.onScreen or false;
            	local enabled = self.enabled or false;
            	local visible = self.drawings.visible;
            	local hidden = self.drawings.hidden;
            	local box3d = self.drawings.box3d;
            	local interface = self.interface;
            	local options = self.options;
            	local corners = self.corners;
            
            	visible.box.Visible = enabled and onScreen and options.box;
            	visible.boxOutline.Visible = visible.box.Visible and options.boxOutline;
            	if visible.box.Visible then
            		local box = visible.box;
            		box.Position = corners.topLeft;
            		box.Size = corners.bottomRight - corners.topLeft;
            		box.Color = parseColor(self, options.boxColor[1]);
            		box.Transparency = options.boxColor[2];
                
            		local boxOutline = visible.boxOutline;
            		boxOutline.Position = box.Position;
            		boxOutline.Size = box.Size;
            		boxOutline.Color = parseColor(self, options.boxOutlineColor[1], true);
            		boxOutline.Transparency = options.boxOutlineColor[2];
            	end
            
            	visible.boxFill.Visible = enabled and onScreen and options.boxFill;
            	if visible.boxFill.Visible then
            		local boxFill = visible.boxFill;
            		boxFill.Position = corners.topLeft;
            		boxFill.Size = corners.bottomRight - corners.topLeft;
            		boxFill.Color = parseColor(self, options.boxFillColor[1]);
            		boxFill.Transparency = options.boxFillColor[2];
            	end
            
            	visible.healthBar.Visible = enabled and onScreen and options.healthBar;
            	visible.healthBarOutline.Visible = visible.healthBar.Visible and options.healthBarOutline;
            	if visible.healthBar.Visible then
            		local barFrom = corners.topLeft - HEALTH_BAR_OFFSET;
            		local barTo = corners.bottomLeft - HEALTH_BAR_OFFSET;
                
            		local healthBar = visible.healthBar;
            		healthBar.To = barTo;
            		healthBar.From = lerp2(barTo, barFrom, self.health/self.maxHealth);
            		healthBar.Color = lerpColor(options.dyingColor, options.healthyColor, self.health/self.maxHealth);
                
            		local healthBarOutline = visible.healthBarOutline;
            		healthBarOutline.To = barTo + HEALTH_BAR_OUTLINE_OFFSET;
            		healthBarOutline.From = barFrom - HEALTH_BAR_OUTLINE_OFFSET;
            		healthBarOutline.Color = parseColor(self, options.healthBarOutlineColor[1], true);
            		healthBarOutline.Transparency = options.healthBarOutlineColor[2];
            	end
            
            	visible.healthText.Visible = enabled and onScreen and options.healthText;
            	if visible.healthText.Visible then
            		local barFrom = corners.topLeft - HEALTH_BAR_OFFSET;
            		local barTo = corners.bottomLeft - HEALTH_BAR_OFFSET;
                
            		local healthText = visible.healthText;
            		healthText.Text = round(self.health) .. "hp";
            		healthText.Size = interface.sharedSettings.textSize;
            		healthText.Font = interface.sharedSettings.textFont;
            		healthText.Color = parseColor(self, options.healthTextColor[1]);
            		healthText.Transparency = options.healthTextColor[2];
            		healthText.Outline = options.healthTextOutline;
            		healthText.OutlineColor = parseColor(self, options.healthTextOutlineColor, true);
            		healthText.Position = lerp2(barTo, barFrom, self.health/self.maxHealth) - healthText.TextBounds*0.5 - HEALTH_TEXT_OFFSET;
            	end
            
            	visible.name.Visible = enabled and onScreen and options.name;
            	if visible.name.Visible then
            		local name = visible.name;
            		name.Size = interface.sharedSettings.textSize;
            		name.Font = interface.sharedSettings.textFont;
            		name.Color = parseColor(self, options.nameColor[1]);
            		name.Transparency = options.nameColor[2];
            		name.Outline = options.nameOutline;
            		name.OutlineColor = parseColor(self, options.nameOutlineColor, true);
            		name.Position = (corners.topLeft + corners.topRight)*0.5 - Vector2.yAxis*name.TextBounds.Y - NAME_OFFSET;
            	end
            
            	visible.distance.Visible = enabled and onScreen and self.distance and options.distance;
            	if visible.distance.Visible then
            		local distance = visible.distance;
            		distance.Text = round(self.distance) .. " studs";
            		distance.Size = interface.sharedSettings.textSize;
            		distance.Font = interface.sharedSettings.textFont;
            		distance.Color = parseColor(self, options.distanceColor[1]);
            		distance.Transparency = options.distanceColor[2];
            		distance.Outline = options.distanceOutline;
            		distance.OutlineColor = parseColor(self, options.distanceOutlineColor, true);
            		distance.Position = (corners.bottomLeft + corners.bottomRight)*0.5 + DISTANCE_OFFSET;
            	end
            
            	visible.weapon.Visible = enabled and onScreen and options.weapon;
            	if visible.weapon.Visible then
            		local weapon = visible.weapon;
            		weapon.Text = self.weapon;
            		weapon.Size = interface.sharedSettings.textSize;
            		weapon.Font = interface.sharedSettings.textFont;
            		weapon.Color = parseColor(self, options.weaponColor[1]);
            		weapon.Transparency = options.weaponColor[2];
            		weapon.Outline = options.weaponOutline;
            		weapon.OutlineColor = parseColor(self, options.weaponOutlineColor, true);
            		weapon.Position =
            			(corners.bottomLeft + corners.bottomRight)*0.5 +
            			(visible.distance.Visible and DISTANCE_OFFSET + Vector2.yAxis*visible.distance.TextBounds.Y or Vector2.zero);
            	end
            
            	visible.tracer.Visible = enabled and onScreen and options.tracer;
            	visible.tracerOutline.Visible = visible.tracer.Visible and options.tracerOutline;
            	if visible.tracer.Visible then
            		local tracer = visible.tracer;
            		tracer.Color = parseColor(self, options.tracerColor[1]);
            		tracer.Transparency = options.tracerColor[2];
            		tracer.To = (corners.bottomLeft + corners.bottomRight)*0.5;
            		tracer.From =
            			options.tracerOrigin == "Middle" and viewportSize*0.5 or
            			options.tracerOrigin == "Top" and viewportSize*Vector2.new(0.5, 0) or
            			options.tracerOrigin == "Bottom" and viewportSize*Vector2.new(0.5, 1);
                
            		local tracerOutline = visible.tracerOutline;
            		tracerOutline.Color = parseColor(self, options.tracerOutlineColor[1], true);
            		tracerOutline.Transparency = options.tracerOutlineColor[2];
            		tracerOutline.To = tracer.To;
            		tracerOutline.From = tracer.From;
            	end
            
            	hidden.arrow.Visible = enabled and (not onScreen) and options.offScreenArrow;
            	hidden.arrowOutline.Visible = hidden.arrow.Visible and options.offScreenArrowOutline;
            	if hidden.arrow.Visible and self.direction then
            		local arrow = hidden.arrow;
            		arrow.PointA = min2(max2(viewportSize*0.5 + self.direction*options.offScreenArrowRadius, Vector2.one*25), viewportSize - Vector2.one*25);
            		arrow.PointB = arrow.PointA - rotateVector(self.direction, 0.45)*options.offScreenArrowSize;
            		arrow.PointC = arrow.PointA - rotateVector(self.direction, -0.45)*options.offScreenArrowSize;
            		arrow.Color = parseColor(self, options.offScreenArrowColor[1]);
            		arrow.Transparency = options.offScreenArrowColor[2];
                
            		local arrowOutline = hidden.arrowOutline;
            		arrowOutline.PointA = arrow.PointA;
            		arrowOutline.PointB = arrow.PointB;
            		arrowOutline.PointC = arrow.PointC;
            		arrowOutline.Color = parseColor(self, options.offScreenArrowOutlineColor[1], true);
            		arrowOutline.Transparency = options.offScreenArrowOutlineColor[2];
            	end
            
            	local box3dEnabled = enabled and onScreen and options.box3d;
            	for i = 1, #box3d do
            		local face = box3d[i];
            		for i2 = 1, #face do
            			local line = face[i2];
            			line.Visible = box3dEnabled;
            			line.Color = parseColor(self, options.box3dColor[1]);
            			line.Transparency = options.box3dColor[2];
            		end
                
            		if box3dEnabled then
            			local line1 = face[1];
            			line1.From = corners.corners[i];
            			line1.To = corners.corners[i == 4 and 1 or i+1];
                    
            			local line2 = face[2];
            			line2.From = corners.corners[i == 4 and 1 or i+1];
            			line2.To = corners.corners[i == 4 and 5 or i+5];
                    
            			local line3 = face[3];
            			line3.From = corners.corners[i == 4 and 5 or i+5];
            			line3.To = corners.corners[i == 4 and 8 or i+4];
            		end
            	end
            end

            -- cham object
            local ChamObject = {};
            ChamObject.__index = ChamObject;

            function ChamObject.new(player, interface)
            	local self = setmetatable({}, ChamObject);
            	self.player = assert(player, "Missing argument #1 (Player expected)");
            	self.interface = assert(interface, "Missing argument #2 (table expected)");
            	self:Construct();
            	return self;
            end

            function ChamObject:Construct()
            	self.highlight = Instance.new("Highlight", container);
            	self.updateConnection = runService.Heartbeat:Connect(function()
            		self:Update();
            	end);
            end

            function ChamObject:Destruct()
            	self.updateConnection:Disconnect();
            	self.highlight:Destroy();
            
            	clear(self);
            end

            function ChamObject:Update()
            	local highlight = self.highlight;
            	local interface = self.interface;
            	local character = interface.getCharacter(self.player);
            	local options = interface.teamSettings[interface.isFriendly(self.player) and "friendly" or "enemy"];
            	local enabled = options.enabled and character and not
            		(#interface.whitelist > 0 and not find(interface.whitelist, self.player.UserId));
            
            	highlight.Enabled = enabled and options.chams;
            	if highlight.Enabled then
            		highlight.Adornee = character;
            		highlight.FillColor = parseColor(self, options.chamsFillColor[1]);
            		highlight.FillTransparency = options.chamsFillColor[2];
            		highlight.OutlineColor = parseColor(self, options.chamsOutlineColor[1], true);
            		highlight.OutlineTransparency = options.chamsOutlineColor[2];
            		highlight.DepthMode = options.chamsVisibleOnly and "Occluded" or "AlwaysOnTop";
            	end
            end

            -- instance class
            local InstanceObject = {};
            InstanceObject.__index = InstanceObject;

            function InstanceObject.new(instance, options)
            	local self = setmetatable({}, InstanceObject);
            	self.instance = assert(instance, "Missing argument #1 (Instance Expected)");
            	self.options = assert(options, "Missing argument #2 (table expected)");
            	self:Construct();
            	return self;
            end

            function InstanceObject:Construct()
            	local options = self.options;
            	options.enabled = options.enabled == nil and true or options.enabled;
            	options.text = options.text or "{name}";
            	options.textColor = options.textColor or { Color3.new(1,1,1), 1 };
            	options.textOutline = options.textOutline == nil and true or options.textOutline;
            	options.textOutlineColor = options.textOutlineColor or Color3.new();
            	options.textSize = options.textSize or 13;
            	options.textFont = options.textFont or 2;
            	options.limitDistance = options.limitDistance or false;
            	options.maxDistance = options.maxDistance or 150;
            
            	self.text = Drawing.new("Text");
            	self.text.Center = true;
            
            	self.renderConnection = runService.Heartbeat:Connect(function(deltaTime)
            		self:Render(deltaTime);
            	end);
            end

            function InstanceObject:Destruct()
            	self.renderConnection:Disconnect();
            	self.text:Remove();
            end

            function InstanceObject:Render()
            	local instance = self.instance;
            	if not instance or not instance.Parent then
            		return self:Destruct();
            	end
            
            	local text = self.text;
            	local options = self.options;
            	if not options.enabled then
            		text.Visible = false;
            		return;
            	end
            
            	local world = getPivot(instance).Position;
            	local position, visible, depth = worldToScreen(world);
            	if options.limitDistance and depth > options.maxDistance then
            		visible = false;
            	end
            
            	text.Visible = visible;
            	if text.Visible then
            		text.Position = position;
            		text.Color = options.textColor[1];
            		text.Transparency = options.textColor[2];
            		text.Outline = options.textOutline;
            		text.OutlineColor = options.textOutlineColor;
            		text.Size = options.textSize;
            		text.Font = options.textFont;
            		text.Text = options.text
            			:gsub("{name}", instance.Name)
            			:gsub("{distance}", round(depth))
            			:gsub("{position}", tostring(world));
            	end
            end

            -- interface
            local EspInterface = {
            	_hasLoaded = false,
            	_objectCache = {},
            	whitelist = {},
            	sharedSettings = {
            		textSize = 13,
            		textFont = 2,
            		limitDistance = false,
            		maxDistance = 150,
            		useTeamColor = false
            	},
            	teamSettings = {
            		enemy = {
            			enabled = false,
            			box = false,
            			boxColor = { Color3.new(1,0,0), 1 },
            			boxOutline = true,
            			boxOutlineColor = { Color3.new(), 1 },
            			boxFill = false,
            			boxFillColor = { Color3.new(1,0,0), 0.5 },
            			healthBar = false,
            			healthyColor = Color3.new(0,1,0),
            			dyingColor = Color3.new(1,0,0),
            			healthBarOutline = true,
            			healthBarOutlineColor = { Color3.new(), 0.5 },
            			healthText = false,
            			healthTextColor = { Color3.new(1,1,1), 1 },
            			healthTextOutline = true,
            			healthTextOutlineColor = Color3.new(),
            			box3d = false,
            			box3dColor = { Color3.new(1,0,0), 1 },
            			name = false,
            			nameColor = { Color3.new(1,1,1), 1 },
            			nameOutline = true,
            			nameOutlineColor = Color3.new(),
            			weapon = false,
            			weaponColor = { Color3.new(1,1,1), 1 },
            			weaponOutline = true,
            			weaponOutlineColor = Color3.new(),
            			distance = false,
            			distanceColor = { Color3.new(1,1,1), 1 },
            			distanceOutline = true,
            			distanceOutlineColor = Color3.new(),
            			tracer = false,
            			tracerOrigin = "Bottom",
            			tracerColor = { Color3.new(1,0,0), 1 },
            			tracerOutline = true,
            			tracerOutlineColor = { Color3.new(), 1 },
            			offScreenArrow = false,
            			offScreenArrowColor = { Color3.new(1,1,1), 1 },
            			offScreenArrowSize = 15,
            			offScreenArrowRadius = 150,
            			offScreenArrowOutline = true,
            			offScreenArrowOutlineColor = { Color3.new(), 1 },
            			chams = false,
            			chamsVisibleOnly = false,
            			chamsFillColor = { Color3.new(0.2, 0.2, 0.2), 0.5 },
            			chamsOutlineColor = { Color3.new(1,0,0), 0 },
            		},
            		friendly = {
            			enabled = false,
            			box = false,
            			boxColor = { Color3.new(0,1,0), 1 },
            			boxOutline = true,
            			boxOutlineColor = { Color3.new(), 1 },
            			boxFill = false,
            			boxFillColor = { Color3.new(0,1,0), 0.5 },
            			healthBar = false,
            			healthyColor = Color3.new(0,1,0),
            			dyingColor = Color3.new(1,0,0),
            			healthBarOutline = true,
            			healthBarOutlineColor = { Color3.new(), 0.5 },
            			healthText = false,
            			healthTextColor = { Color3.new(1,1,1), 1 },
            			healthTextOutline = true,
            			healthTextOutlineColor = Color3.new(),
            			box3d = false,
            			box3dColor = { Color3.new(0,1,0), 1 },
            			name = false,
            			nameColor = { Color3.new(1,1,1), 1 },
            			nameOutline = true,
            			nameOutlineColor = Color3.new(),
            			weapon = false,
            			weaponColor = { Color3.new(1,1,1), 1 },
            			weaponOutline = true,
            			weaponOutlineColor = Color3.new(),
            			distance = false,
            			distanceColor = { Color3.new(1,1,1), 1 },
            			distanceOutline = true,
            			distanceOutlineColor = Color3.new(),
            			tracer = false,
            			tracerOrigin = "Bottom",
            			tracerColor = { Color3.new(0,1,0), 1 },
            			tracerOutline = true,
            			tracerOutlineColor = { Color3.new(), 1 },
            			offScreenArrow = false,
            			offScreenArrowColor = { Color3.new(1,1,1), 1 },
            			offScreenArrowSize = 15,
            			offScreenArrowRadius = 150,
            			offScreenArrowOutline = true,
            			offScreenArrowOutlineColor = { Color3.new(), 1 },
            			chams = false,
            			chamsVisibleOnly = false,
            			chamsFillColor = { Color3.new(0.2, 0.2, 0.2), 0.5 },
            			chamsOutlineColor = { Color3.new(0,1,0), 0 }
            		}
            	}
            };

            function EspInterface.AddInstance(instance, options)
            	local cache = EspInterface._objectCache;
            	if cache[instance] then
            		warn("Instance handler already exists.");
            	else
            		cache[instance] = { InstanceObject.new(instance, options) };
            	end
            	return cache[instance][1];
            end

            function EspInterface.Load()
            	assert(not EspInterface._hasLoaded, "Esp has already been loaded.");
            
            	local function createObject(player)
            		EspInterface._objectCache[player] = {
            			EspObject.new(player, EspInterface),
            			ChamObject.new(player, EspInterface)
            		};
            	end
            
            	local function removeObject(player)
            		local object = EspInterface._objectCache[player];
            		if object then
            			for i = 1, #object do
            				object[i]:Destruct();
            			end
            			EspInterface._objectCache[player] = nil;
            		end
            	end
            
            	local plrs = players:GetPlayers();
            	for i = 2, #plrs do
            		createObject(plrs[i]);
            	end
            
            	EspInterface.playerAdded = players.PlayerAdded:Connect(createObject);
            	EspInterface.playerRemoving = players.PlayerRemoving:Connect(removeObject);
            	EspInterface._hasLoaded = true;
            end

            function EspInterface.Unload()
            	assert(EspInterface._hasLoaded, "Esp has not been loaded yet.");
            
            	for index, object in next, EspInterface._objectCache do
            		for i = 1, #object do
            			object[i]:Destruct();
            		end
            		EspInterface._objectCache[index] = nil;
            	end
            
            	EspInterface.playerAdded:Disconnect();
            	EspInterface.playerRemoving:Disconnect();
            	EspInterface._hasLoaded = false;
            end

            -- game specific functions
            function EspInterface.getWeapon(player)
            	for a,b in next, player:GetChildren() do 
                    if b.ClassName == 'Tool' then
                        return tostring(b.Name)
                    end
                end
                return '';
            end

            function EspInterface.isFriendly(player)
            	return player.Team and player.Team == localPlayer.Team;
            end

            function EspInterface.getTeamColor(player)
            	return player.Team and player.Team.TeamColor and player.Team.TeamColor.Color;
            end

            function EspInterface.getCharacter(player)
            	return player.Character;
            end

            function EspInterface.getHealth(player)
            	local character = player and EspInterface.getCharacter(player);
            	local humanoid = character and findFirstChildOfClass(character, "Humanoid");
            	if humanoid then
            		return humanoid.Health, humanoid.MaxHealth;
            	end
            	return 100, 100;
            end

            return EspInterface;
        end
    end
end

local LicenseType = {}
if License == "KEYAUTH-quantum.wtf-developer-license" then
    LicenseType = "developer"
else
    LicenseType = "beta-tester"
end

--// about ui library and license
local Library = LibraryLoadstring()
local ThemeManager = LibraryThemeManagerLoadstring()
local SaveManager = LibrarySaveManagerLoadstring()
local Sense = ESPSenseLibraryLoadstringInFunctionType()

--* Configuration *--
local initialized = false
local sessionid = ""

--* Application Details *--
Name = "quantum.wtf" --* Application Name
Ownerid = "rcj3wpoVnP" --* OwnerID
APPVersion = "1.0"     --* Application Version

local req = game:HttpGet('https://keyauth.win/api/1.1/?name=' .. Name .. '&ownerid=' .. Ownerid .. '&type=init&ver=' .. APPVersion)

if req == "KeyAuth_Invalid" then 
   print(" < [quantum.wtf]  - Application not found. >")
   Library:Notify(' [quantum.wtf] - Application not found.')
   return false
end

local data = HttpService:JSONDecode(req)

if data.success == true then
   initialized = true
   sessionid = data.sessionid
   --print(req)
elseif (data.message == "invalidver") then
   print(" < [quantum.wtf] - Error: Wrong application version... > ")
   Library:Notify(' [quantum.wtf] - Error: Wrong application version...')

   return false
else
   print(" < [quantum.wtf] - Error: " .. data.message .. " > ")
   Library:Notify(' [quantum.wtf] - Error: ' .. data.message)
   return false
end

print(" < [quantum.wtf] - checking license... >")
Library:Notify(' [quantum.wtf] - checking license...')

local req = game:HttpGet('https://keyauth.win/api/1.1/?name=' .. Name .. '&ownerid=' .. Ownerid .. '&type=license&key=' .. License ..'&ver=' .. APPVersion .. '&sessionid=' .. sessionid)
local data = HttpService:JSONDecode(req)


if data.success == false then
    print(" < [quantum.wtf] - Error: " .. data.message .. " > ")
    Library:Notify(' [quantum.wtf] - Error: ' .. data.message)

    return false
end

print(" < [quantum.wtf]  - Your key is valid, loading... >")
Library:Notify(' [quantum.wtf] - Your key is valid, loading...')

--// Silent Aim
-- init
if not game:IsLoaded() then 
    game.Loaded:Wait()
end
 
if not syn or not protectgui then
    getgenv().protectgui = function() end
end
 
local SilentAimSettings = {
    Enabled = false,
 
    ClassName = "Universal Silent Aim - Aethiel",
    ToggleKey = "RightAlt",
 
    TeamCheck = false,
    VisibleCheck = false, 
    TargetPart = "HumanoidRootPart",
    SilentAimMethod = "Raycast",
 
    FOVRadius = 130,
    FOVVisible = false,
    ShowSilentAimTarget = false, 
 
    MouseHitPrediction = false,
    MouseHitPredictionAmount = 0.165,
    HitChance = 100
}
 
-- variables
getgenv().SilentAimSettings = SilentAimSettings
local MainFileName = "UniversalSilentAim"
local SelectedFile, FileToSave = "", ""
 
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
 
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
 
local GetChildren = game.GetChildren
local GetPlayers = Players.GetPlayers
local WorldToScreen = Camera.WorldToScreenPoint
local WorldToViewportPoint = Camera.WorldToViewportPoint
local GetPartsObscuringTarget = Camera.GetPartsObscuringTarget
local FindFirstChild = game.FindFirstChild
local RenderStepped = RunService.RenderStepped
local GuiInset = GuiService.GetGuiInset
local GetMouseLocation = UserInputService.GetMouseLocation
 
local resume = coroutine.resume 
local create = coroutine.create
 
local ValidTargetParts = {"Head", "HumanoidRootPart"}
local PredictionAmount = 0.165
 
local mouse_box = Drawing.new("Square")
mouse_box.Visible = true 
mouse_box.ZIndex = 999 
mouse_box.Color = Color3.fromRGB(54, 57, 241)
mouse_box.Thickness = 5 
mouse_box.Size = Vector2.new(20, 20)
mouse_box.Filled = true 
 
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.NumSides = 100
fov_circle.Radius = 180
fov_circle.Filled = false
fov_circle.Visible = false
fov_circle.ZIndex = 999
fov_circle.Transparency = 1
fov_circle.Color = Color3.fromRGB(54, 57, 241)
 
local ExpectedArguments = {
    FindPartOnRayWithIgnoreList = {
        ArgCountRequired = 3,
        Args = {
            "Instance", "Ray", "table", "boolean", "boolean"
        }
    },
    FindPartOnRayWithWhitelist = {
        ArgCountRequired = 3,
        Args = {
            "Instance", "Ray", "table", "boolean"
        }
    },
    FindPartOnRay = {
        ArgCountRequired = 2,
        Args = {
            "Instance", "Ray", "Instance", "boolean", "boolean"
        }
    },
    Raycast = {
        ArgCountRequired = 3,
        Args = {
            "Instance", "Vector3", "Vector3", "RaycastParams"
        }
    }
}
 
function CalculateChance(Percentage)
    -- // Floor the percentage
    Percentage = math.floor(Percentage)
 
    -- // Get the chance
    local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100
 
    -- // Return
    return chance <= Percentage / 100
end
 
 
--[[file handling]] do 
    if not isfolder(MainFileName) then 
        makefolder(MainFileName);
    end
 
    if not isfolder(string.format("%s/%s", MainFileName, tostring(game.PlaceId))) then 
        makefolder(string.format("%s/%s", MainFileName, tostring(game.PlaceId)))
    end
end
 
local function getPositionOnScreen(Vector)
    local Vec3, OnScreen = WorldToScreen(Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end
 
local function ValidateArguments(Args, RayMethod)
    local Matches = 0
    if #Args < RayMethod.ArgCountRequired then
        return false
    end
    for Pos, Argument in next, Args do
        if typeof(Argument) == RayMethod.Args[Pos] then
            Matches = Matches + 1
        end
    end
    return Matches >= RayMethod.ArgCountRequired
end
 
local function getDirection(Origin, Position)
    return (Position - Origin).Unit * 1000
end
 
local function getMousePosition()
    return GetMouseLocation(UserInputService)
end
 
local function IsPlayerVisible(Player)
    local PlayerCharacter = Player.Character
    local LocalPlayerCharacter = LocalPlayer.Character
 
    if not (PlayerCharacter or LocalPlayerCharacter) then return end 
 
    local PlayerRoot = FindFirstChild(PlayerCharacter, Options.TargetPart.Value) or FindFirstChild(PlayerCharacter, "HumanoidRootPart")
 
    if not PlayerRoot then return end 
 
    local CastPoints, IgnoreList = {PlayerRoot.Position, LocalPlayerCharacter, PlayerCharacter}, {LocalPlayerCharacter, PlayerCharacter}
    local ObscuringObjects = #GetPartsObscuringTarget(Camera, CastPoints, IgnoreList)
 
    return ((ObscuringObjects == 0 and true) or (ObscuringObjects > 0 and false))
end
 
local function getClosestPlayer()
    if not Options.TargetPart.Value then return end
    local Closest
    local DistanceToMouse
    for _, Player in next, GetPlayers(Players) do
        if Player == LocalPlayer then continue end
        if Toggles.TeamCheck.Value and Player.Team == LocalPlayer.Team then continue end
 
        local Character = Player.Character
        if not Character then continue end
 
        if Toggles.VisibleCheck.Value and not IsPlayerVisible(Player) then continue end
 
        local HumanoidRootPart = FindFirstChild(Character, "HumanoidRootPart")
        local Humanoid = FindFirstChild(Character, "Humanoid")
        if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then continue end
 
        local ScreenPosition, OnScreen = getPositionOnScreen(HumanoidRootPart.Position)
        if not OnScreen then continue end
 
        local Distance = (getMousePosition() - ScreenPosition).Magnitude
        if Distance <= (DistanceToMouse or Options.Radius.Value or 2000) then
            Closest = ((Options.TargetPart.Value == "Random" and Character[ValidTargetParts[math.random(1, #ValidTargetParts)]]) or Character[Options.TargetPart.Value])
            DistanceToMouse = Distance
        end
    end
    return Closest
end

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace:FindFirstChildWhichIsA("Camera")
local Hitsounds = {}

    --// Script Table
    local Script = {
        Functions = {},
        Locals = {
            Target = nil,
            IsTargetting = false,
            Resolver = {
                OldTick = tick(),
                OldPos = Vector3.new(0, 0, 0),
                ResolvedVelocity = Vector3.new(0, 0, 0)
            },
            AutoSelectTick = tick(),
            AntiAimViewer = {
                MouseRemoteFound = false,
                MouseRemote = nil,
                MouseRemoteArgs = nil,
                MouseRemotePositionIndex = nil
            },
            HitEffect = nil,
            Gun = {
                PreviousGun = nil,
                PreviousAmmo = 999,
                Shotguns = {"[Double-Barrel SG]", "[TacticalShotgun]", "[Shotgun]"}
            },
            PlayerHealth = {},
            JumpOffset = 0,
            BulletPath = {
                [4312377180] = Workspace:FindFirstChild("MAP") and Workspace.MAP:FindFirstChild("Ignored") or nil,
                [1008451066] = Workspace:FindFirstChild("Ignored") and Workspace.Ignored:FindFirstChild("Siren") and Workspace.Ignored.Siren:FindFirstChild("Radius") or nil,
                [3985694250] = Workspace and Workspace:FindFirstChild("Ignored") or nil,
                [5106782457] = Workspace and Workspace:FindFirstChild("Ignored") or nil,
                [4937639028] = Workspace and Workspace:FindFirstChild("Ignored") or nil,
                [1958807588] = Workspace and Workspace:FindFirstChild("Ignored") or nil
            },
            World = {
                FogColor = Lighting.FogColor,
                FogStart = Lighting.FogStart,
                FogEnd = Lighting.FogEnd,
                Ambient = Lighting.Ambient,
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                ExposureCompensation = Lighting.ExposureCompensation
            },
        
            NetworkPreviousTick = tick(),
            NetworkShouldSleep = false,
            FFlags = {
           },
            OriginalVelocity = {},
            RotationAngle = 0
        },
        Utility = {
            Drawings = {},
            EspCache = {}
        },
        Connections = {
            GunConnections = {}
        },
        AzureIgnoreFolder = Instance.new("Folder", game:GetService("Workspace"))
    }

    --// Settings Table
    local Settings = {
        Combat = {
            Enabled = false,
            AimPart = "HumanoidRootPart",
            Silent = false,
            Mouse = false,
            Alerts = false,
            LookAt = false,
            Spectate = false,
            AntiAimViewer = false,
            AutoSelect = {
                Enabled = false,
                Cooldown = {
                    Enabled = false,
                    Amount = 0.5
                }
            },
            Checks = {
                Enabled = false,
                Knocked = false,
                Crew = false,
                Wall = false,
                Grabbed = false,
                Vehicle = false
            },
            Smoothing = {
                Horizontal = 1,
                Vertical = 1
            },
            Prediction = {
                Horizontal = 0.134,
                Vertical = 0.134
            },
            Resolver = {
                Enabled = false,
                RefreshRate = 0
            },
            Fov = {
                Enabled = false,
                Visualize = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1)
                },
                Radius = 80
            },
            Visuals = {
                Enabled = false,
                Tracer = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1),
                    Thickness = 2
                },
                Dot = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1),
                    Filled = false,
                    Size = 6
                },
                Chams = {
                    Enabled = false,
                    Fill = {
                        Color = Color3.new(1, 1, 1),
                        Transparency = 0.5
                    },
                    Outline = {
                        Color = Color3.new(1, 1, 1),
                        Transparency = 0.5
                    }
                }
            },
            Air = {
                Enabled = false,
                AirAimPart = {
                    Enabled = false,
                    HitPart = "LowerTorso"
                },
                JumpOffset = {
                    Enabled = false,
                    Offset = 0.09
                }
            }
        },
        Visuals = {
            Esp = {
                Enabled = false,
                Boxes = {
                    Enabled = false,
                    Filled = {
                        Enabled = false,
                        Color = Color3.new(1, 1, 1),
                        Transparency = 0.3
                    },
                    Color = Color3.new(1, 1, 1)
                }
            },
            BulletTracers = {
                Enabled = false,
                Color = {
                    Gradient1 = Color3.new(1, 1, 1),
                    Gradient2 = Color3.new(0, 0, 0)
                },
                Duration = 1,
                Fade = {
                    Enabled = false,
                    Duration = 0.5
                }
            },
            BulletImpacts = {
                Enabled = false,
                Color = Color3.new(1, 1, 1),
                Duration = 1,
                Size = 1,
                Material = "SmoothPlastic",
                Fade = {
                    Enabled = false,
                    Duration = 0.5
                }
            },
            OnHit = {
                Enabled = false,
                Effect = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1)
                },
                Sound = {
                    Enabled = false,
                    Volume = 5,
                    Value = "Skeet"
                },
                Chams = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1),
                    Material = "ForceField",
                    Duration = 1
                }
            },
            World = {
                Enabled = false,
                Fog = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1),
                    End = 1000,
                    Start = 10000
                },
                Ambient = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1)
                },
                Brightness = {
                    Enabled = false,
                    Value = 0
                },
                ClockTime = {
                    Enabled = false,
                    Value = 24
                },
                WorldExposure = {
                    Enabled = false,
                    Value = -0.1
                }
            },
            Crosshair = {
                Enabled = false,
                Color = Color3.new(1, 1, 1),
                Size = 10,
                Gap = 2,
                Rotation = {
                    Enabled = false,
                    Speed = 1
                }
            }
        },
        AntiAim = {
            VelocitySpoofer = {
                Enabled = false,
                Visualize = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1),
                    Prediction = 0.134
                },
                Type = "Underground",
                Roll = 0,
                Pitch = 0,
                Yaw = 0
            },
            CSync = {
                Enabled = false,
                Type = "Custom",
                Visualize = {
                    Enabled = false,
                    Color = Color3.new(1, 1, 1)
                },
                RandomDistance = 16,
                Custom = {
                    X = 0,
                    Y = 0,
                    Z = 0
                },
                TargetStrafe = {
                    Speed = 1,
                    Distance = 1,
                    Height = 1
                }
            },
            Network = {
                Enabled = false,
                WalkingCheck = false,
                Amount = 0.1
            },
            VelocityDesync = {
                Enabled = false,
                Range = 1
            },
            FFlagDesync = {
                Enabled = false,
                SetNew = false,
                FFlags = {"S2PhysicsSenderRate"},
                SetNewAmount = 15,
                Amount = 2
            },
        },
        Misc = {
            Movement = {
                Speed = {
                    Enabled = false,
                    Amount = 1
                },
            },
            Exploits = {
                Enabled = false,
                NoRecoil = false,
                NoJumpCooldown = false,
                NoSlowDown = false
            }
        }
    }

    --// Functions
    do
        --// Utility Functions
        do
            Script.Functions.WorldToScreen = function(Position: Vector3)
                if not Position then return end

                local ViewportPointPosition, OnScreen = Camera:WorldToViewportPoint(Position)
                local ScreenPosition = Vector2.new(ViewportPointPosition.X, ViewportPointPosition.Y)
                return {
                    Position = ScreenPosition,
                    OnScreen = OnScreen
                }
            end

            Script.Functions.Connection = function(ConnectionType: any, Function: any)
                local Connection = ConnectionType:Connect(Function)
                return Connection
            end

            Script.Functions.MoveMouse = function(Position: Vector2, SmoothingX: number, SmoothingY: number)
                local MousePosition = UserInputService:GetMouseLocation()

                mousemoverel((Position.X - MousePosition.X) / SmoothingX, (Position.Y - MousePosition.Y) / SmoothingY)
            end

            Script.Functions.CreateDrawing = function(DrawingType: string, Properties: any)
                local DrawingObject = Drawing.new(DrawingType)

                for Property, Value in pairs(Properties) do
                    DrawingObject[Property] = Value
                end
                return DrawingObject
            end

            Script.Functions.WallCheck = function(Part: any)
                local RayCastParams = RaycastParams.new()
                RayCastParams.FilterType = Enum.RaycastFilterType.Exclude
                RayCastParams.IgnoreWater = true
                RayCastParams.FilterDescendantsInstances = Script.AzureIgnoreFolder:GetChildren()

                local CameraPosition = Camera.CFrame.Position
                local Direction = (Part.Position - CameraPosition).Unit
                local RayCastResult = workspace:Raycast(CameraPosition, Direction * 10000, RayCastParams)

                return RayCastResult.Instance and RayCastResult.Instance == Part
            end

            Script.Functions.Create = function(ObjectType: string, Properties: any)
                local Object = Instance.new(ObjectType)

                for Property, Value in pairs(Properties) do
                    Object[Property] = Value
                end
                return Object
            end

            Script.Functions.GetGun = function(Player: any)
                local Info = {
                    Tool = nil,
                    Ammo = nil,
                    IsGunEquipped = false
                }

                local Tool = Player.Character:FindFirstChildWhichIsA("Tool")

                if not Tool then return end

                if game.GameId == 1958807588 then
                    local ArmoryGun = Player.Information.Armory:FindFirstChild(Tool.Name)
                    if ArmoryGun then
                        Info.Tool = Tool
                        Info.Ammo = ArmoryGun.Ammo.Normal
                        Info.IsGunEquipped = true
                    else
                        for _, Object in pairs(Tool:GetChildren()) do
                            if Object.Name:lower():find("ammo") and not Object.Name:lower():find("max") then
                                Info.Tool = Tool
                                Info.IsGunEquipped = true
                                Info.Ammo = Object
                            end
                        end
                    end
                elseif game.GameId == 3634139746 then
                    for _, Object in pairs(Tool:getdescendants()) do
                        if Object.Name:lower():find("ammo") and not Object.Name:lower():find("max") and not Object.Name:lower():find("no") then
                            Info.Tool = Tool
                            Info.Ammo = Object
                            Info.IsGunEquipped = true
                        end
                    end
                else
                    for _, Object in pairs(Tool:GetChildren()) do
                        if Object.Name:lower():find("ammo") and not Object.Name:lower():find("max") then
                            Info.Tool = Tool
                            Info.IsGunEquipped = true
                            Info.Ammo = Object
                        end
                    end
                end


                return Info
            end

            Script.Functions.Beam = function(StartPos: Vector3, EndPos: Vector3)
                local ColorSequence = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Settings.Visuals.BulletTracers.Color.Gradient1),
                    ColorSequenceKeypoint.new(1, Settings.Visuals.BulletTracers.Color.Gradient2),
                })
                local Part = Instance.new("Part", Script.AzureIgnoreFolder)
                Part.Size = Vector3.new(0, 0, 0)
                Part.Massless = true
                Part.Transparency = 1
                Part.CanCollide = false
                Part.Position = StartPos
                Part.Anchored = true
                local Attachment = Instance.new("Attachment", Part)
                local Part2 = Instance.new("Part", Script.AzureIgnoreFolder)
                Part2.Size = Vector3.new(0, 0, 0)
                Part2.Transparency = 0
                Part2.CanCollide = false
                Part2.Position = EndPos
                Part2.Anchored = true
                Part2.Material = Enum.Material.ForceField
                Part2.Color = Color3.fromRGB(255, 0, 212)
                Part2.Massless = true
                local Attachment2 = Instance.new("Attachment", Part2)
                local Beam = Instance.new("Beam", Part)
                Beam.FaceCamera = true
                Beam.Color = ColorSequence
                Beam.Attachment0 = Attachment
                Beam.Attachment1 = Attachment2
                Beam.LightEmission = 6
                Beam.LightInfluence = 1
                Beam.Width0 = 1.5
                Beam.Width1 = 1.5
                Beam.Texture = "http://www.roblox.com/asset/?id=446111271"
                Beam.TextureSpeed = 2
                Beam.TextureLength = 1
                task.delay(Settings.Visuals.BulletTracers.Duration, function()
                    if Settings.Visuals.BulletTracers.Fade.Enabled then
                        local TweenValue = Instance.new("NumberValue")
                        TweenValue.Parent = Beam
                        local Tween = TweenService:Create(TweenValue, TweenInfo.new(Settings.Visuals.BulletTracers.Fade.Duration), {Value = 1})
                        Tween:Play()

                        local Connection
                        Connection = Script.Functions.Connection(TweenValue:GetPropertyChangedSignal("Value"), function()
                            Beam.Transparency = NumberSequence.new(TweenValue.Value, TweenValue.Value)
                        end)

                        Script.Functions.Connection(Tween.Completed, function()
                            Connection:Disconnect()
                            Part:Destroy()
                            Part2:Destroy()
                        end)
                    else
                        Part:Destroy()
                        Part2:Destroy()
                    end
                end)
            end

            Script.Functions.Impact = function(Pos: Vector3)
                local Part = Script.Functions.Create("Part", {
                    Parent = Script.AzureIgnoreFolder,
                    Color = Settings.Visuals.BulletImpacts.Color,
                    Size = Vector3.new(Settings.Visuals.BulletImpacts.Size, Settings.Visuals.BulletImpacts.Size, Settings.Visuals.BulletImpacts.Size),
                    Position = Pos,
                    Anchored = true,
                    Material = Enum.Material[Settings.Visuals.BulletImpacts.Material]
                })

                task.delay(Settings.Visuals.BulletImpacts.Duration, function()
                    if Settings.Visuals.BulletImpacts.Fade.Enabled then
                        local Tween = TweenService:Create(Part, TweenInfo.new(Settings.Visuals.BulletImpacts.Fade.Duration), {Transparency = 1})
                        Tween:Play()

                        Script.Functions.Connection(Tween.Completed, function()
                            Part:Destroy()
                        end)
                    else
                        Part:Destroy()
                    end
                end)
            end

            Script.Functions.GetClosestPlayerDamage = function(Position: Vector3, MaxRadius: number)
                local Radius = MaxRadius
                local ClosestPlayer

                for PlayerName, Health in pairs(Script.Locals.PlayerHealth) do
                    local Player = Players:FindFirstChild(PlayerName)
                    if Player and Player.Character then
                        local PlayerPosition = Player.Character.PrimaryPart.Position
                        local Distance = (Position - PlayerPosition).Magnitude
                        local CurrentHealth = Player.Character.Humanoid.Health
                        if (Distance < Radius) and (CurrentHealth < Health) then
                            Radius = Distance
                            ClosestPlayer = Player
                        end
                    end
                end
                return ClosestPlayer
            end


            Script.Functions.Effect = function(Part, Color)
                local Clone = Script.Locals.HitEffect:Clone()
                Clone.Parent = Part

                for _, Effect in pairs(Clone:GetChildren()) do
                    if Effect:IsA("ParticleEmitter") then
                        Effect.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                            ColorSequenceKeypoint.new(0.495, Settings.Visuals.OnHit.Effect.Color),
                            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
                        })
                        Effect:Emit(1)
                    end
                end

                task.delay(2, function()
                    Clone:Destroy()
                end)
            end

            Script.Functions.PlaySound = function(SoundId, Volume)
                local Sound = Instance.new("Sound")
                Sound.Parent = Script.AzureIgnoreFolder
                Sound.Volume = Volume
                Sound.SoundId = SoundId

                Sound:Play()

                Script.Functions.Connection(Sound.Ended, function()
                    Sound:Destroy()
                end)
            end

            Script.Functions.Hitcham = function(Player, Color)
                for _, BodyPart in pairs(Player.Character:GetChildren()) do
                    if BodyPart.Name ~= "HumanoidRootPart" and BodyPart:IsA("BasePart") then
                        local Part = Instance.new("Part")
                        Part.Name = BodyPart.Name .. "_Clone"
                        Part.Parent = Script.AzureIgnoreFolder
                        Part.Material = Enum.Material[Settings.Visuals.OnHit.Chams.Material]
                        Part.Color = Settings.Visuals.OnHit.Chams.Color
                        Part.Transparency = 0
                        Part.Anchored = true
                        Part.Size = BodyPart.Size
                        Part.CFrame = BodyPart.CFrame

                        task.delay(Settings.Visuals.OnHit.Chams.Duration, function()
                            Part:Destroy()
                        end)
                    end
                end
            end

            Script.Functions.Rotate = function(Vector, Origin, Angle)
                local CosA = math.cos(Angle)
                local SinA = math.sin(Angle)
                local X = Vector.X - Origin.X
                local Y = Vector.Y - Origin.Y
                local NewX = X * CosA - Y * SinA
                local NewY = X * SinA + Y * CosA
                return Vector2.new(NewX + Origin.x, NewY + Origin.y)
            end
        end

        --// General Functions
        do
            Script.Functions.GetClosestPlayer = function()
                local Radius = Settings.Combat.Fov.Enabled and Settings.Combat.Fov.Radius or math.huge
                local ClosestPlayer
                local Mouse = UserInputService:GetMouseLocation()

                for _, Player in pairs(Players:GetPlayers()) do
                    if Player ~= LocalPlayer then
                        --// Variables
                        local ScreenPosition = Script.Functions.WorldToScreen(Player.Character.PrimaryPart.Position)
                        local Distance = (Mouse - ScreenPosition.Position).Magnitude

                        --// OnScreen Check
                        if not ScreenPosition.OnScreen then continue end

                        --// Checks
                        if (Settings.Combat.Checks.Enabled and (Settings.Combat.Checks.Vehicle and Player.Character:FindFirstChild("[CarHitBox]")) or (Settings.Combat.Checks.Knocked and Player.Character.BodyEffects["K.O"].Value == true) or (Settings.Combat.Checks.Grabbed and Player.Character:FindFirstChild("GRABBING_CONSTRAINT")) or (Settings.Combat.Checks.Crew and Player.DataFolder.Information.Crew.Value == LocalPlayer.DataFolder.Information.Crew.Value) or (Settings.Combat.Checks.Wall and Script.Functions.WallCheck(Player.Character.PrimaryPart))) then continue end

                        if (Distance < Radius) then
                            Radius = Distance
                            ClosestPlayer = Player
                        end
                    end
                end

                return ClosestPlayer
            end

            Script.Functions.GetPredictedPosition = function()
                local BodyPart = Script.Locals.Target.Character[Settings.Combat.AimPart]
                local Velocity = Settings.Combat.Resolver.Enabled and Script.Locals.Resolver.ResolvedVelocity or Script.Locals.Target.Character.HumanoidRootPart.Velocity
                local Position = BodyPart.Position + Velocity * Vector3.new(Settings.Combat.Prediction.Horizontal, Settings.Combat.Prediction.Vertical, Settings.Combat.Prediction.Horizontal)

                if Settings.Combat.Air.Enabled and Settings.Combat.Air.JumpOffset.Enabled then
                    Position = Position + Vector3.new(0, Script.Locals.JumpOffset, 0)
                end

                return Position
            end

            Script.Functions.Resolve = function()
                if Settings.Combat.Enabled and Settings.Combat.Resolver.Enabled and Script.Locals.IsTargetting and Script.Locals.Target then
                    --// Variables
                    local HumanoidRootPart = Script.Locals.Target.Character.HumanoidRootPart
                    local CurrentPosition = HumanoidRootPart.Position
                    local DeltaTime = tick() - Script.Locals.Resolver.OldTick
                    local NewVelocity = (CurrentPosition - Script.Locals.Resolver.OldPos) / DeltaTime

                    --// Set the velocity
                    Script.Locals.Resolver.ResolvedVelocity = NewVelocity

                    --// Update the old tick and old position
                    if tick() - Script.Locals.Resolver.OldTick >= 1 / Settings.Combat.Resolver.RefreshRate then
                        Script.Locals.Resolver.OldTick, Script.Locals.Resolver.OldPos = tick(), HumanoidRootPart.Position
                    end
                end
            end

            Script.Functions.MouseAim = function()
                if Settings.Combat.Enabled and Settings.Combat.Mouse and Script.Locals.IsTargetting and Script.Locals.Target then
                    local Position = Script.Functions.GetPredictedPosition()
                    local ScreenPosition = Script.Functions.WorldToScreen(Position)

                    if ScreenPosition.OnScreen then
                        Script.Functions.MoveMouse(ScreenPosition.Position, Settings.Combat.Smoothing.Horizontal, Settings.Combat.Smoothing.Vertical)
                    end
                end
            end

            Script.Functions.UpdateFieldOfView = function()
                Script.Utility.Drawings["FieldOfViewVisualizer"].Visible = Settings.Combat.Enabled and Settings.Combat.Fov.Enabled and Settings.Combat.Fov.Visualize.Enabled
                Script.Utility.Drawings["FieldOfViewVisualizer"].Color = Settings.Combat.Fov.Visualize.Color
                Script.Utility.Drawings["FieldOfViewVisualizer"].Radius = Settings.Combat.Fov.Radius
                Script.Utility.Drawings["FieldOfViewVisualizer"].Position = UserInputService:GetMouseLocation()
            end

            Script.Functions.UpdateTargetVisuals = function()
                --// ScreenPosition, Will be changed later
                local Position

                --// Variable to indicate if you"re targetting or not with a check if the target visuals are enabled
                local IsTargetting = Settings.Combat.Enabled and Settings.Combat.Visuals.Enabled and Script.Locals.IsTargetting and Script.Locals.Target or false

                --// Change the position
                if IsTargetting then
                    local PredictedPosition = Script.Functions.GetPredictedPosition()
                    Position = Script.Functions.WorldToScreen(PredictedPosition)
                end

                --// Variable to indicate if the drawing elements should show
                local TracerShow = IsTargetting and Settings.Combat.Visuals.Tracer.Enabled and Position.OnScreen or false
                local DotShow = IsTargetting and Settings.Combat.Visuals.Dot.Enabled and Position.OnScreen or false
                local ChamsShow = IsTargetting and Settings.Combat.Visuals.Chams.Enabled and Script.Locals.Target and Script.Locals.Target.Character or nil


                --// Set the drawing elements visibility
                Script.Utility.Drawings["TargetTracer"].Visible = TracerShow
                Script.Utility.Drawings["TargetDot"].Visible = DotShow
                Script.Utility.Drawings["TargetChams"].Parent = ChamsShow


                --// Update the drawing elements
                if TracerShow then
                    Script.Utility.Drawings["TargetTracer"].From = UserInputService:GetMouseLocation()
                    Script.Utility.Drawings["TargetTracer"].To = Position.Position
                    Script.Utility.Drawings["TargetTracer"].Color = Settings.Combat.Visuals.Tracer.Color
                    Script.Utility.Drawings["TargetTracer"].Thickness = Settings.Combat.Visuals.Tracer.Thickness
                end

                if DotShow then
                    Script.Utility.Drawings["TargetDot"].Position = Position.Position
                    Script.Utility.Drawings["TargetDot"].Radius = Settings.Combat.Visuals.Dot.Size
                    Script.Utility.Drawings["TargetDot"].Filled = Settings.Combat.Visuals.Dot.Filled
                    Script.Utility.Drawings["TargetDot"].Color = Settings.Combat.Visuals.Dot.Color
                end

                if ChamsShow then
                    Script.Utility.Drawings["TargetChams"].FillColor = Settings.Combat.Visuals.Chams.Fill.Color
                    Script.Utility.Drawings["TargetChams"].FillTransparency = Settings.Combat.Visuals.Chams.Fill.Transparency
                    Script.Utility.Drawings["TargetChams"].OutlineTransparency = Settings.Combat.Visuals.Chams.Outline.Transparency
                    Script.Utility.Drawings["TargetChams"].OutlineColor = Settings.Combat.Visuals.Chams.Outline.Color
                end
            end

            Script.Functions.AutoSelect = function()
                if (Settings.Combat.Enabled and Settings.Combat.AutoSelect.Enabled) and (tick() - Script.Locals.AutoSelectTick >= Settings.Combat.AutoSelect.Cooldown.Amount and Settings.Combat.AutoSelect.Cooldown.Enabled or true) then
                    local NewTarget = Script.Functions.GetClosestPlayer()
                    Script.Locals.Target = NewTarget or nil
                    Script.Locals.IsTargetting =  NewTarget and true or false
                    Script.Locals.AutoSelectTick = tick()
                end
            end

            Script.Functions.GunEvents = function()
                local CurrentGun = Script.Functions.GetGun(LocalPlayer)

                if CurrentGun and CurrentGun.IsGunEquipped and CurrentGun.Tool then
                    if CurrentGun.Tool ~= Script.Locals.Gun.PreviousGun then
                        Script.Locals.Gun.PreviousGun = CurrentGun.Tool
                        Script.Locals.Gun.PreviousAmmo = 999

                        --// Connections
                        for _, Connection in pairs(Script.Connections.GunConnections) do
                            Connection:Disconnect()
                        end
                        Script.Connections.GunConnections = {}
                    end

                    if not Script.Connections.GunConnections["GunActivated"] and Settings.Combat.Enabled and Settings.Combat.Silent and Script.Locals.AntiAimViewer.MouseRemoteFound then
                        Script.Connections.GunConnections["GunActivated"] = Script.Functions.Connection(CurrentGun.Tool.Activated, function()
                            if Script.Locals.IsTargetting and Script.Locals.Target then
                                if Settings.Combat.AntiAimViewer then
                                    local Arguments = Script.Locals.AntiAimViewer.MouseRemoteArgs

                                    Arguments[Script.Locals.AntiAimViewer.MouseRemotePositionIndex] = Script.Functions.GetPredictedPosition()
                                    Script.Locals.AntiAimViewer.MouseRemote:FireServer(unpack(Arguments))
                                end
                            end
                        end)
                    end


                    if not Script.Connections.GunConnections["GunAmmoChanged"] then
                        Script.Connections.GunConnections["GunAmmoChanged"] = Script.Functions.Connection(CurrentGun.Ammo:GetPropertyChangedSignal("Value") , function()
                            local NewAmmo = CurrentGun.Ammo.Value
                            if (NewAmmo < Script.Locals.Gun.PreviousAmmo or (game.GameId == 3985694250 and NewAmmo > Script.Locals.Gun.PreviousAmmo)) and Script.Locals.Gun.PreviousAmmo then

                                local ChildAdded
                                local ChildrenAdded = 0
                                ChildAdded = Script.Functions.Connection(Script.Locals.BulletPath[game.GameId].ChildAdded, function(Object)
                                    if Object.Name == "BULLET_RAYS" then
                                        ChildrenAdded += 1
                                        if (table.find(Script.Locals.Gun.Shotguns, CurrentGun.Tool.Name) and ChildrenAdded <= 5) or (ChildrenAdded == 1) then
                                            local GunBeam = Object:WaitForChild("GunBeam")
                                            local StartPos, EndPos = Object.Position, GunBeam.Attachment1.WorldPosition

                                            if Settings.Visuals.BulletTracers.Enabled then
                                                GunBeam:Destroy()
                                                Script.Functions.Beam(StartPos, EndPos)
                                            end

                                            if Settings.Visuals.BulletImpacts.Enabled then
                                                Script.Functions.Impact(EndPos)
                                            end

                                            if Settings.Visuals.OnHit.Enabled then
                                                local Player = Script.Functions.GetClosestPlayerDamage(EndPos, 20)
                                                if Player then
                                                    if Settings.Visuals.OnHit.Effect.Enabled then
                                                        Script.Functions.Effect(Player.Character.HumanoidRootPart)
                                                    end

                                                    if Settings.Visuals.OnHit.Sound.Enabled then
                                                        local Sound = string.format("hitsounds/%s", Settings.Visuals.OnHit.Sound.Value)
                                                        Script.Functions.PlaySound(getcustomasset(Sound), Settings.Visuals.OnHit.Sound.Volume)
                                                    end

                                                    if Settings.Visuals.OnHit.Chams.Enabled then
                                                        Script.Functions.Hitcham(Player, Settings.Visuals.OnHit.Chams.Color)
                                                    end
                                                end
                                            end
                                            ChildAdded:Disconnect()
                                        end
                                    else
                                        ChildAdded:Disconnect()
                                    end
                                end)
                            end
                            Script.Locals.Gun.PreviousAmmo = NewAmmo
                        end)
                    end
                end
            end

            Script.Functions.Air = function()
                if Settings.Combat.Enabled and Script.Locals.IsTargetting and Script.Locals.Target and Settings.Combat.Air.Enabled then
                    local Humanoid = Script.Locals.Target.Character.Humanoid

                    if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                        Script.Locals.JumpOffset = Settings.Combat.Air.JumpOffset.Offset
                    else
                        Script.Locals.JumpOffset = 0
                    end
                end
            end

            Script.Functions.UpdateHealth = function()
                if Settings.Visuals.OnHit.Enabled then
                    for _, Player in pairs(Players:GetPlayers()) do
                        if Player.Character and Player.Character.Humanoid then
                            Script.Locals.PlayerHealth[Player.Name] = Player.Character.Humanoid.Health
                        end
                    end
                end
            end

            Script.Functions.UpdateAtmosphere = function()
                Lighting.FogColor = Settings.Visuals.World.Enabled and Settings.Visuals.World.Fog.Enabled and Settings.Visuals.World.Fog.Color or Script.Locals.World.FogColor
                Lighting.FogStart = Settings.Visuals.World.Enabled and Settings.Visuals.World.Fog.Enabled and Settings.Visuals.World.Fog.Start or Script.Locals.World.FogStart
                Lighting.FogEnd = Settings.Visuals.World.Enabled and Settings.Visuals.World.Fog.Enabled and Settings.Visuals.World.Fog.End or Script.Locals.World.FogEnd
                Lighting.Ambient = Settings.Visuals.World.Enabled and Settings.Visuals.World.Ambient.Enabled and Settings.Visuals.World.Ambient.Color or Script.Locals.World.Ambient
                Lighting.Brightness = Settings.Visuals.World.Enabled and Settings.Visuals.World.Brightness.Enabled and Settings.Visuals.World.Brightness.Value or Script.Locals.World.Brightness
                Lighting.ClockTime = Settings.Visuals.World.Enabled and Settings.Visuals.World.ClockTime.Enabled and Settings.Visuals.World.ClockTime.Value or Script.Locals.World.ClockTime
                Lighting.ExposureCompensation = Settings.Visuals.World.Enabled and Settings.Visuals.World.WorldExposure.Enabled and Settings.Visuals.World.WorldExposure.Value or Script.Locals.World.ExposureCompensation
            end

            Script.Functions.VelocitySpoof = function()
                local ShowVisualizerDot = Settings.AntiAim.VelocitySpoofer.Enabled and Settings.AntiAim.VelocitySpoofer.Visualize.Enabled

                Script.Utility.Drawings["VelocityDot"].Visible = ShowVisualizerDot


                if Settings.AntiAim.VelocitySpoofer.Enabled then
                    --// Variables
                    local Type = Settings.AntiAim.VelocitySpoofer.Type
                    local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                    local Velocity = HumanoidRootPart.Velocity

                    --// Main
                    if Type == "Underground" then
                        HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(0, -Settings.AntiAim.VelocitySpoofer.Yaw, 0)
                    elseif Type == "Sky" then
                        HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(0, Settings.AntiAim.VelocitySpoofer.Yaw, 0)
                    elseif Type == "Multiplier" then
                        HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(Settings.AntiAim.VelocitySpoofer.Yaw, Settings.AntiAim.VelocitySpoofer.Pitch, Settings.AntiAim.VelocitySpoofer.Roll)
                    elseif Type == "Custom" then
                        HumanoidRootPart.Velocity = Vector3.new(Settings.AntiAim.VelocitySpoofer.Yaw, Settings.AntiAim.VelocitySpoofer.Pitch, Settings.AntiAim.VelocitySpoofer.Roll)
                    elseif Type == "Prediction Breaker" then
                        HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                    end

                    if ShowVisualizerDot then
                        local ScreenPosition = Script.Functions.WorldToScreen(LocalPlayer.Character.HumanoidRootPart.Position + LocalPlayer.Character.HumanoidRootPart.Velocity * Settings.AntiAim.VelocitySpoofer.Visualize.Prediction)

                        Script.Utility.Drawings["VelocityDot"].Position = ScreenPosition.Position
                        Script.Utility.Drawings["VelocityDot"].Color = Settings.AntiAim.VelocitySpoofer.Visualize.Color
                    end

                    RunService.RenderStepped:Wait()
                    HumanoidRootPart.Velocity = Velocity
                end
            end

            Script.Functions.CSync = function()
                Script.Utility.Drawings["CFrameVisualize"].Parent = Settings.AntiAim.CSync.Visualize.Enabled and Settings.AntiAim.CSync.Enabled and Script.AzureIgnoreFolder or nil

                if Settings.AntiAim.CSync.Enabled then
                    local Type = Settings.AntiAim.CSync.Type
                    local FakeCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    Script.Locals.SavedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    if Type == "Custom" then
                        FakeCFrame = FakeCFrame * CFrame.new(Settings.AntiAim.CSync.Custom.X, Settings.AntiAim.CSync.Custom.Y, Settings.AntiAim.CSync.Custom.Z)
                    elseif Type == "Target Strafe" and Script.Locals.IsTargetting and Script.Locals.Target and Settings.Combat.Enabled then
                        local CurrentTime = tick()
                        FakeCFrame = CFrame.new(Script.Locals.Target.Character.HumanoidRootPart.Position) * CFrame.Angles(0, 2 * math.pi * CurrentTime * Settings.AntiAim.CSync.TargetStrafe.Speed % (2 * math.pi), 0) * CFrame.new(0, Settings.AntiAim.CSync.TargetStrafe.Height, Settings.AntiAim.CSync.TargetStrafe.Distance)
                    elseif Type == "Local Strafe" then
                        local CurrentTime = tick()
                        FakeCFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.Angles(0, 2 * math.pi * CurrentTime * Settings.AntiAim.CSync.TargetStrafe.Speed % (2 * math.pi), 0) * CFrame.new(0, Settings.AntiAim.CSync.TargetStrafe.Height, Settings.AntiAim.CSync.TargetStrafe.Distance)
                    elseif Type == "Random" then
                        FakeCFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance), math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance), math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance))) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))
                    elseif Type == "Random Target" and Script.Locals.IsTargetting and Script.Locals.Target and Settings.Combat.Enabled then
                        FakeCFrame = CFrame.new(Script.Locals.Target.Character.HumanoidRootPart.Position + Vector3.new(math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance), math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance), math.random(-Settings.AntiAim.CSync.RandomDistance, Settings.AntiAim.CSync.RandomDistance))) * CFrame.Angles(math.rad(math.random(0, 360)), math.rad(math.random(0, 360)), math.rad(math.random(0, 360)))
                    end

                    Script.Utility.Drawings["CFrameVisualize"]:SetPrimaryPartCFrame(FakeCFrame)

                    for _, Part in pairs(Script.Utility.Drawings["CFrameVisualize"]:GetChildren()) do
                        Part.Color = Settings.AntiAim.CSync.Visualize.Color
                    end

                    LocalPlayer.Character.HumanoidRootPart.CFrame = FakeCFrame
                    RunService.RenderStepped:Wait()
                    LocalPlayer.Character.HumanoidRootPart.CFrame = Script.Locals.SavedCFrame
                end
            end

            Script.Functions.Network = function()
                if Settings.AntiAim.Network.Enabled then
                    if (tick() - Script.Locals.NetworkPreviousTick) >= ((Settings.AntiAim.Network.Amount / math.pi) / 10000) or (Settings.AntiAim.Network.WalkingCheck and LocalPlayer.Character.Humanoid.MoveDirection.Magnitude > 0) then
                        Script.Locals.NetworkShouldSleep = not Script.Locals.NetworkShouldSleep
                        Script.Locals.NetworkPreviousTick = tick()
                        sethiddenproperty(LocalPlayer.Character.HumanoidRootPart, "NetworkIsSleeping", Script.Locals.NetworkShouldSleep)
                    end
                end
            end

            Script.Functions.Speed = function()
                if Settings.Misc.Movement.Speed.Enabled then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + LocalPlayer.Character.Humanoid.MoveDirection * Settings.Misc.Movement.Speed.Amount
                end
            end

            Script.Functions.VelocityDesync = function()
                if Settings.AntiAim.VelocityDesync.Enabled then
                    local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                    local Velocity = HumanoidRootPart.Velocity
                    local Amount = Settings.AntiAim.VelocityDesync.Range * 1000
                    HumanoidRootPart.Velocity = Vector3.new(math.random(-Amount, Amount), math.random(-Amount, Amount), math.random(-Amount, Amount))
                    RunService.RenderStepped:Wait()
                    HumanoidRootPart.Velocity = Velocity
                end
            end

            Script.Functions.FFlagDesync = function()
                if Settings.AntiAim.FFlagDesync.Enabled then
                    for FFlag, _ in pairs(Settings.AntiAim.FFlagDesync.FFlags) do
                        local Value = Settings.AntiAim.FFlagDesync.Amount
                        setfflag(FFlag, tostring(Value))

                        RunService.RenderStepped:Wait()
                        if Settings.AntiAim.FFlagDesync.SetNew then
                            setfflag(FFlag, Settings.AntiAim.FFlagDesync.SetNewAmount)
                        end
                    end
                end
            end


            --// Invisible Desync

            Script.Functions.NoSlowdown = function()
                if Settings.Misc.Exploits.NoSlowDown then
                    for _, Slowdown in pairs(LocalPlayer.Character.BodyEffects.Movement:GetChildren()) do
                        Slowdown:Destroy()
                    end
                end
            end

            --// Horrid code
            Script.Functions.UpdateCrosshair = function()
                if Settings.Visuals.Crosshair.Enabled then
                    local MouseX, MouseY
                    local RotationAngle = Script.Locals.RotationAngle
                    local RealSize = Settings.Visuals.Crosshair.Size * 2

                    if not MouseX or not MouseY then
                        MouseX, MouseY = UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y
                    end

                    local Gap = Settings.Visuals.Crosshair.Gap
                    if Settings.Visuals.Crosshair.Rotation.Enabled then
                        Script.Locals.RotationAngle = Script.Locals.RotationAngle + Settings.Visuals.Crosshair.Rotation.Speed
                    else
                        Script.Locals.RotationAngle = 0
                    end

                    Script.Utility.Drawings["CrosshairLeft"].Visible = true
                    Script.Utility.Drawings["CrosshairLeft"].Color = Settings.Visuals.Crosshair.Color
                    Script.Utility.Drawings["CrosshairLeft"].Thickness = 1
                    Script.Utility.Drawings["CrosshairLeft"].Transparency = 1
                    Script.Utility.Drawings["CrosshairLeft"].From = Vector2.new(MouseX + Gap, MouseY)
                    Script.Utility.Drawings["CrosshairLeft"].To = Vector2.new(MouseX + RealSize, MouseY)
                    if Settings.Visuals.Crosshair.Rotation.Enabled then
                        Script.Utility.Drawings["CrosshairLeft"].From = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairLeft"].From, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                        Script.Utility.Drawings["CrosshairLeft"].To = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairLeft"].To, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                    end

                    Script.Utility.Drawings["CrosshairRight"].Visible = true
                    Script.Utility.Drawings["CrosshairRight"].Color = Settings.Visuals.Crosshair.Color
                    Script.Utility.Drawings["CrosshairRight"].Thickness = 1
                    Script.Utility.Drawings["CrosshairRight"].Transparency = 1
                    Script.Utility.Drawings["CrosshairRight"].From = Vector2.new(MouseX - Gap, MouseY)
                    Script.Utility.Drawings["CrosshairRight"].To = Vector2.new(MouseX - RealSize, MouseY)
                    if Settings.Visuals.Crosshair.Rotation.Enabled then
                        Script.Utility.Drawings["CrosshairRight"].From = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairRight"].From, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                        Script.Utility.Drawings["CrosshairRight"].To = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairRight"].To, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                    end

                    Script.Utility.Drawings["CrosshairTop"].Visible = true
                    Script.Utility.Drawings["CrosshairTop"].Color = Settings.Visuals.Crosshair.Color
                    Script.Utility.Drawings["CrosshairTop"].Thickness = 1
                    Script.Utility.Drawings["CrosshairTop"].Transparency = 1
                    Script.Utility.Drawings["CrosshairTop"].From = Vector2.new(MouseX, MouseY + Gap)
                    Script.Utility.Drawings["CrosshairTop"].To = Vector2.new(MouseX, MouseY + RealSize)
                    if Settings.Visuals.Crosshair.Rotation.Enabled then
                        Script.Utility.Drawings["CrosshairTop"].From = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairTop"].From, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                        Script.Utility.Drawings["CrosshairTop"].To = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairTop"].To, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                    end

                    Script.Utility.Drawings["CrosshairBottom"].Visible = true
                    Script.Utility.Drawings["CrosshairBottom"].Color = Settings.Visuals.Crosshair.Color
                    Script.Utility.Drawings["CrosshairBottom"].Thickness = 1
                    Script.Utility.Drawings["CrosshairBottom"].Transparency = 1
                    Script.Utility.Drawings["CrosshairBottom"].From = Vector2.new(MouseX, MouseY - Gap)
                    Script.Utility.Drawings["CrosshairBottom"].To = Vector2.new(MouseX, MouseY - RealSize)
                    if Settings.Visuals.Crosshair.Rotation.Enabled then
                        Script.Utility.Drawings["CrosshairBottom"].From = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairBottom"].From, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                        Script.Utility.Drawings["CrosshairBottom"].To = Script.Functions.Rotate(Script.Utility.Drawings["CrosshairBottom"].To, Vector2.new(MouseX, MouseY), math.rad(RotationAngle))
                    end
                else
                    Script.Utility.Drawings["CrosshairBottom"].Visible = false
                    Script.Utility.Drawings["CrosshairTop"].Visible = false
                    Script.Utility.Drawings["CrosshairRight"].Visible = false
                    Script.Utility.Drawings["CrosshairLeft"].Visible = false
                end
            end

            Script.Functions.UpdateLookAt = function()
                if Settings.Combat.Enabled and Settings.Combat.LookAt and Script.Locals.IsTargetting and Script.Locals.Target then
                    LocalPlayer.Character.Humanoid.AutoRotate = false
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.CFrame.Position, Vector3.new(Script.Locals.Target.Character.HumanoidRootPart.CFrame.X, LocalPlayer.Character.HumanoidRootPart.CFrame.Position.Y, Script.Locals.Target.Character.HumanoidRootPart.CFrame.Z))
                else
                    LocalPlayer.Character.Humanoid.AutoRotate = true
                end
            end

            Script.Functions.UpdateSpectate = function()
                if Settings.Combat.Enabled and Settings.Combat.Spectate and Script.Locals.IsTargetting and Script.Locals.Target then
                    Camera.CameraSubject = Script.Locals.Target.Character.Humanoid
                else
                    Camera.CameraSubject = LocalPlayer.Character.Humanoid
                end
            end
        end

        --// Esp Function
        do

        end
    end

    --// Drawing objects
    do
        Script.Utility.Drawings["FieldOfViewVisualizer"] = Script.Functions.CreateDrawing("Circle", {
            Visible = Settings.Combat.Fov.Visualize.Enabled,
            Color = Settings.Combat.Fov.Visualize.Color,
            Radius = Settings.Combat.Fov.Radius
        })

        Script.Utility.Drawings["TargetTracer"] = Script.Functions.CreateDrawing("Line",{
            Visible = false,
            Color = Settings.Combat.Visuals.Tracer.Color,
            Thickness = Settings.Combat.Visuals.Tracer.Thickness
        })

        Script.Utility.Drawings["TargetDot"] = Script.Functions.CreateDrawing("Circle", {
            Visible = false,
            Color = Settings.Combat.Visuals.Dot.Color,
            Radius = Settings.Combat.Visuals.Dot.Size
        })

        Script.Utility.Drawings["VelocityDot"] = Script.Functions.CreateDrawing("Circle", {
            Visible = false,
            Color = Settings.AntiAim.VelocitySpoofer.Visualize.Color,
            Radius = 6,
            Filled = true
        })

        Script.Utility.Drawings["TargetChams"] = Script.Functions.Create("Highlight", {
            Parent = nil,
            FillColor = Settings.Combat.Visuals.Chams.Fill.Color,
            FillTransparency = Settings.Combat.Visuals.Chams.Fill.Transparency,
            OutlineColor = Settings.Combat.Visuals.Chams.Fill.Color,
            OutlineTransparency = Settings.Combat.Visuals.Chams.Outline.Transparency
        })

        Script.Utility.Drawings["CrosshairTop"] = Script.Functions.CreateDrawing("Line", {
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
            Visible = false,
            ZIndex = 10000
        })

        Script.Utility.Drawings["CrosshairBottom"] = Script.Functions.CreateDrawing("Line", {
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
            Visible = false,
            ZIndex = 10000
        })

        Script.Utility.Drawings["CrosshairLeft"] = Script.Functions.CreateDrawing("Line", {
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
            Visible = false,
            ZIndex = 10000
        })

        Script.Utility.Drawings["CrosshairRight"] = Script.Functions.CreateDrawing("Line", {
            Color = Color3.fromRGB(255, 255, 255),
            Thickness = 1,
            Visible = false,
            ZIndex = 10000
        })


        Script.Utility.Drawings["CFrameVisualize"] = game:GetObjects("rbxassetid://9474737816")[1]; Script.Utility.Drawings["CFrameVisualize"].Head.Face:Destroy(); for _, v in pairs(Script.Utility.Drawings["CFrameVisualize"]:GetChildren()) do v.Transparency = v.Name == "HumanoidRootPart" and 1 or 0.70; v.Material = "Neon"; v.Color = Settings.AntiAim.CSync.Visualize.Color; v.CanCollide = false; v.Anchored = false end
    end

    --// Hit Effects
    do
        --// Nova
        do
            local Part = Instance.new("Part")
            Part.Parent = ReplicatedStorage

            local Attachment = Instance.new("Attachment")
            Attachment.Name = "Attachment"
            Attachment.Parent = Part

            Script.Locals.HitEffect = Attachment

            local ParticleEmitter = Instance.new("ParticleEmitter")
            ParticleEmitter.Name = "ParticleEmitter"
            ParticleEmitter.Acceleration = Vector3.new(0, 0, 1)
            ParticleEmitter.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.495, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
            })
            ParticleEmitter.Lifetime = NumberRange.new(0.5, 0.5)
            ParticleEmitter.LightEmission = 1
            ParticleEmitter.LockedToPart = true
            ParticleEmitter.Rate = 1
            ParticleEmitter.Rotation = NumberRange.new(0, 360)
            ParticleEmitter.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 10),
                NumberSequenceKeypoint.new(1, 1),
            })
            ParticleEmitter.Speed = NumberRange.new(0, 0)
            ParticleEmitter.Texture = "rbxassetid://1084991215"
            ParticleEmitter.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(0.534, 0.25),
                NumberSequenceKeypoint.new(1, 0.5),
                NumberSequenceKeypoint.new(1, 0),
            })
            ParticleEmitter.ZOffset = 1
            ParticleEmitter.Parent = Attachment
            local ParticleEmitter1 = Instance.new("ParticleEmitter")
            ParticleEmitter1.Name = "ParticleEmitter"
            ParticleEmitter1.Acceleration = Vector3.new(0, 1, -0.001)
            ParticleEmitter1.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.495, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
            })
            ParticleEmitter1.Lifetime = NumberRange.new(0.5, 0.5)
            ParticleEmitter1.LightEmission = 1
            ParticleEmitter1.LockedToPart = true
            ParticleEmitter1.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            ParticleEmitter1.Rate = 1
            ParticleEmitter1.Rotation = NumberRange.new(0, 360)
            ParticleEmitter1.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 10),
                NumberSequenceKeypoint.new(1, 1),
            })
            ParticleEmitter1.Speed = NumberRange.new(0, 0)
            ParticleEmitter1.Texture = "rbxassetid://1084991215"
            ParticleEmitter1.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(0.534, 0.25),
                NumberSequenceKeypoint.new(1, 0.5),
                NumberSequenceKeypoint.new(1, 0),
            })
            ParticleEmitter1.ZOffset = 1
        ParticleEmitter1.Parent = Attachment
    end
end

--// Connections
do
    --// Combat Connections
    do
        Script.Functions.Connection(RunService.Heartbeat, function()
            Script.Functions.MouseAim()

            Script.Functions.Resolve()

            Script.Functions.Air()

            Script.Functions.UpdateLookAt()
        end)

        Script.Functions.Connection(RunService.RenderStepped, function()
            Script.Functions.UpdateFieldOfView()

            Script.Functions.UpdateTargetVisuals()

            Script.Functions.AutoSelect()

            Script.Functions.UpdateSpectate()
        end)
    end

    --// Visual Connections
    do
        Script.Functions.Connection(RunService.RenderStepped, function()
            Script.Functions.GunEvents()

            Script.Functions.UpdateHealth()

            Script.Functions.UpdateAtmosphere()

            Script.Functions.UpdateCrosshair()
        end)
    end

    --// Anti Aim Connection
    do
        Script.Functions.Connection(RunService.Heartbeat, function()
            Script.Functions.VelocitySpoof()

            Script.Functions.CSync()

            Script.Functions.Network()

            Script.Functions.VelocityDesync()

            Script.Functions.FFlagDesync()
        end)
    end

    --// Movement Connections
    do
        Script.Functions.Connection(RunService.Heartbeat, function()
            Script.Functions.Speed()

            Script.Functions.NoSlowdown()
        end)
    end
end

--// Hooks
do
    local __namecall
    local __newindex
    local __index

    __index = hookmetamethod(game, "__index", LPH_NO_VIRTUALIZE(function(Self, Index)
        if not checkcaller() and Settings.AntiAim.CSync.Enabled and Script.Locals.SavedCFrame and Index == "CFrame" and Self == LocalPlayer.Character.HumanoidRootPart then
            return Script.Locals.SavedCFrame
        end
        return __index(Self, Index)
    end))

    __namecall = hookmetamethod(game, "__namecall", LPH_NO_VIRTUALIZE(function(Self, ...)
        local Arguments = {...}
        local Method = tostring(getnamecallmethod())

        if not checkcaller() and Method == "FireServer" then
            for _, Argument in pairs(Arguments) do
                if typeof(Argument) == "Vector3" then
                    Script.Locals.AntiAimViewer.MouseRemote = Self
                    Script.Locals.AntiAimViewer.MouseRemoteFound = true
                    Script.Locals.AntiAimViewer.MouseRemoteArgs = Arguments
                    Script.Locals.AntiAimViewer.MouseRemotePositionIndex = _

                    if Settings.Combat.Enabled and Settings.Combat.Silent and not Settings.Combat.AntiAimViewer and Script.Locals.IsTargetting and Script.Locals.Target then
                        Arguments[_] =  Script.Functions.GetPredictedPosition()
                    end

                    return __namecall(Self, unpack(Arguments))
                end
            end
        end
        return __namecall(Self, ...)
    end))

        __newindex = hookmetamethod(game, "__newindex", LPH_NO_VIRTUALIZE(function(Self, Property, Value)
        local CallingScript = getcallingscript()

        --// Atmosphere caching
        if not checkcaller() and Self == Lighting and Script.Locals.World[Property] ~= Value then
            Script.Locals.World[Property] = Value
        end

        --// No Recoil
        if CallingScript.Name == "Framework" and Self == Camera and Property == "CFrame" and Settings.Misc.Exploits.Enabled and Settings.Misc.Exploits.NoRecoil then
            return
        end

        --// No Jump Cooldown
        if CallingScript.Name == "Framework" and Self == LocalPlayer.Character.Humanoid and Property == "JumpPower" and Settings.Misc.Exploits.Enabled and Settings.Misc.Exploits.NoJumpCooldown then
            return
        end

        return __newindex(Self, Property, Value)
    end))
end



Sense.Load()

Sense.sharedSettings.useTeamColor = false
Sense.teamSettings.enemy.weapon = false
Sense.teamSettings.enemy.boxOutline = false
Sense.teamSettings.enemy.healthBarOutline = false   
Sense.teamSettings.enemy.healthTextOutline = false
Sense.teamSettings.enemy.nameOutline = false
Sense.teamSettings.enemy.weaponOutline = false
Sense.teamSettings.enemy.distanceOutline = false
Sense.teamSettings.enemy.tracerOutline = false
Sense.teamSettings.enemy.offScreenArrowOutline = false

getgenv().HitboxSize = 1
getgenv().HitboxTransparency = 0.9
getgenv().HitboxStatus = false
getgenv().HitboxTeamCheck = false

getgenv().HeadHitboxSize = 1
getgenv().HeadHitboxTransparency = 0.9
getgenv().HeadHitboxStatus = false
getgenv().HeadHitboxTeamCheck = false

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UIS = game:GetService("UserInputService")
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local plr = game:GetService("Players").LocalPlayer
local humRoot = plr.Character:WaitForChild("HumanoidRootPart")
local velocity = Instance.new("AngularVelocity")
local Players = game:GetService('Players');
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

function GetCharacter()
   return game.Players.LocalPlayer.Character
end

function Teleport(pos)
   local Char = GetCharacter()
   if Char then
       Char:MoveTo(pos)
   end
end

function HitboxHumanoidRootPartFunction()
    game:GetService('RunService').RenderStepped:connect(function()
        if HitboxStatus == true and HitboxTeamCheck == false then
            for i,v in next, game:GetService('Players'):GetPlayers() do
                if v.Name ~= game:GetService('Players').LocalPlayer.Name and
                v.Character:FindFirstChild("HumanoidRootPart") and
                v.Character:FindFirstChild("Humanoid") and
                v.Character:FindFirstChild("Humanoid").Health > 0 then
                    pcall(function()
                        v.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                        v.Character.HumanoidRootPart.Transparency = HitboxTransparency
                        v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
                        v.Character.HumanoidRootPart.Material = "Neon"
                        v.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
        elseif HitboxStatus == true and HitboxTeamCheck == true then
            for i,v in next, game:GetService('Players'):GetPlayers() do
                if game:GetService('Players').LocalPlayer.Team ~= v.Team then
                    pcall(function()
                        v.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                        v.Character.HumanoidRootPart.Transparency = HitboxTransparency
                        v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
                        v.Character.HumanoidRootPart.Material = "Neon"
                        v.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
        else
            for i,v in next, game:GetService('Players'):GetPlayers() do
                if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                    pcall(function()
                        v.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
                        v.Character.HumanoidRootPart.Transparency = 1
                        v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
                        v.Character.HumanoidRootPart.Material = "Plastic"
                        v.Character.HumanoidRootPart.CanCollide = false
                    end)
                end
            end
        end
    end)
end

function HitboxHeadFunction()
    game:GetService('RunService').RenderStepped:connect(function()
        if HeadHitboxStatus == true and HeadHitboxTeamCheck == false then
            for i,v in next, game:GetService('Players'):GetPlayers() do
                if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                    pcall(function()
                        v.Character.Head.Size = Vector3.new(HeadHitboxSize, HeadHitboxSize, HeadHitboxSize)
                        v.Character.Head.Transparency = HeadHitboxTransparency
                        v.Character.Head.BrickColor = BrickColor.new("Really black")
                        v.Character.Head.Material = "Neon"
                        v.Character.Head.CanCollide = false
                    end)
                end
            end
        elseif HeadHitboxStatus == true and HeadHitboxTeamCheck == true then
            for i,v in next, game:GetService('Players'):GetPlayers() do
                if game:GetService('Players').LocalPlayer.Team ~= v.Team then
                    pcall(function()
                        v.Character.Head.Size = Vector3.new(HeadHitboxSize, HeadHitboxSize, HeadHitboxSize)
                        v.Character.Head.Transparency = HeadHitboxTransparency
                        v.Character.Head.BrickColor = BrickColor.new("Really black")
                        v.Character.Head.Material = "Neon"
                        v.Character.Head.CanCollide = false
                    end)
                end
            end
        else
            for i,v in next, game:GetService('Players'):GetPlayers() do
                if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                    pcall(function()
                        v.Character.Head.Size = Vector3.new(2,2,1)
                        v.Character.Head.Transparency = 1
                        v.Character.Head.BrickColor = BrickColor.new("Medium stone grey")
                        v.Character.Head.Material = "Plastic"
                        v.Character.Head.CanCollide = false
                    end)
                end
            end
        end
    end)
end

local Window = Library:CreateWindow({
    Title = 'quantum.wtf - v1.0.0 | license: '..LicenseType..'',
    Center = true,
    AutoShow = true,
    TabPadding = 10,
    MenuFadeTime = 0.12
})

local Tabs = {}

Tabs = {
    Legit = Window:AddTab(' Legit '),
    Rage = Window:AddTab(' Rage '),
    Players = Window:AddTab(' Players '),
    Visuals = Window:AddTab(' Visuals '),
    Misc = Window:AddTab(' Misc '),
    Settings = Window:AddTab(' Settings '),
}
--  Legit  Rage  Players  Visuals  Misc  Settings 
Library.KeybindFrame.Visible = false

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;

        Library:SetWatermark(('quantum.wtf | %s fps | %s ms'):format(
            math.floor(FPS),
            math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
        ));
    end;
end);

Library.Watermark.Visible = true

local MenuGroup = Tabs.Settings:AddLeftGroupbox('Menu')

MenuGroup:AddButton({
    Text = 'Unload',
    Func = function()
        Sense.Unload()
        UIS.MouseIconEnabled = true
        print('< [quantum.wtf] - Successfully unloaded! > ')
        Library:Unload()
    end,
    DoubleClick = true,
    Tooltip = nil
})


MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    Text = 'Menu Keybind',
    NoUI = true,
    Callback = function(MenuKeybindValue)
        if MenuKeybindValue == true then
            task.spawn(Library.Toggle)
        elseif MenuKeybindValue == false then
            task.spawn(Library.Toggle)
        end
    end,
})
MenuGroup:AddToggle('KeybindListToggle', {
    Text = 'Keybind List',
    Default = false,
    Tooltip = nil,
    Callback = function(KeybindListValue)
        Library.KeybindFrame.Visible = KeybindListValue
    end
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind', 'WatermarkToggle' })
ThemeManager:SetFolder('quantum.wtf')
SaveManager:SetFolder('quantum.wtf')
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

local RageTabbox1 = Tabs.Rage:AddRightTabbox()

local RageTabbox11 = RageTabbox1:AddTab('Torso')
local RageTabbox12 = RageTabbox1:AddTab('Head')

local RageSector1 = Tabs.Rage:AddLeftGroupbox('Anti-Aim')
local RageSector2 = Tabs.Rage:AddLeftGroupbox('Fake-Lag')

--// Anti-Aim
do
    RageSector1:AddToggle("CSyncAntiAimEnabled", {
        Text = "Enabled",
        Default = false,
        Tooltip = nil,
    }):AddKeyPicker("CSyncAntiAimKeyPicker", {
        Default = "nil",
        SyncToggleState = true,
        Mode = "Toggle",
        Text = "Anti-Aim",
        NoUI = false,
    })

    Toggles.CSyncAntiAimEnabled:OnChanged(function()
        Settings.AntiAim.CSync.Enabled = Toggles.CSyncAntiAimEnabled.Value
    end)

    RageSector1:AddToggle("CSyncAntiAimVisualizeEnabled", {
        Text = "Visualize",
        Default = false,
        Tooltip = nil,
    }):AddColorPicker("CSyncAntiAimVisualizeColor", {
        Default = Color3.new(1, 1, 1),
        Title = "CFrame Visualize Color",
        Transparency = nil,
    })

    RageSector1:AddDropdown("CSyncAntiAimType", {
        Values = {"Custom", "Random", "Local Strafe"},
        Default = 1,
        Multi = false,
        Text = "Type",
        Tooltip = nil,
    })

    Toggles.CSyncAntiAimVisualizeEnabled:OnChanged(function()
        Settings.AntiAim.CSync.Visualize.Enabled = Toggles.CSyncAntiAimVisualizeEnabled.Value
    end)

    Options.CSyncAntiAimVisualizeColor:OnChanged(function()
        Settings.AntiAim.CSync.Visualize.Color = Options.CSyncAntiAimVisualizeColor.Value
    end)

    Options.CSyncAntiAimType:OnChanged(function()
        Settings.AntiAim.CSync.Type = Options.CSyncAntiAimType.Value
    end)

    RageSector1:AddSlider("CSyncAntiAimRandomRange", {
        Text = "Random Range",
        Default = 0.1,
        Min = 0,
        Max = 20,
        Rounding = 1,
        Compact = false,
    })

    Options.CSyncAntiAimRandomRange:OnChanged(function()
        Settings.AntiAim.CSync.RandomDistance = Options.CSyncAntiAimRandomRange.Value
    end)

    RageSector1:AddSlider("CSyncAntiAimCustomX", {
        Text = "Custom X",
        Default = 0.1,
        Min = 0,
        Max = 500,
        Rounding = 1,
        Compact = false,
    })

    Options.CSyncAntiAimCustomX:OnChanged(function()
        Settings.AntiAim.CSync.Custom.X = Options.CSyncAntiAimCustomX.Value
    end)

    RageSector1:AddSlider("CSyncAntiAimCustomY", {
        Text = "Custom Y",
        Default = 0.1,
        Min = 0,
        Max = 500,
        Rounding = 1,
        Compact = false,
    })

    Options.CSyncAntiAimCustomY:OnChanged(function()
        Settings.AntiAim.CSync.Custom.Y = Options.CSyncAntiAimCustomY.Value
    end)

    RageSector1:AddSlider("CSyncAntiAimCustomZ", {
        Text = "Custom Z",
        Default = 0.1,
        Min = 0,
        Max = 500,
        Rounding = 1,
        Compact = false,
    })

    Options.CSyncAntiAimCustomZ:OnChanged(function()
        Settings.AntiAim.CSync.Custom.Z = Options.CSyncAntiAimCustomZ.Value
    end)

    RageSector1:AddSlider("CSyncAntiAimTargetStrafeSpeed", {
        Text = "Target Strafe Speed",
        Default = 1,
        Min = 0,
        Max = 100,
        Rounding = 1,
        Compact = false,
    })

    Options.CSyncAntiAimTargetStrafeSpeed:OnChanged(function()
        Settings.AntiAim.CSync.TargetStrafe.Speed = Options.CSyncAntiAimTargetStrafeSpeed.Value
    end)

    RageSector1:AddSlider("CSyncAntiAimTargetStrafeDistance", {
        Text = "Target Strafe Distance",
        Default = 1,
        Min = 0,
        Max = 50,
        Rounding = 1,
        Compact = false,
    })

    Options.CSyncAntiAimTargetStrafeDistance:OnChanged(function()
        Settings.AntiAim.CSync.TargetStrafe.Distance = Options.CSyncAntiAimTargetStrafeDistance.Value
    end)

    RageSector1:AddSlider("CSyncAntiAimTargetStrafeHeight", {
        Text = "Target Strafe Height",
        Default = 1,
        Min = 0,
        Max = 35,
        Rounding = 1,
        Compact = false,
    })

    Options.CSyncAntiAimTargetStrafeHeight:OnChanged(function()
        Settings.AntiAim.CSync.TargetStrafe.Height = Options.CSyncAntiAimTargetStrafeHeight.Value
    end)
end

--// Fake Lag
do
    RageSector2:AddToggle("AntiAimNetworkEnabled", {
        Text = "Enabled",
        Default = false,
        Tooltip = nil,
    }):AddKeyPicker("AntiAimNetworkKeyPicker", {
        Default = "nil",
        SyncToggleState = true,
        Mode = "Toggle",
        Text = "Fake-Lag",
        NoUI = true,
    })

    Toggles.AntiAimNetworkEnabled:OnChanged(function()
        Settings.AntiAim.Network.Enabled = Toggles.AntiAimNetworkEnabled.Value
    end)

    RageSector2:AddToggle("AntiAimNetworkWalkingCheck", {
        Text = "Walking Check",
        Default = false,
        Tooltip = nil,
    })

    Toggles.AntiAimNetworkWalkingCheck:OnChanged(function()
        Settings.AntiAim.Network.WalkingCheck = Toggles.AntiAimNetworkWalkingCheck.Value
    end)

    RageSector2:AddSlider("AntiAimNetworkAmount", {
        Text = "Amount",
        Default = 0.1,
        Min = 0,
        Max = 30,
        Rounding = 3,
        Compact = false,
    })

    Options.AntiAimNetworkAmount:OnChanged(function()
        Settings.AntiAim.Network.Amount = Options.AntiAimNetworkAmount.Value
    end)
end

RageTabbox11:AddLabel('Hitbox Expander - Part: Torso')

RageTabbox11:AddToggle('HitboxStatusToggle', {
    Text = 'Enable',
    Default = false,
    Tooltip = nil,
    Callback = function(HitboxStatusValue)
        getgenv().HitboxStatus = HitboxStatusValue
        HitboxHumanoidRootPartFunction()
    end
})

RageTabbox11:AddSlider('HitboxSizeSlider', {
    Text = 'Hitbox Size',
    Default = 1,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(HitboxSizeValue)
        getgenv().HitboxSize = HitboxSizeValue
    end
})

RageTabbox11:AddSlider('HitboxTransperencySlider', {
    Text = 'Hitbox Transperency',
    Default = 0.9,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(HitboxTransperencyValue)
        getgenv().HitboxTransparency = HitboxTransperencyValue
    end
})

RageTabbox11:AddToggle('HitboxTeamCheckToggle', {
    Text = 'Team Check',
    Default = false,
    Tooltip = nil,
    Callback = function(HitboxTeamCheckValue)
        getgenv().HitboxTeamCheck = HitboxTeamCheckValue
        HitboxHumanoidRootPartFunction()
    end
})

RageTabbox12:AddLabel('Hitbox Expander - Part: Head')

RageTabbox12:AddToggle('HitboxStatusToggle', {
    Text = 'Enable',
    Default = false,
    Tooltip = nil,
    Callback = function(HitboxStatusValue)
        getgenv().HeadHitboxStatus = HitboxStatusValue
        HitboxHeadFunction()
    end
})

RageTabbox12:AddSlider('HitboxSizeSlider', {
    Text = 'Hitbox Size',
    Default = 1,
    Min = 1,
    Max = 50,
    Rounding = 1,
    Compact = false,
    Callback = function(HitboxSizeValue)
        getgenv().HeadHitboxSize = HitboxSizeValue
    end
})

RageTabbox12:AddSlider('HitboxTransperencySlider', {
    Text = 'Hitbox Transperency',
    Default = 0.9,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(HitboxTransperencyValue)
        getgenv().HeadHitboxTransparency = HitboxTransperencyValue
    end
})

RageTabbox12:AddToggle('HitboxTeamCheckToggle', {
    Text = 'Team Check',
    Default = false,
    Tooltip = nil,
    Callback = function(HitboxTeamCheckValue)
        getgenv().HeadHitboxTeamCheck = HitboxTeamCheckValue
        HitboxHeadFunction()
    end
})

local CamlockSettings = {
    Main = {
        --// Main
        Enabled = false,
        StickyAim = false,
        TeamCheck = false,
        WallCheck = false,
        AimPart = "Head",
        --// Other
        Smoothing = 0.3,
        Prediction = false;
	    PredictionAmmount = 1;

        --// FOV
        ShowFOV = false,
        FOVRadius = 60,
        --// FOV Settings
        Thickness = 1,
	    FovFillColor = Color3.fromRGB(255,255,255),
	    FovColor = Color3.fromRGB(255,255,255),
	    FovFillTransparency = 1,
	    FovTransparenct = 0,

        --// Keybind
        UseMouse = false;
    	MouseBind = "MouseButton1";
	    Keybind = Enum.KeyCode.F;

        --// bumbum
        IsAimKeyDown = false;
	    Target = nil;
	    CameraTween = nil;
    },
}

local CamlockSector = Tabs.Legit:AddLeftGroupbox("Camlock")

CamlockSector:AddToggle('CamlockToggle', {
    Text = 'Enable',
    Default = false,
    Tooltip = 'Enables Camera Aimbot',
    Callback = function(CV)
        CamlockSettings.Main.Enabled = CV 
    end
}):AddKeyPicker('CamlockKeyPicker', {
    Default = 'F',
    SyncToggleState = false,
    Mode = 'Hold',
    Text = 'Targetting',
    NoUI = true,
    ChangedCallback = function(CCKV)
        CamlockSettings.Main.Keybind = CCKV
    end
})

CamlockSector:AddToggle('CamlockToggle', {
    Text = 'Sticky Aim',
    Default = false,
    Tooltip = nil,
    Callback = function(CSAV)
        CamlockSettings.Main.StickyAim = CSAV 
    end
})

CamlockSector:AddToggle('CamlockUseMouseToggle', {
    Text = 'Use Mouse',
    Default = false,
    Tooltip = nil,
    Callback = function(CUMV)
        CamlockSettings.Main.UseMouse = CUMV
    end
})

local CamlockSectorDepBox1 = CamlockSector:AddDependencyBox()

CamlockSectorDepBox1:AddDropdown('CamlockMouseBindDropdown', {
    Values = { 'MouseButton1', 'MouseButton2' },
    Default = 1,
    Multi = false,
    Text = 'Mouse Bind',
    Tooltip = nil,
    Callback = function(CMBV)
        if CMBV == 'MouseButton1' then
            CamlockSettings.Main.MouseBind = "MouseButton1"
        elseif CMBV == 'MouseButton2' then
            CamlockSettings.Main.MouseBind = "MouseButton2"
        end
    end
})

CamlockSectorDepBox1:SetupDependencies({
    { Toggles.CamlockUseMouseToggle, true }
})

CamlockSector:AddToggle('CamlockShowFovToggle', {
    Text = 'Show FOV',
    Default = false,
    Tooltip = nil,
    Callback = function(CSFV)
        CamlockSettings.Main.ShowFOV = CSFV 
    end
}):AddColorPicker('CamlockShowFovColorPicker', {
    Default = Color3.new(1, 1, 1),
    Title = 'Field Of View',
    Transparency = 0,

    Callback = function(CSFCV)
        CamlockSettings.Main.FovColor = Color3.new(CSFCV)
    end
})

CamlockSector:AddSlider('CamlockFovRadiusSlider', {
    Text = 'FOV Radius',
    Default = 60,
    Min = 1,
    Max = 480,
    Rounding = 1,
    Compact = false,
    Callback = function(CFRV)
        CamlockSettings.Main.FOVRadius = CFRV
    end
})

CamlockSector:AddToggle('CamlockTeamCheckToggle', {
    Text = 'Team Check',
    Default = false,
    Tooltip = nil,
    Callback = function(CTCV)
        CamlockSettings.Main.TeamCheck = CTCV 
    end
})

CamlockSector:AddToggle('CamlockWallCheckToggle', {
    Text = 'Wall Check',
    Default = false,
    Tooltip = nil,
    Callback = function(CWCV)
        CamlockSettings.Main.WallCheck = CWCV 
    end
})

CamlockSector:AddDropdown('CamlockAimPartDropdown', {
    Values = { 'Head', 'HumanoidRootPart' },
    Default = 1,
    Multi = false,
    Text = 'Aim Part',
    Tooltip = nil,
    Callback = function(CAV)
        if CAV == 'Head' then
            CamlockSettings.Main.AimPart = "Head"
        elseif CAV == 'HumanoidRootPart' then
            CamlockSettings.Main.AimPart = "HumanoidRootPart"
        end
    end
})

CamlockSector:AddToggle('CamlockPredictionToggle', {
    Text = 'Prediction',
    Default = false,
    Tooltip = nil,
    Callback = function(CPV)
        CamlockSettings.Main.Prediction = CPV
    end
})

local CamlockSectorDepBox2 = CamlockSector:AddDependencyBox()

CamlockSectorDepBox2:AddSlider('CamlockPredictionAmmountSlider', {
    Text = 'Prediction Ammount',
    Default = 1,
    Min = 1,
    Max = 1000,
    Rounding = 1,
    Compact = false,
    Callback = function(CPAV)
        CamlockSettings.Main.PredictionAmmount = CPAV / 100;
    end
})

CamlockSectorDepBox2:SetupDependencies({
    { Toggles.CamlockPredictionToggle, true }
})

CamlockSector:AddSlider('CamlockSmoothingSlider', {
    Text = 'Smoothing',
    Default = 3.5,
    Min = 1.5,
    Max = 250,
    Rounding = 1,
    Compact = false,
    Callback = function(CSV)
        CamlockSettings.Main.Smoothing = CSV / 100
    end
})

local Fov = Instance.new("ScreenGui",(CoreGui or localPlayer.PlayerGui))Fov.Name = "Fov" Fov.ZIndexBehavior = Enum.ZIndexBehavior.Sibling Fov.ResetOnSpawn = false; -- Yapee
local FOVFFrame = Instance.new("Frame")FOVFFrame.Parent = Fov FOVFFrame.Name = "FOVFFrame" FOVFFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255) FOVFFrame.BorderColor3 = Color3.fromRGB(0, 0, 0) FOVFFrame.BorderSizePixel = 0 FOVFFrame.BackgroundTransparency = 1 FOVFFrame.AnchorPoint = Vector2.new(0.5, 0.5) FOVFFrame.Position = UDim2.new(0.5, 0,0.5, 0) FOVFFrame.Size = UDim2.new(0, CamlockSettings.Main.FOVRadius, 0, CamlockSettings.Main.FOVRadius) FOVFFrame.BackgroundTransparency = 1;
local UICorner = Instance.new("UICorner")UICorner.CornerRadius = UDim.new(1, 0) UICorner.Parent = FOVFFrame;
local UIStroke = Instance.new("UIStroke")UIStroke.Color = Color3.fromRGB(100,0,100) UIStroke.Parent = FOVFFrame UIStroke.Thickness = 1 UIStroke.ApplyStrokeMode = "Border"; game:GetService("StarterGui"):SetCore("SendNotification", {Title = "https://discord.gg/FsApQ7YNTq", Text = "The Discord For More!"});

local function IsAlive(Player)
	if Player and Player.Character and Player.Character:FindFirstChild("Humanoid") ~= nil and (IsArsenal and players[Player.Character.Name].NRPBS["Health"].Value > 0 or not IsArsenal and Player.Character.Humanoid.Health > 0) then
		return true
	end
	return false
end

local function GetTeam(Player)
	if not game.Players.LocalPlayer.Neutral then
		return game.Teams[Player.Team.Name];
	end
	return true;
end

function isVisible(p, ...)

	if not (CamlockSettings.Main.WallCheck == true) then
		return true;
	end

	return #CurrentCamera:GetPartsObscuringTarget({ p }, { CurrentCamera, localPlayer.Character, ... }) == 0;
end

function CameraGetClosestToMouse()
	local AimFov = CamlockSettings.Main.FOVRadius;
	local targetPos = nil;

	for i,v in pairs (game:GetService("Players"):GetPlayers()) do
		if v ~= localPlayer then
			if CamlockSettings.Main.TeamCheck ~= true or GetTeam(v) ~= GetTeam(localPlayer) then 
				if IsAlive(v) then
					local screen_pos, on_screen = CurrentCamera:WorldToViewportPoint(v.Character[CamlockSettings.Main.AimPart].Position)
					local screen_pos_2D = Vector2.new(screen_pos.X, screen_pos.Y)
					local new_magnitude = (screen_pos_2D - mouseLocation(UIS)).Magnitude
					if on_screen and new_magnitude < AimFov and isVisible(v.Character[CamlockSettings.Main.AimPart].Position, v.Character.Head.Parent) then
						AimFov = new_magnitude;
						targetPos = v;
					end
				end
			end
		end
	end
	return targetPos;
end

UIS.InputBegan:Connect(function(Key)
	if Key.KeyCode == CamlockSettings.Main.Keybind and not CamlockSettings.Main.UseMouse then
		CamlockSettings.Main.Target = CameraGetClosestToMouse();
		CamlockSettings.Main.IsAimKeyDown = true;
	end
end)
UIS.InputEnded:Connect(function(Key)
	if Key.KeyCode == CamlockSettings.Main.Keybind and not CamlockSettings.Main.UseMouse then
		CamlockSettings.Main.Target = CameraGetClosestToMouse();
		CamlockSettings.Main.IsAimKeyDown = false;
		if CamlockSettings.Main.CameraTween ~= nil then
			CamlockSettings.Main.CameraTween:Cancel();
		end
	end
end)

localPlayer:GetMouse().Button1Down:Connect(function(Key)
	if CamlockSettings.Main.MouseBind == "MouseButton1" and CamlockSettings.Main.UseMouse then
		if CamlockSettings.Main.IsAimKeyDown then
			CamlockSettings.Main.Target = CameraGetClosestToMouse();
			CamlockSettings.Main.IsAimKeyDown = false;
			if CamlockSettings.Main.CameraTween ~= nil then
				CamlockSettings.Main.CameraTween:Cancel();
			end
		else
			CamlockSettings.Main.Target = CameraGetClosestToMouse();
			CamlockSettings.Main.IsAimKeyDown = true;
		end
	end
end)
localPlayer:GetMouse().Button1Up:Connect(function(Key)
	if CamlockSettings.Main.MouseBind == "MouseButton1" and CamlockSettings.Main.UseMouse then
		CamlockSettings.Main.Target = CameraGetClosestToMouse();
		CamlockSettings.Main.IsAimKeyDown = false;
		if CamlockSettings.Main.CameraTween ~= nil then
			CamlockSettings.Main.CameraTween:Cancel();
		end
	end
end)

localPlayer:GetMouse().Button2Down:Connect(function(Key)
	if CamlockSettings.Main.MouseBind == "MouseButton2" and CamlockSettings.Main.UseMouse then
		CamlockSettings.Main.Target = CameraGetClosestToMouse();
		CamlockSettings.Main.IsAimKeyDown = true;
	end
end)
localPlayer:GetMouse().Button2Up:Connect(function(Key)
	if CamlockSettings.Main.MouseBind == "MouseButton2" and CamlockSettings.Main.UseMouse then
		CamlockSettings.Main.Target = CameraGetClosestToMouse();
		CamlockSettings.Main.IsAimKeyDown = false;
		if CamlockSettings.Main.CameraTween ~= nil then
			CamlockSettings.Main.CameraTween:Cancel();
		end
	end
end)

game:GetService("RunService").Heartbeat:Connect(function() 

	if CamlockSettings.Main.Enabled and CamlockSettings.Main.ShowFov then
		UIStroke.Enabled = true;
		UIStroke.Color = CamlockSettings.Main.FovColor;
		local posd = UIS:GetMouseLocation();
		FOVFFrame.Position = UDim2.new(0, posd.X, 0, posd.Y - 36);
		FOVFFrame.Size = UDim2.fromOffset(CamlockSettings.Main.FOVRadius * 1.5, CamlockSettings.Main.FOVRadius * 1.5);
	else
		UIStroke.Enabled = false;
	end

	if CamlockSettings.Main.Enabled then
		if CamlockSettings.Main.IsAimKeyDown then
			if CamlockSettings.Main.StickyAim then
				if CamlockSettings.Main.Target ~= nil then

					if not IsAlive(CamlockSettings.Main.Target) then -- Yes I Know This Aim Bot Sucks
						local target = CameraGetClosestToMouse()
						CamlockSettings.Main.Target = target;
						CamlockSettings.Main.CameraTween = TweenService:Create(CurrentCamera, TweenInfo.new(CamlockSettings.Main.Smoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(CurrentCamera.CFrame.Position, target.Character[CamlockSettings.Main.AimPart].Position + (CamlockSettings.Main.Prediction and CamlockSettings.Main.target.Character[CamlockSettings.Main.AimPart].Velocity * (localPlayer:GetNetworkPing() * CamlockSettings.Main.PredictionAmmount) or Vector3.new()))});
						CamlockSettings.Main.CameraTween:Play();
					end
					CamlockSettings.Main.CameraTween = TweenService:Create(CurrentCamera, TweenInfo.new(CamlockSettings.Main.Smoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(CurrentCamera.CFrame.Position, CamlockSettings.Main.Target.Character[CamlockSettings.Main.AimPart].Position + (CamlockSettings.Main.Prediction and CamlockSettings.Main.Target.Character[CamlockSettings.Main.AimPart].Velocity * (localPlayer:GetNetworkPing() * CamlockSettings.Main.PredictionAmmount) or Vector3.new()))});
					CamlockSettings.Main.CameraTween:Play();
				end
			else
				local target = CameraGetClosestToMouse();
				if target ~= nil then
					CamlockSettings.Main.CameraTween = TweenService:Create(CurrentCamera, TweenInfo.new(CamlockSettings.Main.Smoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(CurrentCamera.CFrame.Position,  target.Character[CamlockSettings.Main.AimPart].Position + (CamlockSettings.Main.Prediction and target.Character[CamlockSettings.Main.AimPart].Velocity * (localPlayer:GetNetworkPing() * CamlockSettings.Main.PredictionAmmount) or Vector3.new()))});
					CamlockSettings.Main.CameraTween:Play();

				elseif CamlockSettings.Main.CameraTween ~= nil then
					CamlockSettings.Main.CameraTween:Cancel(); 
				end
			end
		end
	end
end)

local SilentAimSector = Tabs.Legit:AddRightGroupbox("Silent Aim")

SilentAimSector:AddToggle("aim_Enabled", {Text = "Enabled"}):AddKeyPicker("aim_Enabled_KeyPicker", {Default = "RightAlt", SyncToggleState = true, Mode = "Toggle", Text = "Enabled", NoUI = false});
Options.aim_Enabled_KeyPicker:OnClick(function()
    SilentAimSettings.Enabled = not SilentAimSettings.Enabled
 
    Toggles.aim_Enabled.Value = SilentAimSettings.Enabled
    Toggles.aim_Enabled:SetValue(SilentAimSettings.Enabled)
 
    mouse_box.Visible = SilentAimSettings.Enabled
end)

SilentAimSector:AddToggle("TeamCheck", {Text = "Team Check", Default = SilentAimSettings.TeamCheck}):OnChanged(function()
    SilentAimSettings.TeamCheck = Toggles.TeamCheck.Value
end)
SilentAimSector:AddToggle("VisibleCheck", {Text = "Visible Check", Default = SilentAimSettings.VisibleCheck}):OnChanged(function()
    SilentAimSettings.VisibleCheck = Toggles.VisibleCheck.Value
end)
SilentAimSector:AddDropdown("TargetPart", {AllowNull = true, Text = "Target Part", Default = SilentAimSettings.TargetPart, Values = {"Head", "HumanoidRootPart", "Random"}}):OnChanged(function()
    SilentAimSettings.TargetPart = Options.TargetPart.Value
end)

SilentAimSector:AddSlider('HitChance', {
    Text = 'Hitchance',
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 1,

    Compact = false,
})
Options.HitChance:OnChanged(function()
    SilentAimSettings.HitChance = Options.HitChance.Value
end)

SilentAimSector:AddDivider()

SilentAimSector:AddToggle("Visible", {Text = "Show FOV Circle"}):AddColorPicker("SilentAimFovColor", {Default = Color3.fromRGB(54, 57, 241)}):OnChanged(function()
    fov_circle.Visible = Toggles.Visible.Value
    SilentAimSettings.FOVVisible = Toggles.Visible.Value
end)
SilentAimSector:AddSlider("Radius", {Text = "FOV Circle Radius", Min = 0, Max = 2000, Default = 130, Rounding = 0}):OnChanged(function()
    fov_circle.Radius = Options.Radius.Value
    SilentAimSettings.FOVRadius = Options.Radius.Value
end)
SilentAimSector:AddToggle("MousePosition", {Text = "Show Silent Aim Target"}):AddColorPicker("MouseVisualizeColor", {Default = Color3.fromRGB(54, 57, 241)}):OnChanged(function()
    mouse_box.Visible = Toggles.MousePosition.Value
    SilentAimSettings.ShowSilentAimTarget = Toggles.MousePosition.Value 
end)

local PlayersSector1 = Tabs.Players:AddLeftGroupbox('ESP')

PlayersSector1:AddToggle('BoxESPToggle', {
    Text = 'Enable ESP',
    Default = false,
    Tooltip = 'enable esp',
    Callback = function(BoxESPValue)
        if BoxESPValue == true then
            Sense.teamSettings.enemy.enabled = true
        elseif BoxESPValue == false then
            Sense.teamSettings.enemy.enabled = false
        end
    end
})

PlayersSector1:AddToggle('3DBoxESPToggle', {
    Text = '3D Box',
    Default = false,
    Tooltip = 'Enables 3D Box',
    Callback = function(Box3DESPValue)
        if Box3DESPValue == true then
            Sense.teamSettings.enemy.box3d = true
            Sense.Load()
        elseif Box3DESPValue == false then
            Sense.teamSettings.enemy.box3d = false
            Sense.Load()
        end
    end
})

PlayersSector1:AddToggle('2DBoxESPToggle', {
    Text = '2D Box',
    Default = false,
    Tooltip = 'Enable 2D Box',
    Callback = function(BoxESPValue)
        if BoxESPValue == true then
            Sense.teamSettings.enemy.box = true
            Sense.Load()
        elseif BoxESPValue == false then
            Sense.teamSettings.enemy.box = false
            Sense.Load()
        end
    end
})

PlayersSector1:AddToggle('TracersESPToggle', {
    Text = 'Show Tracers',
    Default = false,
    Tooltip = 'Enable tracers to players',
    Callback = function(TracerESPValue)
        if TracerESPValue == true then
            Sense.teamSettings.enemy.tracer = true
            Sense.Load()
        elseif TracerESPValue == false then
            Sense.teamSettings.enemy.tracer = false
            Sense.Load()
        end
    end
})

PlayersSector1:AddDropdown('TracerESPDropdown', {
    Values = { 'Bottom', 'Top', 'Middle' },
    Default = 1,
    Multi = false,

    Text = 'Tracers Type',
    Tooltip = nil,

    Callback = function(TracerESPTypeValue)
        if TracerESPTypeValue == 'Bottom' then
            Sense.teamSettings.enemy.tracerOrigin = "Bottom"
        elseif TracerESPTypeValue == 'Top' then
            Sense.teamSettings.enemy.tracerOrigin = "Top"
        elseif TracerESPTypeValue == 'Middle' then
            Sense.teamSettings.enemy.tracerOrigin = "Middle"
        end
    end
})

PlayersSector1:AddToggle('OffScreenArrowsESPToggle', {
    Text = 'OffScreen Arrows',
    Default = false,
    Tooltip = 'Enable OffScreen Arrows',
    Callback = function(OffScreenArrowESPValue)
        if OffScreenArrowESPValue == true then
            Sense.teamSettings.enemy.offScreenArrow = true
            Sense.Load()
        elseif OffScreenArrowESPValue == false then
            Sense.teamSettings.enemy.offScreenArrow = false
            Sense.Load()
        end
    end
})

PlayersSector1:AddToggle('NamesESPToggle', {
    Text = 'Names',
    Default = false,
    Tooltip = 'Enables Name ESP',
    Callback = function(NameESPValue)
        if NameESPValue == true then
            Sense.teamSettings.enemy.name = true
            Sense.Load()
        elseif NameESPValue == false then
            Sense.teamSettings.enemy.name = false
            Sense.Load()
        end
    end
})

PlayersSector1:AddToggle('ToolsESPToggle', {
    Text = 'Tools',
    Default = false,
    Tooltip = 'Enables Tool ESP',
    Callback = function(ToolESPValue)
        if ToolESPValue == true then
            Sense.teamSettings.enemy.weapon = true
            Sense.Load()
        elseif ToolESPValue == false then
            Sense.teamSettings.enemy.weapon = false
            Sense.Load()
        end
    end
})

PlayersSector1:AddToggle('DistanceESPToggle', {
    Text = 'Distance',
    Default = false,
    Tooltip = 'Shows distance',
    Callback = function(DistanceESPValue)
        if DistanceESPValue == true then
            Sense.teamSettings.enemy.distance = true
            Sense.Load()
        elseif DistanceESPValue == false then
            Sense.teamSettings.enemy.distance = false
            Sense.Load()
        end
    end
})

PlayersSector1:AddToggle('HealthBarESPToggle', {
    Text = 'Health Bar',
    Default = false,
    Tooltip = 'Enables HealthBar',
    Callback = function(HealthBarESPValue)
        if HealthBarESPValue == true then
            Sense.teamSettings.enemy.healthBar = true
            Sense.Load()
        elseif HealthBarESPValue == false then
            Sense.teamSettings.enemy.healthBar = false
            Sense.Load()
        end
    end
})

PlayersSector1:AddToggle('HealthTextESPToggle', {
    Text = 'Health Text',
    Default = false,
    Tooltip = 'Enables Health Text',
    Callback = function(HealthTextESPValue)
        if HealthTextESPValue == true then
            Sense.teamSettings.enemy.healthText = true
            Sense.Load()
        elseif HealthTextESPValue == false then
            Sense.teamSettings.enemy.healthText = false
            Sense.Load()
        end
    end
})

PlayersSector1:AddDivider()

PlayersSector1:AddToggle('ChamsESPToggle', {
    Text = 'Chams',
    Default = false,
    Tooltip = 'Enable Chams',
    Callback = function(ChamsESPValue)
        if ChamsESPValue == true then
            Sense.teamSettings.enemy.chams = true
            Sense.Load()
        elseif ChamsESPValue == false then
            Sense.teamSettings.enemy.chams = false
            Sense.Load()
        end
    end
})

PlayersSector1:AddToggle('ChamsVisibleOnlyESPToggle', {
    Text = 'Visible Only',
    Default = false,
    Tooltip = 'Enable Visible Only Chams',
    Callback = function(ChamsVisibleOnlyESPValue)
        if ChamsVisibleOnlyESPValue == true then
            Sense.teamSettings.enemy.chamsVisibleOnly = true
            Sense.Load()
        elseif ChamsVisibleOnlyESPValue == false then
            Sense.teamSettings.enemy.chamsVisibleOnly = false
            Sense.Load()
        end
    end
})

PlayersSector1:AddDivider()

PlayersSector1:AddToggle('UseTeamColorsESPToggle', {
    Text = 'Use TeamColors',
    Default = false,
    Tooltip = 'Changes colors to TeamColors',
    Callback = function(UseTeamColorESPValue)
        if UseTeamColorESPValue == true then
            Sense.sharedSettings.useTeamColor = true
            Sense.Load()
        elseif UseTeamColorESPValue == false then
            Sense.sharedSettings.useTeamColor = false
            Sense.Load()
        end
    end
})

local PlayersSector2 = Tabs.Players:AddLeftGroupbox('ESP - Outline')

PlayersSector2:AddToggle('BoxOutlineESPToggle', {
    Text = '2D Box - Outline',
    Default = false,
    Tooltip = 'Enables outline on 2D Box',
    Callback = function(BoxOutlineESPValue)
        if BoxOutlineESPValue == true then
            Sense.teamSettings.enemy.boxOutline = true
            Sense.Load()
        elseif BoxOutlineESPValue == false then
            Sense.teamSettings.enemy.boxOutline = false
            Sense.Load()
        end
    end
})

PlayersSector2:AddToggle('TracersOutlineESPToggle', {
    Text = 'Tracers - Outline',
    Default = false,
    Tooltip = 'Enable outline on Tracers',
    Callback = function(TracerOutlineESPValue)
        if TracerOutlineESPValue == true then
            Sense.teamSettings.enemy.tracerOutline = true
            Sense.Load()
        elseif TracerOutlineESPValue == false then
            Sense.teamSettings.enemy.tracerOutline = false
            Sense.Load()
        end
    end
})

PlayersSector2:AddToggle('NamesOutlineESPToggle', {
    Text = 'Names - Outline',
    Default = false,
    Tooltip = 'Enable outline on Names',
    Callback = function(NameOutlineESPValue)
        if NameOutlineESPValue == true then
            Sense.teamSettings.enemy.nameOutline = true
            Sense.Load()
        elseif NameOutlineESPValue == false then
            Sense.teamSettings.enemy.nameOutline = false
            Sense.Load()
        end
    end
})

PlayersSector2:AddToggle('DistanceESPToggle', {
    Text = 'Distance - Outline',
    Default = false,
    Tooltip = 'Enable outline on Distance',
    Callback = function(DistanceOutlineESPValue)
        if DistanceOutlineESPValue == true then
            Sense.teamSettings.enemy.distanceOutline = true
            Sense.Load()
        elseif DistanceOutlineESPValue == false then
            Sense.teamSettings.enemy.distanceOutline = false
            Sense.Load()
        end
    end
})

PlayersSector2:AddToggle('HealthBarOutlineESPToggle', {
    Text = 'Health Bar - Outline',
    Default = false,
    Tooltip = 'Enables outline on HealthBar',
    Callback = function(HealthBarOutlineESPValue)
        if HealthBarOutlineESPValue == true then
            Sense.teamSettings.enemy.healthBarOutline = true
            Sense.Load()
        elseif HealthBarOutlineESPValue == false then
            Sense.teamSettings.enemy.healthBarOutline = false
            Sense.Load()
        end
    end
})

PlayersSector2:AddToggle('HealthTextOutlineESPToggle', {
    Text = 'Health Text - Outline',
    Default = false,
    Tooltip = 'Enables Outline on Health Text',
    Callback = function(HealthTextOutlineESPValue)
        if HealthTextOutlineESPValue == true then
            Sense.teamSettings.enemy.healthTextOutline = true
            Sense.Load()
        elseif HealthTextOutlineESPValue == false then
            Sense.teamSettings.enemy.healthTextOutline = false
            Sense.Load()
        end
    end
})

local MiscSector1 = Tabs.Misc:AddLeftGroupbox('CFrame Speed')

MiscSector1:AddToggle("MiscCFrameSpeedEnabled", {
    Text = "Enabled",
    Default = false,
    Tooltip = nil,
}):AddKeyPicker("MiscCFrameSpeedKeybind", {
    Default = "nil",
    SyncToggleState = true,
    Mode = "Toggle",
    Text = "Speed",
    NoUI = false,
})

Toggles.MiscCFrameSpeedEnabled:OnChanged(function()
    Settings.Misc.Movement.Speed.Enabled = Toggles.MiscCFrameSpeedEnabled.Value
end)

MiscSector1:AddSlider("MiscCFrameSpeedAmount", {
    Text = "Amount",
    Default = 0.1,
    Min = 0,
    Max = 10,
    Rounding = 3,
    Compact = false,
})

Options.MiscCFrameSpeedAmount:OnChanged(function()
    Settings.Misc.Movement.Speed.Amount = Options.MiscCFrameSpeedAmount.Value
end)

local MiscSector2 = Tabs.Misc:AddLeftGroupbox('Character')

MiscSector2:AddToggle('NoclipR15Toggle', {
    Text = 'Noclip - R15',
    Default = false,
    Tooltip = 'R15 RIG TYPE ONLY',
    Callback = function(NoclipR15Value)
        if NoclipR15Value == true then
            game:GetService("RunService").Stepped:wait()
            game.Players.LocalPlayer.Character.UpperTorso.CanCollide = false
            game.Players.LocalPlayer.Character.LowerTorso.CanCollide = false
            game.Players.LocalPlayer.Character.HumanoidRootPart.CanCollide = false
            game.Players.LocalPlayer.Character.Head.CanCollide = false
        elseif NoclipR15Value == false then
            game.Players.LocalPlayer.Character.UpperTorso.CanCollide = true
            game.Players.LocalPlayer.Character.LowerTorso.CanCollide = true
            game.Players.LocalPlayer.Character.HumanoidRootPart.CanCollide = true
        end
    end
})

MiscSector2:AddToggle('NoclipR6Toggle', {
    Text = 'Noclip - R6',
    Default = false,
    Tooltip = 'R6 RIG TYPE ONLY',
    Callback = function(NoclipR6Value)
        if NoclipR6Value == true then
            game:GetService("RunService").Stepped:wait()
            game.Players.LocalPlayer.Character.Torso.CanCollide = false
            game.Players.LocalPlayer.Character.HumanoidRootPart.CanCollide = false
            game.Players.LocalPlayer.Character.Head.CanCollide = false
        elseif NoclipR6Value == false then
            game.Players.LocalPlayer.Character.Torso.CanCollide = true
            game.Players.LocalPlayer.Character.HumanoidRootPart.CanCollide = true
        end
    end
})

local VirusGameSector1 = Tabs.Misc:AddRightGroupbox('Virus Game')

local JumpCooldownScript = game.Players.LocalPlayer.PlayerGui:FindFirstChild("JumpCooldown")

VirusGameSector1:AddToggle('RemoveJumpCooldownToggle', {
    Text = 'Remove Jump Cooldown',
    Default = false,
    Tooltip = nil,
    Callback = function(JumpCDValue)
        if JumpCDValue == true then
            repeat game.Players.LocalPlayer.PlayerGui.JumpCooldown.Disabled = false until JumpCDValue == false
        elseif JumpCDValue == false then
            repeat game.Players.LocalPlayer.PlayerGui.JumpCooldown.Disabled = false until JumpCDValue == true
        end
    end
}) 

MiscSector2:AddSlider('WalkSpeedSlider', {
    Text = 'WalkSpeed',
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 1,
    Compact = false,
    Callback = function(WalkSpeedValue)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (WalkSpeedValue)
    end
})

MiscSector2:AddSlider('JumpPowerSlider', {
    Text = 'JumpPower',
    Default = 50,
    Min = 50,
    Max = 400,
    Rounding = 1,
    Compact = false,
    Callback = function(JumpPowerValue)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = (JumpPowerValue)
    end
})

MiscSector2:AddSlider('FieldOfViewSlider', {
    Text = 'Field Of View',
    Default = 70,
    Min = 40,
    Max = 120,
    Rounding = 1,
    Compact = false,
    Callback = function(FieldOfViewValue)
        game.Workspace.CurrentCamera.FieldOfView = FieldOfViewValue
    end
})

MiscSector2:AddToggle('CtrlClickToTPToogle', {
    Text = 'Ctrl + click to TP',
    Default = false,
    Tooltip = nil,
    Callback = function(CtrlClickToTPValue)
        UIS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                if CtrlClickToTPValue then
                    Teleport(Mouse.Hit.p)
                end
            end
        end)
    end
}) 

local MiscSector3 = Tabs.Misc:AddRightGroupbox('Scripts')

MiscSector3:AddLabel('WARNING: Anti-Aim, Fake-Lag and CFrame Speed ​​will stop working if you execute any of these scripts.')

MiscSector3:AddButton({
    Text = 'Infinite Yield',
    Func = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
    DoubleClick = false,
    Tooltip = 'Loads Infinite Yield'
})

MiscSector3:AddButton({
    Text = 'Dark Dex v3 - Secure Edition',
    Func = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
    end,
    DoubleClick = false,
    Tooltip = 'Loads Dark Dex V3'
})

resume(create(function()
    RenderStepped:Connect(function()
        if Toggles.MousePosition.Value and Toggles.aim_Enabled.Value then
            if getClosestPlayer() then 
                local Root = getClosestPlayer().Parent.PrimaryPart or getClosestPlayer()
                local RootToViewportPoint, IsOnScreen = WorldToViewportPoint(Camera, Root.Position);
                -- using PrimaryPart instead because if your Target Part is "Random" it will flicker the square between the Target's Head and HumanoidRootPart (its annoying)
 
                mouse_box.Visible = IsOnScreen
                mouse_box.Color = Options.MouseVisualizeColor.Value
                mouse_box.Position = Vector2.new(RootToViewportPoint.X, RootToViewportPoint.Y)
            else 
                mouse_box.Visible = false 
                mouse_box.Position = Vector2.new()
            end
        end
 
        if Toggles.Visible.Value then 
            fov_circle.Visible = Toggles.Visible.Value
            fov_circle.Color = Options.SilentAimFovColor.Value
            fov_circle.Position = getMousePosition()
        end
    end)
end))

-- hooks
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    local self = Arguments[1]
    local chance = CalculateChance(SilentAimSettings.HitChance)
    if Toggles.aim_Enabled.Value and self == workspace and not checkcaller() and chance == true then
        if Method == "Raycast" then
            if ValidateArguments(Arguments, ExpectedArguments.Raycast) then
                local A_Origin = Arguments[2]
 
                local HitPart = getClosestPlayer()
                if HitPart then
                    Arguments[3] = getDirection(A_Origin, HitPart.Position)
 
                    return oldNamecall(unpack(Arguments))
                end
            end
        end
    end
    return oldNamecall(...)
end))
 
local oldIndex = nil 
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, Index)
    if self == Mouse and not checkcaller() and Toggles.aim_Enabled.Value and Options.Method.Value == "Mouse.Hit/Target" and getClosestPlayer() then
        local HitPart = getClosestPlayer()
 
        if Index == "Target" or Index == "target" then 
            return HitPart
        elseif Index == "Hit" or Index == "hit" then 
            return ((Toggles.Prediction.Value and (HitPart.CFrame + (HitPart.Velocity * PredictionAmount))) or (not Toggles.Prediction.Value and HitPart.CFrame))
        elseif Index == "X" or Index == "x" then 
            return self.X 
        elseif Index == "Y" or Index == "y" then 
            return self.Y 
        elseif Index == "UnitRay" then 
            return Ray.new(self.Origin, (self.Hit - self.Origin).Unit)
        end
    end
 
    return oldIndex(self, Index)
end))

Library:Notify(' [quantum.wtf] - Successfully loaded!')

print(' Logged In!')
print(' User Data')
print(' Username:' .. data.info.username)
print(' IP Address:' .. data.info.ip)
print(' Created at:' .. data.info.createdate)
print(' Last login at:' .. data.info.lastlogin)
