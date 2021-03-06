---
title: "Modern Web Architectural Components"
date: "2020-03-28"
description: "A comprehensive insight into the modern web application architecture and its components, featuring scalability, database, message queue, stream processing and so on."
tags: ["system", "design"]
categories: ["system-design-notes"]
showtoc: false
---

- Tiers 
  - A tier is a logical separation of components in an application or service - database, backend app, user interface, messaging, caching
  - Single tier: user interface, backend business logic, database reside in the same machine
    - Pros: no network latency
    - Cons: hard to maintain once is shipped
  - Two-tier: client (user interface, business logic) & server (database)
    - Communication happens over the HTTP protocol (request-response model & stateless)
    - REST API takes advantage of the HTTP methodologies to establish communication between the client and the server
  - Three-tier: user interface, application logic, database reside in different machines
  - N-tier: more than 3 components involved - cache, message queues, load balancers,...
    - Single Responsibility Principle: a component has only a single responsibility 
    - Separation of concerns: keep components separate, make them reusable
- Scalability
  - Ability to withstand increased workload without sacrificing the latency
  - Latency can be divided into 2 parts:
    - Network latency: amount of time the network takes to send data packet from point A to B
    - Application latency: amount of time the application takes to process a user request
  - Type of scalability
    - Vertical scaling/scaling up: adding more power to server
      - Pros: not a lot of overhead on monitoring, operating and maintaining
      - Cons: single point of failure
    - Horizontal scaling/scaling out: adding more hardware to the existing resource pool
      - Pros: cheaper, better fault-tolerance
      - Cons: managing server is hard, writing distributed computing program is also challenging
  - Common bottlenecks that hurt scalability
    - Database latency
    - Poor application architecture
    - Not caching wisely
    - Inefficient configuration and load balancing
    - Adding business logic to the database
    - Badly written code
  - Common strategies to improve and test the scalability
    - Profiling
    - Cache wisely
    - Use a CDN
    - Compress data
    - Avoid unnecessary round trips between client and sever
    - Run load & stress tests
- High Availability
  - Ability to stay online despite having failures at the infrastructural level in real-time
  - Common reasons for system failures
    - Software crashes
    - Hardware crashes
    - Human error
    - Planned downtime
  - A common way to add more availability is to have redundancy - duplicating the components & keeping them on standby to take over in case the active instances go down
- Monolithic & Microservices
  - Monolithic: entire application code in a single service
    - Pros: simple to develop, test, deploy as everything resides in one repo
    - Cons:
      - Continuous deployment means re-deploying the entire application
      - Single point of failure
      - Hard to scale
  - Microservices: tasks are split into separate services forming a larger service as a whole
    - Pros:
      - No single point of failure
      - Easier to scale independently
    - Cons:
      - Difficult to manage
      - No strong consistency
- Database
  - Forms of data:
    - Structured: conforms to a certain structure, stored in a normalized fashion
    - Unstructured: no definite structure, could be text, image, video, multimedia files, machine-generated data
    - Semi-structured: mix of structured and unstructured data, stored in XML or JSON
    - User state: user logs and activity on the platform
  - Why the need for NoSQL while relational database is still doing fine?
    - Scaling relational database is not trivial, which requires Sharding or Replicating
    - NoSQL is fast with read-write and really easy to scale out
    - Eventual consistency over strong consistency
      - Eventual consistency: achieve high availability that informally guarantees that, if no new updates are made, return the last updated value for all accesses
      - Strong consistency: data has to be strongly consistent at all times
    - Data analytics
  - Polyglot persistence
    - Use different storage technologies to handle different needs within a given software application
    - Multi-model databases reduce the operational complexity of using several different database models in an application by supporting multiple data models via a single API
  - CAP theorem
    - It is impossible for a distributed data store to simultaneously provide more than two out of the following three guarantees:
      - Consistency: every read receives the most recent write
      - Availability: every request receives a non-error response
      - Partition tolerance: system continues to operate despite network failures
  - Types of databases
    - Document-oriented: generally semi-structured & stored in a JSON-like format
      - Use cases:
        - Working with semi-structured data
        - Need a flexible schema
        - Examples are real-time feeds, live sport apps, web-based multiplayer games
      - Real life implementations
        - [SEGA uses Mongo-DB to simply ops and improve gaming experiences](https://www.mongodb.com/blog/post/sega-hardlight-migrates-to-mongodb-atlas-simplify-ops-improve-experience-mobile-gamers)
        - [Coinbase uses MongoDB to scale from 15k to 1.2 million requests per minute](https://www.mongodb.com/customers/coinbase)
    - Graph: store data in nodes/vertices and edges in the form of relationships
      - Use cases:
        - Maps
        - Social graphs
        - Recommendation engines
        - Storing genetic data
      - Real life implementations
        - [Walmart uses Neo4J to show product recommendations in real-time](https://neo4j.com/case-studies/walmart/)
        - [NASA uses Neo4J to store "lessons learned" data](https://neo4j.com/blog/david-meza-chief-knowledge-architect-nasa/)
    - Key-value: use a simple key-value method to store and quickly fetch the data
      - Use cases:
        - Caching
        - Implementing queue
        - Managing real-time data
      - Real life implementations
        - [Inovonics uses Redis to drive real-time analytics on millions of sensor data](https://redislabs.com/customers/inovonics/)
        - [Microsoft uses Redis to handle the traffic spike on its platforms](https://redislabs.com/docs/microsoft-relies-redis-labs/)
        - [Google Cloud uses Memcache to implement caching on their cloud platform](https://cloud.google.com/appengine/docs/standard/python/memcache/)
    - Time series: optimized for tracking & persisting time series data
      - Use cases:
        - Managing data in real-time & continually over a long period of time
        - Managing data for running analytics & monitoring
      - Real life implementations
        - [IBM uses Influx DB to run analytics for real-time cognitive fraud detection](https://www.influxdata.com/customer/ibm/)
        - [Spiio uses Influx DB to remotely monitor vertical lining green walls & plant installations](https://www.influxdata.com/customer/customer_case_study_spiio/)
    - Wide Column: primarily used to handle massive amounts of data
      - Use cases:
        - Managing big data
      - Real life implementations
        - [Netflix uses Cassandra as the backend database for the streaming service](https://netflixtechblog.com/tagged/cassandra)
        - [Adobe uses HBase for processing large amounts of data](https://hbase.apache.org/poweredbyhbase.html)
- Caching
  - Ensure low latency and high throughput
  - Strategies
    - Cache Aside:
      - First look in the cache, return if present, else fetch from the database and update cache
      - Has a TTL (Time To Live) period to sync up data
      - Works well for read-heavy workloads like user profile data
    - Read-through
      - Similar to Cache Aside, but the cache is always up-to-date
    - Write-through
      - Cache before writing to database
      - Works well for write-heavy workloads like MMOs
    - Write-back
      - Similar to Write-through, but add some delay before writing to database
- Message queue
  - Features:
    - Facilitate asynchronous behaviour (background processes, tasks, batch jobs)
    - Facilitate cross-module communication
    - Provide temporary storage for storing messages until they're consumed
  - Models:
    - Publish-subscribe (Pub-sub): one to many relationship
    - Point to point: one to one relationship
  - Protocols:
    - [Advanced Message Queuing Protocol (AMQP)](https://en.wikipedia.org/wiki/Advanced_Message_Queuing_Protocol)
    - [Streaming Text Oriented Messaging Protocol (STOMP)](https://en.wikipedia.org/wiki/Streaming_Text_Oriented_Messaging_Protocol)
  - Real life implementations
    - [LinkedIn Real-Time Architecture](https://www.8bitmen.com/linkedin-real-time-architecture-how-does-linkedin-identify-its-users-online/)
    - [Facebook???s Live Streaming architecture](https://engineering.fb.com/ios/under-the-hood-broadcasting-live-video-to-millions/)
- Stream processing
  - Layers of data processing setup:
    - Data collection/query layer
    - Data standardization layer
    - Data processing layer
    - Data analysis layer
    - Data visualization layer
    - Data storage layer
    - Data security layer
  - Ways to ingest data:
    - Real-time 
    - Batching
  - Challenges:
    - Formatting, standardizing, converting data from multiple resources is a slow and tedious process
    - It's resource-intensive
    - Moving data around is risky
  - Use cases:
    - Moving data into Hadoop
    - Streaming data to Elastic search
    - Log processing
    - Real-time streaming
  - Distributed data processing
    - Diverge large amounts of data to several different nodes for parallel processing
    - Popular frameworks:
      - MapReduce - Apache Hadoop
      - Apache Spark
      - Apache Storm
      - Apache Kafka
  - Architecture
    - Lambda leverages both real-time and batching process that consists 3 layers
      - Batch: deals with results from the batching process
      - Speed: gets data from the real-time streaming process
      - Serving: combines the results from the Batch and Speed layers
    - Kappa has only a single pipeline and only contains Speed and Serving layers
      - Preferred if the batch and the streaming analytics results are fairly identical 
  - Real life implementations
    - [Netflix' Keystone Real-time Stream Processing Platform](https://netflixtechblog.com/keystone-real-time-stream-processing-platform-a3ee651812a)
    - [Netflix' Migrating Batch ETL to Stream Processing](https://netflixtechblog.com/keystone-real-time-stream-processing-platform-a3ee651812a)
- Other architectures
  - Event-driven: capable of handling a big number of concurrent requests with minimal resources
  - WebHooks: have an event-based mechanism that only fires an HTTP event to consumers whenever new info is available
  - Share Nothing: every module has its own environment
  - Hexagonal:
    - Port: act as an API, interface
    - Adapter: an implementation of the interface, convert data from Port to be consumed by Domain
    - Domain: contain business logic
  - Peer to Peer: nodes can communicate with each other without the need of a central server
  - Decentralized social network

**References:**
- [https://www.educative.io/courses/web-application-software-architecture-101](https://www.educative.io/courses/web-application-software-architecture-101)
