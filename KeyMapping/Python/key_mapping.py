from pynput import keyboard

# キーマッピング辞書を作成
key_mapping = {
    'a': 'b',  # 'a'キーを押すと'b'が入力される
    'b': 'a'   # 'b'キーを押すと'a'が入力される
}

# 一度マッピングしたかのフラグ。リマップを一度のみ許可し、マッピングがループすることを防ぐ
#remap_count = 0
class remap_count:
	count = 0

# キーが押された時のイベント
def on_press(key):
    try:
        if key.char in key_mapping:
            # 一度もマッピングしたことない場合のみリマップする
            if remap_count.count == 0:
	            mapped_key = key_mapping[key.char]
	            
	            # マッピング後で入力（押下と離す動作がセット）
	            keyboard.Controller().press(mapped_key)
	            keyboard.Controller().release(mapped_key)
	            print(f"Key {key.char} remapped to {mapped_key}")
	            # 一度マッピングしたかのフラグ。リマップを一度のみ許可し、マッピングがループすることを防ぐ
	            remap_count.count = 1
	            print(f"remap_count update {remap_count.count}")
            else:
	            # リマップがループした場合
            	print(f"remap_count is {remap_count.count}")
        else:
            print(f"Key {key} pressed")
    except AttributeError:
        print(f"Special key {key} pressed")

# キーが離された時のイベント
def on_release(key):
    print(f"Key {key} released")
    # リマップ後で入力されたらマッピングカウントを0に戻す
    remap_count.count = 0
    print(f"remap_count reset {remap_count.count}")
    if key == keyboard.Key.esc:
        # Escキーが押されたらリスナーを停止
        return False

# リスナーを準備し、開始
with keyboard.Listener(
        on_press=on_press,
        on_release=on_release) as listener:
    # リスナーを開始
    listener.join()
