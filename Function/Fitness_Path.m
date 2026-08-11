function fitness = Fitness_Path(x,map,dim)


path = Decode_Path(x,map,dim);



%% 参数

length_cost = 0;

collision_cost = 0;

angle_cost = 0;



%% 权重

% 碰撞必须远大于其它指标

Wc = 100000;

Wa = 10;

% 1.路径长度
for i = 1:size(path,1)-1


    p1 = path(i,:);

    p2 = path(i+1,:);


    length_cost = length_cost + norm(p2-p1);


end

% 2.碰撞检测


for i = 1:size(path,1)-1


    p1 = path(i,:);

    p2 = path(i+1,:);



    if Collision_Check(p1,p2,map)

        collision_cost = collision_cost + 1;


    end


end


% 3.转角平滑评价

for i = 2:size(path,1)-1


    p1 = path(i-1,:);

    p2 = path(i,:);

    p3 = path(i+1,:);



    v1 = p1-p2;

    v2 = p3-p2;



    cos_angle = dot(v1,v2) / ...
        (norm(v1)*norm(v2)+eps);



    cos_angle = max(min(cos_angle,1),-1);



    angle = acos(cos_angle);



    angle_cost = angle_cost + angle;


end


% 4.最终适应度

fitness = length_cost + ...
          Wc*collision_cost + ...
          Wa*angle_cost;


end