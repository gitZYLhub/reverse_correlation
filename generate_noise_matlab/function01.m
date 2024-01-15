clear

figure

length = 1600;  %边长像素数
T = length/4.6;   %正弦波空间周期

% X = ones([12, 1]);
% X = zerso([12, 1]);
% for i = 1:12
%     X(i) = 
X = rand([12, 1]);   %随机数权重
% X = [0.9 0.1 0.1 0.9 0.1 0.1 0.9 0.1 0.1 0.9 0.1 0.1];

% 为了生成旋转的正弦波，先生成一个较大的正弦波，旋转不同角度后从每个旋转后的图像中提取出相同大小的区域
% 参考https://blog.csdn.net/qq_35888055/article/details/105297547
I_size = round(length*1.4/2);
A_size = round(length/2);

% alpha = 0.3*pi;

I=zeros(2*I_size,2*I_size);
for i=1:2*I_size
    for j=1:2*I_size
        I(i,j)=128+127*cos(j/T*2*pi);
    end
end
I1=mat2gray(I);
% figure(1),imshow(I1)
I=zeros(2*I_size,2*I_size);
for i=1:2*I_size
    for j=1:2*I_size
        I(i,j)=128+127*cos(j/T*2*pi+pi/2);
    end
end
I2=mat2gray(I);

A=I1;
B=imrotate(A,-30,'bilinear','crop');
%双线性插值法旋转30°，并剪切图像，使得到的图像和原图像大小一致
C=imrotate(A,-60,'bilinear','crop');
D=imrotate(A,-90,'bilinear','crop');
E=imrotate(A,-120,'bilinear','crop');
F=imrotate(A,-150,'bilinear','crop');

A0 = A(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
B0 = B(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
C0 = C(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
D0 = D(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
E0 = E(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
F0 = F(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);

% 缩放振幅
A1 = X(1) * (A0 - 0.5) + 0.5;
B1 = X(2) * (B0 - 0.5) + 0.5;
C1 = X(3) * (C0 - 0.5) + 0.5;
D1 = X(4) * (D0 - 0.5) + 0.5;
E1 = X(5) * (E0 - 0.5) + 0.5;
F1 = X(6) * (F0 - 0.5) + 0.5;
% A1 = X(1) * A0;
% B1 = X(2) * B0;
% C1 = X(3) * C0;
% D1 = X(4) * D0;
% E1 = X(5) * E0;
% F1 = X(6) * F0;

subplot(2,6,1),imshow(A1);
subplot(2,6,2),imshow(B1);
subplot(2,6,3),imshow(C1);
subplot(2,6,4),imshow(D1);
subplot(2,6,5),imshow(E1);
subplot(2,6,6),imshow(F1);

% G1 = (A+B+C+D+E+F)/6;

A=I2;
B=imrotate(A,-30,'bilinear','crop');
%双线性插值法旋转30°，并剪切图像，使得到的图像和原图像大小一致
C=imrotate(A,-60,'bilinear','crop');
D=imrotate(A,-90,'bilinear','crop');
E=imrotate(A,-120,'bilinear','crop');
F=imrotate(A,-150,'bilinear','crop');

A0 = A(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
B0 = B(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
C0 = C(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
D0 = D(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
E0 = E(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);
F0 = F(I_size-A_size:I_size+A_size-1, I_size-A_size:I_size+A_size-1);

% X = rand([12, 1]);

A2 = X(7) * (A0 - 0.5) + 0.5;
B2 = X(8) * (B0 - 0.5) + 0.5;
C2 = X(9) * (C0 - 0.5) + 0.5;
D2 = X(10) * (D0 - 0.5) + 0.5;
E2 = X(11) * (E0 - 0.5) + 0.5;
F2 = X(12) * (F0 - 0.5) + 0.5;
% A2 = X(7) * A0;
% B2 = X(8) * B0;
% C2 = X(9) * C0;
% D2 = X(10) * D0;
% E2 = X(11) * E0;
% F2 = X(12) * F0;

subplot(2,6,1+6),imshow(A2);
subplot(2,6,2+6),imshow(B2);
subplot(2,6,3+6),imshow(C2);
subplot(2,6,4+6),imshow(D2);
subplot(2,6,5+6),imshow(E2);
subplot(2,6,6+6),imshow(F2);

% G2 = (A+B+C+D+E+F)/6;

G = (A1+B1+C1+D1+E1+F1+A2+B2+C2+D2+E2+F2)/12;
G = G(length/2:length, length/2:length);

figure
imshow(G)
