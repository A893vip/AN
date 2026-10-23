

-- ==========================================
-- AK_Features
-- ==========================================
_G.AK_Features = {
    { id="ESP_HP", val=0 }, { id="ESP_NAME", val=0 }, { id="ESP_DISTANCE", val=0 },
    { id="ESP_ANTENNA", val=0 }, { id="ESP_RADAR", val=0 },
    { id="COUNT_ENEMY", val=0 }, { id="ENEMY_WEAPON", val=0 },
    { id="WALLHACK", val=0 },
    { id="OUTLINE_ESP", val=0 }, { id="OUTLINE_COLOR", val=4 }, { id="OUTLINE_THICK", val=5 },
    { id="ITEMS_MASTER", val=0 },
    { id="ITEM_AR", val=0 }, { id="ITEM_SMG", val=0 }, { id="ITEM_SNIPER", val=0 },
    { id="ITEM_SHOTGUN", val=0 }, { id="ITEM_LMG", val=0 }, { id="ITEM_PISTOL", val=0 },
    { id="ITEM_MELEE", val=0 }, { id="ITEM_SPECIAL", val=0 }, { id="ITEM_SCOPE", val=0 },
    { id="ITEM_GRENADE", val=0 }, { id="ITEM_MED", val=0 },
    { id="VEH_MASTER", val=0 },
    { id="VEH_DACIA", val=0 }, { id="VEH_UAZ", val=0 }, { id="VEH_BUGGY", val=0 },
    { id="VEH_COUPE", val=0 }, { id="VEH_MIRADO", val=0 }, { id="VEH_MOTOR", val=0 },
    { id="VEH_BRDM", val=0 }, { id="VEH_BOAT", val=0 }, { id="VEH_OTHER", val=0 },
    { id="WALL_VEHICLE", val=0 },
    { id="AIMBOT", val=0 }, { id="AIMBOT_MODE", val=3 },
    { id="AIMBOT_FOV", val=100 }, { id="AIMBOT_SPEED", val=100 },
    { id="AIMBOT_BONE", val=1 }, { id="AIMBOT_DIST", val=250 },
    { id="RECOIL_COMP", val=0 }, { id="RECOIL_VAL", val=5 },
    { id="AIMBOT_IGNORE_BOT", val=1 }, { id="AIMBOT_IGNORE_KNOCK", val=1 },
    { id="AIMBOT_VIS_CHECK", val=0 }, { id="AIMBOT_ALWAYS_ON", val=1 },
    { id="ESP_LOAI9", val=0 }, { id="ESP9_COUNT", val=0 }, { id="ESP9_NAME", val=0 },
    { id="ESP9_HP", val=0 }, { id="ESP9_TEAM", val=0 }, { id="ESP9_WEAPON", val=0 },
    { id="ESP9_DISTANCE", val=0 }, { id="ESP9_LINE", val=0 }, { id="ESP9_SKELETON", val=0 },
    { id="CROSSHAIR", val=0 }, { id="BLACK_SKY", val=0 },
    { id="REMOVE_GRASS", val=0 }, { id="REMOVE_TREES", val=0 }, { id="REMOVE_FOG", val=0 },
    { id="IPAD_VIEW", val=0 }, { id="IPAD_FOV", val=120 },
}

local _AK_Lookup = {}
for _, f in ipairs(_G.AK_Features) do _AK_Lookup[f.id] = f end

function _G.AK_GetVal(id)
    local f = _AK_Lookup[id]
    return f and f.val or 0
end

local _ReqCache = {}
local function CR(name)
    local m = _ReqCache[name]
    if m ~= nil then return m ~= false and m or nil end
    local ok, mod = pcall(require, name)
    _ReqCache[name] = ok and mod or false
    return ok and mod or nil
end

local _CachedV2D = nil
local _CachedUU  = nil
local function GetV2D()
    if not _CachedV2D then pcall(function() _CachedV2D = import("Vector2D") end) end
    return _CachedV2D
end
local function GetUU()
    if not _CachedUU then _CachedUU = CR("client.common.ui_util") end
    return _CachedUU
end

local _tickerCached = nil
local function GetTicker()
    if _tickerCached then return _tickerCached end
    local ok, t = pcall(require, "common.time_ticker")
    _tickerCached = ok and t or nil
    return _tickerCached
end

_G.GetConfigPath = function()
    local pkgs = { "com.tencent.ig", "com.pubg.krmobile", "com.vng.pubgmobile", "com.rekoo.pubgm", "com.pubg.imobile", "com.tencent.igfit" }
    for _, p in ipairs(pkgs) do
        local fp = "/storage/emulated/0/Android/data/" .. p .. "/files/reload.flag"
        local ff = io.open(fp, "r")
        if ff then
            ff:close()
            local path = "/storage/emulated/0/Android/data/" .. p .. "/files/SKIN_OP_MENU.ini"
            local f = io.open(path, "r")
            if f then f:close(); return path end
        end
    end
    for _, p in ipairs(pkgs) do
        local path = "/storage/emulated/0/Android/data/" .. p .. "/files/SKIN_OP_MENU.ini"
        local f = io.open(path, "r")
        if f then f:close(); return path end
    end
    return '/storage/emulated/0/Android/data/com.tencent.ig/files/SKIN_OP_MENU.ini'
end
_G.ConfigFilePath = _G.GetConfigPath()

_G.g_Fire4flas = _G.g_Fire4flas or "@Fire4flas"

_G.g_Fire4flas_MasterShotESP = _G.g_Fire4flas_MasterShotESP or {
    Enabled = false, ShowCounter = false, ShowName = false, ShowDistance = false,
    ShowHP = false, ShowLine = true, ShowSkeleton = false,
    MaxRangeMeters = 400.0, ScanInterval = 0.55, UpdateInterval = 0.033, TransformInterval = 0.50,
    MaxRendered = 24, CounterY = 36.0, CounterWidth = 188.0, CounterHeight = 26.0,
    CounterDiamondSize = 20.0, TracerThickness = 1.80,
    NameGap = 2.0, NameFontSize = 10, DistanceFontSize = 8, DistanceBelowFeet = 8.0,
    LineThickness = 2.0,
    PremiumCount = true,
    HPBarHeight = 5.0,
}
_G.MasterShotESP = _G.g_Fire4flas_MasterShotESP
_G.LexusConfig = _G.LexusConfig or {}
_G.LexusState = _G.LexusState or {}
_G.LexusState.CustomTextData = _G.LexusState.CustomTextData or { IpadViewFOV = 120 }

function _G.SyncLexusConfig()
    if not _G.g_Fire4flas_MasterShotESP then return end
    local mainEspOn = (_G.AK_GetVal("ESP_LOAI9") == 1)
    _G.g_Fire4flas_MasterShotESP.Enabled      = mainEspOn
    _G.g_Fire4flas_MasterShotESP.ShowCounter  = (_G.AK_GetVal("ESP9_COUNT") == 1)
    _G.g_Fire4flas_MasterShotESP.ShowName     = (_G.AK_GetVal("ESP9_NAME") == 1)
    _G.g_Fire4flas_MasterShotESP.ShowDistance = (_G.AK_GetVal("ESP9_DISTANCE") == 1)
    _G.g_Fire4flas_MasterShotESP.ShowHP       = (_G.AK_GetVal("ESP9_HP") == 1)
    _G.g_Fire4flas_MasterShotESP.ShowSkeleton = (_G.AK_GetVal("ESP9_SKELETON") == 1)
    _G.g_Fire4flas_MasterShotESP.ShowLine     = mainEspOn
    local forceOldEspOff = _G.g_Fire4flas_MasterShotESP.Enabled
    _G.LexusConfig.EnemyWeapon  = (_G.AK_GetVal("ENEMY_WEAPON") == 1)
    if forceOldEspOff then _G.LexusConfig.EnemyWeapon = false end
    _G.LexusConfig.OutlineEsp   = (_G.AK_GetVal("OUTLINE_ESP") == 1)
    _G.LexusConfig.OutlineColor = _G.AK_GetVal("OUTLINE_COLOR")
    _G.LexusConfig.OutlineThick = _G.AK_GetVal("OUTLINE_THICK")
    _G.LexusConfig.ItemsMaster = (_G.AK_GetVal("ITEMS_MASTER") == 1)
    _G.LexusConfig.ItemAR      = (_G.AK_GetVal("ITEM_AR") == 1)
    _G.LexusConfig.ItemSMG     = (_G.AK_GetVal("ITEM_SMG") == 1)
    _G.LexusConfig.ItemSniper  = (_G.AK_GetVal("ITEM_SNIPER") == 1)
    _G.LexusConfig.ItemShotgun = (_G.AK_GetVal("ITEM_SHOTGUN") == 1)
    _G.LexusConfig.ItemLMG     = (_G.AK_GetVal("ITEM_LMG") == 1)
    _G.LexusConfig.ItemPistol  = (_G.AK_GetVal("ITEM_PISTOL") == 1)
    _G.LexusConfig.ItemMelee   = (_G.AK_GetVal("ITEM_MELEE") == 1)
    _G.LexusConfig.ItemSpecial = (_G.AK_GetVal("ITEM_SPECIAL") == 1)
    _G.LexusConfig.ItemScope   = (_G.AK_GetVal("ITEM_SCOPE") == 1)
    _G.LexusConfig.ItemGrenade = (_G.AK_GetVal("ITEM_GRENADE") == 1)
    _G.LexusConfig.ItemMed     = (_G.AK_GetVal("ITEM_MED") == 1)
    _G.LexusConfig.VehMaster   = (_G.AK_GetVal("VEH_MASTER") == 1)
    _G.LexusConfig.VehDacia    = (_G.AK_GetVal("VEH_DACIA") == 1)
    _G.LexusConfig.VehUAZ      = (_G.AK_GetVal("VEH_UAZ") == 1)
    _G.LexusConfig.VehBuggy    = (_G.AK_GetVal("VEH_BUGGY") == 1)
    _G.LexusConfig.VehCoupe    = (_G.AK_GetVal("VEH_COUPE") == 1)
    _G.LexusConfig.VehMirado   = (_G.AK_GetVal("VEH_MIRADO") == 1)
    _G.LexusConfig.VehMotor    = (_G.AK_GetVal("VEH_MOTOR") == 1)
    _G.LexusConfig.VehBRDM     = (_G.AK_GetVal("VEH_BRDM") == 1)
    _G.LexusConfig.VehBoat     = (_G.AK_GetVal("VEH_BOAT") == 1)
    _G.LexusConfig.VehOther    = (_G.AK_GetVal("VEH_OTHER") == 1)
    _G.LexusConfig.WallVehicle = (_G.AK_GetVal("WALL_VEHICLE") == 1)
    _G.LexusConfig.RemoveGrass = (_G.AK_GetVal("REMOVE_GRASS") == 1)
    _G.LexusConfig.RemoveTrees = (_G.AK_GetVal("REMOVE_TREES") == 1)
    _G.LexusConfig.RemoveFog   = (_G.AK_GetVal("REMOVE_FOG") == 1)

    _G.LexusConfig.FlashSpeed    = false
    _G.LexusConfig.FlashSpeedVal = 5

    _G.LexusConfig.IpadView = (_G.AK_GetVal("IPAD_VIEW") == 1)
    _G.LexusState = _G.LexusState or {}
    _G.LexusState.CustomTextData = _G.LexusState.CustomTextData or {}
    _G.LexusState.CustomTextData.IpadViewFOV = _G.AK_GetVal("IPAD_FOV") or 120
end

_G._AK_LastMTime = 0
_G._AK_LastCheck = 0

local function GetFileMTime(path)
    local f = io.open(path, "r")
    if not f then return 0 end
    local ok, mt = pcall(function() local lfs = package.loaded["lfs"] or require("lfs") if lfs then return lfs.attributes(path, "modification") or 0 end return 0 end)
    f:close()
    if ok and mt and mt > 0 then return mt end
    local f2 = io.open(path, "r")
    if f2 then local c = f2:read("*a"); f2:close(); return #(c or "") end
    return 0
end

function _G.AK_LoadINI(force)
    local path = _G.GetConfigPath()
    local file = io.open(path, "r")
    if not file then return false end
    local changed = false
    for line in file:lines() do
        local k, v = line:match('^([%w_]+)%s*=%s*(%d+)$')
        if k and v then
            local val = tonumber(v)
            if val ~= nil then
                local f = _AK_Lookup[k]
                if f then
                    if f.val ~= val or force then f.val = val; changed = true end
                end
            end
        end
    end
    file:close()
    if changed or force then if _G.SyncLexusConfig then pcall(_G.SyncLexusConfig) end end
    return changed
end

function _G.AK_CheckINIReload()
    local now = os.clock()
    if now - _G._AK_LastCheck < 1.0 then return end
    _G._AK_LastCheck = now
    local cp = _G.GetConfigPath()
    local gd = cp:match("^(.*)/files/")
    if not gd then return end
    local rf = io.open(gd .. "/files/reload.flag", "r")
    if rf then
        rf:close()
        _G.AK_LoadINI(true)
        pcall(function() local d = io.open(gd .. "/files/reload.flag", "w") if d then d:write("0"); d:close() end end)
        pcall(function() os.remove(gd .. "/files/reload.flag") end)
        return
    end
    local mt = GetFileMTime(cp)
    if mt ~= _G._AK_LastMTime and _G._AK_LastMTime ~= 0 then _G.AK_LoadINI(true) end
    _G._AK_LastMTime = mt
end

-- ==========================================
-- Imports
-- ==========================================
local ENetRole = import("ENetRole")
local EPawnState = import("EPawnState")
local ESpecialMovementType = import("ESpecialMovementType")
local ESpiderSwingMoveState = import("ESpiderSwingMoveState")
local ESurviveWeaponPropSlot = import("ESurviveWeaponPropSlot")
local EParachuteState = import("EParachuteState")
local EMovementMode = import("EMovementMode")
local EStateType = import("EStateType")
local ESTEPoseState = import("ESTEPoseState")
local EGameModeType = import("EGameModeType")
local STExtraGameStateBase = import("STExtraGameStateBase")
local UKismetSystemLibrary = import("KismetSystemLibrary")
local USTExtraBlueprintFunctionLibrary = import("STExtraBlueprintFunctionLibrary")
local GameplayData = require("GameLua.GameCore.Data.GameplayData")
local GamePlayTools = require("GameLua.Mod.BaseMod.Common.GamePlayTools")
local MatchModeIds = require("GameLua.Mod.BaseMod.GamePlay.Config.MatchModeIdsConfig")

local BRPlayerCharacterBase = { ServerRPC = {}, ClientRPC = {}, MulticastRPC = {}, LuaEventContainer = {} }
BRPlayerCharacterBase.ServerRPC.ServerRPC_NearDeathGiveupRescue = { Reliable = true, Params = {} }
BRPlayerCharacterBase.ServerRPC.ServerRPC_CarryDeadBox = { Reliable = true, Params = { UEnums.EPropertyClass.Object } }
BRPlayerCharacterBase.ServerRPC.RPC_Server_GmPlayAction = { Reliable = true, Params = { UEnums.EPropertyClass.Int } }
BRPlayerCharacterBase.MulticastRPC.MulticastRPC_GmPlayAction = { Reliable = true, Params = { UEnums.EPropertyClass.Int } }
BRPlayerCharacterBase.ClientRPC.RPC_Client_SetShouldCheckPassWall = { Reliable = true, Params = { UEnums.EPropertyClass.Bool } }
BRPlayerCharacterBase.ClientRPC.ClientRPC_TriggerHighlightMoment = { Reliable = true, Params = { UEnums.EPropertyClass.UInt32, UEnums.EPropertyClass.UInt32 } }

function BRPlayerCharacterBase:ctor() end
function BRPlayerCharacterBase:_PostConstruct()
    BRPlayerCharacterBase.__super._PostConstruct(self)
    self:InitAddSpecialMoveInfo()
    self.bCanNearDeathGiveup = true
end
function BRPlayerCharacterBase:ReceiveBeginPlay()
    BRPlayerCharacterBase.__super.ReceiveBeginPlay(self)
    self:AddControlEvent(self, "MovementModeChangedDelegate", self.HandleOnMovementModeChangedNew, self)
    if self:HasAuthority() and self:CheckAddCheckFallingDistanceComponent() then
        local C = import("CheckFallingDistanceComponent")
        if slua.isValid(C) and not slua.isValid(self:GetComponentByClass(C)) then Game:AddComponent(C, self, "CheckFallingDistanceComponent") end
    end
    if slua.isValid(self.STCharacterMovement) then self.STCharacterMovement.bPositiveBlowUp = true end
    if self.Role == ENetRole.ROLE_AutonomousProxy then
        self:AddControlEvent(self, "OnPawnStateDisabled", self.OnPawnStateChange, self)
        self:AddControlEvent(self, "OnPawnStateEnabled", self.OnPawnStateChange, self)
        self:AddControlEventConditionOnly(self, "OnAttrChangeEventDelegate", { AttrName = { "bCanSelfRescue" } }, self.CharacterAttrChangeEvent, self)
    end
    if Client then
        GameplayData.AddCharacter(self.Object)
        self:AddControlEvent(self, "OnAttachedToVehicle", self.HandleOnAttachedToVehicle, self)
        self:AddControlEvent(self, "OnDetachedFromVehicle", self.HandleOnDetachedFromVehicle, self)
    else
        self:AddCommonEventWithConditions(EVENTTYPE_INGAME_NORMAL, EVENTID_GAME_MODE_STATE_CHANGE, { [1] = "FinishedState" }, self.HandleFinishedState, self)
    end
end
function BRPlayerCharacterBase:HandleOnAttachedToVehicle(v)
    if not slua.isValid(v) then return end
    if self.Role == ENetRole.ROLE_SimulatedProxy then
        self:ClearAttachToVehicleTimer()
        self.nUpdatePlayerAttachToVehicleCount = 0
        self.nUpdatePlayerAttachToVehicleTimer = self:AddGameTimer(5, true, function()
            if slua.isValid(self.Object) and slua.isValid(v) then self:UpdatePlayerAttachToVehicle(v) end
        end)
    end
end
function BRPlayerCharacterBase:HandleOnDetachedFromVehicle(v)
    if not slua.isValid(v) then return end
    if self.Role == ENetRole.ROLE_SimulatedProxy then
        self:ClearAttachToVehicleTimer()
        self.nUpdatePlayerAttachToVehicleCount = 0
    end
end
function BRPlayerCharacterBase:UpdatePlayerAttachToVehicle(v) end
function BRPlayerCharacterBase:FixMeshContainerOffsetIfNeeded(v) end
function BRPlayerCharacterBase:ClearAttachToVehicleTimer()
    if self.nUpdatePlayerAttachToVehicleTimer then self:RemoveGameTimer(self.nUpdatePlayerAttachToVehicleTimer); self.nUpdatePlayerAttachToVehicleTimer = nil end
    if self.nFixMeshContainerTimer then self:RemoveGameTimer(self.nFixMeshContainerTimer); self.nFixMeshContainerTimer = nil end
end
function BRPlayerCharacterBase:CharacterAttrChangeEvent(uPawn, AttrName, AttrVal)
    BRPlayerCharacterBase.__super.CharacterAttrChangeEvent(self, uPawn, AttrName, AttrVal)
    if self.Object ~= uPawn then return end
    if self.Role == ENetRole.ROLE_AutonomousProxy and AttrName == "bCanSelfRescue" then
        local pc = self:GetPlayerControllerSafety()
        if slua.isValid(pc) then pc:BroadcastUIMessage("UIMsg_CanSelfRescue", 0, "", "") end
    end
end
function BRPlayerCharacterBase:OnPawnStateChange(s)
    if s == EPawnState.SwitchPP then
        local pc = self:GetPlayerControllerSafety()
        if slua.isValid(pc) then pc:BroadcastUIMessage("UIMsg_FPPModeChange", 0, "", "") end
    end
end
function BRPlayerCharacterBase:HandleFinishedState()
    if slua.isValid(self.STCharacterMovement) and self.STCharacterMovement.SetDynamicSimpleQueryConfig then
        self.STCharacterMovement:SetDynamicSimpleQueryConfig(false)
    end
end
function BRPlayerCharacterBase:CheckAddCheckFallingDistanceComponent() return false end
function BRPlayerCharacterBase:LuaHandleParachuteStateChanged(a, b) end
function BRPlayerCharacterBase:OnLanded() end
function BRPlayerCharacterBase:ReceiveEndPlay(r)
    BRPlayerCharacterBase.__super.ReceiveEndPlay(self, r)
    if Client then GameplayData.RemoveCharacter(self.Object) end
end
function BRPlayerCharacterBase:IsWarGameMode() return false end
function BRPlayerCharacterBase:BPOnRecycled() if Client then self:ResetMeshRelativeLocationAndRotation() end end
function BRPlayerCharacterBase:BPOnRespawned() if Client then self:ResetMeshRelativeLocationAndRotation() end end
function BRPlayerCharacterBase:ReceiveOnRecycle() if Client then self:ResetMeshRelativeLocationAndRotation(); GameplayData.RemoveCharacter(self.Object) end end
function BRPlayerCharacterBase:ReceiveOnSpawn() if Client then self:ResetMeshRelativeLocationAndRotation(); GameplayData.AddCharacter(self.Object) end end
function BRPlayerCharacterBase:ResetMeshRelativeLocationAndRotation()
    if Game:IsValid(self.Object) and Game:IsValid(self.Mesh) then
        local r = FRotator(0, -90, 0); local l = FVector(0, 0, 0)
        if self.Mesh.K2_SetRelativeRotation then self.Mesh:K2_SetRelativeRotation(r, false, nil, false) end
        self:CacheInitialMeshOffset(l, r)
    end
end
function BRPlayerCharacterBase:HandleOnMovementModeChangedNew()
    if Game:IsValid(self.STCharacterMovement) and self.STCharacterMovement.MovementMode == EMovementMode.MOVE_Swimming and self:CheckBaseIsMoveable() then
        self.CharacterMovement:SetBase(nil, "", true)
    end
    if self.Role == ENetRole.ROLE_AutonomousProxy and Game:IsValid(self.STCharacterMovement) and self.STCharacterMovement.MovementMode == EMovementMode.MOVE_Walking and UIManager.UI_Config_InGame.ParachuteOpenUI then
        UIManager.CloseUI(UIManager.UI_Config_InGame.ParachuteOpenUI)
    end
end
function BRPlayerCharacterBase:BPOnMissPlayerDamageRecord() end

-- ==========================================
-- HELPERS
-- ==========================================
local function Valid(o)
    if not o then return false end
    if slua and slua.isValid then
        local ok, v = pcall(slua.isValid, o)
        if not ok or not v then return false end
    end
    return true
end
local function GetHealthColor(p)
    if p > 60 then return {R=0,G=255,B=0,A=255}
    elseif p > 30 then return {R=255,G=255,B=0,A=255}
    else return {R=255,G=0,B=0,A=255} end
end
local function GetSafeEnemyKey(e)
    if Valid(e) then
        if e.PlayerKey then return tostring(e.PlayerKey) end
        if type(e.GetUniqueID) == "function" then return tostring(e:GetUniqueID()) end
    end
    return tostring(e)
end

local OUTLINE_COLORS = {
    [1]={R=255,G=0,B=0,A=255,fR=1.0,fG=0.0,fB=0.0},
    [2]={R=0,G=255,B=0,A=255,fR=0.0,fG=1.0,fB=0.0},
    [3]={R=0,G=100,B=255,A=255,fR=0.0,fG=0.4,fB=1.0},
    [4]={R=255,G=255,B=0,A=255,fR=1.0,fG=1.0,fB=0.0},
    [5]={R=255,G=0,B=255,A=255,fR=1.0,fG=0.0,fB=1.0},
    [6]={R=255,G=255,B=255,A=255,fR=1.0,fG=1.0,fB=1.0},
}
local function GetOutlineColor()
    local i = _G.AK_GetVal("OUTLINE_COLOR")
    if i < 1 then i = 1 end
    if i > 6 then i = 6 end
    return OUTLINE_COLORS[i], i
end

local SCALE_COLOR_V2 = {R=3, G=3, B=0, A=0}

local function GetAllSkeletalMeshes(enemy, md)
    if md.MeshCache and md.MeshCacheTime and (os.clock() - md.MeshCacheTime) < 5.0 then return md.MeshCache end
    local m = {}
    if enemy.Mesh and slua.isValid(enemy.Mesh) then table.insert(m, enemy.Mesh) end
    pcall(function()
        local SMC = import("SkeletalMeshComponent")
        if SMC and type(enemy.GetComponentsByClass) == "function" then
            local c = enemy:GetComponentsByClass(SMC)
            if c then
                local n = type(c.Num) == "function" and c:Num() or #c
                for i = 1, n do
                    local cmp = type(c.Get) == "function" and c:Get(i-1) or c[i]
                    if cmp and slua.isValid(cmp) and cmp ~= enemy.Mesh then table.insert(m, cmp) end
                end
            end
        end
    end)
    md.MeshCache = m
    md.MeshCacheTime = os.clock()
    return m
end

local function Undowallhackng(enemy, md)
    pcall(function()
        if md.WallhackApplied then
            for _, mesh in ipairs(GetAllSkeletalMeshes(enemy, md)) do
                if mesh and slua.isValid(mesh) then
                    pcall(function() if type(mesh.SetRenderCustomDepth) == "function" then mesh:SetRenderCustomDepth(false) end end)
                end
            end
            md.WallhackApplied = false
        end
    end)
end

local function Applywallhackng(enemy, md)
    pcall(function()
        for _, mesh in ipairs(GetAllSkeletalMeshes(enemy, md)) do
            if mesh and slua.isValid(mesh) then
                pcall(function()
                    if type(mesh.SetRenderCustomDepth) == "function" then mesh:SetRenderCustomDepth(true) end
                    if type(mesh.SetCustomDepthStencilValue) == "function" then mesh:SetCustomDepthStencilValue(252) end
                    if mesh.bRenderCustomDepth ~= nil then mesh.bRenderCustomDepth = true end
                    if mesh.CustomDepthStencilValue ~= nil then mesh.CustomDepthStencilValue = 252 end
                end)
            end
        end
        md.WallhackApplied = true
    end)
end

local function ApplyColorBodyV2(enemy, pc, md)
    pcall(function()
        if _G.AK_GetVal("WALLHACK") ~= 1 then return end
        local meshes = GetAllSkeletalMeshes(enemy, md)
        if #meshes == 0 then return end
        local t = os.clock()
        if md.LastVisCheckTime == nil or (t - md.LastVisCheckTime) > 0.5 then
            md.LastVisCheckTime = t
            local hidden = true
            pcall(function() if pc and slua.isValid(pc) and type(pc.LineOfSightTo) == "function" then hidden = not pc:LineOfSightTo(enemy) end end)
            md.CachedHiddenState = hidden
        end
        local hidden = md.CachedHiddenState
        if hidden == nil then hidden = true end
        local vis = {R=0,G=255,B=0,A=255}
        local inv = {R=255,G=0,B=0,A=255}
        local final = hidden and inv or vis
        local hash = string.format("%d_%d_%d_%d", final.R, final.G, final.B, final.A)
        if md.LastHiddenState == hidden and md.LastColorHash == hash and md.DepthTestApplied == true then return end
        md.LastHiddenState = hidden; md.LastColorHash = hash; md.ColorApplied = true; md.DepthTestApplied = true
        for mi, mesh in ipairs(meshes) do
            if mesh and slua.isValid(mesh) then
                pcall(function()
                    if type(mesh.SetRenderCustomDepth) == "function" then mesh:SetRenderCustomDepth(true) end
                    if type(mesh.SetCustomDepthStencilValue) == "function" then mesh:SetCustomDepthStencilValue(252) end
                end)
                for i = 0, 10 do
                    local mt = mesh:GetMaterial(i)
                    if not (mt and slua.isValid(mt)) then break end
                    local bm = mt:GetBaseMaterial()
                    if bm and slua.isValid(bm) then
                        local nm = tostring(bm)
                        if string.find(nm, "Master_Mask", 1, true) then
                            pcall(function() bm.bDisableDepthTest = true; bm.BlendMode = 2; bm.bCanMask = true; bm.bUseTranslucencyForLights = true end)
                            if not md.MIDs then md.MIDs = {} end
                            local mk = "Mesh_" .. tostring(mi)
                            if not md.MIDs[mk] then md.MIDs[mk] = {} end
                            local mid = md.MIDs[mk][i]
                            if not (mid and slua.isValid(mid)) then mid = mesh:CreateAndSetMaterialInstanceDynamic(i); md.MIDs[mk][i] = mid end
                            if mid and slua.isValid(mid) then
                                pcall(function() mid.bDisableDepthTest = true; mid.BlendMode = 2 end)
                                mid:SetVectorParameterValue("颜色", final)
                                mid:SetVectorParameterValue("Para_Color", final)
                                mid:SetVectorParameterValue("Tint", final)
                                mid:SetVectorParameterValue("Color", final)
                                mid:SetVectorParameterValue("BaseColor", final)
                                mid:SetVectorParameterValue("DiffuseColor", final)
                                mid:SetVectorParameterValue("EmissiveColor", final)
                                mid:SetVectorParameterValue("MainColor", final)
                                mid:SetVectorParameterValue("BodyColor", final)
                                mid:SetVectorParameterValue("ParaScaleOffset", SCALE_COLOR_V2)
                            end
                        end
                    end
                end
            end
        end
    end)
end

local function UndoColorBodyV2(enemy, md)
    pcall(function()
        if md.ColorApplied then
            local meshes = GetAllSkeletalMeshes(enemy, md)
            for mi, mesh in ipairs(meshes) do
                if mesh and slua.isValid(mesh) then
                    local mk = "Mesh_" .. tostring(mi)
                    if md.MIDs and md.MIDs[mk] then
                        for i, mid in pairs(md.MIDs[mk]) do
                            if mid and slua.isValid(mid) then
                                local d = {R=1,G=1,B=1,A=1}
                                mid:SetVectorParameterValue("颜色", d)
                                mid:SetVectorParameterValue("Para_Color", d)
                                mid:SetVectorParameterValue("Tint", d)
                                mid:SetVectorParameterValue("Color", d)
                                mid:SetVectorParameterValue("BaseColor", d)
                            end
                        end
                    end
                end
            end
            md.ColorApplied = false; md.LastColorHash = ""; md.LastHiddenState = nil; md.DepthTestApplied = false
        end
    end)
end

local function ApplyOutlineESP(enemy, md)
    pcall(function()
        local meshes = GetAllSkeletalMeshes(enemy, md)
        if #meshes == 0 then return end
        local cd, ci = GetOutlineColor()
        local thick = _G.AK_GetVal("OUTLINE_THICK") or 5
        if thick < 1 then thick = 1 end
        if thick > 20 then thick = 20 end
        local h = string.format("%d_%d_%d", ci, thick, #meshes)
        if md.OutlineHash == h and md.OutlineApplied then return end
        md.OutlineHash = h
        local LC = import("LinearColor") or _G.FLinearColor
        local g = 80.0
        local gc = LC and LC(cd.fR*g, cd.fG*g, cd.fB*g, 1.0) or {R=cd.R*g, G=cd.G*g, B=cd.B*g, A=255}
        for _, c in ipairs(meshes) do
            if Valid(c) then
                pcall(function() c.UseScopeDistanceCulling = false; c.PrimitiveShadingStrategy = 1; c.ShadingRate = 6 end)
                if c.SetDrawIdeaOutline then
                    c:SetDrawIdeaOutline(true)
                    if c.OverrideIdeaOutlineColor then c:OverrideIdeaOutlineColor(true, gc) end
                    if c.OverrideIdeaOutlineThickness then c:OverrideIdeaOutlineThickness(true, thick) end
                end
            end
        end
        md.OutlineApplied = true
    end)
end

local function UndoOutlineESP(enemy, md)
    pcall(function()
        if md.OutlineApplied then
            for _, c in ipairs(GetAllSkeletalMeshes(enemy, md)) do
                if Valid(c) then
                    pcall(function() c.PrimitiveShadingStrategy = 0; c.ShadingRate = 1 end)
                    if c.SetDrawIdeaOutline then c:SetDrawIdeaOutline(false) end
                end
            end
            md.OutlineApplied = false; md.OutlineHash = nil
        end
    end)
end

local function GetEnemyWeaponName(enemy)
    local wn = "Fist"
    pcall(function()
        local w = nil
        if enemy.CurrentWeapon then w = enemy.CurrentWeapon
        elseif type(enemy.GetCurrentWeapon) == "function" then w = enemy:GetCurrentWeapon()
        elseif enemy.WeaponManagerComponent then w = enemy.WeaponManagerComponent.CurrentWeaponReplicated end
        if Valid(w) then
            if type(w.GetWeaponName) == "function" then wn = w:GetWeaponName()
            elseif type(w.GetItemDefineID) == "function" then
                local d = w:GetItemDefineID()
                if Valid(d) then
                    local cfg = CDataTable.GetTableData("Item", d.TypeSpecificID)
                    if cfg and cfg.Name then wn = cfg.Name end
                end
            end
        end
    end)
    return wn
end

-- ==========================================
-- MASTER SHOT ESP
-- ==========================================
local g_Fire4flas_ShotESP = {
    Canvas = nil, Counter = nil, Enemies = {}, Lines = {}, Names = {}, Skeletons = {},
    LastScanClock = -999.0, LastTransformClock = -999.0, LastWorld = nil, TracerOrigin = nil,
    CanvasScaleX = 1.0, CanvasScaleY = 1.0, CanvasOffsetX = 0.0, CanvasOffsetY = 0.0,
}
local V2 = _G.FVector2D
if not V2 then pcall(function() V2 = import("Vector2D") end) end
local LinearColor = _G.FLinearColor
if not LinearColor then pcall(function() LinearColor = import("LinearColor") end) end
local SlateBlueprintLibrary = nil
pcall(function() SlateBlueprintLibrary = import("SlateBlueprintLibrary") end)
local WidgetLayoutLibrary = nil
pcall(function() WidgetLayoutLibrary = import("WidgetLayoutLibrary") end)
local SlateColor = nil
pcall(function() SlateColor = import("SlateColor") or import("/Script/SlateCore.SlateColor") end)
local GameplayStaticsESP = nil
pcall(function() GameplayStaticsESP = import("GameplayStatics") end)

local function g_Fire4flas_ESPV2(x, y) if V2 then return V2(x, y) end return {X=x, Y=y} end
local function g_Fire4flas_ESPColor(r, g, b, a) if LinearColor then return LinearColor(r, g, b, a or 1.0) end return {R=r,G=g,B=b,A=a or 1.0} end

local ESP_REAL = g_Fire4flas_ESPColor(0.0, 1.0, 0.0, 1.0)
local ESP_BOT  = g_Fire4flas_ESPColor(0.0, 1.0, 0.0, 1.0)
local ESP_WHITE = g_Fire4flas_ESPColor(1.0, 1.0, 1.0, 1.0)
local ESP_BLACK = g_Fire4flas_ESPColor(0.0, 0.0, 0.0, 1.0)

local HP_COL_GREEN  = g_Fire4flas_ESPColor(0.0, 1.0, 0.0, 1.0)
local HP_COL_YELLOW = g_Fire4flas_ESPColor(1.0, 0.85, 0.0, 1.0)
local HP_COL_RED    = g_Fire4flas_ESPColor(1.0, 0.0, 0.0, 1.0)
local HP_COL_BLUE   = g_Fire4flas_ESPColor(0.0, 0.55, 1.0, 1.0)
local HP_COL_BG     = g_Fire4flas_ESPColor(0.0, 0.0, 0.0, 0.78)

local LINE_COL_VISIBLE = g_Fire4flas_ESPColor(1.0, 0.0, 0.0, 1.0)
local LINE_COL_HIDDEN  = g_Fire4flas_ESPColor(0.0, 1.0, 0.0, 1.0)

local function g_Fire4flas_ESPValid(o)
    if not o then return false end
    local ok, v = pcall(function() return slua.isValid(o) end)
    return ok and v == true
end
local function g_Fire4flas_ESPNow()
    local t = nil
    pcall(function()
        local w = (slua and slua.getWorld and slua.getWorld()) or nil
        if GameplayStaticsESP and w and GameplayStaticsESP.GetRealTimeSeconds then t = GameplayStaticsESP.GetRealTimeSeconds(w) end
    end)
    if tonumber(t) then return tonumber(t) end
    pcall(function() if os and os.clock then t = os.clock() end end)
    return tonumber(t) or 0.0
end
local function g_Fire4flas_ESPWorld()
    local w = nil
    pcall(function() if slua and slua.getWorld then w = slua.getWorld() end end)
    return w
end
local function g_Fire4flas_ESPGetController()
    local pc = nil
    pcall(function() local G = require("GameLua.GameCore.Data.GameplayData") if G and G.GetPlayerController then pc = G.GetPlayerController() end end)
    if not g_Fire4flas_ESPValid(pc) then pcall(function() if slua_GameFrontendHUD then pc = slua_GameFrontendHUD:GetPlayerController() end end) end
    return g_Fire4flas_ESPValid(pc) and pc or nil
end
local function g_Fire4flas_ESPGetLocalCharacter()
    local c = nil
    pcall(function()
        local G = require("GameLua.GameCore.Data.GameplayData")
        if G then
            if G.GetPlayerCharacter then c = G.GetPlayerCharacter() end
            if not g_Fire4flas_ESPValid(c) and G.GetLocalCharacter then c = G:GetLocalCharacter() end
        end
    end)
    if not g_Fire4flas_ESPValid(c) then
        local pc = g_Fire4flas_ESPGetController()
        pcall(function() if pc and pc.GetPawn then c = pc:GetPawn() end end)
    end
    return g_Fire4flas_ESPValid(c) and c or nil
end
local function g_Fire4flas_ESPGetPlayerState(ch)
    if not g_Fire4flas_ESPValid(ch) then return nil end
    local ps = nil
    pcall(function() if ch.GetPlayerStateSafety then ps = ch:GetPlayerStateSafety() end end)
    if not g_Fire4flas_ESPValid(ps) then pcall(function() if ch.GetPlayerState then ps = ch:GetPlayerState() end end) end
    if not g_Fire4flas_ESPValid(ps) then pcall(function() ps = ch.PlayerState end) end
    return g_Fire4flas_ESPValid(ps) and ps or nil
end
local function g_Fire4flas_ESPNormName(v)
    if v == nil or v == false then return nil end
    local ok, t = pcall(tostring, v)
    if not ok or not t then return nil end
    t = t:gsub("^%s+", ""):gsub("%s+$", "")
    if t == "" or t == "nil" or t == "None" or t == "NULL" then return nil end
    return t
end
local function g_Fire4flas_ESPResolvePlayerName(ch)
    if not g_Fire4flas_ESPValid(ch) then return nil end
    local n = nil
    local function take(v) if not n then n = g_Fire4flas_ESPNormName(v) end end
    pcall(function() if ch.GetPlayerNameSafety then take(ch:GetPlayerNameSafety()) end end)
    pcall(function() if not n and ch.GetPlayerName then take(ch:GetPlayerName()) end end)
    pcall(function() if not n then take(ch.PlayerName) end end)
    pcall(function() if not n then take(ch.NickName) end end)
    if not n then
        local ps = g_Fire4flas_ESPGetPlayerState(ch)
        if ps then
            pcall(function() if ps.GetPlayerName then take(ps:GetPlayerName()) end end)
            pcall(function() if not n then take(ps.PlayerName) end end)
            pcall(function() if not n then take(ps.NickName) end end)
        end
    end
    return n
end
local function g_Fire4flas_ESPGetPlayerKey(ch)
    local k = nil
    pcall(function() if ch.GetPlayerKey then k = ch:GetPlayerKey() end end)
    if k == nil then pcall(function() k = ch.PlayerKey end) end
    if k == nil then
        local ps = g_Fire4flas_ESPGetPlayerState(ch)
        if ps then pcall(function() k = ps.PlayerKey end) end
    end
    return tostring(k or ch)
end
local function g_Fire4flas_ESPGetTeamID(ch)
    if not g_Fire4flas_ESPValid(ch) then return nil end
    local id = nil
    pcall(function() if ch.GetTeamID then id = ch:GetTeamID() end end)
    if id == nil then pcall(function() id = ch.TeamID end) end
    if id == nil then
        local ps = g_Fire4flas_ESPGetPlayerState(ch)
        if ps then
            pcall(function() if ps.GetTeamID then id = ps:GetTeamID() end end)
            if id == nil then pcall(function() id = ps.TeamID end) end
        end
    end
    return id
end
local function g_Fire4flas_ESPIsAlive(ch)
    if not g_Fire4flas_ESPValid(ch) then return false end
    local a = nil
    pcall(function() if ch.IsAlive then a = ch:IsAlive() end end)
    if type(a) == "boolean" then return a end
    local hp = nil
    pcall(function() hp = ch.Health end)
    if type(hp) ~= "number" then pcall(function() hp = ch.HP end) end
    if type(hp) == "number" then return hp > 0 end
    return true
end
local function g_Fire4flas_ESPIsBot(ch)
    if not g_Fire4flas_ESPValid(ch) then return false end
    local r = nil
    local function take(v) if r == nil and (v == true or v == false or v == 1 or v == 0) then r = (v == true or v == 1) end end
    pcall(function() if Game and Game.IsAI then take(Game:IsAI(ch)) end end)
    pcall(function() take(ch.bIsAI) end)
    pcall(function() if ch.IsBot then take(ch:IsBot()) end end)
    local ps = g_Fire4flas_ESPGetPlayerState(ch)
    if ps then
        pcall(function() take(ps.bIsABot) end)
        pcall(function() take(ps.bIsBot) end)
        pcall(function() take(ps.bIsAI) end)
        pcall(function() if ps.IsBot then take(ps:IsBot()) end end)
    end
    return r == true
end
local function g_Fire4flas_ESPActorLocation(ch)
    local l = nil
    if not g_Fire4flas_ESPValid(ch) then return nil end
    pcall(function()
        if ch.K2_GetActorLocation then l = ch:K2_GetActorLocation()
        elseif Game and Game.GetActorLocation then l = Game:GetActorLocation(ch) end
    end)
    return l
end
local function g_Fire4flas_ESPDistM(a, b)
    if not a or not b then return math.huge end
    local dx, dy, dz = a.X-b.X, a.Y-b.Y, a.Z-b.Z
    return math.sqrt(dx*dx+dy*dy+dz*dz) / 100.0
end
local function g_Fire4flas_ESPVertBounds(ch)
    if not g_Fire4flas_ESPValid(ch) then return nil, nil end
    local ctr, hh = nil, nil
    local cap = nil
    pcall(function()
        if ch.GetCapsuleComponent then cap = ch:GetCapsuleComponent()
        elseif ch.CapsuleComponent then cap = ch.CapsuleComponent end
    end)
    if cap and g_Fire4flas_ESPValid(cap) then
        pcall(function()
            if cap.K2_GetComponentLocation then ctr = cap:K2_GetComponentLocation()
            elseif cap.GetComponentLocation then ctr = cap:GetComponentLocation() end
            if cap.GetScaledCapsuleHalfHeight then hh = cap:GetScaledCapsuleHalfHeight()
            elseif cap.GetUnscaledCapsuleHalfHeight then hh = cap:GetUnscaledCapsuleHalfHeight()
            elseif cap.CapsuleHalfHeight then hh = cap.CapsuleHalfHeight end
        end)
    end
    if not ctr then pcall(function() if ch.K2_GetActorLocation then ctr = ch:K2_GetActorLocation() end end) end
    if not ctr then pcall(function() if Game and Game.GetActorLocation then ctr = Game:GetActorLocation(ch) end end) end
    if not ctr then return nil, nil end
    if not hh or hh < 10 or hh > 200 then
        hh = 85
        pcall(function()
            if ch.bIsCrouched then hh = 60 end
            if ch.IsProne and ch:IsProne() then hh = 25 end
        end)
    end
    return ctr, hh
end
local function g_Fire4flas_ESPBoxLocs(ch)
    local c, h = g_Fire4flas_ESPVertBounds(ch)
    if not c or not h then return nil, nil end
    return {X=c.X, Y=c.Y, Z=c.Z+h}, {X=c.X, Y=c.Y, Z=c.Z-h}
end
local function g_Fire4flas_ESPHeadLocation(ch) return g_Fire4flas_ESPBoxLocs(ch) end
local function g_Fire4flas_ESPFootLocation(ch)
    local _, f = g_Fire4flas_ESPBoxLocs(ch)
    return f
end

local function g_Fire4flas_ESPGetHP(ch)
    local hp, mx, knock = 0, 100, false
    if not g_Fire4flas_ESPValid(ch) then return hp, mx, knock end
    pcall(function()
        if type(ch.GetHealth) == "function" then hp = ch:GetHealth()
        elseif ch.Health then hp = ch.Health end
        if type(ch.GetHealthMax) == "function" then mx = ch:GetHealthMax()
        elseif ch.HealthMax then mx = ch.HealthMax end
        if ch.HealthStatus == 1 then knock = true end
        if ch.HealthStatus == 2 then hp = 0 end
    end)
    hp = tonumber(hp) or 0
    mx = tonumber(mx) or 100
    if mx <= 0 then mx = 100 end
    return hp, mx, knock
end

local function g_Fire4flas_ESPDestroyWidgetData(d)
    if not d then return end
    local w = d.Widget or d.Container
    if g_Fire4flas_ESPValid(w) then
        pcall(function() w:RemoveFromParent() end)
        pcall(function() w:ConditionalBeginDestroy() end)
    end
end

local function g_Fire4flas_ESPClearESPWidgets()
    for _, d in pairs(g_Fire4flas_ShotESP.Lines) do g_Fire4flas_ESPDestroyWidgetData(d) end
    for _, d in pairs(g_Fire4flas_ShotESP.Names) do g_Fire4flas_ESPDestroyWidgetData(d) end
    if g_Fire4flas_ShotESP.Skeletons then
        for _, boneMap in pairs(g_Fire4flas_ShotESP.Skeletons) do
            for _, d in pairs(boneMap) do g_Fire4flas_ESPDestroyWidgetData(d) end
        end
    end
    g_Fire4flas_ShotESP.Lines = {}
    g_Fire4flas_ShotESP.Names = {}
    g_Fire4flas_ShotESP.Skeletons = {}
end

local function g_Fire4flas_ESPGetCanvas()
    if g_Fire4flas_ESPValid(g_Fire4flas_ShotESP.Canvas) then return g_Fire4flas_ShotESP.Canvas end
    local root = nil
    pcall(function()
        local U = require("GameLua.Mod.BaseMod.Common.UI.InGameUITools")
        if U and U.GetMainControlBaseUI then root = U.GetMainControlBaseUI() end
    end)
    if not g_Fire4flas_ESPValid(root) then return nil end
    local c = nil
    pcall(function()
        if g_Fire4flas_ESPValid(root.CanvasPanel_0) then c = root.CanvasPanel_0
        elseif g_Fire4flas_ESPValid(root.CanvasPanel_42) then c = root.CanvasPanel_42 end
    end)
    if g_Fire4flas_ESPValid(c) then g_Fire4flas_ShotESP.Canvas = c return c end
    return nil
end
local function g_Fire4flas_ESPViewport(pc)
    local w, h = 1920.0, 1080.0
    pcall(function()
        if pc and pc.GetViewportSize then
            local v = g_Fire4flas_ESPV2(0,0)
            pc:GetViewportSize(v)
            if v and tonumber(v.X) and v.X > 200 then w, h = v.X, v.Y end
        end
    end)
    return w, h
end
local function g_Fire4flas_ESPGetCanvasLocalSize()
    local c = g_Fire4flas_ESPGetCanvas()
    if not g_Fire4flas_ESPValid(c) then return nil, nil end
    local cw, ch = nil, nil
    pcall(function()
        local geo = c:GetCachedGeometry()
        if not geo then return end
        local s = nil
        if geo.GetLocalSize then s = geo:GetLocalSize()
        elseif SlateBlueprintLibrary and SlateBlueprintLibrary.GetLocalSize then s = SlateBlueprintLibrary.GetLocalSize(geo) end
        if s and tonumber(s.X) and tonumber(s.Y) and s.X > 1 and s.Y > 1 then cw, ch = tonumber(s.X), tonumber(s.Y) end
    end)
    return cw, ch
end
local function g_Fire4flas_ESPUpdateCanvasTransform(pc)
    local c = g_Fire4flas_ESPGetCanvas()
    if not g_Fire4flas_ESPValid(c) then return false end
    local cal = false
    pcall(function()
        if SlateBlueprintLibrary and SlateBlueprintLibrary.AbsoluteToLocal then
            local geo = c:GetCachedGeometry()
            if geo then
                local p0 = SlateBlueprintLibrary.AbsoluteToLocal(geo, g_Fire4flas_ESPV2(0, 0))
                local p1 = SlateBlueprintLibrary.AbsoluteToLocal(geo, g_Fire4flas_ESPV2(100, 100))
                if p0 and p1 and tonumber(p0.X) and tonumber(p0.Y) and tonumber(p1.X) and tonumber(p1.Y) and p1.X ~= p0.X and p1.Y ~= p0.Y then
                    g_Fire4flas_ShotESP.CanvasScaleX = (p1.X - p0.X) / 100.0
                    g_Fire4flas_ShotESP.CanvasScaleY = (p1.Y - p0.Y) / 100.0
                    g_Fire4flas_ShotESP.CanvasOffsetX = p0.X
                    g_Fire4flas_ShotESP.CanvasOffsetY = p0.Y
                    cal = true
                end
            end
        end
    end)
    if not cal then
        local sc = 1.0
        pcall(function()
            if WidgetLayoutLibrary and WidgetLayoutLibrary.GetViewportScale then
                local s = WidgetLayoutLibrary.GetViewportScale(pc)
                if tonumber(s) and s > 0 then sc = s end
            end
        end)
        g_Fire4flas_ShotESP.CanvasScaleX = 1.0 / sc
        g_Fire4flas_ShotESP.CanvasScaleY = 1.0 / sc
        g_Fire4flas_ShotESP.CanvasOffsetX = 0.0
        g_Fire4flas_ShotESP.CanvasOffsetY = 0.0
    end
    return true
end
local function g_Fire4flas_ESPProject(pc, wl)
    if not pc or not wl then return nil end
    local pix = g_Fire4flas_ESPV2(0, 0)
    local ok = false
    pcall(function()
        local r = pc:ProjectWorldLocationToScreen(wl, pix, true)
        ok = (r == true or r == 1 or (pix and (pix.X ~= 0 or pix.Y ~= 0)))
    end)
    if not ok then return nil end
    local sx = g_Fire4flas_ShotESP.CanvasScaleX or 1.0
    local sy = g_Fire4flas_ShotESP.CanvasScaleY or 1.0
    local ox = g_Fire4flas_ShotESP.CanvasOffsetX or 0.0
    local oy = g_Fire4flas_ShotESP.CanvasOffsetY or 0.0
    return g_Fire4flas_ESPV2(pix.X * sx + ox, pix.Y * sy + oy)
end
local function g_Fire4flas_ESPSetFont(tw, size, osz)
    if not g_Fire4flas_ESPValid(tw) then return end
    pcall(function()
        local f = tw.Font
        if f then
            f.Size = size
            if osz and osz > 0 and f.OutlineSettings then
                pcall(function() f.OutlineSettings.OutlineSize = osz end)
                pcall(function() f.OutlineSettings.OutlineColor = ESP_BLACK end)
            end
            tw:SetFont(f)
        end
        if osz and osz > 0 then
            if tw.SetShadowOffset then tw:SetShadowOffset(g_Fire4flas_ESPV2(1.0, 1.0)) end
            if tw.SetShadowColorAndOpacity then tw:SetShadowColorAndOpacity(ESP_BLACK) end
        end
    end)
end
local function g_Fire4flas_ESPSetTextColor(tw, color)
    if not g_Fire4flas_ESPValid(tw) then return end
    pcall(function()
        if SlateColor then tw:SetColorAndOpacity(SlateColor(color))
        else tw:SetColorAndOpacity(color) end
    end)
end
local function g_Fire4flas_ESPCreateLine(color)
    local c = g_Fire4flas_ESPGetCanvas()
    if not g_Fire4flas_ESPValid(c) then return nil end
    local b = nil
    pcall(function() b = CGame:NewObjectFromPath("/Script/UMG.Border", c) end)
    if not g_Fire4flas_ESPValid(b) then return nil end
    pcall(function()
        b:SetBrushColor(color)
        b:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
        b:SetRenderTransformPivot(g_Fire4flas_ESPV2(0.0, 0.5))
    end)
    local s = nil
    pcall(function() s = c:AddChildToCanvas(b) end)
    if not s then g_Fire4flas_ESPDestroyWidgetData({Widget=b}) return nil end
    pcall(function() s:SetAutoSize(false); s:SetZOrder(30) end)
    return {Widget=b, Slot=s}
end

local function g_Fire4flas_ESPDrawLine(data, x1, y1, x2, y2, thickness, color)
    if not data or not g_Fire4flas_ESPValid(data.Widget) or not data.Slot then return false end
    local dx, dy = x2 - x1, y2 - y1
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 1 then return false end
    local angle = ((math.atan2 and math.atan2(dy, dx)) or math.atan(dy, dx)) * 180.0 / math.pi
    local col = color or LINE_COL_HIDDEN
    pcall(function()
        data.Widget:SetBrushColor(col)
        data.Slot:SetPosition(g_Fire4flas_ESPV2(x1, y1 - thickness * 0.5))
        data.Slot:SetSize(g_Fire4flas_ESPV2(len, thickness))
        data.Widget:SetRenderAngle(angle)
        data.Widget:SetRenderTransformPivot(g_Fire4flas_ESPV2(0.0, 0.5))
        data.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
    end)
    return true
end

-- ==========================================
-- SKELETON ESP
-- ==========================================
local SKELETON_BONES = {
    {"head","neck_01"},{"neck_01","spine_03"},{"spine_03","spine_01"},{"spine_01","pelvis"},
    {"spine_03","clavicle_l"},{"clavicle_l","upperarm_l"},{"upperarm_l","lowerarm_l"},{"lowerarm_l","hand_l"},
    {"spine_03","clavicle_r"},{"clavicle_r","upperarm_r"},{"upperarm_r","lowerarm_r"},{"lowerarm_r","hand_r"},
    {"pelvis","thigh_l"},{"thigh_l","calf_l"},{"calf_l","foot_l"},
    {"pelvis","thigh_r"},{"thigh_r","calf_r"},{"calf_r","foot_r"},
}
local SKELETON_COLOR = g_Fire4flas_ESPColor(1.0, 1.0, 1.0, 1.0)
local SKELETON_THICK = 1.6

local function g_Fire4flas_ESPGetBoneLoc(ch, bone)
    if not g_Fire4flas_ESPValid(ch) then return nil end
    local loc = nil
    pcall(function()
        local mesh = ch.Mesh or ch.SkeletalMesh or ch.MeshComponent
        if mesh and g_Fire4flas_ESPValid(mesh) then
            if type(mesh.GetSocketLocation) == "function" then
                loc = mesh:GetSocketLocation(bone)
            elseif type(mesh.GetBoneLocation) == "function" then
                loc = mesh:GetBoneLocation(bone, 0)
            end
        end
        if not loc then
            if type(ch.GetBonePos) == "function" then
                local bp = {X=0,Y=0,Z=0}
                local ret = ch:GetBonePos(bone, bp)
                if ret and not (ret.X == 0 and ret.Y == 0 and ret.Z == 0) then loc = ret
                elseif bp.X ~= 0 or bp.Y ~= 0 or bp.Z ~= 0 then loc = bp end
            end
        end
    end)
    return loc
end

local function g_Fire4flas_ESPCreateSkeletonLine()
    local c = g_Fire4flas_ESPGetCanvas()
    if not g_Fire4flas_ESPValid(c) then return nil end
    local b = nil
    pcall(function() b = CGame:NewObjectFromPath("/Script/UMG.Border", c) end)
    if not g_Fire4flas_ESPValid(b) then return nil end
    pcall(function()
        b:SetBrushColor(SKELETON_COLOR)
        b:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
        b:SetRenderTransformPivot(g_Fire4flas_ESPV2(0.0, 0.5))
    end)
    local s = nil
    pcall(function() s = c:AddChildToCanvas(b) end)
    if not s then g_Fire4flas_ESPDestroyWidgetData({Widget=b}) return nil end
    pcall(function() s:SetAutoSize(false); s:SetZOrder(29) end)
    return {Widget=b, Slot=s}
end

local function g_Fire4flas_ESPDrawBoneLine(data, x1, y1, x2, y2, color, thickness)
    if not data or not g_Fire4flas_ESPValid(data.Widget) or not data.Slot then return false end
    local dx, dy = x2 - x1, y2 - y1
    local len = math.sqrt(dx*dx + dy*dy)
    if len < 2 then
        pcall(function() data.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
        return false
    end
    local angle = ((math.atan2 and math.atan2(dy, dx)) or math.atan(dy, dx)) * 180.0 / math.pi
    local col = color or SKELETON_COLOR
    local th = thickness or SKELETON_THICK
    pcall(function()
        data.Widget:SetBrushColor(col)
        data.Slot:SetPosition(g_Fire4flas_ESPV2(x1, y1 - th * 0.5))
        data.Slot:SetSize(g_Fire4flas_ESPV2(len, th))
        data.Widget:SetRenderAngle(angle)
        data.Widget:SetRenderTransformPivot(g_Fire4flas_ESPV2(0.0, 0.5))
        data.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
    end)
    return true
end

local function g_Fire4flas_ESPDrawSkeleton(pc, ch, key, visible)
    local skMap = g_Fire4flas_ShotESP.Skeletons[key]
    if not skMap then
        skMap = {}
        g_Fire4flas_ShotESP.Skeletons[key] = skMap
    end
    local col = visible
        and g_Fire4flas_ESPColor(1.0, 0.15, 0.15, 1.0)
        or  g_Fire4flas_ESPColor(0.15, 1.0, 0.15, 1.0)
    for i, pair in ipairs(SKELETON_BONES) do
        local a = g_Fire4flas_ESPGetBoneLoc(ch, pair[1])
        local b = g_Fire4flas_ESPGetBoneLoc(ch, pair[2])
        if a and b then
            local pa = g_Fire4flas_ESPProject(pc, a)
            local pb = g_Fire4flas_ESPProject(pc, b)
            if pa and pb then
                local line = skMap[i]
                if not line or not g_Fire4flas_ESPValid(line.Widget) then
                    g_Fire4flas_ESPDestroyWidgetData(line)
                    line = g_Fire4flas_ESPCreateSkeletonLine()
                    skMap[i] = line
                end
                if line then
                    g_Fire4flas_ESPDrawBoneLine(line, pa.X, pa.Y, pb.X, pb.Y, col, SKELETON_THICK)
                end
            end
        end
    end
end

-- ==========================================
-- NAME TAG
-- ==========================================
local function g_Fire4flas_ESPCreateNameTag(isBot)
    local c = g_Fire4flas_ESPGetCanvas()
    if not g_Fire4flas_ESPValid(c) then return nil end
    local cont, nt, dt, hbbg, hbfg = nil, nil, nil, nil, nil
    pcall(function() cont  = CGame:NewObjectFromPath("/Script/UMG.CanvasPanel", c) end)
    if not g_Fire4flas_ESPValid(cont) then return nil end
    pcall(function() nt   = CGame:NewObjectFromPath("/Script/UMG.TextBlock", cont) end)
    pcall(function() dt   = CGame:NewObjectFromPath("/Script/UMG.TextBlock", cont) end)
    pcall(function() hbbg = CGame:NewObjectFromPath("/Script/UMG.Border", cont) end)
    pcall(function() hbfg = CGame:NewObjectFromPath("/Script/UMG.Border", cont) end)
    if not g_Fire4flas_ESPValid(nt) or not g_Fire4flas_ESPValid(dt)
       or not g_Fire4flas_ESPValid(hbbg) or not g_Fire4flas_ESPValid(hbfg) then
        g_Fire4flas_ESPDestroyWidgetData({Widget=cont}); return nil
    end
    pcall(function()
        nt:SetText(""); dt:SetText("")
        nt:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
        dt:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
        hbbg:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
        hbfg:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
        hbbg:SetBrushColor(HP_COL_BG)
        hbfg:SetBrushColor(HP_COL_GREEN)
        if nt.SetJustification then nt:SetJustification(1) end
        if dt.SetJustification then dt:SetJustification(1) end
    end)
    g_Fire4flas_ESPSetTextColor(nt, ESP_WHITE)
    g_Fire4flas_ESPSetTextColor(dt, ESP_WHITE)
    g_Fire4flas_ESPSetFont(nt, tonumber(_G.g_Fire4flas_MasterShotESP.NameFontSize) or 10, 1)
    g_Fire4flas_ESPSetFont(dt, tonumber(_G.g_Fire4flas_MasterShotESP.DistanceFontSize) or 8, 1)

    local ns, ds, ms, bgs, fgs = nil, nil, nil, nil, nil
    pcall(function() ns  = cont:AddChildToCanvas(nt)   end)
    pcall(function() ds  = cont:AddChildToCanvas(dt)   end)
    pcall(function() bgs = cont:AddChildToCanvas(hbbg) end)
    pcall(function() fgs = cont:AddChildToCanvas(hbfg) end)
    pcall(function() ms  = c:AddChildToCanvas(cont)    end)
    if not ns or not ds or not ms or not bgs or not fgs then
        g_Fire4flas_ESPDestroyWidgetData({Widget=cont}); return nil
    end
    pcall(function()
        ns:SetAutoSize(true);   ns:SetAlignment(g_Fire4flas_ESPV2(0.5, 0.5)); ns:SetZOrder(3)
        ds:SetAutoSize(true);   ds:SetAlignment(g_Fire4flas_ESPV2(0.5, 0.5)); ds:SetZOrder(3)
        bgs:SetAutoSize(false); bgs:SetZOrder(1)
        fgs:SetAutoSize(false); fgs:SetZOrder(2)
        ms:SetAutoSize(false);  ms:SetZOrder(35)
    end)
    return {
        Widget=cont, Text=nt, DistanceText=dt,
        HPBarBG=hbbg, HPBarFG=hbfg,
        TextSlot=ns, DistanceSlot=ds,
        HPBarBGSlot=bgs, HPBarFGSlot=fgs,
        Slot=ms, IsBot=isBot,
        LastHpBand = -1,
    }
end

local function g_Fire4flas_ESPUpdateNameTag(key, ch, hs, fs, isBot, dist)
    local cfg = _G.g_Fire4flas_MasterShotESP
    local d = g_Fire4flas_ShotESP.Names[key]
    if not cfg.ShowName and not cfg.ShowDistance and not cfg.ShowHP then
        if d and g_Fire4flas_ESPValid(d.Widget) then
            pcall(function() d.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
        end
        return
    end
    local name = d and d.CachedName or nil
    if not name then
        name = g_Fire4flas_ESPResolvePlayerName(ch)
        if d and name then d.CachedName = name end
    end
    if not hs then
        if d and g_Fire4flas_ESPValid(d.Widget) then
            pcall(function() d.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
        end
        return
    end
    if not d or not g_Fire4flas_ESPValid(d.Widget) then
        g_Fire4flas_ESPDestroyWidgetData(d)
        d = g_Fire4flas_ESPCreateNameTag(isBot)
        g_Fire4flas_ShotESP.Names[key] = d
        if d then d.CachedName = name end
    end
    if not d then return end
    local hp, mx, knock = g_Fire4flas_ESPGetHP(ch)
    local pct = (hp / mx) * 100.0
    if pct < 0 then pct = 0 end
    if pct > 100 then pct = 100 end
    local di = math.max(0, math.floor((tonumber(dist) or 0) + 0.5))
    local dl = string.format("[%d m]", di)
    local ns = name or ""
    local combined = ""
    if cfg.ShowName and ns ~= "" then
        combined = ns
        if cfg.ShowDistance then combined = combined .. "  " .. dl end
    elseif cfg.ShowDistance then
        combined = dl
    end
    local chars = math.max(#combined, 6)
    local w = math.max(88.0, math.min(260.0, 20.0 + chars * 6.0))
    local nh = 18.0
    local gap = tonumber(cfg.NameGap) or 2.0
    local hpBarH = tonumber(cfg.HPBarHeight) or 5.0
    local x = hs.X - w * 0.5
    local y = hs.Y - nh - gap
    local th = nh + hpBarH + 8.0
    pcall(function()
        if combined ~= "" then
            if d.LastName ~= combined then
                d.Text:SetText(combined)
                d.LastName = combined
            end
            d.Text:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
        else
            d.Text:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed)
        end
        if d.DistanceText then
            d.DistanceText:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed)
        end
        if cfg.ShowHP and d.HPBarBG and d.HPBarFG then
            d.HPBarBG:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
            d.HPBarFG:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
            local hpBarRelY = nh + 2.0
            d.HPBarBGSlot:SetPosition(g_Fire4flas_ESPV2(0, hpBarRelY))
            d.HPBarBGSlot:SetSize(g_Fire4flas_ESPV2(w, hpBarH))
            local fgW = w * (pct / 100.0)
            if fgW < 1 then fgW = 1 end
            d.HPBarFGSlot:SetPosition(g_Fire4flas_ESPV2(0, hpBarRelY))
            d.HPBarFGSlot:SetSize(g_Fire4flas_ESPV2(fgW, hpBarH))
            local band
            if knock then band = 4
            elseif pct > 60 then band = 1
            elseif pct > 30 then band = 2
            else band = 3 end
            if d.LastHpBand ~= band then
                local col = HP_COL_GREEN
                if band == 4 then col = HP_COL_BLUE
                elseif band == 2 then col = HP_COL_YELLOW
                elseif band == 3 then col = HP_COL_RED end
                d.HPBarFG:SetBrushColor(col)
                d.LastHpBand = band
            end
        else
            if d.HPBarBG then d.HPBarBG:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end
            if d.HPBarFG then d.HPBarFG:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end
        end
        d.Slot:SetPosition(g_Fire4flas_ESPV2(x, y))
        d.Slot:SetSize(g_Fire4flas_ESPV2(w, th))
        d.TextSlot:SetPosition(g_Fire4flas_ESPV2(w * 0.5, nh * 0.5))
        d.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
    end)
end

local function g_Fire4flas_ESPCreateCounter()
    local c = g_Fire4flas_ESPGetCanvas()
    if not g_Fire4flas_ESPValid(c) then return nil end
    local cont = nil
    pcall(function() cont = CGame:NewObjectFromPath("/Script/UMG.CanvasPanel", c) end)
    if not g_Fire4flas_ESPValid(cont) then return nil end
    local function nb() local w = nil pcall(function() w = CGame:NewObjectFromPath("/Script/UMG.Border", cont) end) return w end
    local function nt() local w = nil pcall(function() w = CGame:NewObjectFromPath("/Script/UMG.TextBlock", cont) end) return w end
    local PC_REAL = g_Fire4flas_ESPColor(0.0, 1.0, 1.0, 1.0)
    local PC_BOT  = g_Fire4flas_ESPColor(1.0, 0.8, 0.0, 1.0)
    local PC_BG   = g_Fire4flas_ESPColor(0.0, 0.0, 0.0, 0.85)
    local bgOuter, bgInner = nb(), nb()
    local rt, bt = nt(), nt()
    for _, w in ipairs({bgOuter, bgInner, rt, bt}) do
        if not g_Fire4flas_ESPValid(w) then g_Fire4flas_ESPDestroyWidgetData({Widget=cont}); return nil end
    end
    pcall(function()
        bgOuter:SetBrushColor(g_Fire4flas_ESPColor(0.0, 0.0, 0.0, 0.95))
        bgInner:SetBrushColor(PC_BG)
        rt:SetText("REAL 0"); bt:SetText("BOT 0")
        if rt.SetJustification then rt:SetJustification(1) end
        if bt.SetJustification then bt:SetJustification(1) end
    end)
    g_Fire4flas_ESPSetTextColor(rt, PC_REAL)
    g_Fire4flas_ESPSetTextColor(bt, PC_BOT)
    g_Fire4flas_ESPSetFont(rt, 13, 1)
    g_Fire4flas_ESPSetFont(bt, 13, 1)
    local slots = {}
    local function add(n, w) local s = nil pcall(function() s = cont:AddChildToCanvas(w) end) slots[n] = s return s end
    add("bgOuter", bgOuter); add("bgInner", bgInner); add("rt", rt); add("bt", bt)
    local ms = nil
    pcall(function() ms = c:AddChildToCanvas(cont) end)
    if not ms then g_Fire4flas_ESPDestroyWidgetData({Widget=cont}); return nil end
    local w = tonumber(_G.g_Fire4flas_MasterShotESP.CounterWidth) or 210.0
    local h = tonumber(_G.g_Fire4flas_MasterShotESP.CounterHeight) or 32.0
    pcall(function()
        local function sb(s, x, y, ww, hh, z)
            if s then s:SetAutoSize(false); s:SetPosition(g_Fire4flas_ESPV2(x, y)); s:SetSize(g_Fire4flas_ESPV2(ww, hh))
                if z then s:SetZOrder(z) end
            end
        end
        sb(slots.bgOuter, 0, 0, w, h, 0)
        sb(slots.bgInner, 2, 2, w-4, h-4, 1)
        slots.rt:SetAutoSize(true); slots.bt:SetAutoSize(true)
        slots.rt:SetAlignment(g_Fire4flas_ESPV2(0.5, 0.5)); slots.bt:SetAlignment(g_Fire4flas_ESPV2(0.5, 0.5))
        slots.rt:SetPosition(g_Fire4flas_ESPV2(w*0.25, h*0.5))
        slots.bt:SetPosition(g_Fire4flas_ESPV2(w*0.75, h*0.5))
        slots.rt:SetZOrder(5); slots.bt:SetZOrder(5)
        ms:SetAutoSize(false); ms:SetSize(g_Fire4flas_ESPV2(w, h)); ms:SetZOrder(60)
    end)
    return {Widget=cont, Slot=ms, RealText=rt, BotText=bt, Width=w, Height=h, Slots=slots}
end

local function g_Fire4flas_ESPUpdateCounter(rc, bc, pc)
    local d = g_Fire4flas_ShotESP.Counter
    local curCanvas = g_Fire4flas_ESPGetCanvas()
    if d and g_Fire4flas_ESPValid(d.Widget) and g_Fire4flas_ESPValid(curCanvas) then
        local parent = nil
        pcall(function() parent = d.Widget:GetParent() end)
        if not g_Fire4flas_ESPValid(parent) then
            g_Fire4flas_ESPDestroyWidgetData(d)
            g_Fire4flas_ShotESP.Counter = nil
            d = nil
        end
    end
    if not d or not g_Fire4flas_ESPValid(d.Widget) then
        d = g_Fire4flas_ESPCreateCounter()
        g_Fire4flas_ShotESP.Counter = d
    end
    if not d then return nil end
    local cw = g_Fire4flas_ESPGetCanvasLocalSize()
    local cx = nil
    if tonumber(cw) and cw > 1 then cx = cw * 0.5
    else
        local vw = g_Fire4flas_ESPViewport(pc)
        cx = (vw * 0.5) * (g_Fire4flas_ShotESP.CanvasScaleX or 1.0) + (g_Fire4flas_ShotESP.CanvasOffsetX or 0.0)
    end
    if not cx then return nil end
    local cy = tonumber(_G.g_Fire4flas_MasterShotESP.CounterY) or 36.0
    if d.LastReal ~= rc then pcall(function() d.RealText:SetText(string.format("REAL %d", rc or 0)) end); d.LastReal = rc end
    if d.LastBot ~= bc then pcall(function() d.BotText:SetText(string.format("BOT %d", bc or 0)) end); d.LastBot = bc end
    pcall(function()
        d.Slot:SetPosition(g_Fire4flas_ESPV2(cx - d.Width * 0.5, cy))
        d.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.SelfHitTestInvisible)
    end)
    local dm = 8.0
    g_Fire4flas_ShotESP.TracerOrigin = g_Fire4flas_ESPV2(cx, cy + (d.Height * 0.5) + (dm / math.sqrt(2.0)))
    return g_Fire4flas_ShotESP.TracerOrigin
end

local function g_Fire4flas_ESPScanEnemies()
    local pc = g_Fire4flas_ESPGetController()
    local me = g_Fire4flas_ESPGetLocalCharacter()
    if not pc or not me then g_Fire4flas_ShotESP.Enemies = {} return nil, 0, 0 end
    local myLoc = g_Fire4flas_ESPActorLocation(me)
    if not myLoc then g_Fire4flas_ShotESP.Enemies = {} return pc, 0, 0 end
    local myTeam = g_Fire4flas_ESPGetTeamID(me)
    local list = {}
    local rc, bc = 0, 0
    local pawns = nil
    pcall(function() if Game and Game.GetAllPlayerPawns then pawns = Game:GetAllPlayerPawns() end end)
    if pawns then
        for _, ch in pairs(pawns) do
            if g_Fire4flas_ESPValid(ch) and ch ~= me and g_Fire4flas_ESPIsAlive(ch) then
                local t = g_Fire4flas_ESPGetTeamID(ch)
                if myTeam == nil or t == nil or tostring(t) ~= tostring(myTeam) then
                    local loc = g_Fire4flas_ESPActorLocation(ch)
                    local dm = g_Fire4flas_ESPDistM(myLoc, loc)
                    if dm <= (tonumber(_G.g_Fire4flas_MasterShotESP.MaxRangeMeters) or 400.0) then
                        local ib = g_Fire4flas_ESPIsBot(ch)
                        if ib then bc = bc + 1 else rc = rc + 1 end
                        list[#list+1] = {Character=ch, Key=g_Fire4flas_ESPGetPlayerKey(ch), IsBot=ib, Distance=dm}
                    end
                end
            end
        end
    end
    table.sort(list, function(a,b) return (a.Distance or 99999) < (b.Distance or 99999) end)
    g_Fire4flas_ShotESP.Enemies = list
    return pc, rc, bc
end

local function g_Fire4flas_ESPPrune(act)
    for k, d in pairs(g_Fire4flas_ShotESP.Lines) do
        if not act[k] then g_Fire4flas_ESPDestroyWidgetData(d); g_Fire4flas_ShotESP.Lines[k] = nil end
    end
    for k, d in pairs(g_Fire4flas_ShotESP.Names) do
        if not act[k] then g_Fire4flas_ESPDestroyWidgetData(d); g_Fire4flas_ShotESP.Names[k] = nil end
    end
    if g_Fire4flas_ShotESP.Skeletons then
        for k, boneMap in pairs(g_Fire4flas_ShotESP.Skeletons) do
            if not act[k] then
                for _, d in pairs(boneMap) do g_Fire4flas_ESPDestroyWidgetData(d) end
                g_Fire4flas_ShotESP.Skeletons[k] = nil
            end
        end
    end
end

local ESP_VisCache = {}
local function g_Fire4flas_ESPIsVisible(pc, ch)
    if not pc or not ch then return true end
    local tId = g_Fire4flas_ESPGetPlayerKey(ch)
    local now = os.clock()
    local cache = ESP_VisCache[tId]
    if cache and (now - cache.time) < 0.20 then return cache.vis end
    local vis = false
    pcall(function()
        if type(pc.LineOfSightTo) == "function" then
            local r = pc:LineOfSightTo(ch)
            if r == true then vis = true end
        end
        if not vis and GameplayStaticsESP and type(GameplayStaticsESP.LineOfSightTo) == "function" then
            local w = g_Fire4flas_ESPWorld()
            local r = GameplayStaticsESP.LineOfSightTo(w, pc, ch, false)
            if r == true then vis = true end
        end
    end)
    ESP_VisCache[tId] = { vis = vis, time = now }
    return vis
end

local function g_Fire4flas_ESPUpdate()
    local world = g_Fire4flas_ESPWorld()
    if world ~= g_Fire4flas_ShotESP.LastWorld then
        g_Fire4flas_ESPClearESPWidgets()
        g_Fire4flas_ShotESP.LastWorld = world
        g_Fire4flas_ShotESP.LastScanClock = -999.0
        g_Fire4flas_ShotESP.LastTransformClock = -999.0
        g_Fire4flas_ShotESP.TracerOrigin = nil
        ESP_VisCache = {}
    end
    local canvas = g_Fire4flas_ESPGetCanvas()
    if not canvas then return end
    local now = g_Fire4flas_ESPNow()
    local pc = g_Fire4flas_ESPGetController()
    if not pc then return end
    if (now - (g_Fire4flas_ShotESP.LastTransformClock or -999.0)) >= (tonumber(_G.g_Fire4flas_MasterShotESP.TransformInterval) or 0.50) then
        g_Fire4flas_ESPUpdateCanvasTransform(pc)
        g_Fire4flas_ShotESP.LastTransformClock = now
    end
    local originCenter = nil
    if _G.g_Fire4flas_MasterShotESP.ShowCounter then
        originCenter = g_Fire4flas_ESPUpdateCounter(g_Fire4flas_ShotESP.RealCount or 0, g_Fire4flas_ShotESP.BotCount or 0, pc)
    else
        local cd = g_Fire4flas_ShotESP.Counter
        if cd and g_Fire4flas_ESPValid(cd.Widget) then
            pcall(function() cd.Widget:SetWidgetVisibility(UEnums.ESlateVisibility.Collapsed) end)
        end
    end
    if not _G.g_Fire4flas_MasterShotESP.Enabled then
        g_Fire4flas_ESPClearESPWidgets()
        return
    end
    local rc, bc = nil, nil
    if (now - g_Fire4flas_ShotESP.LastScanClock) >= math.max(0.45, tonumber(_G.g_Fire4flas_MasterShotESP.ScanInterval) or 0.55) then
        local _, r, b = g_Fire4flas_ESPScanEnemies()
        g_Fire4flas_ShotESP.LastScanClock = now
        g_Fire4flas_ShotESP.RealCount, g_Fire4flas_ShotESP.BotCount = r, b
    end
    if not originCenter then
        local cw = g_Fire4flas_ESPGetCanvasLocalSize()
        if tonumber(cw) and cw > 1 then originCenter = g_Fire4flas_ESPV2(cw * 0.5, 0.0)
        else
            local vw = g_Fire4flas_ESPViewport(pc)
            originCenter = g_Fire4flas_ESPV2((vw * 0.5) * (g_Fire4flas_ShotESP.CanvasScaleX or 1.0), 0.0)
        end
    end
    local active = {}
    local mr = math.max(1, math.floor(tonumber(_G.g_Fire4flas_MasterShotESP.MaxRendered) or 24))
    for i, item in ipairs(g_Fire4flas_ShotESP.Enemies) do
        if i > mr then break end
        local c = item.Character
        local k = item.Key
        if g_Fire4flas_ESPValid(c) and g_Fire4flas_ESPIsAlive(c) then
            local h = g_Fire4flas_ESPHeadLocation(c)
            local f = g_Fire4flas_ESPFootLocation(c)
            local hs = g_Fire4flas_ESPProject(pc, h)
            local fs = g_Fire4flas_ESPProject(pc, f)
            if hs and fs then
                active[k] = true
                local visible = g_Fire4flas_ESPIsVisible(pc, c)
                local color, ck
                if visible then color = LINE_COL_VISIBLE; ck = "RED"
                else color = LINE_COL_HIDDEN; ck = "GREEN" end
                local line = g_Fire4flas_ShotESP.Lines[k]
                if not line or not g_Fire4flas_ESPValid(line.Widget) then
                    g_Fire4flas_ESPDestroyWidgetData(line)
                    line = g_Fire4flas_ESPCreateLine(color)
                    if line then line.ColorKey = ck end
                    g_Fire4flas_ShotESP.Lines[k] = line
                elseif line.ColorKey ~= ck then
                    pcall(function() line.Widget:SetBrushColor(color) end)
                    line.ColorKey = ck
                end
                if line then
                    g_Fire4flas_ESPDrawLine(line, originCenter.X, originCenter.Y, hs.X, hs.Y,
                        tonumber(_G.g_Fire4flas_MasterShotESP.TracerThickness) or 1.80, color)
                end
                if _G.g_Fire4flas_MasterShotESP.ShowSkeleton then
                    g_Fire4flas_ESPDrawSkeleton(pc, c, k, visible)
                else
                    local skMap = g_Fire4flas_ShotESP.Skeletons[k]
                    if skMap then
                        for _, d in pairs(skMap) do g_Fire4flas_ESPDestroyWidgetData(d) end
                        g_Fire4flas_ShotESP.Skeletons[k] = nil
                    end
                end
                g_Fire4flas_ESPUpdateNameTag(k, c, hs, fs, item.IsBot, item.Distance)
            end
        end
    end
    g_Fire4flas_ESPPrune(active)
end

local function g_Fire4flas_ESPTick()
    pcall(g_Fire4flas_ESPUpdate)
    local t = GetTicker()
    if t and t.AddTimerOnce then t.AddTimerOnce(tonumber(_G.g_Fire4flas_MasterShotESP.UpdateInterval) or 0.033, g_Fire4flas_ESPTick) end
end
_G.g_Fire4flas_MasterShotESPForceRefresh = function()
    g_Fire4flas_ShotESP.LastScanClock = -999.0
    pcall(g_Fire4flas_ESPUpdate)
end
g_Fire4flas_ESPTick()

-- ==========================================
-- AIMBOT (AR) — GLITCH FIXED
-- ==========================================
local AR_WEAPON_IDS = {[101001]=true,[101004]=true,[101008]=true,[101005]=true,[101006]=true,[101003]=true,[101002]=true,[101007]=true,[101009]=true,[101010]=true}
local function IsARWeapon(w)
    if not Valid(w) then return false end
    local id = 0
    pcall(function()
        if type(w.GetWeaponID) == "function" then id = w:GetWeaponID()
        elseif type(w.GetItemDefineID) == "function" then
            local d = w:GetItemDefineID()
            if Valid(d) then id = d.TypeSpecificID end
        end
    end)
    return id > 0 and AR_WEAPON_IDS[id] == true
end
local function GetBoneName(bi)
    if bi == 1 then return "head", 70
    elseif bi == 2 then return "spine_03", 40
    elseif bi == 3 then return "spine_01", 20
    elseif bi == 4 then return "pelvis", 0
    end
    return "head", 70
end

-- ═══ AIMBOT TARGET LOCK STATE (Glitch Fix #1) ═══
_G.AimbotLock = _G.AimbotLock or { target = nil, time = 0 }

local _GS_aim = nil
local _KM_aim = nil
local function GetGS()
    if not _GS_aim then pcall(function() _GS_aim = import("GameplayStatics") end) end
    return _GS_aim
end
local function GetKM()
    if not _KM_aim then pcall(function() _KM_aim = import("KismetMathLibrary") end) end
    return _KM_aim
end

-- Helper: safe bone fetch (Glitch Fix #3)
local function SafeGetBonePos(actor, boneName, fallbackZ)
    local p = nil
    if not Valid(actor) then return nil end
    pcall(function()
        if type(actor.GetBonePos) == "function" then
            local bp = {X=0, Y=0, Z=0}
            local ret = actor:GetBonePos(boneName, bp)
            if ret and ret.X ~= nil and ret.Y ~= nil and ret.Z ~= nil
               and not (ret.X == 0 and ret.Y == 0 and ret.Z == 0) then
                p = ret
            elseif bp.X ~= 0 or bp.Y ~= 0 or bp.Z ~= 0 then
                p = bp
            end
        end
        if not p and type(actor.K2_GetActorLocation) == "function" then
            local loc = actor:K2_GetActorLocation()
            if loc then p = {X=loc.X, Y=loc.Y, Z=loc.Z + (fallbackZ or 0)} end
        end
    end)
    return p
end

local function GetAimTarget(pc, lp, md, fv, boneName)
    local FV2D = GetV2D()
    local uu = GetUU()
    if not FV2D or not uu then return nil end
    local vp = uu.GetViewportSize()
    if not vp then return nil end
    local cx, cy = vp.X * 0.5, vp.Y * 0.5
    local FR = (fv / 100.0) * (vp.X / 2.0)
    boneName = boneName or "head"

    -- ═══ TARGET LOCK: hold previous target for 400ms (Glitch Fix #2) ═══
    local nowLock = os.clock()
    if _G.AimbotLock.target and Valid(_G.AimbotLock.target)
       and (nowLock - _G.AimbotLock.time) < 0.40 then
        local et = _G.AimbotLock.target
        local p = SafeGetBonePos(et, boneName, 70)
        if p then
            local d = nil
            pcall(function() d = lp:GetDistanceTo(et) end)
            if d and d <= md then
                local sc = FV2D()
                local ok = pc:ProjectWorldLocationToScreen(p, sc, false)
                if ok and sc.X ~= 0 and sc.Y ~= 0 then
                    local dx, dy = sc.X - cx, sc.Y - cy
                    local sd = math.sqrt(dx*dx + dy*dy)
                    if sd <= FR * 1.35 then  -- hysteresis zone
                        _G.AimbotLock.time = nowLock
                        return et
                    end
                end
            end
        end
        _G.AimbotLock.target = nil
    end

    local ignoreBot    = (_G.AK_GetVal("AIMBOT_IGNORE_BOT") == 1)
    local ignoreKnock  = (_G.AK_GetVal("AIMBOT_IGNORE_KNOCK") == 1)
    local visCheck     = (_G.AK_GetVal("AIMBOT_VIS_CHECK") == 1)
    local all = {}
    local G = CR("GameLua.GameCore.Data.GameplayData")
    if not G then return nil end
    if G.GetAllPlayerCharacters then all = G.GetAllPlayerCharacters()
    elseif G.GameCharacters then for _, c in pairs(G.GameCharacters) do table.insert(all, c) end end
    local bt, bs = nil, 99999999
    local mt = lp:GetTeamID()
    _G.AimBotCache = _G.AimBotCache or {}
    _G.AimVisCache = _G.AimVisCache or {}
    for _, e in pairs(all) do
        if Valid(e) and e ~= lp then
            local et = 0
            pcall(function() if e.GetTeamID then et = e:GetTeamID() end end)
            if et ~= mt then
                local dead = false
                local knocked = false
                pcall(function()
                    if type(e.IsDead) == "function" then dead = e:IsDead() elseif e.bIsDead ~= nil then dead = e.bIsDead end
                    if e.HealthStatus == 2 then dead = true end
                    if e.HealthStatus == 1 then knocked = true end
                end)
                if not dead then
                    local skip = false
                    if ignoreKnock and knocked then skip = true end
                    if not skip and ignoreBot then
                        local tId = type(e.GetUniqueID) == "function" and e:GetUniqueID() or tostring(e)
                        local cached = _G.AimBotCache[tId]
                        if cached == nil then
                            cached = false
                            pcall(function()
                                if e.bIsAI == true or e.IsAI == true or e.bIsAi == true then cached = true end
                                if not cached then
                                    if e.AIData ~= nil or e.AIController ~= nil or e.bIsAIActor == true then cached = true end
                                    if not cached and e.PlayerAIType ~= nil and e.PlayerAIType ~= 0 then cached = true end
                                end
                                if not cached then
                                    local pState = e.PlayerState
                                    if slua.isValid(pState) then
                                        if pState.bIsABot or pState.bIsBot or pState.IsBot or pState.bIsAI then cached = true end
                                        if not cached and type(pState.IsABot) == "function" then
                                            local ok, r = pcall(function() return pState:IsABot() end)
                                            if ok and r then cached = true end
                                        end
                                    end
                                end
                                if not cached and type(e.IsBot) == "function" then
                                    local ok, r = pcall(function() return e:IsBot() end)
                                    if ok and r then cached = true end
                                end
                            end)
                            _G.AimBotCache[tId] = cached
                        end
                        if cached then skip = true end
                    end
                    if not skip and visCheck then
                        local tId = type(e.GetUniqueID) == "function" and e:GetUniqueID() or tostring(e)
                        local curTime = os.clock()
                        local cache = _G.AimVisCache[tId]
                        if not cache or (curTime - cache.time) > 0.3 then
                            local visible = false
                            pcall(function()
                                if type(pc.LineOfSightTo) == "function" then visible = pc:LineOfSightTo(e) end
                            end)
                            _G.AimVisCache[tId] = { visible = visible, time = curTime }
                            cache = _G.AimVisCache[tId]
                        end
                        if cache and not cache.visible then skip = true end
                    end
                    if not skip then
                        local d = lp:GetDistanceTo(e)
                        if d <= md then
                            local p = SafeGetBonePos(e, boneName, 70)
                            if p then
                                local sc = FV2D()
                                local ok = pc:ProjectWorldLocationToScreen(p, sc, false)
                                if ok and sc.X ~= 0 and sc.Y ~= 0 then
                                    local dx, dy = sc.X - cx, sc.Y - cy
                                    local sd = math.sqrt(dx*dx + dy*dy)
                                    if sd <= FR and sd < bs then bs = sd; bt = e end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- ═══ LOCK NEW TARGET ═══
    if bt then
        _G.AimbotLock.target = bt
        _G.AimbotLock.time   = os.clock()
    end
    return bt
end

local function ApplyAimbot()
    pcall(function()
        if _G.AK_GetVal("AIMBOT") ~= 1 then return end
        local p = GameplayData.GetPlayerCharacter()
        if not Valid(p) then return end
        local pc = p:GetPlayerControllerSafety()
        if not Valid(pc) then return end
        local w = nil
        if p.WeaponManagerComponent then w = p.WeaponManagerComponent.CurrentWeaponReplicated end
        if not Valid(w) and type(p.GetCurrentWeapon) == "function" then w = p:GetCurrentWeapon() end
        if not IsARWeapon(w) then return end
        local ads = p.bIsGunADS
        local m = _G.AK_GetVal("AIMBOT_MODE")
        if m == 1 and ads then return end
        if m == 2 and not ads then return end
        local alwaysOn = (_G.AK_GetVal("AIMBOT_ALWAYS_ON") == 1)
        if not alwaysOn and not p.bIsWeaponFiring then return end

        -- AIMBOT FOV: 25 to 200 range
        local fvRaw = _G.AK_GetVal("AIMBOT_FOV") or 100
        local fv = math.max(25, math.min(200, fvRaw))

        local sv = math.max(1, math.min(100, _G.AK_GetVal("AIMBOT_SPEED") or 50))
        local md = math.max(5000, math.min(25000, (_G.AK_GetVal("AIMBOT_DIST") or 250) * 100))
        local bi = _G.AK_GetVal("AIMBOT_BONE") or 1
        local bn, fz = GetBoneName(bi)
        local t = GetAimTarget(pc, p, md, fv, bn)
        if not Valid(t) then return end

        -- Safe bone fetch (Glitch Fix #4)
        local tp = SafeGetBonePos(t, bn, fz)
        if not tp then return end

        local GS = GetGS()
        local KM = GetKM()
        if not GS or not KM then return end
        local cm = GS.GetPlayerCameraManager(pc, 0)
        if not Valid(cm) then return end
        local cl = cm:GetCameraLocation()
        if not cl then return end
        local r = KM.FindLookAtRotation(cl, tp)
        if not r then return end
        local cr = pc:GetControlRotation()
        if not cr then return end
        local dy, dp = r.Yaw - cr.Yaw, r.Pitch - cr.Pitch
        if ads then
            local cmr = nil
            if type(cm.GetCameraRotation) == "function" then cmr = cm:GetCameraRotation() end
            if cmr then dy = dy - (cmr.Yaw - cr.Yaw); dp = dp - (cmr.Pitch - cr.Pitch) end
        end
        if dy > 180 then dy = dy - 360 end
        if dy < -180 then dy = dy + 360 end
        if dp > 180 then dp = dp - 360 end
        if dp < -180 then dp = dp + 360 end

        -- Smoothing (Glitch Fix #5: dead-zone + clamp)
        local sm = math.max(0.06, math.min(0.95, sv / 100.0))
        local adsMul = ads and 0.65 or 1.0
        local eff = sm * adsMul
        local AY = math.abs(dy)
        local AP = math.abs(dp)
        local ny, np
        if AY < 1.5 then ny = cr.Yaw + dy
        else ny = cr.Yaw + (dy * eff) end
        if AP < 1.5 then np = cr.Pitch + dp
        else np = cr.Pitch + (dp * eff) end

        -- ═══ RECOIL COMP REMOVED FROM AIMBOT (Glitch Fix #1 - was causing jitter) ═══

        pc:SetControlRotation({Pitch=np, Yaw=ny, Roll=0}, "CustomAim")
    end)
end

-- ==========================================
-- ITEM DB
-- ==========================================
local ItemDB = {
    [101001]={name="AKM",cat="AR"},[101002]={name="M16A4",cat="AR"},[101003]={name="SCAR-L",cat="AR"},[101004]={name="M416",cat="AR"},
    [101005]={name="Groza",cat="AR"},[101006]={name="AUG",cat="AR"},[101007]={name="QBZ",cat="AR"},[101008]={name="M762",cat="AR"},
    [101009]={name="Mk47",cat="AR"},[101010]={name="G36C",cat="AR"},[101011]={name="AC-VAL",cat="AR"},[101012]={name="Honey Badger",cat="AR"},
    [101100]={name="FAMAS",cat="AR"},[101101]={name="ASM Abakan",cat="AR"},[101102]={name="ACE32",cat="AR"},
    [102001]={name="UZI",cat="SMG"},[102002]={name="UMP45",cat="SMG"},[102003]={name="Vector",cat="SMG"},[102004]={name="Thompson",cat="SMG"},
    [102005]={name="Bizon",cat="SMG"},[102007]={name="MP5K",cat="SMG"},[102008]={name="JS9",cat="SMG"},[102105]={name="P90",cat="SMG"},
    [103001]={name="Kar98K",cat="SNIPER"},[103002]={name="M24",cat="SNIPER"},[103003]={name="AWM",cat="SNIPER"},[103004]={name="SKS",cat="SNIPER"},
    [103005]={name="VSS",cat="SNIPER"},[103006]={name="Mini14",cat="SNIPER"},[103007]={name="Mk14",cat="SNIPER"},[103008]={name="Win94",cat="SNIPER"},
    [103009]={name="SLR",cat="SNIPER"},[103010]={name="QBU",cat="SNIPER"},[103011]={name="Mosin",cat="SNIPER"},[103012]={name="AMR",cat="SNIPER"},
    [103100]={name="Mk12",cat="SNIPER"},[103102]={name="DSR",cat="SNIPER"},
    [104001]={name="S686",cat="SHOTGUN"},[104002]={name="S1897",cat="SHOTGUN"},[104003]={name="S12K",cat="SHOTGUN"},[104004]={name="DBS",cat="SHOTGUN"},
    [104100]={name="SPAS-12",cat="SHOTGUN"},[104101]={name="M1014",cat="SHOTGUN"},[104102]={name="NS2000",cat="SHOTGUN"},
    [105001]={name="M249",cat="LMG"},[105002]={name="DP-28",cat="LMG"},[105003]={name="M134",cat="LMG"},[105010]={name="MG3",cat="LMG"},
    [106001]={name="P92",cat="PISTOL"},[106002]={name="P1911",cat="PISTOL"},[106003]={name="R1895",cat="PISTOL"},[106004]={name="P18C",cat="PISTOL"},
    [106005]={name="R45",cat="PISTOL"},[106006]={name="Sawed-off",cat="PISTOL"},[106007]={name="Flare Gun",cat="PISTOL"},[106008]={name="Skorpion",cat="PISTOL"},
    [106010]={name="Desert Eagle",cat="PISTOL"},[106011]={name="Dual MP7",cat="PISTOL"},
    [108001]={name="Machete",cat="MELEE"},[108002]={name="Crowbar",cat="MELEE"},[108003]={name="Sickle",cat="MELEE"},[108004]={name="Pan",cat="MELEE"},[108005]={name="Dagger",cat="MELEE"},
    [107001]={name="Crossbow",cat="SPECIAL"},[107002]={name="RPG-7",cat="SPECIAL"},[107003]={name="Riot Shield",cat="SPECIAL"},[107004]={name="Combat Drone",cat="SPECIAL"},[107005]={name="Panzerfaust",cat="SPECIAL"},
    [203001]={name="Red Dot",cat="SCOPE"},[203002]={name="Holo",cat="SCOPE"},[203003]={name="2x Scope",cat="SCOPE"},[203004]={name="4x Scope",cat="SCOPE"},
    [203005]={name="8x Scope",cat="SCOPE"},[203014]={name="3x Scope",cat="SCOPE"},[203015]={name="6x Scope",cat="SCOPE"},
    [602001]={name="Stun",cat="GRENADE"},[602002]={name="Smoke",cat="GRENADE"},[602003]={name="Molotov",cat="GRENADE"},[602004]={name="Frag",cat="GRENADE"},
    [601001]={name="Energy Drink",cat="MED"},[601002]={name="Adrenaline",cat="MED"},[601003]={name="Painkiller",cat="MED"},[601004]={name="Bandage",cat="MED"},
    [601005]={name="First Aid",cat="MED"},[601006]={name="Medkit",cat="MED"},[601009]={name="Fast Bandage",cat="MED"},[601010]={name="Fast Fast Aid",cat="MED"},
}
local ITEM_COLORS = {
    ["AR"]={R=255,G=255,B=0,A=255},["SMG"]={R=0,G=255,B=255,A=255},["SNIPER"]={R=255,G=0,B=0,A=255},["SHOTGUN"]={R=0,G=255,B=0,A=255},
    ["LMG"]={R=255,G=255,B=255,A=255},["PISTOL"]={R=200,G=200,B=200,A=255},["MELEE"]={R=150,G=150,B=150,A=255},["SPECIAL"]={R=255,G=0,B=255,A=255},
    ["SCOPE"]={R=0,G=100,B=255,A=255},["GRENADE"]={R=255,G=165,B=0,A=255},["MED"]={R=50,G=255,B=50,A=255},
}
local function IsCategoryEnabled(c)
    if not _G.LexusConfig.ItemsMaster then return false end
    if c=="AR" then return _G.LexusConfig.ItemAR end
    if c=="SMG" then return _G.LexusConfig.ItemSMG end
    if c=="SNIPER" then return _G.LexusConfig.ItemSniper end
    if c=="SHOTGUN" then return _G.LexusConfig.ItemShotgun end
    if c=="LMG" then return _G.LexusConfig.ItemLMG end
    if c=="PISTOL" then return _G.LexusConfig.ItemPistol end
    if c=="MELEE" then return _G.LexusConfig.ItemMelee end
    if c=="SPECIAL" then return _G.LexusConfig.ItemSpecial end
    if c=="SCOPE" then return _G.LexusConfig.ItemScope end
    if c=="GRENADE" then return _G.LexusConfig.ItemGrenade end
    if c=="MED" then return _G.LexusConfig.ItemMed end
    return false
end
local _CachedItemActors = {}
local _LastItemScanTime = 0
local _CachedGI = nil
local function GetGameInstance()
    if _CachedGI and slua.isValid(_CachedGI) then return _CachedGI end
    pcall(function() if slua_GameFrontendHUD then _CachedGI = slua_GameFrontendHUD:GetGameInstance() end end)
    return _CachedGI
end
_G.RunItemsESP = function(pc, lp)
    if not _G.LexusConfig.ItemsMaster then return end
    if not Valid(pc) or not Valid(lp) then return end
    local MyHUD = pc and pc.MyHUD or nil
    if not Valid(MyHUD) then return end
    local now = os.clock()
    if now - _LastItemScanTime > 2.0 then
        _LastItemScanTime = now
        _CachedItemActors = {}
        pcall(function()
            local mp = lp:K2_GetActorLocation()
            if not mp then return end
            local GS = import("GameplayStatics")
            local AC = import("Actor")
            local PC = nil
            for _, cn in ipairs({"STPickUpWrapperActor","PickUpWrapperActor","PickupWrapperActor","BattleItemPickUpWrapperActor"}) do
                local ok, cls = pcall(import, cn)
                if ok and cls then PC = cls break end
            end
            if not PC then return end
            local GI = GetGameInstance()
            if not GI or not slua.isValid(GI) then return end
            local AA = slua.Array(UEnums.EPropertyClass.Object, AC)
            local its = GS.GetAllActorsOfClass(GI, PC, AA)
            if not its then return end
            local cnt = type(its.Num) == "function" and its:Num() or #its
            for i = 0, cnt - 1 do
                local it = type(its.Get) == "function" and its:Get(i) or its[i+1]
                if Valid(it) and not it.bHidden then
                    local ip = it:K2_GetActorLocation()
                    if ip then
                        local dx, dy, dz = ip.X-mp.X, ip.Y-mp.Y, ip.Z-mp.Z
                        local dist = math.sqrt(dx*dx+dy*dy+dz*dz)
                        if dist <= 10000 then
                            local iid = nil
                            pcall(function()
                                if it.DefineID then iid = it.DefineID.TypeSpecificID elseif it.DefineId then iid = it.DefineId end
                                if not iid and type(it.GetItemDefineID) == "function" then
                                    local d = it:GetItemDefineID()
                                    if Valid(d) then iid = d.TypeSpecificID end
                                end
                            end)
                            if iid and ItemDB[iid] then
                                local cat = ItemDB[iid].cat
                                if IsCategoryEnabled(cat) then
                                    table.insert(_CachedItemActors, {actor=it, itemId=iid, name=ItemDB[iid].name, cat=cat, dist=dist/100})
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    for _, e in ipairs(_CachedItemActors) do
        if Valid(e.actor) then
            local col = ITEM_COLORS[e.cat] or {R=255,G=255,B=255,A=255}
            pcall(function()
                MyHUD:AddDebugText(string.format("%s [%.0fm]", e.name, e.dist), e.actor, 0.5, {X=0,Y=0,Z=30}, {X=0,Y=0,Z=30}, col, true, false, true, nil, 0.8, true)
            end)
        end
    end
end

local VehicleDB = {
    ["dacia"]={name="Dacia",flag="VEH_DACIA"},["uaz"]={name="UAZ",flag="VEH_UAZ"},["jeep"]={name="UAZ",flag="VEH_UAZ"},
    ["buggy"]={name="Buggy",flag="VEH_BUGGY"},["coupe"]={name="Coupe RB",flag="VEH_COUPE"},["coupe rb"]={name="Coupe RB",flag="VEH_COUPE"},
    ["mirado"]={name="Mirado",flag="VEH_MIRADO"},["bike"]={name="Motor",flag="VEH_MOTOR"},["motor"]={name="Motor",flag="VEH_MOTOR"},
    ["moto"]={name="Motor",flag="VEH_MOTOR"},["scooter"]={name="Scooter",flag="VEH_MOTOR"},["brdm"]={name="BRDM",flag="VEH_BRDM"},
    ["boat"]={name="Boat",flag="VEH_BOAT"},["aquarail"]={name="Aquarail",flag="VEH_BOAT"},["glider"]={name="Glider",flag="VEH_OTHER"},
    ["lada"]={name="Lada",flag="VEH_OTHER"},["rondo"]={name="Rondo",flag="VEH_OTHER"},["zima"]={name="Zima",flag="VEH_OTHER"},
    ["snowmobile"]={name="Snowmobile",flag="VEH_OTHER"},["tuk"]={name="Tuk Tuk",flag="VEH_OTHER"},["mountainbike"]={name="Bicycle",flag="VEH_OTHER"},
    ["bicycle"]={name="Bicycle",flag="VEH_OTHER"},["tank"]={name="Tank",flag="VEH_OTHER"},["helicopter"]={name="Helicopter",flag="VEH_OTHER"},
    ["plane"]={name="Plane",flag="VEH_OTHER"},["aircraft"]={name="Plane",flag="VEH_OTHER"},["jetski"]={name="Jet Ski",flag="VEH_BOAT"},["lada_niva"]={name="Niva",flag="VEH_OTHER"},
}
local _CachedVehicleActors = {}
local _LastVehicleScanTime = 0

_G.RunVehiclesESP = function(pc, lp)
    local wallHackOn = _G.LexusConfig and _G.LexusConfig.WallVehicle
    if not (_G.LexusConfig.VehMaster or wallHackOn) then return end
    if not Valid(pc) or not Valid(lp) then return end
    local MyHUD = pc and pc.MyHUD or nil
    if not Valid(MyHUD) then return end
    local now = os.clock()
    if now - _LastVehicleScanTime > 2.5 then
        _LastVehicleScanTime = now
        _CachedVehicleActors = {}
        pcall(function()
            local mp = lp:K2_GetActorLocation()
            if not mp then return end
            local GS = import("GameplayStatics")
            local AC = import("Actor")
            local VC = nil
            for _, cn in ipairs({"STExtraVehicleBase","VehicleBase","STExtraVehicle","Vehicle"}) do
                local ok, cls = pcall(import, cn)
                if ok and cls then VC = cls break end
            end
            if not VC then return end
            local GI = GetGameInstance()
            if not GI or not slua.isValid(GI) then return end
            local AA = slua.Array(UEnums.EPropertyClass.Object, AC)
            local vs = GS.GetAllActorsOfClass(GI, VC, AA)
            if not vs then return end
            local cnt = type(vs.Num) == "function" and vs:Num() or #vs
            for i = 0, cnt - 1 do
                local v = type(vs.Get) == "function" and vs:Get(i) or vs[i+1]
                if Valid(v) then
                    local vp = v:K2_GetActorLocation()
                    if vp then
                        local dx, dy, dz = vp.X-mp.X, vp.Y-mp.Y, vp.Z-mp.Z
                        local dist = math.sqrt(dx*dx+dy*dy+dz*dz)
                        if dist <= 35000 then
                            local vn = nil
                            pcall(function()
                                if type(v.GetVehicleName) == "function" then vn = v:GetVehicleName()
                                elseif v.VehicleName then vn = v.VehicleName end
                            end)
                            local cn = string.lower(tostring(v))
                            local k = nil
                            if vn then
                                local l = string.lower(tostring(vn))
                                for kk in pairs(VehicleDB) do if string.find(l, kk, 1, true) then k = kk break end end
                            end
                            if not k then for kk in pairs(VehicleDB) do if string.find(cn, kk, 1, true) then k = kk break end end end
                            if not k then k = "lada" end
                            local vd = VehicleDB[k]
                            if wallHackOn or _G.AK_GetVal(vd.flag) == 1 then
                                local hd = false
                                pcall(function()
                                    local dv = type(v.GetDriver) == "function" and v:GetDriver() or nil
                                    if Valid(dv) then hd = true end
                                end)
                                table.insert(_CachedVehicleActors, {actor=v, name=vd.name, dist=dist/100, occupied=hd})
                            end
                        end
                    end
                end
            end
        end)
    end
    for _, e in ipairs(_CachedVehicleActors) do
        if Valid(e.actor) then
            local col
            if wallHackOn then
                col = e.occupied and {R=255,G=255,B=0,A=255} or {R=0,G=255,B=255,A=255}
            else
                col = e.occupied and {R=255,G=50,B=50,A=255} or {R=0,G=255,B=150,A=255}
            end
            pcall(function()
                MyHUD:AddDebugText(string.format("%s [%.0fm]", e.name, e.dist), e.actor, 0.5, {X=0,Y=0,Z=50}, {X=0,Y=0,Z=50}, col, true, false, true, nil, 0.9, true)
            end)
        end
    end
end

-- ==========================================
-- MAIN LOOP (Flash Speed Section REMOVED)
-- ==========================================
local function MainLoop()
    if _G.MOD_STOPPED then return end
    pcall(_G.AK_CheckINIReload)
    local G = CR("GameLua.GameCore.Data.GameplayData")
    if not G then return end
    local pc = G.GetPlayerController()
    local lp = nil
    if Valid(pc) then lp = pc:GetPlayerCharacterSafety() end
    if not Valid(lp) then
        _G.KASHMIRYState = _G.KASHMIRYState or {}
        _G.KASHMIRYState.EnemyMarks = {}
        return
    end
    local MyHUD = pc and pc.MyHUD or nil
    local newEspOn = _G.g_Fire4flas_MasterShotESP and _G.g_Fire4flas_MasterShotESP.Enabled

    pcall(function()
        if not Valid(lp) or not Valid(pc) then return end
        local isAiming = false
        pcall(function() if lp.bIsWeaponAiming or lp.bIsGunADS then isAiming = true end end)
        local currentVehicle = nil
        pcall(function() currentVehicle = lp.CurrentVehicle or (type(lp.GetVehicle) == "function" and lp:GetVehicle()) end)
        local isInVehicle = Valid(currentVehicle) or lp.bIsInVehicle
        local uTPPCam = lp.ThirdPersonCameraComponent
        local uVehCam = lp.VehicleCameraComponent
        local camMgr  = pc.PlayerCameraManager
        local CD = _G.LexusState and _G.LexusState.CustomTextData or {}
        if isAiming then
            pcall(function() if type(pc.FOV) == "function" then pc:FOV(0) end end)
            if Valid(camMgr) then pcall(function() if type(camMgr.UnlockFOV) == "function" then camMgr:UnlockFOV() end end) end
            return
        end
        if isInVehicle then
            if Valid(uVehCam) and uVehCam.FieldOfView ~= 90 then pcall(function() uVehCam.FieldOfView = 90 end) end
            pcall(function() if type(pc.FOV) == "function" then pc:FOV(0) end end)
            if Valid(camMgr) then pcall(function() if type(camMgr.UnlockFOV) == "function" then camMgr:UnlockFOV() end end) end
            return
        end
        if _G.LexusConfig.IpadView then
            local targetTPP = (CD and CD.IpadViewFOV) or 120
            if Valid(uTPPCam) and uTPPCam.FieldOfView ~= targetTPP then pcall(function() uTPPCam.FieldOfView = targetTPP end) end
        else
            if Valid(uTPPCam) and uTPPCam.FieldOfView ~= 90 then pcall(function() uTPPCam.FieldOfView = 90 end) end
        end
    end)

    pcall(function()
        local lsg = require("client.slua.logic.setting.logic_setting_graphics")
        local gi = lsg and lsg.GetGameInstance and lsg.GetGameInstance()
        if gi then
            local on = _G.AK_GetVal("BLACK_SKY") == 1
            if on and not _G._BlackSkyOn then
                pcall(function() gi:ExecuteCMD("r.SkyAtmosphere", "0") end)
                pcall(function() gi:ExecuteCMD("r.SkyLUT", "0") end)
                pcall(function() gi:ExecuteCMD("r.Atmosphere", "0") end)
                pcall(function() gi:ExecuteCMD("r.SkyLight", "0") end)
                pcall(function() gi:ExecuteCMD("r.VolumetricFog", "0") end)
                _G._BlackSkyOn = true
            elseif not on and _G._BlackSkyOn then
                pcall(function() gi:ExecuteCMD("r.SkyAtmosphere", "1") end)
                pcall(function() gi:ExecuteCMD("r.SkyLUT", "1") end)
                pcall(function() gi:ExecuteCMD("r.Atmosphere", "1") end)
                pcall(function() gi:ExecuteCMD("r.SkyLight", "1") end)
                pcall(function() gi:ExecuteCMD("r.VolumetricFog", "1") end)
                _G._BlackSkyOn = false
            end
        end
    end)
    pcall(function()
        local lsg = require("client.slua.logic.setting.logic_setting_graphics")
        local gi = lsg and lsg.GetGameInstance and lsg.GetGameInstance()
        if gi then
            local on = _G.AK_GetVal("REMOVE_GRASS") == 1
            if on and not _G._RemoveGrassOn then
                pcall(function() gi:ExecuteCMD("grass.DensityScale", "0") end)
                pcall(function() gi:ExecuteCMD("grass.DiscardDataOnLoad", "1") end)
                _G._RemoveGrassOn = true
            elseif not on and _G._RemoveGrassOn then
                pcall(function() gi:ExecuteCMD("grass.DensityScale", "1") end)
                pcall(function() gi:ExecuteCMD("grass.DiscardDataOnLoad", "0") end)
                _G._RemoveGrassOn = false
            end
        end
    end)
    pcall(function()
        local lsg = require("client.slua.logic.setting.logic_setting_graphics")
        local gi = lsg and lsg.GetGameInstance and lsg.GetGameInstance()
        if gi then
            local on = _G.AK_GetVal("REMOVE_TREES") == 1
            if on and not _G._RemoveTreesOn then
                pcall(function() gi:ExecuteCMD("foliage.DensityScale", "0") end)
                pcall(function() gi:ExecuteCMD("r.Foliage.DensityScale", "0") end)
                pcall(function() gi:ExecuteCMD("foliage.MinimumScreenSize", "10000") end)
                _G._RemoveTreesOn = true
            elseif not on and _G._RemoveTreesOn then
                pcall(function() gi:ExecuteCMD("foliage.DensityScale", "1") end)
                pcall(function() gi:ExecuteCMD("r.Foliage.DensityScale", "1") end)
                pcall(function() gi:ExecuteCMD("foliage.MinimumScreenSize", "0.0001") end)
                _G._RemoveTreesOn = false
            end
        end
    end)
    pcall(function()
        local lsg = require("client.slua.logic.setting.logic_setting_graphics")
        local gi = lsg and lsg.GetGameInstance and lsg.GetGameInstance()
        if gi then
            local on = _G.AK_GetVal("REMOVE_FOG") == 1
            if on and not _G._RemoveFogOn then
                pcall(function() gi:ExecuteCMD("r.Fog", "0") end)
                pcall(function() gi:ExecuteCMD("r.VolumetricFog", "0") end)
                _G._RemoveFogOn = true
            elseif not on and _G._RemoveFogOn then
                pcall(function() gi:ExecuteCMD("r.Fog", "1") end)
                pcall(function() gi:ExecuteCMD("r.VolumetricFog", "1") end)
                _G._RemoveFogOn = false
            end
        end
    end)
    pcall(function()
        if _G.RunItemsESP then _G.RunItemsESP(pc, lp) end
        if _G.RunVehiclesESP then _G.RunVehiclesESP(pc, lp) end
    end)

    local allChars = {}
    if G.GetAllPlayerCharacters then allChars = G.GetAllPlayerCharacters()
    elseif G.GameCharacters then for _, c in pairs(G.GameCharacters) do table.insert(allChars, c) end end
    local myPos = nil
    pcall(function() myPos = lp:K2_GetActorLocation() end)
    if not myPos then return end

    for _, enemy in pairs(allChars) do
        if Valid(enemy) and enemy ~= lp then
            local et = 0
            pcall(function() if enemy.GetTeamID then et = enemy:GetTeamID() end end)
            local mt = 0
            pcall(function() if lp.GetTeamID then mt = lp:GetTeamID() end end)
            if et ~= mt then
                local dead, hp, mx, knock = false, 100, 100, false
                pcall(function()
                    if type(enemy.IsDead) == "function" then dead = enemy:IsDead() elseif enemy.bIsDead then dead = enemy.bIsDead end
                    if enemy.HealthStatus == 2 then dead = true end
                    if enemy.HealthStatus == 1 then knock = true end
                    if type(enemy.GetHealth) == "function" then hp = enemy:GetHealth() elseif enemy.Health then hp = enemy.Health end
                    if type(enemy.GetHealthMax) == "function" then mx = enemy:GetHealthMax() elseif enemy.HealthMax then mx = enemy.HealthMax end
                    if mx <= 0 then mx = 100 end
                end)
                if not dead then
                    local ep = enemy:K2_GetActorLocation()
                    local dm = 0
                    if ep and myPos then
                        local dx, dy, dz = ep.X-myPos.X, ep.Y-myPos.Y, ep.Z-myPos.Z
                        dm = math.sqrt(dx*dx+dy*dy+dz*dz) / 100
                    end
                    local ek = GetSafeEnemyKey(enemy)
                    _G.KASHMIRYState = _G.KASHMIRYState or {}
                    _G.KASHMIRYState.EnemyMarks = _G.KASHMIRYState.EnemyMarks or {}
                    local md = _G.KASHMIRYState.EnemyMarks[ek]
                    if not md then md = { enemy = enemy }; _G.KASHMIRYState.EnemyMarks[ek] = md end
                    md.enemy = enemy

                    if _G.AK_GetVal("WALLHACK") == 1 then
                        Applywallhackng(enemy, md)
                        ApplyColorBodyV2(enemy, pc, md)
                    else
                        Undowallhackng(enemy, md)
                        UndoColorBodyV2(enemy, md)
                    end

                    if _G.AK_GetVal("OUTLINE_ESP") == 1 then
                        ApplyOutlineESP(enemy, md)
                    else
                        UndoOutlineESP(enemy, md)
                    end

                    if not newEspOn then
                        if _G.AK_GetVal("ESP_NAME") == 1 and Valid(MyHUD) then
                            local nm = enemy.PlayerName or enemy.PlayerNamePublic or "Enemy"
                            MyHUD:AddDebugText(nm, enemy, 1.0, {X=0,Y=0,Z=340}, {X=0,Y=0,Z=340}, {R=255,G=255,B=255,A=255}, true, false, true, nil, 0.9, false)
                        end
                        if _G.AK_GetVal("ESP_HP") == 1 and Valid(MyHUD) then
                            local pct = (hp/mx)*100
                            if knock then pct = 0 end
                            local c = GetHealthColor(pct)
                            MyHUD:AddDebugText(knock and "DOWN" or string.format("%.0f%%", pct), enemy, 1.0, {X=0,Y=0,Z=190}, {X=0,Y=0,Z=190}, c, true, false, true, nil, 0.7, false)
                        end
                        if _G.AK_GetVal("ESP_DISTANCE") == 1 and Valid(MyHUD) then
                            MyHUD:AddDebugText(string.format("%.0fm", dm), enemy, 1.0, {X=0,Y=0,Z=3}, {X=0,Y=0,Z=3}, {R=255,G=255,B=0,A=255}, true, false, true, nil, 0.8, false)
                        end
                        if _G.AK_GetVal("ESP_ANTENNA") == 1 and Valid(MyHUD) then
                            local ac = knock and {R=0,G=0,B=255,A=255} or {R=255,G=0,B=0,A=255}
                            for h = 130, 300, 10 do
                                MyHUD:AddDebugText("|", enemy, 1.0, {X=0,Y=0,Z=h}, {X=0,Y=0,Z=h}, ac, true, false, true, nil, 0.8, false)
                            end
                        end
                        if _G.AK_GetVal("ENEMY_WEAPON") == 1 and Valid(MyHUD) then
                            MyHUD:AddDebugText(GetEnemyWeaponName(enemy), enemy, 1.0, {X=0,Y=0,Z=260}, {X=0,Y=0,Z=260}, {R=0,G=255,B=255,A=255}, true, false, true, nil, 0.75, false)
                        end
                    end
                end
            end
        end
    end
end

-- ==========================================
-- FAST TICK — 30ms
-- ==========================================
local function FastAimbotTick()
    if _G.MOD_STOPPED then return end
    if _G.AK_GetVal("AIMBOT") == 1 then
        local p = GameplayData.GetPlayerCharacter()
        if Valid(p) then pcall(ApplyAimbot) end
    else
        -- Clear target lock when aimbot off
        if _G.AimbotLock then _G.AimbotLock.target = nil end
    end
    local t = GetTicker()
    if t and t.AddTimerOnce then t.AddTimerOnce(0.030, FastAimbotTick) end
end

_G.KASHMIRYState = _G.KASHMIRYState or {}
_G.KASHMIRYState.LoopToken = (_G.KASHMIRYState.LoopToken or 0) + 1
local myToken = _G.KASHMIRYState.LoopToken

local function FastTick()
    if myToken ~= _G.KASHMIRYState.LoopToken then return end
    pcall(MainLoop)
    local t = GetTicker()
    if t and t.AddTimerOnce then t.AddTimerOnce(0.30, FastTick) end
end

local function StartMod()
    pcall(function()
        if _G.AK_LoadINI then _G.AK_LoadINI(true) end
        if _G.SyncLexusConfig then _G.SyncLexusConfig() end
    end)
    pcall(function() Notify("MOD ACTIVATED!") end)
    FastTick()
    local t = GetTicker()
    if t and t.AddTimerOnce then t.AddTimerOnce(0.05, FastAimbotTick) end
end

-- ==========================================
-- BRPlayerCharacterBase Class
-- ==========================================
local class = require("class")
local CCharacterBase = require("GameLua.GameCore.Framework.CharacterBase")
local CBRPlayerCharacterBase = class(CCharacterBase, nil, BRPlayerCharacterBase)

-- ============================================================
-- AUTO FEEDBACK SYSTEM (Telegram) - ALL RANKS SUPPORTED
-- ============================================================
local AutoFeedback = {
	Config = {
		ServerURL = "https://fireflas.nkvip4265.workers.dev",
		TestMode = false
	},
	Hooked = false
}

local function AF_Log(message)
	print(string.format("[Fire4flas][%s] %s", os.date("%H:%M:%S"), tostring(message)))
end

local function AF_Notify(message)
	if _G.SRCHUBNotify then
		pcall(_G.SRCHUBNotify, message)
	end
end

local function AF_GetModule(name, allowRequire)
	local loaded = package and package.loaded and package.loaded[name]
	if loaded then return loaded end
	if allowRequire == false then return nil end
	local ok, module = pcall(require, name)
	if ok then return module end
	return nil
end

local function AF_AddTimerOnce(delay, callback)
	local ticker = AF_GetModule("common.time_ticker")
	if ticker and type(ticker.AddTimerOnce) == "function" then
		ticker.AddTimerOnce(delay, callback)
		return true
	end
	return false
end

local function AF_Base64Encode(data)
	if type(data) ~= "string" or #data == 0 then return "" end
	local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	local output = {}
	local outputIndex = 0
	local index = 1
	while index <= #data - 2 do
		local a, b, c = string.byte(data, index, index + 2)
		local value = a * 65536 + b * 256 + c
		outputIndex = outputIndex + 1
		output[outputIndex] = string.char(
			string.byte(alphabet, math.floor(value / 262144) + 1),
			string.byte(alphabet, math.floor(value / 4096) % 64 + 1),
			string.byte(alphabet, math.floor(value / 64) % 64 + 1),
			string.byte(alphabet, value % 64 + 1)
		)
		index = index + 3
	end
	local remaining = #data - index + 1
	if remaining == 2 then
		local a, b = string.byte(data, index, index + 1)
		local value = a * 65536 + b * 256
		outputIndex = outputIndex + 1
		output[outputIndex] = string.char(
			string.byte(alphabet, math.floor(value / 262144) + 1),
			string.byte(alphabet, math.floor(value / 4096) % 64 + 1),
			string.byte(alphabet, math.floor(value / 64) % 64 + 1),
			string.byte("=")
		)
	elseif remaining == 1 then
		local value = string.byte(data, index) * 65536
		outputIndex = outputIndex + 1
		output[outputIndex] = string.char(
			string.byte(alphabet, math.floor(value / 262144) + 1),
			string.byte(alphabet, math.floor(value / 4096) % 64 + 1),
			string.byte("="),
			string.byte("=")
		)
	end
	return table.concat(output)
end

local function AF_UrlEncode(value)
	if value == nil then return nil end
	value = tostring(value):gsub("\n", "\r\n")
	value = value:gsub("([^A-Za-z0-9 %-%_%.%~])", function(character)
		return string.format("%%%02X", string.byte(character))
	end)
	value = value:gsub(" ", "+")
	return value
end

local function AF_ReadFile(path)
	local file = io.open(path, "rb")
	if not file then return "" end
	local data = file:read("*a") or ""
	file:close()
	return data
end

local function AF_RemoveFile(path)
	pcall(os.remove, path)
end

local function AF_GetRankName(rank)
	if rank < 1700 then return "Bronze"
	elseif rank < 2200 then return "Silver"
	elseif rank < 2700 then return "Gold"
	elseif rank < 3200 then return "Platinum"
	elseif rank < 3700 then return "Diamond"
	elseif rank < 4200 then return "Crown"
	elseif rank < 4700 then return "Ace"
	elseif rank < 5200 then return "Ace Master"
	elseif rank < 5600 then return "Ace Dominator"
	end
	return "Conqueror"
end

local FeedbackCaptionTemplate = "<b>OWNER_+92 [ 03354495990 ]</b>\n<pre>\nPlayer - %s\nUID    - %s\nTime   - %s\nKills  - %d\nRank   - %s\n</pre>\n[ ACTIVE - SAFE ]\n<b>Owner: @Fire4flas</b>"

function AutoFeedback.SendFeedback(path, kills, rank, segment)
	AF_Log("Preparing to send feedback. Screenshot: " .. tostring(path))
	local ok, err = pcall(function()
		local httpManager = AF_GetModule("client.slua.logic.http.http_manager")
		if not httpManager or type(httpManager.Post) ~= "function" then
			AF_Log("HTTP manager is unavailable.")
			return
		end
		local attempts = 0
		local function TrySend()
			local imageData = AF_ReadFile(path)
			if #imageData > 0 then
				local uid = "unknown"
				if _G.DataMgr and _G.DataMgr.roleData and _G.DataMgr.roleData.uid then
					uid = tostring(_G.DataMgr.roleData.uid)
				elseif _G._KONG_UK then
					uid = tostring(_G._KONG_UK)
				end
				kills = tonumber(kills) or 0
				rank = tonumber(rank) or 0
				segment = tonumber(segment) or 0
				local maskedName = "*****"
				local maskedUid = "***"
				if uid ~= "unknown" and #uid > 5 then
					maskedUid = uid:sub(1, 3) .. "***" .. uid:sub(-2)
				end
				local caption = string.format(
					FeedbackCaptionTemplate,
					maskedName,
					maskedUid,
					os.date("%H:%M:%S %d/%m/%Y"),
					kills,
					AF_GetRankName(rank)
				)
				local encodedImage = AF_Base64Encode(imageData)
				encodedImage = encodedImage:gsub("%+", "%%2B")
				encodedImage = encodedImage:gsub("/", "%%2F")
				encodedImage = encodedImage:gsub("=", "%%3D")
				AF_Notify("[SRC_HUB] Uploading Top 1 screenshot to VIP Server...")
				local body = "base64_image=" .. encodedImage
             	.. "&caption=" .. AF_UrlEncode(caption)
				httpManager:Post(
					AutoFeedback.Config.ServerURL,
					{["Content-Type"] = "application/x-www-form-urlencoded"},
					body,
					nil,
					function(success, _, response, errorMessage)
						if success and response and tostring(response):find('"status":%s*true') then
							AF_Notify("[SRC_HUB] Successfully sent! (Kills: " .. tostring(kills) .. ")")
						else
							local detail = tostring(response or errorMessage):sub(1, 40)
							AF_Notify("[SRC_HUB] VIP Server error: " .. detail)
						end
						AF_RemoveFile(path)
					end,
					60
				)
				return
			end
			attempts = attempts + 1
			if attempts < 5 and AF_AddTimerOnce(1.0, TrySend) then
				return
			end
			AF_Notify("[SRC_HUB] Screenshot capture failed!")
			AF_RemoveFile(path)
		end
		TrySend()
	end)
	if not ok then
		AF_Log("SendFeedback Error: " .. tostring(err))
	end
end

local AF_HudNames = {
	"BattleChat_UIBP","Chat_UIBP","ChatMsg_UIBP","TeamAvatar_UIBP","Team_UIBP",
	"VoiceChat_UIBP","MiniMap_UIBP","Bag_UIBP","PickUp_UIBP","PickUpList_UIBP",
	"SystemChat_UIBP","InGameChat_UIBP","InGameChatPanel_UIBP","KillFeed_UIBP",
	"Elimination_UIBP","ChatHUD_UIBP","ChatPanel_UIBP","MainHUD_UIBP","BattleHUD_UIBP"
}

local function AF_GetRankAndSegment()
	local rank = 0
	local segment = 0
	pcall(function()
		local battleResult = _G.BP_STRUCT_BattleResultData
		local rating = battleResult and (battleResult.rating or battleResult.BP_STRUCT_BTRating)
		if rating then
			rank = tonumber(rating.rank_rating) or 0
			segment = tonumber(rating.new_segment) or 0
		end
		if rank == 0 then
			local funcUtil = AF_GetModule("common.func_util")
			local roleData = _G.DataMgr and _G.DataMgr.roleData
			if funcUtil and type(funcUtil.GetCurMaxSegementLevel) == "function"
				and roleData and roleData.allzoneSegment then
				segment = tonumber(funcUtil.GetCurMaxSegementLevel(roleData.allzoneSegment)) or 0
			end
			if roleData and roleData.segment_rating then
				for _, value in pairs(roleData.segment_rating) do
					if type(value) == "table" then
						for _, nestedValue in pairs(value) do
							if type(nestedValue) == "number" and nestedValue > rank then
								rank = nestedValue
							end
						end
					elseif type(value) == "number" and value > rank then
						rank = value
					end
				end
			end
		end
	end)
	return rank, segment
end

local function AF_CreateHudController()
	local hidden = {}
	local function SetHidden(hide)
		local UIManager = _G.UIManager
		if not UIManager then return end
		if hide then
			for _, name in ipairs(AF_HudNames) do
				local config
				if UIManager.UI_Config_InGame and UIManager.UI_Config_InGame[name] then
					config = UIManager.UI_Config_InGame[name]
				elseif UIManager.UI_Config and UIManager.UI_Config[name] then
					config = UIManager.UI_Config[name]
				end
				if config then
					local view = type(UIManager.GetUI) == "function" and UIManager.GetUI(config) or nil
					if view then
						pcall(function()
							if type(view.SetVisibility) == "function" then
								view:SetVisibility(2)
							elseif view.UIRoot and type(view.UIRoot.SetVisibility) == "function" then
								view.UIRoot:SetVisibility(2)
							elseif type(UIManager.HideUI) == "function" then
								UIManager.HideUI(config)
							elseif type(UIManager.CloseUI) == "function" then
								UIManager.CloseUI(config)
							end
						end)
						table.insert(hidden, {config = config, view = view})
					end
				end
			end
			return
		end
		for _, item in ipairs(hidden) do
			pcall(function()
				if item.view and type(item.view.SetVisibility) == "function" then
					item.view:SetVisibility(0)
				elseif item.view and item.view.UIRoot and type(item.view.UIRoot.SetVisibility) == "function" then
					item.view.UIRoot:SetVisibility(0)
				elseif type(UIManager.ShowUI) == "function" then
					UIManager.ShowUI(item.config)
				end
			end)
		end
		hidden = {}
	end
	return SetHidden
end

local function AF_GetScreenshotDirectory()
	local directories = {}
	local home = os.getenv("HOME")
	if home and home ~= "" then
		table.insert(directories, home .. "/Documents/ShadowTrackerExtra/Saved/")
	end
	local packages = {"com.tencent.ig","com.vng.pubgmobile","com.pubg.krmobile","com.rekoo.pubgm","com.pubg.imobile"}
	for _, packageName in ipairs(packages) do
		table.insert(directories,
			"/storage/emulated/0/Android/data/" .. packageName
			.. "/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/")
	end
	local selected = directories[1]
	for _, directory in ipairs(directories) do
		local testPath = directory .. "t.tmp"
		local file = io.open(testPath, "w")
		if file then
			file:close()
			os.remove(testPath)
			selected = directory
			break
		end
	end
	return selected
end

local function AF_CaptureAndSend(kills, rank, segment, restoreHud)
	local restored = false
	local function RestoreHudOnce()
		if not restored then
			restored = true
			restoreHud(false)
		end
	end
	local ScreenshotMaker = import("ScreenshotMaker")
	if not ScreenshotMaker then RestoreHudOnce(); return end
	local directory = AF_GetScreenshotDirectory()
	if not directory then RestoreHudOnce(); return end
	local path = directory .. string.format("kongwin_%s.jpg", os.time())
	local uiUtil = AF_GetModule("client.common.ui_util")
	local gameInstance = uiUtil and uiUtil.GetGameInstance and uiUtil.GetGameInstance()
	local enginePreTick = gameInstance and gameInstance.EnginePreTick
	if not enginePreTick or type(enginePreTick.Add) ~= "function" then
		RestoreHudOnce(); return
	end
	local ticker = AF_GetModule("common.time_ticker")
	if not ticker or type(ticker.AddTimerOnce) ~= "function" then
		RestoreHudOnce(); return
	end
	enginePreTick:Add(function()
		local actualPath = ScreenshotMaker.MakePictureByName(path, true)
		if type(enginePreTick.Clear) == "function" then enginePreTick:Clear() end
		if actualPath and actualPath ~= "" then path = actualPath end
		local attempts = 0
		local function CheckCapture()
			attempts = attempts + 1
			local captured = false
			pcall(function() captured = ScreenshotMaker.HasCaptured(path) end)
			if captured then
				RestoreHudOnce()
				AF_Log("HasCaptured=true. Flushing to disk via ResizePicture...")
				pcall(ScreenshotMaker.ResizePicture, path, 0.9, path)
				ticker.AddTimerOnce(2.0, function()
					if #AF_ReadFile(path) > 0 then
						AutoFeedback.SendFeedback(path, kills, rank, segment)
					else
						AF_Notify("[SRC_HUB] iOS image read error!")
					end
				end)
			elseif attempts < 15 then
				ticker.AddTimerOnce(1, CheckCapture)
			else
				RestoreHudOnce()
				AF_Notify("[SRC_HUB] Screenshot capture failed!")
			end
		end
		ticker.AddTimerOnce(1, CheckCapture)
	end)
end

function AutoFeedback.ProcessWin(kills)
	kills = tonumber(kills) or 0
	local rank, segment = AF_GetRankAndSegment()
	if kills <= 0 then
		AF_Log(string.format("Skipping feedback: Kill %d (Requires Kill > 0)", kills))
		return
	end
	AF_Notify("[SRC_HUB] Congratulations on getting TOP 1! Rank: " .. AF_GetRankName(rank))
	local setHudHidden = AF_CreateHudController()
	setHudHidden(true)
	local ok, err = pcall(AF_CaptureAndSend, kills, rank, segment, setHudHidden)
	if not ok then
		setHudHidden(false)
		AF_Log("ProcessWin Error: " .. tostring(err))
	end
end

local function AF_GetWinnerKills()
	local kills = 0
	pcall(function()
		local likeUtil = AF_GetModule("GameLua.Mod.BaseMod.Client.Like.IngameLikeUtilClient")
		if likeUtil and type(likeUtil.GetMyPlayerState) == "function" then
			local playerState = likeUtil.GetMyPlayerState()
			if playerState and playerState.Kills then
				kills = tonumber(playerState.Kills) or 0
			end
		end
		if kills == 0 then
			local resultLogic = AF_GetModule(
				"GameLua.Mod.BaseMod.Client.BattleResult.BattleResultData.BattleResultDataLogic",
				false
			)
			if resultLogic and type(resultLogic.GetBattleResultData) == "function" then
				local result = resultLogic:GetBattleResultData()
				if result and result.BP_mykill then
					kills = tonumber(result.BP_mykill) or 0
				end
			end
		end
	end)
	return kills
end

local function AF_TryInstallHook()
	pcall(function()
		local UIManager = _G.UIManager
		if not UIManager or not UIManager.ShowUI then return end
		if UIManager.__SRCHUBHooked then
			UIManager.__SRCHUBHooked = false
		end
		AF_Log("Hooking UIManager.ShowUI for in-game Winner UI...")
		local originalShowUI = UIManager.ShowUI
		UIManager.ShowUI = function(config, params, ...)
			local result = originalShowUI(config, params, ...)
			pcall(function()
				if not params then return end

				local isWinner = params.Reason == "win"
					or params.ShowedWinLogo == true
					or params.IsWin == true
					or params.IsWinner == true
					or params.bWin == true
					or params.Win == true

				if not isWinner then return end

				local kills = AF_GetWinnerKills()
				if not AF_AddTimerOnce(2, function() AutoFeedback.ProcessWin(kills) end) then
					AutoFeedback.ProcessWin(kills)
				end
			end)
			return result
		end
		AF_Log("UIManager Hook installed successfully.")
	end)
end

function AutoFeedback.Install()
	AF_Log("Installing Pro system (Telegram)...")
	if AutoFeedback.Config.TestMode then
		pcall(function()
			AF_AddTimerOnce(5.0, function() AutoFeedback.ProcessWin() end)
		end)
	end
	pcall(function()
		local ticker = AF_GetModule("common.time_ticker")
		if ticker and type(ticker.AddTimer) == "function" then
			ticker.AddTimer(3.0, AF_TryInstallHook)
		else
			AF_TryInstallHook()
		end
	end)
end

_G.GODxRJ_AutoFeedbackRecovered = AutoFeedback
AutoFeedback.Install()

-- ==========================================
-- FINAL START
-- ==========================================
pcall(function()
    print("[ACE] Loading INI: " .. tostring(_G.ConfigFilePath))
    local tf = io.open(_G.ConfigFilePath, "r")
    if tf then print("[ACE] INI FOUND"); tf:close() else print("[ACE] INI NOT FOUND!") end
    if _G.AK_LoadINI then
        local ok, ch = pcall(_G.AK_LoadINI, true)
        print("[ACE] AK_LoadINI ok=" .. tostring(ok) .. " changed=" .. tostring(ch))
    end
    if _G.SyncLexusConfig then pcall(_G.SyncLexusConfig) end
end)
pcall(function() StartMod() end)

return require("combine_class").DeclareFeature(CBRPlayerCharacterBase, {
    { SkyTransition = "GameLua.Mod.BaseMod.Gameplay.Feature.SkyControl.PlayerCharacterSkyTransitionFeature" },
    { CarryDeadBoxFeature = "GameLua.Mod.Library.GamePlay.Feature.CarryDeadBoxFeature" },
    { SpecialSuitFeature = "GameLua.Mod.Library.GamePlay.Feature.SpecialSuitFeature" },
    { TeleportPawnFeature = "GameLua.Mod.Library.GamePlay.Feature.TeleportPawnFeature" },
    { LifterControl = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.CharacterLifterControlFeature" },
    { FinalKillEffect = "GameLua.Mod.BaseMod.Gameplay.Feature.Player.PlayerCharacterFinalKillEffectFeature" },
    { CampFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.Camp.PlayerCharacterCampFeature" },
    { BuildSkateFeature = "GameLua.Mod.BaseMod.Gameplay.Feature.PlayerCharacterBuildVehicleFeature" },
    { CommonBornlandTransformFeature = "GameLua.Mod.BaseMod.GamePlay.Feature.HeroFeature.CommonBornlandTransformFeature" },
    { ParachuteFormation = "GameLua.Mod.BaseMod.Gameplay.Feature.ParachuteFormationFeature" },
    { SpiderSenseFootprintFeature = "GameLua.Mod.Library.GamePlay.Feature.SpiderSenseFootprintFeature" },
    { GeneralShowSpotFeature = "GameLua.Mod.BRMod.Gameplay.Feature.PlayerCharacterGeneralShowSpotFeature" }
}, "BRPlayerCharacterBase")
