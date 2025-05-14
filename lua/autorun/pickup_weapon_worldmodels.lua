
-- todo, will mark with done if its, well... done.
-- players on servers could activate the sv_pickup_weapon_models  convar on and off if they want, that sounds cool -- not done
-- make physgun world model (its a skin bodygroup for gravity gun) give physgun -- DONE! i think


local WEAPON_MODELS = {
    ["models/weapons/w_stunbaton.mdl"] = "weapon_stunstick",
    ["models/weapons/w_crowbar.mdl"] = "weapon_crowbar",
    ["models/weapons/w_physics.mdl"] = function(ent) 
        return ent:GetSkin() == 1 and "weapon_physgun" or "weapon_physcannon"  
    end,
    ["models/weapons/w_357.mdl"] = "weapon_357",
    ["models/weapons/w_pistol.mdl"] = "weapon_pistol",
    ["models/weapons/w_irifle.mdl"] = "weapon_ar2",
    ["models/weapons/w_smg1.mdl"] = "weapon_smg1",
    ["models/weapons/w_crossbow.mdl"] = "weapon_crossbow",
    ["models/weapons/w_shotgun.mdl"] = "weapon_shotgun",
    ["models/weapons/w_rocket_launcher.mdl"] = "weapon_rpg",
    ["models/weapons/w_grenade.mdl"] = "weapon_frag",
    ["models/weapons/w_slam.mdl"] = "weapon_slam",
    ["models/weapons/w_bugbait.mdl"] = "weapon_bugbait",
    ["models/weapons/w_toolgun.mdl"] = "gmod_tool",
    ["models/weapons/w_medkit.mdl"] = "weapon_medkit",
    ["models/maxofs2d/camera.mdl"] = "gmod_camera"
}

CreateConVar("sv_pickup_weapon_models", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "Enable/disable picking up weapon models")

hook.Add("PlayerUse", "pickupWeaponModels", function(ply, ent)
    if not GetConVar("sv_pickup_weapon_models"):GetBool() then return end
    if not IsValid(ent) then return end
    
    local model = ent:GetModel()
    if not model then return end
    
    local weaponClass = WEAPON_MODELS[model]
    
    if isfunction(weaponClass) then
        weaponClass = weaponClass(ent)
    end
    
    if weaponClass then
        if ply:HasWeapon(weaponClass) then
            return false
        end
        ply:Give(weaponClass)
        ply:EmitSound("common/wpn_select.wav") 
        ply:EmitSound("items/ammo_pickup.wav") 
        ent:Remove()
        return false 
    end
end)