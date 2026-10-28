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
	print("------------------\n")
	print("kctl: operational\n")
  print("------------------\n")

  -- System info
  print("System")

  --  Prints the kernel and removes surrounding whitespace
  if kerneli then
    local kernel = trim(kerneli)
    print("   Kernel:", kernel)
  else
    print("   Kernel: unavailable")
  end

  print("   Architecture:", trim(get_architecture()))

  -- Check if dependencies are installed, via command_exists()
  print("Components")
  print("   Lua:", command_exists("lua") and "installed" or "missing")
  print("   decman:", command_exists("decman") and "installed" or "missing")
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


