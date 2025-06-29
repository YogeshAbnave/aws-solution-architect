# YARN Architecture - Comprehensive Guide

## Overview
YARN (Yet Another Resource Negotiator) is the cluster management technology in Hadoop 2.0 that manages resources and schedules applications across the Hadoop cluster. It separates resource management from job scheduling and monitoring, providing a more scalable and efficient architecture.

## YARN Architecture Components

### 1. Resource Manager (RM)
The Resource Manager is the master daemon that manages the allocation of resources across the cluster.

**Key Responsibilities:**
- Global resource allocation and scheduling
- Manages cluster resources (CPU, memory, disk, network)
- Arbitrates resources among competing applications
- Maintains cluster-wide view of resources

**Sub-components:**
- **Scheduler**: Allocates resources to applications based on capacity, fairness, or other policies
- **Application Manager**: Manages running applications and their lifecycle

### 2. Scheduler
The Scheduler is a pluggable component within the Resource Manager responsible for resource allocation.

**Types of Schedulers:**
- **FIFO Scheduler**: First-in-first-out scheduling
- **Capacity Scheduler**: Hierarchical queues with guaranteed capacity
- **Fair Scheduler**: Fair share allocation among applications

**Functions:**
- Allocates resources based on application requirements
- Enforces scheduling policies and queue configurations
- Does not monitor or track application status

### 3. Application Manager
The Application Manager handles application lifecycle management within the Resource Manager.

**Responsibilities:**
- Accepts job submissions from clients
- Negotiates resources for Application Master
- Manages Application Master lifecycle
- Restarts failed Application Masters
- Maintains application metadata

### 4. Node Manager (NM)
Node Manager is the per-node daemon that manages resources and containers on individual cluster nodes.

**Key Functions:**
- Reports node health and resource availability to Resource Manager
- Manages containers on the local node
- Monitors resource usage (CPU, memory, disk)
- Handles container lifecycle (start, stop, cleanup)
- Localizes application dependencies

**Communication:**
- **To Resource Manager**: Sends heartbeats with node status and resource availability
- **From Application Master**: Receives container launch requests
- **Local Monitoring**: Tracks container resource consumption

### 5. Application Master (AM)
Application Master acts as the project manager for each application, coordinating its execution across the cluster.

**Role as Project Manager:**
- Negotiates resources with Resource Manager
- Works with Node Managers for task execution and monitoring
- Manages application-specific scheduling
- Handles fault tolerance and task retries

**Key Responsibilities:**
- **Resource Negotiation**: Requests containers from Resource Manager based on application needs
- **Task Management**: Coordinates with Node Managers to execute application tasks
- **Progress Monitoring**: Tracks task progress and handles failures
- **Communication Hub**: Interfaces between application and YARN infrastructure

**Team Management Analogy:**
- **Workers**: Individual tasks/containers executing application logic
- **Coordination**: Manages team of workers across different nodes
- **Reporting**: Provides progress updates to Resource Manager

### 6. Container
Container represents the physical resources allocated for task execution.

**Resource Allocation:**
- CPU cores
- Memory (RAM)
- Disk space
- Network bandwidth

**Container Lifecycle:**
- **Allocation**: Resource Manager allocates container to Application Master
- **Launch**: Node Manager starts container with specified resources
- **Execution**: Container executes tasks assigned by Application Master
- **Monitoring**: Node Manager monitors resource usage
- **Cleanup**: Node Manager cleans up after container completion

## YARN Architecture Flow - Detailed Analysis

### Overall Architecture Diagram
```
                            YARN Cluster Architecture
    
    Client                     Resource Manager (RM)
      |                      /                    \
      |                     /                      \
      |               Scheduler              Application Manager
      |                    |                         |
      |                    |                         |
      ▼                    ▼                         ▼
   Job Submit ──────► Resource Allocation ────► AM Lifecycle Mgmt
                           |
                           |
                           ▼
                    Node Manager (NM)     Node Manager (NM)     Node Manager (NM)
                         |                      |                      |
                         |                      |                      |
                    Container Pool         Container Pool         Container Pool
                    [Container 1]          [Container 1]          [Container 1]
                    [Container 2]          [Container 2]          [Container 2]
                    [Container 3]          [Container 3]          [Container 3]
                         |                      |                      |
                         ▼                      ▼                      ▼
                   Application Master    Task Execution         Task Execution
```

### Detailed Communication Flow

#### Phase 1: Initial Setup and Registration
```
Step 1.1: Client → Resource Manager
┌─────────────┐         ┌──────────────────┐
│   Client    │ ──────► │ Resource Manager │
│ Application │   (1)   │  (Port: 8032)    │
└─────────────┘         └──────────────────┘
                                │
                                ▼
                        Application Manager
                        validates submission
```

**Detailed Flow:**
1. **Client Preparation**: Client packages application JAR, configuration files, and resource requirements
2. **Submission Protocol**: Uses YARN Client API to submit ApplicationSubmissionContext
3. **Validation Process**: Application Manager validates application type, resources, and permissions
4. **Application ID Generation**: Unique Application ID assigned (application_timestamp_counter)
5. **Queue Assignment**: Application placed in appropriate queue based on user/configuration

#### Phase 2: Application Master Bootstrapping
```
Step 2.1: Resource Manager → Node Manager Selection
┌──────────────────┐         ┌─────────────────┐
│ Resource Manager │ ──────► │ Node Manager 1   │
│   Scheduler      │   (2)   │ (Selected Node)  │
└──────────────────┘         └─────────────────┘
                                      │
                                      ▼
                              Container Allocation
                              for Application Master
```

**Detailed Process:**
1. **Node Selection Criteria**:
   - Available memory and CPU cores
   - Network locality considerations
   - Node health status
   - Load balancing across cluster

2. **Container Specification for AM**:
   ```
   Container Request for AM:
   - Memory: 1GB (configurable)
   - CPU: 1 vCore (configurable)
   - Priority: HIGH
   - Location: ANY (flexible)
   ```

3. **Application Master Launch Sequence**:
   ```
   Node Manager → Container Launch
   │
   ├── Download Application Resources
   ├── Set Environment Variables
   ├── Configure Security Tokens
   ├── Start Application Master JVM
   └── Monitor AM Health
   ```

#### Phase 3: Application Master Registration and Planning
```
Step 3.1: Application Master Registration
┌─────────────────┐         ┌──────────────────┐
│Application Master│ ◄────► │ Resource Manager │
│   (Port: 8041)   │   (3)  │                  │
└─────────────────┘         └──────────────────┘
```

**Registration Details:**
1. **AM Registration Information**:
   - Application Master hostname and port
   - Tracking URL for application monitoring
   - Resource capabilities and requirements

2. **Job Analysis Phase**:
   ```
   Application Master Job Planning:
   │
   ├── Analyze Input Data Size and Location
   ├── Calculate Required Containers
   ├── Determine Resource Requirements per Task
   ├── Plan Data Locality Preferences
   └── Create Resource Request List
   ```

#### Phase 4: Resource Negotiation Cycle
```
Step 4.1: Resource Request Cycle
┌─────────────────┐    Request     ┌──────────────────┐
│Application Master│ ────────────► │ Resource Manager │
└─────────────────┘               │    Scheduler     │
         ▲                        └──────────────────┘
         │            Response             │
         └─────────────────────────────────┘
```

**Detailed Negotiation Process:**

1. **Resource Request Format**:
   ```
   Resource Request:
   - Priority: 1 (highest priority)
   - Memory: 2048 MB per container
   - CPU: 2 vCores per container
   - Number of Containers: 10
   - Node Preferences: [node1, node2, node3]
   - Rack Preferences: [rack1, rack2]
   - Relaxed Locality: true
   ```

2. **Scheduler Decision Process**:
   ```
   Scheduler Evaluation:
   │
   ├── Check Queue Capacity and Limits
   ├── Evaluate Resource Availability
   ├── Apply Fair Share/Capacity Policies
   ├── Consider Data Locality Requirements
   ├── Check User/Application Limits
   └── Generate Container Allocation Response
   ```

3. **Allocation Response Structure**:
   ```
   Allocation Response:
   - Allocated Containers: [Container_1, Container_2, ...]
   - Container Details:
     ├── Container ID: container_timestamp_appid_attemptid_containerid
     ├── Node ID: node1.cluster.com:45454
     ├── Resource: <memory:2048, vCores:2>
     └── Container Token: (security token)
   ```

#### Phase 5: Container Launch and Task Execution
```
Step 5.1: Multi-Node Container Launch
                    Application Master
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
   Node Manager 1   Node Manager 2   Node Manager 3
          │                │                │
          ▼                ▼                ▼
    [Container A]    [Container B]    [Container C]
    [Container D]    [Container E]    [Container F]
```

**Container Launch Sequence:**

1. **Pre-Launch Phase**:
   ```
   Node Manager Preparation:
   │
   ├── Validate Container Token
   ├── Check Local Resource Availability
   ├── Create Container Working Directory
   ├── Download Application Dependencies
   ├── Set up Environment Variables
   └── Configure Security Context
   ```

2. **Launch Phase**:
   ```
   Container Launch Command:
   $JAVA_HOME/bin/java
   -Djava.io.tmpdir=$PWD/tmp
   -Dlog4j.configuration=container-log4j.properties
   -Dyarn.app.container.log.dir=$LOG_DIRS
   -Dyarn.app.container.log.filesize=0
   -Dhadoop.root.logger=INFO,CLA
   -Xmx1024m
   org.apache.hadoop.mapreduce.v2.app.MRAppMaster
   ```

3. **Task Execution Flow**:
   ```
   Container Task Execution:
   │
   ├── Initialize Task Runtime Environment
   ├── Load Input Data (with data locality optimization)
   ├── Execute Application Logic (Map/Reduce/Spark tasks)
   ├── Write Intermediate/Output Data
   ├── Report Progress to Application Master
   └── Clean up Local Resources
   ```

#### Phase 6: Progress Monitoring and Heartbeat Mechanism
```
Step 6.1: Multi-Level Monitoring
Container ────► Node Manager ────► Application Master ────► Resource Manager
   │                 │                      │                      │
   │                 │                      │                      │
Progress         Resource Usage        Job Progress           Cluster Status
Updates          Monitoring            Tracking               Updates
```

**Heartbeat Details:**

1. **Container → Node Manager** (Every 3 seconds):
   ```
   Container Status Report:
   - Container ID
   - Task Progress Percentage
   - Resource Usage (CPU, Memory, Disk, Network)
   - Task State (RUNNING, COMPLETED, FAILED)
   - Diagnostic Information
   ```

2. **Node Manager → Resource Manager** (Every 1 second):
   ```
   Node Heartbeat:
   - Node Health Status
   - Available Resources (Memory, CPU, Disk)
   - Running Containers List
   - Completed Containers
   - Node Manager Version and Capabilities
   ```

3. **Application Master → Resource Manager** (Every 1 second):
   ```
   AM Heartbeat:
   - Application Progress
   - Resource Requirements Update
   - Completed Containers
   - Failed Containers
   - New Resource Requests
   ```

#### Phase 7: Dynamic Resource Management
```
Step 7.1: Resource Scaling
Application Master Intelligence
         │
         ├── Monitor Task Progress
         ├── Detect Slow/Failed Tasks
         ├── Request Additional Containers (Scale Up)
         ├── Release Unused Containers (Scale Down)
         └── Handle Speculative Task Execution
```

**Dynamic Scaling Process:**
1. **Scale-Up Scenario**:
   - Detect slow-running tasks or failed containers
   - Calculate additional resource requirements
   - Submit new resource requests with higher priority
   - Launch speculative tasks on new containers

2. **Scale-Down Scenario**:
   - Identify completing or idle containers
   - Release unnecessary resources back to cluster
   - Update resource requests to reflect actual needs

#### Phase 8: Fault Tolerance and Recovery
```
Step 8.1: Multi-Level Fault Handling
   Container Failure ────► Node Manager Recovery
        │                          │
        ▼                          ▼
Application Master ────────► Resource Manager
   Retry Logic              AM Restart Logic
```

**Fault Tolerance Mechanisms:**

1. **Container Failure Handling**:
   ```
   Container Failure Recovery:
   │
   ├── Node Manager Detects Container Failure
   ├── Reports Failure to Application Master
   ├── Application Master Analyzes Failure Cause
   ├── Decides on Retry Strategy (up to max attempts)
   ├── Requests New Container for Task Retry
   └── Updates Job Progress and Status
   ```

2. **Application Master Failure Recovery**:
   ```
   AM Failure Recovery:
   │
   ├── Resource Manager Detects AM Failure
   ├── Checks AM Restart Policy and Attempt Count
   ├── Selects New Node for AM Restart
   ├── Restores AM State from Persistent Store
   ├── Re-establishes Communication with Containers
   └── Continues Job Execution from Checkpoint
   ```

#### Phase 9: Job Completion and Cleanup
```
Step 9.1: Graceful Shutdown Sequence
Application Master ────► Resource Manager ────► Client
        │                        │
        ▼                        ▼
   Cleanup Containers      Update Job Status
        │                        │
        ▼                        ▼
   Release Resources       Final Report
```

**Completion Process:**
1. **Task Completion Detection**:
   - Application Master monitors all task completions
   - Validates output data integrity
   - Handles any final cleanup tasks

2. **Resource Release**:
   ```
   Resource Cleanup:
   │
   ├── Stop All Running Containers
   ├── Clean up Temporary Files
   ├── Release Allocated Memory and CPU
   ├── Update Node Manager Resource Availability
   └── Notify Resource Manager of Resource Release
   ```

3. **Final Status Reporting**:
   ```
   Job Completion Report:
   - Final Job Status (SUCCEEDED/FAILED/KILLED)
   - Job Statistics (duration, resource usage)
   - Output Data Location
   - Performance Metrics
   - Error Logs (if any)
   ```

### Data Flow Architecture
```
HDFS Data Locality Optimization in YARN

    Input Data (HDFS)
           │
    ┌──────┼──────┐
    ▼      ▼      ▼
   DN1    DN2    DN3
    │      │      │
    ▼      ▼      ▼
Container Container Container
 (Local)  (Local)  (Local)
    │      │      │
    └──────┼──────┘
           ▼
    Application Master
    (Coordinates Data Processing)
```

**Data Locality Levels:**
1. **NODE_LOCAL**: Container runs on the same node as data
2. **RACK_LOCAL**: Container runs on the same rack as data
3. **OFF_SWITCH**: Container runs on different rack (last resort)

## Data Node Architecture (DN1 → DN2 → DN3)

### Data Locality Optimization
YARN coordinates with HDFS to optimize data processing:

```
DN1 (Data Node 1) ← Container processes local data
DN2 (Data Node 2) ← Container processes local data  
DN3 (Data Node 3) ← Container processes local data
```

**Benefits:**
- Reduces network traffic
- Improves processing speed
- Maximizes cluster efficiency

## YARN Analogy: Construction Project Management

### Project Manager (Application Master)
- Oversees entire construction project
- Negotiates resources with resource provider
- Coordinates with site supervisors
- Manages timeline and deliverables

### Resource Provider (Resource Manager)
- Manages overall resource allocation
- Provides equipment, materials, and workforce
- Ensures fair distribution across projects

### Site Supervisor (Node Manager)
- Manages local construction site
- Supervises workers and equipment
- Reports progress to project manager
- Ensures safety and quality standards

### Construction Workers (Containers)
- Execute specific construction tasks
- Use allocated tools and materials
- Report progress to site supervisor

### Construction Sites (Data Nodes)
- Physical locations where work is performed
- Contain materials and equipment
- Workers perform tasks at optimal locations

## Key Advantages of YARN Architecture

### Scalability
- Supports thousands of nodes
- Handles multiple application types
- Dynamic resource allocation

### Resource Efficiency
- Better resource utilization
- Reduced idle time
- Optimized scheduling

### Multi-tenancy
- Multiple applications run simultaneously
- Resource isolation between applications
- Fair resource sharing

### Fault Tolerance
- Application Master restart capability
- Container failure handling
- Node failure recovery

## Conclusion

YARN provides a robust, scalable architecture for managing resources in Hadoop clusters. Its separation of resource management from application logic, combined with the Application Master pattern, enables efficient execution of diverse workloads while maintaining fault tolerance and optimal resource utilization across the cluster.