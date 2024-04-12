[n,m] = size(result);
disp(['共有' num2str(n) '个评价对象, ' num2str(m) '个评价指标']) 
Judge = input(['这' num2str(m) '个指标是否需要经过正向化处理，需要请输入1 ，不需要输入0：  ']);
if Judge == 1
    Position = input('请输入需要正向化处理的指标所在的列，例如第2、3、6三列需要处理，那么你需要输入[2,3,6]： '); %[2,3,6]
    disp('请输入需要处理的这些列的指标类型（1：极小型， 2：中间型， 3：区间型） ')
    Type = input('例如：第2列是极小型，第3列是区间型，第6列是中间型，就输入[1,3,2]：  '); %[2,1,3]
    % 注意，Position和Type是两个同维度的行向量
    for i = 1 : size(Position,2)  %这里需要对这些列分别处理，因此我们需要知道一共要处理的次数，即循环的次数
        result(:,Position(i)) = Positivization(result(:,Position(i)),Type(i),Position(i));
    % Positivization是我们自己定义的函数，其作用是进行正向化，其一共接收三个参数
    % 第一个参数是要正向化处理的那一列向量 X(:,Position(i))   回顾上一讲的知识，X(:,n)表示取第n列的全部元素
    % 第二个参数是对应的这一列的指标类型（1：极小型， 2：中间型， 3：区间型）
    % 第三个参数是告诉函数我们正在处理的是原始矩阵中的哪一列
    % 该函数有一个返回值，它返回正向化之后的指标，我们可以将其直接赋值给我们原始要处理的那一列向量
    end
    disp('正向化后的矩阵 result =  ')
    disp(result)
end
Z = result ./ repmat(sum(result.*result) .^ 0.5, n, 1);
Z(:,2)=Z(:,2)*10;
disp('标准化矩阵 Z = ')
disp(Z)
W=[0.3,0.7];%指标权重，需要动态调整
% S=W(1).*Z(:,1)+W(2).*Z(:,2);
D_P = sum(repmat(W,n,1).*(Z - repmat(max(Z),n,1)) .^ 2 ,2) .^ 0.5;   % D+ 与最大值的距离向量
D_N = sum(repmat(W,n,1).*(Z - repmat(min(Z),n,1)) .^ 2 ,2) .^ 0.5;   % D- 与最小值的距离向量
S = D_N ./ (D_P+D_N);    % 未归一化的得分
% disp('最后的得分为：')
stand_S = S / sum(S);%归一化后的得分
stand_S =stand_S(405:end);
[sorted_S,index] = sort(stand_S ,'descend');
stand_S=reshape(stand_S,101,96);
rank=zeros(101,96);
for i=1:length(index)
    rank(index(i))=i;
end
[~, idx] = max(stand_S(:));
[m, n] = size(stand_S);
[row, col] = ind2sub([m, n], idx);
h=heatmap(rank);


filename = 'rank.csv';  % 保存的文件名
writematrix(rank, filename);
