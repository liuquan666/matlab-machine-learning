%% TreeDiagram Tree diagram plotting function.
%% Description
% Generates a tree diagram from hierarchical data.
%
% Type TreeDiagram for a demo.
%
% w is optional the defaults are:
%
%  .name      = 'Tree';
%  .width     = 400;
%  .fontName  = 'Times';
%  .fontSize  = 10;
%  .linewidth = 1;
%  .linecolor = 'r';
%
%--------------------------------------------------------------------------
%% Form:
%   TreeDiagram( n, w, update )
%
%% Inputs
%   n        {:}    Nodes
%                   .parent	   (1,1) Parent
%                   .name      (1,1) Number of observation
%                   .row       (1,1) Row number
%   w        (.)    Diagram data structure
%                   .name      (1,:) Tree name
%                   .width     (1,1) Circle width
%                   .fontName  (1,:) Font name
%                   .fontSize  (1,1) Font size
%   update   (1,1)  If entered and true update an existing plot
%
%% Copyright
%   Copyright (c) 2012, 2016 Princeton Satellite Systems, Inc.
%   All rights reserved.

function TreeDiagram( n, w, update )

persistent figHandle

% Demo
%-----
if( nargin < 1 )
  Demo
  return;
end

% Defaults
%---------
if( nargin < 2 )
  w = [];
end
if( nargin < 3 )
  update = false;
end

if( isempty(w) )
  w.name      = 'Tree';
  w.width     = 1200;
  w.fontName  = 'Times';
  w.fontSize  = 10;
  w.linewidth = 1;
  w.linecolor = 'r';
end

% Find row range
%----------------
m      = length(n);
rowMin = 1e9;
rowMax = 0;

for k = 1:m
  rowMin = min([rowMin n{k}.row]);
  rowMax = max([rowMax n{k}.row]);
end

nRows = rowMax - rowMin + 1;
row   = rowMin:rowMax;
rowID = cell(nRows,1);

% Determine which nodes go with which rows
%------------------------------------------
for k = 1:nRows
  for j = 1:m
    if( n{j}.row == row(k) )
      rowID{k} = [rowID{k} j];
    end
  end
end

% Determine the maximum number of circles at the last row
%---------------------------------------------------------
width = 3*length(rowID{nRows})*w.width;

% Draw the tree
%--------------
if( ~update )
  figHandle = NewFigure(w.name);
else
  clf(figHandle)
end

figure(figHandle);
set(figHandle,'color',[1 1 1]);
dY = width/(nRows+2);
y  = (nRows+2)*dY;
set(gca,'ylim',[0 (nRows+1)*dY]);
set(gca,'xlim',[0 width]);
for k = 1:nRows
  
	label = sprintf('Row %d',k);
  
  text(0,y,label,'fontname',w.fontName,'fontsize',w.fontSize);
  x = 4*w.width;
  for j = 1:length(rowID{k})
    node            = rowID{k}(j);
    [xC,yCT,yCB]    = DrawNode( x, y, n{node}.name, w );
    n{node}.xC      = xC;
    n{node}.yCT     = yCT;
    n{node}.yCB     = yCB;
    x               = x + 3*w.width;
  end
  y = y - dY;
end

% Connect the nodes
%------------------
for k = 1:m
  if( ~isempty(n{k}.parent) )
    ConnectNode( n{k}, n{n{k}.parent},w );
  end
end

axis off
axis image


%--------------------------------------------------------------------------
%	Draw a node. This is a circle with a number in the middle.
%--------------------------------------------------------------------------
function [xC,yCT,yCB] = DrawNode( x0, y0, k, w )

n = 20;
a = linspace(0,2*pi*(1-1/n),n);

x = w.width*cos(a)/2 + x0;
y = w.width*sin(a)/2 + y0;
patch(x,y,'w');
text(x0,y0,sprintf('%d',k),'fontname',w.fontName,'fontsize',w.fontSize,'horizontalalignment','center');

xC  = x0;
yCT = y0 + w.width/2;
yCB = y0 - w.width/2;

%--------------------------------------------------------------------------
%	Connect a node to its parent
%--------------------------------------------------------------------------
function ConnectNode( n, nP, w )

x = [n.xC nP.xC];
y = [n.yCT nP.yCB];

line(x,y,'linewidth',w.linewidth,'color',w.linecolor);

%--------------------------------------------------------------------------
%	Create the demo data structure
%--------------------------------------------------------------------------
function Demo

k = 1;
%---------------
row        = 1;
d.parent	= [];
d.name     = 1;
d.row      = row;
n{k}        = d; k = k + 1;

%---------------
row        = 2;

d.parent    = 1;
d.name     = 1;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 1;
d.name     = 2;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = [];
d.name     = 3;
d.row      = row;
n{k}        = d; k = k + 1;

%---------------
row        = 3;

d.parent    = 2;
d.name     = 1;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 2;
d.name     = 4;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 3;
d.name     = 2;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 3;
d.name     = 5;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 4;
d.name     = 6;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 4;
d.name     = 7;
d.row      = row;
n{k}        = d; k = k + 1;


%---------------
row        = 4;

d.parent    = 5;
d.name     = 1;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 6;
d.name     = 8;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 6;
d.name     = 4;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 7;
d.name     = 2;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 7;
d.name     = 9;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 9;
d.name     = 10;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 10;
d.name     = 11;
d.row      = row;
n{k}        = d; k = k + 1;

d.parent    = 10;
d.name     = 12;
d.row      = row;
n{k}        = d;

%---------------
% Call the function with the demo data
TreeDiagram( n )
