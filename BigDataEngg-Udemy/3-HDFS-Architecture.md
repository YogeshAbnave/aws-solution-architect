### DataNode (Worker) - Detailed Architecture

DataNodes are the workhorses that store the actual data blocks and serve read/write requests.

#### **Internal DataNode Architecture**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          DataNode Internal Architecture                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                       Network Layer                                 │    │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐      │    │
│  │  │   Data Server   │  │  IPC Server     │  │   Info Server   │      │    │
│  │  │  (Port 50010/   │  │  (Port 50020)   │  │  (Port 50075)   │      │    │
│  │  │     9866)       │  │                 │  │                 │      │    │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘      │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                   │                                         │
│                                   ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                        Service Layer                                │    │
│  │                                                                     │    │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐      │    │
│  │  │   Block         │  │   Data Transfer │  │   Volume        │      │    │
│  │  │   Manager       │  │   Manager       │  │   Manager       │      │    │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘      │    │
│  │           │                     │                     │             │    │
│  │           ▼                     ▼                     ▼             │    │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐      │    │
│  │  │   Checksum      │  │   Pipeline      │  │   Disk          │      │    │
│  │  │   Manager       │  │   Manager       │  │   Manager       │      │    │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘      │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                   │                                         │
│                                   ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                        Storage Layer                                │    │
│  │                                                                     │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │                    Volume Management                        │    │    │
│  │  │                                                             │    │    │
│  │  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │    │    │
│  │  │  │   Volume    │  │   Volume    │  │   Volume    │          │    │    │
│  │  │  │     /d1     │  │     /d2     │  │     /dN     │          │    │    │
│  │  │  │             │  │             │  │             │          │    │    │
│  │  │  │ ┌─────────┐ │  │ ┌─────────┐ │  │ ┌─────────┐ │          │    │    │
│  │  │  │ │current/ │ │  │ │current/ │ │  │ │current/ │ │          │    │    │
│  │  │  │ │finalized│ │  │ │finalized│ │  │ │finalized│ │          │    │    │
│  │  │  │ │rbw/     │ │  │ │rbw/     │ │  │ │rbw/     │ │          │    │    │
│  │  │  │ │tmp/     │ │  │ │tmp/     │ │  │ │tmp/     │ │          │    │    │
│  │  │  │ └─────────┘ │  │ └─────────┘ │  │ └─────────┘ │          │    │    │
│  │  │  └─────────────┘  └─────────────┘  └─────────────┘          │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  │                                                                     │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │                     Block Storage                           │    │    │
│  │  │                                                             │    │  

 # HDFS Architecture - Complete Guide

## Table of Contents
1. [Introduction](#introduction)
2. [Why HDFS?](#why-hdfs)
3. [Core Architecture](#core-architecture)
4. [Master-Worker Model](#master-worker-model)
5. [Block Management](#block-management)
6. [Replication & Fault Tolerance](#replication--fault-tolerance)
7. [High Availability (HA)](#high-availability-ha)
8. [Data Operations](#data-operations)
9. [Google Cloud Hadoop Clusters](#google-cloud-hadoop-clusters)
10. [Command Reference](#command-reference)
11. [Best Practices](#best-practices)

---

## Introduction

Hadoop Distributed File System (HDFS) is a distributed file system designed to store and manage large datasets across multiple machines in a cluster. It provides high fault tolerance, scalability, and efficient data processing capabilities for big data applications.

---

## Why HDFS?

HDFS addresses the fundamental challenges of big data storage and processing:

### Core Benefits
- **Distributed Storage**: Distributes data across multiple machines, enabling horizontal scaling
- **Fault Tolerance**: Replicates data across different nodes to prevent data loss
- **Efficient Processing**: Optimized for large file processing and batch operations
- **Cost-Effective**: Runs on commodity hardware, reducing infrastructure costs
- **High Throughput**: Designed for streaming data access patterns rather than random access

### Use Cases
- Big data analytics and processing
- Data warehousing and ETL operations
- Machine learning model training on large datasets
- Log file storage and analysis
- Backup and archival storage

---

## Core Architecture

HDFS follows a **Master-Worker architecture** with clear separation of concerns between metadata management and data storage.

### High-Level Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           HDFS Ecosystem Architecture                           │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                        Client Layer                                     │    │
│  │  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐    │    │
│  │  │    HDFS      │ │   MapReduce  │ │    Spark     │ │    Hive      │    │    │
│  │  │   Client     │ │   Client     │ │   Client     │ │   Client     │    │    │
│  │  └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘    │    │
│  └─────────────────────────────────────────────────────────────────────────┘    │
│                                   │                                             │
│                                   ▼                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                        HDFS API Layer                                    │   │
│  │  ┌──────────────────┐              ┌──────────────────┐                  │   │
│  │  │ DistributedFile  │              │   FileSystem     │                  │   │
│  │  │     System       │              │     Interface    │                  │   │
│  │  └──────────────────┘              └──────────────────┘                  │   │
│  └─────────────────────────────────────────────────────────────────────────┘    │
│                                   │                                             │
│                                   ▼                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                      HDFS Core Components                               │    │
│  │                                                                         │    │
│  │    ┌─────────────────────────────────────────────────────────┐          │    │
│  │    │                 NameNode Cluster                       │           │    │
│  │    │  ┌─────────────┐                    ┌─────────────┐    │           │    │ 
│  │    │  │   Active    │◄─── Failover ────►│   Standby   │    │            │    │
│  │    │  │  NameNode   │                    │  NameNode   │    │           │    │
│  │    │  └─────────────┘                    └─────────────┘    │           │    │
│  │    │         │                                   │          │           │    │
│  │    │         └─────────── Shared Edit Logs ─────┘          │            │    │
│  │    └─────────────────────────────────────────────────────────┘          │    │
│  │                                   │                                     │    │
│  │                                   │ Metadata Operations                 │    │
│  │                                   ▼                                     │    │
│  │    ┌─────────────────────────────────────────────────────────┐          │    │
│  │    │                 DataNode Pool                           │          │    │
│  │    │                                                         │          │    │
│  │    │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐    │            │    │
│  │    │  │  DataNode   │  │  DataNode   │  │  DataNode   │    │            │    │
│  │    │  │   Rack 1    │  │   Rack 2    │  │   Rack N    │    │            │    │
│  │    │  │             │  │             │  │             │    │            │    │
│  │    │  │ ┌─────────┐ │  │ ┌─────────┐ │  │ ┌─────────┐ │    │            │    │
│  │    │  │ │Block    │ │  │ │Block    │ │  │ │Block    │ │    │            │    │
│  │    │  │ │Storage  │ │  │ │Storage  │ │  │ │Storage  │ │    │            │    │
│  │    │  │ └─────────┘ │  │ └─────────┘ │  │ └─────────┘ │    │            │    │
│  │    │  └─────────────┘  └─────────────┘  └─────────────┘    │            │    │
│  │    └─────────────────────────────────────────────────────────┘          │    │
│  └─────────────────────────────────────────────────────────────────────────┘    │
│                                                                                 │
│  ┌─────────────────────────────────────────────────────────────────────────┐    │
│  │                    Support Infrastructure                               │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │    │
│  │  │ JournalNode │  │ ZooKeeper   │  │   Balancer  │  │   SecondNN  │     │    │
│  │  │   Quorum    │  │   Ensemble  │  │   Service   │  │   (Legacy)  │     │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘     │    │
│  └─────────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### Detailed System Architecture

#### **Multi-Layer Architecture Stack**

```
┌─────────────────────────────────────────────────────────────────┐
│                    Application Layer                            │ ← User Applications
├─────────────────────────────────────────────────────────────────┤
│                      API Layer                                  │ ← Java/REST APIs  
├─────────────────────────────────────────────────────────────────┤
│                   HDFS Client Layer                             │ ← Protocol Handling
├─────────────────────────────────────────────────────────────────┤
│                 NameNode Service Layer                          │ ← Metadata Management
├─────────────────────────────────────────────────────────────────┤
│                 DataNode Service Layer                          │ ← Data Storage
├─────────────────────────────────────────────────────────────────┤
│                  Block Storage Layer                            │ ← Physical Storage
├─────────────────────────────────────────────────────────────────┤
│                Operating System Layer                           │ ← OS File System
├─────────────────────────────────────────────────────────────────┤
│                    Hardware Layer                               │ ← Physical Hardware
└─────────────────────────────────────────────────────────────────┘
```

### Network Communication Architecture

```
                         HDFS Network Communication Flow
                                      
       Client ←→ NameNode: RPC (Port 8020/9000)
         │          │
         │          │ Metadata Queries
         │          ▼
         │     ┌─────────────┐
         │     │  NameNode   │
         │     │   Memory    │
         │     │             │
         │     │ ┌─────────┐ │
         │     │ │FSImage &│ │
         │     │ │EditLogs │ │
         │     │ └─────────┘ │
         │     └─────────────┘
         │            │
         │            │ Block Reports/Heartbeats
         │            ▼
         └────────────────────── Data Transfer (Port 50010/9866) ──────┐
                                                                       │
    ┌─────────────┐         ┌─────────────┐         ┌─────────────┐    │
    │  DataNode   │◄────────┤  DataNode   │────────►│  DataNode   │◄─-─┘
    │   Rack 1    │         │   Rack 2    │         │   Rack 3    │
    │             │         │             │         │             │
    │ ┌─────────┐ │         │ ┌─────────┐ │         │ ┌─────────┐ │
    │ │Blocks   │ │         │ │Blocks   │ │         │ │Blocks   │ │
    │ │1,4,7... │ │         │ │2,5,8... │ │         │ │3,6,9... │ │
    │ └─────────┘ │         │ └─────────┘ │         │ └─────────┘ │
    └─────────────┘         └─────────────┘         └─────────────┘
```

---

## Master-Worker Model

### NameNode (Master) - Detailed Architecture

The NameNode is the central metadata server that manages the file system namespace and coordinates data access.

#### **Internal NameNode Architecture**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            NameNode Internal Architecture                   │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                        RPC Server Layer                             │    │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐      │    │
│  │  │   Client RPC    │  │  DataNode RPC   │  │   Web UI RPC    │      │    │
│  │  │   (Port 8020)   │  │  (Port 8020)    │  │  (Port 50070)   │      │    │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘      │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                   │                                         │
│                                   ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                      Service Layer                                  │    │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐      │    │
│  │  │   Namespace     │  │   Block         │  │   Lease         │      │    │
│  │  │   Manager       │  │   Manager       │  │   Manager       │      │    │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘      │    │
│  │           │                     │                     │             │    │
│  │           ▼                     ▼                     ▼             │    │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐      │    │
│  │  │   Permission    │  │   Replication   │  │   Heartbeat     │      │    │
│  │  │   Manager       │  │   Manager       │  │   Manager       │      │    │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘      │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                   │                                         │
│                                   ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                       Memory Layer                                  │    │
│  │                                                                     │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │                    Namespace Image                          │    │    │
│  │  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │    │    │
│  │  │  │   INode     │  │   INode     │  │   INode     │          │    │    │
│  │  │  │    Tree     │  │  Directory  │  │   Block     │          │    │    │
│  │  │  │             │  │    Map      │  │    Map      │          │    │    │
│  │  │  └─────────────┘  └─────────────┘  └─────────────┘          │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  │                                                                     │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │                    Block Management                         │    │    │
│  │  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │    │    │
│  │  │  │   Block     │  │   Block     │  │ Under/Over  │          │    │    │
│  │  │  │  Location   │  │  Pool Map   │  │ Replicated  │          │    │    │
│  │  │  │     Map     │  │             │  │   Blocks    │          │    │    │
│  │  │  └─────────────┘  └─────────────┘  └─────────────┘          │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                   │                                         │
│                                   ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                      Persistence Layer                              │    │
│  │                                                                     │    │
│  │  ┌─────────────────┐              ┌─────────────────┐               │    │
│  │  │    FSImage      │              │   Edit Logs     │               │    │
│  │  │                 │              │                 │               │    │
│  │  │ ┌─────────────┐ │              │ ┌─────────────┐ │               │    │
│  │  │ │  Namespace  │ │              │ │ Transaction │ │               │    │
│  │  │ │  Snapshot   │ │              │ │   Journal   │ │               │    │ 
│  │  │ └─────────────┘ │              │ └─────────────┘ │               │    │
│  │  │                 │              │                 │               │    │
│  │  │ ┌─────────────┐ │              │ ┌─────────────┐ │               │    │
│  │  │ │   Block     │ │              │ │   Current   │ │               │    │
│  │  │ │  Metadata   │ │              │ │   In-Progress│ │              │    │
│  │  │ └─────────────┘ │              │ └─────────────┘ │               │    │
│  │  └─────────────────┘              └─────────────────┘               │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────┘
```

#### **Core NameNode Components**

##### **1. Namespace Manager**
- **INode Management**: Maintains file system tree structure
- **Path Resolution**: Converts file paths to INode references
- **Directory Operations**: Handles directory creation, deletion, listing
- **Metadata Caching**: Keeps frequently accessed metadata in memory

##### **2. Block Manager**
- **Block Allocation**: Assigns blocks to DataNodes for new files
- **Block Location Tracking**: Maintains mapping of blocks to DataNodes
- **Replication Policy**: Enforces replication factor requirements
- **Block Reports Processing**: Handles DataNode block inventory reports

##### **3. Lease Manager**
- **Write Coordination**: Manages exclusive write access to files
- **Lease Renewal**: Handles client lease renewals during long operations
- **Recovery Operations**: Manages block recovery for failed writes
- **Conflict Resolution**: Prevents concurrent write conflicts

##### **4. Heartbeat Manager**
- **Node Health Monitoring**: Tracks DataNode availability
- **Failure Detection**: Identifies failed or slow DataNodes
- **Command Dispatching**: Sends replication/deletion commands
- **Load Balancing**: Distributes work across DataNodes

#### **NameNode Memory Layout**

```
┌─────────────────────────────────────────────────────────────┐
│                  NameNode JVM Heap Layout                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │            Namespace Memory (60-70%)                │    │
│  │                                                     │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │    │
│  │  │   INode     │  │  Directory  │  │   File      │  │    │
│  │  │   Objects   │  │   Entries   │  │ Attributes  │  │    │
│  │  │   (~200B    │  │   (~40B     │  │   (~150B    │  │    │
│  │  │   each)     │  │   each)     │  │   each)     │  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │            Block Memory (20-30%)                    │    │
│  │                                                     │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │    │
│  │  │   Block     │  │  BlockInfo  │  │   Replica   │  │    │
│  │  │  Objects    │  │   Objects   │  │   Objects   │  │    │
│  │  │   (~100B    │  │   (~80B     │  │   (~48B     │  │    │
│  │  │   each)     │  │   each)     │  │   each)     │  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │            Network & Cache (5-10%)                  │    │
│  │                                                     │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │    │
│  │  │  RPC Call   │  │   DataNode  │  │   Client    │  │    │
│  │  │   Cache     │  │   Cache     │  │   Cache     │  │    │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │            JVM Overhead (5-10%)                     │    │
│  │   GC, Class Loading, Thread Stacks, etc.            │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘

Memory Calculation Example:
- 100 million files = ~20GB namespace metadata
- 1 billion blocks = ~100GB block metadata  
- Total NameNode heap needed: ~150GB+ (with overhead)
```

#### **Responsibilities & Operations**

| **Category** | **Operation** | **Description** | **Performance Impact** |
|-------------|---------------|-----------------|----------------------|
| **Metadata Management** | File/Directory CRUD | Create, read, update, delete operations | High memory usage |
| **Block Management** | Block allocation | Assigns blocks to DataNodes | Network intensive |
| **Namespace Operations** | Path resolution | Converts paths to INode references | CPU intensive |
| **Client Coordination** | Request routing | Directs clients to appropriate DataNodes | Network coordination |
| **Replication Management** | Under-replication handling | Ensures proper block replication | Background processing |
| **Heartbeat Processing** | Node health monitoring | Tracks DataNode availability | Continuous monitoring |
| **Lease Management** | Write coordination | Manages exclusive file access | Concurrency control |

#### **Key Characteristics & Limitations**

##### **Advantages**
- **Centralized Metadata**: Single source of truth for namespace
- **Fast Metadata Access**: In-memory operations for quick responses
- **Simplified Consistency**: Easier to maintain consistency with single master
- **Global View**: Complete cluster visibility for optimization

##### **Limitations**
- **Memory Constraints**: Metadata must fit in NameNode RAM
- **Single Point of Failure**: Cluster unavailable if NameNode fails (non-HA)
- **Scalability Bottleneck**: All metadata operations go through single node
- **Startup Time**: FSImage loading can take significant time for large clusters

### DataNode (Worker)

DataNodes are the workhorses that store the actual data blocks and serve read/write requests.

#### **Responsibilities**
- **Data Storage**: Stores actual file data in blocks on local disk
- **Block Operations**: Handles block creation, deletion, and replication
- **Heartbeat Communication**: Sends periodic status updates to NameNode
- **Block Reporting**: Reports block inventory and health status
- **Data Pipeline**: Participates in data replication pipelines

#### **Key Characteristics**
- **Block-Based Storage**: Stores data in fixed-size blocks (default 128MB)
- **Local File System**: Uses underlying OS file system for storage
- **Automatic Registration**: Registers with NameNode on startup
- **Failure Detection**: Monitored via heartbeat mechanism

### Comparison Table

| **Aspect**           | **NameNode**                          | **DataNode**                          |
|---------------------|---------------------------------------|---------------------------------------|
| **Primary Role**     | Metadata management and coordination  | Data storage and block operations     |
| **Data Stored**      | File metadata, block locations        | Actual data blocks (default: 128 MB) |
| **Memory Usage**     | High (keeps metadata in RAM)         | Moderate (caches frequently accessed blocks) |
| **Fault Tolerance**  | Single point of failure (non-HA)     | Replicates blocks across multiple nodes |
| **Communication**    | Coordinates clients and DataNodes     | Sends heartbeats and block reports    |
| **Scalability**      | Vertical scaling (more RAM/CPU)      | Horizontal scaling (add more nodes)   |
| **Persistence**      | Edit logs and FSImage files          | Local file system storage            |

---

## Block Management

### Block Fundamentals

HDFS divides large files into fixed-size blocks for distributed storage and parallel processing.

#### **Default Block Size: 128 MB**

**Why 128 MB?**
- Balances between parallelism and metadata overhead
- Optimizes network utilization and reduces seeks
- Suitable for most big data workloads

#### **Block Size Trade-offs**

| **Block Size** | **Advantages** | **Disadvantages** |
|---------------|----------------|-------------------|
| **Smaller Blocks** | • Higher parallelism<br>• Better for small files<br>• More granular data access | • Increased metadata overhead<br>• More network overhead<br>• Higher NameNode memory usage |
| **Larger Blocks** | • Reduced metadata overhead<br>• Better for large files<br>• Improved sequential read performance | • Reduced parallelism<br>• Potential data locality issues<br>• Less efficient for small files |

### Block Distribution Strategy

#### **Rack Awareness**
HDFS implements rack-aware placement to optimize data locality and fault tolerance:

```
Rack 1                  Rack 2                  Rack 3
┌─────────────┐        ┌─────────────┐        ┌─────────────┐
│ DataNode A  │        │ DataNode D  │        │ DataNode G  │
│ DataNode B  │        │ DataNode E  │        │ DataNode H  │
│ DataNode C  │        │ DataNode F  │        │ DataNode I  │
└─────────────┘        └─────────────┘        └─────────────┘

Block Replica Placement:
- Replica 1: Same rack as client (or random)
- Replica 2: Different rack from replica 1
- Replica 3: Same rack as replica 2, different node
```

---

## Replication & Fault Tolerance

### Replication Strategy

#### **Default Replication Factor: 3**

**Why 3 Replicas?**
- Provides fault tolerance for up to 2 simultaneous node failures
- Balances storage overhead with reliability
- Enables efficient read performance through data locality

#### **Replica Placement Policy**

1. **First Replica**: Placed on the same node as the client (if client is in cluster) or random node
2. **Second Replica**: Placed on a different rack to ensure rack-level fault tolerance
3. **Third Replica**: Placed on the same rack as the second replica but different node

### Failure Detection and Recovery

#### **Failure Types and Detection**

| **Failure Type** | **Detection Method** | **Detection Time** | **Recovery Action** |
|------------------|---------------------|-------------------|---------------------|
| **Temporary Node Failure** | Heartbeat timeout | 10.5 minutes | Re-replicate under-replicated blocks |
| **Permanent Node Failure** | Prolonged heartbeat absence | Extended timeout | Mark blocks as lost; create new replicas |
| **Disk Failure** | Block checksum validation | On read/write operations | Replicate blocks from other nodes |
| **Network Partition** | Heartbeat interruption | Network-dependent | Isolate affected nodes temporarily |

#### **Heartbeat Mechanism**

```
DataNode ──────────── Heartbeat (every 3 seconds) ──────────► NameNode
         ◄─────────── Instructions/Block Reports ──────────── 

Heartbeat Timeout Calculation:
- Heartbeat Interval: 3 seconds
- Timeout Threshold: 10 heartbeats + 30 seconds = 10.5 minutes
```

#### **Under-Replication Recovery Process**

1. **Detection**: NameNode identifies blocks with insufficient replicas
2. **Prioritization**: Ranks blocks by replication deficit (blocks with 0 replicas get highest priority)
3. **Source Selection**: Chooses healthy DataNodes with available replicas
4. **Target Selection**: Selects target DataNodes based on rack awareness and load balancing
5. **Replication**: Initiates block copy operations to restore replication factor

---

## High Availability (HA)

### Traditional HDFS Limitations

- **Single Point of Failure**: NameNode failure results in cluster unavailability
- **Planned Downtime**: Upgrades and maintenance require cluster shutdown
- **Recovery Time**: FSImage and edit log replay can take significant time

### HA Architecture Components

#### **Active-Standby NameNode Configuration**

```
┌─────────────────────────────────────────────────────────────┐
│                    HDFS HA Cluster                          │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐                    ┌─────────────┐         │
│  │   Active    │                    │   Standby   │         │
│  │  NameNode   │◄──── Failover ────►│  NameNode   │         │
│  └─────────────┘                    └─────────────┘         │
│         │                                   │               │
│         │                                   │               │
│         ▼                                   ▼               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              JournalNodes Quorum                    │    │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐              │    │
│  │  │Journal 1│  │Journal 2│  │Journal 3│              │    │
│  │  └─────────┘  └─────────┘  └─────────┘              │    │
│  └─────────────────────────────────────────────────────┘    │
│                           │                                 │
│                           ▼                                 │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                ZooKeeper                            │    │
│  │  ┌─────────┐  ┌─────────┐  ┌─────────┐              │    │
│  │  │  ZK 1   │  │  ZK 2   │  │  ZK 3   │              │    │
│  │  └─────────┘  └─────────┘  └─────────┘              │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

#### **HA Component Roles**

| **Component**        | **Role** | **Responsibilities** |
|---------------------|----------|----------------------|
| **Active NameNode**  | Primary metadata server | • Handles all client requests<br>• Manages file system operations<br>• Writes to shared edit logs |
| **Standby NameNode** | Hot backup server | • Reads shared edit logs<br>• Maintains synchronized metadata<br>• Ready for immediate failover |
| **JournalNodes**     | Shared storage system | • Store edit logs in distributed fashion<br>• Provide consistency guarantees<br>• Require majority quorum for writes |
| **ZooKeeper**        | Coordination service | • Manages automatic failover<br>• Prevents split-brain scenarios<br>• Provides distributed consensus |

#### **Failover Process**

1. **Failure Detection**: ZooKeeper detects Active NameNode failure
2. **Fencing**: Ensures failed NameNode cannot process requests
3. **Standby Activation**: Standby NameNode reads latest edit logs
4. **State Synchronization**: Ensures metadata consistency
5. **Service Activation**: Standby becomes Active, starts serving requests

---

## Data Operations

### Read Operation Workflow

#### **Step-by-Step Read Process**

```
Client ──1──► NameNode: "Where is file X?"
       ◄─2─── NameNode: "Blocks at DataNodes A, B, C"
       ──3──► DataNode A: "Give me block 1"
       ◄─4─── DataNode A: "Here's block 1 data"
       ──5──► DataNode B: "Give me block 2"
       ◄─6─── DataNode B: "Here's block 2 data"
```

**Detailed Steps:**
1. **Client Request**: Client queries NameNode for file block locations
2. **Metadata Response**: NameNode returns list of DataNodes containing file blocks
3. **Data Locality**: Client preferentially contacts nearest DataNode
4. **Direct Data Transfer**: Client reads data directly from DataNodes
5. **Parallel Reads**: Multiple blocks can be read simultaneously
6. **Checksum Verification**: Data integrity verified during transfer

### Write Operation Workflow

#### **Step-by-Step Write Process**

```
Client ──1──► NameNode: "I want to write file Y"
       ◄─2─── NameNode: "Write to DataNodes D, E, F"
       ──3──► DataNode D: "Here's block data + replicate to E"
              DataNode D ──4──► DataNode E: "Block data + replicate to F"
                         DataNode E ──5──► DataNode F: "Block data"
                                    DataNode F ──6──► DataNode E: "ACK"
                         DataNode E ──7──► DataNode D: "ACK"
       ◄─8─── DataNode D: "Write complete"
```

**Detailed Steps:**
1. **Write Request**: Client requests file creation from NameNode
2. **Node Allocation**: NameNode allocates DataNodes for block storage
3. **Pipeline Setup**: Client establishes write pipeline to DataNodes
4. **Data Streaming**: Data flows through pipeline with replication
5. **Acknowledgment**: Success confirmations flow back through pipeline
6. **Block Reporting**: DataNodes report new blocks to NameNode
7. **Metadata Update**: NameNode updates file system metadata

---

## Google Cloud Hadoop Clusters

### Cluster Configuration Types

#### **Standard Cluster**
- **Architecture**: 1 Master + N Worker nodes
- **Use Case**: Production workloads with dedicated master
- **Advantages**: Clear separation of concerns, scalable
- **Considerations**: Master node is single point of failure

#### **Single Node Cluster**
- **Architecture**: 1 node (Master + Worker combined)
- **Use Case**: Development, testing, small-scale processing
- **Advantages**: Simple setup, cost-effective for small workloads
- **Considerations**: No fault tolerance, limited scalability

#### **High Availability Cluster**
- **Architecture**: 3 Master nodes + N Worker nodes
- **Use Case**: Production workloads requiring high availability
- **Advantages**: Fault tolerance, automatic failover, continuous operation
- **Considerations**: Higher cost, more complex setup

### Cluster Sizing Recommendations

| **Workload Type** | **Recommended Configuration** | **Rationale** |
|------------------|------------------------------|---------------|
| **Development** | Single node, 4-8 cores, 16-32 GB RAM | Cost-effective, sufficient for testing |
| **Small Production** | 1 master + 3-5 workers, 8+ cores each | Basic fault tolerance, moderate scale |
| **Large Production** | HA setup, 10+ workers, 16+ cores each | High availability, enterprise scale |

---

## Command Reference

### Linux Fundamentals

#### **Navigation Commands**
```bash
pwd                    # Print current working directory
cd /path/to/directory  # Change directory
cd ~                   # Go to home directory
cd ..                  # Go to parent directory
ls                     # List files and directories
ls -la                 # List with details and hidden files
```

#### **File Operations**
```bash
mv source destination  # Move/rename files
cp source destination  # Copy files
rm filename           # Remove files
mkdir dirname         # Create directory
rmdir dirname         # Remove empty directory
```

### HDFS Commands

#### **Basic HDFS Operations**
```bash
# List HDFS contents
hdfs dfs -ls /
hdfs dfs -ls /user/

# Create directories
hdfs dfs -mkdir /user/data
hdfs dfs -mkdir -p /user/data/input

# Copy files from local to HDFS
hadoop fs -put localfile.txt /user/data/
hdfs dfs -put localfile.txt /user/data/

# Copy files from HDFS to local
hdfs dfs -get /user/data/file.txt ./
hadoop fs -get /user/data/file.txt ./

# Copy within HDFS
hdfs dfs -cp /user/data/file1.txt /user/data/file2.txt

# Move within HDFS
hdfs dfs -mv /user/data/file1.txt /user/data/backup/

# Remove files
hdfs dfs -rm /user/data/file.txt
hdfs dfs -rm -r /user/data/directory/
```

#### **Advanced HDFS Operations**
```bash
# Check file system status
hdfs dfsadmin -report

# Check file system health
hdfs fsck /

# Check specific file
hdfs fsck /user/data/file.txt -files -blocks -locations

# Set replication factor
hdfs dfs -setrep 2 /user/data/file.txt

# Check disk usage
hdfs dfs -du /user/data/
hdfs dfs -du -h /user/data/

# Display file contents
hdfs dfs -cat /user/data/file.txt
hdfs dfs -tail /user/data/file.txt
```

#### **Administrative Commands**
```bash
# Safe mode operations
hdfs dfsadmin -safemode get
hdfs dfsadmin -safemode enter
hdfs dfsadmin -safemode leave

# Balancer operations
hdfs balancer
hdfs balancer -threshold 5

# Namenode operations
hdfs namenode -format
hdfs namenode -checkpoint
```

---

## Best Practices

### Performance Optimization

#### **File Size Guidelines**
- **Optimal File Size**: 128 MB to several GB per file
- **Avoid Small Files**: Combine small files to reduce NameNode memory pressure
- **Use Appropriate Block Size**: Adjust based on file size and processing patterns

#### **Data Locality Optimization**
- **Rack Awareness**: Configure proper rack topology
- **Balanced Clusters**: Use HDFS balancer to distribute data evenly
- **Client Placement**: Run processing jobs close to data

### Security Considerations

#### **Access Control**
- **Permissions**: Set appropriate file and directory permissions
- **User Management**: Use proper user authentication and authorization
- **Encryption**: Enable data encryption at rest and in transit

#### **Network Security**
- **Firewall Rules**: Restrict access to HDFS ports
- **Kerberos**: Implement strong authentication mechanisms
- **SSL/TLS**: Encrypt data transfers

### Monitoring and Maintenance

#### **Key Metrics to Monitor**
- **NameNode Heap Usage**: Monitor memory consumption
- **DataNode Health**: Track failed nodes and disk usage
- **Block Replication**: Monitor under-replicated blocks
- **Network Throughput**: Track data transfer rates

#### **Regular Maintenance Tasks**
- **Log Rotation**: Manage log file sizes
- **Metadata Backup**: Regular FSImage and edit log backups
- **Cluster Balancing**: Periodic data redistribution
- **Health Checks**: Regular file system consistency checks

### Troubleshooting Common Issues

#### **Performance Issues**
- **Slow Reads**: Check data locality and network bandwidth
- **Slow Writes**: Verify DataNode disk performance and network
- **High NameNode Memory**: Reduce small files, increase heap size

#### **Availability Issues**
- **DataNode Failures**: Check disk health and network connectivity
- **NameNode Issues**: Monitor memory usage and GC performance
- **Network Partitions**: Verify network configuration and connectivity

---

## Conclusion

HDFS provides a robust, scalable, and fault-tolerant storage solution for big data applications. Its master-worker architecture, combined with intelligent replication strategies and high availability features, makes it suitable for enterprise-scale data processing workloads. Understanding these architectural principles and operational practices is essential for successfully deploying and managing HDFS clusters in production environments.