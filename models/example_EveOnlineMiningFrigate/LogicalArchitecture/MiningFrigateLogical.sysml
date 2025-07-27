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

        part Hulllogical : LogicalMiningFrigateHull :> miningFrigate.coreSystem ;

        //The parts of the LogicalMiningFrigate are a subset of the parts of the MiningFrigate 
        // COTS Modules (Ref Parts - Exchangeable)
        //the mining laser is available in three variants
        variation ref part miningLaserlogical : MinerModule[2] :> miningFrigate.miningLaser {
            variant 'Mining Laser EP-S Gaussian Scoped';
            variant 'Mining Laser Particle Bore Compact';
            variant minerI : MinerI;
        }             
        ref part propulsionModulelogical : Afterburner[0..1] :> miningFrigate.propulsionModule; 
        ref part shieldModulelogical : SmallShieldExtenderI[0..1] :> miningFrigate.shieldModule; 
        ref part capacitorModulelogical : SmallCapBatteryI[0..1] :> miningFrigate.capacitorBooster;  
        ref part sensorModulelogical : SurveyScannerI[0..1] :> miningFrigate.sensorModule;  
        ref part warpCoreStabilizerlogical : WarpCoreStabilizerI[0..2] :> miningFrigate.warpCoreStabilizer; 
        
        //internal conexions between parts of the LogicalMiningFrigateConfiguration
        interface highSlotInterface1 : HighSlotInterface connect
        	hullPort ::> Hulllogical.highSlot1 to
        	modulePort ::> miningLaserlogical.highSlot;

	    interface highSlotInterface2 : HighSlotInterface connect
	        hullPort ::> Hulllogical.highSlot2 to
	        modulePort ::> miningLaserlogical.highSlot;
	
	    interface mediumSlotInterface1 : MediumSlotInterface connect
	        hullPort ::> Hulllogical.mediumSlot1 to
	        modulePort ::> propulsionModulelogical.mediumSlot;
	
	    interface mediumSlotInterface2 : MediumSlotInterface connect
	        hullPort ::> Hulllogical.mediumSlot2 to
	        modulePort ::> shieldModulelogical.mediumSlot;
	
	    interface lowSlotInterface1 : LowSlotInterface connect
	        hullPort ::> Hulllogical.lowSlot1 to
	        modulePort ::> warpCoreStabilizerlogical.lowSlot; 
        
        //the ports of the LogicalMiningFrigateConfiguration are bound to the ports of the LogicalMiningFriagteHull
        //the external ports of LogicalMiningFrigateConfiguration are not redefined because they must be same as the ones at the problem space.
        bind controlPort = Hulllogical.hullControlPort;
        bind dockingPort = Hulllogical.hullDockingPort;
        bind defensePort = Hulllogical.hullDefensePort;
        bind droneControlPort = Hulllogical.hullDroneControlPort;
  
    }

    //An abstract frigate is defined here, that will be used as a basis to define possible frigate configurations.
    abstract part logicalMiningFrigateConfiguration : LogicalMiningFrigateConfiguration {

        //the state of the LogicalMiningFrigateConfiguration is redefined from the problem space
        state logicalMiningFrigateStates :>> miningFrigate.miningFrigatesStates {
            
            entry;
            then Dockedlogical; //boarding a ship is not modeled.

            state Packagedlogical {
                doc /* The mining frigate is packaged inside a station and can be cargoed. */
            }	 	
            state Parkedlogical {
                doc /* The mining frigate is parked inside a station, but not boarded by a pod. */
            }	 	
            state Dockedlogical {
                doc /* The mining frigate is inside a station, available for refitting, resupply, or cargo transfer. */
            }
            state InGridlogical {
                doc /* The mining frigate is in open space, near asteroids, stations, or other celestial objects. */
            }
            state OnWarplogical {
                doc /* The mining frigate is in warp, traveling between locations. */
            }
            
            transition docked_to_inGridlogical 
                first Dockedlogical
                accept pilotPodUndockCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action undockFromStation_logical : UndockFromStation_logical {in undockCommand = pilotPodUndockCommandSig;}
                then InGridlogical;  		
                
            transition inGrid_to_dockedlogical
                first InGridlogical
                accept pilotPodDockCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action dockToStation_logical : DockToStation_logical {in dockCommand = pilotPodDockCommandSig;}
                then Dockedlogical;
                
            transition inGrid_to_onWarplogical
                first InGridlogical
                accept warpCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action executeWarpDrive_logical : ExecuteWarpDrive_logical {in warpCommand = warpCommandSig;}
                then OnWarplogical;
        
            transition onWarp_to_inGridlogical
                first OnWarplogical
                accept when logicalMiningFrigateConfiguration.warpBubbleEnd
                then InGridlogical;     	
            
            //Internal transitions
            transition unloadCargological 
                first Dockedlogical
                accept unloadCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action transferOre_logical : TransferOre_logical {in unloadCommand = unloadCommandSig;}
                then Dockedlogical;
            
            transition cycleMininglogical 
                first InGridlogical
                accept miningCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action activateMiningLaser_logical : ActivateMiningLaser_logical
                then InGridlogical;
                
            transition scanThreatslogical
                first InGridlogical
                accept scanCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action scanForThreats_logical : ScanForThreats_logical {in scanCommand = scanCommandSig;}
                then InGridlogical;

            transition prioritizeThreatlogical
                first InGridlogical
                accept threatSignatureSig : ScanSignature via logicalMiningFrigateConfiguration.controlPort
                do action prioritizeThreats_logical : PrioritizeThreats_logical {in detectedThreats = threatSignatureSig;}
                then InGridlogical;

            transition deployDroneslogical
                first InGridlogical
                accept droneCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action selectDronesForDeployment_logical : SelectDronesForDeployment_logical {in droneCommand = droneCommandSig;}
                then InGridlogical;

            transition navigationlogical
                first InGridlogical
                accept destinationCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action acceptDestination_logical : AcceptDestination_logical {in destinationCommand = destinationCommandSig;}
                then InGridlogical;

            transition coursePlotlogical
                first InGridlogical
                accept courseCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action plotOptimalCourse_logical : PlotOptimalCourse_logical
                then InGridlogical;

            transition engagingPropulsionlogical
                first InGridlogical
                accept propulsionCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action engagePropulsion_logical : EngagePropulsion_logical { in engagePropulsion = propulsionCommandSig;}
                then InGridlogical;

            transition adjustingCourselogical
                first InGridlogical
                accept courseCorrectionSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action monitorAndAdjustCourse_logical : MonitorAndAdjustCourse_logical
                then InGridlogical;

            transition cargoVerificationlogical
                first Dockedlogical
                accept warehouseStatusCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action verifyCargoTransfer_logical : VerifyResupply_logical {in warehouseStatusCommand = warehouseStatusCommandSig;}
                then Dockedlogical;

            transition detectingThreatlogical
                first InGridlogical
                accept threatScanCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action detectThreat_logical : DetectThreat_logical {in scanCommand = threatScanCommandSig;}
                then InGridlogical;

            transition engagingDefenseslogical
                first InGridlogical
                accept defenseCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action engageDefenses_logical : EngageDefenses_logical {in engageCommand = defenseCommandSig;}
                then InGridlogical;

            transition resupplyinglogical
                first Dockedlogical
                accept shipStatusCommandSig : ShipCommand via logicalMiningFrigateConfiguration.controlPort
                do action verifyResupply_logical : VerifyCargoTransfer_logical
                then Dockedlogical;
        }       
        
    }
    
    //Three different configurations of mining frigatte are defined here that base on an abstract frigate
    part logicalNoviceMiningFrigatte :> logicalMiningFrigateConfiguration{
        part redefines miningLaserlogical = miningLaserlogical::minerI;
    }

    part logicalTrainerMiningFrigate :> logicalMiningFrigateConfiguration{
        part redefines miningLaserlogical = miningLaserlogical::'Mining Laser Particle Bore Compact';
    } 

    part logicalFieldMiningFrigate :> logicalMiningFrigateConfiguration{
        part redefines miningLaserlogical = miningLaserlogical::'Mining Laser EP-S Gaussian Scoped';
    } 

}
