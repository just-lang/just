-- Lua code to tokenize another Lua code
function tokenizeLuaCode(code)
    local tokens = {}
    local index = 1

    while index <= #code do
        local char = code:sub(index, index)

        -- Skip whitespace
        if char:match("%s") then
            index = index + 1

        -- Handle comments
        elseif char == "-" and code:sub(index + 1, index + 1) == "-" then
            local _, endIndex = code:find("\n", index + 2)
            if not endIndex then
                endIndex = #code
            end
            table.insert(tokens, code:sub(index, endIndex))
            index = endIndex + 1

        -- Handle strings
        elseif char:match("[\"']") then
            local startChar = char
            local _, endIndex = code:find(startChar .. "[^\\" .. startChar .. "]*" .. startChar, index)
            if endIndex then
                table.insert(tokens, code:sub(index, endIndex))
                index = endIndex + 1
            else
                error("Unterminated string at index " .. index)
            end

        -- Handle identifiers and keywords
        elseif char:match("%a") or char == "_" then
            local _, endIndex = code:find("[%w_]+", index)
            table.insert(tokens, code:sub(index, endIndex))
            index = endIndex + 1

        -- Handle numbers
        elseif char:match("%d") or (char == "." and code:sub(index + 1, index + 1):match("%d")) then
            local _, endIndex = code:find("[%d%.]+", index)
            table.insert(tokens, code:sub(index, endIndex))
            index = endIndex + 1

        -- Handle operators and symbols
        else
            local _, endIndex = code:find("[%+%-%*%/%^%%%=<>#;{},%(%)]+", index)
            table.insert(tokens, code:sub(index, endIndex))
            index = endIndex + 1
        end
    end

    return tokens
end

-- Example usage
local luaCode = "local x = 42 + 5 -- This is a comment\nprint('Hello, world!')"
local tokens = tokenizeLuaCode(luaCode)

-- Print the tokens
for _, token in ipairs(tokens) do
    print(token)
end
