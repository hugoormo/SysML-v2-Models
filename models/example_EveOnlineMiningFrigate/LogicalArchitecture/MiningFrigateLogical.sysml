package MiningFrigateSolutionSpace {

    private import DomainPackage::*;
    private import MiningFrigatePackage::*;
    private import ScalarValues::*;
    private import COTS::*;
    private import StdPortsAndInterfaces::*;
    private import ParametersOfInterestMetadata::*;
    private import FrigateRollupAnalysis::*;
    private import MiningFrigateHullActions::*;
    private import MiningFrigateActions_logical::*;
    private import MiningFrigateHull::*;
    
    //The LogicalMiningFrigate is a spezialisation of the MiningFrigate and inherits all its features
    abstract part def LogicalMiningFrigateConfiguration :> CompositeFrigateComponent, MiningFrigate {
        doc /* The Mining Frigate consists of a fixed hull structure with modular (COTS) components 
         * that can be replaced or upgraded depending on operational needs. */

        part logicalHull : LogicalMiningFrigateHull :> miningFrigate.coreSystem ;

        //The parts of the LogicalMiningFrigate are a subset of the parts of the MiningFrigate 
        // COTS Modules (Ref Parts - Exchangeable)
        //the mining laser is available in three variants
        variation ref part miningLaser : MinerModule[2] :> miningFrigate.miningLaser {
            variant 'Mining Laser EP-S Gaussian Scoped';
            variant 'Mining Laser Particle Bore Compact';
            variant minerI : MinerI;
        }             
        ref part propulsionModule : Afterburner[0..1] :> miningFrigate.propulsionModule; 
        ref part shieldModule : SmallShieldExtenderI[0..1] :> miningFrigate.shieldModule; 
        ref part capacitorModule : SmallCapBatteryI[0..1] :> miningFrigate.capacitorBooster;  
        ref part sensorModule : SurveyScannerI[0..1] :> miningFrigate.sensorModule;  
        ref part warpCoreStabilizer : WarpCoreStabilizerI[0..2] :> miningFrigate.warpCoreStabilizer; 
        
        //internal conexions between parts of the LogicalMiningFrigateConfiguration
        interface highSlotInterface1 : HighSlotInterface connect
        	hullPort ::> logicalHull.highSlot1 to
        	modulePort ::> miningLaser.highSlot;

	    interface highSlotInterface2 : HighSlotInterface connect
	        hullPort ::> logicalHull.highSlot2 to
	        modulePort ::> miningLaser.highSlot;
	
	    interface mediumSlotInterface1 : MediumSlotInterface connect
	        hullPort ::> logicalHull.mediumSlot1 to
	        modulePort ::> propulsionModule.mediumSlot;
	
	    interface mediumSlotInterface2 : MediumSlotInterface connect
	        hullPort ::> logicalHull.mediumSlot2 to
	        modulePort ::> shieldModule.mediumSlot;
	
	    interface lowSlotInterface1 : LowSlotInterface connect
	        hullPort ::> logicalHull.lowSlot1 to
	        modulePort ::> warpCoreStabilizer.lowSlot; 
        
        //the ports of the LogicalMiningFrigateConfiguration are bound to the ports of the LogicalMiningFriagteHull
        //the external ports of LogicalMiningFrigateConfiguration are not redefined because they must be same as the ones at the problem space.
        bind controlPort = logicalHull.hullControlPort;
        bind dockingPort = logicalHull.hullDockingPort;
        bind defensePort = logicalHull.hullDefensePort;
        bind droneControlPort = logicalHull.hullDroneControlPort;
  
    }

    //An abstract frigate is defined here, that will be used as a basis to define possible frigate configurations.
    abstract part logicalMiningFrigateConfiguration : LogicalMiningFrigateConfiguration {

        //the state of the LogicalMiningFrigateConfiguration is redefined from the problem space
        state logicalMiningFrigateStates :>> miningFrigate.miningFrigatesStates {
            
            entry;
            then Docked; //boarding a ship is not modeled.

            state Packaged {
                doc /* The mining frigate is packaged inside a station and can be cargoed. */
            }	 	
            state Parked {
                doc /* The mining frigate is parked inside a station, but not boarded by a pod. */
            }	 	
            state Docked {
                doc /* The mining frigate is inside a station, available for refitting, resupply, or cargo transfer. */
            }
            state InGrid {
                doc /* The mining frigate is in open space, near asteroids, stations, or other celestial objects. */
            }
            state OnWarp {
                doc /* The mining frigate is in warp, traveling between locations. */
            }
            
            transition docked_to_inGrid 
                first Docked
                accept pilotPodUndockCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action undockFromStation_logical : UndockFromStation_logical {in undockCommand = pilotPodUndockCommandSig;}
                then InGrid;  		
                
            transition inGrid_to_docked
                first InGrid
                accept pilotPodDockCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action dockToStation_logical : DockToStation_logical {in dockCommand = pilotPodDockCommandSig;}
                then Docked;
                
            transition inGrid_to_onWarp
                first InGrid
                accept warpCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action executeWarpDrive_logical : ExecuteWarpDrive_logical {in warpCommand = warpCommandSig;}
                then OnWarp;
        
            transition onWarp_to_inGrid
                first OnWarp
                accept when logicalMiningFrigateConfiguration.warpBubbleEnd
                then InGrid;     	
            
            //Internal transitions
            transition unloadCargo 
                first Docked
                accept unloadCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action transferOre_logical : TransferOre_logical {in unloadCommand = unloadCommandSig;}
                then Docked;
            
            transition cycleMining 
                first InGrid
                accept miningCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action activateMiningLaser_logical : ActivateMiningLaser_logical
                then InGrid;
                
            transition scanThreats
                first InGrid
                accept scanCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action scanForThreats_logical : ScanForThreats_logical {in scanCommand = scanCommandSig;}
                then InGrid;

            transition prioritizeThreat
                first InGrid
                accept threatSignatureSig : ScanSignature via logicalMiningFrigateConfiguration.controlPort
                do action prioritizeThreats_logical : PrioritizeThreats_logical {in detectedThreats = threatSignatureSig;}
                then InGrid;

            transition deployDrones
                first InGrid
                accept droneCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action selectDronesForDeployment_logical : SelectDronesForDeployment_logical {in droneCommand = droneCommandSig;}
                then InGrid;

            transition navigation
                first InGrid
                accept destinationCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action acceptDestination_logical : AcceptDestination_logical {in destinationCommand = destinationCommandSig;}
                then InGrid;

            transition coursePlot
                first InGrid
                accept courseCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action plotOptimalCourse_logical : PlotOptimalCourse_logical
                then InGrid;

            transition engagingPropulsion
                first InGrid
                accept propulsionCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action engagePropulsion_logical : EngagePropulsion_logical { in engagePropulsion = propulsionCommandSig;}
                then InGrid;

            transition adjustingCourse
                first InGrid
                accept courseCorrectionSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action monitorAndAdjustCourse_logical : MonitorAndAdjustCourse_logical
                then InGrid;

            transition cargoVerification
                first Docked
                accept warehouseStatusCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action verifyCargoTransfer_logical : VerifyResupply_logical {in warehouseStatusCommand = warehouseStatusCommandSig;}
                then Docked;

            transition detectingThreat
                first InGrid
                accept threatScanCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action detectThreat_logical : DetectThreat_logical {in scanCommand = threatScanCommandSig;}
                then InGrid;

            transition engagingDefenses
                first InGrid
                accept defenseCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action engageDefenses_logical : EngageDefenses_logical {in engageCommand = defenseCommandSig;}
                then InGrid;

            transition resupplying
                first Docked
                accept shipStatusCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action verifyResupply_logical : VerifyCargoTransfer_logical
                then Docked;
        }       
        
    }
    
    //Three different configurations of mining frigatte are defined here that base on an abstract frigate
    part logicalNoviceMiningFrigatte :> logicalMiningFrigateConfiguration{
        part redefines miningLaser = miningLaser::minerI;
    }

    part logicalTrainerMiningFrigate :> logicalMiningFrigateConfiguration{
        part redefines miningLaser = miningLaser::'Mining Laser Particle Bore Compact';
    } 

    part logicalFieldMiningFrigate :> logicalMiningFrigateConfiguration{
        part redefines miningLaser = miningLaser::'Mining Laser EP-S Gaussian Scoped';
    } 

}
