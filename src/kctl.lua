local function command_exists(command)
  local result = os.execute("command -v " .. command .. ">/dev/null 2>&1")
  return result == true or result == 0
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
	print("KERN SYSTEM STATUS")
	print("------------------")
	print("kctl: operational")
  print("------------------")
  print("System")
  print("   Kernel:", read_file("/proc/sys/kernel/ostype"))
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


