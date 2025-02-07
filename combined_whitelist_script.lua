-- Loadstring-compatible script for the whitelist system
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- Whitelist Module
local WhitelistModule = {}

local validUsers = {
    ["username1"] = "password1",
    ["username2"] = "password2",
    -- Add more username and password pairs as needed
}

local authenticatedUsers = {}

function WhitelistModule.isValidUser(username, password)
    return validUsers[username] == password
end

function WhitelistModule.addAuthenticatedUser(username)
    if not WhitelistModule.isUserAuthenticated(username) then
        table.insert(authenticatedUsers, username)
    end
end

function WhitelistModule.isUserAuthenticated(username)
    for _, user in ipairs(authenticatedUsers) do
        if user == username then
            return true
        end
    end
    return false
end

-- Server-side Authentication
local authenticateEvent = Instance.new("RemoteEvent")
authenticateEvent.Name = "AuthenticateEvent"
authenticateEvent.Parent = ReplicatedStorage

local function onAuthenticate(player, username, password)
    if WhitelistModule.isValidUser(username, password) then
        WhitelistModule.addAuthenticatedUser(username)
        authenticateEvent:FireClient(player, true) -- Authentication successful
    else
        authenticateEvent:FireClient(player, false) -- Authentication failed
    end
end

authenticateEvent.OnServerEvent:Connect(onAuthenticate)

-- Server-side Saving
local authenticatedUsersStore = DataStoreService:GetDataStore("AuthenticatedUsers")

local function onGameShutdown()
    authenticatedUsersStore:SetAsync("users", authenticatedUsers)
end

local function onGameStart()
    local savedUsers = authenticatedUsersStore:GetAsync("users")
    if savedUsers then
        for _, user in ipairs(savedUsers) do
            WhitelistModule.addAuthenticatedUser(user)
        end
    end
end

game:BindToClose(onGameShutdown)
onGameStart()

-- Client-side Input
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local usernameBox = Instance.new("TextBox")
usernameBox.Size = UDim2.new(0.3, 0, 0.05, 0)
usernameBox.Position = UDim2.new(0.35, 0, 0.4, 0)
usernameBox.PlaceholderText = "Enter Username"
usernameBox.Parent = screenGui

local passwordBox = Instance.new("TextBox")
passwordBox.Size = UDim2.new(0.3, 0, 0.05, 0)
passwordBox.Position = UDim2.new(0.35, 0, 0.5, 0)
passwordBox.PlaceholderText = "Enter Password"
passwordBox.Parent = screenGui

local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0.3, 0, 0.05, 0)
submitButton.Position = UDim2.new(0.35, 0, 0.6, 0)
submitButton.Text = "Submit"
submitButton.Parent = screenGui

local function onSubmitButtonClick()
    local username = usernameBox.Text
    local password = passwordBox.Text
    authenticateEvent:FireServer(username, password)
end

submitButton.MouseButton1Click:Connect(onSubmitButtonClick)

local function onAuthenticateResponse(isAuthenticated)
    if isAuthenticated then
        print("Authentication successful!")
        screenGui:Destroy()
    else
        print("Authentication failed!")
    end
end

authenticateEvent.OnClientEvent:Connect(onAuthenticateResponse)
