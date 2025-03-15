import keyboard
import threading


while True:
	print(keyboard.read_event())
	#print(keyboard.read_event().name)
	if keyboard.read_event().name == 't': 
		keyboard.block_key('t')
	
	if keyboard.read_event().name == 'esc': 
		exit()


