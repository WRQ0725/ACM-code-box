function z = f_xy(x, y)
% 适应度函数
z = - x.^2 - y.^2 + 10*cos(2*pi*x) + 10*cos(2*pi*y) + 100;
end


