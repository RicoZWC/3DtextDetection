clear all
close all
%Set this to one if you want to calculate the GLCM
% set it to zero if it has allready been calculated
% you need to change the path
pathName = 'F:\Project_detecting3dText\our dataset\';
output_path = 'F:\Project_detecting3dText\Gabor_Magnitude_Median\Lamda_4.16\';

for i = 1:1:255
    a = num2str(i);
    imgName = strcat('a',a);
    img = strcat(pathName,imgName,'.jpg');
    %reading img
    img = (imread(img));
    
%     figure(1);
%     imshow(img, []); % notice the black-and-white frame in 'zebra_1.tif'
%     title('Original image');
    imgName = strcat(output_path,imgName);
    % saveas(figure(1),strcat(imgName,'_1'),'jpg')
    im_rgb = img;
    img = rgb2gray(img);
    
    %%% Gabor Magnitude Calculation
    
    wavelength = 4.16;
    [mag0,phase0] = imgaborfilt(img,wavelength,0);
    [mag1,phase1] = imgaborfilt( img,wavelength,90);
    [mag2,phase0] = imgaborfilt( img,wavelength,45);
    [mag3,phase1] = imgaborfilt( img,wavelength,135);
    
    [mag4,phase0] = imgaborfilt( img,wavelength,180);
    [mag5,phase1] = imgaborfilt( img,wavelength,225);
    [mag6,phase0] = imgaborfilt( img,wavelength,270);
    [mag7,phase1] = imgaborfilt( img,wavelength,315);
    %
    mag =(mag0+mag1+mag2+mag3+mag4+mag5+mag6+mag7)/8;
    %
    img = uint8(mag);
    
    %     end
    calculateGLCM = 1;
    
    G = 8; % We just want to use G gray levels

    img_std = histeq(img,G);
    img_std = uint8(round(double(img_std) * (G-1) / double(max(img_std(:)))));
    
    % %     % Define GLCM-parameters.
    windowSize = 31;
    
    % Remember that the variance is the square of the standard deviation
    
    std_var = stdfilt(img, ones(windowSize)).^2;

    std_ent = entropyfilt(img, ones(windowSize));
    
    [im_v, im_e,new_im] = funct_1(std_var, std_ent);

    text_region1 = uint8(new_im).*im_rgb(:,:,1);
    text_region2 = uint8(new_im).*im_rgb(:,:,2);
    text_region3 = uint8(new_im).*im_rgb(:,:,3);
    
    text_detect = cat(3,text_region1,text_region2,text_region3);
    
    
    figure(1);
    subplot(211);imshow()
    imshow(img, []); % notice the black-and-white frame in 'zebra_1.tif'
    title('Original image');
    subplot(212);imshow(text_detect)
    title('Text intersection of common variance and entropy ');
    saveas(figure(1),strcat(imgName,'_subplot'),'jpg')
    
    close all
end
