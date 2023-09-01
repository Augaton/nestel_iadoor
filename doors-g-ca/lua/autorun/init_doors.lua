
if SERVER then
    include("doors/shared.lua")
    include("doors/server.lua")
    AddCSLuaFile("doors/shared.lua")
    AddCSLuaFile("doors/client.lua")
else
    include("doors/shared.lua")
    include("doors/client.lua")
end