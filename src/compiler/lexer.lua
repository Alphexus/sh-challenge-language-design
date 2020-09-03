local lexer = {}
lexer.__index = lexer

local KEYWORDS = {["let"]=1, ["return"]=1} 
local PUNCTUATORS = {[","]=1, ["("]=1, [")"]=1}
local OPERATORS = {
    ["$"]=1, ["-"]=1, 
    ["+"]=1, ["*"]=1, 
    ["/"]=1, ["%"]=1, 
    ["^"]=1, ["="]=1
}

function lexer.new(src)
    return setmetatable({
        Source = src,
        Tokens = {}
    }, lexer)
end

function lexer:lex()
    local source = self.Source
    local tokens = self.Tokens
    
    local nextToken = {}
    local str = ""
    local inComment = false

    for i = 1, #source do
        local char = source:sub(i,i)
        local foundToken = false

        if char == "#" then
            inComment = true
        end

        if inComment then
            if str:sub(#str,#str) .. char == "\n" then
                inComment = false
            else
                goto forEnd
            end  
        end

        if KEYWORDS[str] then
            nextToken[1] = "keyword"
        elseif PUNCTUATORS[str] then
            nextToken[1] = "punctuator"
        elseif OPERATORS[str] then
            nextToken[1] = "operator"
        elseif char == " " then
            local c = str:sub(1,1)
            if tonumber(c) then
                if tonumber(str) then
                    nextToken[1] = "number"
                end
            else
                nextToken[1] = "identifier"
            end
        end

        if nextToken[1] then
            nextToken[2] = str
            table.insert(tokens, nextToken)
            nextToken = {}
            str = ""
        end

        str = str .. char
        ::forEnd::
    end
end

return lexer