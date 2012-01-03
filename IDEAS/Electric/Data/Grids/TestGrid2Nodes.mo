within IDEAS.Electric.Data.Grids;
record TestGrid2Nodes "2 Node test grid"
 /*
   Simple 2 nodes grid to test components easily.
 */

   extends IDEAS.Electric.Data.Interfaces.GridType(
  Pha=1,n=2,
    T_matrix={{-1,0},{1,-1}},
     LenVec={0,48},
     CabTyp={IDEAS.Electric.Data.Cables.PvcAl35(),
                                IDEAS.Electric.Data.Cables.PvcAl35()});
end TestGrid2Nodes;
