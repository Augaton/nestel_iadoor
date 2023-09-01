
util.AddNetworkString("remote_doors")

local function getDoorsInRange(target)
    local doors, foundEnts = {}, ents.FindInSphere(target:GetPos(), 120)
    for _, v in ipairs(foundEnts) do
        
        v = RemoteDoors.GetDoor(v)

        if v then table.insert(doors, v) end
    end
    return doors
end

local function isDoorLocked(target)
    return target:GetInternalVariable("m_bLocked")
end

local function getDoorState(target)
	local targetclass = target:GetClass()
	if (targetclass == "func_door" or targetclass == "func_door_rotating") then
		return target:GetInternalVariable("m_toggle_state") == 0
	elseif (targetclass == "prop_door_rotating") then
		return target:GetInternalVariable("m_eDoorState") ~= 0
	else
		return false
	end
end

net.Receive("remote_doors", function(_, ply)
    if not RemoteDoors.CanRemoteUnlockDoors(ply) then return end    
    local isOpenClose = net.ReadBit() == 1


    local target = net.ReadEntity()
    if not RemoteDoors.IsDoor(target) then return end
    local isOpen = getDoorState(target)

    local trace = util.TraceLine({
        ["start"] = ply:GetPos(),
        ["filter"] = ply,
        ["endpos"] = target:GetPos()
    })

    if isOpen then

        if trace.HitPos:Distance(target:GetPos()) > 60 then return end
    else
        
        if not (trace.Entity and trace.Entity:GetParent() == target) then return end
    end

    local doors, fires = getDoorsInRange(target), {}
    if isOpenClose then
        
        if isOpen then fires = {"close"}
        else fires = {"unlock", "open"} end
    else
        
        fires = {isDoorLocked(target) and "unlock" or "lock"}
        ply:PrintMessage(HUD_PRINTTALK, (fires[1] == "lock" and "Locked" or "Unlocked") .. " the door ahead.")
    end

    for _, v in ipairs(doors) do
        for __, s in ipairs(fires) do
            v:Fire(s)
        end
    end
end)