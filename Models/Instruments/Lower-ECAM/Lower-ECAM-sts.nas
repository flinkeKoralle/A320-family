# A3XX Lower ECAM Canvas
# Copyright (c) 2024 Josh Davidson (Octal450) and Jonathan Redpath

var canvas_lowerECAMPageSts =
{
	new: func(svg,name) {
		var obj = {parents: [canvas_lowerECAMPageSts,canvas_lowerECAM_base] };
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
		return["Bulk","BulkLine","BulkLbl","Exit1L","Exit1R","Cabin1Left","Cabin1LeftLbl","Cabin1LeftLine","Cabin1LeftSlide","Cabin1Right","Cabin1RightLbl","Cabin1RightLine","Cabin1RightSlide","Cabin2Left","Cabin2LeftLbl",
		"Cabin2LeftLine","Cabin2LeftSlide","Cabin2Right","Cabin2RightLbl","Cabin2RightLine","Cabin2RightSlide","Cabin3Left","Cabin3LeftLbl","Cabin3LeftLine","Cabin3LeftSlide","Cabin3Right","Cabin3RightLbl","Cabin3RightLine","Cabin3RightSlide","AvionicsLine1",
		"AvionicsLbl1","AvionicsLine2","AvionicsLbl2","Cargo1Line","Cargo1Lbl","Cargo1Door","Cargo2Line","Cargo2Lbl","Cargo2Door","ExitLSlide","ExitLLine","ExitLLbl","ExitRSlide","ExitRLine","ExitRLbl","Cabin4Left","Cabin4LeftLbl","Cabin4LeftLine",
		"Cabin4LeftSlide","Cabin4Right","Cabin4RightLbl","Cabin4RightLine","Cabin4RightSlide","DOOROXY-REGUL-LO-PR"];
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
		
		foreach(var update_item; me.update_items)
        {
            update_item.update(notification);
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
};

foreach (var name; keys(input)) {
	emesary.GlobalTransmitter.NotifyAll(notifications.FrameNotificationAddProperty.new("A320 System Display", name, input[name]));
}