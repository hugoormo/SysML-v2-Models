package OPSCON {

    private import DocumentStructureMetadata::*;

    // The OPSCON document instance
    #document OPSCON {
        titleOpsCon ::> title = "OPSCON for Mining Frigate-Based Resource Extraction";
        statusOpsCon ::> status = "Draft";

        // Chapter 1 – Mission Overview
        #chapter missionOverview {
            titleChapter1 ::> title = "1. Mission Overview";
            #section overviewSection {
                headingChapter1 ::> heading = "Overview";
                contentChapter1 ::> content = "The Mining Corporation operates fleets of mining frigates in 
                asteroid belts and wormholes. The goals are maximizing profitability, 
                ensuring operational safety, and sustaining long-term operations. The 
                central command coordinates deployments using PilotPods with tactical 
                oversight from Fleet Commanders.";
            }
        }

        // Chapter 2 – Operational Context
        #chapter context {
            titleChapter2 ::> title = "2. Operational Context";
            #section environment {
                headingChapter2 ::> heading = "Operational Environment";
                contentChapter2 ::> content = "Operations take place in High Sec, Low Sec, Null Sec, and 
                Wormhole space, involving hostile encounters, asteroid depletion, and 
                resupply via stations or POS. System elements and context are defined 
                in Domain and ConceptOfOperations packages.";
            }
        }

        // Chapter 3 – Stakeholders and Roles
        #chapter stakeholders {
            titleChapter3 ::> title = "3. Actors and Roles";
            #section actorRoles {
                headingChapter3 ::> heading = "Actor Definitions";
                contentChapter3 ::> content = "Actors include Mining CEO, Operations Manager, Fleet Commander, 
                Ship Engineer, and Market Analyst. Responsibilities span strategy, cost 
                control, fleet survivability, system design, and market alignment.";
            }
        }

        // Chapter 4 – System Elements
        #chapter systemElements {
            titleChapter4 ::> title = "4. System Elements";
            #section elementsOverview {
                headingChapter4 ::> heading = "System Components";
                contentChapter4 ::> content = "Primary elements include MiningFrigate, PilotPod, Rorqual, 
                Drone, and Station. These components are defined in the Domain and MiningFrigate 
                packages.";
            }
        }

        // Chapter 5 – Use Cases
        #chapter useCases {
            titleChapter5 ::> title = "5. Use Case Overview";
            #section useCasesSummary {
                headingChapter5 ::> heading = "Operational Use Cases";
                contentChapter5 ::> content = "Main use cases include Mine Asteroids, Plot Course and Navigate, 
                Detect Threats and Engage Defenses, Offload Ore and Resupply, and Deploy Drones. 
                Each is modeled in the MiningFrigateUseCases package and leverages reusable 
                included use cases.";
            }
        }

        // Chapter 6 – Operational Requirements
        #chapter requirements {
            titleChapter6 ::> title = "6. Operational Requirements";
            #section requirementSummary {
                headingChapter6 ::> heading = "Performance and Capability Requirements";
                contentChapter6 ::> content = "MiningFrigates are required to extract ≥ 50 m³/min, have ≥ 5000 m³ 
                cargo capacity, survive 400 DPS, detect threats within 20 AU, warp at ≥ 5 AU/s, 
                align in ≤ 3 sec, and dock/unload in ≤ 60 sec. These are defined and bound 
                in MiningFrigateRequirements and MiningFrigateRequirementsDef.";
            }
        }

        // Chapter 7 – Verification Strategy
        #chapter systemVerification {
            titleChapter7 ::> title = "7. Verification Strategy";
            #section strategy {
                headingChapter7 ::> heading = "Verification through Simulation and Testing";
                contentChapter7 ::> content = "Requirements are verified using formal verification definitions 
                (e.g., OreExtractionEfficiencyTest) implemented in MiningFrigateRequirementsVerification. 
                The MiningFrigateTestRig simulates conditions, logs data, and compares outcomes 
                against defined constraints.";
            }
        }

        // Chapter 8 – Measures of Effectiveness
        #chapter moes {
            titleChapter8 ::> title = "8. Measures of Effectiveness";
            #section moesSummary {
                headingChapter8 ::> heading = "MoEs and Decision Criteria";
                contentChapter8 ::> content = "MoEs include profitability (ISK/hour), ore throughput, survivability, 
                threat response time, storage utilization, fleet deployment efficiency, and 
                adaptability. These are modeled in the Domain and BusinessRequirements packages 
                and trace to StakeholderConcerns.";
            }
        }

        // Chapter 9 – Risk Considerations
        #chapter risk {
            titleChapter9 ::> title = "9. Risk Considerations";
            #section riskAnalysis {
                headingChapter9 ::> heading = "Risk-Adjusted Decision Making";
                contentChapter9 ::> content = "The analysisProblemSpace package provides a model-based method for 
                calculating profitability adjusted by risk factors like survival probability, 
                operational cost, and market ore prices across different zones.";
            }
        }

        // Chapter 10 – Lifecycle Considerations
        #chapter lifecycle {
            titleChapter10 ::> title = "10. Lifecycle Considerations";
            #section traceability {
                headingChapter10 ::> heading = "Model Traceability and Lifecycle Use";
                contentChapter10 ::> content = "The full model supports requirement declaration, use case-driven 
                behavior, formal verification, and traceability across viewpoints. All aspects 
                are integrated through packages including MiningFrigateRequirementsDecl, 
                MiningFrigateRequirementsVerification, and StakeholderConcerns.";
            }
        }

    }
}
