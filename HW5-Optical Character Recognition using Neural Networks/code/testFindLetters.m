% test
im = imread('../images/02_letters.jpg');
% im = imread('../images/01_list.jpg');
% im = imread('../images/03_haiku.jpg');
im = imread('../images/04_deep.jpg');

[lines, bw] = findLetters(im);
for i = 1:length(lines)
   line = lines{i}; 
   [num_obj, ~] = size(line);
   for j = 1:num_obj
       obj = line(j, :);
       [width, height] = deal(obj(3) - obj(1), obj(4) - obj(2));
       im = insertShape(im,'Rectangle',[obj(1), obj(2), width, height],'LineWidth', 5);
       imshow(im);
   end
end




