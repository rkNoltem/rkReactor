reactor = peripheral.find("BigReactors-Reactor")
monitor = peripheral.find("monitor")
 
local modemSide = nil
local periTable = peripheral.getNames()
 
for p=1,#periTable do
  if peripheral.getType(periTable[p]) == "modem" then
    if peripheral.call(periTable[p], "isWireless") then
      modem = peripheral.wrap(periTable[p])
      modemSide = periTable[p]
    end
  end
end
 
if monitor then
  term.write("Running on monitor")
  term.redirect(monitor)
end
 
local rodLevel = nil
local stats = {}
local active = nil
local isActive = nil
local backup = nil
local isBackup = nil
 
local isCooled = reactor.isActivelyCooled()
 
if isCooled then
 
stats[1] = {"Casing Temp:", nil, " C"}
stats[2] = {"Core Temp: ", nil, " C"}
stats[3] = {"Fuel Reactivity: ", nil, "%"}
stats[4] = {"Fuel Amount: ", nil, "%"}
stats[5] = {"Coolant Amount: ", nil, "%"}
stats[6] = {"Steam Amount: ", nil, "%"}
stats[7] = {"Production Rate: ", nil, " mB/t"}
stats[8] = {"Rod Levels: ", nil, "%"}
stats[9] = {"Reactor: ", nil}
 
else
 
stats[1] = {"Casing Temp: ", nil, " C"}
stats[2] = {"Core Temp: ", nil, " C"}
stats[3] = {"Fuel Reactivity: ", nil, "%"}
stats[4] = {"Fuel Amount: ", nil, "%"}
stats[5] = {"Energy Stored: ", nil, " RF"}
stats[6] = {"Production Rate: ", nil, " RF/t"}
stats[7] = {"Rod Levels: ", nil, "%"}
stats[8] = {"Reactor: ", nil}
stats[9] = {"Backup: ", nil}
 
end
 
if modem then
  rednet.open(modemSide)
  rednet.host("reactorStats", "reactor")
end
 
while true do
  active = not rs.testBundledInput("bottom", colors.green)
  reactor.setActive(active)
  if active then
    isActive = "Active"
  else
    isActive = "Not Active"
  end
 
  if isCooled then
    rodLevel = (reactor.getHotFluidAmount()*100/reactor.getHotFluidAmountMax())
  else
    backup = (reactor.getFuelAmount() == 0)
    if backup then
      isBackup = "Active"
      rs.setBundledOutput("bottom", colors.red)
    else
      isBackup = "Not Active"
      rs.setBundledOutput("bottom", 0)
    end
 
    rodLevel = (reactor.getEnergyStored()/100000)
  end
 
  reactor.setAllControlRodLevels(rodLevel)
   
  stats[1][2] = math.floor(0.5 + reactor.getCasingTemperature())
  stats[2][2] = math.floor(0.5 + reactor.getFuelTemperature())
  stats[3][2] = math.floor(0.5 + reactor.getFuelReactivity())
  stats[4][2] = math.floor(0.5 + (100 * reactor.getFuelAmount() / reactor.getFuelAmountMax()))
 
  if isCooled then
    stats[5][2] = math.floor(0.5 + (100 * reactor.getCoolantAmount() / reactor.getCoolantAmountMax()))
    stats[6][2] = math.floor(0.5 + (100 * reactor.getHotFluidAmount() / reactor.getHotFluidAmountMax()))
    stats[7][2] = math.floor(0.5 + reactor.getHotFluidProducedLastTick())
    stats[8][2] = math.floor(0.5 + rodLevel)
    stats[9][2] = isActive
  else
    stats[5][2] = math.floor(0.5 + reactor.getEnergyStored())
    stats[6][2] = math.floor(0.5 + reactor.getEnergyProducedLastTick())
    stats[7][2] = math.floor(0.5 + rodLevel)
    stats[8][2] = isActive
    stats[9][2] = isBackup  
  end
 
  if modem then
    rednet.broadcast(textutils.serialize(stats), "reactorStats")
  end
   
  term.clear()
 
  for i=1,#stats do
    term.setCursorPos(1, i)
   
    for j=1,#stats[i] do
      term.write(stats[i][j])
    end
  end
 
  sleep(5)
end
