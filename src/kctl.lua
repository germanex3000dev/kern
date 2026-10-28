-- kern config path location
local config_path = os.getenv("HOME") .. "/kern/config/source.py"

local function command_exists(command)
  local handle = io.popen("command -v " .. command .. ">/dev/null 2>&1; echo $?")
  if not handle then
    return false
  end 

  local result = handle:read("*l")
  handle:close()

  return result == "0"
end

local function get_architecture()
  local handle = io.popen("uname -m")

  if not handle then
    return "unavalilable"
  end

  local result = handle:read("*l")
  handle:close()

  return result or "unavailable"
end

-- Read sytsem informatin direcctly from files
local function read_file(path)
  local file = io.open(path, "r")

  if not file then
    return nil
  end

  local content = file:read("*a")
  file:close()

  return content
end 

local function file_exists(path)
  local handle = io.open(path, "r")

  if handle then
    return true
  else
    return nil
  end

  handle:close()
end

-- Trim leading and trailing whitespace
local function trim(s)
  if not s then
    return ""
  end
  return (string.gsub(s, "^%s+", ""):gsub("%s+$", ""))
end

local function show_help()
	print("KERN Control Utility")
	print("")
	print("Usage: kctl <command>")
	print("")
	print("Commands: ")
	print("   status          Show system status")
	print("   help		  Show this help")
end

local function status()
  local kerneli = read_file("/proc/sys/kernel/ostype")

	print("KERN SYSTEM STATUS\n")
	print("------------------")
	print("kctl: operational")
  print("------------------\n")

  -- System info
  print("System")

  --  Prints the kernel and removes surrounding whitespace
  if kerneli then
    local kernel = trim(kerneli)
    print("   Kernel: " .. kernel)
  else
    print("   Kernel: unavailable")
  end

  print("   Architecture: " .. trim(get_architecture()).."\n")

  -- Check if dependencies are installed, via command_exists()
  print("Components")
  print("   Lua: " .. (command_exists("lua") and "installed" or "missing"))
  print("   decman: " .. (command_exists("decman") and "installed" or "missing").."\n")
  
  -- config file
  print("Configuration")
  print("   Source: " .. config_path)
  if file_exists(config_path) then 
    print("   Status: found\n")
  elseif not file_exists(config_path) then
    print("   Status: missing\n")
  end 
end

local commands = {
	status = status,
	help = show_help,
}

local command = arg[1] or "help"
local handler = commands[command]

if handler then
	handler()
else
	io.stderr:write("kctl: unknown command: " .. command .. "\n")
	show_help()
	os.exit(1)
end


