local _M = {}

local function _StringSplit(input_str, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(input_str, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function _M.UploadDsp()
  local upload = require "resty.upload"
  local shell = require "resty.shell"
  local cjson = require "cjson"
  local ngx = ngx
  -- local ngx_resp = require "ngx.resp"

  local chunk_size = 8196
  local form, err = upload:new(chunk_size)
  if not form then
    ngx.log(ngx.ERR, "failed to new upload: ", err)
    ngx.exit(500)
  end

  form:set_timeout(1000)
  local media_id = tonumber(string.sub(ngx.var.request_id, 0, 15), 16)
  media_id = string.format("%.f", media_id)
  local media_file = ""
  local media_type
  local media_filename

  while true do
    local typ, res, err = form:read()
    if not typ then
      ngx.say("failed to read: ", err)
      return
    end

    if typ == "header" then
      for i, ele in ipairs(res) do
        local filename = string.match(ele, 'filename="(.*)"')
        if filename and filename ~= '' then
          if string.find(ele, 'Disposition') then
            media_filename = filename
          end
          local filename_list = _StringSplit(filename, '.')
          media_type = filename_list[#filename_list]
        end
      end
    elseif typ == "body" then
      media_file = media_file .. res
    elseif typ == "part_end" then

    elseif typ == "eof" then
      break
    end
  end
  
  local timeout = 2000  -- ms
  local max_size = 4096  -- byte

  local ok = shell.run("mkdir builds/" .. media_id, nil, timeout, max_size)
  
  local out_file_name = "builds/" .. media_id .. "/" .. media_filename
  local out_file = io.open(out_file_name, 'w')
  out_file:write(media_file)
  out_file:close()  
  
  local ok = shell.run("bash build.sh " .. media_id .. " " .. media_filename, nil, timeout, max_size)
  ngx.header.location = "/" .. media_id
  ngx.exit(307)

end

return _M