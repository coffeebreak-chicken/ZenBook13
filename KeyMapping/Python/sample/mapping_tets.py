import keyboard

def on_key_event(event): #keyboard.event と同じ
    print(f"Key: {event.name}, Event Type: {event.event_type}")

# main > on_key_event()呼び出し
keyboard.hook(on_key_event)


keyboard.wait('esc')  # Press 'esc' to exit