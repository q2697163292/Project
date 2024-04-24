function [Y,Xf,Af] = myNeuralNetworkFunction(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Auto-generated by MATLAB, 09-Apr-2024 12:48:22.
%
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
%
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = Qx2 matrix, input #1 at timestep ts.
%
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = Qx1 matrix, output #1 at timestep ts.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [250;25];
x1_step1.gain = [0.00266666666666667;0.08];
x1_step1.ymin = -1;

% Layer 1
b1 = [10.87261744204885261;3.8855081098583919008;-3.8934691341309770607;-3.1156367134546383291;3.4682215055100504841;8.0699265359373750783;-11.120424086267632902;-1.3888974115376704344;-1.0178514144396135777;-3.0001983091070307808;-2.9854488289449894189;7.1246835117961735406;3.9130727168138568217;4.6298634290572788785;-5.5287249563037192956];
IW1_1 = [-12.807263778187534697 -1.4305238902685926128;-2.3743190472178579142 -5.8102295428096368823;1.0622182187115063456 3.004715346151192179;4.5686833013143743898 -5.5640935111297151749;-4.5586958860409811933 -1.4223677331788393552;-14.189217082943258674 -5.4801455345272778175;-24.59072200686487264 12.359147732342767867;-9.8029657627903965533 9.5446464299782789453;-3.4003930242828612762 -2.736566613484797017;-2.9433747388421802604 5.0271838871680367689;-3.5139242334687277314 -1.0543591242993859414;1.612843748155135648 8.575765837220073351;3.2434494749448550266 -4.3465353990599933098;3.1579282829395087795 -4.4121626209323920875;-1.6520028734482483657 5.3730422370247907793];

% Layer 2
b2 = -0.93523419786480643801;
LW2_1 = [-5.7232470519713452006 -0.85749515524332320382 -0.68003113795197478453 0.98626475849813366459 2.6937500828845784007 4.6572143408030051148 0.32109497029532851897 -4.0973467361609925419 0.39580388716133596549 2.1756517136476962726 1.0008896504583129072 1.578585790496923158 -1.1415765097884560397 0.35666718049912427002 -0.49544007101484205391];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 0.0900340330547069;
y1_step1.xoffset = 252.523929738118;

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
    X = {X};
end

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
    Q = size(X{1},1); % samples/series
else
    Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS

    % Input 1
    X{1,ts} = X{1,ts}';
    Xp1 = mapminmax_apply(X{1,ts},x1_step1);

    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);

    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;

    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1);
    Y{1,ts} = Y{1,ts}';
end

% Final Delay States
Xf = cell(1,0);
Af = cell(2,0);

% Format Output Arguments
if ~isCellX
    Y = cell2mat(Y);
end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
y = bsxfun(@minus,x,settings.xoffset);
y = bsxfun(@times,y,settings.gain);
y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
x = bsxfun(@minus,y,settings.ymin);
x = bsxfun(@rdivide,x,settings.gain);
x = bsxfun(@plus,x,settings.xoffset);
end
