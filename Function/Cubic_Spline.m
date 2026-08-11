function smooth_path = Cubic_Spline(path)

% 原始节点数量

n=size(path,1);



% 参数化

t=1:n;



% 插值点

tt=linspace(1,n,200);



%% X方向插值

xx=spline(...
    t,...
    path(:,1),...
    tt);



%% Y方向插值

yy=spline(...
    t,...
    path(:,2),...
    tt);



%% 输出


smooth_path=[xx',yy'];



end