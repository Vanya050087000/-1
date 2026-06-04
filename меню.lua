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
local Players = game:GetService("Players")
local Fatality = {
    Font = Enum.Font.RobotoMono,
    Accent = Color3.fromRGB(180, 0, 255),
    Secondary = Color3.fromRGB(255, 0, 150),
    Options = {},
    ConfigFolder = "FatalityConfigs"
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

-- Створення папки для конфігів при ініціалізації
if makefolder then
    pcall(makefolder, Fatality.ConfigFolder)
end

-- Particle System
local function CreateParticles(parent)
    local particleContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = parent,
        ZIndex = 0
    })

    for i = 1, 15 do
        local particle = Create("Frame", {
            Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4)),
            Position = UDim2.new(math.random(), 0, math.random(), 0),
            BackgroundColor3 = Color3.fromRGB(180, 0, 255),
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            Parent = particleContainer,
            ZIndex = 0
        })

        -- Animate particles
        spawn(function()
            while particle and particle.Parent do
                local newX = math.random()
                local newY = math.random()
                local tweenInfo = TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                local tween = TweenService:Create(particle, tweenInfo, {
                    Position = UDim2.new(newX, 0, newY, 0),
                    BackgroundTransparency = math.random(60, 90) / 100
                })
                tween:Play()
                tween.Completed:Wait()
            end
        end)
    end
end

-- Loading Screen
function Fatality:ShowLoading()
    local loadingGui = Create("ScreenGui", {
        Name = "FatalityLoading",
        Parent = CoreGui,
        DisplayOrder = 999,
        ZIndexBehavior = Enum.ZIndexBehavior.Global
    })

    local loadingFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 10, 15),
        BorderSizePixel = 0,
        Parent = loadingGui
    })

    -- Create particles in background
    CreateParticles(loadingFrame)

    -- Center container
    local centerFrame = Create("Frame", {
        Size = UDim2.new(0, 400, 0, 200),
        Position = UDim2.new(0.5, -200, 0.5, -100),
        BackgroundTransparency = 1,
        Parent = loadingFrame
    })

    -- Logo
    local logo = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "FATALITY",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Fatality.Font,
        TextSize = 48,
        TextStrokeTransparency = 0.5,
        TextStrokeColor3 = Color3.fromRGB(180, 0, 255),
        Parent = centerFrame
    })

    local logoGradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 0, 150)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 0, 255))
        }),
        Parent = logo
    })

    -- Loading bar background
    local barBg = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 4),
        Position = UDim2.new(0.5, -150, 0, 100),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        BorderSizePixel = 0,
        Parent = centerFrame
    })

    -- Loading bar fill
    local barFill = Create("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(180, 0, 255),
        BorderSizePixel = 0,
        Parent = barBg
    })

    local barGradient = Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 150))
        }),
        Parent = barFill
    })

    -- Loading text
    local loadingText = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 115),
        BackgroundTransparency = 1,
        Text = "Loading...",
        TextColor3 = Color3.fromRGB(160, 160, 170),
        Font = Fatality.Font,
        TextSize = 14,
        Parent = centerFrame
    })

    -- Version text
    local versionText = Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 140),
        BackgroundTransparency = 1,
        Text = "v2.0 | fatality.win",
        TextColor3 = Color3.fromRGB(100, 100, 110),
        Font = Fatality.Font,
        TextSize = 12,
        Parent = centerFrame
    })

    -- Animation sequence
    spawn(function()
        -- Fade in
        loadingFrame.BackgroundTransparency = 1
        TweenService:Create(loadingFrame, TweenInfo.new(0.3), {
            BackgroundTransparency = 0
        }):Play()

        -- Loading bar animation with sound-like effects
        local phases = {
            {time = 0.3, percent = 0.2},
            {time = 0.5, percent = 0.5},
            {time = 0.3, percent = 0.7},
            {time = 0.5, percent = 0.9},
            {time = 0.2, percent = 1.0}
        }

        -- Play loading sound effect (simulated)
        for _, phase in ipairs(phases) do
            loadingText.Text = "Loading components..."
            TweenService:Create(barFill, TweenInfo.new(phase.time, Enum.EasingStyle.Quad), {
                Size = UDim2.new(phase.percent, 0, 1, 0)
            }):Play()
            wait(phase.time)
        end

        loadingText.Text = "Complete!"
        
        -- Fade out
        wait(0.5)
        TweenService:Create(loadingFrame, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()
        wait(0.5)
        
        loadingGui:Destroy()
        Fatality.Loaded = true
    end)
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

    local Main = Create("Frame", {
        Size = UDim2.new(0, 620, 0, 480),
        Position = UDim2.new(0.5, -310, 0.5, -240),
        BackgroundColor3 = Theme.Main,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })

    local Bar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        BorderSizePixel = 0,
        Parent = Main
    })
    Create("UIGradient", { Color = Theme.AccentGradient, Parent = Bar })

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
    Create("UIGradient", { Color = Theme.AccentGradient, Parent = Logo })
    local TabContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 1, -60),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        Parent = Sidebar
    })
    Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = TabContainer })
    local PageContainer = Create("Frame", {
        Size = UDim2.new(1, -170, 1, -15),
        Position = UDim2.new(0, 165, 0, 10),
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

        -- Tab hover effect
        TabBtn.MouseEnter:Connect(function()
            if not (Page.Visible) then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {
                    TextColor3 = Theme.Text
                }):Play()
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if not (Page.Visible) then
                TweenService:Create(TabBtn, TweenInfo.new(0.2), {
                    TextColor3 = Theme.TextDark
                }):Play()
            end
        end)

        local Page = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Fatality.Accent,
            BorderSizePixel = 0,
            Parent = PageContainer,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        Create("UIListLayout", { 
            Padding = UDim.new(0, 15),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Page
        })

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PageContainer:GetChildren()) do v.Visible = false end
            for _, v in pairs(TabContainer:GetChildren()) do if v:IsA("TextButton") then v.TextColor3 = Theme.TextDark end end
            Page.Visible = true
            TabBtn.TextColor3 = Theme.Text
            
            -- Animate page transition
            Page.Position = UDim2.new(0, 50, 0, 0)
            TweenService:Create(Page, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
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
            Create("UIStroke", { 
                Color = Theme.Outline, 
                Thickness = 1,
                Parent = SectionOuter 
            })

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
            local Layout = Create("UIListLayout", { 
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Content 
            })

            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionOuter.Size = UDim2.new(1, -5, 0, Layout.AbsoluteContentSize.Y + 25)
            end)

            local Elements = {}

            function Elements:AddColorPicker(text, default, flag, callback)
                local CP = { Value = default, Type = "ColorPicker" }
                local Frame = Create("Frame", { 
                    Size = UDim2.new(1, 0, 0, 20), 
                    BackgroundTransparency = 1, 
                    Parent = Content 
                })
                
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
                Create("UIStroke", { Color = Theme.Outline, Thickness = 1, Parent = Box })

                function CP:Set(val)
                    if typeof(val) == "table" then val = Color3.new(val.R, val.G, val.B) end
                    CP.Value = val
                    Box.BackgroundColor3 = val
                    if callback then callback(val) end
                end

                Box.MouseButton1Click:Connect(function() 
                    if callback then callback(CP.Value) end
                end)
                
                -- Color picker popup
                local colorPickerOpen = false
                Box.MouseButton2Click:Connect(function()
                    -- Here you could implement a full color picker
                    -- For now, we'll cycle through some preset colors
                    local colors = {
                        Color3.fromRGB(255, 0, 0),
                        Color3.fromRGB(0, 255, 0),
                        Color3.fromRGB(0, 0, 255),
                        Color3.fromRGB(255, 255, 0),
                        Color3.fromRGB(255, 0, 255),
                        Color3.fromRGB(0, 255, 255),
                        Color3.fromRGB(255, 255, 255),
                    }
                    local currentIndex = 1
                    for i, color in ipairs(colors) do
                        if color == CP.Value then
                            currentIndex = i
                            break
                        end
                    end
                    currentIndex = (currentIndex % #colors) + 1
                    CP:Set(colors[currentIndex])
                end)

                if flag then Fatality.Options[flag] = CP end
                return CP
            end

            function Elements:AddToggle(text, default, flag, callback)
                local Tgl = { Value = default, Type = "Toggle" }
                local Frame = Create("Frame", { 
                    Size = UDim2.new(1, 0, 0, 20), 
                    BackgroundTransparency = 1, 
                    Parent = Content 
                })
                
                local Box = Create("TextButton", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0, 0, 0.5, -7),
                    BackgroundColor3 = Tgl.Value and Fatality.Accent or Theme.Outline,
                    Text = "",
                    Parent = Frame,
                    AutoButtonColor = false
                })
                Create("UIStroke", { Color = Theme.Outline, Thickness = 1, Parent = Box })

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
                    local tween = TweenService:Create(Box, TweenInfo.new(0.2), {
                        BackgroundColor3 = val and Fatality.Accent or Theme.Outline
                    })
                    tween:Play()
                    if callback then callback(val) end
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
                local SldFrame = Create("Frame", { 
                    Size = UDim2.new(1, 0, 0, 38), 
                    BackgroundTransparency = 1, 
                    Parent = Content 
                })
                
                local Label = Create("TextLabel", { 
                    Size = UDim2.new(1, 0, 0, 18), 
                    BackgroundTransparency = 1, 
                    Text = text, 
                    TextColor3 = Theme.Text, 
                    Font = Fatality.Font, 
                    TextSize = 13, 
                    TextXAlignment = Enum.TextXAlignment.Left, 
                    Parent = SldFrame 
                })
                
                local Bg = Create("Frame", { 
                    Size = UDim2.new(1, -50, 0, 6), 
                    Position = UDim2.new(0, 0, 0, 24), 
                    BackgroundColor3 = Theme.Outline, 
                    Parent = SldFrame 
                })
                
                local Fill = Create("Frame", { 
                    Size = UDim2.new((default-min)/(max-min), 0, 1, 0), 
                    BackgroundColor3 = Fatality.Accent, 
                    Parent = Bg 
                })
                
                local ValText = Create("TextLabel", { 
                    Size = UDim2.new(0, 40, 0, 18), 
                    Position = UDim2.new(1, -40, 0, 0), 
                    BackgroundTransparency = 1, 
                    Text = tostring(default), 
                    TextColor3 = Theme.TextDark, 
                    Font = Fatality.Font, 
                    TextSize = 12, 
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = SldFrame 
                })

                function Sld:Set(v)
                    local p = math.clamp((v - min) / (max - min), 0, 1)
                    Sld.Value = v
                    TweenService:Create(Fill, TweenInfo.new(0.15), {
                        Size = UDim2.new(p, 0, 1, 0)
                    }):Play()
                    ValText.Text = tostring(v)
                    if callback then callback(v) end
                end

                local dragging = false
                local function update()
                    local p = math.clamp((Mouse.X - Bg.AbsolutePosition.X) / Bg.AbsoluteSize.X, 0, 1)
                    local v = math.floor(min + (max-min) * p)
                    Sld:Set(v)
                end

                Bg.InputBegan:Connect(function(i) 
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
                        dragging = true
                        update() 
                    end 
                end)
                
                UserInputService.InputChanged:Connect(function(i) 
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then 
                        update() 
                    end 
                end)
                
                UserInputService.InputEnded:Connect(function(i) 
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then 
                        dragging = false 
                    end 
                end)

                if flag then
                    Fatality.Options[flag] = Sld
                end

                return Sld
            end

            function Elements:AddKeybind(text, default, flag, callback)
                local Bind = { Value = default.Name, Type = "Keybind" }
                local BindFrame = Create("Frame", { 
                    Size = UDim2.new(1, 0, 0, 20), 
                    BackgroundTransparency = 1, 
                    Parent = Content 
                })
                
                Create("TextLabel", { 
                    Size = UDim2.new(1, -70, 1, 0), 
                    BackgroundTransparency = 1, 
                    Text = text, 
                    TextColor3 = Theme.Text, 
                    Font = Fatality.Font, 
                    TextSize = 13, 
                    TextXAlignment = Enum.TextXAlignment.Left, 
                    Parent = BindFrame 
                })
                
                local Btn = Create("TextButton", {
                    Size = UDim2.new(0, 60, 0, 18),
                    Position = UDim2.new(1, -60, 0.5, -9),
                    BackgroundColor3 = Theme.Outline,
                    Text = default.Name,
                    TextColor3 = Theme.TextDark,
                    Font = Fatality.Font,
                    TextSize = 11,
                    AutoButtonColor = false,
                    Parent = BindFrame
                })
                Create("UIStroke", { Color = Theme.Outline, Thickness = 1, Parent = Btn })

                function Bind:Set(val)
                    Bind.Value = val
                    Btn.Text = val
                    if callback then callback(Enum.KeyCode[val] or val) end
                end

                local picking = false
                Btn.MouseButton1Click:Connect(function() 
                    picking = true
                    Btn.Text = "..."
                    Btn.TextColor3 = Fatality.Accent
                end)
                
                UserInputService.InputBegan:Connect(function(i)
                    if picking and i.UserInputType == Enum.UserInputType.Keyboard then
                        picking = false
                        Btn.TextColor3 = Theme.TextDark
                        Bind:Set(i.KeyCode.Name)
                    end
                end)

                if flag then
                    Fatality.Options[flag] = Bind
                end

                return Bind
            end

            function Elements:AddButton(text, callback)
                local Btn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = Fatality.Accent,
                    Text = text:upper(),
                    TextColor3 = Theme.Text,
                    Font = Fatality.Font,
                    TextSize = 13,
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    Parent = Content
                })
                Create("UIStroke", { Color = Fatality.Secondary, Thickness = 1, Parent = Btn })

                Btn.MouseEnter:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Fatality.Secondary
                    }):Play()
                end)

                Btn.MouseLeave:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Fatality.Accent
                    }):Play()
                end)

                Btn.MouseButton1Click:Connect(callback)
                return Btn
            end

            function Elements:AddDropdown(text, options, default, flag, callback)
                local DD = { Value = default, Type = "Dropdown", Open = false }
                local DDFrame = Create("Frame", { 
                    Size = UDim2.new(1, 0, 0, 20), 
                    BackgroundTransparency = 1, 
                    Parent = Content 
                })
                
                local Label = Create("TextLabel", { 
                    Size = UDim2.new(0, 100, 1, 0), 
                    BackgroundTransparency = 1, 
                    Text = text, 
                    TextColor3 = Theme.Text, 
                    Font = Fatality.Font, 
                    TextSize = 13, 
                    TextXAlignment = Enum.TextXAlignment.Left, 
                    Parent = DDFrame 
                })
                
                local Selector = Create("TextButton", {
                    Size = UDim2.new(1, -110, 1, 0),
                    Position = UDim2.new(0, 110, 0, 0),
                    BackgroundColor3 = Theme.Outline,
                    Text = default,
                    TextColor3 = Theme.Text,
                    Font = Fatality.Font,
                    TextSize = 13,
                    AutoButtonColor = false,
                    Parent = DDFrame
                })

                local DropList = Create("Frame", {
                    Size = UDim2.new(1, -110, 0, 0),
                    Position = UDim2.new(0, 110, 1, 0),
                    BackgroundColor3 = Theme.Sidebar,
                    ClipsDescendants = true,
                    Visible = false,
                    ZIndex = 20,
                    Parent = DDFrame
                })

                local ListLayout = Create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = DropList
                })

                function DD:Set(val)
                    DD.Value = val
                    Selector.Text = val
                    if callback then callback(val) end
                end

                for _, option in ipairs(options) do
                    local OptionBtn = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 20),
                        BackgroundColor3 = Theme.Sidebar,
                        Text = option,
                        TextColor3 = Theme.TextDark,
                        Font = Fatality.Font,
                        TextSize = 12,
                        AutoButtonColor = false,
                        Parent = DropList
                    })
                    
                    OptionBtn.MouseEnter:Connect(function()
                        OptionBtn.BackgroundColor3 = Fatality.Accent
                    end)
                    
                    OptionBtn.MouseLeave:Connect(function()
                        OptionBtn.BackgroundColor3 = Theme.Sidebar
                    end)
                    
                    OptionBtn.MouseButton1Click:Connect(function()
                        DD:Set(option)
                        DD.Open = false
                        DropList.Visible = false
                    end)
                end

                Selector.MouseButton1Click:Connect(function()
                    DD.Open = not DD.Open
                    DropList.Visible = DD.Open
                    if DD.Open then
                        DropList.Size = UDim2.new(1, -110, 0, ListLayout.AbsoluteContentSize.Y)
                    end
                end)

                if flag then
                    Fatality.Options[flag] = DD
                end

                return DD
            end

            return Elements
        end

        return Sections
    end

    return Window
end

-- Theme customization
function Fatality:SetTheme(accent, secondary)
    Fatality.Accent = accent or Fatality.Accent
    Fatality.Secondary = secondary or Fatality.Secondary
    Theme.AccentGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Fatality.Accent),
        ColorSequenceKeypoint.new(1, Fatality.Secondary)
    })
end

function Fatality:Notify(title, text, duration)
    duration = duration or 4
    local notifyGui = CoreGui:FindFirstChild("FatalityNotifications")
    if not notifyGui then
        notifyGui = Create("ScreenGui", {
            Name = "FatalityNotifications",
            Parent = CoreGui,
            DisplayOrder = 1000,
            ZIndexBehavior = Enum.ZIndexBehavior.Global
        })
    end

    local NotifyFrame = Create("Frame", {
        Size = UDim2.new(0, 240, 0, 60),
        Position = UDim2.new(1, 10, 1, -70),
        BackgroundColor3 = Theme.Main,
        BorderSizePixel = 0,
        Parent = notifyGui,
        ZIndex = 1000
    })
    Create("UIStroke", { Color = Theme.Outline
