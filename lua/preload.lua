 local _M = {}

 local res = io.open("templates/processing.html", 'r')
 local content = res:read("*a")
 res:close()

 local templates = {
     processing = content
 }

 function _M.get_template(name)
     return templates[name]
 end

 return _M