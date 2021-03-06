--Main Library
local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
local Lang = module("lib/Lang")
sha2 = module("lib/sha2") -- encryption library

--Main Configuration
local config = module("config/base")

--Main Proxy
vRP = {}
Proxy.addInterface("vRP",vRP)

--MySQL Functions
vRP.MySQL = {}
vRP.MySQL = module("lib/MySQL")

--Main Tunnel
tvRP = {}
Tunnel.bindInterface("vRP",tvRP)

--Main Client
vRPclient = Tunnel.getInterface("vRP","vRP")


vRP.requests = {}
vRP.users = {}

--Database Generator
vRP.MySQL.createCommand("base_tables",[[
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `username` varchar(24) DEFAULT NULL,
  `email` longtext DEFAULT NULL,
  `password` longtext DEFAULT NULL,
  `data` longtext DEFAULT NULL,
  `banned` tinyint(1) NOT NULL DEFAULT 0,
  `whitelisted` tinyint(1) NOT NULL DEFAULT 0,
  `registered_date` date DEFAULT NULL,
  `last_login_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `homes` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `data` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `inventories` (
  `id` varchar(24) NOT NULL PRIMARY KEY,
  `data` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `vehicles` (
  `vehicle_plate` varchar(255) NOT NULL PRIMARY KEY,
  `vehicle` varchar(255) NOT NULL,
  `owner` int(11) DEFAULT NULL,
  `data` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
]])
vRP.MySQL.execute("base_tables")

--Main Functions
function vRP.getPlayerEndpoint(player)
  return GetPlayerEP(player) or "0.0.0.0"
end

function vRP.isLoggedIn(source)
  for i,v in pairs(vRP.users) do
      if i == source then
          return true
      end
  end
  
  return false
end

function vRP.getUserSource(id)
  for i,v in pairs(vRP.users) do
      if v.id == id then
          return i
      end
  end
end

function vRP.getUserId(source)
  return vRP.users[source].id or -1
end

function vRP.getUserName(source)
  return vRP.users[source].username
end

function vRP.isBanned(user_id)
  return vRP.users[source].data.banned
end

function vRP.setBanned(user_id,banned)
  vRP.users[source].data.banned = banned
end

function vRP.isWhitelisted(user_id)
  return vRP.users[source].data.whitelisted
end

function vRP.setWhitelisted(user_id,whitelisted)
  vRP.users[source].data.whitelisted = whitelisted
end

function vRP.getUserDataTable(user_id)
  return vRP.users[user_id].data
end

function vRP.isPlayerConnected(user_id)
  return vRP.users[source] ~= nil
end

function vRP.getUsers()
  return vRP.users
end

function vRP.ban(user_id,reason)
  if user_id ~= nil then
    vRP.setBanned(user_id,true)
    vRP.kick(source,"[Banned] "..reason)
  end
end

function vRP.kick(source,reason)
  DropPlayer(source,reason)
end

function vRP.Vdist(x1,y1,z1,x2,y2,z2)
  return math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) + (z2-z1)*(z2-z1))
end

--Main Save Event ( used for saving data to sql )
RegisterServerEvent("vRP:save")
Citizen.CreateThread(function()
    while true do
        Wait(config.time_db_save*1000)
        print("vRP | Database saved all data!")
        TriggerEvent("vRP:save")
    end
end)
