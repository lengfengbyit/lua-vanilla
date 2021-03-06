----------------------
-- 辅助函数
-- 2017/10/20 16:32:02
----------------------

local helper = {}

-- 根据文件路径获得文件目录
function helper:dirPath(filePath)
    return string.match(filePath, "^.*/")
end

-- 获得当前文件所在目录
function helper:getCurrDirPath()

    local info = debug.getinfo(1, 'S')
    local filePath = string.sub(info.source, 2, -1)
    return self:dirPath(filePath)
end

-- 日志记录
function helper:log(str)

  if type(str) == 'table' then
    str = self:dumpTab(str)
  end

  if str then
      local filePath = './logs/debug.log'
      if not logFile then
        logFile = io.open(filePath, 'a')
      end

      logFile:write(str .. '\n')
  end
end

-- 关闭日志文件指针
function helper:closeLogFile()
  if logFile then
    logFile:close()
  end
end

function helper:currDir()
  os.execute("cd > cd.tmp")
  local f = io.open("cd.tmp", r)
  local cwd = f:read("*a")
  f:close()
  os.remove("cd.tmp")
  return cwd
end



---
-- @function: 获取table的字符串格式内容，递归
-- @tab： table
-- @ind：不用传此参数，递归用（前缀格式（空格））
-- @return: format string of the table
function helper:dumpTab(tab,ind)
  if(tab==nil)then return "nil" end;
  local str="{";
  if(ind==nil)then ind="  "; end;
  --//each of table
  for k,v in pairs(tab) do
    --//key
    if(type(k)=="string")then
      k=tostring(k).." = ";
    else
      k="["..tostring(k).."] = ";
    end;--//end if
    --//value
    local s="";
    if(type(v)=="nil")then
      s="nil";
    elseif(type(v)=="boolean")then
      if(v) then s="true"; else s="false"; end;
    elseif(type(v)=="number")then
      s=v;
    elseif(type(v)=="string")then
      s="\""..v.."\"";
    elseif(type(v)=="table")then
      s=self:dumpTab(v,ind.."  ");
      s=string.sub(s,1,#s-1);
    elseif(type(v)=="function")then
      s="function : ".. v;
    elseif(type(v)=="thread")then
      s="thread : "..tostring(v);
    elseif(type(v)=="userdata")then
      s="userdata : "..tostring(v);
    else
      s="nuknow : "..tostring(v);
    end;--//end if
    --//Contact
    str=str.."\n"..ind..k..s.." ,";
  end --//end for
  --//return the format string
  local sss=string.sub(str,1,#str-1);
  if(#ind>0)then ind=string.sub(ind,1,#ind-2) end;
  sss=sss.."\n"..ind.."}\n";
  return sss;--string.sub(str,1,#str-1).."\n"..ind.."}\n";
end;--//end function

-- 设置cookie
function helper:setCookie(key, val, time)

  local str = nil
  if time ~= nil then
    time = ngx.cookie_time(ngx.time() + time)
  end

  if type(key) == 'string' then
    str = key .. '=' .. val
    if time ~= nil then
      str = str .. ';Expires=' .. time
    end
  elseif type(key) == 'table' then
    str = {}
    local tmp = nil
    for k,v in pairs(key) do
      tmp = k .. '=' .. v
      if time ~= nil then
        tmp = tmp .. ';Expires=' .. time
      end
      table.insert(str, tmp)
    end
  end

  if str ~= nil then
    ngx.header['Set-Cookie'] = str;
  end
end

function helper:getCookie(key)

  return ngx.var['cookie_' .. key];
end

-- 获得所有cookie,返回table
function helper:getAllCookie()

  local allCookie = ngx.var.http_cookie;
  if allCookie == nil then return nil end

  local list = self:split(allCookie, ';')
  if list == nil then return nil end

  local result = {}
  for _,item in ipairs(list) do
    local tab = self:split(item, '=')
    if tab ~= nil then result[tab[1]] = tab[2] end
  end
  return result
end

-- 删除cookie，key可以是单个键，
-- 也可以是多个键，多个键放在数组里
-- 如果没有指定key，则默认删除所有cookie
function helper:delCookie( key )

  self:log(type(key))
  local cookie = {};
  if type(key) == 'table' then
    for i,v in ipairs(key) do
      cookie[v] = '';
    end
    key = cookie;
  elseif type(key) == 'nil' then
    key = self:getAllCookie()
  end

  self:setCookie(key, '', -1);
end

-- 字符串分隔
function helper:split(str, delimiter)

  if str == nil or str == '' or delimiter == nil then return nil end

  local result = {}

  for match in (str .. delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match)
  end

  return result
end

return helper