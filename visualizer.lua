--[[
name: simple-visualizer
author: Aldanium/recursion/Fernando Goncalves
]]--

local table = {}
local rotation = 0
local playback = 0

local character = owner.Character
local rootPart = character['HumanoidRootPart']

local new = function(obj, ...)
	local Object = Instance.new(obj)
	for i,v in pairs(...) do
		Object[i] = v
	end
	return Object
end

local tween = function(i, t, p)
	game:GetService("TweenService"):Create(i, t, p):Play()
end

local visualizer = new("Part", {
	Parent = script,
	CanCollide = false,
	Anchored = true,
	Material = "Neon",
	Name = "visualizer",
	Locked = true
})

local music = new("Sound", {
	Parent = rootPart,
	SoundId = "rbxassetid://247353474",
	Name = "music",
	Playing = true,
	Looped = true
})

local remote = new("RemoteEvent", {Name = "remoteEvent", Parent = character})

NLS([[
local remote = script.Parent['remoteEvent']
local sound = script.Parent['HumanoidRootPart'].music

game:GetService("RunService").RenderStepped:Connect(function()
	remote:FireServer(sound.PlaybackLoudness)
end)
]], character)

remote.OnServerEvent:Connect(function(player, playback)
	newPlayback = playback
end)

game:GetService("RunService").Heartbeat:Connect(function()
	pcall(function()
		playback = math.floor(newPlayback)
	end)
	rotation = rotation + 0.5
	
	table.Size = Vector3.new(0.5 + playback/200, 2 + playback/300, 0.5 + playback/200)
	table.Color = Color3.fromHSV(tick()/3.25 % 1, 0.66, playback/1000)
	table.CFrame = rootPart.CFrame * CFrame.new(0, 0, -5) * CFrame.Angles(math.rad(rotation), 0, math.rad(rotation))
	
	tween(visualizer, TweenInfo.new(0.25, Enum.EasingStyle.Sine), table)
end)

owner.Chatted:Connect(function(msg)
	if msg:sub(1, 5) == "play " then
		local soundid = msg:sub(6)
		
		music:Stop()
		wait()
		music.SoundId = "rbxassetid://"..soundid
		music:Play()
	elseif msg == "stop" then
		music:Stop()
	end
end)