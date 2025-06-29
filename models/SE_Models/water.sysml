package water {
	private import ScalarValues::*;
	private import ISQ::*;
	private import SI::*;

    item def H2O {
        attribute def temperature :> TemperatureValue;
        attribute def mass :> MassValue;
        attribute def pressure :> PressureValue;
        attribute def specific_heat_capacity :> SpecificHeatCapacityAtConstantPressureUnit;

        item ice : H2O;
        item water : H2O;
        item steam : H2O;

        port heat_exchange : Heat_exchange {
            in energy : heat;
        }

        //water warms up or cools down
        action def transfer_heat {
            in warming_heat : heat = heat_exchange.energy;
            assign temperature = temperature + heat * specific_heat_capacity;
        }

        perform transfer_heat {
            in 
        }

        state def H2O_states {
            entry ; then water_state;

            state water_state; 

            transition water_to_ice
                first water_state
                accept latent_heat_of_fusion : heat
                then ice_state;
            
            state ice_state;    
        }

    port def Heat_exchange {inout exchanged_heat : heat; }
    }
}