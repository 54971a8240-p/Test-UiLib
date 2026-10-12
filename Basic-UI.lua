-- v1.1
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ParryUI = {}

function ParryUI.new()
    local self = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "ParryBot"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    gui.Parent = game:GetService("CoreGui")

    local Win = Instance.new("Frame")
    Win.Name = "Window"
    Win.Size = UDim2.new(0, 290, 0, 255)
    Win.Position = UDim2.new(0.5, -145, 0.5, -127)
    Win.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    Win.BorderSizePixel = 0
    Win.Active = true
    Win.Draggable = true
    Win.Parent = gui
    Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 10)

    -- Shadow inside Win so it follows when dragged
    local ShadowHolder = Instance.new("Frame")
    ShadowHolder.Size = UDim2.new(1, 60, 1, 60)
    ShadowHolder.Position = UDim2.new(0, -30, 0, -30)
    ShadowHolder.BackgroundTransparency = 1
    ShadowHolder.ZIndex = 0
    ShadowHolder.Parent = Win

    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 0, 1, 0)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.ZIndex = 0
    Shadow.Parent = ShadowHolder

    -- Accent
    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(1, 0, 0, 2)
    Accent.BackgroundColor3 = Color3.fromRGB(100, 80, 220)
    Accent.BorderSizePixel = 0
    Accent.ZIndex = 2
    Accent.Parent = Win
    local ag = Instance.new("UIGradient")
    ag.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(100, 80,  220)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 100, 255)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(80,  160, 255)),
    })
    ag.Parent = Accent

    -- Title
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundTransparency = 1
    TitleBar.Parent = Win

    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 32, 0, 32)
    Icon.Position = UDim2.new(0, 14, 0, 10)
    Icon.BackgroundTransparency = 1
    Icon.Text = "⚔"
    Icon.TextSize = 20
    Icon.Font = Enum.Font.GothamBold
    Icon.TextColor3 = Color3.fromRGB(160, 120, 255)
    Icon.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 0, 20)
    Title.Position = UDim2.new(0, 50, 0, 9)
    Title.BackgroundTransparency = 1
    Title.Text = "Blade Ball"
    Title.TextSize = 15
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Color3.fromRGB(230, 225, 255)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(1, -60, 0, 14)
    Sub.Position = UDim2.new(0, 50, 0, 30)
    Sub.BackgroundTransparency = 1
    Sub.Text = "auto parry"
    Sub.TextSize = 11
    Sub.Font = Enum.Font.Gotham
    Sub.TextColor3 = Color3.fromRGB(80, 75, 110)
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.Parent = TitleBar

    local Div = Instance.new("Frame")
    Div.Size = UDim2.new(1, -28, 0, 1)
    Div.Position = UDim2.new(0, 14, 0, 52)
    Div.BackgroundColor3 = Color3.fromRGB(28, 26, 38)
    Div.BorderSizePixel = 0
    Div.Parent = Win

    -- ── helpers ───────────────────────────
    local function sectionLabel(text, y)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -28, 0, 14)
        l.Position = UDim2.new(0, 14, 0, y)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextSize = 10
        l.Font = Enum.Font.GothamBold
        l.TextColor3 = Color3.fromRGB(65, 60, 95)
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = Win
    end

    -- Row: label on left, right side free for controls
    -- NOTE: ClipsDescendants is FALSE so pill/keybind dont get cut
    local function makeRow(y, labelText)
        local f = Instance.new("Frame")
        f.Size = UDim2.new(1, -28, 0, 36)
        f.Position = UDim2.new(0, 14, 0, y)
        f.BackgroundTransparency = 1
        f.ClipsDescendants = false
        f.Parent = Win

        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0.5, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = labelText
        l.TextSize = 13
        l.Font = Enum.Font.Gotham
        l.TextColor3 = Color3.fromRGB(185, 180, 210)
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = f
        return f
    end

    -- ── toggle pill ───────────────────────
    local function makePill(parent)
        local pill = Instance.new("TextButton")
        pill.Size = UDim2.new(0, 44, 0, 24)
        pill.Position = UDim2.new(1, -44, 0.5, -12)
        pill.BackgroundColor3 = Color3.fromRGB(32, 30, 46)
        pill.BorderSizePixel = 0
        pill.Text = ""
        pill.AutoButtonColor = false
        pill.ZIndex = 3
        pill.Parent = parent
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new(0, 3, 0.5, -9)
        knob.BackgroundColor3 = Color3.fromRGB(100, 95, 140)
        knob.BorderSizePixel = 0
        knob.ZIndex = 4
        knob.Parent = pill
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local state = false

        local function setState(s)
            state = s
            local kp = s and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
            local pc = s and Color3.fromRGB(100,80,220) or Color3.fromRGB(32,30,46)
            local kc = s and Color3.fromRGB(230,225,255) or Color3.fromRGB(100,95,140)
            TweenService:Create(knob, TweenInfo.new(0.18,Enum.EasingStyle.Quad),
                {Position=kp, BackgroundColor3=kc}):Play()
            TweenService:Create(pill, TweenInfo.new(0.18,Enum.EasingStyle.Quad),
                {BackgroundColor3=pc}):Play()
        end

        pill.MouseButton1Click:Connect(function()
            setState(not state)
            if self.onToggle then self.onToggle(state) end
        end)

        return setState, function() return state end
    end

    -- ── keybind tag ───────────────────────
    -- Left click = rebind, Right click = hold/toggle picker
    local function makeKeybind(parent, defaultKey)
        local tag = Instance.new("TextButton")
        tag.Size = UDim2.new(0, 52, 0, 26)
        tag.Position = UDim2.new(1, -102, 0.5, -13)
        tag.BackgroundColor3 = Color3.fromRGB(24, 22, 36)
        tag.BorderSizePixel = 0
        tag.Text = defaultKey.Name
        tag.TextSize = 11
        tag.Font = Enum.Font.GothamBold
        tag.TextColor3 = Color3.fromRGB(150, 140, 190)
        tag.AutoButtonColor = false
        tag.ZIndex = 3
        tag.Parent = parent
        Instance.new("UICorner", tag).CornerRadius = UDim.new(0, 6)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(45, 42, 65)
        stroke.Thickness = 1
        stroke.Parent = tag

        -- Mini hud parented to Win so it isn't clipped by row
        local miniHud = Instance.new("Frame")
        miniHud.Size = UDim2.new(0, 110, 0, 62)
        miniHud.BackgroundColor3 = Color3.fromRGB(18, 16, 28)
        miniHud.BorderSizePixel = 0
        miniHud.Visible = false
        miniHud.ZIndex = 20
        miniHud.Parent = Win  -- parented to Win, not tag
        Instance.new("UICorner", miniHud).CornerRadius = UDim.new(0, 7)
        local ms = Instance.new("UIStroke")
        ms.Color = Color3.fromRGB(50, 45, 75)
        ms.Thickness = 1
        ms.Parent = miniHud

        local function miniOpt(text, yp)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -12, 0, 26)
            b.Position = UDim2.new(0, 6, 0, yp)
            b.BackgroundTransparency = 1
            b.Text = text
            b.TextSize = 12
            b.Font = Enum.Font.Gotham
            b.TextColor3 = Color3.fromRGB(165, 160, 200)
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.ZIndex = 21
            b.Parent = miniHud
            return b
        end

        local holdBtn   = miniOpt("  Hold",   4)
        local toggleBtn = miniOpt("  Toggle", 32)
        local spamMode  = "hold"

        local function setSpamMode(mode)
            spamMode = mode
            holdBtn.TextColor3   = mode=="hold"   and Color3.fromRGB(160,130,255) or Color3.fromRGB(165,160,200)
            toggleBtn.TextColor3 = mode=="toggle" and Color3.fromRGB(160,130,255) or Color3.fromRGB(165,160,200)
            miniHud.Visible = false
            if self.onSpamModeChanged then self.onSpamModeChanged(mode) end
        end

        holdBtn.MouseButton1Click:Connect(function()   setSpamMode("hold")   end)
        toggleBtn.MouseButton1Click:Connect(function() setSpamMode("toggle") end)

        -- Position mini hud relative to Win when shown
        tag.MouseButton2Click:Connect(function()
            if miniHud.Visible then
                miniHud.Visible = false
                return
            end
            -- Get tag absolute position relative to Win
            local tagPos = tag.AbsolutePosition - Win.AbsolutePosition
            miniHud.Position = UDim2.new(0, tagPos.X - 29, 0, tagPos.Y + 30)
            miniHud.Visible = true
        end)

        -- Close on click elsewhere — use UserInputService, NOT gui
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- small delay so the right-click handler fires first
                task.delay(0.05, function()
                    miniHud.Visible = false
                end)
            end
        end)

        -- Rebind on left click
        local listening = false
        local currentKey = defaultKey

        tag.MouseButton1Click:Connect(function()
            listening = true
            tag.Text = "..."
            tag.TextColor3 = Color3.fromRGB(160, 130, 255)
            TweenService:Create(stroke, TweenInfo.new(0.15),
                {Color=Color3.fromRGB(120,90,220)}):Play()
        end)

        UserInputService.InputBegan:Connect(function(input, gp)
            if not listening then return end
            if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
            currentKey = input.KeyCode
            tag.Text = input.KeyCode.Name
            tag.TextColor3 = Color3.fromRGB(150, 140, 190)
            TweenService:Create(stroke, TweenInfo.new(0.15),
                {Color=Color3.fromRGB(45,42,65)}):Play()
            listening = false
            if self.onKeybindChanged then self.onKeybindChanged(currentKey) end
        end)

        return function() return currentKey end,
               function() return spamMode  end
    end

    -- ── dropdown ──────────────────────────
    local function makeDropdown(y, options, default)
        local selected = default or options[1]
        local open = false
        local itemH = 30

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -28, 0, 32)
        btn.Position = UDim2.new(0, 14, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(20, 18, 28)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 5
        btn.Parent = Win
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(38, 35, 55)
        stroke.Thickness = 1
        stroke.Parent = btn

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -36, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = selected
        lbl.TextSize = 12
        lbl.Font = Enum.Font.Gotham
        lbl.TextColor3 = Color3.fromRGB(185, 180, 215)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 6
        lbl.Parent = btn

        local arrow = Instance.new("TextLabel")
        arrow.Size = UDim2.new(0, 24, 1, 0)
        arrow.Position = UDim2.new(1, -28, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "›"
        arrow.TextSize = 16
        arrow.Font = Enum.Font.GothamBold
        arrow.TextColor3 = Color3.fromRGB(90, 85, 130)
        arrow.Rotation = 90
        arrow.ZIndex = 6
        arrow.Parent = btn

        local list = Instance.new("Frame")
        list.Size = UDim2.new(1, -28, 0, #options * itemH)
        list.Position = UDim2.new(0, 14, 0, y + 34)
        list.BackgroundColor3 = Color3.fromRGB(18, 16, 26)
        list.BorderSizePixel = 0
        list.ClipsDescendants = true
        list.ZIndex = 10
        list.Visible = false
        list.Parent = Win
        Instance.new("UICorner", list).CornerRadius = UDim.new(0, 7)
        local ls = Instance.new("UIStroke")
        ls.Color = Color3.fromRGB(38, 35, 55)
        ls.Parent = list

        local optBtns = {}
        for i, opt in ipairs(options) do
            local ob = Instance.new("TextButton")
            ob.Size = UDim2.new(1, 0, 0, itemH)
            ob.Position = UDim2.new(0, 0, 0, (i-1)*itemH)
            ob.BackgroundTransparency = 1
            ob.Text = opt
            ob.TextSize = 12
            ob.Font = Enum.Font.Gotham
            ob.TextColor3 = opt==selected
                and Color3.fromRGB(160,130,255)
                or  Color3.fromRGB(155,150,190)
            ob.ZIndex = 11
            ob.Parent = list
            optBtns[i] = ob

            ob.MouseButton1Click:Connect(function()
                selected = opt
                lbl.Text = opt
                for j, b in ipairs(optBtns) do
                    b.TextColor3 = j==i
                        and Color3.fromRGB(160,130,255)
                        or  Color3.fromRGB(155,150,190)
                end
                open = false
                list.Visible = false
                TweenService:Create(arrow, TweenInfo.new(0.15), {Rotation=90}):Play()
                if self.onModeChanged then self.onModeChanged(opt) end
            end)
        end

        btn.MouseButton1Click:Connect(function()
            open = not open
            list.Visible = open
            TweenService:Create(arrow, TweenInfo.new(0.15),
                {Rotation = open and 270 or 90}):Play()
        end)
    end

    -- ── status bar ────────────────────────
    local statusBar = Instance.new("Frame")
    statusBar.Size = UDim2.new(1, 0, 0, 30)
    statusBar.Position = UDim2.new(0, 0, 1, -30)
    statusBar.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    statusBar.BorderSizePixel = 0
    statusBar.Parent = Win

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 7, 0, 7)
    dot.Position = UDim2.new(0, 14, 0.5, -3)
    dot.BackgroundColor3 = Color3.fromRGB(55, 52, 80)
    dot.BorderSizePixel = 0
    dot.Parent = statusBar
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(1, -34, 1, 0)
    statusLbl.Position = UDim2.new(0, 28, 0, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "idle"
    statusLbl.TextSize = 11
    statusLbl.Font = Enum.Font.Gotham
    statusLbl.TextColor3 = Color3.fromRGB(80, 75, 115)
    statusLbl.TextXAlignment = Enum.TextXAlignment.Left
    statusLbl.Parent = statusBar

    -- ── assemble ──────────────────────────
    sectionLabel("PARRY", 62)
    local row1 = makeRow(78, "Auto Parry")
    local getKey, getSpamMode = makeKeybind(row1, Enum.KeyCode.L)
    local setPill, getPill = makePill(row1)

    sectionLabel("METHOD", 124)
    makeDropdown(140, {"Remote", "Keypress"}, "Remote")

    -- ── public API ────────────────────────
    function self.setStatus(text, col)
        statusLbl.Text = text
        local c = col or Color3.fromRGB(80,75,115)
        statusLbl.TextColor3 = c
        TweenService:Create(dot, TweenInfo.new(0.2), {BackgroundColor3=c}):Play()
    end

    function self.getKey()       return getKey()      end
    function self.getToggle()    return getPill()     end
    function self.setToggle(s)   setPill(s)           end
    function self.getSpamMode()  return getSpamMode() end

    self.onToggle          = nil
    self.onKeybindChanged  = nil
    self.onModeChanged     = nil
    self.onSpamModeChanged = nil

    return self
end

return ParryUI
