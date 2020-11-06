--[[--Open source string library that supplies additional LUA string functions
@module string
@author YuchengMo

Date   2018-05-08 15:45:21
Last Modified by   YuchengMo
Last Modified time 2020-11-06 09:35:47
]]

-- local string = {};
-- Allows the ability to index into a string using square-bracket notation
-- For example:
--        s = "hello"
--        s[1] = "h"

local mt = getmetatable('')
mt.__index = function(str, i)
    if (type(i) == 'number') then
        return string.sub(str, i, i)
    end

    return string[i]
end

mt.__sub = function(str, pattern)
	return str:remove(pattern)
end

mt.__add = function(str1, str2)
	return str1:concat(str2)
end


-- Allows the ability to index into a string like above, but using normal brackes to
-- return the substring
-- For example:
--        s = "hello"
--        s(2,5) = "ello"
--
-- However, it also allows indexing into the string to return the byte (unicode) value
-- of the character found at the index. This only occurs if the second value is omitted
-- For example:
--      s = "hello"
--      s(2) = 101 (e)
--
-- Furthermore, it also allows for the ability to replace a character at the given index
-- with the given characters, iff the second value is a string
-- For example:
--        s = "hello"
--        s(2,'p') = "hpllo"
mt.__call = function(str, i, j)
    if (type(i) == 'number' and type(j) == 'number') then
        return string.sub(str, i, j)
    elseif (type(i) == 'number' and type(j) == 'string') then
        return table.concat{string.sub(str, 1, i - 1), j, string.sub(str, i + 1)}
    elseif (type(i) == 'number' and type(j) == 'nil') then
        return string.byte(str, i)
    end

    return string[i]
end

--[[--
	判断字符串是否以chars开头
	@tparam string str 目标字符串
	@tparam string chars 开头字符串
	@return boolean true|false str是否以chars开头
	@usage
	string.starts_with("xixixi","xi") -- true
]]
function string.starts_with(str, chars)
    return chars == '' or string.sub(str, 1, string.len(chars)) == chars
end

--[[--
	判断字符串是否以chars结尾
	@tparam string str 目标字符串
	@tparam string chars 结尾字符串
	@return boolean true|false str是否以chars结尾
	@usage
	string.ends_with("213123xi","xi") -- true
]]
function string.ends_with(str, chars)
    return chars == '' or string.sub(str, -string.len(chars)) == chars
end

--[[--
	移除str开头的N个字符
	@tparam string str 目标字符串
	@tparam number|string length 长度n,如果是字符，则移除该字符长度
	@return string 移除后的str,如果length非法，则返回原本的str
	@usage
	string.remove_from_start("213123xi",3) -- "123xi"
]]
function string.remove_from_start(str, length)
    if (type(length) == 'number') then
        return string.sub(str, length + 1, string.len(str))
    elseif (type(length) == 'string') then
        return string.sub(str, string.len(length) + 1, string.len(str))
    else
        return str
    end
end

--[[--
	移除str结尾的n个字符
	@tparam string str 目标字符串
	@tparam number|string length 长度n,如果是字符，则移除该字符长度
	@return string 移除后的str,如果length非法，则返回原本的str
	@usage
	string.remove_from_end("213123xi",3) -- "21312"
]]
function string.remove_from_end(str, length)
    if (type(length) == 'number') then
        return string.sub(str, 1, string.len(str) - length)
    elseif (type(length) == 'string') then
        return string.sub(str, 1, string.len(str) - string.len(length))
    else
        return str
    end
end

--[[--
	移除str中符合pattern模式的子串,最多不超过limit个
	@tparam string str 目标字符串
	@tparam string pattern 匹配模式
	@tparam number limit 移除上限
	@return string 移除后的字符串
	@usage
	string.remove("213123xi","3",1) -- "21123xi"
]]
function string.remove(str, pattern, limit)
    if (pattern == '' or pattern == nil) then
        return str
    end

    if (limit == '' or limit == nil) then
        str = string.gsub(str, pattern, '')
    else
        str = string.gsub(str, pattern, '', limit)
    end
    return str
end

--[[--
	通过concatStr拼接2个字符串
	@tparam string str1 字符串1
	@tparam string str2 字符串2
	@tparam string concatStr 拼接字符串
	@return string str1..concatStr..str2
	@usage
	string.concat("213123xi","3","bb") -- "213123xibb3"
]]
function string.concat(str1, str2, concatStr)
    local ret =  table.concat({str1, str2}, concatStr)
    return ret
end

--[[--
	移除str中符合pattern模式的所有子串
	@tparam string str 目标字符串
	@tparam string pattern 匹配模式
	@return string 移除后的字符串
	@usage
	string.remove_all("213123xi","3") -- "2112xi"
]]
function string.remove_all(str, pattern)
    if (pattern == '' or pattern == nil) then
        return str
    end

    str = string.gsub(str, pattern, '')
    return str
end

--[[--
	移除str中符合pattern模式的第一个子串
	@tparam string str 目标字符串
	@tparam string pattern 匹配模式
	@return string 移除后的字符串
	@usage
	string.remove_first("213123xi","3") -- "21123xi"
]]
function string.remove_first(str, pattern)
    if (pattern == '' or pattern == nil) then
        return str
    end

    str = string.gsub(str, pattern, '', 1)
    return str
end

--[[--
	判断str是否包含符合pattern的字串
	@tparam string str 目标字符串
	@tparam string pattern 匹配模式
	@return boolean 是否包含
	@usage
	string.contains("213123xi","3") -- true
]]
function string.contains(str, pattern)
    if (pattern == '' or string.find(str, pattern, 1)) then
        return true
    end

    return false
end

--[[--
	查找str中pattern子串的位置(大小写不敏感)
	@tparam string str 目标字符串
	@tparam string pattern 匹配模式
	@return number,number 子串开始和结束为止|nil
	@usage
	string.findi("xi","xi") -- 1,2
]]
function string.findi(str, pattern)
    return string.find(string.lower(str), string.lower(pattern), 1)
end

--[[--
	获取str中某个位置开始的符合pattern的子串
	@tparam string str 目标字符串
	@tparam string pattern 匹配模式
	@tparam number start 起始位置，默认为1
	@return string substr 字串
	@usage
	string.find_pattern("s1x123x2","x.",5) -- x2
]]
function string.find_pattern(str, pattern, start)
    if (pattern == '' or pattern == nil) then
        return ''
    end

    if (start == '' or start == nil) then
        start = 1
    end
    local s,e = string.find(str, pattern, start)
    if s and e then
        return string.sub(str, s,e)
    else
        return ""
    end
end

--[[--
	按照分隔符delimiter分割字符串成table
	@tparam string str 目标字符串
	@tparam string delimiter 分隔符
	@return table 被分割的表
	@usage 
	local a = string.split("axbxc","x")
	a = {a,b,c} 
]]
function string.split(str, delimiter)
    if (delimiter == '') then return false end
    local pos, arr = 0, {}
    -- for each divider found
    for st, sp in function() return string.find(str, delimiter, pos, true) end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end

--[[--
	将str中的单词提取成table的形式
	@tparam string str 目标字符串
	@return table 单词表
	@usage 
	local a = string.to_word_array("a b c")
	a = {a,b,c} 
]]
function string.to_word_array(str)
    local words = {}
    local index = 1

    for word in string.gmatch(str, '%w+') do
        words[index] = word
        index = index + 1
    end

    return words
end

--[[--
	返回字符串包含的字母数量
	@tparam string str 目标字符串
	@return number  字母数量
	@usage 
	local a = string.letter_count("a b c")-- 3
]]
function string.letter_count(str)
    local _, count = string.gsub(str, '%a', '')
    return count
end

--[[--
	返回字符串包含的空格数量
	@tparam string str 目标字符串
	@return number  空格数量
	@usage 
	local a = string.space_count("a b c")-- 2
]]
function string.space_count(str)
    local _, count = string.gsub(str, '%s', '')
    return count
end

--[[--
	返回字符串包含pattern字串的数量
	@tparam string str 目标字符串
	@tparam string pattern 字串模式
	@return number  字串的数量
	@usage 
	local a = string.pattern_count("a b c","%w")-- 3
]]
function string.pattern_count(str, pattern)
    if (pattern == '' or pattern == nil) then
        return nil
    end

    local _, count = string.gsub(str, pattern, '')
    return count
end

--[[--
	统计字符串中出现的所有字符的个数
	@tparam string str 目标字符串
	@return table  统计完的表{"char"=count,...}
	@usage 
	local a = string.char_totals("a b c")
	a = {
		a = 1,
		b = 1,
		c = 1,
		" " = 2,
	}
]]
function string.char_totals(str)
    local totals = {}
    local temp = ''

    for i = 1, string.len(str), 1 do
        temp = str[i]
        if (totals[temp]) then
            totals[temp] = totals[temp] + 1
        else
            totals[temp] = 1
        end
    end

    return totals
end

--[[--
	模糊搜索，返回true、false,匹配单词中如果含有特殊字符串，返回false
	@tparam string sourceStr 目标字符串
	@tparam string searchStr 被搜索str
	@return boolean  是否包含searchStr的按顺序出现的字符
	@usage 
	local a = string.fuzzy_match("axxbxxc","abc") -- true
	local a = string.fuzzy_match("axxcxxb","abc") -- false
]]
function string.fuzzy_match(sourceStr,  searchStr)
    if string.find(searchStr,"[().%+-*?[^$]")then
        return
    end
    sourceStr = string.upper(sourceStr)
    searchStr = string.upper(searchStr)
    searchStr = string.gsub(searchStr,"",".*")
    if string.find(sourceStr,searchStr) then
        return true
    end
end

--[[--
	返回str中包含的单词个数
	@tparam string str 目标字符串
	@return number  单词个数
	@usage 
	local a = string.word_count("aaa bb c") -- 3
]]
function string.word_count(str)
    local _, count = string.gsub(str, '%w+', '')
    return count
end

--[[--
	返回str中所有单词长度组成的字符串
	@tparam string str 目标字符串
	@return string  单词长度字符串
	@usage 
	local a = string.word_lengths("aaa bb c") -- "3 2 1"
]]
function string.word_lengths(str)
    local lengths = string.gsub(str, '%w+', function(w) return string.len(w) end)
    return lengths
end

--[[--
	返回str中所有单词出现的次数统计表
	@tparam string str 目标字符串
	@return table  单词次数表{"word" = count,...}
	@usage 
	local a = string.word_totals("aaa bb c")
	a = {
		aaa = 1,
		bb = 1,
		c = 1,
	}
]]
function string.word_totals(str)
    local totals = {}

    for word in string.gmatch(str, '%w+') do
        if (totals[word]) then
            totals[word] = totals[word] + 1
        else
            totals[word] = 1
        end
    end

    return totals
end

--[[--
	获取str中所有字符的byte
	@tparam string str 目标字符串
	@return table  byte{1 = byte1,...}
	@usage 
	local a = string.to_byte_array("abc")
	a = {97,98,99}
]]
function string.to_byte_array(str)
    local bytes = {}

    for i = 1, string.len(str), 1 do
        bytes[i] = string.byte(str, i)
    end

    return bytes
end

--[[--
	将str装换为char table
	@tparam string str 目标字符串
	@return table  charsTable,{1 = char1,...}
	@usage 
	local a = string.to_byte_array("abc")
	a = {"a","b","c"}
]]
function string.to_char_array(str)
    local chars = {}

    for i = 1, string.len(str), 1 do
        chars[i] = str[i]
    end

    return chars
end

--[[--
	将str中匹配pattern的字符转为大写，并返回所有匹配到的结果连接起来的字符串
	@tparam string str 目标字符串
	@tparam string pattern 模式
	@return string  "match1 match2 "...
	@usage 
	local a = string.pattern_to_upper("a b c","%w") --  "A B C"
]]
function string.pattern_to_upper(str, pattern)
    if (pattern == '' or pattern == nil) then
        return str
    end

    local upper = string.gsub(str, pattern, string.upper)
    return upper
end

--[[--
	将str中匹配pattern的字符转为小写，并返回所有匹配到的结果连接起来的字符串
	@tparam string str 目标字符串
	@tparam string pattern 模式
	@return string  "match1 match2 "...
	@usage 
	local a = string.pattern_to_lower("A B C","%w") --  "a b c"
]]
function string.pattern_to_lower(str, pattern)
    if (pattern == '' or pattern == nil) then
        return str
    end

    local lower = string.gsub(str, pattern, string.lower)
    return lower
end

--[[--
	将str中匹配pattern的子串替换为chars,最多替换limit个
	@tparam string str 目标字符串
	@tparam string pattern 模式
	@tparam string chars 模式
	@tparam number limit 替换上限，默认全替换
	@return string  替换后的结果
	@usage 
	local a = string.replace("A B C","%w","d",2) --  "d d C"
]]
function string.replace(str, pattern, chars, limit)
    if (pattern == '' or pattern == nil) then
        return str
    end

    if (limit == '' or limit == nil) then
        str = string.gsub(str, pattern, chars)
    else
        str = string.gsub(str, pattern, chars, limit)
    end
    return str
end

--[[--
	将str中index的字符替换为chars
	@tparam string str 目标字符串
	@tparam number index 位置
	@tparam string chars 子串
	@return string  插入后的结果
	@usage 
	local a = string.replace_at("aaabbb",3,"d") --  "aadbbb"
]]
function string.replace_at(str, index, chars)
    return table.concat{string.sub(str, 1, index - 1), chars, string.sub(str, index + 1)}
end

--[[--
	将str中匹配pattern的子串全替换为chars
	@tparam string str 目标字符串
	@tparam string pattern 模式
	@tparam string chars 模式
	@return string  替换后的结果
	@usage 
	local a = string.replace_all("A B C","%w","d") --  "d d d"
]]
function string.replace_all(str, pattern, chars)
    if (pattern == '' or pattern == nil) then
        return str
    end

    str = string.gsub(str, pattern, chars)
    return str
end

--[[--
	将str中匹配pattern的第一个子串替换为chars
	@tparam string str 目标字符串
	@tparam string pattern 模式
	@tparam string chars 模式
	@return string  替换后的结果
	@usage 
	local a = string.replace_first("A B C","%w","d") --  "d B C"
]]
function string.replace_first(str, pattern, chars)
    if (pattern == '' or pattern == nil) then
        return str
    end

    str = string.gsub(str, pattern, chars, 1)
    return str
end

--[[--
	得到str中从start位置开始匹配pattern的位置
	@tparam string str 目标字符串
	@tparam string pattern 模式
	@tparam number start 起点
	@return number  位置
	@usage 
	local a = string.index_of("A B C","%w",2) -- 3
]]
function string.index_of(str, pattern, start)
    if (pattern == '' or pattern == nil) then
        return nil
    end

    if (start == '' or start == nil) then
        start = 1
    end

    local position = string.find(str, pattern, start)
    return position
end

--[[--
	得到str中匹配pattern的第一个位置
	@tparam string str 目标字符串
	@tparam string pattern 模式
	@return number  位置
	@usage 
	local a = string.first_index_of("A B C","%w") -- 1
]]
function string.first_index_of(str, pattern)
    if (pattern == '' or pattern == nil) then
        return nil
    end

    local position = string.find(str, pattern, 1)
    return position
end

--[[--
	得到str中匹配pattern的最后一个位置
	@tparam string str 目标字符串
	@tparam string pattern 模式
	@return number  位置
	@usage 
	local a = string.last_index_of("A B C","%w") -- 5
]]
function string.last_index_of(str, pattern)
    if (pattern == '' or pattern == nil) then
        return nil
    end

    local position = string.find(str, pattern, 1)
    local previous = nil

    while (position ~= nil) do
        previous = position
        position = string.find(str, pattern, previous + 1)
    end

    return previous
end

--[[--
	获取str中第index个字符
	@tparam string str 目标字符串
	@tparam number index 位置
	@return string char
	@usage 
	local a = string.char_at("A B C",1) -- "A"
]]
function string.char_at(str, index)
    return str[index]
end

--[[--
	获取str中第index个byte符
	@tparam string str 目标字符串
	@tparam number index 位置
	@return number byte
	@usage 
	local a = string.byte_at("a B C",1) -- 97
]]
function string.byte_at(str, index)
    return string.byte(str, index)
end

--[[--
	获取字符的byte
	@tparam string char 字符
	@return number byte 
	@usage 
	local a = string.byte_value("a") -- 97
]]
function string.byte_value(char)
    if (string.len(char) == 1) then
        return string.byte(char, 1)
    end

    return nil
end

--[[--
	按照字符表顺序比较两个字符串,大小写敏感,小写大于大写
	@tparam string str1 字符串1
	@tparam string str2 字符串2
	@return number 大于返回1  小于返回-1  等于返回0 
	@usage 
	string.compare("abc","cba") -- -1
	string.compare("a","A") -- 1
]]
function string.compare(str1, str2)
    local len1 = string.len(str1)
    local len2 = string.len(str2)
    local smallestLen = 0;

    if (len1 <= len2) then
        smallestLen = len1
    else
        smallestLen = len2
    end

    for i = 1, smallestLen, 1 do
        if (str1(i) > str2(i)) then
            return 1
        elseif (str1(i) < str2(i)) then
            return -1
        end
    end

    local lengthDiff = len1 - len2
    if (lengthDiff < 0) then
        return -1
    elseif (lengthDiff > 0) then
        return 1
    else
        return 0
    end
end

--[[--
	按照字符表顺序比较两个字符串,大小写不敏感
	@tparam string str1 字符串1
	@tparam string str2 字符串2
	@return number 大于返回1  小于返回-1  等于返回0 
	@usage 
	string.comparei("abc","cba") -- -1
	string.comparei("a","A") -- 0
]]
function string.comparei(str1, str2)
    return string.compare(string.lower(str1), string.lower(str2))
end

--[[--
	判断两个字符是否相等,大小写敏感
	@tparam string str1 字符串1
	@tparam string str2 字符串2
	@return boolean 是否相等
	@usage 
	string.equal("abc","abc") -- true 
	string.comparei("ab","a") -- false
]]
function string.equal(str1, str2)
    local len1 = string.len(str1)
    local len2 = string.len(str2)

    if (len1 ~= len2) then
        return false
    end

    for i = 1, len1, 1 do
        if (str1[i] ~= str2[i]) then
            return false
        end
    end

    return true
end

--[[--
	判断两个字符是否相等,大小写不敏感
	@tparam string str1 字符串1
	@tparam string str2 字符串2
	@return boolean 是否相等
	@usage 
	string.equal("ABC","abc") -- true 
	string.comparei("ab","a") -- false
]]
function string.equali(str1, str2)
    return string.equal(string.lower(str1), string.lower(str1))
end

---Prints the elements of an array, optionally displaying each element's index
function print_array(array, showindex)
    for k,v in ipairs(array) do
        if (showindex) then
            print(k, v)
        else
            print(v)
        end
    end
end

---Prints the elements of a table in key-value pair style
function print_table(_table)
    for k,v in pairs(_table) do
        print(k, v)
    end
end

--[[--
	返回值的类型
	@tparam string value 字符串1
	@return string 类型值，string/number/boolean/table之外的类型全部返回"nil"
	@usage 
	string.value_of("ABC") -- "string" 
	string.value_of(1) -- "number"
]]
function string.value_of(value)
    local t = type(value)

    if (t == 'string') then
        return value
    elseif (t == 'number') then
        return '' .. value .. ''
    elseif (t == 'boolean') then
        if (value) then
            return "true"
        else
            return "false"
        end
    elseif (t == 'table') then
        local str = ""
        for k,v in pairs(value) do
            str = str .. "[" .. k .. "] = " .. v .. "\n"
        end
        str = string.sub(str, 1, string.len(str) - string.len("\n"))
        return str
    else
        return "nil"
    end
end

--[[--
	在str中index的位置插入chars
	@tparam string str 目标字符串
	@tparam string chars 字符串
	@tparam number index 位置
	@return string  插入后的结果
	@usage 
	local a = string.insert("aaabbb","d",3) --  "aaadbbb"
]]
function string.insert(str, chars, index)
    if (index == 0) then
        return chars .. str
    elseif (index == string.len(str)) then
        return str .. chars
    else
        return string.sub(str, 1, index) .. chars .. string.sub(str, index + 1, string.len(str))
    end
end

--[[--
	在str中index的位置插入rep个chars
	@tparam string str 目标字符串
	@tparam string chars 字符串
	@tparam number rep 重复次数
	@tparam number index 位置
	@return string  插入后的结果
	@usage 
	string.insert_rep("ello", "h", 4, 0) -- "hhhhello"
]]
function string.insert_rep(str, chars, rep, index)
    local rep = string.rep(chars, rep)
    return string.insert(str, rep, index)
end

--[[--
	移除str中的倒数index个字符串
	@tparam string str 目标字符串
	@tparam number index 位置
	@return string  移除后的结果
	@usage 
	string.remove_to_end("hello", 3) -- "he"
]]
function string.remove_to_end(str, index)
    if (index == 1) then
        return ""
    else
        return string.sub(str, 1, index - 1)
    end
end

--[[--
	移除str中的前index个字符串
	@tparam string str 目标字符串
	@tparam number index 位置
	@return string  移除后的结果
	@usage 
	string.remove_to_start("hello", 3) -- "lo"
]]
function string.remove_to_start(str, index)
    if (index == string.len(str)) then
        return ""
    else
        return string.sub(str, index + 1, string.len(str))
    end
end

--[[--
	裁剪掉str中的char字符
	@tparam string str 目标字符串
	@tparam string char 字符，不传为空格
	@return string  裁剪后的结果
	@usage 
	string.trim("(((word(((", "%(") -- "word"
	string.trim("   word   ") -- "word"
]]
function string.trim(str, char)
    if (char == '' or char == nil) then
        char = '%s'
    end

    local trimmed = string.gsub(str, '^' .. char .. '*(.-)' .. char .. '*$', '%1')
    return trimmed
end

--[[--
	裁剪掉str中开头的所有char字符
	@tparam string str 目标字符串
	@tparam string char 字符，不传为空格
	@return string  裁剪后的结果
	@usage 
	string.trim("(((word(((", "%(") -- "word((("
	string.trim("   word   ") -- "word   "
]]
function string.trim_start(str, char)
    if (char == '' or char == nil) then
        char = '%s'
    end

    local trimmed = string.gsub(str, '^' .. char .. '*', '')
    return trimmed
end

--[[--
	裁剪掉str中结尾的所有char字符
	@tparam string str 目标字符串
	@tparam string char 字符，不传为空格
	@return string  裁剪后的结果
	@usage 
	string.trim("(((word(((", "%(") -- "(((word"
	string.trim("   word   ") -- "   word"
]]
function string.trim_end(str, char)
    if (char == '' or char == nil) then
        char = '%s'
    end

    local length = string.len(str)

    while (length > 0 and string.find(str, '^' .. char .. '', length)) do
        length = length - 1
    end

    return string.sub(str, 1, length)
end

--[[--
	返回一个字符串，其中给定的字符串中已经替换了变量
	@tparam string str 目标字符串
	@tparam table _table 变量值
	@return string  替换后的结果
	@usage 
	string.subvar("x=$(x), y=$(y)", {x=200, y=300}) -- "x=200, y=300"
	string.subvar("x=$(x), y=$(y)", {['x']=200, ['y']=300}) -- "x=200, y=300"
]]
function string.subvar(str, _table)
    str = string.gsub(str, "%$%(([%w_]+)%)", function(key)
        local value = _table[key]
        return value ~= nil and tostring(value)
    end)

    return str
end

--[[--
	调换index后的字符串到str的开头
	@tparam string str 目标字符串
	@tparam number index 位置
	@return string  结果
	@usage 
	string.rotate("hello", 3) -- "lohel"
]]
function string.rotate(str, index)
    local str1 = string.sub(str, 1, index)
    local str2 = string.sub(str, index + 1, string.len(str))
    return str2 .. str1
end

--[[--
	获取两个字符串的平均值生成的字串
	@tparam string str1 目标字符串1
	@tparam string str2 目标字符串2
	@return string  结果
	@usage 
	string.average("str111","strc")
]]
function string.average(str1, str2)
    local len1 = string.len(str1)
    local len2 = string.len(str2)
    local smallestLen = 0
    local newstr = ''

    if (len1 <= len2) then
        smallestLen = len1
    else
        smallestLen = len2
    end

    for i = 1, smallestLen, 1 do
        newstr = newstr .. string.char( (str1(i) + str2(i)) / 2 )
    end

    if (len1 <= len2) then
        newstr = newstr .. string.sub(str2, smallestLen + 1, string.len(str2))
    else
        newstr = newstr .. string.sub(str1, smallestLen + 1, string.len(str1))
    end

    return newstr
end

--[[--
	在给定的字符串下标处交换这两个字符
	@tparam string str 目标字符串1
	@tparam number index1 位置1
	@tparam number index2 位置2
	@return string  结果
	@usage 
	string.swap("str111",1,3)
]]
function string.swap(str, index1, index2)
    local temp = str[index1]
    str = str(index1, str[index2])
    return str(index2, temp)
end

--[[--
	根据unicode值将字符串按升序排序。
	@tparam string str 目标字符串
	@return string  结果
	@usage 
	string.sort_ascending("ascasd")
]]
function string.sort_ascending(str)
    local chars = str:to_char_array()
    table.sort(chars, function(a,b) return a(1) < b(1) end)
    return table.concat(chars)
end

--[[--
	根据unicode值将字符串按降序排序。
	@tparam string str 目标字符串
	@return string  结果
	@usage 
	string.sort_descending("ascasd")
]]
function string.sort_descending(str)
    local chars = str:to_char_array()
    table.sort(chars, function(a,b) return a(1) > b(1) end)
    return table.concat(chars)
end

--[[--
	返回具有最高字节(unicode)值的字符
	@tparam string str 目标字符串
	@return string  结果
	@usage 
	string.highest("ascasd")
]]
function string.highest(str)
    local s = string.sort_descending(str)
    return s[1]
end

--[[--
	返回具有最低字节(unicode)值的字符
	@tparam string str 目标字符串
	@return string  结果
	@usage 
	string.lowest("ascasd")
]]
function string.lowest(str)
    local s = string.sort_ascending(str)
    return s[1]
end

--[[--
	判断字符是否为空
	@tparam string str 目标字符串
	@return boolean  结果
	@usage 
	string.is_empty("ascasd")
]]
function string.is_empty(str)
    if (str == '' or str == nil) then
        return true
    end

    return false
end

--[[--
	返回每个单词组成字符串的百分比的表。
	@tparam string str 目标字符串
	@return table  结果
	@usage 
	string.word_percents("hello, world!") -- {"hello" = 38.46, "world" = 38.46}
]]
function string.word_percents(str)
    local t = string.word_totals(str)
    local count = string.len(str)

    for k,v in pairs(t) do
        t[k] = ((string.len(k) * v) / count) * 100.0
    end

    return t
end

--[[--
	返回某个单词占字符串的百分比
	@tparam string str 目标字符串
	@tparam string word 单词
	@return number  结果
	@usage 
	string.word_percent("hello, world!", "hello") -- 38.46
]]
function string.word_percent(str, word)
    local t = string.word_percents(str)

    if (t[word]) then
        return t[word]
    end

    return 0
end

--[[--
	返回每个字符占字符串的百分比的表
	@tparam string str 目标字符串
	@return table  结果
	@usage 
	string.char_percents("hello") -- {"h" = 20, "e" = 20, "l" = 40, "o" = 20}
]]
function string.char_percents(str)
    local t = string.char_totals(str)
    local count = string.len(str)

    for k,v in pairs(t) do
        t[k] = (v/count) * 100.0
    end

    return t
end

--[[--
	返回某个字符占字符串的百分比
	@tparam string str 目标字符串
	@tparam string char 字符
	@return number  结果
	@usage 
	string.char_percent("hello", "h")  -- 20
]]
function string.char_percent(str, char)
    local t = string.char_percents(str)

    if (t[char]) then
        return t[char]
    end

    return 0
end

--[[--
	返回空格占字符串的百分比
	@tparam string str 目标字符串
	@return number  结果
	@usage 
	string.char_percent("hello   ")
]]
function string.space_percent(str)
    local count = string.space_count(str)
    return (count / string.len(str)) * 100.0
end

--[[--
	返回大写字符的个数
	@tparam string str 目标字符串
	@return number  结果
	@usage 
	string.upper_count("HHHsdd   ")
]]
function string.upper_count(str)
    local _, count = string.gsub(str, '%u', '')
    return count
end

--[[--
	返回大写字符的百分比
	@tparam string str 目标字符串
	@return number  结果
	@usage 
	string.upper_count("HHHsdd   ")
]]
function string.upper_percent(str)
    local count = string.upper_count(str)
    return (count / string.len(str)) * 100.0
end

--[[--
	返回小写字符的个数
	@tparam string str 目标字符串
	@return number  结果
	@usage 
	string.lower_count("HHHsdd   ")
]]
function string.lower_count(str)
    local _, count = string.gsub(str, '%l', '')
    return count
end

--[[--
	返回小写字符的百分比
	@tparam string str 目标字符串
	@return number  结果
	@usage 
	string.lower_percent("HHHsdd   ")
]]
function string.lower_percent(str)
    local count = string.lower_count(str)
    return (count / string.len(str)) * 100.0
end

--[[--
	返回包含的数字个数
	@tparam string str 目标字符串
	@return number  结果
	@usage 
	string.digit_count("123asd   ")
]]
function string.digit_count(str)
    local _, count = string.gsub(str, '%d', '')
    return count
end

--[[--
	返回包含的数字的个数统计表
	@tparam string str 目标字符串
	@return table  结果{1=count1,2= count2,...}
	@usage 
	string.digit_totals("123asd 12312312  ")
]]
function string.digit_totals(str)
    local totals = {}

    for digit in string.gmatch(str, '%d') do
        if (totals[digit]) then
            totals[digit] = totals[digit] + 1
        else
            totals[digit] = 1
        end
    end

    return totals
end

--[[--
	返回包含的数字的百分比统计表
	@tparam string str 目标字符串
	@return table  结果{1=percent1,2= percent2,...}
	@usage 
	string.digit_percents("123asd 12312312  ")
]]
function string.digit_percents(str)
    local t = string.digit_totals(str)
    local count = string.len(str)

    for k,v in pairs(t) do
        t[k] = ((string.len(k) * v) / count) * 100.0
    end

    return t
end

--[[--
	返回某个数字的百分比
	@tparam string str 目标字符串
	@tparam number digit 数字
	@return number  百分比
	@usage 
	string.digit_percent("123asd 12312312  ",1)
]]
function string.digit_percent(str, digit)
    local t = string.digit_percents(str)

    if (t[digit]) then
        return t[digit]
    end

    return 0
end

--[[--
	返回字符串中标点符号的个数
	@tparam string str 目标字符串
	@return number  结果
	@usage 
	string.punc_count("123asd 1231v,2312/.  ")--3
]]
function string.punc_count(str)
    local _, count = string.gsub(str, '%p', '')
    return count
end

--[[--
	返回字符串中标点符号的个数统计表
	@tparam string str 目标字符串
	@return table  结果{","=count1,...}
	@usage 
	string.punc_totals("123as,d 1231.2312/  ")
]]
function string.punc_totals(str)
    local totals = {}

    for punc in string.gmatch(str, '%p') do
        if (totals[punc]) then
            totals[punc] = totals[punc] + 1
        else
            totals[punc] = 1
        end
    end

    return totals
end

--[[--
	返回字符串中标点符号的百分比统计表
	@tparam string str 目标字符串
	@return table  结果{","=percent1,...}
	@usage 
	string.punc_percents("123as,d 1231.2312/  ")
]]
function string.punc_percents(str)
    local t = string.punc_totals(str)
    local count = string.len(str)

    for k,v in pairs(t) do
        t[k] = ((string.len(k) * v) / count) * 100.0
    end

    return t
end

--[[--
	返回字符串中指定标点符号的百分比
	@tparam string str 目标字符串
	@tparam string punc 标点符号
	@return number  结果
	@usage 
	string.punc_percents("123as,d 1231.2312/  ")
]]
function string.punc_percent(str, punc)
    local t = string.punc_percents(str)

    if (t[punc]) then
        return t[punc]
    end

    return 0
end

--[[--
	将array里的字符串通过sep拼接起来
	@tparam table array 字符串数组
	@tparam string sep 拼接符
	@return string  结果
	@usage 
	string.join({"sd","33","44"},"kk")
]]
function string.join(array, sep)
    return table.concat(array, sep)
end

--[[--
	获取从str1转化成str2需要的次数
	@tparam string str1 字符串1
	@tparam string str2 字符串2
	@return number  结果
	@usage 
	string.levenshtein("asdac","kk")
]]
function string.levenshtein(str1, str2)
    local len1 = string.len(str1)
    local len2 = string.len(str2)
    local matrix = {}
    local cost = 0

    if (len1 == 0) then
        return len2
    elseif (len2 == 0) then
        return len1
    elseif (str1 == str2) then
        return 0
    end

    for i = 0, len1, 1 do
        matrix[i] = {}
        matrix[i][0] = i
    end
    for j = 0, len2, 1 do
        matrix[0][j] = j
    end

    for i = 1, len1, 1 do
        for j = 1, len2, 1 do
            if (str1[i] == str2[j]) then
                cost = 0
            else
                cost = 1
            end

            matrix[i][j] = math.min(matrix[i-1][j] + 1, matrix[i][j-1] + 1, matrix[i-1][j-1] + cost)
        end
    end

    return matrix[len1][len2]
end

--[[--
	将字符串第一个字符转成小写
	@tparam string str 字符串
	@return string  结果
	@usage 
	string.lower_first("Asdac")
]]
function string.lower_first(str)
    return str(1, string.lower(str[1]))
end

--[[--
	将字符串第一个字符转成大写
	@tparam string str 字符串
	@return string  结果
	@usage 
	string.upper_first("asdac")
]]
function string.upper_first(str)
    return str(1, string.upper(str[1]))
end

--[[--
	将字符串的顺序打乱
	@tparam string str 字符串
	@return string  结果
	@usage 
	string.shuffle("Asdac")
]]
function string.shuffle(str)
    local temp = ''
    local length = string.len(str)
    local ran1, ran2 = 0, 0
    math.randomseed(os.time())

    for i = 1, length , 1 do
        ran1 = math.random(length)
        ran2 = math.random(length)
        temp = str[ran1]
        str = str(ran1, str[ran2])
        str = str(ran2, temp)
    end

    return str
end

---Converts the given integer value into a binary string of length limit
---If limit is omitted, then a binary string of length 8 is returned
function dec_to_bin(dec, limit)
    if (limit == '' or limit == nil) then
        limit = 8
    end

    local bin = ''
    local rem = 0

    for i = 1, dec, 1 do
        rem = dec % 2
        dec = dec - rem
        bin = rem .. bin
        dec = dec / 2
        if (dec <= 0) then break end
    end

    local padding = limit - (string.len(bin) % limit)
    if (padding ~= limit) then
        bin = string.insert_rep(bin, '0', padding, 0)
    end

    return bin
end

--[[--
	将字符串转为uuencode格式
	@tparam string str 字符串
	@return string  结果
	@usage 
	string.uuencode("Asdac")
]]
function string.uuencode(str)
    local padding = 3 - (string.len(str) % 3)
    if (padding ~= 3) then
        str = string.insert_rep(str, string.char(1), padding, string.len(str))
    end

    local uuenc = ''
    local bin1, bin2, bin3, binall = '', '', '', ''

    for i = 1, string.len(str) - 2, 3 do
        bin1 = dec_to_bin(string.byte(str[i]), 8)
        bin2 = dec_to_bin(string.byte(str[i+1]), 8)
        bin3 = dec_to_bin(string.byte(str[i+2]), 8)

        binall = bin1 .. bin2 .. bin3

        uuenc = uuenc .. string.char(tonumber(binall(1,6), 2) + 32)
        uuenc = uuenc .. string.char(tonumber(binall(7,12), 2) + 32)
        uuenc = uuenc .. string.char(tonumber(binall(13,18), 2) + 32)
        uuenc = uuenc .. string.char(tonumber(binall(19,24), 2) + 32)
    end

    return uuenc
end

--[[--
	将uuencode格式字符串转为正常格式
	@tparam string str uuencode字符串
	@return string  结果
	@usage 
	local str = string.uuencode("asdads")
	string.uudecode(str)
]]
function string.uudecode(str)
    local padding = 4 - (string.len(str) % 4)
    if (padding ~= 4) then
        str = string.insert_rep(str, string.char(1), padding, string.len(str))
    end

    local uudec = ''
    local bin1, bin2, bin3, bin4, binall = '', '', '', '', ''

    for i = 1, string.len(str) - 3, 4 do
        bin1 = dec_to_bin(string.byte(str[i]) - 32, 6)
        bin2 = dec_to_bin(string.byte(str[i+1]) - 32, 6)
        bin3 = dec_to_bin(string.byte(str[i+2]) - 32, 6)
        bin4 = dec_to_bin(string.byte(str[i+3]) - 32, 6)

        binall = bin1 .. bin2 .. bin3 .. bin4

        uudec = uudec .. string.char(tonumber(binall(1,8), 2))
        uudec = uudec .. string.char(tonumber(binall(9,16), 2))
        uudec = uudec .. string.char(tonumber(binall(17,24), 2))
    end

    return string.trim(uudec, string.char(1))
end

--[[--
	获取字符串的哈希值
	@tparam string str 字符串
	@tparam number check 校验值,默认为17
	@return number  结果
	@usage 
	string.hash("asdasda",17)
]]
function string.hash(str, check)
    local sum = 0
    local checksum = 17
    local length = string.len(str)

    if (check ~= '' and check ~= nil) then checksum = check end

    sum = str(1) + 1
    sum = sum + str(length) + length
    sum = sum + str(length/2) + math.ceil(length/2)

    return sum % checksum
end

--[[--
	url字符转换
	@tparam string char 字符
	@return string  结果
	@usage 
	string.url_encode_char("x")
]]
function string.url_encode_char(char)
    return "%" .. string.format("%02X", string.byte(char))
end

--[[--
	url字符传转换
	@tparam string str 字符
	@return string  结果
	@usage 
	string.url_encode("xasdasdasd")
]]
function string.url_encode(str)
    --convert line endings
    str = string.gsub(tostring(str), "\n", "\r\n")
    --escape all characters but alphanumeric, '.' and '-'
    str = string.gsub(str, "([^%w%.%- ])", string.url_encode_char)
    --convert spaces to "+" symbols
    return string.gsub(str, " ", "+")
end

--[[--
    去掉开头的空格、制表、换行符
	@tparam string str 字符
	@return string  结果
	@usage 
	string.ltrim("		    xasdasdasd")
]]
function string.ltrim(str)
    return string.gsub(str, "^[ \t\n\r]+", "")
end

--[[--
    去掉结尾的空格、制表、换行符
	@tparam string str 字符
	@return string  结果
	@usage 
	string.rtrim("xasdasdasd		    ")
]]
function string.rtrim(str)
    return string.gsub(str, "[ \t\n\r]+$", "")
end

--[[--
    去掉开头和结尾的空格、制表、换行符
	@tparam string str 字符
	@return string  结果
	@usage 
	string.trim("		    xasdasdasd		    ")
]]
function string.trim(str)
    str = string.gsub(str, "^[ \t\n\r]+", "")
    return string.gsub(str, "[ \t\n\r]+$", "")
end

--[[--
    检测手机号码是否正确
	@tparam string PhoneNumText 电话字符
	@return boolean  结果
	@usage 
	string.is_phone_num("13888888888")
]]
function string.is_phone_num( PhoneNumText )
    local phoneNum = string.trim(PhoneNumText);
    local start, length = string.find(phoneNum, "^1[3|4|5|8|7][0-9]%d+$"); --判断手机号码是否正确
    if start ~= nil and length == 11 then
        return true ;
    end
    return false;
end

--[[--
    计算文字utf8的长度
	@tparam string str 字符
	@return number  结果
	@usage 
	string.utf8len("asdasdasd")
]]
function string.utf8len(str)
    local len = #str
    local left = len
    local cnt = 0
    local arr = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc }
    while left > 0 do
        local tmp = string.byte(str, -left)
        local i = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
    end
    return cnt
end

--[[--
    按照utf8格式取subLen长度的子串
	@tparam string str 字符
	@tparam number subLen 子串长度
	@return string  结果
	@usage 
	string.utf8_sub_str("asdasdasd",3)
]]
function string.utf8_sub_str(str,subLen)

    if subLen == 0 then return "" end
    if str == nil then
        debug.traceback()
        print(str, "str")
    end

    local len = #str
    local left = len
    local cnt = 0
    local arr = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc }
    while left > 0 do
        local tmp = string.byte(str, -left)
        local i = #arr
        while arr[i] do
            if tmp >= arr[i] then
                left = left - i
                break
            end
            i = i - 1
        end
        cnt = cnt + 1
        if cnt >= subLen then
            break;
        end
    end
    local temp = string.sub(str,0,len - left);
    return temp
end

--[[--
    获取字符串中index位置的utf-8字符
	@tparam string str 字符
	@tparam number index 子串长度
	@return string  结果
	@usage 
	string.utf8_char_str("asdasdasd",3)
]]
function string.utf8_char_str( str, index )

    local last = string.utf8_sub_str(str, index - 1)

    local tem = string.utf8_sub_str(str, index)
    local utf8_char_str = string.sub(str, #last + 1, #tem)

    return utf8_char_str
end


return string;