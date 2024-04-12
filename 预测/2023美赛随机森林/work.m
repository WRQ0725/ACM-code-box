clear;clc;close all

%% 加载数据集
load('iris_train.mat', 'Train_data');%用于建立随机森林的数据集
train =Train_data(1:100,:);
test = Train_data(101:120,:);
train_data = train(:,1:4); % 训练用的卷子
train_label =train(:,5);  % 训练用的答案
test_data = test(:,1:4);   % 测试用的卷子
test_label = test(:,5);    % 测试用的答案

%% 确定最优叶子样本个数和决策树个数
Leaf=[5,10,20,50,100,200,500];
col='rgbcmyk';
figure();
for i=1:length(Leaf)
 RFModel=TreeBagger(1000,train_data,train_label,'Method','regression','OOBPrediction','On','MinLeafSize',Leaf(i));%可以改Method选择是回归还是分类
 plot(oobError(RFModel),col(i));
 hold on
end
xlabel('决策树个数');
ylabel('MSE') ;
LeafTreelgd=legend({'5' '10' '20' '50' '100' '200' '500'},'Location','NorthEast');
title(LeafTreelgd,'叶子个数');

%% 训练随机森林和设置随机森林参数
tic
leaf = 10;%叶子个数
ntrees = 300;%决策树个数
OOBPredicorImportance='on';
Model = TreeBagger(ntrees, train_data,train_label, 'OOBPredictorImportance', OOBPredicorImportance,'Method','regression', 'minleaf',leaf);
disp('随机森林训练')
toc

%% 模型性能评估
%预测测试集
disp('随机森林预测')
y= predict(Model, test_data);
toc
% 计算相关系数
cct=corrcoef(test_label,y);
cct=cct(2,1);
% 绘制散点图
figure()
plot(test_label,test_label,'LineWidth',3);
hold on
scatter(test_label,y,'filled');
hold off
grid on
xlabel('实际值')
ylabel('预测值')
title(['R^2=' num2str(cct^2,2)])

%% 计算变量重要度
importance=Model.OOBPermutedPredictorDeltaError;
figure
bar(importance)
legend('影响程度大小')
xlabel('影响因素')
ylabel('影响程度大小')

load('predict.mat')
class= predict(Model, Predict_data);
for i=1:length(class)
    distance(2)=abs(class(i)-1);
    distance(1)=abs(class(i)-0);
    distance(3)=abs(class(i)-2);
    [value,idx]=sort(distance,'descend');
    class(i)=idx(3)-1;
end
% 绘制散点图
Predict_data=[Predict_data,class];
writematrix(Predict_data, '1.csv');
