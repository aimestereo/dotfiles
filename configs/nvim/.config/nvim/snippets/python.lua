local ls = require("luasnip")
local s = ls.s
local i = ls.insert_node
local t = ls.text_node

ls.add_snippets("python", {
  s("logger", {
    t({ "from structlog.stdlib import get_logger", "logger = get_logger(__name__)" }),
    i(0),
  }),
})
