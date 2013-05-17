within IDEAS.Buildings.Data.Interfaces;
record Material "Properties of building materials"

extends Modelica.Icons.MaterialProperty;

  parameter Modelica.SIunits.Length d "Layer thickness";
  parameter Modelica.SIunits.ThermalConductivity k "Thermal conductivity";
  parameter Modelica.SIunits.SpecificHeatCapacity c "Specific thermal capacity";
  parameter Modelica.SIunits.Density rho "Density";
  parameter Modelica.SIunits.Emissivity epsLw "Longwave emisivity";
  parameter Modelica.SIunits.Emissivity epsSw "Shortwave emissivity";
  parameter Boolean gas = false "Boolean wether the material is a gas";
  parameter Real mhu(unit="m2/s") = 0
    "Viscosity, i.e. if the material is a fluid";
  parameter Real R = d/k;

  parameter Modelica.SIunits.Emissivity epsLw_a = 0.84 "Longwave emisivity";
  parameter Modelica.SIunits.Emissivity epsLw_b = 0.84 "Longwave emisivity";

  parameter Modelica.SIunits.ThermalDiffusivity alpha = k/(c*rho)
    "Thermal diffusivity";
  parameter Integer nStaRef = 3
    "Number of states of a reference case, ie. 20 cm dense concrete";
  parameter Real piRef = 224
    "d/sqrt(mat.alpha) of a reference case, ie. 20 cm dense concrete";
  parameter Real piLay = d/sqrt(alpha)
    "d/sqrt(mat.alpha) of the depicted layer";
  parameter Integer nSta(min=1) = max(1, integer(ceil(nStaRef*piLay/piRef)))
    "Actual number of state variables in material";

  annotation (Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p><h5>Goal</h5></p>
<p>The <code>Material.mo</code> partial describes the material data required for building construction modelling.</p>
<p><h5>Assumptions and limitations</h5></p>
<p><ol>
<li>Current number of states in the material layer is determined by a reference number of states in a 20cm concrete slab.</li>
</ol></p>
<p><h4><font color=\"#008000\">Validation </font></h4></p>
<p>No validation required.</p>
</html>"));
end Material;
