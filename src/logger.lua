local log_level = os.getenv("LIFE_LOG_LEVEL")
if log_level == nil then
        log_level = "info" -- https://github.com/moteus/lua-log/blob/master/doc/doc.md
end
local logger = require "log".new(
        log_level,
        require 'log.writer.list'.new(
                require 'log.writer.console.color'.new()
        ),
        require "log.formatter.concat".new()
)
return logger
