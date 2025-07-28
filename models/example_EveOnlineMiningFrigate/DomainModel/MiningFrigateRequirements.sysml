package MiningFrigateRequirements {

    private import DomainPackage::*;
    private import ScalarValues::*;
    private import MiningFrigateRequirementsDef::*;
    private import MiningFrigatePackage::*;

    //Mining Frigate Requirement assertions for the Mining Frigates
    requirement <MFRQF01_1> oreExtractionEfficiencyRequirementLowSec : OreExtractionEfficiencyRequirement {
    	subject myMiningFrigate : MiningFrigate;
    }
    
    requirement <MFRQF02_1> cargoCapacityRequirementLowSec : CargoCapacityRequirement {
    	subject myMiningFrigate : MiningFrigate;
    }

    requirement <MFRQF03_1> survivabilityRequirementLowSec : SurvivabilityRequirement {
    	subject myMiningFrigate : MiningFrigate;
    }

    requirement <MFRQF04_1> droneOperationsRequirementLowSec : DroneOperationsRequirement {
        subject myMiningFrigate : MiningFrigate;
    }

    requirement <MFRQF05_1> threatDetectionRequirementLowSec : ThreatDetectionRequirement {
        subject myMiningFrigate : MiningFrigate;
    }

    requirement <MFRQF06_1> travelEfficiencyRequirementLowSec : TravelEfficiencyRequirement {
        subject myMiningFrigate : MiningFrigate;
    }

    requirement <MFRQF07_1> miningTargetRequirementLowSec : MiningTargetRequirement {
        subject myMiningFrigate : MiningFrigate;
    }

    requirement <MFRQF08_1> dockingRequirementLowSec : DockingRequirement {
        subject myMiningFrigate : MiningFrigate;
    }
    
   	//Stakeholder Requirement assertions for the Mining Corporation
   	requirement <MFRQC01_1> fleetCoordinationRequirementLowSec : FleetCoordinationRequirement {
   		subject myFleetCommander : PilotPod;
   	}   
	
	requirement <MFRQC02_1> oreCompressionRequirement : OreCompressionRequirement {
   		subject myRorqual : Rorqual;
   	}   
}