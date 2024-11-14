local _M = {}

function _M.RetrieveMedia()
  local ngx = ngx
  
  local f = io.open("builds" .. ngx.var.uri .. "/file", 'r')
  if (f == nil) then
    local res = io.open("templates/processing.html", 'r')
    local content = res:read("*a")
    ngx.say(content)
    return
  end
  
  local file = f:read("*a")
  ngx.say("<a href=\"" .. ngx.var.uri .. "/" .. file .. "\">Click here</a>")
  
end

return _M