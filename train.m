function [ W,B ] = train( epoches, eta, layer )
%��������ֱ�Ϊ epochesΪѵ��������eta��ʾѧϰ���ʣ�layer������ṹ������ʾ����[m,n]=train(10, 3, [784, 30, 10]);
image = loadMNISTImages('train-images'); % ��������ͼ��60000��size(image)=784*60000
label = loadMNISTLabels('train-labels');%��������ͼ���Ӧ��ǩ
for i = 1:60000
    label_tmp = zeros(10,1);
    label_tmp(label(i)+1) = 1;
    images{i} = {image(:,i) label_tmp};%����Cell�������������ǩ��Ӧ�ش洢����
end 
%TRAIN Summary of this function goes here
%   Detailed explanation goes here
layer_num = size(layer,2);%ȷ��������ṹ�Ĳ���
%size(layer)=1,3; size(layer,2)=3;
batch_num = 10;

for i = 2:layer_num%�����ʼ��Ȩֵw��ƫ��b����ֵΪ��-1��1��֮��������
    W{i} = [];
    B{i} = [];
    W{i} = randn(layer(i),layer(i-1));
    %layer= [784, 30, 10]����layer(2)=30��layer(3)=10��
    B{i} = randn(layer(i),1);
    %�������д���ֱ�������ɵ�2�㵽��3�㣬��3���ڷ��򵽵�2���Ȩֵ��ƫ��
end 

for i = 1:epoches %ѵ������ѭ��
    r = randperm(size(images,2));%�������60000��ѵ�������ı�ǩ��Ȼ���ٽ���ѵ��
    images = images(:,r);
    for j = 1:batch_num:59991%��10��ѵ������Ϊһ�飬������Ȩֵw��ƫ��b
        for k = 2:layer_num%ֻ�дӵ�2���Ժ����Ȩֵw��ƫ��b
            NABLA_B{k} = zeros(layer(k),1);%ƫ�ó�ʼ��
            NABLA_W{k} = zeros(layer(k),layer(k-1));%Ȩֵ��ʼ��
        end
        cur_batch = images(:,j:j+batch_num-1);%��image��ȡ��10��ͼ��*��ǩ
        for k = 1:batch_num% ��10��ͼ�����ѭ��
            [A, Z]= feedforward(cur_batch{k}{1},W,B);%A������������
            [nabla_b,nabla_w] = backprop(A,W,Z, cur_batch{k}{2});%����Ȩֵ��ƫ�õ�������
            
            for m = 2:layer_num
                NABLA_B{m} = NABLA_B{m} + nabla_b{m};
                NABLA_W{m} = NABLA_W{m} + nabla_w{m};
                %�����д��룺�Բ���ѭ����Ȼ���ƫ�ú�Ȩֵ���
            end
        end
        %fprintf('%f %d %f %f %f\n',A{3}(2),j,B{2}(1),NABLA_B{2}(1), eta.*NABLA_B{2}(1)./batch_num);
        for k = 2:layer_num
            B{k} = B{k} - eta.*NABLA_B{k}./batch_num;
            W{k} = W{k} - eta.*NABLA_W{k}./batch_num;
        end
    end
%  test(W,B);
end
end

