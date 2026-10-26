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


