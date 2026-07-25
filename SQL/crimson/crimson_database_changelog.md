Any time you make a change to the schema files, remember to increment the database schema version. Generally increment the minor number, major should be reserved for significant changes to the schema. Both values go up to 255. Keep this up to date with `../database_changelog.md` and be sure to update that one's latest database version accordingly as well.

Make sure to also update `DB_MAJOR_VERSION` and `DB_MINOR_VERSION`, which can be found in `code/__DEFINES/subsystem.dm`.

The latest database version is 5.36; The query to update the schema revision table is:

```sql
INSERT INTO `schema_revision` (`major`, `minor`) VALUES (5, 36);
```

or

```sql
INSERT INTO `SS13_schema_revision` (`major`, `minor`) VALUES (5, 36);
```

In any query remember to add a prefix to the table names if you use one.

---

Version 5.36, 21 April 2026, by Flleeppyy

Remove `stickyban` and its related tables.
Also fixed some `CREATE TABLE` statements to remove `IF NOT EXISTS` since that was literally useless after `DROP TABLE IF EXISTS`

```sql
DROP TABLE IF EXISTS `stickyban`;
DROP TABLE IF EXISTS `stickyban_matched_ckey`;
DROP TABLE IF EXISTS `stickyban_matched_ip`;
DROP TABLE IF EXISTS `stickyban_matched_cid`;
```
