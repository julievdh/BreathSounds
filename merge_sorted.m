function [outArray,outOrigin] = merge_sorted(in1,in2)
  inAll = [in1(:); flipud(in2(:))];  %# Combine the arrays, flipping the second
  N = numel(inAll);       %# The number of total input values
  iFront = 1;             %# Index for the front of the array
  iBack = N;              %# Index for the back of the array
  outArray = zeros(N,1);  %# Initialize the output array
  outOrigin = zeros(N,1); %# add origin 
  for iOut = 1:N                       %# Loop over the number of values
    if inAll(iFront) <= inAll(iBack)   %# If the front value is smaller ...
      outArray(iOut) = inAll(iFront);  %#    ...add it to the output ...
      iFront = iFront+1;               %#    ...and increment the front index
      outOrigin(iOut) = 1;             %# add origin
    else                               %# Otherwise ...
      outArray(iOut) = inAll(iBack);   %#    ...add the back value ...
      iBack = iBack-1;                 %#    ...and increment the back index
      outOrigin(iOut) = 2;             %# add origin
    end
  end
end