@events.on_ptk_create
def _custom_keybindings(bindings, **kw):
    from prompt_toolkit.application.current import get_app
    from prompt_toolkit.filters import Always, Condition, vi_navigation_mode
    from prompt_toolkit.keys import Keys

    _always = Always()

    @bindings.add(Keys.ControlY)
    def _accept_suggestion(event):
        buf = event.current_buffer
        if buf.suggestion:
            buf.insert_text(buf.suggestion.text)

    # Mac zsh `up-line-or-beginning-search` parity. history_search_text=None
    # forces _set_history_search to recompute the prefix from the cursor on
    # every call; cursor restore matches zsh (history_backward jumps to EOL).
    def _prefix_history_nav(event, backward):
        buf = event.current_buffer
        cursor = buf.cursor_position
        saved_filter = buf.enable_history_search
        saved_search_text = buf.history_search_text
        buf.enable_history_search = _always
        buf.history_search_text = None
        try:
            if backward:
                buf.history_backward(count=event.arg)
            else:
                buf.history_forward(count=event.arg)
        finally:
            buf.enable_history_search = saved_filter
            buf.history_search_text = saved_search_text
        buf.cursor_position = min(cursor, len(buf.text))

    @bindings.add(Keys.ControlP)
    def _history_backward_cp(event):
        _prefix_history_nav(event, backward=True)

    @bindings.add(Keys.ControlN)
    def _history_forward_cn(event):
        _prefix_history_nav(event, backward=False)

    # Up/Down: eager=True wins over atuin's non-eager Up binding (prompt_toolkit
    # collapses to eager matches before applying last-registered-wins). Filter
    # mirrors atuin's `should_search` so completion-menu nav and multi-line
    # editing keep their default Up/Down behaviour.
    @Condition
    def _can_prefix_nav():
        buf = get_app().current_buffer
        return buf.complete_state is None and '\n' not in buf.text

    @bindings.add(Keys.Up, eager=True, filter=_can_prefix_nav)
    def _history_backward_up(event):
        _prefix_history_nav(event, backward=True)

    @bindings.add(Keys.Down, eager=True, filter=_can_prefix_nav)
    def _history_forward_down(event):
        _prefix_history_nav(event, backward=False)

    # mirrors Mac zsh `bindkey -M vicmd '^v' edit-command-line`
    @bindings.add(Keys.ControlV, filter=vi_navigation_mode)
    def _edit_in_editor(event):
        event.current_buffer.open_in_editor()
