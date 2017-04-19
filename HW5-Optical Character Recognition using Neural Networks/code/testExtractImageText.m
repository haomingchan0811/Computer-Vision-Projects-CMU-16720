fnames = cell(4, 1);
fnames{1} = '../images/01_list.jpg';
fnames{2} = '../images/03_haiku.jpg';
fnames{3} = '../images/02_letters.jpg';
fnames{4} = '../images/04_deep.jpg';

texts = cell(4,1);

for i = 1:4
    text = extractImageText(fnames{i});
    texts{i} = text;
end
