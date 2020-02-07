within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
partial model PartialFanCoil4Pipes
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit(
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Air,
    final have_watHea=true,
    final have_watCoo=true,
    final have_fan=true,
    final mHeaWat_flow_nominal=abs(QHea_flow_nominal/cpHeaWat_nominal/(
      T_aHeaWat_nominal - T_bHeaWat_nominal)),
    final mChiWat_flow_nominal=abs(QCoo_flow_nominal/cpChiWat_nominal/(
      T_aChiWat_nominal - T_bChiWat_nominal)));
  import hexConfiguration = Buildings.Fluid.Types.HeatExchangerConfiguration;
  parameter hexConfiguration hexConHea=
    hexConfiguration.CounterFlow
    "Heating heat exchanger configuration";
  parameter hexConfiguration hexConCoo=
    hexConfiguration.CounterFlow
    "Cooling heat exchanger configuration";
  Buildings.Controls.OBC.CDL.Continuous.LimPID conHea(
    Ti=120,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=false,
    yMin=0) "PI controller for heating"
    annotation (Placement(transformation(extent={{-10,210},{10,230}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare final package Medium=Medium2,
    energyDynamics=energyDynamics,
    m_flow_nominal=max({mLoaHea_flow_nominal, mLoaCoo_flow_nominal}),
    redeclare Fluid.Movers.Data.Generic per,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=200,
    final allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexHea(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final configuration=hexConHea,
    final m1_flow_nominal=mHeaWat_flow_nominal,
    final m2_flow_nominal=mLoaHea_flow_nominal,
    final dp1_nominal=0,
    dp2_nominal=100,
    final Q_flow_nominal=QHea_flow_nominal,
    final T_a1_nominal=T_aHeaWat_nominal,
    final T_a2_nominal=T_aLoaHea_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
    annotation (Placement(transformation(extent={{-80,4}, {-60,-16}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiHeaFloNom(k=mHeaWat_flow_nominal)
    annotation (Placement(transformation(extent={{20,210},{40,230}})));
  Modelica.Blocks.Sources.RealExpression Q_flowHea(y=hexHea.Q2_flow)
    annotation (Placement(transformation(extent={{120,210},{140,230}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexCoo(
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final configuration=hexConCoo,
    final m1_flow_nominal=mChiWat_flow_nominal,
    final m2_flow_nominal=mLoaCoo_flow_nominal,
    final dp1_nominal=0,
    dp2_nominal=100,
    final Q_flow_nominal=QCoo_flow_nominal,
    final T_a1_nominal=T_aChiWat_nominal,
    final T_a2_nominal=T_aLoaCoo_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal)
    annotation (Placement(transformation(extent={{0,4},{20,-16}})));
  Modelica.Blocks.Sources.RealExpression Q_flowCoo(y=hexCoo.Q2_flow)
    annotation (Placement(transformation(extent={{120,190},{140,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiFloNom2(k=max({
    mLoaHea_flow_nominal,mLoaCoo_flow_nominal}))
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sigFlo2(k=1)
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conCoo(
    Ti=120,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=true,
    yMin=0) "PI controller for cooling"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiCooFloNom(k=mChiWat_flow_nominal)
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium=Medium2,
    final m_flow_nominal=max(mLoaHea_flow_nominal, mLoaCoo_flow_nominal),
    final allowFlowReversal=allowFlowReversal)
    "Return air temperature (sensed, steady-state)"
    annotation (Placement(transformation(extent={{130,-10},{110,10}})));
equation
  connect(hexCoo.port_b2, hexHea.port_a2)
    annotation (Line(points={{0,0},{-60,0}},     color={0,127,255}));
  connect(fan.port_b, hexCoo.port_a2)
    annotation (Line(points={{70,0},{20,0}}, color={0,127,255}));
  connect(gaiFloNom2.u, sigFlo2.y)
    annotation (Line(points={{18,100},{-58,100}}, color={0,0,127}));
  connect(gaiFloNom2.y, fan.m_flow_in)
    annotation (Line(points={{42,100},{80,100},{80,12}}, color={0,0,127}));
  connect(port_aChiWat, hexCoo.port_a1) annotation (Line(points={{-200,-180},{-20,
          -180},{-20,-12},{0,-12}}, color={0,127,255}));
  connect(hexCoo.port_b1, port_bChiWat) annotation (Line(points={{20,-12},{40,-12},
          {40,-180},{200,-180}}, color={0,127,255}));
  connect(port_aHeaWat, hexHea.port_a1) annotation (Line(points={{-200,-220},{
          -100,-220},{-100,-12},{-80,-12}},
                                       color={0,127,255}));
  connect(hexHea.port_b1, port_bHeaWat) annotation (Line(points={{-60,-12},{-40,
          -12},{-40,-220},{200,-220}}, color={0,127,255}));
  connect(conHea.y, gaiHeaFloNom.u)
    annotation (Line(points={{12,220},{18,220}}, color={0,0,127}));
  connect(conCoo.y, gaiCooFloNom.u)
    annotation (Line(points={{12,180},{18,180}}, color={0,0,127}));
  connect(senTem.port_b, fan.port_a)
    annotation (Line(points={{110,0},{90,0}}, color={0,127,255}));
  connect(gaiHeaFloNom.y,scaMasFloReqHeaWat.u)  annotation (Line(points={{42,220},
          {108,220},{108,100},{158,100}},      color={0,0,127}));
  connect(gaiCooFloNom.y, scaMasFloReqChiWat.u) annotation (Line(points={{42,
          180},{100,180},{100,80},{158,80}}, color={0,0,127}));
  connect(fan.P, scaPFan.u) annotation (Line(points={{69,9},{60,9},{60,140},{
          158,140}}, color={0,0,127}));
  connect(Q_flowHea.y, scaQActHea_flow.u) annotation (Line(points={{141,220},
          {150,220},{150,220},{158,220}}, color={0,0,127}));
  connect(Q_flowCoo.y, scaQActCoo_flow.u) annotation (Line(points={{141,200},
          {158,200},{158,200}}, color={0,0,127}));
  connect(senTem.T, conCoo.u_m) annotation (Line(points={{120,11},{120,40},{0,40},
          {0,168}}, color={0,0,127}));
  connect(senTem.T, conHea.u_m) annotation (Line(points={{120,11},{120,40},{0,40},
          {0,160},{-20,160},{-20,200},{0,200},{0,208}}, color={0,0,127}));
  connect(TSetCoo, conCoo.u_s)
    annotation (Line(points={{-220,180},{-12,180}}, color={0,0,127}));
  connect(TSetHea, conHea.u_s)
    annotation (Line(points={{-220,220},{-12,220}}, color={0,0,127}));
end PartialFanCoil4Pipes;
