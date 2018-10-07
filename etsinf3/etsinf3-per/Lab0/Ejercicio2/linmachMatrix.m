function indices=linmachMatrix(w,x)
  g=x*w;
  [max_values indices]=max(g');
  indices=indices';
  endfunction
  