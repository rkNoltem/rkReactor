monitor = peripheral.find("monitor")
if monitor then
  term.redirect(monitor)
end
 
local id,message,protocol,stats = {nil, nil, nil, nil}
 
rednet.open("back")
 
while true do
  id,message,protocol = rednet.receive("reactorStats")
 
  stats = textutils.unserialize(message)
 
  term.clear()
 
  for i=1,#stats do
    term.setCursorPos(1, i)
   
    for j=1,#stats[i] do
      term.write(stats[i][j])
    end
  end
end
