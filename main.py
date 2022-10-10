import os
import subprocess
import sys
from PIL import Image
from pyftpdlib.authorizers import DummyAuthorizer
from pyftpdlib.handlers import FTPHandler
from pyftpdlib.servers import FTPServer

FTP_PORT = 2121

# The name of the FTP user that can log in.
FTP_USER = sys.argv[1]

# The FTP user's password.
FTP_PASSWORD = sys.argv[2]

# The directory the FTP user will have full read/write access to.
FTP_DIRECTORY = "./ftp_files/"

class MyHandler(FTPHandler):

    # def on_connect(self):
    #     print(f"{self.remote_ip}:{self.remote_port} connected")

    # def on_disconnect(self):
    #     # do something when client disconnects
    #     pass

    # def on_login(self, username):
    #     # do something when user login
    #     pass

    # def on_logout(self, username):
    #     # do something when user logs out
    #     pass

    # def on_file_sent(self, file):
    #     # do something when a file has been sent
    #     pass

    def on_file_received(self, file: str):
        # # importing PIL Module
        # from PIL import Image
        
        # # open the original image
        # original_img = Image.open(file)
        
        # # Flip the original image vertically
        # vertical_img = original_img.transpose(method=Image.Transpose(Image.Transpose.FLIP_LEFT_RIGHT))
        # vertical_img.save(file)
        
        # # close all our files object
        # original_img.close()
        # vertical_img.close()
        current_dir = os.getcwd()
        #Resize image
        image = Image.open(file)
        image_resized = image.resize((300, 300))
        image_resized.save(file)
        #Place image from phone in ObjectMappingNN and RCNN
        subprocess.run(['cp', file, './mmdetection/adam_files/input/Real_1.jpg'])
        subprocess.run(['cp', file, './ObjectMappingNN/Real_1.jpg'])
        os.chdir('./mmdetection/adam_files/')
        #Run RCNN
        subprocess.run(['bash', './runRCNN.sh'])
        #Place RCNN output in ObjectMappingNN
        subprocess.run(['cp', 'our_json_new_result.bbox.json', f'{current_dir}/ObjectMappingNN'])
        os.chdir(current_dir)
        subprocess.run(['docker', 'exec', 'mapper', 'python', '/project/test_main_pipe.py', '/project/rectangle_special_sort.pth', '/project/Real_1.jpg', '/project/'])
        subprocess.run(['cp', './ObjectMappingNN/example.json', f'{current_dir}/ftp_files/output.json'])
        #subprocess.run(['python', './script.py', file])
        #pass

    # def on_incomplete_file_sent(self, file):
    #     # do something when a file is partially sent
    #     pass

    # def on_incomplete_file_received(self, file):
    #     # remove partially uploaded files
    #     import os
    #     os.remove(file)


def main():
    authorizer = DummyAuthorizer()

    # Define a new user having full r/w permissions.
    authorizer.add_user(FTP_USER, FTP_PASSWORD, FTP_DIRECTORY, perm='elradfmw')

    handler = MyHandler
    handler.authorizer = authorizer

    # Define a customized banner (string returned when client connects)
    handler.banner = "pyftpdlib based ftpd ready."

    address = ('', FTP_PORT)
    server = FTPServer(address, handler)

    server.max_cons = 256
    server.max_cons_per_ip = 5

    server.serve_forever()


if __name__ == '__main__':
    main()
