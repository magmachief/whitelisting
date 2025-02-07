-- Server-side script for saving authenticated users
local DataStoreService = game:GetService("DataStoreService")
local authenticatedUsersStore = DataStoreService:GetDataStore("AuthenticatedUsers")

local WhitelistModule = require(game.ReplicatedStorage:WaitForChild("WhitelistModule"))

-- Function to save authenticated users when the game shuts down
local function onGameShutdown()
    authenticatedUsersStore:SetAsync("users", WhitelistModule.authenticatedUsers)
end

-- Function to load authenticated users when the game starts
local function onGameStart()
    local savedUsers = authenticatedUsersStore:GetAsync("users")
    if savedUsers then
        for _, user in ipairs(savedUsers) do
            WhitelistModule.addAuthenticatedUser(user)
        end
    end
end

-- Connect the functions to the appropriate events
game:BindToClose(onGameShutdown)
onGameStart()
