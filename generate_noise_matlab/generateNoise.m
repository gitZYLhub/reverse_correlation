clear
close all

img_size = 512;
T = 256;
n_scale = 5;

scales = [1, 2, 4, 8, 16];
scalesnum = size(scales, 2);
images = zeros(scalesnum, img_size, img_size);
for i = 1:scalesnum
    scale = scales(i);
    for m = 1:scale
        for n = 1:scale
            R = rand(12,1)*2-1;
            img_size_1 = img_size/scale;
            T_1 = T/scale;
            G = generateMultiSinusoid(img_size_1, T_1, R);
            images(i, (m-1)*img_size_1+1:m*img_size_1, (n-1)*img_size_1+1:n*img_size_1) = G;
        end
    end
end
image = squeeze(sum(images, 1))/scalesnum;
image = image - min(min(image));
image = image/max(max(image));
figure
imshow(image);


function G = generateMultiSinusoid(img_size, T, R)

A = zeros(12, img_size, img_size);
for i_2 = 1:6
    A_temp = generateSingleSinusoid(img_size, 30*(i_2-1), 0, T);
    A(i_2,:,:) = R(i_2) * ( A_temp - 0.5 ) + 0.5;
end
for i_2 = 7:12
    A_temp = generateSingleSinusoid(img_size, 30*(i_2-1), pi/2, T);
    A(i_2,:,:) = R(i_2) * ( A_temp - 0.5 ) + 0.5;
end
G = squeeze(sum(A,1))/12;

end


function G = generateSingleSinusoid(img_size, angle, phase, T)

G = zeros(img_size);
angle = deg2rad(angle);
direction = [cos(angle), -sin(angle)];

for i_1 = 1:img_size
    for j_1 = 1:img_size
        x = i_1*sin(angle) + j_1*cos(angle);
        G(i_1,j_1) = 0.5+0.5*sin(x*2*pi/T + phase);
    end
end

end