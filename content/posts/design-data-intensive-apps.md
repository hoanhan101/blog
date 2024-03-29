---
title: "📌 Designing Data-Intensive Applications by Martin Kleppmann"
date: "2020-07-05"
description: "Principles and practicalities of data systems and how to build data-intensive applications."
tags: ["system", "design", "data"]
categories: ["system-design-notes", "reading-notes"]
weight: 2
---

## 4 fundamental ideas that we need in order to design data-intensive applications.

### Reliable, scalable, maintainable applications.

- Reliability means continuing to work correctly, even when things go wrong. Common faults and preventions include:
  - Hardware faults: hard disks crash, blackout, incorrect network configuration,...
    - Add redundancy to individual hardware components to reduce the failure rate.
    - As long as we can restore a backup onto a new machine quickly, the downtime is not fatal.
  - Software faults: bug, out of shared resources, unresponsive service, cascading failure,...
    - There's no quick solution other than thorough testing, measuring, monitoring, analyzing.
  - Human errors: design error, configuration error,...
    - Enforce good design, good practice and training.
    - Decouple the places where people make the most mistake.
    - Automate testing: unit test, integration test, end-to-end test.
    - Allow quick recovery rollback strategy.
    - Set up details monitoring
- Scalability describes a system's ability to cope with increased load.
  - Describing load: requests per second, read/write radio, active users, cache hit rate,...
  - Describing performance:
    - When you increase a load parameter, keep system resources unchanged, how is performance affected?
    - When you increase a load parameter, how much do you increase the resources if you want to keep performance unchanged?
  - Approaches for coping with load:
    - Scaling up (vertical scaling): move to a more powerful machine.
    - Scaling out (horizontal scaling): distribute the load across different machines.
- Maintainability focuses on 3 design principles:
  - Operability: make it easy for operation teams to keep the system running smoothly.
    - Provide monitoring system health.
    - Support for automation and integration tools.
    - Have Good documentation.
  - Simplicity: make it easy for new engineers to understand the system.
    - Provide good abstraction layers that allow us to extract parts of a large system into well-defined, reusable components.
  - Evolvability: make it easy for engineers to make changes.
    - Follow agile approach.

### Data models and query languages.

- Data started out being represented as one big tree, though it wasn't good for representing many-to-many relationships models, so the relational model was invented.
- However, some applications didn't fit well into the relational model, non-relational NoSQL was born:
  - Document database: self-contained documents, rare relationships between one model and another.
  - Graph database: anything is related to everything.

### Storage and retrieval.

- Data structres that power your database:
  - Hash indexes:
    - Basically key-value pairs where each key is mapped to a byte offset in the data file.
    - Can also split it into smaller chunks/segments for easy storing.
    - Even though it's easy to understand and implement, it has memory constrains that the hash table must fit in memory. Also range queries are not efficient since hashed keys are not put next to each other.
  - Sorted String Table (SSTable) and Log-Structured Merge-Tree (LSM-trees):
    - SSTable maintains a list of key-value pairs that is sorted by key.
    - The table can also be split into smaller segments and merging is simple as it is sorted.
    - Maintaining a sorted structure on disk is possible, though keeping it in memory is easy as we can use a tree data structure such as Red-Black trees or AVL trees (memtable).
    - If the database crashes, memtable might be lost though we can keep a separate log for it, inspired by LSM-tree indexing structure.
  - B-trees:
    - Like SSTables, B-trees keep key-value pairs sorted by key, which allows efficient key-value lookups and range queries.
    - Instead of breaking down the database into variable-size segments and always writing sequentially, B-trees break into fixed-size blocks/pages and reading/writing one page at a time.
    - Every modification is first written to a write-ahead log (WAL) so that the index can be restored to a consistent state after a crash.
- Transactional processing or analytic?
  - The basic database access pattern is similar to processing business transaction (create, read, update, delete record), as known as online transaction processing (OLTP).
  - Since OLTP are expected to be highly available as they're critical to the operation of the business, they're reluctant to let business analysts run ad-hoc analytic queries.
  - A data warehouse is a separate database that analysts can query without affecting OLTP operations.
    - Data is extracted from OLTP databases, transformed into an analysis-friendly schema, cleaned up, and then loaded into the data warehouse.
    - A big advantage of using a separate data warehouse is that the data warehouse can be optimized for analytic access patterns.
    - 2 popular schemas that data are stored in are star schema, snowflake schema.
- Column-oriented storage:
  - In most OLTP databases, storage is laid out in a row-oriented fashion: all the values from one row of a table are stored next to each other. In the column-oriented storage, all the values are stored from each column together instead.
  - Since the sequences of values for each column are often look repetitive (distinct values are small), they often lend themselves well to compression.
- Aggregation:
  - Since data warehouse queries often involve an aggregate function, such as COUNT, SUM, AVG, MIN or MAX, we can cache these aggregated values that are used often.
  - One way of creating such a cache is a materialized view, while data cube is a special case.

### Encoding and evolution.

- Formats for encoding data.
  - Many languages come with built-in support for encoding in-memory objects to byte sequences though they are not used because it's language-specific and don't show good performance.
  - JSON, XML are widely known, supported due to the fact that they are simple, can be used by many languages and have built-in support for web browser. However, there are a lot of ambiguity around the encoding of numbers and they also don't support binary encoding (compact, efficient encoding). Hence the development of MessagePack, BSON, BJSON, and so on.
  - Thrift and Protocol Buffers are binary encoding libraries that require a schema for any data that is encoded, that is clearly defined forward and backward compatibility semantics. They come with a code generation tool that produces classes that implement the schema in various programming languages.
  - There's is also a binary encoding library Avro that is good for processing large files as in Hadoop’s use cases.
- Modes of data flow (from one process to anther).
  - Databases: the process writing to the database encodes the data, and the process reading from the database decodes it.
  - Calls to services, REST and RPC (gRPC): client encodes a request, server decodes the request and encodes a response, and client finally decodes the response.
  - Asynchronous message-passing (RabbitMQ, Apache Kafka): nodes send each other messages that are encoded by the sender and decoded by the recipient.

## Replication, partitioning/sharding, transactions, and what it means to achieve consistency and consensus in a distributed system.

### Replication.

- Why would you want to replicate data?
  - Reduce latency by keeping data geographically close to users.
  - Increase availability.
  - Increase throughput.
- 2 types of algorithms are leader-based replication and leaderless replication.
- Leader-based replication:
  - Workflow:
    - One of the replicas is designed as the leader while others are followers.
    - Client must send write request to the leader though can send read request to both leader and followers.
    - After the leader writes data to its local storage, it sends the changes to all of its followers so that they can self apply accordingly.
  - An important detail of a replicated system is whether the replication happens synchronously or asynchronously. 
    - Even though the advantage of synchronous replication is that followers is that the follower is guaranteed to have an up-to-date data, if the synchronous follower doesn’t respond, the write cannot be processed, thus the leader must block all writes and wait until one is available again.
    - It is impractical for all followers to be synchronous so leader-based replication is often configured to be completely asynchronous.
  - From time to time, you need to set up new followers to increase the number of replicas, or to replace failed nodes. This can usually be done without downtime by maintaining a consistent snapshot of the leader's database.
  - If the follower goes down, it can recover quite easily from its logs that it has received from the leader. Later when it's able to talk to the leader again, it can request all the missing data and catch up to the leader.
  - If the leader goes down, a possible approach is failover: one of the followers needs to be promoted to be the new leader using a consensus algorithm, clients and followers need to be configured to talk to the new leader. However, failover can go wrong as well (two leaders, choosing the right timeout before the leader is declared dead,...) as there are no easy solutions to these.
  - Different implementation of replication logs:
    - Statement-based replication: the leader logs every write request that it executes, and sends that statement log to its followers. Even though it seems reasonable, non-deterministic function, such as NOW() to get current date and time, is likely to generate a different value on each replica.
    - Write-ahead log (WAL) shipping: similar to B-tree's approach where every modification is first written to a WAL, besides writing the log to disk, the leader also sends it to its followers so that they can build a copy of the exact same data structures as found on the leader.
    - Logical log replication: allow the replication log to be decoupled from the storage engine by using different log formats.
    - Trigger-based replication: register a trigger to only replicate subset of the data, or from one kind of database to another and so on.
  - Replication lags:
    - If the user view the data shortly after making the write, new data may have not yet reach the replica. In this case, we need read-after-write consistency, meaning we can read from the leader first, so that user always see their latest changes.
    - If a user makes several reads from different replicas and there's lagging among replicas, they might not see the correct data. Monotonic reads guarantee that this kind of anomaly does not happen by making sure that each user always makes their reads from the same replica.
    - If some followers are replicated slower than others, an observer may see the answer before they see the question. Preventing this kind of anomaly requires consistent prefix reads so that if a sequence of writes happens in a certain order, then anyone reading those writes will see them appear in the same order.
- Multi-leader replication:
  - Use cases:
    - Multi-datacenter operation: each datacenter has its own leader. This can improve perfomance, tolerance of datacenter outages though same data may be concurrently modified in two different datacenters, and those write conflicts must be resolved.
    - Client with offline operation: every client has a local database that acts as a leader, and there is an asynchronous multi-leader replication process (sync) between the replicas on all of your clients.
    - Real-time collaborative editing: when one user edits a document, the changes are instantly applied to their local replica and asynchronously replicated to the server and any other users who are editing the same document.
  - Handling write conflicts:
    - A write conflict can be caused by two leaders concurrently updating the same record. In a single-leader scenario, it can't happen since the second leader will wait for the first write or abort it. In a multi-leader one, both writes are successful and the conflict can only be detected asynchronously at later point in time.
    - The simplest way for dealing with multi-leader write conflicts is to avoid them by making sure all writes go through the same designated leader.
    - Since there is no defined ordering of writes in a multi-leader database, it's unclear what the final value should be in all replicas. A number of ways to converge to the final value include giving each writes a unique ID and picking one with the highest ID as the winner, somehow merging values together,...
  - Topologies: communication paths along which writes are propagated from one node to another.
    - The most general topology is all-to-all where every leader sends its writes to every other leader. Other popular ones are circular and star topology.
    - A problem with circular and star topologies is that if one node fails, the path is broken, resulting in some nodes are not connected others.
    - Even though all-to-all topologies avoid a single point of failure, they can also have issues that some replications are faster and can overtake others. A technique called version vectors can be used to order these events correctly.
- Leaderless replication: client writes to several replicas or a coordinator node does this on behalf of the client.
  - A failover does not exist in a leaderless replication. If a node is down, client writes to all available replicas in parallel, verify if they're successful and simply ignore the one unavailable replica. Read requests are also sent to several nodes in parallel to avoid stale values.
  - To ensure all up-to-date data is copied to every replica, two often used mechanisms are read repair (make requests to several nodes in parallel and detect stale values using versioning), anti-entropy process (background process that constantly looks for differences in the data between replicas and copies any missing data from one replica to another).
  - If there are n replicas, every write must be confirmed by w nodes to be considered successful, and we must query at least r nodes for each read, as long as w + r > n, we expect to get an up-to-date value when reading, because at least one of the r nodes we’re reading from must be up-to-date. However, there're still edge cases when stale values are return:
    - Using a sloppy quorum.
    - Two writes happen concurrently, or with read.
    - A node carrying a failed value.
  - For multi-datacenter operation, some implementation of leaderless replication keeps all communication between clients and database nodes local to one datacenter, so n describes the number of replicas within one datacenter. Cross-datacenter replication works similarly to multi-leader replication.
  - Handling concurrent write conflicts:
    - Last write wins: attach a timestamp to each write, pick the biggest timestamp as the most ‘recent’, and discard any writes with a lower timestamp.
    - Version vectors:
      - For a singple replica, the algorithm works as follow:
        - A server maintains a version number for every key, increments the version number every time that key is written, and stores the new version number along with the value written.
        - A client must read a key before writing. When a client writes a key, it must include the version number from the prior read, and it must merge together all values that it received in the prior read.
        - When the server receives a write with a particular version number, it can overwrite all values with that version number or below but it must keep all values with a higher version number.
      - For multiple replicas:
        - We need to use a version number per replica as well as per key.
        - Each replica increments its own version number when processing a write, and also keeps track of the version numbers it has seen from all of the other replicas.

### Partitioning/sharding.

- The main reason for partitioning is scalability: partitions can be distributed across many nodes, disks, and so on.
- It is usually combined with replication so that copies of each partitions are stored on multiple nodes.
- The goal of partitioning is to spread the data and query load evenly across nodes.
- Partitioning of key-value data.
  - One way of partitioning is to assign a continuous range of keys to each partition. However, the downside is that certain patterns can lead to high load.
  - Another way is to use a hash function to determine the partition for a given key. A downside is the ability to efficiently do range queries as adjacent keys are now scattered across all partitions.
- Partitioning and secondary indexes.
  - Partitioning becomes more complicated if secondary indexes are involved since they don't identify records uniquely but rather, it’s a way of searching for occurrences of a particular value.
  - Two main approaches are document-based partitioning and term-based partitioning.
  - With document-based partitioning, each partition maintains its own secondary indexes covering only the documents in that partition. Since it doesn't care about other partitions, reading from it can be quite expensive since one need to query all partitions and aggregate everything for more exact results.
  - With term-based partitioning, rather than each partition having its own secondary index, we can construct a global index that covers data in all partitions. This can make reads more efficient rather than doing scatter/gather over all partitions. The downside is that writes are now slower and more complicated, because a write to a single document may now affect multiple partitions of the index.
- Rebalancing partitions as we increase our nodes and machines over time.
  - Mod N approach is problematic when the number of nodes N changes, most of the keys need to be moved as well.
  - A simple solution is to create many more partitions than there are nodes, and assign several partitions to each node. If a new node is added, it can steal a few partitions from every existing node.
  - Rebalancing can be done automatically, though it won't hurt to have a human in the loop to help prevent operational surprises.
- Request routing/service discovery.
  - After the partitioning and rebalancing, how does the client know which node to connection to?
    - Client can talk to any node and forward the request to the appropriate node if needed.
    - Client can talk to a routing tier that determines the node that should handle the request and forwards it accordingly.

### Transactions.

- Atomicity, Consistency, Isolation and Durability (ACID).
  - Since transactions are often composed of multiple statements, atomicity guarantees that each transaction is treated as a single "unit", which either succeeds completely, or fails completely.
  - Consistency ensures that a transaction can only bring the database from one valid state to another, maintaining database invariants.
  - Isolation means that concurrently executing transactions are isolated from each other.
  - Durability guarantees that once a transaction has been committed, it will remain committed even in the case of a system failure.
- Weak isolation levels.
  - Database hides concurrency issues from application developers by providing transaction isolation, especially serializable isolation, by guaranteeing that have transactions the same effect as if they ran serially, one at a time without any concurrency.
  - In practice, serializable isolation has a performance cost and many databases don't want to pay that price. Instead, they use weaker levels of isolation.
  - Read committed.
    - When reading from the database, you will only see data that has been committed.
    - When writing to the database, you will only overwrite data that has been committed.
  - Snapshot isolation or Multiversion Concurrency Control (MVCC).
    - Each transaction read from a consistent snapshot of the database. Each transaction sees the latest data from the time it starts.
  - Preventing lost update.
    - Lost update can occur if two transations modify the value concurrently that one modification is lost.
    - 2 popular approaches are to use atomic write and locking.
  - Preventing write skew and phantoms.
    - Write skew is a generalization of lost update. It happens when two transaction update **some** of the same objects, not just the same object.
    - Phantom happens while a write in one transaction change the result of a search query in another transaction.
    - Since multiple objects are involved, atomic single-object or snapshot isolation write doesn't help as it doesn't prevent valid conflicting concurrent writes.
    - A simple and straightforward solution is to use serializable isolation.
- Implementation of serializable isolation.
  - Actual serial execution.
    - The best way to avoid concurrency issue is to execute only one transaction at a time, in serial order, on a single thread.
    - The entire transaction is submitted as a stored procedure as the data must be small and fast.
  - Two-phase locking (2PL).
    - 2PL has really strong requirements where writers don't just block writers, readers also block writers and vice versa.
    - The big downside is performance as it hasn't used a lot in practice.
  - Serializable snapshot isolation (SSI).
    - As serial isolation doesn't scale well and 2PL doesn't perform well, SSI is promising since it provides full serializability and has only a small performance penalty compared to snapshot isolation.
    - It allows transactions to proceed without blocking. When a transaction wants to commit, it is checked, and aborted if the execution was not serializable.

### Things that may go wrong in a distributed system.

- A partial failure is when there are some parts of the system that are broken in some unpredictable ways even though the rest are working fine. And since partial failures are non-deterministic in a sense that your solution might sometimes unpredictably fail, it distributed systems hard to work with.
- Unreliable networks.
  - There are many things could go wrong with a networking request such as your request may have been lost, be waiting in a queue, the remote node may have failed, the response has been lost, delayed, and so on.
  - Network problem can be surprisingly common in practice.
  - Timeout is normally a good way to detect a fault. Rather than using a configured constant timeouts, system can automatically adjust timeouts according to the observed response time distribution.
- Unreliable clocks.
  - Time is tricky since communication is not instantaneous, it takes time for a message to travel from one point to another, and because of variable delayed in network with multiple machines are involved, it's hard to determine the order of operations.
  - Modern computers have at least two different kinds of clock:
    - A time-of-day clock, which are usually synchronized with Network Time Protocol (NTP), which means that a timestamp from one machine (ideally) means the same as a timestamp on another machine. 
    - A monotonic clock is suitable for measuring a duration such as a timeout or a service’s response time.
  - Time-of-day clocks need to be set according to an NTP in order to be useful though this isn't as reliable as we hope as he quartz clock in a computer is not very accurate, if a computer’s clock differs too much from an NTP server, it may refuse to synchronize, NTP synchronization can only be as good as the network delay, NTP servers could be wrong or misconfigured, the hardware clock is virtualized in virtual machines, and so on.
  - If you use software that requires synchronized clocks, it is essential that you also carefully monitor the clock offsets between all the machines.
- Knowledge, truth and lies.
  - A distributed system cannot exclusively rely on a single node, because a node may fail at any time, potentially leaving the system stuck and unable to recover. Instead, many distributed algorithms rely on a quorum where decisions are made by a majority of nodes.
  - Distributed systems problems become much harder if there is a risk that nodes may lie, such as claiming unreceived messages from other node or sending untrue messages to other nodes, it's known as Byzantine fault.

### Consistency and consensus.

- Most replicated databases provide at least eventual consistency, which means that if you stop writing to the database and wait for some unspecified length of time, then eventually all read requests will return the same value. However, this is a very weak guarantee as it doesn’t say anything about when the replicas will converge. Below we're looking at stronger consistency models and discussing their trade-offs.
- Linearizability makes a system appear as if there was only one copy of the data, and all operations on it are atomic.
  - It is useful in such circumstances:
    - A system needs to ensure that there is indeed only one leader.
    - Constraints and uniqueness guarantees in database: user's username or email must be unique, two people can't have the same seat on a flight,...
    - Cross-channel timing dependencies: web server and image resizer communicate both through file storage and a message queue, opening the potential for race conditions,...
  - CAP (Consistency, Availability, Partition tolerance) theorem to pick 2 out of 3:
    - If the application requires linearizability, some replicas are disconnected from the other replicas due to a network problem, then some replicas cannot process requests while they are disconnected, or unavailable.
    - If the application does not require linearizability, each replica can process requests independently, even if it is disconnected from other replica.
    - A better way of phrasing CAP would be either Consistent or Available when Partitioned 
  - Few systems are actually linearizable in practice since most of them concern about their performance and availability.
- Ordering guarantees.
  - In order to maintain causality, you need to know which operation happened before which other operation. One way is to use sequence numbers or timestamps to order events such as Lamport timestamp.
  - However, in order to implement something like a uniqueness constraint for usernames, it’s not sufficient to have a total ordering of operations as you also need to know when that order is finalized, aka total order broadcast.
  - Total order broadcast says that if every message represents a write to the database, and every replica processes the same writes in the same order, then the replicas will remain consistent with each other.
- Distributed transaction and consensus.
  - There are several situations in which it is important for nodes to reach consensus such as leader election and atomic commit in database.
  - 2-phase commit (2PC) algorithm is the most common way for achieving atomic transaction commit across multiple nodes.
    - 2PC uses a new component as a coordinator to manage all nodes.
    - The application first requests a globally unique transaction ID from the coordinator for transaction.
    - When the application is ready to commit, the coordinator begins phase 1: send a prepare request to each of the nodes, tagged with the ID, asking them whether they are able to commit.
    - If all participants reply "yes", the coordinator sends out a commit request to all nodes in phase 2, while if any of them says "no", the coordinator sends an abort request.
    - If the coordinator fails after all participants reply "yes" in phase 1, participants have no way of knowing whether to commit or abort in phase 2. The only way how this can complete is to wait for the coordinator to recover.
    - Three-phase commit (3PC) has been proposed as alternative to 2PC. However, it assumes a network with bounded delay and nodes with bounded response times which is not practical in most systems.
  - Distributed transactions in practice has mixed reputation. On one hand, they provide an important safety guarantee. On the other hand, it causes operational problems, kill perfomance and so on.
    - There are two types of distributed transaction are often conflated: database-internal distributed transactions (distributed databases that support internal transactions among the nodes of that database) and heterogeneous distributed transactions (participants are two or more different technologies).
    - That said, database-internal distributed transactions can often work quite well though transactions spanning heterogeneous technologies are a lot more challenging.
  - The best-known fault-tolerant consensus algorithms are Viewstamped Replication (VSR), Paxos, Raft and Zab as most of them provide total order broadcast. However, they're not used everywhere since they all come with performance costs.
  - ZooKeeper or etcd implements a consensus algorithm though they are often described as distributed key-value stores. They are not use directly in your application but via some other projects for distributed coordination, work allocation, service discovery, membership services.

## Batch and stream processing.

### Batch processing.

- With basic Unix tools (awk, sed, grep, sort, uniq, xarg, pipe,...), one can do a lot of powerful data processing jobs. A simple chain of Unix commands can actually perform surprisingly well as it can easily scale to large datasets, without running out of memory.
- MapReduce is a bit like Unix tools, but distributed across potentially thousands of machines.
  - While Unix tools use stdin and stdout as input and output, MapReduce jobs read and write files on a distributed filesystem like Google's GFS.
  - As the name suggested, 2 callback functions in MapReduce are map and reduce. Map extracts they key and value from the input record while reduce iterates over that collection of values with the same key and produce zero or more outputs. They're stateless function as they also don't modify output. Since the input is also bounded, the output is guaranteed to be completed.
  - The main difference to pipelines of Unix commands is that MapReduce can parallelize a computation across many machines out-of-the-box.
  - Your code does not need to worry about implementing fault tolerance mechanisms since the framework can guarantee that the final output of a job is the same as if no faults had occurred, even though in reality various tasks perhaps had to be retried.
  - It's common for MapReduce jobs to be chained together into workflows, such that the output of one job becomes the input to the next job.
  - There are several join algorithms for MapReduce such as sort-merge joins, broadcast hash joins, partitioned hash joins that allow us to use joins more efficiently.

### Stream processing.

- In batch process, the input is bounded that it's known and have finite size. In reality, a lot of data is unbounded, arrives gradually over time and never complete in any meaningful way, that batch processors must divide and process them in chunks. However, that takes a long time for impatient users. Stream processing is introduced as it simply processes every event as it happens.
- An event is generated once by a producer/publisher/sender and processed by multiple consumers/subscribers/recipients.
- A common approach for notifying consumers about new events is to use a messaging system: a producer sends a message containing the event, which is then pushed to consumers.
  - A number of messaging systems use direct network communication between producers and consumers, without going via intermediary nodes such as UDP multicast, ZeroMQ, webhooks,...
  - A widely-used alternative is to send messages via a message broker/message queue. Two types of them are:
    - AMQP/JMS-style message brokers: the broker assigned individual messages to consumers, consumers acknowledge when they have been successfully processed.
    - Log-based message brokers: the broker assigns all messages in a partition to the same consumer node, and always delivers messages in the same order while consumers keep their logs.
  - When multiple consumers are reading messages in the same topic, two main patterns of messaging are load balancing and fan out.
- It's also useful to think of the writes to a database as a stream that it can capture the changelog, either implicitly through change data capture or explicitly through event sourcing as it also opens up powerful opportunities for integrating systems.
  - You can keep derived data systems such as search indexes, caches and analytics systems continually up-to-date by consuming the log of changes and applying them to the derived system.
  - You can even build fresh views onto existing data by starting from scratch and consuming the log of changes from the beginning all the way to the present.
- Stream processing has long been used for monitoring purposes, where an organization wants to be alerted if certain things happen. However, other uses of stream processing have also emerged over time.
  - Complex event processing (CEP) allows you to specify rules to search for certain patterns of events in a stream.
  - Analytics that are more oriented towards aggregations and statistical metrics over a large number of events are also used.
  - It can be used to maintain materialized views onto some dataset, so that you can query it efficiently, and updating that view whenever the underlying data changes.
- Stream processing frameworks use the local system clock on the processing machine to determine windowing. Even though it's simple to implement and reason about, it breaks down if there is any significant processing lag.
- There are 3 types of join that may appear in stream processes:
  - Stream-stream joins: matching two events that occur within some window of time.
  - Stream-table joins: one input stream consists of activity events, while the other is a database changelog.
  - Table-table joins: both input streams are database changelogs where every change on one side is joined with the latest state of the other side.
- To tolerate faults, one solution is to break the stream into small blocks, and treat each block like a miniature batch process (microbatching). Other is to use idempotent writes.

**References:**
- <https://www.goodreads.com/book/show/23463279-designing-data-intensive-applications>
- <https://en.wikipedia.org/wiki/ACID>
