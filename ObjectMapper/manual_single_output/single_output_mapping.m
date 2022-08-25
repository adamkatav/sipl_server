global json_name;
json_name = "Real_1.jpg";

file_name_res = "our_json_new_result.bbox.json";
% read a json file 
fileID = fopen(file_name_res,'r');
text = fread(fileID,inf);
str = char(text');

time = 0;
num_img = 134;
waitbar(time/num_img);

% decoded json
values_res = jsondecode(str);
fclose(fileID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% open the coco file 

file_name_gt = "COCO.json";
% read a json file 
fileID = fopen(file_name_gt,'r');
text = fread(fileID,inf);
str = char(text');


% decoded json
values_gt = jsondecode(str);
fclose(fileID);

counter_img = 0;
curr_im_id = 1;
threshold_score = 0.8;
bbox = [];
labels = {};

dict_name_id_categories = struct("p"+1,"triangle"  ,"p"+2, "static_rectangle" ,  "p"+3, "static_ball", "p"+4 , "ceiling",  ...
    "p"+5,"floor", "p"+6, "ball" ,"p"+7 , "rectangle","p"+8 ,"cart" , "p"+9,"pendulum" , "p"+10,"spring");

%getting wanted id
wanted_img_name = json_name;

for gt_img = values_gt.images'
    if strcmp(gt_img.file_name, wanted_img_name)
        wanted_img_id = gt_img.id;
        break;
    end
end


for val = values_res'    
    for orign_img = values_gt.images'
        if (val.image_id == orign_img.id)  && (val.score>threshold_score) && (val.image_id == wanted_img_id)
            bbox(end+1,:) =  val.bbox;
            labels{end+1} = dict_name_id_categories.("p"+(val.category_id));
            file_name = orign_img.file_name;
            break;
        end
    end
end
curr_im_id = val.image_id;
img = imread(file_name);
addpath("../")
[JSON_dir, results] = mapObjects(img, bbox, labels);
counter_img = counter_img +1;
bbox = [];
labels = [];
fig = showMapping(img, results);
addpath("mapped_img/");
saveas(fig, "mapped_img/"+file_name);
close all
time = time + 1;
waitbar(time/num_img);

addpath("../");