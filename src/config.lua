local function getenv_or (varname, fallback_value)
    local value = os.getenv(varname)
    if value == nil then
        return fallback_value
    end
    return value
end

return {
    -- https://github.com/moteus/lua-log/blob/master/doc/doc.md
    log_level = getenv_or("LIFE_LOG_LEVEL", "info"),
    cell_size = tonumber(getenv_or("LIFE_CELL_SIZE", "30")),
    init_state = getenv_or("LIFE_INIT_STATE", "simple")
}
