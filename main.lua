--[[
	
	Inertia Module
	> ben7
	> version 0.1a ; 9/07/2021
	
]]--

local InertiaModule = {}

function specificationfunc(style)
	return (
		style == "linear" and (function(i) return i end) or
		style == "sine" and (function(i) return math.sin(i*math.pi/2) end) or
		style == "quadratic" and (function(i) return math.pow(i, 2) end) or
		style == "cubic" and (function(i) return math.pow(i, 3) end)
	)
end

function userinput()
	assert (InertiaModule.KEYBINDS ~= nil, "inertia not loaded")
	game:GetService("UserInputService").InputBegan:connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			for index, element in pairs(InertiaModule.KEYBINDS) do
				local keycode, func = element[1], element[2]
				if input.KeyCode == keycode then
					pcall(func)
					break
				end
			end
		end
	end)
end

function getmostprobableinput(input)
	assert (InertiaModule.COMMANDS ~= nil, "inertia not loaded")
	for _, list in pairs(InertiaModule.suggestion_lookthrough) do
		for index, _ in pairs(list) do
			if string.lower(string.sub(tostring(index), 1, string.len(tostring(input)))) == string.lower(input) then
				return tostring(index)
			end
		end
	end
	return nil
end

function addlistener(object, property, func)
	object:GetPropertyChangedSignal(property):connect(func)
end

function updatesuggestion()
	assert (InertiaModule.GUI.InputBox ~= nil, "inertia not loaded")
	local inputtext = InertiaModule.GUI.InputBox.Text
	local suggestion = getmostprobableinput(inputtext)
	InertiaModule.GUI.SuggestionLabel.Text = inputtext == "" and "" or (suggestion ~= nil and suggestion or "")
end

function handlecommand(cmd)
	for cmd_known, fn in pairs(InertiaModule.COMMANDS) do
		if string.lower(cmd_known) == cmd then
			pcall(fn)
		end
	end
end

function handlefocuslost(enterpressed)
	InertiaModule:colorunderline({
		color = Color3.fromRGB(255, 255, 255)
	})
	if enterpressed then
		handlecommand(string.lower(InertiaModule.GUI.InputBox.Text))
	end
end

function handlefocused()
	InertiaModule:colorunderline({
		color = Color3.fromRGB(122, 0, 0)
	})
end

function InertiaModule:colorunderline(specifications)
	assert (InertiaModule.GUI.Underline ~= nil, "inertia not loaded")
	local currentcolor = InertiaModule.GUI.Underline.BackgroundColor3
	local specfunc = specificationfunc(specifications.style ~= nil and specifications.style or "linear")
	coroutine.resume(coroutine.create(function() 
		for i = 0, 1, 0.1 do
			InertiaModule.GUI.Underline.BackgroundColor3 = currentcolor:lerp(specifications.color or Color3.fromRGB(255, 255, 255), specfunc(i)) 
			wait(specifications.speed or 0.01)
		end
	end))
end

function InertiaModule:show()
	assert (InertiaModule.GUI.MainFrame ~= nil, "inertia not loaded")
	InertiaModule.GUI.VisibilityFrame:TweenSize(UDim2.new(0, 500, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
end

function InertiaModule:hide()
	assert (InertiaModule.GUI.MainFrame ~= nil, "inertia not loaded")
	InertiaModule.GUI.VisibilityFrame:TweenSize(UDim2.new(0, 500, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.1, true)
end

function InertiaModule:capturefocus()
	assert (InertiaModule.GUI.InputBox ~= nil, "inertia not loaded")
	InertiaModule.GUI.InputBox:CaptureFocus()
end

function InertiaModule:initialize()
	assert (game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("InertiaModule") == nil, "inertia has already been loaded")
	local SC = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer.PlayerGui)
	SC.Name = "InertiaModule"
	SC.DisplayOrder = 100
	SC.IgnoreGuiInset = true
	SC.ResetOnSpawn = false
	local VF = Instance.new("Frame", SC)
	VF.Name = ""
	VF.BackgroundTransparency = 1
	VF.Position = UDim2.new(0.5, -250, 0, 5)
	VF.Size = UDim2.new(0, 500, 0, 20)
	VF.ClipsDescendants = true
	local MF = Instance.new("Frame", VF)
	MF.Name = ""
	MF.BackgroundColor3 = Color3.fromRGB(47, 47, 47)
	MF.BackgroundTransparency = 0.35
	MF.BorderSizePixel = 0
	MF.Size = UDim2.new(0, 500, 0, 20)
	local UL = Instance.new("Frame", MF)
	UL.Name = ""
	UL.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UL.BorderSizePixel = 0
	UL.Position = UDim2.new(0, 0, 1, -1)
	UL.Size = UDim2.new(1, 0, 0, 1)
	UL.ZIndex = 2
	local I = Instance.new("TextLabel", MF)
	I.Name = ""
	I.BackgroundTransparency = 1
	I.Size = UDim2.new(0, 20, 0, 20)
	I.ZIndex = 2
	I.Font = Enum.Font.SourceSansBold
	I.Text = ">"
	I.TextColor3 = Color3.fromRGB(182, 182, 182)
	I.TextSize = 15
	I.ZIndex = 2
	local IN = Instance.new("TextBox", MF)
	IN.Name = ""
	IN.BackgroundTransparency = 1
	IN.Position = UDim2.new(0, 20, 0, 0)
	IN.Size = UDim2.new(1, -20, 1, 0)
	IN.Font = Enum.Font.Code
	IN.PlaceholderColor3 = Color3.fromRGB(188, 188, 188)
	IN.PlaceholderText = "cmd"
	IN.Text = ""
	IN.TextColor3 = Color3.fromRGB(236, 236, 236)
	IN.TextSize = 12
	IN.TextXAlignment = Enum.TextXAlignment.Left
	IN.ZIndex = 2
	local SL = Instance.new("TextLabel", MF)
	SL.Name = ""
	SL.BackgroundTransparency = 1
	SL.Position = UDim2.new(0, 20, 0, 0)
	SL.Size = UDim2.new(1, -20, 1, 0)
	SL.Font = Enum.Font.Code
	SL.Text = ""
	SL.TextColor3 = Color3.fromRGB(176, 176, 176)
	SL.TextSize = 12
	SL.TextXAlignment = Enum.TextXAlignment.Left
	SL.ZIndex = 2
	InertiaModule.GUI 						= {}
	InertiaModule.GUI.ScreenGui 			= SC
	InertiaModule.GUI.VisibilityFrame 		= VF
	InertiaModule.GUI.MainFrame 			= MF
	InertiaModule.GUI.Underline 			= UL
	InertiaModule.GUI.Indent				= I
	InertiaModule.GUI.InputBox				= IN
	InertiaModule.GUI.SuggestionLabel		= SL
	InertiaModule.VISIBLE 					= true
	InertiaModule.KEYBINDS					= {
		showhide 		= {Enum.KeyCode.LeftAlt, function() if InertiaModule.VISIBLE == false then InertiaModule:show() else InertiaModule:hide() end InertiaModule.VISIBLE = not InertiaModule.VISIBLE end},
		capturefocus 	= {Enum.KeyCode.RightAlt, InertiaModule.capturefocus},
	}
	InertiaModule.COMMANDS 					= {}
	InertiaModule.suggestion_lookthrough	= {InertiaModule.COMMANDS}
	pcall(addlistener, IN, "Text", updatesuggestion)
	IN.FocusLost:connect(handlefocuslost)
	IN.Focused:connect(handlefocused)
	userinput()
	return InertiaModule.GUI
end

function InertiaModule:bindkey(specifications)
	if specifications.name ~= nil and specifications.key ~= nil and specifications.bindfunction ~= nil and specifications.clearotherinputs ~= nil then
		if specifications.clearotherinputs then
			for index, element in pairs(InertiaModule.KEYBINDS) do
				if element[1] == specifications.key then
					InertiaModule.KEYBINDS[index] = nil
				end
			end
		end
		InertiaModule.KEYBINDS[specifications.name] = {specifications.key, specifications.bindfunction}
	end
end

function InertiaModule:addcommand(specifications)
	assert (InertiaModule.COMMANDS ~= nil, "inertia not loaded")
	if specifications.funcname ~= nil and specifications.func ~= nil then
		local funcnameexpression, funcexpression = type(specifications.funcname) == "string" and specifications.funcname or "nameless", type(specifications.func) == "function" and specifications.func or function() end
		InertiaModule.COMMANDS[funcnameexpression] = funcexpression
		InertiaModule.suggestion_lookthrough.COMMANDS = InertiaModule.COMMANDS
	end
end

return InertiaModule
