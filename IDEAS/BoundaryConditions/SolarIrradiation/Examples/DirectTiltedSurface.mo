within IDEAS.BoundaryConditions.SolarIrradiation.Examples;
model DirectTiltedSurface
  "Test model for direct solar irradiation on a tilted surface"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Angle lat=37/180*Modelica.Constants.pi "Latitude";
  IDEAS.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://IDEAS/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  IDEAS.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirRoo(
    til=IDEAS.Types.Tilt.Ceiling,
    lat=0.6457718232379,
    azi=0.78539816339745) "Direct irradiation on roof"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  IDEAS.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirFlo(
    til=IDEAS.Types.Tilt.Floor,
    lat=0.6457718232379,
    azi=0.78539816339745) "Direct irradiation on floor"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  IDEAS.BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirWal(
    til=IDEAS.Types.Tilt.Wall,
    lat=0.6457718232379,
    azi=0.78539816339745) "Direct irradiation on wall"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  IDEAS.Utilities.Diagnostics.AssertEquality assEqu
    "Assert to ensure that direct radiation received by floor construction is zero"
    annotation (Placement(transformation(extent={{60,-66},{80,-46}})));
  Modelica.Blocks.Sources.Constant const(k=0) "Block that outputs zero"
    annotation (Placement(transformation(extent={{-40,-72},{-20,-52}})));
equation
  connect(assEqu.u1, HDirFlo.H) annotation (Line(
      points={{58,-50},{41,-50}},
      color={0,0,127}));
  connect(const.y, assEqu.u2) annotation (Line(
      points={{-19,-62},{58,-62}},
      color={0,0,127}));
  connect(weaDat.weaBus, HDirRoo.weaBus) annotation (Line(
      points={{-40,30},{20,30}},
      color={255,204,51},
      thickness=0.5));
  connect(HDirWal.weaBus, weaDat.weaBus) annotation (Line(
      points={{20,-10},{-10,-10},{-10,30},{-40,30}},
      color={255,204,51},
      thickness=0.5));
  connect(HDirFlo.weaBus, weaDat.weaBus) annotation (Line(
      points={{20,-50},{-10,-50},{-10,30},{-40,30}},
      color={255,204,51},
      thickness=0.5));
  annotation (
experiment(StartTime=1.82304e+07, StopTime=1.83168e+07),
__Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/BoundaryConditions/SolarIrradiation/Examples/DirectTiltedSurface.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the direct solar irradiation received on a ceiling, a wall and a floor.
The assert statement will stop the simulation if the floor receives
any direct solar irradiation.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end DirectTiltedSurface;
