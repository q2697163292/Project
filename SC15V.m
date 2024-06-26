function [Y,Xf,Af] = myNeuralNetworkFunction(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Auto-generated by MATLAB, 09-Apr-2024 12:52:09.
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
b1 = [-5.3937075940298013776;-5.002219318629655298;3.9055578963920276614;-3.0377070449219258919;-2.5212754487016582061;-1.6063208271306894659;-0.86635839564461569751;0.12367940483505461546;-0.47033021029556076886;-1.5566392118525245181;-2.5170262011831421312;-2.9523902448042722568;4.1807616058140322224;4.853792200619793995;5.4131429735635396838];
IW1_1 = [5.25270561532715341 -1.5021834341087205722;2.6030222275097512075 4.3265105984593521526;-2.9168645936773538452 4.477499594452255316;5.4314782574632651801 -0.022615966390668179598;5.0234581562590046033 1.6773374316333535816;0.7772267677455789725 -5.3403629883635783671;1.7606207706642340582 5.1103420496268423534;-2.5822694948061730713 -4.7574915653990430542;-1.915150728486134879 5.1181879700298615887;-0.020382991132270000117 5.3889588381665047834;-4.2483370295149907037 3.27793161356906948;-1.5743754255842630219 -5.2632986323111392579;4.2530714065471322272 2.4773830302065835696;3.858643194346060401 3.8894664982976503431;5.0242619699143808987 -2.0522492774816418759];

% Layer 2
b2 = -0.65297580738903793218;
LW2_1 = [-0.23901931561256098413 -0.6553267051384980002 -0.333741704999703237 0.096963457480407785893 0.24685453284777328364 -0.14075247704771082224 -0.1401591631073246802 0.15424986030013265736 0.48054714652279928444 -0.37036686608940527776 -0.93181290942211114636 0.20368488295291056756 0.25516281473540780578 -0.40087952908282781239 -0.38212198413876191649];

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
