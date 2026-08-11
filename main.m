clc;
clear;
close all;


%% 添加路径

addpath('./Algorithms');
addpath('./Functions');
addpath('./Map');
addpath('./Plot');


% 地图环境

map = Create_Map();


figure;
hold on;
axis equal;

title('Robot Path Planning Environment');

% 绘制障碍物
for i = 1:length(map.obstacle)

    obs = map.obstacle{i};

    fill(obs(:,1),obs(:,2),...
        [0.3 0.3 0.3]);

end


plot(map.start(1),...
     map.start(2),...
     'go',...
     'MarkerSize',12,...
     'LineWidth',2);


plot(map.goal(1),...
     map.goal(2),...
     'r*',...
     'MarkerSize',12,...
     'LineWidth',2);


xlabel('X');
ylabel('Y');


% 算法参数



SearchAgents = 30;     % 种群数量

Max_iter = 200;        % 最大迭代次数


% 路径控制点数量
point_num=8;

dim=point_num*2;


% 搜索范围
lb=zeros(1,dim);

ub=100*ones(1,dim);
% Fitness函数


fobj = @(x) Fitness_Path(...
        x,...
        map,...
        dim);



% PLO


disp('Running PLO...');


[Best_score_PLO,...
 Best_pos_PLO,...
 Curve_PLO] = PLO(...
 SearchAgents,...
 Max_iter,...
 lb,...
 ub,...
 dim,...
 fobj);





disp('Running CPLO...');


[Best_score_CPLO,...
 Best_pos_CPLO,...
 Curve_CPLO] = CPLO(...
 SearchAgents,...
 Max_iter,...
 lb,...
 ub,...
 dim,...
 fobj);



% BCPLO


disp('Running BCPLO...');


[Best_score_BCPLO,...
 Best_pos_BCPLO,...
 Curve_BCPLO] = BCPLO(...
 SearchAgents,...
 Max_iter,...
 lb,...
 ub,...
 dim,...
 fobj);


% 绘制最终路径



figure;
hold on;
axis equal;

title('Comparison of Robot Paths');


% 障碍物

for i=1:length(map.obstacle)

    obs=map.obstacle{i};

    fill(obs(:,1),obs(:,2),...
        [0.5 0.5 0.5]);

end



% 起点终点

plot(map.start(1),...
     map.start(2),...
     'go',...
     'MarkerSize',12,...
     'LineWidth',2);


plot(map.goal(1),...
     map.goal(2),...
     'r*',...
     'MarkerSize',12,...
     'LineWidth',2);



%% PLO路径

path1 = Decode_Path(...
    Best_pos_PLO,...
    map,...
    dim);


plot(path1(:,1),...
     path1(:,2),...
     'b',...
     'LineWidth',2);



%% CPLO路径

path2 = Decode_Path(...
    Best_pos_CPLO,...
    map,...
    dim);


plot(path2(:,1),...
     path2(:,2),...
     'm',...
     'LineWidth',2);



%% BCPLO路径
% BCPLO路径生成


path3 = Decode_Path(...
    Best_pos_BCPLO,...
    map,...
    dim);



% 绘制原始折线路径

plot(path3(:,1),...
     path3(:,2),...
     'r',...
     'LineWidth',2);


% 三次样条路径平滑

smooth_path=Cubic_Spline(path3);


collision=false;


for i=1:size(smooth_path,1)-1

    if Collision_Check(...
        smooth_path(i,:),...
        smooth_path(i+1,:),...
        map)

        collision=true;

    end

end


if collision

    smooth_path=path3;

end



% 绘制平滑路径

plot(smooth_path(:,1),...
     smooth_path(:,2),...
     'k--',...
     'LineWidth',3);





legend(...
'Obstacle',...
'Start',...
'Goal',...
'PLO',...
'CPLO',...
'BCPLO');

grid on;

legend(...
'Obstacle',...
'Start',...
'Goal',...
'PLO',...
'CPLO',...
'BCPLO');


grid on;


% 保存路径规划结果图

saveas(gcf,...
'./Result/Path_Result.png');

% 收敛曲线


figure;

semilogy(Curve_PLO,...
    'b',...
    'LineWidth',2);

hold on;


semilogy(Curve_CPLO,...
    'm',...
    'LineWidth',2);


semilogy(Curve_BCPLO,...
    'r',...
    'LineWidth',2);


xlabel('Iteration');

ylabel('Fitness');


legend(...
'PLO',...
'CPLO',...
'BCPLO');


title('Convergence Curve');


grid on;

saveas(gcf,...
'./Result/Convergence.png');


%% 输出结果

fprintf('\n========= Result =========\n');

fprintf('PLO  Best Fitness : %.4f\n',...
    Best_score_PLO);


fprintf('CPLO Best Fitness : %.4f\n',...
    Best_score_CPLO);


fprintf('BCPLO Best Fitness: %.4f\n',...
    Best_score_BCPLO);



Result.PLO = Best_score_PLO;

Result.CPLO = Best_score_CPLO;

Result.BCPLO = Best_score_BCPLO;



Result.Path = smooth_path;



Result.Curve_PLO = Curve_PLO;

Result.Curve_CPLO = Curve_CPLO;

Result.Curve_BCPLO = Curve_BCPLO;



save('./Result/Result_Data.mat',...
    'Result');



disp('Result saved successfully');

% Algorithm comparison

Algorithm = {

'PLO'

'CPLO'

'BCPLO'

};



BestFitness=[

Best_score_PLO

Best_score_CPLO

Best_score_BCPLO

];



ResultTable=table(...
Algorithm,...
BestFitness);



disp(ResultTable);



writetable(...
ResultTable,...
'./Result/Algorithm_Result.xlsx');
