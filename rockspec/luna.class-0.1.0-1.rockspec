package = "luna.class"
version = "0.1.0-1"
description = {
    summary = "Lua classes.",
    detailed = [[
        Provides classes support for Lua.
    ]],
    homepage = "https://github.com/y-akulau/luna.class",
    license = "MIT",
}
source = {
    url = "git://github.com/y-akulau/luna.class.git",
    tag = "v0.1.0",
}
dependencies = {
    "lua >= 5.1",
}
build = {
    type = "builtin",
    modules = {
        ["luna.class"] = "src/class.lua",
    },
}
