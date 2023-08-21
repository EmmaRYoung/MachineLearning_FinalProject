function [measurement] = EstimateCurcumference(x,y)
%This function takes the x and y coordinates of the sliced SMPL model. It
%will estimate the circumference created by the coordinates.

%Basically copied from a VERY useful matlab answer
%https://www.mathworks.com/matlabcentral/answers/565277-how-to-apply-a-fit-on-this-shape
%converts into polar coordinates, fits a function r(theta) to this
%converted data, then switches back into cartesian coordinates for the
%final, useful result. 


mux = mean(x);
muy = mean(y);

[Theta, R] = cart2pol(x-mux, y-muy); %polar coordiantes of mean centered data
[Theta, ind] = sort(Theta);
R = R(ind);

%fourier expansion? ??
n = numel(x);
M = 6;
A = [ones(n,1), sin(Theta*(1:M)), cos(Theta*(1:M))];
coeff = A\R;

Rhat = A*coeff;
[xhat, yhat] = pol2cart(Theta,Rhat);

%close gap between first and last estimated point
xhat(end+1) = xhat(1);
yhat(end+1) = yhat(1);

%find length of these segments
measurement = 0;
for i=1:length(xhat)-1
    xtemp = [xhat(i)-xhat(i+1)];
    ytemp = [yhat(i)-yhat(i+1)];
    
    measurement = measurement + norm([xtemp ytemp]);
end

measurement = measurement*100;
%convert untis? Not sure if this is right



% plot(x,y,'bo', xhat + mux, yhat + muy, '-xr')
% hold on
% 

end

