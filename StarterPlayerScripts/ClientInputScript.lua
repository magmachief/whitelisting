-- Client-side script for user input
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local authenticateEvent = ReplicatedStorage:WaitForChild("AuthenticateEvent")

-- Create the GUI for username and password input
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

-- Function to handle the submit button click
local function onSubmitButtonClick()
    local username = usernameBox.Text
    local password = passwordBox.Text
    authenticateEvent:FireServer(username, password)
end

submitButton.MouseButton1Click:Connect(onSubmitButtonClick)

-- Function to handle authentication response from the server
local function onAuthenticateResponse(isAuthenticated)
    if isAuthenticated then
        print("Authentication successful!")
        screenGui:Destroy()
    else
        print("Authentication failed!")
    end
end

authenticateEvent.OnClientEvent:Connect(onAuthenticateResponse)
