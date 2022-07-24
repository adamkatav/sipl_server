import os
from LT_spice_transformer import *
import sys
print('1')
print(sys.argv)

def main(file_name):
    os.chdir('./sipl_spice')
    path = file_name
    Thresh = 0.4
    pic, components, models = load_data_2(path, Thresh) #gray pic
    bin_pic = 1 - cv2.adaptiveThreshold(pic, 1, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 15, 12)
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
    dil_pic = cv2.dilate(bin_pic, kernel, iterations = 7)
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
    er_pic = cv2.erode(dil_pic, kernel, iterations = 7)
    plt.figure()
    plt.imshow(er_pic)
    plt.savefig("er_pic.png")
    #plt.figure()
    #plt.imshow(er_pic)
    matrix, wires = connection_finder(er_pic, components)
    digitize(components, wires)
    LTspice_writer('name', components, wires)
    Latex_writer(components, wires, 'name')
    return components, wires


def load_data_2(pathIMG, Thresh):
  if torch.cuda.is_available():
    device = torch.device('cuda')
  else:
    device = torch.device('cpu')

  ''' Old components
  all_comps = ['junction', 'text', 'gnd', 'terminal', 'crossover',
                          'resistor', 'capacitor', 'inductor',
                          'diode', 'transistor',
                          'voltage', 'current']
  comps = ["voltage", "diode", "capacitor", "inductor", "resistor"]
  num_outs = [4, 4, 2, 2, 2]'''
  all_comps = ['C', 'V_dep', 'text_dep_I', 'text', 'L', 'gnd', 'terminal', 'V', 'transformer', 'NL', 'cross',
               'text_dep_V', 'J', 'R', 'amplifier', 'I', 'SW', 'Z', 'I_dep']
  comps = ['V', 'C', 'L', 'R']
  num_outs = [4, 2, 2, 2]
  models = {"device": device}
  for comp, num in zip(comps, num_outs):
    models[comp] = torchvision.models.resnet18(pretrained=False)
    num_ftrs = models[comp].fc.in_features
    models[comp].fc = nn.Linear(num_ftrs, num)
    models[comp].to(device)
    path = ("./comp_models/{}_model.pt").format(comp)
    checkpoint = torch.load(path)
    model_state_dict = checkpoint["model_state_dict"]
    #pdb.set_trace()
    models[comp].load_state_dict(model_state_dict)
  img = Image.open(pathIMG)
  pic = np.asarray(img)
  gray_pic = cv2.cvtColor(pic, cv2.COLOR_RGB2GRAY)
  H, W = gray_pic.shape
  components = []
  object_detective = torchvision.models.detection.fasterrcnn_resnet50_fpn(pretrained=False)
  object_detective.to(device)
  #path = "./resnet_models/best_bin_resnet.pt"
  path = "./resnet_models/best_resnet.pt"
  checkpoint = torch.load(path)
  object_detective.load_state_dict(checkpoint['model_state_dict'])
  object_detective.eval()
  pic_cuda = [torch.from_numpy(gray_pic.reshape([1, H, W])).float().to(device)]
  bin_pic = 1 - cv2.adaptiveThreshold(gray_pic, 1, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 15, 12)
  #kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
  #dil_pic = cv2.dilate(bin_pic, kernel, iterations=7)
  #kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (2, 2))
  #er_pic = cv2.erode(dil_pic, kernel, iterations=7)
  pic_cuda = [torch.from_numpy(gray_pic.reshape([1, H, W])).float().to(device)]
  predictions = object_detective(pic_cuda)
  boxes = predictions[0]["boxes"].cpu().detach().numpy()
  labels = predictions[0]["labels"].cpu().detach().numpy()
  scores = predictions[0]["scores"].cpu().detach().numpy()
  indices = scores > Thresh
  labels = labels[indices]

  boxes = boxes[indices]
  plot_all(gray_scale(pic), boxes, labels, "before.jpg")
  boxes, labels = reduce_replicas(boxes, labels, scores[indices])
  plot_all(gray_scale(pic), boxes, labels, "after.jpg")
  labels_string = [all_comps[label - 1] for label in labels]
  for box, label in zip(boxes, labels_string):
    if (label in comps) | (label == 'J'):
      box_int = [int(element) for element in box]
      component = drawn_component(box_int, label, gray_pic)
      component.find_orientation(models)
      components.append(component)
  return gray_pic, components, models


main(sys.argv[1])
