# sipl_server

Command to run the conatiner:
Under sipl/pythonProject:
`docker run --name spice --shm-size=2g --ulimit memlock=-1 --gpus all -it --rm -v $PWD:"/root" sipltechnion/sipldocker:v0.61`
