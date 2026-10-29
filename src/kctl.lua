-- kern config path location
local config_path = os.getenv("HOME") .. "/kern/config/source.py"

local editor = os.getenv("EDITOR") or os.getenv("VISUAL") or "vim"

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

local function forge()
  local option = arg[2]

  if option == "--dry-run" then
    local ok, kind, code = os.execute(
      "sudo decman --source "..config_path.." --dry-run"
    )
    if ok then
      print("\nDry run succesful\n")
    else
      io.stderr:write("\nDry run failed\n")
      os.exit(1)
    end
  elseif option == "--apply" then
    local ok, kin, code = os.execute(
      "sudo decman --source "..config_path
    )
    if ok then
      print("\nApplied new configuration successfully\n")
    else
      io.stderr:write("\nApply failed\n")
      os.exit(1)
    end
  elseif option == "--help" then
    print("KERN FORGE HELP\n")
    print("-------------------")
    print("options:")
    print("   kctl forge")
    print("            --dry-run     Preview changes of the source file")
    print("            --apply       Apply the new configuration changes")
    print("            --help        Show this help screen\n")
    print("-------------------")
  elseif option == nil then
    print("KERN FORGE HELP\n")
    print("-------------------")
    print("options:")
    print("   kctl forge")
    print("            --dry-run     Preview changes of the source file")
    print("            --apply       Apply the new configuration changes")
    print("            --help        Show this help screen\n")
    print("-------------------")
  end
end


local function source()
  local option = arg[2]

  if option == "--check" then 
    print("Checking KERN configuration...")
    local ok, kind, code = os.execute(
      "sudo decman --source "..config_path.." --dry-run"
    )
    if ok then 
      print("\nConfiguration check completed")
    else
      io.stderr:write("\nConfiguration check failed.\n")
      os.exit(1)
    end

  elseif option == "--edit" then
    print("Opening KERN configuration...")
    os.execute(editor .." ".. config_path)

  elseif option == "--debug" then
    print("Checking KERN configuration with debug output...")
    local ok, kind, code = os.execute(
      "sudo decman --source "..config_path.." --dry-run"
    )
    if ok then
      print("\nConfiguration check completed.\n")
    else
      print("\nConfiguration check failed.\n")
      os.exit(1)
    end

  elseif option == nil then
    print("KERN CONFIGURATION\n")
    print("------------------")
    print("Source "..config_path)

    if file_exists(config_path) then
      print("Status: found")
    else
      print("Status: missing")
    end
  else 
    io.stderr:write("kctl source: unknown option: " .. option .. "\n")
    os.exit(1)
  end
end

local function show_help()
	print("KERN Control Utility")
	print("")
	print("Usage: kctl <command>")
	print("")
	print("Commands: ")
	print("   status          Show system status\n")
  print("   source          Show source status")
  print("       --check     Check source file for errors")
  print("       --debug     Check source file with debug output")
  print("       --edit      Open the configuration file in editor\n")
	print("   help		   Show this help\n")
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
  source = source,
  forge = forge,
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


