function [BW] = Grow(V,head)
[a,b,c] = size(V);
visit = zeros(size(V));
queue = [];
queue = [queue;head];
hcell = num2cell(head);
visit(hcell{:}) = 1;
h = 1;
t = 1;
r = 1;
while (h <= t)
   H = queue(h , :);
   h = h + 1;
   x = H(1); y = H(2); z = H(3);
   for s1 = -r : r
       for s2 = -r : r
           for s3 = -r : r
               nx = x + s1;
               ny = y + s2;
               nz = z + s3;
               if (nx >= 1 && nx <= a && ny >= 1 && ny <= b && nz >= 1 && nz <= c)
                   if (visit(nx,ny,nz) == 0 && V(nx,ny,nz) == 1)
                      queue = [queue ; [nx ny nz]];
                      visit(nx,ny,nz) = 1;
                      t = t + 1;
                   end
               end
           end
       end
   end
end
BW = visit == 1;

