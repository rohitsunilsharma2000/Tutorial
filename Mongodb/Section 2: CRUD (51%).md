# CRUD Section (51%)

## Table of Contents
1. [Insert Command Scenarios](#insert-command-scenarios)
2. [Full Document Update](#full-document-update)
3. [$set Update Scenario](#set-update-scenario)
4. [Upsert Command](#upsert-command)
5. [Multiple Documents Update](#multiple-documents-update)
6. [findAndModify Concurrent Operation](#findandmodify-concurrent-operation)
7. [Document Deletion](#document-deletion)
8. [Single Document Lookup](#single-document-lookup)
9. [Equality Query on Array Field](#equality-query-on-array-field)
10. [Relational Operator Query](#relational-operator-query)
11. [$in Query](#in-query)
12. [$elemMatch Query](#elemmatch-query)
13. [Logical Operator Query](#logical-operator-query)
14. [Sort and Limit Query](#sort-and-limit-query)
15. [Projection Expression](#projection-expression)
16. [Cursor Results](#cursor-results)
17. [Count Matching Documents](#count-matching-documents)
18. [Search Index Definition](#search-index-definition)
19. [Search Query](#search-query)
20. [Aggregation with $match and $group](#aggregation-with-match-and-group)
21. [Aggregation with $lookup](#aggregation-with-lookup)
22. [Aggregation with $out](#aggregation-with-out)

## Insert Command Scenarios
**Routine:**
- Properly formed insert commands involve a correctly structured document that matches the schema of the collection.
- Improperly formed insert commands may include syntax errors, mismatched fields, or missing required fields.


## Full Document Update
**Routine:**
- When updating an entire document (without update operators), the provided document will replace the existing one.
- The document will be completely replaced with the new data, and the database will reflect the updated state.

## $set Update Scenario
**Routine:**
- Using `$set` allows updating specific fields in a document.
- Only the specified fields will be modified, while other fields remain unchanged.
- The updated document will reflect the changes in the fields set by `$set`.

## Upsert Command
**Routine:**
- In a scenario where a document should be inserted if it doesn’t already exist, the correct command will use `upsert: true`.
- If the document exists, it is updated; if not, it is inserted.

## Multiple Documents Update
**Routine:**
- To update multiple documents, the `updateMany()` method should be used with the appropriate query and update expressions.
- The update expression will specify how the documents should be modified.

## findAndModify Concurrent Operation
**Routine:**
- In a `findAndModify` operation where another operation is run concurrently, the database will apply the first operation and then apply the second operation.
- The final state of the document depends on the order and nature of the operations.

## Document Deletion
**Routine:**
- The correct delete expression should use `deleteOne()` or `deleteMany()` depending on whether one or multiple documents need to be deleted.
- The query will specify which document(s) should be removed.

## Single Document Lookup
**Routine:**
- A simple query to find a single document using an equality constraint (e.g., `{x: 3}`) will use the `findOne()` method.
- The expression specifies the field and value to match.

## Equality Query on Array Field
**Routine:**
- To match documents with an equality constraint on an array field, use the `find()` method with a query that specifies an array field and an exact value.
- This will match documents where the array field contains the exact value specified.

## Relational Operator Query
**Routine:**
- Use relational operators (e.g., `$gt`, `$lt`, `$gte`, `$lte`) to find documents based on the value of a field in relation to another value.
- For example, `{age: {$gt: 25}}` will match documents where the age is greater than 25.

## $in Query
**Routine:**
- The `$in` operator is used to match documents where a field's value is within a specified list of values.
- The query would look like `{status: {$in: ["active", "pending"]}}`.

## $elemMatch Query
**Routine:**
- The `$elemMatch` operator is used to match documents with an array that contains at least one element that matches the specified query.
- For example, `{tags: {$elemMatch: {$eq: "mongodb"}}}` will match documents where the `tags` array contains the value "mongodb".

## Logical Operator Query
**Routine:**
- Logical operators like `$and`, `$or`, and `$not` can combine multiple conditions in a query.
- For example, `{$and: [{age: {$gt: 25}}, {status: "active"}]}` will match documents where both conditions are true.

## Sort and Limit Query
**Routine:**
- Use the `sort()` method to order documents and `limit()` to restrict the number of results returned.
- For example, `db.collection.find().sort({age: 1}).limit(5)` will return the first 5 documents sorted by age in ascending order.

## Projection Expression
**Routine:**
- A projection expression is used to specify which fields should be included or excluded from the result set.
- For example, `{name: 1, age: 0}` will return only the `name` field and exclude the `age` field from the document.

## Cursor Results
**Routine:**
- To retrieve all documents from a cursor, the `toArray()` method can be used.
- For example, `cursor.toArray()` will return all documents in the cursor as an array.

## Count Matching Documents
**Routine:**
- To count the number of documents matching a query, use the `countDocuments()` method.
- For example, `db.collection.countDocuments({status: "active"})` will return the count of documents where the `status` is "active".

## Search Index Definition
**Routine:**
- The correct command for defining a search index is `createIndex()`.
- For example, `db.collection.createIndex({name: 1})` creates an index on the `name` field.

## Search Query
**Routine:**
- A search query can be defined using `find()` or the `$text` operator for full-text search.
- For example, `{ $text: { $search: "mongodb" } }` searches for documents containing the word "mongodb".

## Aggregation with $match and $group
**Routine:**
- The `$match` stage filters documents, while `$group` groups them by a specified field.
- For example, `{$match: {status: "active"}}, {$group: {_id: "$age", count: {$sum: 1}}}` will group active users by age and count them.

## Aggregation with $lookup
**Routine:**
- The `$lookup` stage performs a left outer join with another collection.
- For example, `{$lookup: {from: "orders", localField: "_id", foreignField: "userId", as: "user_orders"}}` will join data from the "orders" collection.

## Aggregation with $out
**Routine:**
- The `$out` stage outputs the result of the aggregation to a new collection.
- For example, `{$out: "aggregated_results"}` will store the aggregation result in the `aggregated_results` collection.
