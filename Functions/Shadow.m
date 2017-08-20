function post = RemoveShadow(Image)
%   Remove unwanted intensity gradients from image. A by-product of ongoing computational
%   materials science research at MINED@Gatech.(http://mined.gatech.edu/)
%
%   Copyright (c) 2017, Ahmet Cecen  -  All rights reserved.

if isnumeric(Image)
    
    post = zeros(size(Image));
    
    if ismatrix(Image) || ndims(Image) == 3
        
        for ii = 1:size(Image,3)
            current = double(Image(:,:,ii));
            I = mat2gray(current, [0 max(current(:))]);
            I2 = padarray(I,[round(max(size(I))*0.05) round(max(size(I))*0.05)],'replicate');
            filter = double(getnhood(strel('disk',round(max(size(I))*0.05))));
            Shadow = FFTimfilter(I2,filter)./nnz(filter);
            current = I2 - Shadow + mean(I(:));
            current = imcrop(current,[round(max(size(I))*0.05)+1 round(max(size(I))*0.05)+1 size(I,2)-1 size(I,1)-1]);
            current = mat2gray(current, [0 max(current(:))]);
            post(:,:,ii) = current;
        end
        
    else 
        
        errordlg('Input Not Valid!');
        return
        
    end
    
elseif iscell(Image)
    
    post = cell(size(Image));
    
    for jj = 1:length(Image)
        
        currentimage = double(Image{jj});
        currentpost = zeros(size(currentimage));
    
        if ismatrix(currentimage) || ndims(currentimage) == 3

            for ii = 1:size(currentimage,3)
                current = currentimage(:,:,ii);
                I = mat2gray(current, [0 max(current(:))]);
                I2 = padarray(I,[round(max(size(I))*0.05) round(max(size(I))*0.05)],'replicate');
                filter = double(getnhood(strel('disk',round(max(size(I))*0.05))));
                Shadow = FFTimfilter(I2,filter)./nnz(filter);
                current = I2 - Shadow + mean(I(:));
                current = imcrop(current,[round(max(size(I))*0.05)+1 round(max(size(I))*0.05)+1 size(I,2)-1 size(I,1)-1]);
                current = mat2gray(current, [0 max(current(:))]);
                currentpost(:,:,ii) = current;
            end

        else 

            errordlg('Input Not Valid!');
            return

        end
        
        post{jj} = currentpost;
        
    end
    
else
    
    errordlg('Input Not Valid!');
    return
    
end