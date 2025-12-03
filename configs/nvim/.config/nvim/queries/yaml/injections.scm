; extends

; github actions: https://github.com/rmuir/tree-sitter-ghactions
([
  (string_scalar)
  (block_scalar)
  (double_quote_scalar)
  (single_quote_scalar)
  (plain_scalar)
  (flow_node)
] @injection.content
  (#lua-match? @injection.content "%${{.+}}")
  (#set! injection.language "ghactions"))

