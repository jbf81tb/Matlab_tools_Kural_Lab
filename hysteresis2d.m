function hys=hysteresis2d(img,t1,t2,varargin)
% function hys = HYSTERESIS3D(img,t1,t2,conn)
%
% Usage:        hys = HYSTERESIS2D(img,t1,t2,conn)
%
% Arguments:    img - image for hysteresis (assumed to be non-negative)
%               t1 - lower threshold value (absolute magnitude)
%               t2 - upper threshold value (absolute magnitude)
%                   (t1/t2 can be entered in any order, larger one will be 
%                   set as the upper threshold)
%               conn - number of connectivities (4 or 8 for 2D)     
% Returns:
%               hys - the hysteresis image (logical mask image)
%
% 2012/07/10: written by Luke Xie 
% 2013/12/09: defaults added 
% 2017/09/08: simplified to 2d

%% arguments
if nargin<3
    disp('function needs at least 3 inputs')
    return;
elseif nargin==3
    conn = 4;
elseif nargin==4
    conn = varargin{1};
end
%% scale t1 & t2 based on image intensity range
if t1>t2    % swap values if t1>t2 
	tmp=t1;
	t1=t2; 
	t2=tmp;
end
%% hysteresis
abovet1=img>t1;                                     % points above lower threshold
seed_indices=sub2ind(size(abovet1),find(img>t2));   % indices of points above upper threshold
hys=imfill(~abovet1,seed_indices,conn);             % obtain all connected regions in abovet1 that include points with values above t2
hys=hys & abovet1;
