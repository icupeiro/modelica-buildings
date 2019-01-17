within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Validation;
model Capacities_uSta
  "Validate water side economizer tuning parameter sequence"

  parameter Integer numSta = 2
  "Highest chiller stage";

  parameter Modelica.SIunits.Power staNomCap[numSta + 1] = {small, 5e5, 1e6}
  "Nominal capacity at all chiller stages, starting with stage 0";

  parameter Modelica.SIunits.Power minStaUnlCap[numSta + 1] = {0, 0.2*5e5, 0.2*1e6}
    "Nominal part load ratio for at all chiller stages, starting with stage 0";

  parameter Real small = 0.001
  "Small number to avoid division with zero";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities
    staCap0(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final numSta=2) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities
    staCap1(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final numSta=2)
    "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities
    staCap2(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final numSta=2)
    "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(k=0) "Stage 0"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(k=1) "Stage 1"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage2(k=2) "Stage 2"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta0[numSta + 1]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta2[numSta + 1]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta1[numSta + 1]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  CDL.Continuous.Sources.Constant staCap[numSta + 1](
    final k=staNomCap)
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  CDL.Continuous.Sources.Constant minStaUnload[numSta + 1](
    final k=minStaUnlCap)
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
equation

  connect(stage0.y, staCap0.uSta)
    annotation (Line(points={{-59,60},{-42,60}}, color={255,127,0}));
  connect(stage1.y, staCap1.uSta)
    annotation (Line(points={{-59,0},{-42,0}}, color={255,127,0}));
  connect(stage2.y, staCap2.uSta)
    annotation (Line(points={{-59,-50},{-42,-50}}, color={255,127,0}));
  connect(staCap0.ySta, absErrorSta0[1].u1) annotation (Line(points={{-19,66},{40,
          66},{40,80},{58,80}}, color={0,0,127}));
  connect(staCap0.yStaDow, absErrorSta0[2].u1) annotation (Line(points={{-19,60},
          {40,60},{40,80},{58,80}}, color={0,0,127}));
  connect(staCap0.yStaMin, absErrorSta0[3].u1) annotation (Line(points={{-19,54},
          {40,54},{40,80},{58,80}}, color={0,0,127}));
  connect(staCap1.ySta, absErrorSta1[1].u1) annotation (Line(points={{-19,6},{
          40,6},{40,0},{58,0}},  color={0,0,127}));
  connect(staCap1.yStaDow, absErrorSta1[2].u1) annotation (Line(points={{-19,0},
          {58,0}},                   color={0,0,127}));
  connect(staCap1.yStaMin, absErrorSta1[3].u1) annotation (Line(points={{-19,-6},
          {40,-6},{40,0},{58,0}},     color={0,0,127}));
  connect(staCap2.ySta, absErrorSta2[1].u1) annotation (Line(points={{-19,-44},{
          40,-44},{40,-50},{58,-50}}, color={0,0,127}));
  connect(staCap2.yStaDow, absErrorSta2[2].u1)
    annotation (Line(points={{-19,-50},{58,-50}}, color={0,0,127}));
  connect(staCap2.yStaMin, absErrorSta2[3].u1) annotation (Line(points={{-19,-56},
          {40,-56},{40,-50},{58,-50}}, color={0,0,127}));
  connect(staCap[1].y, absErrorSta0[1].u2)
    annotation (Line(points={{21,30},{70,30},{70,68}}, color={0,0,127}));
  connect(minStaUnload[1].y, absErrorSta0[3].u2) annotation (Line(points={{21,-80},
          {90,-80},{90,60},{70,60},{70,68}}, color={0,0,127}));
  connect(minStaUnload[2].y, absErrorSta1[3].u2) annotation (Line(points={{21,-80},
          {92,-80},{92,-30},{70,-30},{70,-12}}, color={0,0,127}));
  connect(minStaUnload[3].y, absErrorSta2[3].u2)
    annotation (Line(points={{21,-80},{70,-80},{70,-62}}, color={0,0,127}));
  connect(minStaUnload[2].y, absErrorSta1[2].u2) annotation (Line(points={{21,-80},
          {88,-80},{88,-30},{70,-30},{70,-12}}, color={0,0,127}));
  connect(staCap[3].y, absErrorSta2[1].u2) annotation (Line(points={{21,30},{50,
          30},{50,-70},{70,-70},{70,-62}}, color={0,0,127}));
  connect(staCap[2].y, absErrorSta2[2].u2) annotation (Line(points={{21,30},{48,
          30},{48,-70},{70,-70},{70,-62}}, color={0,0,127}));
  connect(staCap[1].y, absErrorSta0[2].u2) annotation (Line(points={{21,30},{40,
          30},{40,32},{70,32},{70,68}}, color={0,0,127}));
  connect(staCap[2].y, absErrorSta1[1].u2) annotation (Line(points={{21,30},{50,
          30},{50,-30},{70,-30},{70,-12}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Generic/Validation/Capacities_uSta.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Capacities_uSta;
