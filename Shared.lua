Shared = {
  Enabled = true, -- set this to false if you don't want to enable this function (block triggers, CLIENT & Server)
  CustomBANSystem = false, -- Enable this if you're using an external anticheat, like Fiveguard, etc.
  BlockNUIDevTools = true, -- This function checks if the player is trying to open the NUI Dev Tools to see the NUI Code or something similar
  AntiSilentAIM = true, -- Experimental, testing. Blocks& tries to detect if user is using Silent AIM. (Code from: axdevelopment)
  AntiRapePlayer = true, -- Testing. If this enabled, will enable the Protection of Raped Players.
  Admins = {
    "steam:9234u9n49394",
    "discord:"
  },
  BANPlayer = function(banData)
    -- Add Here the code to ban the player.
    -- banData Variable returns the next data
    -- Array
    --  - identifiers = Array
    --     - steam
    --     - xbox
    --     - license
    --     - discord
    --     - ip
    --  - expiry = UNIX Timestamp String
    --  - reason = string
  end,
  ClientTriggers = {}, -- Add here the client side Triggers names to block
  ServerTriggers = {}, -- Add here the server side Triggers names to block
}
