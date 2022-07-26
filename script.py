# wine XVIIx64.exe -big -b 'adam_circuit.asc'

import os
import subprocess
import time

loading_proc = subprocess.Popen(['python', 'loading.py'])
time.sleep(4)
ltspice_proc = subprocess.Popen(['wine', '/home/adam/.wine/drive_c/Program Files/LTC/LTspiceXVII/XVIIx64.exe', '-big', '-b', 'C:\\users\\adam\\Desktop\\sipl\\sipl_server\\sipl_spice\\adam_circuit.asc'])
# os.system("wine '/home/adam/.wine/drive_c/Program Files/LTC/LTspiceXVII/XVIIx64.exe' -big -b 'C:\\users\\adam\\Desktop\\sipl\\sipl_server\\sipl_spice\\adam_circuit.asc'")
loading_proc.kill()
