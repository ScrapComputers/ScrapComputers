dofile("./TextCodec.lua")

---@class Computer.Filesystem
Filesystem = {}

local function split(str)
    local result = {}
    for part in string.gmatch(str, "[^/]+") do
        table.insert(result, part)
    end
    return result
end

local function normalizePath(basePath, path)
    local isAbsolute = path:sub(1, 1) == "/"
    local dirs = {}

    if isAbsolute then
        -- Start from root
    else
        if basePath ~= "/" then
            for _, dir in ipairs(split(basePath)) do
                table.insert(dirs, dir)
            end
        end
    end

    for _, dir in ipairs(split(path)) do
        if dir == ".." then
            if #dirs > 0 then
                table.remove(dirs)
            end
        elseif dir ~= "." and dir ~= "" then
            table.insert(dirs, dir)
        end
    end

    return dirs
end

local function traversePath(tbl, basePath, path)
    local dirs = normalizePath(basePath, path)
    local current = tbl
    for i, dir in ipairs(dirs) do
        if type(current[dir]) == "table" then
            current = current[dir]
        elseif i < #dirs then
            return nil, "Path error: '" .. dir .. "' is not a directory"
        else
            return current, nil, dir, dirs -- return parent for file access
        end
    end
    return current
end

---Creates a new filesystem
---@return self
function Filesystem:createFilesystem()
    local data = {
        currentPath = "/",
        contents = {},
        isEncrypted = false,
        password = "",
        cachedContents = {},
        __hey_computer_please_cast_this_shit = 6969
    }

    return sm.scrapcomputers.table.merge(self, data)
end

---Applies metatable to data to be used as a filesystem
---@return self
function Filesystem:createFilesystemFromRawData(data)
    if data.__hey_computer_please_cast_this_shit == 6969 then
        local data = sm.scrapcomputers.table.clone(data)
        data.isEncrypted = false
        data.password = ""
        data.cachedContents = {}
        
        return sm.scrapcomputers.table.merge(self, data)
    end

    return sm.scrapcomputers.table.merge(self, {
        contents = data,
        currentPath = "/",
        isEncrypted = false,
        password = "",
        cachedContents = {},
        __hey_computer_please_cast_this_shit = 6969
    })
end

---Gets the raw contents of a filesystem instance
---@return table contents The raw contents
function Filesystem:getRawContents()
    return self.contents
end

---Creates information that should be passed through a shared table for syncing filesystems
function Filesystem:createSharedTableInfo()
    return {
        contents = self.contents,
        currentPath = self.currentPath,
        __hey_computer_please_cast_this_shit = 6969
    }
end

---Parses a shared table info to set the filesystem contents
---@param info table The info to parse
---@return self
function Filesystem:createFilesystemFromSharedTableInfo(info)
    sm.scrapcomputers.errorHandler.assertArgument(info, nil, { "table" })

    return sm.scrapcomputers.table.merge(self, {
        contents    = info.contents or {},
        currentPath = info.currentPath or "/",
        isEncrypted = false,
        password = "",
        cachedContents = {},
        __hey_computer_please_cast_this_shit = 6969
    })
end

---Sets the current path
---@param path string The path
function Filesystem:setCurrentPath(path)
    sm.scrapcomputers.errorHandler.assertArgument(path, nil, { "string" })

    local dir, err = traversePath(self.contents, "/", path)
    sm.scrapcomputers.errorHandler.assert(path, 0, err or (type(dir) ~= "table" and "Not a directory"))

    self.currentPath = path
end

---Gets the current path
---@return string The current path
function Filesystem:getCurrentPath()
    return self.currentPath
end

---Resets the current path to /
function Filesystem:resetCurrentPath()
    self.currentPath = "/"
end

---Lists all files in a directory
---@param path string The path to check
---@return table<string, "directory"|"file"> contents The contents of the folder
function Filesystem:list(path)
    sm.scrapcomputers.errorHandler.assertArgument(path, nil, { "string" })

    local dir, err = traversePath(self.contents, "/", path)
    sm.scrapcomputers.errorHandler.assert(path, nil, err or (type(dir) ~= "table" and "Not a directory"))

    local directories = {}
    local files = {}

    for name, value in pairs(dir) do
        if type(value) == "table" then
            table.insert(directories, name)
        else
            table.insert(files, name)
        end
    end

    table.sort(directories, function(a, b) return a < b end)
    table.sort(files, function(a, b) return a < b end)

    local output = {}
    for _, entry in ipairs(directories) do
        table.insert(output, {entry, "directory"})
    end
    for _, entry in ipairs(files) do
        table.insert(output, {entry, "file"})
    end

    return output
end

---Reads a file
---@param path string The file to read
---@return string content The contents of the file
function Filesystem:readFile(path)
    sm.scrapcomputers.errorHandler.assertArgument(path, nil, { "string" })

    local absPath = self:resolve(path)
    if self.cachedContents[absPath] then
        return self.cachedContents[absPath]
    end
    
    local content, err, filename = traversePath(self.contents, self.currentPath, path)
    if err then
        sm.scrapcomputers.errorHandler.assert(nil, nil, err)
    end

    -- If content is a table, it's a directory, not a file
    if type(content) == "table" then
        local dirs = split(path)
        filename = dirs[#dirs]
        local parentPath = table.concat(dirs, "/", 1, #dirs - 1)
        local parent, err = traversePath(self.contents, self.currentPath, parentPath)
        local file = parent and parent[filename]
        if file and type(file) ~= "table" then
            content = file
        else
            sm.scrapcomputers.errorHandler.assert(nil, nil, "File not found or is a directory: " .. (filename or path))
        end
    end

    local decoded = TextCodec:decode(content, self.isEncrypted, self.password)
    self.cachedContents[absPath] = decoded
    return decoded
end

---Creates a new file
---@param path string The path to create the file at
---@param content string The content of the file
function Filesystem:createFile(path, content)
    sm.scrapcomputers.errorHandler.assertArgument(path, 1, { "string" })
    sm.scrapcomputers.errorHandler.assertArgument(content, 2, { "string" })

    local parentPath = path:match("^(.*)/[^/]+$")
    local filename   = path:match("([^/]+)$")

    local parent, err = traversePath(self.contents, self.currentPath, parentPath)
    sm.scrapcomputers.errorHandler.assert(path, 1, err or (type(parent) ~= "table" and "Not a directory"))

    if parent[filename] then
        sm.scrapcomputers.errorHandler.assert(false, 1, "File already exists or a directory is using that name: " .. filename)
    end

    parent[filename] = TextCodec:encode(content, self.isEncrypted, self.currentPath)
    self.cachedContents[self:resolve(path)] = content
end

---Creates a new directory
---@param path string The path to create the directory at
function Filesystem:createDirectory(path)
    sm.scrapcomputers.errorHandler.assertArgument(path, nil, { "string" })

    local parentPath = path:match("^(.*)/[^/]+$")
    local dirname    = path:match("([^/]+)$")

    local parent, err = traversePath(self.contents, self.currentPath, parentPath)
    sm.scrapcomputers.errorHandler.assert(path, nil, err or (type(parent) ~= "table" and "Not a directory"))

    if parent[dirname] then
        sm.scrapcomputers.errorHandler.assert(false, nil, "Directory already exists or a file is using that name: " .. dirname)
    end

    parent[dirname] = {}
end

---Deletes a file or directory
---@param path string The path to delete
function Filesystem:delete(path)
    sm.scrapcomputers.errorHandler.assertArgument(path, nil, { "string" })

    local parentPath = path:match("^(.*)/[^/]+$")
    local name       = path:match("([^/]+)$")

    local parent, err = traversePath(self.contents, self.currentPath, parentPath)
    sm.scrapcomputers.errorHandler.assert(path, nil, err or (type(parent) ~= "table" and "Not a directory"))

    if not parent[name] then
        sm.scrapcomputers.errorHandler.assert(path, nil, "File or directory does not exist: " .. name)
    end

    parent[name] = nil
    self.cachedContents[self:resolve(path)] = nil
end

---Renames a file or directory
---@param oldPath string The current path of the file or directory
---@param newPath string The new path for the file or directory
function Filesystem:rename(oldPath, newPath)
    sm.scrapcomputers.errorHandler.assertArgument(oldPath, 1, { "string" })
    sm.scrapcomputers.errorHandler.assertArgument(newPath, 2, { "string" })

    local oldParentPath = oldPath:match("^(.*)/[^/]+$")
    local oldName       = oldPath:match("([^/]+)$")

    local newParentPath = newPath:match("^(.*)/[^/]+$")
    local newName       = newPath:match("([^/]+)$")
    
    local oldParent, err = traversePath(self.contents, self.currentPath, oldParentPath)
    sm.scrapcomputers.errorHandler.assert(oldPath, nil, err or (type(oldParent) ~= "table" and "Not a directory"))

    if not oldParent[oldName] then
        sm.scrapcomputers.errorHandler.assert(oldPath, 1, "File or directory does not exist: " .. oldName)
    end

    local newParent, err = traversePath(self.contents, self.currentPath, newParentPath)
    sm.scrapcomputers.errorHandler.assert(newPath, nil, err or (type(newParent) ~= "table" and "Not a directory"))

    if newParent[newName] then
        sm.scrapcomputers.errorHandler.assert(newPath, 2, "File or directory already exists: " .. newName)
    end

    newParent[newName] = oldParent[oldName]
    oldParent[oldName] = nil
end

---Checks if a path exists
---@param path string The path to check
---@return boolean exists True if the path exists, false otherwise
function Filesystem:exists(path)
    sm.scrapcomputers.errorHandler.assertArgument(path, nil, { "string" })

    local dirs = normalizePath(self.currentPath, path)
    if #dirs == 0 then
        return true
    end

    local current = self.contents
    for i, dir in ipairs(dirs) do
        if type(current) ~= "table" then
            return false
        end

        current = current[dir]
        if current == nil then
            return false
        end
    end

    return true
end

---Checks if a path is a directory
---@param path string The path to check
---@return boolean isDir True if the path is a directory, false otherwise
function Filesystem:isDirectory(path)
    sm.scrapcomputers.errorHandler.assertArgument(path, nil, { "string" })

    local dir, err = traversePath(self.contents, self.currentPath, path)
    if err then
        return false
    end

    return type(dir) == "table"
end

---Checks if a path is a file
---@param path string The path to check
---@return boolean isFile True if the path is a file, false otherwise
function Filesystem:isFile(path)
    sm.scrapcomputers.errorHandler.assertArgument(path, nil, { "string" })

    return not self:isDirectory(path)
end

---Writes data to a file, creating it if it doesn't exist (unless specified otherwise)
---@param path string The path to the file
---@param data string The data to write
---@param createIfNotExists boolean Whether to create the file if it doesn't exist (default: true)
function Filesystem:writeToFile(path, data, createIfNotExists)
    sm.scrapcomputers.errorHandler.assertArgument(path, 1, { "string" })
    sm.scrapcomputers.errorHandler.assertArgument(data, 2, { "string" })
    sm.scrapcomputers.errorHandler.assertArgument(createIfNotExists, 3, { "boolean", "nil" })

    createIfNotExists = type(createIfNotExists) == "nil" and true or createIfNotExists

    if not self:exists(path) then
        if createIfNotExists then
            local parentPath = path:match("^(.*)/[^/]+$")
            if parentPath then
                local createDirPath = "/"
                for part in parentPath:gmatch("[^/]+") do
                    createDirPath = createDirPath .. part

                    if not self:exists(createDirPath) then
                        self:createDirectory(createDirPath)
                    end
                end
            end
            
            self:createFile(path, data)
        else
            sm.scrapcomputers.errorHandler.assert(path, 1, "File does not exist: " .. path)
        end
    else
        local parentPath = path:match("^(.*)/[^/]+$")
        local filename   = path:match("([^/]+)$")

        local parent, err = traversePath(self.contents, self.currentPath, parentPath)
        sm.scrapcomputers.errorHandler.assert(path, 1, err or (type(parent) ~= "table" and "Not a directory"))

        parent[filename] = TextCodec:encode(data, self.isEncrypted, self.password)
        self.cachedContents[self:resolve(path)] = data
    end
end

---Resolves a relative path to an absolute path
---@param path string The path to resolve
---@return string absolutePath The resolved absolute path
function Filesystem:resolve(path)
    sm.scrapcomputers.errorHandler.assertArgument(path, nil, { "string" })
    local dirs = normalizePath(self.currentPath, path)
    return "/" .. table.concat(dirs, "/")
end

function Filesystem:enableEncryption(password)
    sm.scrapcomputers.errorHandler.assertArgument(password, 1, { "string" })

    if self.isEncrypted then
        sm.scrapcomputers.errorHandler.assert(false, 1, "Filesystem is already encrypted.")
        return
    end

    self.password = password
    self.isEncrypted = true

    local function encryptRecursive(tbl, currentPath)
        for name, value in pairs(tbl) do
            if type(value) == "table" then
                encryptRecursive(value, currentPath .. "/" .. name)
            else
                tbl[name] = TextCodec:encode(TextCodec:decode(value, false, nil), true, password)
            end
        end
    end

    self.cachedContents = {}

    encryptRecursive(self.contents, "/")
end


function Filesystem:disableEncryption()
    if not self.isEncrypted then
        sm.scrapcomputers.errorHandler.assert(false, nil, "Filesystem is not encrypted.")
        return
    end

    local function decryptRecursive(tbl, currentPath)
        for name, value in pairs(tbl) do
            if type(value) == "table" then
                decryptRecursive(value, currentPath .. "/" .. name)
            else
                tbl[name] = TextCodec:encode(TextCodec:decode(value, true, self.password), false, nil)
            end
        end
    end

    self.cachedContents = {}

    decryptRecursive(self.contents, "/")
    self.isEncrypted = false
    self.password = ""
end


function Filesystem:enterEncryptionPassword(password)
    sm.scrapcomputers.errorHandler.assertArgument(password, 1, { "string" })

    local success, _ = pcall(TextCodec.decode, TextCodec, self.contents["Main.lua"], true, password)
    if not success then
        return false
    end

    self.cachedContents = {}

    self.isEncrypted = true
    self.password = password
    return true
end
