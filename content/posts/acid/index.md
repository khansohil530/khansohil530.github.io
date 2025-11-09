---
title: "ACID Properties: Core Principles for any Database Systems"
description: "ACID"
categories: [Database]
date: 2025-06-14
---

**ACID**, which stands for <u>**A**</u>tomicity, <u>**C**</u>onsistency, <u>**I**</u>solation, <u>**D**</u>urability are 
4 fundamental properties which needs to be considered when developing a database management system. 
These properties are essential because they help guiding through problems already encountered across databases. 

But to understand these properties individually, we’ll first need to understand <b>Transaction</b>.

## Transaction
**Transaction** is a collection of DML queries which should be treated as a single unit of work at application level. 

For example, in a banking application money transfer from one account to other should be treated as a single operation 
as we either want the transfer to succeed or not.
However, the actual code to perform this function might issue multiple DML queries,
like checking the balance see if the transfer amount is available,debiting the amount and finally crediting the amount.
If all these queries aren’t wrapped in a transaction,
we can encounter serious bugs like money being debited but not credited,
or debiting money when we don't have available balance, etc.

A Transaction's lifecycle usually involves keywords to begin (`BEGIN`),
to save changes (`COMMIT`) and discard changes (`ROLLBACK`).
Each of these commands are implemented differently across different DBMS. 
For Example, `COMMIT` can save changes directly to disk,
or gather multiple changes in memory before flushing them to disk.
Both options have their use case,
as applications which doesn't allow margin for data loss would go for first approach while
applications which have high throughput requirement can opt for second option. 

Transactions are mostly associated with writes, but you can also have read-only transactions. 
For example, **Read-only** transactions are valuable for generating consistent reports by providing a time-based snapshot of data

## Atomicity
Atomicity suggests that every transaction should be treated as an atomic operation. 
It means the operation is successful only if all its steps executes successfully,
and failure of any single step within it
which would result in failing the entire operation. 

Atomicity helps database by:
- **Preventing inconsistent data** as it guarantees complete success or failure, and not a mix of both which leads to inconsistent data
- **Ensuring data integrity** by preventing corruption in data due to partial changes
- **Handling failure gracefully** like rolling back data to original state before transaction began in case of outages.
- **Simplified error handling** as developer won't have to worry about partially completed queries.
 
Database systems implements atomicity differently based on their architecture and consistency model. 
The most commonly strategies used are:
- **Write-Ahead Logging (`WAL`)**: Changes are recorded to in a sequential log file before applying them to actual data on disk.
  You can apply these changes on disk when a COMMIT command is issued, or discard them easily if ROLLBACK is issued.
- **Shadow Paging**: This technique creates a new copy of data pages that are to be modified during transaction. Now changes during
  transaction can be directly recorded on this page. COMMIT command can be easily applied by switching the pointer from old to new page,
  and ROLLBACK can be executed by simply discarding the shadow page.
- **Two-Phase Commit (2PC)**: Used to ensure atomicity across multiple database nodes in a distributed system. 
  Phase 1 (prepare) involves coordinating node asking all the involved nodes to prepare for commit, 
  to which the nodes write to an undo log and guarantee they can commit the transaction if asked. 
  In Phase 2 (commit), if all nodes responded positively during prepare step, the coordinator sends a commit command, otherwise
  it sends a rollback command to all nodes.

Across different database types, RDBMS typically relies on WAL to ensure strong atomicity. 
While NoSQL databases commonly relaxes the strict requirement of atomicity, in favour of higher performance and availability.


## Isolation
When you've multiple concurrent transaction interacting with same piece of data, you can get unexpected results like
mismatching records in a transaction where another transaction changes your data midway, or losing your update due to
write from another transaction and many more.
All these unexpected behaviours are known as **read phenomena** and all of them are caused due to direct interference from other transaction.

You can avoid these read phenomenas by **isolating** your data from outside interference.
To achieve this, database systems provides you with different **Isolation levels** from lowest (**Read Uncommitted**) to highest (**Serializable**).
The choice of level balances performance with data consistency, with higher isolation levels providing greater data integrity but potentially causing more blocking and lower performance.
As such you should always decide the level of Isolation based on your workload so that it isn't impacted by any undesired read phenomena.

Below are some of the most common Read phenomena along with the Isolation Level to solve them:
- **Dirty Reads**: If we allow our transaction to read uncommitted data from other transaction, its considered dirty as the data could be rolled back. 
  You can avoid this behaviour by using the Isolation Level of **Read Committed** and above which guarantees that your transaction always reads committed data.
- **Non-repeatable reads**: Now your transaction is reading only committed data, but you could still have inconsistent reads if your transaction reads same data entry twice. 
  Often this repeated read is hidden from direct point of view, for example we might read an entry once for its value and for second time when aggregating the column. 
  
  The inconsistency might occur if we've another transaction commit their changes in between our repeated read. 
  To avoid this you can use Isolation level of **Repeatable Read** and above 
  which keeps separate version of entries involved in transaction at the start of transaction. This ensures that your reads can be repeated consistently using same version of entries.      
- **Phantom Reads**: Even with repeatable read, new rows committed from other transaction could sneak in your query range which couldn't have been versioned by repeatable read isolation level 
  leading to inconsistent data. This can be avoided using Isolation level of **Serializable** which basically ensures that concurrent transactions are executed one after another preventing all read phenomenas.

These isolation levels are implemented using various mechanisms like 
- **Locking**: Commonly involves shared (read) and exclusive (write) locks to control access. This can lead to deadlocks if not handled properly.
- **Multiversion Concurrency Control (MVCC)**: Involves creating multiple versions of data to see consistent snapshot of database at a point in time which allows non-blocking reads and writes among concurrent readers and writers.

## Consistency

Consistency plays an important role in development of different database platforms like SQL, NoSQL, Graph, etc. 
But when defining Consistency, it actually comes in two forms
1. **Data Consistency** ensures consistent data w.r.t to the defined data model like referential integrity or counts.
   Orphaned references should be cleaned up by either database or application to avoid inconsistent data.
2. **Read Consistency** ensures consistent data across different instances of database servers. 
   It ensures that a transaction sees the most recent committed changes immediately. 
   This challenge is introduced due to **Replication**, specifically when data written to primary isn't yet synced to replicas.
   To optimize for performance, we usually trade off these criteria, such as in case **Eventual consistency** where the application is allowed temporarily to show stale data before eventually becoming consistent.
   **Synchronous replication** offers stronger consistency but is a lot slower compared to asynchronous approaches which boils it down to trade off.
    

## Durability
**Durability** ensures changes from a committed transaction are permanently stored on non-volatile storage (e.g., SSD, HDD)
— even if the system losses power loss or crashes.

Database Systems play around a lot with this concept to optimize their performance since writing to disk is slower in magnitude compared to writing to memory.
Some Databases write to memory first and then flush the changes to disk in bulk which is a compromise with durability since all the data case of power loss is lost from memory.
To avoid such cases, a separate data structure is maintained which stores the changes to table on disk in delta.
The data structure can be replayed before restarting a database to restore it to the original state and as such avoid any data loss. 
The only reason its possible is due small size of delta being written to disk.
<blockquote>
When you save data to disk, OS may lie about it being persisted because it caches the writes first before flushing to disk for better performance.
So Databases instead use the fsync command to force immediate disk writes, ensuring durability but at a performance cost.
</blockquote>

Some Databases like Redis even offer configurable durability — from strong (immediate writes) to eventual (delayed persistence) — letting users choose between speed and safety.

---
At the end of day, if a transaction is reported as committed, the data **must** be recoverable after a crash — or the system breaks the durability promise.
For mission-critical systems, strong durability is non-negotiable; for less critical data, eventual durability may be acceptable. 
All of this boils down to trade off between different metrics and its upto the developer to decide which is most important for their workload.