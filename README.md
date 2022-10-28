[![Ruby Style Guide](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/testdouble/standard)
![Run CI](https://github.com/hathitrust/crms/workflows/Run%20CI/badge.svg)

# rights_database
Ruby interface to the HathiTrust Rights Database and related tables.

Note: some of the tables exposed by this module -- namely `access_stmts` and `access_stmts_map`
actually reside in the `ht_repository` database rather than `ht_rights`. Rather than try to
juggle two database connections we use the simplifying mechanism of the `ht` database which
is a collection of views into `ht_rights`, `ht_reposotory`, `ht_web`. This also allows us to
use the `db-image` Docker image for local testing, as it consists of a single unified database.

## Quick Setup

```
docker-compose build
docker-compose run --rm test bundle install
docker-compose up -d mariadb
docker-compose run --rm test
```

For noodling with the source code, Bundler has provided `bin/console` which is just IRB
with the needed `require`s.

```
docker-compose run --rm test bin/console
irb(main):001:0> RightsDatabase::VERSION
=> "0.1.0"
```

## Objects and Database Tables
Aside from `rights_current` and `rights_log` (which are multi-million-row tables
in a production environment), all other tables are best read once and cached in memory.
Hence, you will typically call `RightsDatabase.access_profiles` instead of
`RightsDatabase::AccessProfiles.new` to take advantage of the fact that the former is
a de facto singleton.

This means that in the unlikely event that one of these supporting tables changes during
execution of your program, this library will be unaware and you will receive incomplete
results.

For all the tables below, refer to
[the `db-image` schema](https://github.com/hathitrust/db-image/sql/000_ht_schema.sql).

Most support tables that have an `id` primary key and a `name` field can be indexed by either.
Exceptions will be noted.

### `AccessProfiles`: `ht.access_profiles`
A simple table with only four rows: `open`, `google`, `page`, and `page+lowres`.
They can be indexed by `access_profiles.id` or by `access_profiles.name`.

```ruby
RightsDatabase.access_profiles[1]
# Alternatively...
RightsDatabase.access_profiles["open"]

```

See [seed data](https://github.com/hathitrust/db-image/sql/002_access_stmts.sql).

### `AccessStatements`: `ht.access_stmts`
Provides metadata from HathiTrust Access and Use Policies statements for entries in `access_stmts_map` (below).

Note that this table does not have a numeric primary key so lookup is provided only on `access_stmts.stmt_key`.

```ruby
irb(main):004:0> RightsDatabase.access_statements["pd-us"].unknown?
=> false
irb(main):003:0> RightsDatabase.access_statements[1].unknown?
=> true
```

See [seed data](https://github.com/hathitrust/db-image/sql/002_access_stmts.sql).

### `AccessStatementsMap`: `ht.access_stmts_map`
Maps `Attribute` and `AccessProfile` to `AccessStatement`.

See [seed data](https://github.com/hathitrust/db-image/sql/003_access_stmts_map.sql).

Typical usage:
```ruby
r = RightsDatabase::Rights.new(item_id: "test.pd_google")
RightsDatabase.access_statements_map[attribute: r.attribute, access_profile: r.access_profile]
```

Shortcut version:
```ruby
RightsDatabase.access_statements_map.for(rights: r)
```

### `Attributes`: `ht.attributes`

Like `AccessProfiles`, can be indexed by `id` or `name`. `RightsDatabase.attributes[1]` and
`RightsDatabase.attributes["pd"]` return the same object.

See [seed data](https://github.com/hathitrust/db-image/sql/004_attributes.sql).

### `DB`

Call `RightsDatabase.db` if connecting with `ENV["RIGHTS_DATABASE_CONNECTION_STRING"]` and
need no further customization. This is the method the other `RightsDatabase`
classes to get access to the database connection.

Call `RightsDatabase.connect` as a one-time initialization if you need more control,
or if for some reason you need to kick off a second connection with different credentials.
The keyword arguments and/or environment variables to use with that method are documented
in `lib/rights_database/db.rb`.

Both methods return `Sequel::Mysql2::Database`.

### `Reasons`: `ht.reasons`

Like `Attributes`, can be indexed by `id` or `name`. `RightsDatabase.reasons[1]` and
`RightsDatabase.reasons["bib"]` return the same object.

See [seed data](https://github.com/hathitrust/db-image/sql/010_reasons.sql).

### `Rights`: `ht.rights_current` (`ht.rights_log` is a TODO)

Possibly the only class with which you will actually use the `#new` method. This kicks
off a SQL query for the current rights for the given `item_id`.

```ruby
irb(main):021:0> RightsDatabase::Rights.new(item_id: "test.pd_open").tap { |r| pp r }.to_s
#<RightsDatabase::Rights:0x00007f275dc9ba40
 @access_profile=                                                                                                                        
  #<RightsDatabase::AccessProfile:0x00007f275dc3f740                                                                                     
   @description="Unrestricted image and full-volume download (e.g. Internet Archive)",                                                   
   @id=1,                                                                                                                                
   @name="open">,                                                                                                                        
 @attribute=#<RightsDatabase::Attribute:0x00007f275dc98e08 @description="public domain", @id=1, @name="pd", @type="copyright">,          
 @id="pd_open",                                                                                                                          
 @item_id="test.pd_open",                                                                                                                
 @namespace="test",                                                                                                                      
 @note=nil,                                                                                                                              
 @reason=#<RightsDatabase::Reason:0x00007f275dc9c5d0 @description="bibliographically-derived by automatic processes", @id=1, @name="bib">,
 @source=                                                                                                                                
  #<RightsDatabase::Source:0x00007f275dcaf400                                                                                            
   @access_profile=                                                                                                                      
    #<RightsDatabase::AccessProfile:0x00007f275dcae0c8
     @description="Restricted public full-volume download - watermarked PDF only, when logged in or with Data API key (e.g. Google)",
     @id=2,
     @name="google">,
   @description="Google",
   @digitization_source="google",
   @id=1,
   @name="google">,
 @time=2009-01-01 05:00:00 +0000,
 @user="libadm">
=> "pd/bib"
```

Note `#to_s` produces the familiar "attr/reason" format.

See [seed data](https://github.com/hathitrust/db-image/sql/011_rights_current.sql).

### `Sources`: `ht.sources`
Maps institutions or organizational units to description, `AccessProfile`, and digitization source.

Index by `id` or `name`. `RightsDatabase.sources[1]` and `RightsDatabase.sources["google"]` are identical.

See [seed data](https://github.com/hathitrust/db-image/sql/012_sources.sql).
