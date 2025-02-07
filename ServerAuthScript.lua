-- Server-side script for handling authentication
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WhitelistModule = require(ReplicatedStorage:WaitForChild("WhitelistModule"))

-- Remote event for receiving authentication requests
local authenticateEvent = Instance.new("RemoteEvent")
authenticateEvent.Name = "AuthenticateEvent"
authenticateEvent.Parent = ReplicatedStorage

-- Function to handle authentication requests
local function onAuthenticate(player, username, password)
    if WhitelistModule.isValidUser(username, password) then
        WhitelistModule.addAuthenticatedUser(username)
        authenticateEvent:FireClient(player, true) -- Authentication successful
    else
        authenticateEvent:FireClient(player, false) -- Authentication failed
    end
end

-- Connect the function to the remote event
authenticateEvent.OnServerEvent:Connect(onAuthenticate)
