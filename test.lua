inert = loadstring(game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/DevSp4c3/inertiamodule/main/main.lua"))()
a = inert:initialize()
a.ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui
inert:addcommand({
	funcname = "noclip",
	func = function() wait(1) inert:colorunderline({
		color = Color3.fromRGB(255, 255, 127)
	}) end
})

inert:colorunderline({
	color = Color3.fromRGB(170, 0, 0),
	style = "sine"
})
