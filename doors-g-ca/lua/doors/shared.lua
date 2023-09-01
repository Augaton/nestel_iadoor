RemoteDoors = RemoteDoors or {}

function RemoteDoors.CanRemoteUnlockDoors(ply)
    return ply:Team() == TEAM_IA
end

function RemoteDoors.GetDoor(door)
    if RemoteDoors.IsDoor(door) then return door end
    if RemoteDoors.IsDoor(door:GetParent()) then return door:GetParent() end
    return nil
end

local doorClasses = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true
}

function RemoteDoors.IsDoor(ent)
    return IsValid(ent) and doorClasses[ent:GetClass()]
end