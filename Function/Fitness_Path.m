function fitness = Fitness_Path(x,map,dim)
%FITNESS_PATH Objective function for 2-D robot path planning.
% The objective favours short, smooth and safe paths. Colliding paths are
% still allowed during optimisation, but receive a very large continuous
% penalty so the algorithms can learn how far they are from feasibility.

path = Decode_Path(x,map,dim);

length_cost = 0;
collision_cost = 0;
clearance_cost = 0;
smooth_cost = 0;
spacing_cost = 0;

robot_radius = map.robot_radius;
safe_margin = robot_radius + 3;

for i = 1:size(path,1)-1
    p1 = path(i,:);
    p2 = path(i+1,:);
    segment_length = norm(p2-p1);
    length_cost = length_cost + segment_length;

    if Collision_Check(p1,p2,map)
        collision_cost = collision_cost + 1 + segment_length;
    end

    sample_num = max(5,ceil(segment_length));
    for k = 1:sample_num
        alpha = (k-1)/(sample_num-1);
        point = (1-alpha)*p1 + alpha*p2;
        clearance = Point_Obstacle_Clearance(point,map);
        if clearance < safe_margin
            clearance_cost = clearance_cost + (safe_margin-clearance)^2;
        end
    end
end

for i = 2:size(path,1)-1
    v1 = path(i,:) - path(i-1,:);
    v2 = path(i+1,:) - path(i,:);
    n1 = norm(v1);
    n2 = norm(v2);

    if n1 < eps || n2 < eps
        spacing_cost = spacing_cost + 1;
        continue;
    end

    cos_turn = dot(v1,v2)/(n1*n2);
    cos_turn = max(min(cos_turn,1),-1);
    turn_angle = acos(cos_turn);
    smooth_cost = smooth_cost + turn_angle^2;

    min_spacing = 3;
    if n1 < min_spacing
        spacing_cost = spacing_cost + (min_spacing-n1)^2;
    end
end

W_collision = 100000;
W_clearance = 30;
W_smooth = 20;
W_spacing = 50;

fitness = length_cost + ...
          W_collision*collision_cost + ...
          W_clearance*clearance_cost + ...
          W_smooth*smooth_cost + ...
          W_spacing*spacing_cost;

end

function clearance = Point_Obstacle_Clearance(point,map)
clearance = inf;

for i = 1:length(map.obstacle)
    obstacle = map.obstacle{i};
    xmin = min(obstacle(:,1));
    xmax = max(obstacle(:,1));
    ymin = min(obstacle(:,2));
    ymax = max(obstacle(:,2));

    dx = max([xmin-point(1),0,point(1)-xmax]);
    dy = max([ymin-point(2),0,point(2)-ymax]);

    if dx == 0 && dy == 0
        distance = -min([point(1)-xmin,xmax-point(1),point(2)-ymin,ymax-point(2)]);
    else
        distance = hypot(dx,dy);
    end

    clearance = min(clearance,distance);
end
end
