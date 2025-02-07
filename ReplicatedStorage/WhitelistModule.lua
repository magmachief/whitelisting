-- Module script for managing the whitelist
local WhitelistModule = {}

-- Table to store the valid username and password pairs
local validUsers = {
    ["username1"] = "password1",
    ["username2"] = "password2",
    -- Add more username and password pairs as needed
}

-- Table to store the users who have successfully authenticated
local authenticatedUsers = {}

-- Function to check if the provided username and password are valid
function WhitelistModule.isValidUser(username, password)
    return validUsers[username] == password
end

-- Function to add a user to the authenticated users list
function WhitelistModule.addAuthenticatedUser(username)
    if not WhitelistModule.isUserAuthenticated(username) then
        table.insert(authenticatedUsers, username)
    end
end

-- Function to check if a user is already authenticated
function WhitelistModule.isUserAuthenticated(username)
    for _, user in ipairs(authenticatedUsers) do
        if user == username then
            return true
        end
    end
    return false
end

return WhitelistModule
