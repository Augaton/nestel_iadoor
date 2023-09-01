
hook.Add("PlayerBindPress", "open_door", function(ply, bind, pressed)
    if not (RemoteDoors.CanRemoteUnlockDoors(ply) and pressed) then return end
    if string.find(bind, "+use") or string.find(bind, "+reload") then

        local target = RemoteDoors.GetDoor(ply:GetEyeTrace().Entity)
        if target == nil then return end

        local isUse, _ = string.find(bind, "+use")
        net.Start("remote_doors")
            net.WriteBit(isUse and 1 or 0)
            net.WriteEntity(target)
        net.SendToServer() 
    end
end)