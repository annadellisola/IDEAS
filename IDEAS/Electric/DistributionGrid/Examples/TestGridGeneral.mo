within IDEAS.Electric.DistributionGrid.Examples;
model TestGridGeneral

   IDEAS.Electric.DistributionGrid.Examples.Components.SinePower
                                            risingflankSingle
     annotation (Placement(transformation(extent={{40,0},{60,20}})));
   IDEAS.Electric.DistributionGrid.GridGeneral
                       gridGeneral(
     redeclare IDEAS.Electric.Data.Grids.TestGrid2Nodes grid,
     Phases=1,
     traPre=true,
     houCon=true)
     annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
   IDEAS.Electric.DistributionGrid.GridGeneral
                       gridGeneral1(
     redeclare IDEAS.Electric.Data.Grids.TestGrid2Nodes grid,
     Phases=3,
     traPre=true,
     houCon=true)
     annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
   IDEAS.Electric.DistributionGrid.Examples.Components.SinePower
                                            risingflankSingle1[
                                        3]
     annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

equation
  for i in 1:3 loop
  end for;
   connect(gridGeneral.gridNodes[2], risingflankSingle.nodes) annotation (Line(
       points={{-20,10},{40,10}},
       color={0,0,255},
       smooth=Smooth.None));

  connect(gridGeneral1.gridNodes3P[:, 2], risingflankSingle1.nodes) annotation (
     Line(
      points={{-20,-30},{40,-30}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=1.2096e+006, Interval=600),
    __Dymola_experimentSetupOutput);
end TestGridGeneral;
