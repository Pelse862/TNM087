clear all

%load('gfun.mat')
%plot(gfun)
%plot(2.^gfun)

for n=1:14
    
    adress=strcat('Img',num2str(n),'.tiff');
    A = (imread(adress));
    
    if n<9
        maxValue(n)=max(max(A(:,:,1)));
    end 
    
    if n == 9
        medianValue = median(median(A(:,:,1)));
    end
    
    if n>9
        minValue(n-9) = min(min(A(:,:,1)));
    end

    bildLager{n} = A(:,:,1);
    B{n}= A;
    
end
figure
imshow(B{9}) 
impixelregion 

figure
graph= [minValue medianValue maxValue];
plot(graph)

%{
img = imread('Img10.tiff'); % Read image
red = img(:,:,1); % Red channel
green = img(:,:,2); % Green channel
blue = img(:,:,3); % Blue channel
a = zeros(size(img, 1), size(img, 2)); %zero(black) matrix big as the image
just_red = cat(3, red, a, a);
just_green = cat(3, a, green, a);
just_blue = cat(3, a, a, blue);
back_to_original_img = cat(3, red, green, blue);
figure, imshow(img), title('Original image')
figure, imshow(just_red), title('Red channel')
figure, imshow(just_green), title('Green channel')
figure, imshow(just_blue), title('Blue channel')
figure, imshow(back_to_original_img), title('Back to original image')
%}

for i=1:8
 maxValue2{i} = max(max(B{i}(:,:,1)));
 C{i+6} = maxValue2{i};
end

medianValue2 = median(median(B{9}(:,:,1)));
C{6} = medianValue2;

for k=10:14
 minValue2{k-9} = min(min(B{k}(:,:,1)));
 C{k-9} = minValue2{k-9};
end

C = cell2mat(C);
figure
plot(C)


%%
clear all

darkImg = imread('Img1.tiff');
maxValue3 = max(max(darkImg(:,:,1)));
[i,j] = find(maxValue3 == darkImg);
lightPos = [i(1),j(1)]

medianImg = imread('Img9.tiff');
medianValue3 = median(median(medianImg(:,:,1)));
[i,j] = find(medianValue3 == medianImg);
medianPos = [i(1),j(1)]

lightImg = imread('Img14.tiff');
minValue3 = min(min(lightImg(:,:,1)));
[i,j] = find(minValue3 == lightImg);
darkPos = [i(1),j(1)]

for n=1:14   
    adress=strcat('Img',num2str(n),'.tiff');
    A = (imread(adress));
    bild = A(:,:,1);  
    dark(n)=bild(darkPos(1),darkPos(2));
    median2(n)=bild(medianPos(1),medianPos(2));
    light(n)=bild(lightPos(1),lightPos(2));  
end

plot(dark, 'r')
hold on
plot(median2, 'g')
hold on
plot(light, 'b')

%%
clear all
for n=1:14
    adress=strcat('Img',num2str(n),'.tiff');
    orginalBild = (imread(adress));   
    imgR(:,:,n) = orginalBild(:,:,1);
    imgG(:,:,n) = orginalBild(:,:,2);
    imgB(:,:,n) = orginalBild(:,:,3);
    orginalBild2{n}= orginalBild;    
end

load('gfun.mat')
% ber�knar f invers
finv = (2.^gfun);

%3 loopar g�r snabbare, v�ldigt konstigt men sant
%Ber�knar exponeringen f�r dem olika kanalerna
dim = size(imgR);
for k=1:14
    for n = 1:dim(1)
       for j = 1:dim(2)
            intensR(n,j,k) = finv(imgR(n,j,k)+1,1)/(2*k);           
       end
    end
end

for k=1:14
    for n = 1:dim(1)
       for j = 1:dim(2)
            intensG(n,j,k) = finv(imgG(n,j,k)+1,2)/(2*k); 
       end
    end
end

for k=1:14
    for n = 1:dim(1)
       for j = 1:dim(2)
            intensB(n,j,k) = finv(imgB(n,j,k)+1,3)/(2*k);
       end
    end
end

dims = size(gfun);
%viktar exponeringen med funktion 10.7
for k = 1:14
    for n = 1:dims(1)
         for j = 1:dims(2)
             if intensR(n,j,k) <= (255/2)
                 intensR(n,j,k) = intensR(n,j,k);
             end
             
             if intensR(n,j,k) >(255/2)
                intensR(n,j,k) = 255 - intensR(n,j,k);
             end
             
             if intensG(n,j,k) <= (255/2)
                 intensG(n,j,k) = intensG(n,j,k);
             end
             
             if intensG(n,j,k) >(255/2)
                intensG(n,j,k) = 255 - intensG(n,j,k);
             end

             if intensB(n,j,k) <= (255/2)
                 intensB(n,j,k) = intensB(n,j,k);
             end
             
             if intensB(n,j,k) >(255/2)
                intensB(n,j,k) = 255 - intensB(n,j,k);
             end
        end
    end
end

%l�gger samman exponeringarna
bildR = intensR(:,:,1);
for n=2:14
    bildR = bildR + intensR(:,:,n);
end

bildG = intensG(:,:,1);
for n=2:14
    bildG = bildG + intensG(:,:,n);
end

bildB = intensB(:,:,1);
for n=2:14
    bildB = bildB + intensB(:,:,n);
end
%Ber�knar slutbild samt plottar
bild = cat(3,bildR,bildG,bildB);

figure
imshow(bild)
title('Bild innan tonemap')
figure
imshow(tonemap(bild))
title('Bild efter tonemap')