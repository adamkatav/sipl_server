global json_name;

files = dir(".");

for file = files'
    if contains(file.name,"jpeg") || contains(file.name,"jpg")
        json_name = file.name;
        single_output_mapping;
    end
end
        
        
