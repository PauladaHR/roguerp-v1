-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tools = module("lib/Tools")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local prompts = {}
local requests = {}
local request_ids = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROMPT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.prompt(source,title,default_text)
	local r = async()
	prompts[source] = r
	vRPC._prompt(source,title,default_text)
	return r:wait()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.request(source,titulo,text,time)
	if time == nil then
		time = text
		text = titulo
		titulo = "Sistema"
	end

	local r = async()
	local id = request_ids:gen()
	local request = { source = source, cb_ok = r, done = false }
	requests[id] = request

	vRPC.request(source,id,titulo,text,time)

	SetTimeout(time*1000,function()
		if not request.done then
			request.cb_ok(false)
			request_ids:free(id)
			requests[id] = nil
		end
	end)
	return r:wait()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROMPTRESULT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.promptResult(text)
	if text == nil then
		text = ""
	end

	local prompt = prompts[source]
	if prompt ~= nil then
		prompts[source] = nil
		prompt(text)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTRESULT
-----------------------------------------------------------------------------------------------------------------------------------------
function tvRP.requestResult(id,ok)
	local request = requests[id]
	if request and request.source == source then
		request.done = true
		request.cb_ok(not not ok)
		request_ids:free(id)
		requests[id] = nil
	end
end