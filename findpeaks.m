function [pks,locs] = findpeaks(X,Ph,Pd,Np)
%FINDPEAKS Find local peaks in data
%   PKS = FINDPEAKS(X) finds local peaks in the data vector X. A local peak
%   is defined as a data sample which is either larger than the two
%   neighboring samples or is equal to Inf.
%
%   [PKS,LOCS]= FINDPEAKS(X, MPH, MPD, NP) returns the indices LOCS at which the
%   peaks occur; only those peaks that are greater than MINPEAKHEIGHT
%   MPH, that are at least separated by MINPEAKDISTANCE MPD, & the maximum 
%   number of peaks to be found is NP
%
%   % Example 1:
%   %   Find peaks in a vector and plot the result.
%
%   data = [2 12 4 6 9 4 3 1 19 7];     % Define data with peaks
%   [pks,locs] = findpeaks(data)        % Find peaks and their indices
%   plot(data,'Color','blue'); hold on;
%   plot(locs,data(locs),'k^','markerfacecolor',[1 0 0]);

%   Copyright 2007-2012 The MathWorks, Inc.

% narginchk(1,11);

Th = 0;
Str = 'none';
% Replace Inf by realmax because the diff of two Infs is not a number
infIdx = isinf(X);
if any(infIdx),
    X(infIdx) = sign(X(infIdx))*realmax;
end
infIdx = infIdx & X>0; % Keep only track of +Inf

[pks,locs] = getPeaksAboveMinPeakHeight(X,Ph);
[pks,locs] = removePeaksBelowThreshold(X,pks,locs,Th,infIdx);
[pks,locs] = removePeaksSeparatedByLessThanMinPeakDistance(pks,locs,Pd);
[pks,locs] = orderPeaks(pks,locs,Str);
[pks,locs] = keepAtMostNpPeaks(pks,locs,Np);

%--------------------------------------------------------------------------
% function [X,Ph,Pd,Th,Np,Str,infIdx] = parse_inputs(X,varargin)


%--------------------------------------------------------------------------
function [pks,locs] = getPeaksAboveMinPeakHeight(X,Ph)

pks = [];
locs = [];

if all(isnan(X)),
    return,
end

Indx = find(X > Ph);
if(isempty(Indx))
    return
end
    
% Peaks cannot be easily solved by comparing the sample values. Instead, we
% use first order difference information to identify the peak. A peak
% happens when the trend change from upward to downward, i.e., a peak is
% where the difference changed from a streak of positives and zeros to
% negative. This means that for flat peak we'll keep only the rising
% edge.
trend = sign(diff(X));
idx = find(trend==0); % Find flats
N = length(trend);
for i=length(idx):-1:1,
    % Back-propagate trend for flats
    if trend(min(idx(i)+1,N))>=0,
        trend(idx(i)) = 1; 
    else
        trend(idx(i)) = -1; % Flat peak
    end
end
        
idx  = find(diff(trend)==-2)+1;  % Get all the peaks
locs = intersect(Indx,idx);      % Keep peaks above MinPeakHeight
pks  = X(locs);

%--------------------------------------------------------------------------
function [pks,locs] = removePeaksBelowThreshold(X,pks,locs,Th,infIdx)

idelete = [];
for i = 1:length(pks),
    delta = min(pks(i)-X(locs(i)-1),pks(i)-X(locs(i)+1));
    if delta<Th,
        idelete = [idelete i]; %#ok<AGROW>
    end
end
if ~isempty(idelete),
    locs(idelete) = [];
end

pks  = X(locs);

%--------------------------------------------------------------------------
function [pks,locs] = removePeaksSeparatedByLessThanMinPeakDistance(pks,locs,Pd)
% Start with the larger peaks to make sure we don't accidentally keep a
% small peak and remove a large peak in its neighborhood. 

if isempty(pks) || Pd==1,
    return
end

% Order peaks from large to small
[pks, idx] = sort(pks,'descend');
locs = locs(idx);

idelete = ones(size(locs))<0;
for i = 1:length(locs),
    if ~idelete(i),
        % If the peak is not in the neighborhood of a larger peak, find
        % secondary peaks to eliminate.
        idelete = idelete | (locs>=locs(i)-Pd)&(locs<=locs(i)+Pd); 
        idelete(i) = 0; % Keep current peak
    end
end
pks(idelete) = [];
locs(idelete) = [];

%--------------------------------------------------------------------------
function [pks,locs] = orderPeaks(pks,locs,Str)

if isempty(pks), return; end

if strcmp(Str,'none')
    [locs,idx] = sort(locs);
    pks = pks(idx);
else
    [pks,s]  = sort(pks,1,'ascend');
    locs = locs(s);
end

%--------------------------------------------------------------------------
function [pks,locs] = keepAtMostNpPeaks(pks,locs,Np)

if length(pks)>Np,
    locs = locs(1:Np);
    pks  = pks(1:Np);
end

% [EOF]