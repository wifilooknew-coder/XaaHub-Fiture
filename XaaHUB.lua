-- Recorder + WalkSpeed + Infinite Jump (Minimalis + Title + Minimize + Animasi)
warn("Recorder Minimal GUI Loaded")

local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- ====== Recorder ======
local recording = false
local startTime = 0
local logs = {}

-- ====== Extra ======
local infJumpEnabled = false
local wsEnabled = false
local normalWS = humanoid.WalkSpeed
local boostedWS = 50

-- ====== GUI ======
local gui = Instance.new("ScreenGui")
gui.Name = "RecorderGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 160)
frame.Position = UDim2.new(0.05, 0, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 22)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -44, 1, 0) -- space buat tombol
title.Position = UDim2.new(0, 5, 0, 0)
title.BackgroundTransparency = 1
title.Text = "XaaScriptHub"
title.TextColor3 = Color3.fromRGB(255, 70, 70) -- merah
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 18, 0, 18)
closeBtn.Position = UDim2.new(1, -20, 0.5, -9)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 18, 0, 18)
minimizeBtn.Position = UDim2.new(1, -40, 0.5, -9)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.TextSize = 12
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.Parent = titleBar

-- Container untuk tombol utama
local container = Instance.new("Frame")
container.Size = UDim2.new(1,0,1,-24)
container.Position = UDim2.new(0,0,0,24)
container.BackgroundTransparency = 1
container.Parent = frame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.Padding = UDim.new(0,3)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

-- Button Creator
local function makeButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 22)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 13
	btn.AutoButtonColor = true
	btn.Parent = container
	return btn
end

-- Buttons
local startBtn = makeButton("▶ Start Recording")
local stopBtn = makeButton("⏹ Stop Recording")
local copyBtn = makeButton("📋 Copy Log")
local wsBtn = makeButton("⚡ WalkSpeed (OFF)")
local jumpBtn = makeButton("🌀 Inf Jump (OFF)")

-- Minimize logic with animation
local minimized = false
local normalSize = UDim2.new(0, 180, 0, 160)
local minimizedSize = UDim2.new(0, 180, 0, 22)
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		minimizeBtn.Text = "+"
		container.Visible = false
		TweenService:Create(frame, tweenInfo, {Size = minimizedSize}):Play()
	else
		minimizeBtn.Text = "-"
		TweenService:Create(frame, tweenInfo, {Size = normalSize}):Play()
		task.delay(0.25, function() -- tunggu animasi selesai
			if not minimized then
				container.Visible = true
			end
		end)
	end
end)

-- Functions
local function updateBtn(btn, state)
	if state then
		btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	else
		btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end
end

-- Recording
local function startRecording()
	if recording then return end
	recording = true
	startTime = tick()
	logs = {}
	warn("[0] Recording Started")

	task.spawn(function()
		while recording do
			local now = tick() - startTime
			local pos = hrp.Position
			table.insert(logs, string.format("[%.2f] Vector3.new(%.2f, %.2f, %.2f)", now, pos.X, pos.Y, pos.Z))
			task.wait(1)
		end
	end)
end

local function stopRecording()
	if not recording then return end
	recording = false
	warn(string.format("[%.2f] Recording Stopped", tick() - startTime))
end

local function copyLog()
	if #logs == 0 then
		warn("Belum ada log!")
		return
	end
	local allLogs = table.concat(logs, "\n")
	if setclipboard then
		setclipboard(allLogs)
		warn("Log dicopy ke clipboard!")
	else
		print("=== COPY MANUAL DI BAWAH INI ===")
		print(allLogs)
		print("=== END COPY ===")
	end
end

-- WalkSpeed
local function toggleWS()
	wsEnabled = not wsEnabled
	if wsEnabled then
		humanoid.WalkSpeed = boostedWS
		wsBtn.Text = "⚡ WalkSpeed (ON)"
	else
		humanoid.WalkSpeed = normalWS
		wsBtn.Text = "⚡ WalkSpeed (OFF)"
	end
	updateBtn(wsBtn, wsEnabled)
end

-- Inf Jump
local UserInputService = game:GetService("UserInputService")
UserInputService.JumpRequest:Connect(function()
	if infJumpEnabled then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

local function toggleInfJump()
	infJumpEnabled = not infJumpEnabled
	if infJumpEnabled then
		jumpBtn.Text = "🌀 Inf Jump (ON)"
	else
		jumpBtn.Text = "🌀 Inf Jump (OFF)"
	end
	updateBtn(jumpBtn, infJumpEnabled)
end

-- Connect
startBtn.MouseButton1Click:Connect(startRecording)
stopBtn.MouseButton1Click:Connect(stopRecording)
copyBtn.MouseButton1Click:Connect(copyLog)
wsBtn.MouseButton1Click:Connect(toggleWS)
jumpBtn.MouseButton1Click:Connect(toggleInfJump)
