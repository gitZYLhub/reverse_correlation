close all
clear

I_size = 2240/2;
A_size = 1600/2;

image = zeros(A_size);

num_list = [1, 2, 4, 8, 16];

for k = 1:5
    
    num = num_list(k);
    H = zeros(A_size);
    length = size(H, 1)/num;
    % T = 800;
    T = A_size/(2*num);

    X = rand(12, num, num);
    for m = 1:num
        for n = 1:num
            % X = zeros(12,1)
            % for a = 1:12
            %     X(a) = 
            G = basic_image(2*length, T, squeeze(X(:,m,n)));
            H(((m-1)*length+1):m*length,((n-1)*length+1):n*length) = G;
        end
    end
    image = image + H;
    figure(k);
    imshow(H);

end
image = image/5;
image = image/max(max(image));
figure(6);
imshow(image);



function G = basic_image(length, T, X)

I_size = round(length*1.4/2);
A_size = round(length/2);

I=zeros(2*I_size,2*I_size);
for i=1:2*I_size
    for j=1:2*I_size
        I(i,j)=128+127*cos(j/T*2*pi+pi/4);
    end
end
I1=mat2gray(I);
% figure(1),imshow(I1)
I=zeros(2*I_size,2*I_size);
for i=1:2*I_size
    for j=1:2*I_size
        I(i,j)=128+127*cos(j/T*2*pi+3*pi/4);
    end
end
I2=mat2gray(I);

A=I1;
B=imrotate(A,30,'bilinear','crop');
%双线性插值法旋转30°，并剪切图像，使得到的图像和原图像大小一致
C=imrotate(A,60,'bilinear','crop');
D=imrotate(A,90,'bilinear','crop');
E=imrotate(A,120,'bilinear','crop');
F=imrotate(A,150,'bilinear','crop');

A0 = A(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
B0 = B(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
C0 = C(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
D0 = D(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
E0 = E(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
F0 = F(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);

% A = X(1) * (A0 - 0.5) + 0.5;
% B = X(2) * (B0 - 0.5) + 0.5;
% C = X(3) * (C0 - 0.5) + 0.5;
% D = X(4) * (D0 - 0.5) + 0.5;
% E = X(5) * (E0 - 0.5) + 0.5;
% F = X(6) * (F0 - 0.5) + 0.5;
A = X(1) * A0;
B = X(2) * B0;
C = X(3) * C0;
D = X(4) * D0;
E = X(5) * E0;
F = X(6) * F0;

G1 = (A+B+C+D+E+F)/6;

A=I2;
B=imrotate(A,30,'bilinear','crop');
%双线性插值法旋转30°，并剪切图像，使得到的图像和原图像大小一致
C=imrotate(A,60,'bilinear','crop');
D=imrotate(A,90,'bilinear','crop');
E=imrotate(A,120,'bilinear','crop');
F=imrotate(A,150,'bilinear','crop');

A0 = A(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
B0 = B(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
C0 = C(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
D0 = D(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
E0 = E(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
F0 = F(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);

% A = X(7) * (A0 - 0.5) + 0.5;
% B = X(8) * (B0 - 0.5) + 0.5;
% C = X(9) * (C0 - 0.5) + 0.5;
% D = X(10) * (D0 - 0.5) + 0.5;
% E = X(11) * (E0 - 0.5) + 0.5;
% F = X(12) * (F0 - 0.5) + 0.5;
A = X(7) * A0;
B = X(8) * B0;
C = X(9) * C0;
D = X(10) * D0;
E = X(11) * E0;
F = X(12) * F0;

G2 = (A+B+C+D+E+F)/6;

G = (G1 + G2)/2;
G = G/max(max(G));
G = G(length/2+1:length, length/2+1:length);

end