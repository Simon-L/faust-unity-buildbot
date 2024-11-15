local _M = {}

function _M.RetrieveDsp(preload)
  local ngx = ngx
  local f = io.open("builds" .. ngx.var.uri .. "/file", 'r')
  if (f == nil) then
    ngx.say(preload.get_template "processing" )
    return
  end
  
  local file = f:read("*a")
  local url = ngx.var.uri .. "/" .. file
  
  local template = require "resty.template".new({
    root = "templates"
  })
  template.render_file("build.html", { url = url, file = string.sub(file, 3, -1)})
  
end

return _M