local config = require("src/config")

local logger = require "log".new(
        config.log_level,
        require 'log.writer.list'.new(
                require 'log.writer.console.color'.new()
        ),
        require "log.formatter.concat".new()
)
return logger
