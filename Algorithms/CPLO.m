function [Best_score,Best_pos,Curve]=CPLO(...
    SearchAgents,...
    Max_iter,...
    lb,...
    ub,...
    dim,...
    fobj)
% Logistic混沌初始化


Positions=zeros(SearchAgents,dim);



chaos=zeros(SearchAgents,dim);



for i=1:SearchAgents

    for j=1:dim


        x=rand();


        % Logistic map

        for k=1:10

            x=4*x*(1-x);

        end


        chaos(i,j)=x;


    end


end



Positions=lb+(ub-lb).*chaos;



% 初始适应度



Fitness=zeros(SearchAgents,1);



for i=1:SearchAgents

    Fitness(i)=fobj(Positions(i,:));

end



%% 最优解

[Best_score,index]=min(Fitness);


Best_pos=Positions(index,:);



Curve=zeros(1,Max_iter);



% 迭代优化



for t=1:Max_iter



    % 动态权重

    W1=1/(1+exp(5*(t/Max_iter-0.5)));

    W2=exp(-3*t/Max_iter);



    %% 保存精英个体

    [~,sortIndex]=sort(Fitness);


    Elite=Positions(sortIndex(1),:);



    for i=1:SearchAgents



        X=Positions(i,:);




        % 回转运动
 


        r1=rand();


        Rotation=W1*r1*(Elite-X);



        X1=X+Rotation;

        % 极光搜索



        Levy=Levy_Flight(dim);


        X2=X1+W2*rand()*...
            Levy.*(Elite-X);

        % 引导学习策略
   


        j=randi(SearchAgents);



        Guide=...
            Positions(j,:)+...
            rand()*(Elite-Positions(j,:));



        X3=X2+...
            rand()*(Guide-X2);


        % 边界处理



        X3=max(X3,lb);

        X3=min(X3,ub);



        %% 新适应度


        NewFitness=fobj(X3);



        %% 贪婪更新


        if NewFitness<Fitness(i)


            Positions(i,:)=X3;


            Fitness(i)=NewFitness;


        end



        %% 更新全局最优


        if Fitness(i)<Best_score


            Best_score=Fitness(i);

            Best_pos=Positions(i,:);


        end



    end



    %% 精英保留

    [Worst,index]=max(Fitness);


    if fobj(Elite)<Worst


        Positions(index,:)=Elite;

        Fitness(index)=fobj(Elite);


    end



    Curve(t)=Best_score;



end



end


% Levy Flight



function step=Levy_Flight(dim)


beta=1.5;


sigma=(...
gamma(1+beta)*sin(pi*beta/2)/...
(gamma((1+beta)/2)*beta*...
2^((beta-1)/2)))^(1/beta);



u=randn(1,dim)*sigma;

v=randn(1,dim);



step=u./abs(v).^(1/beta);



end