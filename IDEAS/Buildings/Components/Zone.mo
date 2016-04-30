within IDEAS.Buildings.Components;
model Zone "thermal building zone"
  extends IDEAS.Buildings.Components.Interfaces.StateZone(Eexpr(y=E));
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare replaceable package Medium = IDEAS.Media.Air,
    final mSenFac = corrCV);

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal in zone, false restricts to design direction (port_a -> port_b)."
    annotation(Dialog(tab="Assumptions"));
  parameter Boolean calculateViewFactor = false
    "Explicit calculation of view factors: only for rectangular zones!"
    annotation(Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Volume V "Total zone air volume";
  parameter Real n50(min=0.01)=0.4
    "n50 value cfr airtightness, i.e. the ACH at a pressure diffence of 50 Pa";
  parameter Real corrCV=5 "Multiplication factor for the zone air capacity";

  parameter Boolean linearise=true
    "Linearized computation of long wave radiation";

  final parameter Modelica.SIunits.Power QInf_design=1012*1.204*V/3600*n50/20*(273.15
       + 21 - sim.Tdes)
    "Design heat losses from infiltration at reference outdoor temperature";
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.1*1.224*V/3600;
  final parameter Modelica.SIunits.Power QRH_design=A*fRH
    "Additional power required to compensate for the effects of intermittent heating";
  parameter Real fRH=11
    "Reheat factor for calculation of design heat load, (EN 12831, table D.10 Annex D)"
                                                                                        annotation(Dialog(group="Design heat load"));
  parameter Modelica.SIunits.Area A = V/hZone "Total conditioned floor area" annotation(Dialog(group="Design heat load"));
  parameter Modelica.SIunits.Length hZone = 2.8
    "Zone height: distance between floor and ceiling";
  parameter Real n50toAch=20 "Conversion fractor from n50 to Air Change Rate"
    annotation(Dialog(tab="Advanced"));
  Modelica.SIunits.Power QTra_design=sum(propsBus.QTra_design)
    "Total design transmission heat losses for the zone";
  final parameter Modelica.SIunits.Power Q_design(fixed=false)
    "Total design heat losses for the zone";

  Modelica.SIunits.Temperature TAir=airModel.Tair;
  Modelica.SIunits.Temperature TStar=radDistr.TRad;
  Modelica.SIunits.Energy E = airModel.E;

protected
  IDEAS.Buildings.Components.BaseClasses.ZoneLwGainDistribution radDistr(final
      nSurf=nSurf) "distribution of radiative internal gains" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-50,-50})));
  IDEAS.Buildings.Components.BaseClasses.ZoneLwDistribution radDistrLw(final
      nSurf=nSurf, final linearise=linearise) if not calculateViewFactor
    "internal longwave radiative heat exchange" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-50,-10})));
  Modelica.Blocks.Math.Sum add(nin=2, k={0.5,0.5}) "Operative temperature"
    annotation (Placement(transformation(extent={{66,-6},{78,6}})));

public
  BaseClasses.ZoneLwDistributionViewFactor zoneLwDistributionViewFactor(
    final nSurf=nSurf,
    final hZone=hZone) if calculateViewFactor
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-30,-10})));
  replaceable BaseClasses.WellMixedAir airModel(
    redeclare package Medium = Medium,
    nSurf=nSurf,
    Vtot=V,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    n50=n50,
    n50toAch=n50toAch,
    mSenFac=corrCV)    constrainedby BaseClasses.PartialAirModel(
    redeclare package Medium = Medium,
    nSurf=nSurf,
    Vtot=V,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal,
    n50=n50,
    n50toAch=n50toAch,
    mSenFac=corrCV) "Zone air model"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})), Dialog(tab="Advanced", group="Air model"));

initial equation
  Q_design=QInf_design+QRH_design+QTra_design; //Total design load for zone (additional ventilation losses are calculated in the ventilation system)
equation

  connect(radDistr.radGain, gainRad) annotation (Line(
      points={{-46.2,-60},{100,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radDistr.TRad, add.u[1]) annotation (Line(
      points={{-40,-50},{60,-50},{60,-0.6},{64.8,-0.6}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(propsBus.area, radDistr.area) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-46},{-60,-46}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(propsBus.area, radDistrLw.A) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-14},{-60,-14}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBus.epsLw, radDistrLw.epsLw) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-10},{-60,-10}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBus.epsLw, zoneLwDistributionViewFactor.epsLw) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-10},{-40,-10}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBus.area, zoneLwDistributionViewFactor.A) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-14},{-40,-14}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBus.epsLw, radDistr.epsLw) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-50},{-60,-50}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(propsBus.epsSw, radDistr.epsSw) annotation (Line(
      points={{-100.1,39.9},{-80,39.9},{-80,-54},{-60,-54}},
      color={127,0,0},
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

for i in 1:nSurf loop
  connect(radDistr.iSolDir, propsBus[i].iSolDir) annotation (Line(
      points={{-54,-60},{-100.1,-60},{-100.1,39.9}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(radDistr.iSolDif, propsBus[i].iSolDif) annotation (Line(
      points={{-50,-60},{-50,-64},{-100.1,-64},{-100.1,39.9}},
      color={191,0,0},
      smooth=Smooth.None));
end for;
      if allowFlowReversal then
      else
      end if;
  connect(radDistr.radSurfTot, radDistrLw.port_a) annotation (Line(
      points={{-50,-40},{-50,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(zoneLwDistributionViewFactor.inc, propsBus.inc) annotation (Line(
      points={{-34,-1.77636e-15},{-34,4},{-80,4},{-80,39.9},{-100.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneLwDistributionViewFactor.azi, propsBus.azi) annotation (Line(
      points={{-26,-1.77636e-15},{-26,6},{-80,6},{-80,39.9},{-100.1,39.9}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zoneLwDistributionViewFactor.port_a, radDistr.radSurfTot) annotation (
     Line(
      points={{-30,-20},{-30,-30},{-50,-30},{-50,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(add.y, TSensor) annotation (Line(points={{78.6,0},{78.6,0},{106,0}},
                   color={0,0,127}));
  connect(radDistr.radSurfTot, propsBus.surfRad) annotation (Line(points={{-50,-40},
          {-50,-30},{-80,-30},{-80,39.9},{-100.1,39.9}},      color={191,0,0}));
  connect(airModel.ports_surf, propsBus.surfCon) annotation (Line(points={{-40,30},
          {-80,30},{-80,40},{-98,40},{-100.1,40},{-100.1,39.9}},  color={191,0,0}));
  connect(airModel.inc, propsBus.inc) annotation (Line(points={{-40.8,38},{-80,
          38},{-80,40},{-82,40},{-100.1,40},{-100.1,39.9}},
                                                        color={0,0,127}));
  connect(airModel.azi, propsBus.azi) annotation (Line(points={{-40.8,34},{-80,
          34},{-80,40},{-98,40},{-100.1,40},{-100.1,39.9}},
                                                         color={0,0,127}));
  connect(airModel.A, propsBus.area) annotation (Line(points={{-40.6,24},{-80,
          24},{-80,40},{-96,40},{-100.1,40},{-100.1,39.9}},
                                                        color={0,0,127}));
  connect(airModel.port_b, flowPort_Out) annotation (Line(points={{-34,40},{-34,
          100},{-20,100}}, color={0,127,255}));
  connect(airModel.port_a, flowPort_In) annotation (Line(points={{-26,40},{-26,40},
          {-26,74},{-26,88},{20,88},{20,100}}, color={0,127,255}));
  connect(airModel.ports_air[1], gainCon) annotation (Line(points={{-20,30},{2,30},
          {2,-30},{100,-30}}, color={191,0,0}));
  connect(airModel.Tair, add.u[2]) annotation (Line(points={{-19.2,24},{26,24},{
          26,0.6},{64.8,0.6}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
         graphics),
    Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>Also the thermal response of a zone can be divided into a convective, longwave radiative and shortwave radiative process influencing both thermal comfort in the depicted zone as well as the response of adjacent wall structures.</p>
<p><h5>Description</h5></p>
<p>The air within the zone is modeled based on the assumption that it is well-stirred, i.e. it is characterized by a single uniform air temperature. This is practically accomplished with the mixing caused by the air distribution system. The convective gains and the resulting change in air temperature T_{a} of a single thermal zone can be modeled as a thermal circuit. The resulting heat balance for the air node can be described as c_{a}.V_{a}.dT_{a}/dt = som(Q_{ia}) + sum(h_{ci}.A_{si}.(T_{a}-T_{si})) + sum(m_{az}.(h_{a}-h_{az})) + m_{ae}(h_{a}-h_{ae}) + m_{sys}(h_{a}-h_{sys}) wherefore h_{a} is the specific air enthalpy and where T_{a} is the air temperature of the zone, c_{a} is the specific heat capacity of air at constant pressure, V_{a} is the zone air volume, Q_{a} is a convective internal load, R_{si} is the convective surface resistance of surface s_{i}, A_{si} is the area of surface s_{i}, T_{si} the surface temperature of surface s_{i}, m_{az} is the mass flow rate between zones, m_{ae} is the mass flow rate between the exterior by natural infiltrationa and m_{sys} is the mass flow rate provided by the ventilation system. </p>
<p>Infiltration and ventilation systems provide air to the zones, undesirably or to meet heating or cooling loads. The thermal energy provided to the zone by this air change rate can be formulated from the difference between the supply air enthalpy and the enthalpy of the air leaving the zone <img src=\"modelica://IDEAS/Images/equations/equation-jiSQ22c0.png\" alt=\"h_a\"/>. It is assumed that the zone supply air mass flow rate is exactly equal to the sum of the air flow rates leaving the zone, and all air streams exit the zone at the zone mean air temperature. The moisture dependence of the air enthalpy is neglected.</p>
<p>A multiplier for the zone capacitance f_{ca} is included. A f_{ca} equaling unity represents just the capacitance of the air volume in the specified zone. This multiplier can be greater than unity if the zone air capacitance needs to be increased for stability of the simulation. This multiplier increases the capacitance of the air volume by increasing the zone volume and can be done for numerical reasons or to account for the additional capacitances in the zone to see the effect on the dynamics of the simulation. This multiplier is constant throughout the simulation and is set to 5.0 if the value is not defined <a href=\"IDEAS.Buildings.UsersGuide.References\">[Masy 2008]</a>.</p>
<p>The exchange of longwave radiation in a zone has been previously described in the building component models and further considering the heat balance of the interior surface. Here, an expression based on <i>radiant interchange configuration factors</i> or <i>view factors</i> is avoided based on a delta-star transformation and by definition of a <i>radiant star temperature</i> T_{rs}. Literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption. ThisT_{rs} can be derived from the law of energy conservation in the radiant star node as sum(Q_{si,rs}) must equal zero. Long wave radiation from internal sources are dealt with by including them in the heat balance of the radiant star node resulting in a diffuse distribution of the radiative source.</p>
<p>
An option exist that calculates view factors explicitly and derives the thermal resistances 
between individual surfaces. The implementation however assumes that the zone is rectangular. 
This is often not the case and therefore the implementation is disabled by default.
It can be enabled using parameter <code>calculateViewFactor</code>.
</p>
<p>Transmitted shortwave solar radiation is distributed over all surfaces in the zone in a prescribed scale. This scale is an input value which may be dependent on the shape of the zone and the location of the windows, but literature <a href=\"IDEAS.Buildings.UsersGuide.References\">[Liesen 1997]</a> shows that the overall model is not significantly sensitive to this assumption.</p>
<p><h4><font color=\"#008000\">Validation </font></h4></p>
<p>By means of the <code>BESTEST.mo</code> examples in the <code>Validation.mo</code> package.</p>
</html>", revisions="<html>
<ul>
<li>
April 30, 2016, by Filip Jorissen:<br/>
Added replaceable air model implementation.
</li>
<li>
March, 2015, by Filip Jorissen:<br/>
Added view factor implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end Zone;
