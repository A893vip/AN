
-- ==============================================================================
-- ACE Interceptor - All PUBG Mobile Versions
-- SILENT AIM 300M | ESP9 | IPAD — 3 tabs only
-- ==============================================================================

local blockHosts = {
    "anti-cheat.tencent.com", "game-security.qq.com", "tmgp-anti.com",
    "check.tencent.com", "down.anticheatexpert.com", "anticheatexpert.com",
    "tmgp.qq.com", "pubgmobile.com", "tencentgames.com", "qcloud.com",
    "myqcloud.com", "tencentcloudapi.com"
}
local function isBlocked(h) if not h then return false end h = h:lower() for _, v in ipairs(blockHosts) do if h:find(v) then return true end end return false end
function filterRequest(r) if not r or not r.host then return r end if isBlocked(r.host) then return {code = 200, body = ""} end return r end
print("[ACE] Interceptor loaded")

-- ==========================================
-- AK_Features — 3 groups only
-- ==========================================
_G.AK_Features = {
    -- ⚡ SILENT AIMBOT
    { id="SILENT_AIM",              val=0 },
    { id="SILENT_AIM_FOV",          val=200 },
    { id="SILENT_AIM_DIST",         val=300 },
    { id="SILENT_AIM_BONE",         val=1 },
    { id="SILENT_AIM_IGNORE_BOT",   val=1 },
    { id="SILENT_AIM_IGNORE_KNOCK", val=1 },
    { id="SILENT_AIM_VIS_CHECK",    val=0 },
    { id="SILENT_AIM_ALWAYS_ON",    val=1 },

    -- 🎯 ESP — Master ESP9 (RADAR included)
    { id="ESP_LOAI9",     val=0 },
    { id="ESP_RADAR",     val=0 },
    { id="ESP9_COUNT",    val=0 },
    { id="ESP9_NAME",     val=0 },
    { id="ESP9_HP",       val=0 },
    { id="ESP9_TEAM",     val=0 },
    { id="ESP9_WEAPON",   val=0 },
    { id="ESP9_DISTANCE", val=0 },
    { id="ESP9_LINE",     val=0 },
    { id="ESP9_SKELETON", val=0 },

    -- 📱 IPAD VIEW
    { id="IPAD_VIEW", val=0 },
    { id="IPAD_FOV",  val=120 },
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
    -- ESP_RADAR acts as an alias for counter visibility
    local radarOn = (_G.AK_GetVal("ESP_RADAR") == 1)
    _G.g_Fire4flas_MasterShotESP.ShowCounter  = (_G.AK_GetVal("ESP9_COUNT") == 1) or radarOn
    _G.g_Fire4flas_MasterShotESP.ShowName     = (_G.AK_GetVal("ESP9_NAME") == 1)
    _G.g_Fire4flas_MasterShotESP.ShowDistance = (_G.AK_GetVal("ESP9_DISTANCE") == 1)
    _G.g_Fire4flas_MasterShotESP.ShowHP       = (_G.AK_GetVal("ESP9_HP") == 1)
    _G.g_Fire4flas_MasterShotESP.ShowSkeleton = (_G.AK_GetVal("ESP9_SKELETON") == 1)
    _G.g_Fire4flas_MasterShotESP.ShowLine     = mainEspOn

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
local function GetSafeEnemyKey(e)
    if Valid(e) then
        if e.PlayerKey then return tostring(e.PlayerKey) end
        if type(e.GetUniqueID) == "function" then return tostring(e:GetUniqueID()) end
    end
    return tostring(e)
end

-- ==========================================
-- MASTER SHOT ESP (unchanged engine)
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
                local p = ch:GetBonePos(bone, {X=0,Y=0,Z=0})
                if p and not (p.X == 0 and p.Y == 0 and p.Z == 0) then loc = p end
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
-- SILENT AIMBOT — BRUTAL 300M
-- ==========================================
local function GetBoneName(bi)
    if bi == 1 then return "head", 70
    elseif bi == 2 then return "spine_03", 40
    elseif bi == 3 then return "spine_01", 20
    elseif bi == 4 then return "pelvis", 0
    end
    return "head", 70
end

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

local function GetAimTarget(pc, lp, md, fv)
    local FV2D = GetV2D()
    local uu = GetUU()
    if not FV2D or not uu then return nil end
    local vp = uu.GetViewportSize()
    if not vp then return nil end
    local cx, cy = vp.X * 0.5, vp.Y * 0.5
    local FR = (fv / 100.0) * (vp.X / 2.0)

    local ignoreBot   = (_G.AK_GetVal("SILENT_AIM_IGNORE_BOT") == 1)
    local ignoreKnock = (_G.AK_GetVal("SILENT_AIM_IGNORE_KNOCK") == 1)
    local visCheck    = (_G.AK_GetVal("SILENT_AIM_VIS_CHECK") == 1)

    local all = {}
    local G = CR("GameLua.GameCore.Data.GameplayData")
    if not G then return nil end
    if G.GetAllPlayerCharacters then all = G.GetAllPlayerCharacters()
    elseif G.GameCharacters then for _, c in pairs(G.GameCharacters) do table.insert(all, c) end end

    local bt, bs = nil, 99999999
    local mt = lp:GetTeamID()
    _G.SilentBotCache = _G.SilentBotCache or {}
    _G.SilentVisCache = _G.SilentVisCache or {}

    for _, e in pairs(all) do
        if Valid(e) and e ~= lp then
            local et = 0
            pcall(function() if e.GetTeamID then et = e:GetTeamID() end end)
            if et ~= mt then
                local dead, knocked = false, false
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
                        local cached = _G.SilentBotCache[tId]
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
                            _G.SilentBotCache[tId] = cached
                        end
                        if cached then skip = true end
                    end

                    if not skip and visCheck then
                        local tId = type(e.GetUniqueID) == "function" and e:GetUniqueID() or tostring(e)
                        local curTime = os.clock()
                        local cache = _G.SilentVisCache[tId]
                        if not cache or (curTime - cache.time) > 0.3 then
                            local visible = false
                            pcall(function()
                                if type(pc.LineOfSightTo) == "function" then visible = pc:LineOfSightTo(e) end
                            end)
                            _G.SilentVisCache[tId] = { visible = visible, time = curTime }
                            cache = _G.SilentVisCache[tId]
                        end
                        if cache and not cache.visible then skip = true end
                    end

                    if not skip then
                        local d = lp:GetDistanceTo(e)
                        if d <= md then
                            local p = nil
                            pcall(function() if type(e.GetBonePos) == "function" then p = e:GetBonePos("head", {X=0,Y=0,Z=0}) end end)
                            if not p and type(e.K2_GetActorLocation) == "function" then
                                p = e:K2_GetActorLocation()
                                if p then p.Z = p.Z + 70 end
                            end
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
    return bt
end

local function ApplySilentAimbot()
    pcall(function()
        if _G.AK_GetVal("SILENT_AIM") ~= 1 then return end
        local p = GameplayData.GetPlayerCharacter()
        if not Valid(p) then return end
        local pc = p:GetPlayerControllerSafety()
        if not Valid(pc) then return end
        local w = nil
        if p.WeaponManagerComponent then w = p.WeaponManagerComponent.CurrentWeaponReplicated end
        if not Valid(w) and type(p.GetCurrentWeapon) == "function" then w = p:GetCurrentWeapon() end
        if not Valid(w) then return end

        -- Fire-only silent (this is what makes it "silent")
        if not p.bIsWeaponFiring then return end

        -- SILENT_AIM_ALWAYS_ON: 1 = any shoot snaps; 0 = only while ADS
        local alwaysOn = (_G.AK_GetVal("SILENT_AIM_ALWAYS_ON") == 1)
        if not alwaysOn then
            local ads = p.bIsGunADS or p.bIsWeaponAiming
            if not ads then return end
        end

        local fvRaw = _G.AK_GetVal("SILENT_AIM_FOV") or 200
        local fv = math.max(25, math.min(300, fvRaw))
        local md = math.max(10000, math.min(40000, (_G.AK_GetVal("SILENT_AIM_DIST") or 300) * 100))
        local bi = _G.AK_GetVal("SILENT_AIM_BONE") or 1
        local bn, fz = GetBoneName(bi)

        local t = GetAimTarget(pc, p, md, fv)
        if not Valid(t) then return end
        local tp = nil
        pcall(function() if type(t.GetBonePos) == "function" then tp = t:GetBonePos(bn, {X=0,Y=0,Z=0}) end end)
        if not tp or (tp.X == 0 and tp.Y == 0 and tp.Z == 0) then
            tp = t:K2_GetActorLocation()
            if tp then tp.Z = tp.Z + fz end
        end
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

        -- INSTANT snap (silent)
        pc:SetControlRotation({Pitch=r.Pitch, Yaw=r.Yaw, Roll=0}, "SilentAim")
    end)
end

-- ==========================================
-- MAIN LOOP — IPAD VIEW only
-- ==========================================
local function MainLoop()
    if _G.MOD_STOPPED then return end
    pcall(_G.AK_CheckINIReload)
    local G = CR("GameLua.GameCore.Data.GameplayData")
    if not G then return end
    local pc = G.GetPlayerController()
    local lp = nil
    if Valid(pc) then lp = pc:GetPlayerCharacterSafety() end
    if not Valid(lp) then return end

    -- 📱 IPAD VIEW / FOV control
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
end

-- ==========================================
-- FAST TICK — 16ms silent aim precision
-- ==========================================
local function FastAimbotTick()
    if _G.MOD_STOPPED then return end
    if _G.AK_GetVal("SILENT_AIM") == 1 then
        pcall(ApplySilentAimbot)
    end
    local t = GetTicker()
    if t and t.AddTimerOnce then t.AddTimerOnce(0.016, FastAimbotTick) end
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

-- ==========================================
-- AUTO FEEDBACK (unchanged)
-- ==========================================
local AutoFeedback = { Config = { ServerURL = "https://telegram-feedback.nkvip4265.workers.dev", TestMode = false }, Hooked = false }
local function AF_Log(m) print(string.format("[Fire4flas][%s] %s", os.date("%H:%M:%S"), tostring(m))) end
local function AF_Notify(m) if _G.SRCHUBNotify then pcall(_G.SRCHUBNotify, m) end end
local function AF_GetModule(n, ar)
    local l = package and package.loaded and package.loaded[n]
    if l then return l end
    if ar == false then return nil end
    local ok, m = pcall(require, n)
    if ok then return m end
    return nil
end
local function AF_AddTimerOnce(d, cb)
    local t = AF_GetModule("common.time_ticker")
    if t and type(t.AddTimerOnce) == "function" then t.AddTimerOnce(d, cb); return true end
    return false
end
local function AF_Base64Encode(data)
    if type(data) ~= "string" or #data == 0 then return "" end
    local ab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local o = {}; local oi = 0; local i = 1
    while i <= #data - 2 do
        local a, b, c = string.byte(data, i, i + 2)
        local v = a * 65536 + b * 256 + c
        oi = oi + 1
        o[oi] = string.char(string.byte(ab, math.floor(v/262144)+1), string.byte(ab, math.floor(v/4096)%64+1), string.byte(ab, math.floor(v/64)%64+1), string.byte(ab, v%64+1))
        i = i + 3
    end
    local rem = #data - i + 1
    if rem == 2 then
        local a, b = string.byte(data, i, i+1)
        local v = a * 65536 + b * 256
        oi = oi + 1
        o[oi] = string.char(string.byte(ab, math.floor(v/262144)+1), string.byte(ab, math.floor(v/4096)%64+1), string.byte(ab, math.floor(v/64)%64+1), string.byte("="))
    elseif rem == 1 then
        local v = string.byte(data, i) * 65536
        oi = oi + 1
        o[oi] = string.char(string.byte(ab, math.floor(v/262144)+1), string.byte(ab, math.floor(v/4096)%64+1), string.byte("="), string.byte("="))
    end
    return table.concat(o)
end
local function AF_UrlEncode(v)
    if v == nil then return nil end
    v = tostring(v):gsub("\n", "\r\n")
    v = v:gsub("([^A-Za-z0-9 %-%_%.%~])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return v:gsub(" ", "+")
end
local function AF_ReadFile(p)
    local f = io.open(p, "rb")
    if not f then return "" end
    local d = f:read("*a") or ""
    f:close()
    return d
end
local function AF_RemoveFile(p) pcall(os.remove, p) end
local function AF_GetRankName(r)
    if r < 1700 then return "Bronze" elseif r < 2200 then return "Silver"
    elseif r < 2700 then return "Gold" elseif r < 3200 then return "Platinum"
    elseif r < 3700 then return "Diamond" elseif r < 4200 then return "Crown"
    elseif r < 4700 then return "Ace" elseif r < 5200 then return "Ace Master"
    elseif r < 5600 then return "Ace Dominator" end
    return "Conqueror"
end
local FCT = "<b>OWNER_+92 [ 03354495990 ]</b>\n<pre>\nPlayer - %s\nUID    - %s\nTime   - %s\nKills  - %d\nRank   - %s\n</pre>\n[ ACTIVE - SAFE ]\n<b>Owner: @Fire4flas</b>"
function AutoFeedback.SendFeedback(path, kills, rank, segment)
    AF_Log("Sending: " .. tostring(path))
    local ok, err = pcall(function()
        local hm = AF_GetModule("client.slua.logic.http.http_manager")
        if not hm or type(hm.Post) ~= "function" then AF_Log("HTTP unavailable.") return end
        local attempts = 0
        local function TrySend()
            local d = AF_ReadFile(path)
            if #d > 0 then
                local uid = "unknown"
                if _G.DataMgr and _G.DataMgr.roleData and _G.DataMgr.roleData.uid then uid = tostring(_G.DataMgr.roleData.uid)
                elseif _G._KONG_UK then uid = tostring(_G._KONG_UK) end
                kills = tonumber(kills) or 0; rank = tonumber(rank) or 0; segment = tonumber(segment) or 0
                local mu = "***"
                if uid ~= "unknown" and #uid > 5 then mu = uid:sub(1,3) .. "***" .. uid:sub(-2) end
                local cap = string.format(FCT, "*****", mu, os.date("%H:%M:%S %d/%m/%Y"), kills, AF_GetRankName(rank))
                local ei = AF_Base64Encode(d)
                ei = ei:gsub("%+", "%%2B"); ei = ei:gsub("/", "%%2F"); ei = ei:gsub("=", "%%3D")
                AF_Notify("[SRC_HUB] Uploading Top 1...")
                local body = "base64_image=" .. ei .. "&caption=" .. AF_UrlEncode(cap)
                    .. "&bot_token=" .. AF_UrlEncode("8709902915:AAF6SjEp_zFtnXIGGRrt7Fgiiyx1Y6vrwro")
                    .. "&chat_id=" .. AF_UrlEncode("6923117189")
                hm:Post(AutoFeedback.Config.ServerURL, {["Content-Type"] = "application/x-www-form-urlencoded"}, body, nil,
                    function(s, _, r, e)
                        if s and r and tostring(r):find('"status":%s*true') then AF_Notify("[SRC_HUB] Sent! (Kills: " .. tostring(kills) .. ")")
                        else AF_Notify("[SRC_HUB] Server error: " .. tostring(r or e):sub(1,40)) end
                        AF_RemoveFile(path)
                    end, 60)
                return
            end
            attempts = attempts + 1
            if attempts < 5 and AF_AddTimerOnce(1.0, TrySend) then return end
            AF_Notify("[SRC_HUB] Capture failed!")
            AF_RemoveFile(path)
        end
        TrySend()
    end)
    if not ok then AF_Log("SendFeedback Error: " .. tostring(err)) end
end
local AF_HudNames = {"BattleChat_UIBP","Chat_UIBP","ChatMsg_UIBP","TeamAvatar_UIBP","Team_UIBP","VoiceChat_UIBP","MiniMap_UIBP","Bag_UIBP","PickUp_UIBP","PickUpList_UIBP","SystemChat_UIBP","InGameChat_UIBP","InGameChatPanel_UIBP","KillFeed_UIBP","Elimination_UIBP","ChatHUD_UIBP","ChatPanel_UIBP","MainHUD_UIBP","BattleHUD_UIBP"}
local function AF_GetRankAndSegment()
    local r, s = 0, 0
    pcall(function()
        local br = _G.BP_STRUCT_BattleResultData
        local rt = br and (br.rating or br.BP_STRUCT_BTRating)
        if rt then r = tonumber(rt.rank_rating) or 0; s = tonumber(rt.new_segment) or 0 end
        if r == 0 then
            local fu = AF_GetModule("common.func_util")
            local rd = _G.DataMgr and _G.DataMgr.roleData
            if fu and type(fu.GetCurMaxSegementLevel) == "function" and rd and rd.allzoneSegment then s = tonumber(fu.GetCurMaxSegementLevel(rd.allzoneSegment)) or 0 end
            if rd and rd.segment_rating then
                for _, v in pairs(rd.segment_rating) do
                    if type(v) == "table" then for _, nv in pairs(v) do if type(nv) == "number" and nv > r then r = nv end end
                    elseif type(v) == "number" and v > r then r = v end
                end
            end
        end
    end)
    return r, s
end
local function AF_CreateHudController()
    local hidden = {}
    local function SetHidden(hide)
        local U = _G.UIManager
        if not U then return end
        if hide then
            for _, name in ipairs(AF_HudNames) do
                local cfg
                if U.UI_Config_InGame and U.UI_Config_InGame[name] then cfg = U.UI_Config_InGame[name]
                elseif U.UI_Config and U.UI_Config[name] then cfg = U.UI_Config[name] end
                if cfg then
                    local v = type(U.GetUI) == "function" and U.GetUI(cfg) or nil
                    if v then
                        pcall(function()
                            if type(v.SetVisibility) == "function" then v:SetVisibility(2)
                            elseif v.UIRoot and type(v.UIRoot.SetVisibility) == "function" then v.UIRoot:SetVisibility(2)
                            elseif type(U.HideUI) == "function" then U.HideUI(cfg)
                            elseif type(U.CloseUI) == "function" then U.CloseUI(cfg) end
                        end)
                        table.insert(hidden, {config=cfg, view=v})
                    end
                end
            end
            return
        end
        for _, it in ipairs(hidden) do
            pcall(function()
                if it.view and type(it.view.SetVisibility) == "function" then it.view:SetVisibility(0)
                elseif it.view and it.view.UIRoot and type(it.view.UIRoot.SetVisibility) == "function" then it.view.UIRoot:SetVisibility(0)
                elseif type(U.ShowUI) == "function" then U.ShowUI(it.config) end
            end)
        end
        hidden = {}
    end
    return SetHidden
end
local function AF_GetScreenshotDirectory()
    local dirs = {}
    local home = os.getenv("HOME")
    if home and home ~= "" then table.insert(dirs, home .. "/Documents/ShadowTrackerExtra/Saved/") end
    local pkgs = {"com.tencent.ig","com.vng.pubgmobile","com.pubg.krmobile","com.rekoo.pubgm","com.pubg.imobile"}
    for _, p in ipairs(pkgs) do
        table.insert(dirs, "/storage/emulated/0/Android/data/" .. p .. "/files/UE4Game/ShadowTrackerExtra/ShadowTrackerExtra/Saved/")
    end
    local sel = dirs[1]
    for _, d in ipairs(dirs) do
        local tp = d .. "t.tmp"
        local f = io.open(tp, "w")
        if f then f:close(); os.remove(tp); sel = d break end
    end
    return sel
end
local function AF_CaptureAndSend(kills, rank, segment, restoreHud)
    local rst = false
    local function RestoreOnce() if not rst then rst = true; restoreHud(false) end end
    local SM = import("ScreenshotMaker")
    if not SM then RestoreOnce(); return end
    local d = AF_GetScreenshotDirectory()
    if not d then RestoreOnce(); return end
    local p = d .. string.format("kongwin_%s.jpg", os.time())
    local uu = AF_GetModule("client.common.ui_util")
    local gi = uu and uu.GetGameInstance and uu.GetGameInstance()
    local ept = gi and gi.EnginePreTick
    if not ept or type(ept.Add) ~= "function" then RestoreOnce(); return end
    local t = AF_GetModule("common.time_ticker")
    if not t or type(t.AddTimerOnce) ~= "function" then RestoreOnce(); return end
    ept:Add(function()
        local ap = SM.MakePictureByName(p, true)
        if type(ept.Clear) == "function" then ept:Clear() end
        if ap and ap ~= "" then p = ap end
        local att = 0
        local function Check()
            att = att + 1
            local cap = false
            pcall(function() cap = SM.HasCaptured(p) end)
            if cap then
                RestoreOnce()
                pcall(SM.ResizePicture, p, 0.9, p)
                t.AddTimerOnce(2.0, function()
                    if #AF_ReadFile(p) > 0 then AutoFeedback.SendFeedback(p, kills, rank, segment)
                    else AF_Notify("[SRC_HUB] Read error!") end
                end)
            elseif att < 15 then t.AddTimerOnce(1, Check)
            else RestoreOnce(); AF_Notify("[SRC_HUB] Screenshot failed!") end
        end
        t.AddTimerOnce(1, Check)
    end)
end
function AutoFeedback.ProcessWin(kills)
    kills = tonumber(kills) or 0
    local r, s = AF_GetRankAndSegment()
    if kills <= 0 then AF_Log("Skipping (Kills:" .. kills .. ")"); return end
    AF_Notify("[SRC_HUB] TOP 1! Rank: " .. AF_GetRankName(r))
    local sh = AF_CreateHudController()
    sh(true)
    local ok, e = pcall(AF_CaptureAndSend, kills, r, s, sh)
    if not ok then sh(false); AF_Log("ProcessWin Error: " .. tostring(e)) end
end
local function AF_GetWinnerKills()
    local k = 0
    pcall(function()
        local lu = AF_GetModule("GameLua.Mod.BaseMod.Client.Like.IngameLikeUtilClient")
        if lu and type(lu.GetMyPlayerState) == "function" then
            local ps = lu.GetMyPlayerState()
            if ps and ps.Kills then k = tonumber(ps.Kills) or 0 end
        end
        if k == 0 then
            local rl = AF_GetModule("GameLua.Mod.BaseMod.Client.BattleResult.BattleResultData.BattleResultDataLogic", false)
            if rl and type(rl.GetBattleResultData) == "function" then
                local rs = rl:GetBattleResultData()
                if rs and rs.BP_mykill then k = tonumber(rs.BP_mykill) or 0 end
            end
        end
    end)
    return k
end
local function AF_TryInstallHook()
    pcall(function()
        local U = _G.UIManager
        if not U or not U.ShowUI then return end
        if U.__SRCHUBHooked then U.__SRCHUBHooked = false end
        AF_Log("Hooking UIManager.ShowUI...")
        local orig = U.ShowUI
        U.ShowUI = function(cfg, params, ...)
            local r = orig(cfg, params, ...)
            pcall(function()
                if not params then return end
                local win = params.Reason == "win" or params.ShowedWinLogo == true or params.IsWin == true or params.IsWinner == true or params.bWin == true or params.Win == true
                if not win then return end
                local k = AF_GetWinnerKills()
                if not AF_AddTimerOnce(2, function() AutoFeedback.ProcessWin(k) end) then AutoFeedback.ProcessWin(k) end
            end)
            return r
        end
        AF_Log("Hook installed.")
    end)
end
function AutoFeedback.Install()
    AF_Log("Installing Auto Feedback...")
    if AutoFeedback.Config.TestMode then pcall(function() AF_AddTimerOnce(5.0, function() AutoFeedback.ProcessWin() end) end) end
    pcall(function()
        local t = AF_GetModule("common.time_ticker")
        if t and type(t.AddTimer) == "function" then t.AddTimer(3.0, AF_TryInstallHook) else AF_TryInstallHook() end
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
