--[[
    FATALITY.WIN UI FRAMEWORK v2.0
    Style: Fatality CS:GO (Purple/Pink/Dark)
    Enhanced with loading screen, particles, customizable themes
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
    Loaded = false
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

-- Створення папки для конфігів
if makefolder then
    pcall(makefolder, Fatality.ConfigFolder)
end

-- Particle System
local function CreateParticles(parent)
    local particleContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 1,
        Parent = parent
    })

    for i = 1, 20 do
        spawn(function()
            local particle = Create("Frame", {
                Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4)),
                Position = UDim2.new(math.random(), 0, math.random(), 0),
                BackgroundColor3 = Color3.fromRGB(180, 0, 255),
                BackgroundTransparency = 0.7,
                BorderSizePixel = 0,
                ZIndex = 1,
                Parent = particleContainer
            })

            while particle and particle.Parent do
                local tweenInfo = TweenInfo.new(math.random(4, 8), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                local tween = TweenService:Create(particle, tweenInfo, {
                    Position = UDim2.new(math.random(), 0, math.random(), 0),
                    BackgroundTransparency = math.random(60, 90) / 100
                })
                tween:Play()
                tween.Completed:Wait()
            end
        end)
    end
end

-- Loading Screen
function Fatality:ShowLoading(callback)
    local loadingGui = Create("ScreenGui", {
        Name = "FatalityLoading",
        Parent = CoreGui,
        DisplayOrder = 999,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    local loadingFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(10, 10, 15),
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Parent = loadingGui
    })

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

    Create("UIGradient", {
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

    Create("UIGradient", {
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
        Text = "Initializing...",
        TextColor3 = Color3.fromRGB(160, 160, 170),
        Font = Fatality.Font,
        TextSize = 14,
        Parent = centerFrame
    })

    -- Version text
    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 140),
        BackgroundTransparency = 1,
        Text = "v2.0 | fatality.win",
        TextColor3 = Color3.fromRGB(100, 100, 110),
        Font = Fatality.Font,
        TextSize = 12,
        Parent = centerFrame
    })

    -- Fade in
    TweenService:Create(loadingFrame, TweenInfo.new(0.3), {
        BackgroundTransparency = 0
    }):Play()

    -- Loading animation
    spawn(function()
        local phases = {
            {time = 0.3, percent = 0.2, text = "Loading components..."},
            {time = 0.4, percent = 0.5, text = "Initializing UI..."},
            {time = 0.3, percent = 0.7, text = "Loading scripts..."},
            {time = 0.4, percent = 0.9, text = "Finalizing..."},
            {time = 0.2, percent = 1.0, text = "Complete!"}
        }

        for _, phase in ipairs(phases) do
            loadingText.Text = phase.text
            TweenService:Create(barFill, TweenInfo.new(phase.time, Enum.EasingStyle.Quad), {
                Size = UDim2.new(phase.percent, 0, 1, 0)
            }):Play()
            wait(phase.time)
        end

        wait(0.3)
        
        -- Fade out
        TweenService:Create(loadingFrame, TweenInfo.new(0.5), {
            BackgroundTransparency = 1
        }):Play()
        wait(0.5)
        
        loadingGui:Destroy()
        Fatality.Loaded = true
        
        -- Call callback after loading
        if callback then
            callback()
        end
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
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false
    })

    local Main = Create("Frame", {
        Size = UDim2.new(0, 680, 0, 540),
        Position = UDim2.new(0.5, -310, 0.5, -240),
        BackgroundColor3 = Theme.Main,
        BorderSizePixel = 0,
        Visible = true,
        Parent = ScreenGui
    })

    -- Corner rounding
    local UICorner = Create("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = Main
    })

    -- Background particles
    CreateParticles(Main)

    -- Top accent bar
    local Bar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 2),
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = Main
    })
    Create("UIGradient", { Color = Theme.AccentGradient, Parent = Bar })

    -- Top bar with controls
    local TopBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 2),
        BackgroundColor3 = Color3.fromRGB(12, 12, 18),
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = Main
    })

    -- Window title
    Create("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = titleText:upper(),
        TextColor3 = Theme.TextDark,
        Font = Fatality.Font,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar
    })

    -- Close button
    local CloseBtn = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(30, 30, 40),
        Text = "×",
        TextColor3 = Theme.Text,
        Font = Fatality.Font,
        TextSize = 18,
        BorderSizePixel = 0,
        Parent = TopBar
    })

    CloseBtn.MouseButton1Click:Connect(function()
        Window.Visible = false
        Main.Visible = false
    end)

    -- Sidebar
    local Sidebar = Create("Frame", {
        Size = UDim2.new(0, 160, 1, -32),
        Position = UDim2.new(0, 0, 0, 32),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        ZIndex = 5,
        Parent = Main
    })

    -- Logo
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

    -- Tab buttons container
    local TabContainer = Create("Frame", {
        Size = UDim2.new(1, 0, 1, -60),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        Parent = Sidebar
    })
    Create("UIListLayout", { 
        SortOrder = Enum.SortOrder.LayoutOrder, 
        Padding = UDim.new(0, 2),
        Parent = TabContainer 
    })

    -- Page container
    local PageContainer = Create("Frame", {
        Size = UDim2.new(1, -165, 1, -42),
        Position = UDim2.new(0, 165, 0, 38),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = Main
    })

    -- Bottom bar
    local BottomBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -20),
        BackgroundColor3 = Color3.fromRGB(12, 12, 18),
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = Main
    })

    local FPSText = Create("TextLabel", {
        Size = UDim2.new(1, -10, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "fatality.win | FPS: 60",
        TextColor3 = Theme.TextDark,
        Font = Fatality.Font,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = BottomBar
    })

    -- Update FPS
    spawn(function()
        while BottomBar and BottomBar.Parent do
            wait(1)
            if FPSText and FPSText.Parent then
                local fps = math.floor(1 / RunService.RenderStepped:Wait())
                FPSText.Text = "fatality.win | FPS: " .. fps
            end
        end
    end)

    -- Dragging functionality
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Toggle window visibility
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Insert or input.KeyCode == Enum.KeyCode.RightShift then
            Window.Visible = not Window.Visible
            Main.Visible = Window.Visible
        end
    end)

    -- Function to add tabs
    function Window:AddTab(name)
        local Sections = {}
        
        -- Tab button
        local TabBtn = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = name:upper(),
            TextColor3 = Theme.TextDark,
            Font = Fatality.Font,
            TextSize = 14,
            Parent = TabContainer
        })

        -- Tab page (ScrollingFrame)
        local Page = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Fatality.Accent,
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Parent = PageContainer
        })
        
        Create("UIListLayout", { 
            Padding = UDim.new(0, 15),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Page
        })

        -- Auto-update canvas size
        Page.ChildAdded:Connect(function()
            wait(0.1)
            local contentSize = 0
            for _, child in ipairs(Page:GetChildren()) do
                if child:IsA("Frame") then
                    contentSize = contentSize + child.AbsoluteSize.Y + 15
                end
            end
            Page.CanvasSize = UDim2.new(0, 0, 0, contentSize)
        end)

        -- Tab click handler
        TabBtn.MouseButton1Click:Connect(function()
            -- Hide all pages
            for _, v in pairs(PageContainer:GetChildren()) do 
                if v:IsA("ScrollingFrame") then
                    v.Visible = false 
                end
            end
            
            -- Reset all tab colors
            for _, v in pairs(TabContainer:GetChildren()) do 
                if v:IsA("TextButton") then 
                    v.TextColor3 = Theme.TextDark 
                end 
            end
            
            -- Show selected page and highlight tab
            Page.Visible = true
            TabBtn.TextColor3 = Theme.Text
        end)

        -- Select first tab automatically
        if #TabContainer:GetChildren() == 2 then -- Logo + first tab button
            Page.Visible = true
            TabBtn.TextColor3 = Theme.Text
        end

        -- Add section method
        function Sections:AddSection(sName)
            local SectionOuter = Create("Frame", {
                Size = UDim2.new(1, -10, 0, 30),
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

            -- Update section size when content changes
            Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionOuter.Size = UDim2.new(1, -10, 0, Layout.AbsoluteContentSize.Y + 25)
            end)

            local Elements = {}

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
                    AutoButtonColor = false,
                    BorderSizePixel = 0,
                    Parent = Frame
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
                    TweenService:Create(Box, TweenInfo.new(0.2), {
                        BackgroundColor3 = val and Fatality.Accent or Theme.Outline
                    }):Play()
                    if callback then callback(val) end
                end

                Box.MouseButton1Click:Connect(function()
                    Tgl:Set(not Tgl.Value)
                end)

                if flag then Fatality.Options[flag] = Tgl end
                return Tgl
            end

            function Elements:AddSlider(text, min, max, default, flag, callback)
                local Sld = { Value = default, Type = "Slider" }
                local SldFrame = Create("Frame", { 
                    Size = UDim2.new(1, 0, 0, 38), 
                    BackgroundTransparency = 1, 
                    Parent = Content 
                })
                
                Create("TextLabel", { 
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
                    Fill.Size = UDim2.new(p, 0, 1, 0)
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

                if flag then Fatality.Options[flag] = Sld end
                return Sld
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

                Btn.MouseButton1Click:Connect(callback)
                return Btn
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

                if flag then Fatality.Options[flag] = Bind end
                return Bind
            end

            return Elements
        end

        return Sections
    end

    return Window
end

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
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            ResetOnSpawn = false
        })
    end

    local NotifyFrame = Create("Frame", {
        Size = UDim2.new(0, 240, 0, 60),
        Position = UDim2.new(1, 10, 1, -70),
        BackgroundColor3 = Theme.Main,
        BorderSizePixel = 0,
        ZIndex = 1000,
        Parent = notifyGui
    })
    Create("UIStroke", { Color = Theme.Outline, Thickness = 1, Parent = NotifyFrame })
    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = NotifyFrame })
    
    local Line = Create("Frame", { 
        Size = UDim2.new(1, 0, 0, 2),
        ZIndex = 1001,
        Parent = NotifyFrame 
    })
    Create("UIGradient", { Color = Theme.AccentGradient, Parent = Line })

    Create("TextLabel", { 
        Size = UDim2.new(1, -20, 0, 25), 
        Position = UDim2.new(0, 10, 0, 5), 
        BackgroundTransparency = 1, 
        Text = title:upper(), 
        TextColor3 = Fatality.Accent, 
        Font = Fatality.Font, 
        TextSize = 14, 
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1001,
        Parent = NotifyFrame 
    })
    
    Create("TextLabel", { 
        Size = UDim2.new(1, -20, 0, 25), 
        Position = UDim2.new(0, 10, 0, 25), 
        BackgroundTransparency = 1, 
        Text = text, 
        TextColor3 = Theme.Text, 
        Font = Fatality.Font, 
        TextSize = 12, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        TextWrapped = true,
        ZIndex = 1001,
        Parent = NotifyFrame 
    })

    NotifyFrame:TweenPosition(UDim2.new(1, -250, 1, -70), "Out", "Quart", 0.5)
    
    task.delay(duration, function()
        if NotifyFrame and NotifyFrame.Parent then
            NotifyFrame:TweenPosition(UDim2.new(1, 10, 1, -70), "In", "Quart", 0.5)
            task.wait(0.5)
            NotifyFrame:Destroy()
        end
    end)
end

return Fatality
