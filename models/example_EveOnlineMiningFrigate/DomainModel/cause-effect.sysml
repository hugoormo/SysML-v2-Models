package causeEffect {
	
	private import DomainPackage::domain;
	private import CauseAndEffect::*;

	//The cause-effect relationships
	//This section is not correctly parsed and needs further corrections
	#causation connect domain.miningCorporation.miningFrigate.miningRateIncreases to domain.asteroid.oreYieldIncreases;
	#causation connect domain.miningCorporation.miningFrigate.cargoCapacityIncreases to domain.miningCorporation.fleet.downtimeReduces;
	#causation connect domain.miningCorporation.miningFrigate.shieldStrengthIncreases to domain.miningCorporation.fleet.survivabilityEnhances;
	#causation connect domain.miningCorporation.miningFrigate.threatDetectionImproves to domain.miningCorporation.fleet.threatResponseImproves;
	#causation connect domain.miningCorporation.miningFrigate.droneOperationsImprove to domain.miningCorporation.fleet.operationalEfficiencyIncreases;
	#causation connect domain.miningCorporation.miningFrigate.warpSpeedIncreases to domain.miningCorporation.fleet.downtimeReduces;
	#causation connect domain.miningCorporation.fleet.fleetCoordinationImproves to domain.miningCorporation.fleet.operationalEfficiencyIncreases;
	
	#multicausation connection {
	    end #cause ::> domain.asteroid.oreYieldIncreases;
	    end #cause ::> domain.miningCorporation.fleet.downtimeReduces;
	    end #effect ::> domain.miningCorporation.fleet.oreExtractionEfficiencyIncreases;
	}
	
	#multicausation connection {
	    end #cause ::> domain.miningCorporation.fleet.survivabilityEnhances;
	    end #cause ::> domain.miningCorporation.fleet.threatResponseImproves;
	    end #effect ::> domain.miningCorporation.fleet.operationalEfficiencyIncreases;
	}
	
	#multicausation connection {
	    end #cause ::> domain.miningCorporation.fleet.operationalEfficiencyIncreases;
	    end #cause ::> domain.miningCorporation.fleet.oreExtractionEfficiencyIncreases;
	    end #effect ::> domain.miningCorporation.fleet.profitabilityMaximizes;
	}	
}