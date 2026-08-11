function flag = Collision_Check(p1,p2,map)
%% 默认无碰撞

flag = false;

% 障碍物膨胀半径
inflate = 1;

% 输入检查


if isempty(p1) || isempty(p2)

    flag = true;

    return;

end



% 转换为行向量

p1 = p1(:)';

p2 = p2(:)';



if length(p1)~=2 || length(p2)~=2

    error('Collision_Check: 输入必须为二维坐标[x,y]');

end



% 线段离散采样


sample_num = 200;


x_line = linspace(...
    p1(1),...
    p2(1),...
    sample_num);



y_line = linspace(...
    p1(2),...
    p2(2),...
    sample_num);


% 遍历检测点


for k = 1:sample_num


    point_x = x_line(k);

    point_y = y_line(k);



    %% 检查所有障碍物

    for i = 1:length(map.obstacle)



        obstacle = map.obstacle{i};



        % 障碍物边界

       xmin=min(obstacle(:,1))-inflate;

xmax=max(obstacle(:,1))+inflate;


ymin=min(obstacle(:,2))-inflate;

ymax=max(obstacle(:,2))+inflate;



        %% 点是否进入障碍区域


        if point_x >= xmin && ...
           point_x <= xmax && ...
           point_y >= ymin && ...
           point_y <= ymax


            flag = true;

            return;


        end


    end


end



end