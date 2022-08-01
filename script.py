# wine XVIIx64.exe -big -b 'adam_circuit.asc'

import os
import subprocess
import time

import matplotlib.pyplot as plt
import matplotlib.image as mpimg

loading_proc = subprocess.Popen(['python', 'loading.py'])
time.sleep(4)

# set the timer interval 5000 milliseconds
fig = plt.figure(figsize=(10, 10), dpi=80)
timer = fig.canvas.new_timer(interval = 3500)
timer.add_callback(plt.close)

img = mpimg.imread('/home/adam/Desktop/sipl/sipl_server/sipl_spice/test_1/black_label_image.jpeg')
plt.imshow(img)
plt.axis('off')
timer.start()
plt.show()


img = mpimg.imread('/home/adam/Desktop/sipl/sipl_server/sipl_spice/test_1/101_17_1_bw.jpeg')
plt.imshow(img)
plt.axis('off')
timer.start()
plt.show()


ltspice_proc = subprocess.Popen(['wine', '/home/adam/.wine/drive_c/Program Files/LTC/LTspiceXVII/XVIIx64.exe', '-big', '-b', 'C:\\users\\adam\\Desktop\\sipl\\sipl_server\\sipl_spice\\test_1\\101_17_1.asc'])
# os.system("wine '/home/adam/.wine/drive_c/Program Files/LTC/LTspiceXVII/XVIIx64.exe' -big -b 'C:\\users\\adam\\Desktop\\sipl\\sipl_server\\sipl_spice\\adam_circuit.asc'")
loading_proc.kill()
