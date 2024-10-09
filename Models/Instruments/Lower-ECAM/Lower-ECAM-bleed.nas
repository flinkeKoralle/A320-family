# A3XX Lower ECAM Canvas
# Copyright (c) 2024 Josh Davidson (Octal450) and Jonathan Redpath

var canvas_lowerECAMPageBleed =
{
	new: func(svg,name) {
		var obj = {parents: [canvas_lowerECAMPageBleed,canvas_lowerECAM_base] };
        obj.group = obj.canvas.createGroup();
		obj.name = name;
        
		canvas.parsesvg(obj.group, svg, {"font-mapper": obj.font_mapper} );
		
 		foreach(var key; obj.getKeys()) {
			obj[key] = obj.group.getElementById(key);
		};
		
		foreach(var key; obj.getKeysBottom()) {
			obj[key] = obj.group.getElementById(key);
		};
		
		# init
		
		obj.update_items = [
			props.UpdateManager.FromHashList(["BleedCrossbleed","apuMaster","apuBleedValvePos"], 0.1, func(val) {
				if (val.apuMaster) {
					if (val.apuBleedValvePos >= 0.9) {
						obj["BLEED-APU-CIRCLE"].setRotation(0);
						obj["BLEED-APU-connectionTop"].show();
						obj["BLEED-xbleedLeft"].show();
					} else {
						obj["BLEED-APU-CIRCLE"].setRotation(90 * D2R);
						obj["BLEED-APU-connectionTop"].hide();
						if (val.BleedCrossbleed < 0.9) {
							obj["BLEED-xbleedLeft"].hide();
						} else {
							obj["BLEED-xbleedLeft"].show();
						}
					}
				} else {
					if (val.BleedCrossbleed < 0.9) {
						obj["BLEED-xbleedLeft"].hide();
					} else {
						obj["BLEED-xbleedLeft"].show();
					}
				}
			}),
			props.UpdateManager.FromHashList(["ApuBleedNotOn","apuMaster"], 1, func(val) {
				if (val.apuMaster) {
					obj["BLEED-APU-LINES"].show();
					if (val.ApuBleedNotOn != 1) {
						obj["BLEED-APU-CIRCLE"].setColor(0.0509,0.7529,0.2941);
					} else {
						obj["BLEED-APU-CIRCLE"].setColor(0.7333,0.3803,0);
					}
				} else {
					obj["BLEED-APU-LINES"].hide();
					obj["BLEED-APU-connectionTop"].hide();
				}
			}),
			props.UpdateManager.FromHashList(["flowCtlValve1","flowCtlValve2","RamAirValve","gear1Wow"], 0.1, func(val) {
				if (val.RamAirValve <= 0.1) {
					obj["BLEED-Ram-Air"].setRotation(90 * D2R);
					obj["BLEED-Ram-Air"].setColor(0.0509,0.7529,0.2941);
					obj["BLEED-Ram-Air"].setColorFill(0.0509,0.7529,0.2941);
					obj["BLEED-Ram-Air-Cross"].setColorFill(0.0509,0.7529,0.2941);
					obj["BLEED-Ram-Air-connection"].hide();
				} elsif (val.RamAirValve >= 0.9) {
					obj["BLEED-Ram-Air"].setRotation(0);
					if (val.gear1Wow) {
						obj["BLEED-Ram-Air"].setColor(0.7333,0.3803,0);
						obj["BLEED-Ram-Air"].setColorFill(0.7333,0.3803,0);
						obj["BLEED-Ram-Air-Cross"].setColorFill(0.7333,0.3803,0);
						obj["BLEED-Ram-Air-connection"].setColorFill(0.7333,0.3803,0);
						obj["BLEED-Ram-Air-connection"].setColorFill(0.7333,0.3803,0);
					} else {
						obj["BLEED-Ram-Air"].setColor(0.0509,0.7529,0.2941);
						obj["BLEED-Ram-Air"].setColorFill(0.0509,0.7529,0.2941);
						obj["BLEED-Ram-Air-Cross"].setColorFill(0.0509,0.7529,0.2941);
						obj["BLEED-Ram-Air-connection"].setColor(0.0509,0.7529,0.2941);
						obj["BLEED-Ram-Air-connection"].setColorFill(0.0509,0.7529,0.2941);
					}
					obj["BLEED-Ram-Air-connection"].show();
				} else {
					obj["BLEED-Ram-Air"].setRotation(45 * D2R);
					obj["BLEED-Ram-Air"].setColor(0.7333,0.3803,0);
					obj["BLEED-Ram-Air"].setColorFill(0.7333,0.3803,0);
					obj["BLEED-Ram-Air-Cross"].setColorFill(0.7333,0.3803,0);
					obj["BLEED-Ram-Air-connection"].setColorFill(0.7333,0.3803,0);
					obj["BLEED-Ram-Air-connection"].setColorFill(0.7333,0.3803,0);
					obj["BLEED-Ram-Air-connection"].show();
				}
				
				if (val.flowCtlValve1 <= 0.1 and val.flowCtlValve2 <= 0.1) {
					if (val.gear1Wow or val.RamAirValve < 0.9) {
						obj["BLEED-cond-1"].setColor(0.7333,0.3803,0);
						obj["BLEED-cond-2"].setColor(0.7333,0.3803,0);
						obj["BLEED-cond-3"].setColor(0.7333,0.3803,0);
					} else {
						obj["BLEED-cond-1"].setColor(0.0509,0.7529,0.2941);
						obj["BLEED-cond-2"].setColor(0.0509,0.7529,0.2941);
						obj["BLEED-cond-3"].setColor(0.0509,0.7529,0.2941);
					}
				} else {
					obj["BLEED-cond-1"].setColor(0.0509,0.7529,0.2941);
					obj["BLEED-cond-2"].setColor(0.0509,0.7529,0.2941);
					obj["BLEED-cond-3"].setColor(0.0509,0.7529,0.2941);
				}
			}),
			props.UpdateManager.FromHashList(["BleedCrossbleedCmd","BleedCrossbleedPositionMatch"], nil, func(val) {
				if (val.BleedCrossbleedPositionMatch) {
					obj["BLEED-XFEED"].setColor(0.0509,0.7529,0.2941);
					obj["BLEED-XFEED-Cross"].setColorFill(0.0509,0.7529,0.2941);
					if (val.BleedCrossbleedCmd) {
						obj["BLEED-XFEED"].setRotation(0);
					} else {
						obj["BLEED-XFEED"].setRotation(90 * D2R);
					}
				} else {
					obj["BLEED-XFEED"].setColor(0.7333,0.3803,0);
					obj["BLEED-XFEED-Cross"].setColorFill(0.7333,0.3803,0);
					obj["BLEED-XFEED"].setRotation(45 * D2R);
				}
			}),
			props.UpdateManager.FromHashValue("BleedCrossbleed", 0.1, func(val) {
				if (val >= 0.9) {
					obj["BLEED-xbleedCenter"].show();
					obj["BLEED-xbleedRight"].show();
				} else {
					obj["BLEED-xbleedCenter"].hide();
					obj["BLEED-xbleedRight"].hide();
				}
			}),
			props.UpdateManager.FromHashValue("BleedHPValve1Cmd", 1, func(val) {
				if (val) {
					obj["BLEED-HP-Valve-1"].setRotation(90 * D2R);
					obj["BLEED-HP-1-connection"].show();
				} else {
					obj["BLEED-HP-Valve-1"].setRotation(0);
					obj["BLEED-HP-1-connection"].hide();
				}
			}),
			props.UpdateManager.FromHashValue("BleedHPValve2Cmd", 1, func(val) {
				if (val) {
					obj["BLEED-HP-Valve-1"].setRotation(90 * D2R);
					obj["BLEED-HP-1-connection"].show();
				} else {
					obj["BLEED-HP-Valve-1"].setRotation(0);
					obj["BLEED-HP-1-connection"].hide();
				}
			}),
			props.UpdateManager.FromHashValue("bleedHPValve1PositionMatch", 1, func(val) {
				if (val) {
					obj["BLEED-HP-Valve-1"].setColor(0.0509,0.7529,0.2941);
				} else {
					obj["BLEED-HP-Valve-1"].setColor(0.7333,0.3803,0);
				}
			}),
			props.UpdateManager.FromHashValue("bleedHPValve2PositionMatch", 1, func(val) {
				if (val) {
					obj["BLEED-HP-Valve-2"].setColor(0.0509,0.7529,0.2941);
				} else {
					obj["BLEED-HP-Valve-2"].setColor(0.7333,0.3803,0);
				}
			}),
			props.UpdateManager.FromHashValue("BleedPreCoolerPSI1", 1, func(val) {
				obj.bleedPrecoolerInlet1Pressure = sprintf("%s", math.clamp(math.round(val, 2), -99, 98));
				
				if (val < 4 or val > 57) {
					obj.bleedPrecoolerInlet1PressureOut = 1;
				} else {
					obj.bleedPrecoolerInlet1PressureOut = 0;
				}
			}),
			props.UpdateManager.FromHashValue("BleedPreCoolerPSI2", 1, func(val) {
				obj.bleedPrecoolerInlet2Pressure = sprintf("%s", math.clamp(math.round(val, 2), -99, 98));
				
				if (val < 4 or val > 57) {
					obj.bleedPrecoolerInlet2PressureOut = 1;
				} else {
					obj.bleedPrecoolerInlet2PressureOut = 0;
				}
			}),
			props.UpdateManager.FromHashValue("BleedPreCoolerTemp1", 0.5, func(val) {
				obj.bleedPrecoolerTemp1 = sprintf("%s", math.clamp(math.round(val, 5), -999, 510));
			}),
			props.UpdateManager.FromHashValue("BleedPreCoolerTemp2", 0.5, func(val) {
				obj.bleedPrecoolerTemp2 = sprintf("%s", math.clamp(math.round(val, 5), -999, 510));
			}),
			props.UpdateManager.FromHashList(["BleedBMC1Working","bleedPrecoolerTemp1Lo","BleedPRVValve1Cmd","BleedPreCoolerOvht1"], nil, func(val) {
				if (val.BleedBMC1Working) {
					if (val.BleedPRVValve1Cmd and (val.bleedPrecoolerTemp1Lo or val.BleedPreCoolerOvht1)) {
						obj["BLEED-Precooler-1-Outlet-Temp"].setColor(0.7333,0.3803,0);
					} else {
						obj["BLEED-Precooler-1-Outlet-Temp"].setColor(0.0509,0.7529,0.2941);
					}
				} else {
					obj["BLEED-Precooler-1-Outlet-Temp"].setColor(0.7333,0.3803,0);
				}
			}),
			props.UpdateManager.FromHashList(["BleedBMC2Working","bleedPrecoolerTemp2Lo","BleedPRVValve2Cmd","BleedPreCoolerOvht2"], nil, func(val) {
				if (val.BleedBMC2Working) {
					if (val.BleedPRVValve2Cmd and (val.bleedPrecoolerTemp2Lo or val.BleedPreCoolerOvht2)) {
						obj["BLEED-Precooler-2-Outlet-Temp"].setColor(0.7333,0.3803,0);
					} else {
						obj["BLEED-Precooler-2-Outlet-Temp"].setColor(0.0509,0.7529,0.2941);
					}
				} else {
					obj["BLEED-Precooler-2-Outlet-Temp"].setColor(0.7333,0.3803,0);
				}
			}),
			props.UpdateManager.FromHashValue("Pack1Bypass", 1, func(val) {
				obj["BLEED-Pack-1-Bypass-needle"].setRotation((val - 50) * D2R);
			}),
			props.UpdateManager.FromHashValue("Pack2Bypass", 1, func(val) {
				obj["BLEED-Pack-2-Bypass-needle"].setRotation((val - 50) * D2R);
			}),
			props.UpdateManager.FromHashValue("Pack1OutTemp", 0.5, func(val) {
				obj["BLEED-Pack-1-Out-Temp"].setText(sprintf("%s", math.round(val, 5)));
				
				if (val > 90) {
					obj["BLEED-Pack-1-Out-Temp"].setColor(0.7333,0.3803,0);
				} else {
					obj["BLEED-Pack-1-Out-Temp"].setColor(0.0509,0.7529,0.2941);
				}
			}),
			props.UpdateManager.FromHashValue("Pack2OutTemp", 0.5, func(val) {
				obj["BLEED-Pack-2-Out-Temp"].setText(sprintf("%s", math.round(val, 5)));
				
				if (val > 90) {
					obj["BLEED-Pack-2-Out-Temp"].setColor(0.7333,0.3803,0);
				} else {
					obj["BLEED-Pack-2-Out-Temp"].setColor(0.0509,0.7529,0.2941);
				}
			}),
			props.UpdateManager.FromHashValue("Pack1OutletTemp", 0.5, func(val) {
				obj["BLEED-Pack-1-Comp-Out-Temp"].setText(sprintf("%s", math.round(val, 5)));
				
				if (val > 230) {
					obj["BLEED-Pack-1-Comp-Out-Temp"].setColor(0.7333,0.3803,0);
				} else {
					obj["BLEED-Pack-1-Comp-Out-Temp"].setColor(0.0509,0.7529,0.2941);
				}
			}),
			props.UpdateManager.FromHashValue("Pack2OutletTemp", 0.5, func(val) {
				obj["BLEED-Pack-2-Comp-Out-Temp"].setText(sprintf("%s", math.round(val, 5)));
				
				if (val > 230) {
					obj["BLEED-Pack-2-Comp-Out-Temp"].setColor(0.7333,0.3803,0);
				} else {
					obj["BLEED-Pack-2-Comp-Out-Temp"].setColor(0.0509,0.7529,0.2941);
				}
			}),
			props.UpdateManager.FromHashValue("Pack1FlowOutput", 0.5, func(val) {
				obj["BLEED-Pack-1-Packflow-needle"].setRotation(val * D2R);
			}),
			props.UpdateManager.FromHashValue("Pack2FlowOutput", 0.5, func(val) {
				obj["BLEED-Pack-2-Packflow-needle"].setRotation(val * D2R);
			}),
			props.UpdateManager.FromHashValue("gear1Wow", 1, func(val) {
				if (val) {
					obj["BLEED-GND"].show();
				} else {
					obj["BLEED-GND"].hide();
				}
			}),
			props.UpdateManager.FromHashValue("IceWingSw", 1, func(val) {
				if (val) {
					obj["BLEED-Anti-Ice-Left"].show();
					obj["BLEED-Anti-Ice-Right"].show();
				} else {
					obj["BLEED-Anti-Ice-Left"].hide();
					obj["BLEED-Anti-Ice-Right"].hide();
				}
			}),
			props.UpdateManager.FromHashValue("N2_actual_1", 0.5, func(val) {
				if (val >= 59) {
					obj["BLEED-ENG-1-label"].setColor(0.8078,0.8039,0.8078);
				} else {
					obj["BLEED-ENG-1-label"].setColor(0.7333,0.3803,0);
				}
			}),
			props.UpdateManager.FromHashValue("N2_actual_2", 0.5, func(val) {
				if (val >= 59) {
					obj["BLEED-ENG-2-label"].setColor(0.8078,0.8039,0.8078);
				} else {
					obj["BLEED-ENG-2-label"].setColor(0.7333,0.3803,0);
				}
			}),
			
			props.UpdateManager.FromHashValue("flowCtlValve1", 0.1, func(val) {
				if (val <= 0.1) {
					obj["BLEED-Pack-1-Packflow-needle"].setColorFill(0.7333,0.3803,0);
					obj["BLEED-Pack-1-Flow-Valve"].setRotation(90 * D2R);
					obj["BLEED-Pack-1-connection"].setColor(0.7333,0.3803,0);
					obj["BLEED-Pack-1-connection"].setColorFill(0.7333,0.3803,0);
				} else {
					obj["BLEED-Pack-1-Packflow-needle"].setColorFill(0.0509,0.7529,0.2941);
					obj["BLEED-Pack-1-Flow-Valve"].setRotation(0);
					obj["BLEED-Pack-1-connection"].setColor(0.0509,0.7529,0.2941);
					obj["BLEED-Pack-1-connection"].setColorFill(0.0509,0.7529,0.2941);
				}
			}),
			props.UpdateManager.FromHashValue("flowCtlValve2", 0.1, func(val) {
				if (val <= 0.1) {
					obj["BLEED-Pack-2-Packflow-needle"].setColorFill(0.7333,0.3803,0);
					obj["BLEED-Pack-2-Flow-Valve"].setRotation(90 * D2R);
					obj["BLEED-Pack-2-connection"].setColor(0.7333,0.3803,0);
					obj["BLEED-Pack-2-connection"].setColorFill(0.7333,0.3803,0);
				} else {
					obj["BLEED-Pack-2-Packflow-needle"].setColorFill(0.0509,0.7529,0.2941);
					obj["BLEED-Pack-2-Flow-Valve"].setRotation(0);
					obj["BLEED-Pack-2-connection"].setColor(0.0509,0.7529,0.2941);
					obj["BLEED-Pack-2-connection"].setColorFill(0.0509,0.7529,0.2941);
				}
			}),
			props.UpdateManager.FromHashValue("flowCtlValve1PositionMatch", 1, func(val) {
				if (val) {
					obj["BLEED-Pack-1-Flow-Valve"].setColor(0.0509,0.7529,0.2941);
					obj["BLEED-Pack-1-Flow-Valve-Cross"].setColorFill(0.0509,0.7529,0.2941);
				} else {
					obj["BLEED-Pack-1-Flow-Valve"].setColor(0.7333,0.3803,0);
					obj["BLEED-Pack-1-Flow-Valve-Cross"].setColorFill(0.7333,0.3803,0);
				}
			}),
			props.UpdateManager.FromHashValue("flowCtlValve2PositionMatch", 1, func(val) {
				if (val) {
					obj["BLEED-Pack-2-Flow-Valve"].setColor(0.0509,0.7529,0.2941);
					obj["BLEED-Pack-2-Flow-Valve-Cross"].setColorFill(0.0509,0.7529,0.2941);
				} else {
					obj["BLEED-Pack-2-Flow-Valve"].setColor(0.7333,0.3803,0);
					obj["BLEED-Pack-2-Flow-Valve-Cross"].setColorFill(0.7333,0.3803,0);
				}
			}),
			props.UpdateManager.FromHashValue("BleedPRVValve1", 0.1, func(val) {
				if (val <= 0.1) {
					obj["BLEED-ENG-1"].setRotation(0);
				} else {
					obj["BLEED-ENG-1"].setRotation(90 * D2R);
				}
			}),
			props.UpdateManager.FromHashValue("BleedPRVValve2", 0.1, func(val) {
				if (val <= 0.1) {
					obj["BLEED-ENG-2"].setRotation(0);
				} else {
					obj["BLEED-ENG-2"].setRotation(90 * D2R);
				}
			}),
			props.UpdateManager.FromHashValue("BleedPRVValve1PositionMatch", 1, func(val) {
				if (val) {
					obj["BLEED-ENG-1"].setColor(0.0509,0.7529,0.2941);
					obj["BLEED-ENG-1-Cross"].setColorFill(0.0509,0.7529,0.2941);
				} else {
					obj["BLEED-ENG-1"].setColor(0.7333,0.3803,0);
					obj["BLEED-ENG-1-Cross"].setColorFill(0.7333,0.3803,0);
				}
			}),
			props.UpdateManager.FromHashValue("BleedPRVValve2PositionMatch", 1, func(val) {
				if (val) {
					obj["BLEED-ENG-2"].setColor(0.0509,0.7529,0.2941);
					obj["BLEED-ENG-2-Cross"].setColorFill(0.0509,0.7529,0.2941);
				} else {
					obj["BLEED-ENG-2"].setColor(0.7333,0.3803,0);
					obj["BLEED-ENG-2-Cross"].setColorFill(0.7333,0.3803,0);
				}
			}),
		];
		
		obj.updateItemsBottom = [
			props.UpdateManager.FromHashValue("acconfigUnits", 1, func(val) {
				if (val) {
					obj["GW-weight-unit"].setText("KG");
				} else {
					obj["GW-weight-unit"].setText("LBS");
				}
			}),
			props.UpdateManager.FromHashValue("hour", 1, func(val) {
				obj["UTCh"].setText(sprintf("%02d", val));
			}),
			props.UpdateManager.FromHashValue("minute", 1, func(val) {
				obj["UTCm"].setText(sprintf("%02d", val));
			}),
			props.UpdateManager.FromHashValue("gForce", 0.05, func(val) {
				obj["GLoad"].setText("G.LOAD " ~ sprintf("%3.1f", val));
			}),
			props.UpdateManager.FromHashValue("gForceDisplay", nil, func(val) {
				if (val) {
					obj["GLoad"].show();
				} else {
					obj["GLoad"].hide();
				}
			}),
			props.UpdateManager.FromHashValue("satTemp", 0.5, func(val) {
				obj["SAT"].setText(sprintf("%+2.0f", val));
			}),
			props.UpdateManager.FromHashValue("tatTemp", 0.5, func(val) {
				obj["TAT"].setText(sprintf("%+2.0f", val));
			}),
		];
		return obj;
	},
	getKeysBottom: func() {
		return ["TAT","SAT","GW","UTCh","UTCm","GLoad","GW-weight-unit"];
	},
	getKeys: func() {
		return["TAT","SAT","GW","UTCh","UTCm","GLoad","GW-weight-unit", "BLEED-XFEED", "BLEED-Ram-Air", "BLEED-Ram-Air-Cross", "BLEED-APU-CIRCLE", "BLEED-HP-Valve-1", "BLEED-XFEED-Cross",
		"BLEED-APU-LINES","BLEED-ENG-1", "BLEED-HP-Valve-2", "BLEED-ENG-2", "BLEED-Precooler-1-Inlet-Press", "BLEED-Precooler-1-Outlet-Temp",
		"BLEED-Precooler-2-Inlet-Press", "BLEED-Precooler-2-Outlet-Temp", "BLEED-ENG-1-label", "BLEED-ENG-2-label",
		"BLEED-GND", "BLEED-Pack-1-Flow-Valve", "BLEED-Pack-2-Flow-Valve", "BLEED-Pack-1-Out-Temp","BLEED-APU-connectionTop",
		"BLEED-Pack-1-Comp-Out-Temp", "BLEED-Pack-1-Packflow-needle", "BLEED-Pack-1-Bypass-needle", "BLEED-Pack-2-Out-Temp",
		"BLEED-Pack-2-Bypass-needle", "BLEED-Pack-2-Comp-Out-Temp", "BLEED-Pack-2-Packflow-needle", "BLEED-Anti-Ice-Left",
		"BLEED-Anti-Ice-Right", "BLEED-HP-2-connection", "BLEED-HP-1-connection", "BLEED-ANTI-ICE-ARROW-LEFT", "BLEED-ANTI-ICE-ARROW-RIGHT",
		"BLEED-xbleedLeft","BLEED-xbleedCenter","BLEED-xbleedRight","BLEED-cond-1","BLEED-cond-2","BLEED-cond-3","BLEED-Ram-Air-connection","BLEED-ENG-1-Cross","BLEED-ENG-2-Cross",
		"BLEED-Pack-1-Flow-Valve-Cross","BLEED-Pack-2-Flow-Valve-Cross","BLEED-Pack-1-connection","BLEED-Pack-2-connection"];
	},
	updateBottom: func(notification) {
		if (fmgc.FMGCInternal.fuelRequest and fmgc.FMGCInternal.blockConfirmed and !fmgc.FMGCInternal.fuelCalculating and notification.FWCPhase != 1) {
			if (notification.acconfigUnits) {
				me["GW"].setText(sprintf("%s", math.round(fmgc.FMGCInternal.fuelPredGw * 1000 * LBS2KGS, 100)));
			} else {
				me["GW"].setText(sprintf("%s", math.round(fmgc.FMGCInternal.fuelPredGw * 1000, 100)));
			}
			me["GW"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["GW"].setText(sprintf("%s", " --    "));
			me["GW"].setColor(0.0901,0.6039,0.7176);
		}
		
		if (dmc.DMController.DMCs[1].outputs[4] != nil) {
			notification.satTemp = dmc.DMController.DMCs[1].outputs[4].getValue();
			me["SAT"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["SAT"].setText("XX");
			me["SAT"].setColor(0.7333,0.3803,0);
		}
		
		if (dmc.DMController.DMCs[1].outputs[5] != nil) {
			notification.tatTemp = dmc.DMController.DMCs[1].outputs[5].getValue();
			me["TAT"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["TAT"].setText("XX");
			me["TAT"].setColor(0.7333,0.3803,0);
		}
		
		foreach(var update_item_bottom; me.updateItemsBottom)
        {
            update_item_bottom.update(notification);
        }
	},
	update: func(notification) {
		me.updatePower();
		
		if (me.test.getVisible() == 1) {
			me.updateTest(notification);
		}
		
		if (me.group.getVisible() == 0) {
			return;
		}
		
		if ((notification.flowCtlValve1 >= 0.95 and notification.Pack1Switch) or (notification.flowCtlValve1 <= 0.05 and !notification.Pack1Switch)) {
			notification.flowCtlValve1PositionMatch = 1;
		} else {
			notification.flowCtlValve1PositionMatch = 0;
		}
		
		if ((notification.flowCtlValve2 >= 0.95 and notification.Pack2Switch) or (notification.flowCtlValve2 <= 0.05 and !notification.Pack2Switch)) {
			notification.flowCtlValve2PositionMatch = 1;
		} else {
			notification.flowCtlValve2PositionMatch = 0;
		}
		
		if ((notification.BleedPRVValve1 >= 0.95 and notification.BleedPRVValve1Cmd) or (notification.BleedPRVValve1 <= 0.05 and !notification.BleedPRVValve1Cmd)) {
			notification.BleedPRVValve1PositionMatch = 1;
		} else {
			notification.BleedPRVValve1PositionMatch = 0;
		}
		
		if ((notification.BleedPRVValve2 >= 0.95 and notification.BleedPRVValve2Cmd) or (notification.BleedPRVValve2 <= 0.05 and !notification.BleedPRVValve2Cmd)) {
			notification.BleedPRVValve2PositionMatch = 1;
		} else {
			notification.BleedPRVValve2PositionMatch = 0;
		}
		
		if ((notification.BleedHPValve1 >= 0.95 and notification.BleedHPValve1Cmd) or (notification.BleedHPValve1 <= 0.05 and !notification.BleedHPValve1Cmd)) {
			notification.bleedHPValve1PositionMatch = 1;
		} else {
			notification.bleedHPValve1PositionMatch = 0;
		}
		
		if ((notification.BleedHPValve2 >= 0.95 and notification.BleedHPValve2Cmd) or (notification.BleedHPValve2 <= 0.05 and !notification.BleedHPValve2Cmd)) {
			notification.bleedHPValve2PositionMatch = 1;
		} else {
			notification.bleedHPValve2PositionMatch = 0;
		}
		
		if ((notification.BleedCrossbleed >= 0.95 and notification.BleedCrossbleedCmd) or (notification.BleedCrossbleed <= 0.05 and !notification.BleedCrossbleedCmd)) {
			notification.BleedCrossbleedPositionMatch = 1;
		} else {
			notification.BleedCrossbleedPositionMatch = 0;
		}
		
		if (notification.BleedPreCoolerTemp1 < 150) {
			notification.bleedPrecoolerTemp1Lo = 1;
		} else {
			notification.bleedPrecoolerTemp1Lo = 0;
		}
		
		if (notification.BleedPreCoolerTemp2 < 150) {
			notification.bleedPrecoolerTemp2Lo = 1;
		} else {
			notification.bleedPrecoolerTemp2Lo = 0;
		}
		
		foreach(var update_item; me.update_items)
        {
            update_item.update(notification);
        }
		
		if (notification.BleedBMC1Working) {
			me["BLEED-Precooler-1-Outlet-Temp"].setText(me.bleedPrecoolerTemp1);
			me["BLEED-Precooler-1-Inlet-Press"].setText(me.bleedPrecoolerInlet1Pressure);
			
			if (me.bleedPrecoolerInlet1PressureOut) {
				me["BLEED-Precooler-1-Inlet-Press"].setColor(0.7333,0.3803,0);
			} else {
				me["BLEED-Precooler-1-Inlet-Press"].setColor(0.0509,0.7529,0.2941);
			}
		} else {
			me["BLEED-Precooler-1-Outlet-Temp"].setText("XX");
			me["BLEED-Precooler-1-Inlet-Press"].setText("XX");
			me["BLEED-Precooler-1-Inlet-Press"].setColor(0.7333,0.3803,0);
		}
		
		if (notification.BleedBMC2Working) {
			me["BLEED-Precooler-2-Outlet-Temp"].setText(me.bleedPrecoolerTemp2);
			me["BLEED-Precooler-2-Inlet-Press"].setText(me.bleedPrecoolerInlet2Pressure);
			
			if (me.bleedPrecoolerInlet2PressureOut) {
				me["BLEED-Precooler-2-Inlet-Press"].setColor(0.7333,0.3803,0);
			} else {
				me["BLEED-Precooler-2-Inlet-Press"].setColor(0.0509,0.7529,0.2941);
			}
		} else {
			me["BLEED-Precooler-2-Outlet-Temp"].setText("XX");
			me["BLEED-Precooler-2-Inlet-Press"].setText("XX");
			me["BLEED-Precooler-2-Inlet-Press"].setColor(0.7333,0.3803,0);
		}
		
		me.updateBottom(notification);
	},
	updatePower: func() {
		if (me.name == ecam.SystemDisplayController.displayedPage.name) {
			if (du4_lgt.getValue() > 0.01 and systems.ELEC.Bus.ac2.getValue() >= 110) {
				if (du4_test_time.getValue() + du4_test_amount.getValue() >= pts.Sim.Time.elapsedSec.getValue()) {
					me.group.setVisible(0);
					me.test.setVisible(1);
				} else {
					me.group.setVisible(1);
					me.test.setVisible(0);
				}
			} else {
				if (pts.Modes.EcamDuXfr.getBoolValue()) {
					if (du3_lgt.getValue() > 0.01 and systems.ELEC.Bus.acEss.getValue() >= 110) {
						if (du3_test_time.getValue() + du3_test_amount.getValue() >= pts.Sim.Time.elapsedSec.getValue()) {
							me.group.setVisible(0);
							me.test.setVisible(1);
						} else {
							me.group.setVisible(1);
							me.test.setVisible(0);
						}
					} else {
						me.group.setVisible(0);
						me.test.setVisible(0);
					}
				} else {
					me.group.setVisible(0);
					me.test.setVisible(0);
				}
			}
		} else {
			me.group.setVisible(0);
			# don't hide the test group; just let whichever page is active control it
		}
	},
};

var input = {
	ApuBleedNotOn: "/systems/pneumatics/warnings/apu-bleed-not-on",
	BleedBMC1Working: "/systems/pneumatics/indicating/bmc1-working",
	BleedBMC2Working: "/systems/pneumatics/indicating/bmc2-working",
	BleedCrossbleedCmd: "/systems/pneumatics/valves/crossbleed-valve-cmd",
	BleedCrossbleed: "/systems/pneumatics/valves/crossbleed-valve",
	BleedHPValve1: "/systems/pneumatics/valves/engine-1-hp-valve",
	BleedHPValve2: "/systems/pneumatics/valves/engine-2-hp-valve",
	BleedHPValve1Cmd: "/systems/pneumatics/valves/engine-1-hp-valve-cmd",
	BleedHPValve2Cmd: "/systems/pneumatics/valves/engine-2-hp-valve-cmd",
	BleedPRVValve1Cmd: "/controls/pneumatics/switches/bleed-1",
	BleedPRVValve2Cmd: "/controls/pneumatics/switches/bleed-2",
	BleedPRVValve1: "/systems/pneumatics/valves/engine-1-prv-valve",
	BleedPRVValve2: "/systems/pneumatics/valves/engine-2-prv-valve",
	BleedPreCoolerPSI1: "/systems/pneumatics/psi/engine-1-psi",
	BleedPreCoolerPSI2: "/systems/pneumatics/psi/engine-2-psi",
	BleedPreCoolerTemp1: "/systems/pneumatics/precooler/temp-1",
	BleedPreCoolerTemp2: "/systems/pneumatics/precooler/temp-2",
	BleedPreCoolerOvht1: "/systems/pneumatics/precooler/ovht-1",
	BleedPreCoolerOvht2: "/systems/pneumatics/precooler/ovht-2",
	Pack1Bypass: "/systems/pneumatics/pack-1-bypass",
	Pack2Bypass: "/systems/pneumatics/pack-2-bypass",
	Pack1FlowOutput: "/ECAM/Lower/pack-1-flow-output",
	Pack2FlowOutput: "/ECAM/Lower/pack-2-flow-output",
	Pack1OutTemp: "/systems/air-conditioning/packs/pack-1-output-temp",
	Pack2OutTemp: "/systems/air-conditioning/packs/pack-2-output-temp",
	Pack1OutletTemp: "/systems/air-conditioning/packs/pack-1-outlet-temp",
	Pack2OutletTemp: "/systems/air-conditioning/packs/pack-2-outlet-temp",
	Pack1Switch: "/controls/pneumatics/switches/pack-1",
	Pack2Switch: "/controls/pneumatics/switches/pack-2",
	RamAirValve: "/systems/air-conditioning/valves/ram-air",
	IceWingSw: "/controls/ice-protection/wing",
};

foreach (var name; keys(input)) {
	emesary.GlobalTransmitter.NotifyAll(notifications.FrameNotificationAddProperty.new("A320 System Display", name, input[name]));
}