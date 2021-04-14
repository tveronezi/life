local LOG = require "log".new(
        "trace",
        require 'log.writer.list'.new(
                require 'log.writer.console.color'.new()
        ),
        require "log.formatter.concat".new()
)
return LOG
