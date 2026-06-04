--[[
    FATALITY.WIN UI FRAMEWORK
    Style: Fatality CS:GO (Purple/Pink/Dark)
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

local Fatality = {
    Font = Enum.Font.RobotoMono,
    Accent = Color3.fromRGB(180, 0, 255),
    Secondary = Color3.fromRGB(255, 0, 150),
    Options = {},
    ConfigFolder = "FatalityConfigs",
    Gradients = {},
    AccentObjects = {}
}

local Theme = {
    Main = Color3.fromRGB(15, 15, 22),
    Sidebar = Color3.fromRGB(12, 12, 18),
    Outline = Color3.fromRGB(35, 35, 45),
    Section = Color3.fromRGB(20, 20, 28),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(160, 160, 170),
    AccentGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 150))
    })
}

local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    return inst
end

function Fatality:SetTheme(accent, secondary)
    self.Accent = accent or self.Accent
    self.Secondary = secondary or self.Secondary

    local newGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Accent),
        ColorSequenceKeypoint.new(1, self.Secondary)
    })

    for _, grad in pairs(self.Gradients) do
        if grad and grad.Parent then
            grad.Color = newGradient
        end
    end

    for _, obj in pairs(self.AccentObjects) do
        if obj and obj.Parent then
            -- Обновляем сплошные цвета (молнии, ползунки слайдеров)
            obj.BackgroundColor3 = self.Accent
        end
    end
end

-- Створення папки для конфігів при ініціалізації
if makefolder then
    pcall(makefolder, Fatality.ConfigFolder)
end

function Fatality:SaveConfig(name)
    local data = {}
    for flag, option in pairs(self.Options) do
        data[flag] = option.Value
    end
    if writefile then
        writefile(self.ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end
end

function Fatality:LoadConfig(name)
    local path = self.ConfigFolder .. "/" .. name .. ".json"
    if isfile and isfile(path) then
        local data = HttpService:JSONDecode(readfile(path))
        for flag, value in pairs(data) do
            if self.Options[flag] then
                self.Options[flag]:Set(value)
            end
        end
    end
end

function Fatality:CreateWindow(titleText)
    local Window = {
        Tabs = {},
        Visible = true
    }

    local ScreenGui = Create("ScreenGui", {
        Name = "FatalityWin_" .. titleText,
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })

    -- Загрузочный экран (Fatality Style)
    local Loading = Create("Frame",{
        Size = UDim2.new(0, 400, 0, 140),
        Position = UDim2.new(0.5, -200, 0.5, -70),
        BackgroundColor3 = Theme.Main,
        Parent = ScreenGui,
        ZIndex = 100
    })

    local LoadingText = Create("TextLabel",{
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "FATALITY.WIN",
        Font = Fatality.Font,
        TextSize = 26,
        TextColor3 = Color3.new(1, 1, 1),
        Parent = Loading,
        ZIndex = 101
    })

    local BarBg = Create("Frame",{
        Size = UDim2.new(0.8, 0, 0, 4),
        Position = UDim2.new(0.1, 0, 0.7, 0),
        BackgroundColor3 = Theme.Outline,
        Parent = Loading,
        ZIndex = 101
    })

    local Fill = Create("Frame",{
        Size = UDim2.new(0, 0, 1, 0),
        Parent = BarBg,
        ZIndex = 102
    })

    Create("UIGradient",{
        Color = Theme.AccentGradient,
        Parent = Fill
    })

    local Main = Create("Frame", {
        Size = UDim2.new(0, 680, 0, 540),
        Position = UDim2.new(0.5, -310, 0.5, -240),
        BackgroundColor3 = Theme.Main,
        BorderSizePixel = 0,
        Parent = ScreenGui,
        Visible = false -- Скрыто до окончания загрузки
    })

    -- Эффект молний на фоне
    local LightningFolder = Instance.new("Folder")
    LightningFolder.Name = "LightningBackground"
    LightningFolder.Parent = Main

    for i = 1, 8 do
        local line = Instance.new("Frame")
        line.Parent = LightningFolder
        line.BorderSizePixel = 0
        line.BackgroundColor3 = Fatality.Accent
        line.BackgroundTransparency = 0.85
        line.Size = UDim2.new(0, math.random(80, 180), 0, 2)
        line.Position = UDim2.new(math.random(), 0, math.random(), 0)
        line.Rotation = math.random(-70, 70)
        line.ZIndex = 0
        table.insert(Fatality.AccentObjects, line)

        task.spawn(function()
            while line.Parent do
                line.Visible = false
                task.wait(math.random(1, 4))
                line.Visible = true
                TweenService:Create(line, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
                task.wait(0.15)
                line.BackgroundTransparency = 0.85
            end
        end)
    end

    local Bar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        BorderSizePixel = 0,
        Parent = Main
    })
    local BarGrad = Create("UIGradient", { Color = Theme.AccentGradient, Parent = Bar })
    table.insert(self.Gradients, BarGrad)

    local Sidebar = Create("Frame", {
        Size = UDim2.new(0, 160, 1, -2),
        Position = UDim2.new(0, 0, 0, 2),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = Main
    })

    local Logo = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Text = "FATALITY",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Fatality.Font,
        TextSize = 22,
        Parent = Sidebar
    })
    local LogoGrad = Create("UIGradient", { Color = Theme.AccentGradient, Parent = Logo })
    table.insert(self.Gradients, LogoGrad)

    local TabContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 1, -60),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        Parent = Sidebar
    })
    Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabContainer })

    local PageContainer = Create("Frame", {
        Size = UDim2.new(1, -170, 1, -50),
        Position = UDim2.new(0, 165, 0, 35),
        BackgroundTransparency = 1,
        Parent = Main
    })

    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    Main.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    -- Перемикання видимості вікна (Insert / RightShift)
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightShift then
            Window.Visible = not Window.Visible
            Main.Visible = Window.Visible
        end
    end)

    -- Анимация загрузки
    task.spawn(function()
        TweenService:Create(Fill, TweenInfo.new(2.5), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        task.wait(2.5)
        Loading:Destroy()
        Main.Visible = true
    end)

    function Window:AddTab(name)
        local Sections = {}
        local TabBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = name:upper(),
            TextColor3 = Theme.TextDark,
            Font = Fatality.Font,
            TextSize = 14,
            Parent = TabContainer
        })

        local Page = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Fatality.Accent,
            BorderSizePixel = 0,
            Parent = PageContainer
        })
        Create("UIListLayout", { Padding = UDim.new(0, 15), Parent = Page })

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Theme.TextDark end end
            Page.Visible = true
            TabBtn.TextColor3 = Theme.Text
        end)

        if #TabContainer:GetChildren() <= 2 then
            Page.Visible = true; TabBtn.TextColor3 = Theme.Text
        end

        function Sections:AddSection(sName)
            local SectionOuter = Create("Frame", {
                Size = UDim2.new(1, -5, 0, 30),
                BackgroundColor3 = Theme.Section,
                BorderSizePixel = 0,
                Parent = Page
            })
            Create("UIStroke", { Color = Theme.Outline, Parent = SectionOuter })

            local SectionTitle = Create("TextLabel", {
                Size = UDim2.new(0, 0, 0, 18),
                Position = UDim2.new(0, 10, 0, -9),
                BackgroundColor3 = Theme.Main,
                Text = " " .. sName .. " ",
                TextColor3 = Theme.Text,
                Font = Fatality.Font,
                TextSize = 13,
                Parent = SectionOuter
            })
            SectionTitle.Size = UDim2.new(0, SectionTitle.TextBounds.X + 4, 0, 18)

            local Content = Create("Frame", {
                Size = UDim2.new(1, -20, 1, -20),
                Position = UDim2.new(0, 10, 0, 10),
                BackgroundTransparency = 1,
                Parent = SectionOuter
            })
            local Layout = Create("UIListLayout", { Padding = UDim.new(0, 8), Parent = Content })

            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionOuter.Size = UDim2.new(1, -5, 0, Layout.AbsoluteContentSize.Y + 25)
            end)

            local Elements = {}

            function Elements:AddColorPicker(text, default, flag, callback)
                local CP = { Value = default, Type = "ColorPicker" }
                local Frame = Create("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = Content })
                
                local Label = Create("TextLabel", {
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Theme.Text,
                    Font = Fatality.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Frame
                })

                local Box = Create("TextButton", {
                    Size = UDim2.new(0, 25, 0, 14),
                    Position = UDim2.new(1, -30, 0.5, -7),
                    BackgroundColor3 = default,
                    BorderSizePixel = 0,
                    Text = "",
                    Parent = Frame
                })

                function CP:Set(val)
                    if typeof(val) == "table" then val = Color3.new(val.R, val.G, val.B) end
                    CP.Value = val
                    Box.BackgroundColor3 = val
                    callback(val)
                end

                Box.MouseButton1Click:Connect(function() callback(CP.Value) end)
                if flag then Fatality.Options[flag] = CP end
                return CP
            end

            function Elements:AddToggle(text, default, flag, callback)
                local Tgl = { Value = default, Type = "Toggle" }
                local Frame = Create("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = Content })
                
                local Box = Create("TextButton", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0, 0, 0.5, -7),
                    BackgroundColor3 = Tgl.Value and Fatality.Accent or Theme.Outline,
                    Text = "",
                    Parent = Frame
                })

                Create("TextLabel", {
                    Size = UDim2.new(1, -25, 1, 0),
                    Position = UDim2.new(0, 25, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Theme.Text,
                    Font = Fatality.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Frame
                })

                function Tgl:Set(val)
                    Tgl.Value = val
                    Box.BackgroundColor3 = val and Fatality.Accent or Theme.Outline
                    callback(val)
                end

                Box.MouseButton1Click:Connect(function()
                    Tgl:Set(not Tgl.Value)
                end)

                if flag then
                    Fatality.Options[flag] = Tgl
                end

                return Tgl
            end

            function Elements:AddSlider(text, min, max, default, flag, callback)
                local Sld = { Value = default, Type = "Slider" }
                local SldFrame = Create("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundTransparency = 1, Parent = Content })
                Create("TextLabel", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Fatality.Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = SldFrame })
                
                local Bg = Create("Frame", { Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0, 24), BackgroundColor3 = Theme.Outline, Parent = SldFrame })
                local Fill = Create("Frame", { Size = UDim2.new((default-min)/(max-min), 0, 1, 0), BackgroundColor3 = Fatality.Accent, Parent = Bg })
                local ValText = Create("TextLabel", { Size = UDim2.new(0, 40, 0, 18), Position = UDim2.new(1, -40, 0, 0), BackgroundTransparency = 1, Text = tostring(default), TextColor3 = Theme.TextDark, Font = Fatality.Font, TextSize = 12, Parent = SldFrame })
                table.insert(Fatality.AccentObjects, Fill)

                function Sld:Set(v)
                    local p = math.clamp((v - min) / (max - min), 0, 1)
                    Sld.Value = v
                    Fill.Size = UDim2.new(p, 0, 1, 0)
                    ValText.Text = tostring(v)
                    callback(v)
                end

                local dragging = false
                local function update()
                    local p = math.clamp((Mouse.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X, 0, 1)
                    local v = math.floor(min + (max-min) * p)
                    Sld:Set(v)
                end

                Bg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update() end end)
                UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update() end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

                if flag then
                    Fatality.Options[flag] = Sld
                end

                return Sld
            end

            function Elements:AddKeybind(text, default, flag, callback)
                local Bind = { Value = default.Name, Type = "Keybind" }
                local BindFrame = Create("Frame", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Parent = Content })
                Create("TextLabel", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Fatality.Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = BindFrame })
                
                local Btn = Create("TextButton", {
                    Size = UDim2.new(0, 60, 0, 18),
                    Position = UDim2.new(1, -60, 0.5, -9),
                    BackgroundColor3 = Theme.Outline,
                    Text = default.Name,
                    TextColor3 = Theme.TextDark,
                    Font = Fatality.Font,
                    TextSize = 11,
                    Parent = BindFrame
                })

                function Bind:Set(val)
                    Bind.Value = val
                    Btn.Text = val
                    callback(Enum.KeyCode[val] or val)
                end

                local picking = false
                Btn.MouseButton1Click:Connect(function() picking = true; Btn.Text = "..." end)
                UserInputService.InputBegan:Connect(function(i)
                    if picking and i.UserInputType == Enum.UserInputType.Keyboard then
                        picking = false
                        Bind:Set(i.KeyCode.Name)
                    end
                end)

                if flag then
                    Fatality.Options[flag] = Bind
                end

                return Bind
            end

            return Elements
        end

        return Sections
    end

    return Window
end

function Fatality:Notify(title, text)
    local notifyGui = CoreGui:FindFirstChild("FatalityNotifications")
    if not notifyGui then
        notifyGui = Create("ScreenGui", {
            Name = "FatalityNotifications",
            Parent = CoreGui,
            DisplayOrder = 1000
        })
    end

    local NotifyFrame = Create("Frame", {
        Size = UDim2.new(0, 240, 0, 60),
        Position = UDim2.new(1, 10, 1, -70),
        BackgroundColor3 = Theme.Main,
        Parent = notifyGui
    })
    Create("UIStroke", { Color = Theme.Outline, Parent = NotifyFrame })
    local Line = Create("Frame", { Size = UDim2.new(1, 0, 0, 2), Parent = NotifyFrame })
    local NotifyGrad = Create("UIGradient", { Color = Theme.AccentGradient, Parent = Line })
    table.insert(self.Gradients, NotifyGrad)

    Create("TextLabel", { Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 5), BackgroundTransparency = 1, Text = title:upper(), TextColor3 = Fatality.Accent, Font = Fatality.Font, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Parent = NotifyFrame })
    Create("TextLabel", { Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 25), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text, Font = Fatality.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = NotifyFrame })

    NotifyFrame:TweenPosition(UDim2.new(1, -250, 1, -70), "Out", "Quart", 0.5)
    task.delay(4, function()
        NotifyFrame:TweenPosition(UDim2.new(1, 10, 1, -70), "In", "Quart", 0.5)
        task.wait(0.5); NotifyFrame:Destroy()
    end)
end

return Fatality
