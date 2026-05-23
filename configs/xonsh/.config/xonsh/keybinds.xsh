$VI_MODE = True

@events.on_ptk_create
def _custom_keybindings(bindings, **kw):
    from prompt_toolkit.keys import Keys

    @bindings.add(Keys.ControlY)
    def _accept_suggestion(event):
        buf = event.current_buffer
        if buf.suggestion:
            buf.insert_text(buf.suggestion.text)
