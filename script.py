# wine XVIIx64.exe -big -b 'adam_circuit.asc'

import os
import subprocess
import sys
import time

import matplotlib.pyplot as plt
import matplotlib.image as mpimg

# loading_proc = subprocess.Popen(['python', 'loading.py'])
# time.sleep(4)

# # set the timer interval 5000 milliseconds
# fig = plt.figure(figsize=(10, 10), dpi=80)
# timer = fig.canvas.new_timer(interval = 3500)
# timer.add_callback(plt.close)

# img = mpimg.imread('/home/adam/Desktop/sipl/sipl_server/sipl_spice/test_1/black_label_image.jpeg')
# plt.imshow(img)
# plt.axis('off')
# timer.start()
# plt.show()


# img = mpimg.imread('/home/adam/Desktop/sipl/sipl_server/sipl_spice/test_1/101_17_1_bw.jpeg')
# plt.imshow(img)
# plt.axis('off')
# timer.start()
# plt.show()
subprocess.run(['cp', sys.argv[1], '../pythonProject/Dans_rebuild/pic.jpg'])
subprocess.run(['cp', sys.argv[2], '../pythonProject/Dans_rebuild/params.txt'])
print('Before docker')
subprocess.run(['docker', 'exec', 'spice', './run_dans_script.sh', 'pic.jpg', 'params.txt'])
print('After docker')
#subprocess.run(['rm', sys.argv[1]])

ltspice_proc = subprocess.Popen(['wine', '/home/adam/.wine/drive_c/Program Files/LTC/LTspiceXVII/XVIIx64.exe', '-big', '-Run', '-b', f'C:\\users\\adam\\Desktop\\sipl\\pythonProject\\Dans_rebuild\\output.asc'])
# os.system("wine '/home/adam/.wine/drive_c/Program Files/LTC/LTspiceXVII/XVIIx64.exe' -big -b 'C:\\users\\adam\\Desktop\\sipl\\sipl_server\\sipl_spice\\adam_circuit.asc'")
# loading_proc.kill()
