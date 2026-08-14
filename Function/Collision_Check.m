function flag = Collision_Check(p1,p2,map)
%COLLISION_CHECK Return true when a segment violates map bounds or obstacles.

flag = false;

if isempty(p1) || isempty(p2)
    flag = true;
    return;
end

p1 = p1(:)';
p2 = p2(:)';

if length(p1)~=2 || length(p2)~=2
    error('Collision_Check: 输入必须为二维坐标[x,y]');
end

robot_radius = map.robot_radius;

if any([p1 p2] < 0) || p1(1) > map.xmax || p2(1) > map.xmax || ...
        p1(2) > map.ymax || p2(2) > map.ymax
    flag = true;
    return;
end

segment_length = norm(p2-p1);
sample_num = max(20,ceil(segment_length*3));
x_line = linspace(p1(1),p2(1),sample_num);
y_line = linspace(p1(2),p2(2),sample_num);

for k = 1:sample_num
    point_x = x_line(k);
    point_y = y_line(k);

    for i = 1:length(map.obstacle)
        obstacle = map.obstacle{i};
        xmin = min(obstacle(:,1))-robot_radius;
        xmax = max(obstacle(:,1))+robot_radius;
        ymin = min(obstacle(:,2))-robot_radius;
        ymax = max(obstacle(:,2))+robot_radius;

        if point_x >= xmin && point_x <= xmax && ...
           point_y >= ymin && point_y <= ymax
            flag = true;
            return;
        end
    end
end
end
