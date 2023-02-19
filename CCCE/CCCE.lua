args = {...}
if #args == 0 then
  print("Please enter a file path to execute")
  Path = read()
  print("Please enter a controll button (it should be a key that the program does not use)")
  CK = os.pullEvent("keys")
  print("Should the program be ran in the context that the OS has a regular MOTD? (If you dont know awnser 'Y') [Y/n]")
  local sel = string.upper(read())
  if sel == "Y" or sel == "YES" then
    MOTD = true
  else
    MOTD = false
  end
  print("Starting")
else
  if args[1] == "API" then
    MOTD = false
    if #args == 2 then
      Path = args[2]
    else
      return false
    end
  else
    MOTD = true
    for i=1,#args do
      if args[i] == "-NoMOTD" then
        MOTD = false
      elseif string.sub(args[i],1,1) == "-" then
        print("Unknown flag",args[i])
        return false
      else
        Path = args[i]
      end
    end
    print("Please enter a controll button (it should be a key that the program does not use)")
    CK = os.pullEvent("keys")
end
end
if fs.exists(Path) then
  if MOTD then
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.yellow)
    term.clear()
    print("CCCE Fake Motd Splash Screen")
    term.setTextColor(colors.white)
    print("Did you know that you can start CCCE with flags, simply run 'CCCE' then enter a file path")
  else
    term.clear()
  end
else
  if #args > 0 then
    if args[1] == "API" then
      return false
    end
  end
  print("Failed to find the path",Path)
  return false
end
local file = fs.open(Path,"r")
lines = {}
while true do
  local line=file.read()
  if line == nil then
    break
  else
    lines[#lines+1] = line
  end
end
--Remove spaces and tabs
Compiled = {}
for lineNr = 1, #lines do
  for letterNr = 1,string.len(lines[lineNr]) do
    local temp = string.sub(lines[lineNr],letterNr,letterNr)
    if temp == " " or temp == " " then
    else
      if letterNr == 1 then
        Compiled[#Compiled+1] = string.sub(lines[lineNr],1,string.len(lines[lineNr]))
      else
        Compiled[#Compiled+1] = string.sub(lines[lineNr],lettNr,string.len(lines[lineNr]))
      end
    end
  end
end
--Execute the code!
FuncStack = 0
LoopStack = 0
for line=1,#Compiled do
  if string.sub(Compiled[line],1,9) == "shell.run" then
    printError("CCCE has halted the running program beacuse it wants to execute")
    printError(Compiled[line])
    printError("How do you wish to continue?")
    printError("1. Run in foreground (CCCE cant halt it while it runs)")
    printError("2. Run in background (CCCE cant halt it while it runs)")
    printError("3. Attempt to force CCCE to run it via the API")
    sel = read()
    if sel == "3" then
      shell.run("CCCE API",string.sub(Compiled[line],12,string.len(Compiled[line])-3))
    elseif sel == "2" then
      shell.run("bg",string.sub(Compiled[line],12,string.len(Compiled[line])-3))
    else
      os.execute(Compiled[line])
    end
  elseif string.sub(Compiled[line],1,6) == "return" then
    if FuncStack == 0 then
      printError("The code has finnished running")
      printError("Thank you for useing CCCE")
    else
      printError("Currently CCCE does not support returns in functions ):")
      sleep(1)
    end
  elseif string.sub(Compiled[line],1,11) == "os.shutdown" then
    printError("The code called a shutdown command")
    printError("so CCCE will now exit")
  elseif string.sub(Compiled[line],1,9) == "os.reboot" then
    printError("The code called a reboot command")
    printError("so CCCE will now exit")
  elseif string.sub(Compiled[line],1,8) == "function" then
    printError("Currently CCCE does not support functions properly ):")
    printError("NOTICE: The code is now likely to crash")
    sleep(3)
  elseif string.sub(Compiled[line],1,3) == "for" or string.sub(Compiled[line],1,5) == "while" then
    printError("Currently CCCE does not support loops ):")
    printError("The code is likely to crash")
  else
    os.execute(Compiled[line])
  end
end
