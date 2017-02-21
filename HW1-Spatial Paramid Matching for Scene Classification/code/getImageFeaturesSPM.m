function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
%
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
%
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

    % TODO Implement your code here
    
%     % test data
%     dictionarySize = 128;
%     layerNum = 3;
%     load('../data/computer_room/sun_aagspgyvjmoiytfb.mat');
    
    % fetch the dimension of wordMap
    [H, W] = deal(size(wordMap, 1), size(wordMap, 2));
    
    % initialize the histogram and indices 
    L = layerNum - 1;    % layer index
    h = zeros(dictionarySize, (4^(L + 1) - 1) / 3);
    weight = -1;
    dim_h = 1;           % dimension index of h
    
    % index mapping from 2d to 1d
    mapping = zeros(2^L, 2^L);
    
    % bottom-up approach: 
    % compute the finest layer first to reuse intermediate result
    for l = L: -1: 0
        
        % initialize parameters of for loop
        num_split = 2^l;
        len_hSplit = floor(H / num_split);  % length of the splited grid
        len_wSplit = floor(W / num_split);
        
        % decide the weight of current layer
        if l == 0
            weight = 2^(-L);
        else
            weight = 2^(l - L - 1);
        end
        
        for i = 1: num_split
            for j = 1: num_split
%                 fprintf('i = %d, j = %d\n', i, j);

                % initialize histogram of current grid
                hist_grid = zeros(dictionarySize, 1);
                
                % check whether current layer is the finest one
                if l == L
                   % fetch corresponding pixels of wordMap
                   row_head = 1 + len_hSplit * (i - 1);
                   row_tail = len_hSplit * i;
                   col_head = 1 + len_wSplit * (j - 1);
                   col_tail = len_wSplit * j;
                   grid = wordMap(row_head: row_tail, col_head: col_tail);

                   % extract feature of sub-wordMap and store weighted histogram 
                   hist_grid = getImageFeatures(grid, dictionarySize);
                   
                else 
                   % accumulate from layer l+1 to compute layer l
                   for x = i * 2 - 1: i * 2
                       for y = j * 2 - 1: j * 2                           
                           hist_grid = hist_grid + h(:, mapping(x, y));
                       end 
                   end
                end
                
                % update the final vector with weighted histogram
                h(:, dim_h) = weight .* hist_grid;
                
                % record the mapping of corresponding 2d index 
                mapping(i, j) = dim_h;
                dim_h = dim_h + 1;
                
            end
        end
        
        % resize the index mapping to save space
        mapping = mapping(1: num_split, 1: num_split);
        
    end 

    % L1-normalized the histogram
    totalCnt = sum(h(:));
    h = reshape((h ./ totalCnt), [], 1); 

end