monitor = peripheral.find("monitor")
if monitor then
  term.redirect(monitor)
end
 
local id,message,protocol,stats = {nil, nil, nil, nil}
 
rednet.open("back")

print([[rkReactorStats  Copyright (C) 2015  Sean Harris
This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
This is free software, and you are welcome to redistribute it
under certain conditions.]])
sleep (10)
term.clear()
 
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

--[[
Big-Reactors reactor management code for ComputerCraft in Lua
Copyright (C) 2015  Sean Harris
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
You can contact the author at: ridleykiller1994@gmail.com]]
