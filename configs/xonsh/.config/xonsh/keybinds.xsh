$VI_MODE = True

@events.on_ptk_create
def _custom_keybindings(bindings, **kw):
    from prompt_toolkit.keys import Keys

    @bindings.add(Keys.ControlY)
    def _accept_suggestion(event):
        buf = event.current_buffer
        if buf.suggestion:
            buf.insert_text(buf.suggestion.text)

    # history navigation (mirrors Mac zsh ^p/^n)
    @bindings.add(Keys.ControlP)
    def _history_backward(event):
        event.current_buffer.history_backward(count=event.arg)

    @bindings.add(Keys.ControlN)
    def _history_forward(event):
        event.current_buffer.history_forward(count=event.arg)
