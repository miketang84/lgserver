

return 
[==[
	local socket = require 'socket'
	local zmq = require 'zmq'
--	local cmsgpack = require 'cmsgpack'
--	local zlib = require 'zlib'

    local host, port, channel_sub_addr = ...
--  print(host, port, channel_sub_addr)

    local client = assert(socket.connect(host, port))
    local ctx = zmq.init(1)
    local channel_sub = ctx:socket(zmq.SUB)
	channel_sub:setopt(zmq.SUBSCRIBE, "")
	channel_sub:connect(channel_sub_addr)
		
    while true do
		local msg, err = channel_sub:recv()   -- block wait
		-- print('return msg...', #msg)

		local s, errmsg = client:send(#msg..' '..msg)
		if not s and errmsg == 'closed' then
			client = assert(socket.connect(host, port))
			client:send(#msg..' '..msg)
		end
    end
    
    print('Client Ends.')
]==]
