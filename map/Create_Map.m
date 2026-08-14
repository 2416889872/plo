function map = Create_Map()

%  Create 2D Robot Environment


%% 地图尺寸

map.xmax = 100;
map.ymax = 100;



%% 起点

map.start = [5,5];


%% 终点

map.goal = [95,95];



%% 障碍物设置

map.obstacle = {};



% 障碍物1

obs1=[
20 20
35 20
35 35
20 35
];


% 障碍物2

obs2=[
55 15
70 15
70 35
55 35
];



% 障碍物3

obs3=[
25 60
45 60
45 80
25 80
];



% 障碍物4

obs4=[
65 55
85 55
85 75
65 75
];



% 障碍物5

obs5=[
45 40
60 40
60 50
45 50
];



map.obstacle{1}=obs1;
map.obstacle{2}=obs2;
map.obstacle{3}=obs3;
map.obstacle{4}=obs4;
map.obstacle{5}=obs5;



%% 障碍物膨胀半径

map.robot_radius = 2;



end
