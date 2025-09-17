--========================================================--
--  XaaScriptHub Loader
--========================================================--

pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/wifilooknew-coder/XaaHub-Fiture/main/XaaHUB.lua"))()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "XaaScriptHub",
        Text = "Loaded Successfully ✅",
        Duration = 5
    })
end)
