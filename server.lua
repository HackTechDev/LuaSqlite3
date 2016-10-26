-- Lua Sqlite3 
--
-- Documentation; http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki
--


sqlite3 = require("lsqlite3")

databaseName = "mt_gandi.sqlite3"

function initDatabase()
    local db = sqlite3.open(databaseName)
    db:exec[[
      CREATE TABLE user (id INTEGER PRIMARY KEY, 
                         firstname CHAR(32),
                         lastname CHAR(32),
                         nickname CHAR(32)
                        );
      CREATE TABLE server (id INTEGER PRIMARY KEY,
                           name CHAR(32),
                           ipv4 CHAR(32),
                           ipv6 CHAR(32)
    ]]
    db:close()
end


-- Lua CRUD method
function insertUser(id, firstname, lastname, nickname)
    local db = sqlite3.open(databaseName)
    local stmt = db:prepare[[ INSERT INTO user VALUES (:id, :firstname, :lastname, :nickname) ]]
    stmt:bind_names{  id = id,  firstname = firstname, lastname = lastname, nickname = nickname  }
    stmt:step()
    stmt:finalize()
    db:close()
end

function selectUser()
    local db = sqlite3.open(databaseName)
    for row in db:nrows("SELECT * FROM user") do
      print(row.id, row.firstname, row.lastname, row.nickname)
      end 
    db:close()
end


function updateUser(id, field, value)
    local db = sqlite3.open(databaseName)
    if field == "nickname" then
        local stmt = db:prepare[[ UPDATE user SET  nickname = :value WHERE id = :id ]]
        stmt:bind_names{  id = id,  value = value  }
        stmt:step()
        stmt:finalize()
    end
    db:close()
end


function deleteUser(id)
    local db = sqlite3.open(databaseName)
    local stmt = db:prepare[[ DELETE FROM user WHERE id = :id ]]
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


-- Insert data
insertUser(1, "Solomon", "Kane", "Nekrofage")
insertUser(2, "Samuel", "Gondouin", "LeSanglier")
insertUser(3, "Black", "Metal", "Nekros")

seperator()

-- Select user
selectUser()

seperator()

-- Update User
updateUser(2, "nickname", "Samglux")

seperator()

-- Select user
selectUser()

seperator()

-- Delete user
deleteUser(3)

seperator()

-- Select user
selectUser()

seperator()
