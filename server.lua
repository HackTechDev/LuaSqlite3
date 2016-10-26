-- Lua Sqlite3 
--
-- Documentation; http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki
--


sqlite3 = require("lsqlite3")

databaseName = "mt_gandi.sqlite3"

function initDatabase()
    local db = sqlite3.open(databaseName)
    db:exec[[
      CREATE TABLE server (id INTEGER PRIMARY KEY AUTOINCREMENT,  
                         hostname CHAR(32),
                         ipv4name CHAR(32),
                         ipv6 CHAR(32)
                        );

    ]]
    db:close()
end


-- Lua CRUD method
function insertServer(hostname, ipv4name, ipv6)
    local db = sqlite3.open(databaseName)
    local stmt = db:prepare[[ INSERT INTO server VALUES (null, :hostname, :ipv4name, :ipv6) ]]
    stmt:bind_names{ hostname = hostname, ipv4name = ipv4name, ipv6 = ipv6  }
    stmt:step()
    stmt:finalize()
    db:close()
end

function selectServer()
    local db = sqlite3.open(databaseName)
    for row in db:nrows("SELECT * FROM server") do
      print(row.id, row.hostname, row.ipv4name, row.ipv6)
    end 
    db:close()
end


function updateServer(id, field, value)
    local db = sqlite3.open(databaseName)
    if field == "ipv6" then
        local stmt = db:prepare[[ UPDATE server SET  ipv6 = :value WHERE id = :id ]]
        stmt:bind_names{  id = id,  value = value  }
        stmt:step()
        stmt:finalize()
    end
    db:close()
end


function deleteServer(id)
    local db = sqlite3.open(databaseName)
    local stmt = db:prepare[[ DELETE FROM server WHERE id = :id ]]
    stmt:bind_names{  id = id }
    stmt:step()
    stmt:finalize()
    db:close()
end


function seperator()
    print("-----------------------")
end

-- Init database
initDatabase()


insertServer("Solomon", "Kane", "Nekrofage")
insertServer("Samuel", "Gondouin", "LeSanglier")
insertServer("Black", "Metal", "Nekros")

seperator()

selectServer()
seperator()

updateServer(2, "ipv6", "Samglux")

seperator()

selectServer()

seperator()

deleteServer(3)

seperator()

selectServer()

seperator()
