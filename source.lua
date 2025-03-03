local link = [[https://github.com/v9h/sounds/raw/refs/heads/main/Sybyr%20Mix%202%20(Destroyed).mp3]]
local alphabet = {}
local randString = ""

for i = 97, 122 do
    local char = utf8.char(i)
    table.insert(alphabet, char)
end

for i = 1, 5 do
    local rand = math.random(1, #alphabet)
    randString = randString..alphabet[rand] -- need this so that the file name is unique
end

for i, v in pairs(game.Workspace.Camera:GetChildren()) do
    if v.ClassName == "Sound" then
        v:Destroy()
    end
end
wait(1)


-- get file extension
local extension = link:match("%.([^%.]+)$")
local fileext = extension:match("^(mp3|ogg|wav)") or "mp3"
local filename = randString .. "gensound." .. fileext
writefile(filename, request({ Url = link, Method = "GET" }).Body)

local sound = Instance.new("Sound")
sound.SoundId = getcustomasset(filename)
sound.Parent = workspace.CurrentCamera
sound.Volume = 5
sound:Play()

-- delete previous ui
if game:GetService("CoreGui"):FindFirstChild("SoundVisualizer") then
    game:GetService("CoreGui"):FindFirstChild("SoundVisualizer"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SoundVisualizer"
ScreenGui.Parent = game:GetService("CoreGui")

local numBars = 30  
local screenWidth = game:GetService("Workspace").Camera.ViewportSize.X
local barWidth = screenWidth / numBars  
local spacing = 2   
local tweenService = game:GetService("TweenService")

-- make bars
local bars = {}
for i = 1, numBars do
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, barWidth - spacing, 0, 5) 
    bar.Position = UDim2.new(0, (i - 1) * barWidth, 1, 0) 
    bar.AnchorPoint = Vector2.new(0, 1)  
    bar.BackgroundColor3 = Color3.new(1, 1, 1)
    bar.BorderSizePixel = 0
    bar.BackgroundTransparency = 0.6 
    bar.ZIndex = 2 -- Ensure bars are rendered on top

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = bar

    bar.Parent = ScreenGui
    bars[i] = bar
end

-- create time and status labels
local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(0, 200, 0, 30)
timeLabel.Position = UDim2.new(0.5, -100, 0, 10)
timeLabel.BackgroundTransparency = 1
timeLabel.TextScaled = true
timeLabel.TextSize = 14
timeLabel.TextColor3 = Color3.new(1, 1, 1) 
timeLabel.Parent = ScreenGui

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 200, 0, 30) 
statusLabel.Position = UDim2.new(0.5, -100, 0, 40)
statusLabel.BackgroundTransparency = 1
statusLabel.TextScaled = true
statusLabel.TextSize = 14 
statusLabel.Text = "Music name, get from API" 
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.Parent = ScreenGui

-- wait for sound to load
task.spawn(function()
    while sound.TimeLength == 0 do wait(0.5) end

    -- gets stuff
    while sound.Playing do
        local loudness = sound.PlaybackLoudness / 100
        local songPosition = sound.TimePosition
        local songLength = sound.TimeLength
        local function formatTime(seconds)
            local minutes = math.floor(seconds / 60)
            local seconds = math.floor(seconds % 60)
            return string.format("%02d:%02d", minutes, seconds)
        end
        timeLabel.Text = formatTime(songPosition) .. "/" .. formatTime(songLength)

        for i, bar in ipairs(bars) do
            local randomness = math.random(50, 150) / 100 
            local targetHeight = loudness * randomness * 35
            local hue = (tick() * 0.2 + i * 0.01) % 1  
            local barColor = Color3.fromHSV(hue, 0.4, 0.6)
            bar.BackgroundColor3 = barColor

            local tween = tweenService:Create(bar, TweenInfo.new(0.2, Enum.EasingStyle.Linear), 
                {Size = UDim2.new(0, barWidth - spacing, 0, targetHeight)})
            tween:Play()
        end

        -- Update the text color to match the bars
        local hue = (tick() * 0.2) % 1
        local textColor = Color3.fromHSV(hue, 0.4, 0.6)
        timeLabel.TextColor3 = textColor
        statusLabel.TextColor3 = textColor

        task.wait(.1) -- dont recommend going lower, it'll make the bars look less smooth
    end

    ScreenGui:Destroy()
end)

-- delete sound file after playing
sound.Ended:Connect(function()
    delfile(filename)
    sound:Destroy()
end)
