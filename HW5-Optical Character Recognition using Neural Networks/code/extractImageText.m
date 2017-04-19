function [text] = extractImageText(fname)
% [text] = extractImageText(fname) loads the image specified by the path 'fname'
% and returns the next contained in the image as a string.

im = imread(fname);
[lines, bw] = findLetters(im);

% prepare data for classification
num_data = 0;
for i = 1:length(lines)
   num_data = num_data + size(lines{i}, 1);
end
data = zeros(num_data, 32 * 32);

index = 0;
linebreak = zeros(num_data, 1);  % indicate the line break
linebreak_ind = 1;
space = zeros(num_data, 1);     % indicate the space
space_ind = 1;
for i = 1:length(lines)
    line = lines{i};
    num_obj = size(line, 1);
    avgBoxLen = 0;
    index_copy = index;
    for j = 1: num_obj
        index = index + 1;
        obj = line(j, :);
        img = ~bw(obj(2):obj(4), obj(1):obj(3));
        avgBoxLen = avgBoxLen + (obj(3) - obj(1));
        
        % padding to make it a squre image 
        [H, W] = size(obj);
        sideLen = max(H, W);
        diff = max(sideLen - H, sideLen - W);
        if mod(diff, 2) == 0
            img = padarray(img, [(sideLen - H) / 2, (sideLen - W) / 2]);
        else 
            img = padarray(img, [sideLen - H, sideLen - W], 'pre');
        end
        img = ~imresize(img, [32 32]);
        % imshow(img);
        data(index, :) = img(:)';
    end
    linebreak(linebreak_ind) = index;
    linebreak_ind = linebreak_ind + 1;
    
    avgBoxLen = avgBoxLen / num_obj * 0.66;   % 0.66
    index_copy = index_copy + 1;
    for j = 2: num_obj
        index_copy = index_copy + 1;
        prevObj = line(j - 1, :);
        currObj = line(j, :);
        if currObj(1) - prevObj(3) > avgBoxLen
            space(space_ind) = index_copy - 1;
            space_ind = space_ind + 1;
        end
    end
end

% perform classification
load('nist36_model.mat');
% load('nist36_model_old.mat');
load('nist36_model_new.mat');
[outputs] = Classify(W, b, data);
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
text = '';
for i = 1:num_data
    predict = outputs(i, :);
    imshow(mat2gray(reshape(data(i, :), [32,32])));
    [~, ind] = max(predict);
    
    if ~isempty(find(space == i))
        text = [text letters(ind) ' '];
    else
        if ~isempty(find(linebreak == i))
            text = [text letters(ind) char(10)];
        else
            text = [text, letters(ind)];
        end
    end
end
% space
sprintf(text);

% test
fname = '../images/01_list.jpg';
fname = '../images/04_deep.jpg';
fname = '../images/03_haiku.jpg';
fname = '../images/02_letters.jpg';

end
