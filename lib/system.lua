hsystem = {
    --获取一个对象的id
    getObjId = function(idChar)
        local i = string.byte(idChar, 1)
        i = i * 256 + string.byte(idChar, 2)
        i = i * 256 + string.byte(idChar, 3)
        i = i * 256 + string.byte(idChar, 4)
        return i
    end,
    --获取一个对象的id字符串
    getObjChar = function(id)
        return string.char(id // 0x1000000)
                .. string.char(id // 0x10000 % 0x100)
                .. string.char(id // 0x100 % 0x100)
                .. string.char(id % 0x100)
    end,
    --获取一个table的正确长度
    getTableLen = function(table)
        local len = 0
        for k, v in pairs(table) do
            len = len + 1
        end
        return len
    end,
    --在数组内
    inArray = function(val, arr)
        local isin = false
        for k, v in pairs(arr) do
            if (v == val) then
                isin = true
                break
            end
        end
        return isin
    end,
    --打印对象table
    print_r = function(t)
        local print_r_cache = {}
        local function sub_print_r(tt, indent)
            if (print_r_cache[tostring(tt)]) then
                print(indent .. "*" .. tostring(tt))
            else
                print_r_cache[tostring(tt)] = true
                if (type(tt) == "table") then
                    for pos, val in pairs(tt) do
                        if (type(val) == "table") then
                            print(indent .. "[" .. pos .. "] => " .. tostring(tt) .. " {")
                            sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
                            print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                        elseif (type(val) == "string") then
                            print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                        else
                            print(indent .. "[" .. pos .. "] => " .. tostring(val))
                        end
                    end
                else
                    print(indent .. tostring(tt))
                end
            end
        end
        if (type(t) == "table") then
            print(tostring(t) .. " {")
            sub_print_r(t, "  ")
            print("}")
        else
            sub_print_r(t, "  ")
        end
        print()
    end,

    --转义
    addslashes = function(s)
        local in_char = { '\\', '"', '/', '\b', '\f', '\n', '\r', '\t' }
        local out_char = { '\\', '"', '/', 'b', 'f', 'n', 'r', 't' }
        for i, c in ipairs(in_char) do
            s = s:gsub(c, '\\' .. out_char[i])
        end
        return s
    end,
    --反转义
    stripslashes = function(s)
        local in_char = { '\\', '"', '/', 'b', 'f', 'n', 'r', 't' }
        local out_char = { '\\', '"', '/', '\b', '\f', '\n', '\r', '\t' }

        for i, c in ipairs(in_char) do
            s = s:gsub('\\' .. c, out_char[i])
        end
        return s
    end,

    base64encode = function(source_str)
        local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        local s64 = ''
        local str = source_str

        while #str > 0 do
            local bytes_num = 0
            local buf = 0

            for byte_cnt = 1, 3 do
                buf = (buf * 256)
                if #str > 0 then
                    buf = buf + string.byte(str, 1, 1)
                    str = string.sub(str, 2)
                    bytes_num = bytes_num + 1
                end
            end

            for group_cnt = 1, (bytes_num + 1) do
                local b64char = math.fmod(math.floor(buf / 262144), 64) + 1
                s64 = s64 .. string.sub(b64chars, b64char, b64char)
                buf = buf * 64
            end

            for fill_cnt = 1, (3 - bytes_num) do
                s64 = s64 .. '='
            end
        end

        return s64
    end,
    base64Decode = function(str64)
        local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
        local temp = {}
        for i = 1, 64 do
            temp[string.sub(b64chars, i, i)] = i
        end
        temp['='] = 0
        local str = ""
        for i = 1, #str64, 4 do
            if i > #str64 then
                break
            end
            local data = 0
            local str_count = 0
            for j = 0, 3 do
                local str1 = string.sub(str64, i + j, i + j)
                if not temp[str1] then
                    return
                end
                if temp[str1] < 1 then
                    data = data * 64
                else
                    data = data * 64 + temp[str1] - 1
                    str_count = str_count + 1
                end
            end
            for j = 16, 0, -8 do
                if str_count > 0 then
                    str = str .. string.char(math.floor(data / math.pow(2, j)))
                    data = math.mod(data, math.pow(2, j))
                    str_count = str_count - 1
                end
            end
        end

        local last = tonumber(string.byte(str, string.len(str), string.len(str)))
        if last == 0 then
            str = string.sub(str, 1, string.len(str) - 1)
        end
        return str
    end

}
