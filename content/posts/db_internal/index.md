---
title: "Database Internals: Exploring Disk Storage"
description: "Explore how database storage different data structure on disk"
categories: [Database]
tags: [Fundamentals, Internals]
date: 2025-06-20
---

In this article, we'll explore how databases store data on disk and how it impacts different kinds of workloads.
By the end, you'll have a clear understanding of how modern databases manage, store, and retrieve data. 
This can help you 
- **Write better queries** that work with, not against, the database engine
- **Design more efficient schemas** that minimize storage overhead and maximize performance
- **Troubleshoot performance issues** by understanding what causes bottlenecks
- **Make informed architectural decisions** when choosing between different database systems


## Essential Database Terminology

Before diving into core concept, it is important to have some understanding of few terminologies used across the database domain

**Table**: A collection of rows and columns, similar to a spreadsheet. 
Each row represents a record, and each column represents a specific piece of information about that record.

**RowID (TupleID)**: A unique identifier that the database assigns to each row internally.
Some databases like PostgreSQL manage this automatically, while others allow you to use your primary key for this purpose.

**Page**: Fixed-size blocks on disk that store multiple rows or columns. 
When the database needs to fetch a single row, it must load the entire page containing that row into memory.
This is why page organization is crucial for performance.

**I/O (Input/Output)**: The expensive operation of reading pages from disk into memory.
Since disk access is much slower than memory access, minimizing I/O operations is key to database performance.

**Heap**: The basic data structure where tables are stored as pages.
Without indexes, the database must scan through the entire heap to find specific data—a slow process for large datasets.

**Indexes**: Special data structures that act like a book's index, helping the database quickly locate specific rows without scanning the entire table.
They're stored as pages too, so their size directly impacts lookup performance.

## How Databases Store Tables on Disk
Tables in databases are organized in fixed-size pages where each page can hold onto multiple rows.
When you query for a specific row, the database doesn't just grab that one row.
Instead, it loads the entire page containing that row into memory.
This size limit on pages varies across different database systems like **PostgreSQL** uses 8KB pages while **MySQL (InnoDB)** uses 16KB pages.

The choice of page size involves trade-offs. Smaller pages mean faster reads and writes when you only need a little data, but they also mean more overhead from page headers and metadata.
Larger pages reduce metadata overhead and are better for sequential scans, but they waste space when you only need a small amount of data.

Every page follows a structured layout designed for efficiency. Let's look at PostgreSQL's page structure as an example:

1. **Page Header** (24 bytes): Contains metadata about the page, including information about free space and the last write-ahead log entry
2. **Item IDs** (4 bytes each): An array of pointers that indicate where each row is located within the page
3. **Items** (variable length): The actual data rows
4. **Special Space** (variable length): Used by B-tree indexes to link pages together

This structure allows for efficient insertion, deletion, and updates without disrupting the entire page layout.
However, it's also important to consider how data within pages are laid out and this choice drastically impacts performance for different types of workloads.

## Storage Models: Row Store vs Column Store
The Storage Model of a database decides how the entries are laid out on a disk.  
In **row-oriented** storage model, complete rows are stored together on each page sequentially.
If you have a customer table with name, email, phone, and address fields, all these fields for each customer are stored side by side.
While **Column-oriented** storage model groups all values for each column together.
Instead of storing complete customer records on each page, you'd have separate pages for names, emails, phone numbers, and addresses.
Both approaches have pros and cons depending on the type of workload

| *Aspect* | *Row Store*                                                                                      | *Column Store* |
| --- |--------------------------------------------------------------------------------------------------| --- |
| *Good for...* | transactional workloads (OLTP) where you frequently insert, update, or retrieve complete records | Exceptional performance for analytical queries (OLAP) and aggregations |
| *Insert speed* | Fast (write whole row at once) | Slower (must update all columns present in different blocks) |
| *Read for full record* | Efficient  | Expensive |
| *Read for few columns* | Inefficient  | Highly efficient |
| *Compression* | Limited compression opportunities due to mixed data types| Excellent compression ratios since similar data types are stored together |
| *Indexing needs* | Often needs indexes| May not need indexes |


## Clustered Index / Index On Table (IOT)
Clustered Index allows you to store the table data within the index itself. 
They're based on B-tree indexes where the Intermediate Nodes contain indexed column as the key and leaf nodes contain the respective rows and pages.
All the leaf nodes are ordered and interconnected with their previous and next values allowing for efficient range querying.
Since the table itself is organized with the index, you can only have one Clustered Index per Table. 
The Rest of the indexes are known as Secondary Indexes and points to these index Nodes.

In **PostgreSQL**, all indexes are Secondary Indexes since it maintains internal *RowId* as the primary key, and the rest of the indexes points to this RowId. You can explicitly `CLUSTER` the table around an index, but it's not maintained with inserts/updates.

In **MySQL (InnoDB)**, the primary key *is* the table. It’s an *Index-Organized Table (IOT)*. That’s why MySQL *requires* a primary key: because the actual row data is physically stored with the primary key in a B-Tree. If you don’t define one, it creates a hidden one.

**Oracle** makes this all very explicit. You get to choose:
  - *Heap Organized Table (HOT)* — default behavior where rows are stored sequentially without any order.
  - *Index-Organized Table (IOT)* — table *is* the index i.e., rows are stored around the index in an order.

Oracle naming really helps as it’s a clean way to communicate intent.
    
**SQL Server** gives you a similar choice. You can define:
    — A *clustered index* (only one per table).
    — Or keep it *heap-organized* and have non-clustered indexes instead.

**Trade off for using Clustered Indexes**:

- Clustering comes at a cost—because inserts are no longer just append-only; they must maintain order.
- Smart storage engines (Postgres, Oracle, MySQL) avoid naive insert strategies by pre-allocating space (page management) for future rows.
- Range queries benefit *hugely* from clustering (low I/O, good cache locality).
- Random PKs like UUIDs are problematic for clustered tables due to page splits and fragmentation—especially visible in InnoDB.


## Memory Management: The Buffer Pool

One of the most critical parts for database performance is the buffer pool—the database's main memory cache for frequently accessed pages.

When you query data, the database first checks if the required pages are already in the buffer pool.
If they are (a "hit"), the data is returned immediately from memory.
If not (a "miss"), the database must read the pages from disk, which is significantly slower.

The buffer pool uses sophisticated algorithms to decide which pages to keep in memory and which to evict when space is needed.
The most common approach is a variation of the Least Recently Used (LRU) algorithm, which removes pages that haven't been accessed recently.

**Buffer Pool Optimization Strategies**:

- **Multiple Buffer Pools**: Reduce contention by creating separate pools for different purposes
- **Pre-fetching**: Load pages into memory before they're needed based on query patterns
- **Scan Sharing**: Allow multiple queries to share a single table scan operation


## Conclusion
What you store in pages is up to you and heavily depends on the kind of workload.

**Row-store** databases write rows and all their attributes one after the other packed in the page so that **OLTP** workloads are better, especially write workload.

**Column-store** databases pack the same columns on the same page sequentially, and as such, **OLAP** workloads that run a summary with fewer fields are more efficient. A single page read will be packed with values from one column, making aggregate functions like SUM much more effective.

**Document based** databases compress documents and store them in page just like row stores

**Graph based** databases persist the connectivity in pages such that page read is efficient for traversing graphs, this also can be tuned for depth vs. breadth vs. search.

Whether you're storing rows, columns, documents, or graphs, the goal is to pack your items in the page such that a page read is effective. 
The page should give you as much useful information as possible to help with the client side workload.
If you find yourself reading many pages to do tiny little work, consider rethinking your data modeling.