package Water {
	private import ScalarValues::*;
	private import ISQ::*;
	private import SI::*;

    item def Water {
        attribute def temperature :> TemperatureValue;
        attribute def mass :> MassValue;
        attribute def pressure :> PressureValue;
        attribute def specific_heat_capacity :> SpecificHeatCapacityAtConstantPressureUnit;

        item solid_water : Water;
        item liquid_water : Water
        item gas_water : Water;

        port heat_exchange : Heat_exchange {
            in energy : heat;
        }

        //water warms up or cools down
        action def Transfer_heat {
            in warming_heat : heat = heat_exchange.energy;
            assign temperature = temperature + heat * specific_heat_capacity;
        }

        state def Water_states {
            entry ; then water_state;

            state water_state; 

            transition water_to_ice
                first water_state
                accept absorved_heat : heat via heat_exchange
                then do transfer_heat : transfer_heat { in exchanged_heat; }
                then water_state;

            transition water_to_ice
                first water_state
                accept latent_heat_of_fusion : heat
                then ice_state;
            
            state ice_state;    
        }

    port def Heat_exchange {inout exchanged_heat : heat; }
    }
}