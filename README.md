# Proof of Concept

## TL;DR

1. set up DB-0 and DB-1 (DB-1 will be wiped)
1. apply Workbench to DB-1
1. run `make all`
1. observe the created migration scripts
1. apply them to DB-0 by `make migrate`


## Goal

To automate creating of incremental migrations
upon MySQL database, continue using
MySQL Workbench as a single source of truth.

## Terms

1. WB-0: base version of Workbench
1. WB-1: next version of Workbench
1. DB-0: base db, consistent with WB-0
1. DB-1: another empty db
1. model_0.py: SqlAlchemy models, consistent with WB-0
1. model_1.py: SqlAlchemy models, consistent with WB-1

## Approach

1. We start with: model.py, DB-0 and WB-0, 
    all mutually consistent.
1. Next, we update WB-0, end up with WB-1.
1. Next, one have to apply WB-1 to the DB-1.
    DB-1 will be created from scratch and
    filled up with data from WB-1.
1. Next, we have to create new python models
    against WB-1. A tool `sqlacodegen` will help
    with that task. And we end up with model_1.py
1. At this moment, model_1.py looks like
    an "updated" model against DB-0.
    Now we can create migration scripts using alembic.
1. We call alembic to create incremental migration.
    They are in Python by default, but AFAIR it can
    produce SQL. However, Python version consists of
    both upgrade & downgrade instructions.
1. Now we can apply migrations to DB-0.
1. At this moment, we end up with:
    1. WB-1, new version of DB schema
    1. the upgraded DB-0, consistent with WB-1.
        One can compare it with the DB-1 just to be sure.
        Or use as he wants (for local dev, for example).
        If migrations were applied correctly,
        then all data - i.e. dev/staging - will stay alive.
        No need to repopulate the DB from fixtures etc.
    1. models_1.py, which is consistent with WB-1.
        Can be used in lambda, for instance.
    1. models_0.py can be removed and replaced with model_1.py.
    1. DB-1 may be reset until next cycle.

## Usage

The only point we cannot automate
is to apply WB-1 to DB-1. So it MUST be done manually.
One MUST provide links to the DB-0 and DB-1 as well.

So, basically, one should just apply
the Workbench onto DB-1, and run `make all`.
After the review migrations can be applied
by issuing `make migrate` command.

This POC uses Dynaconf to configure all that stuff.
So links to the DB MIGHT be given either via proper ENVs
or via config/.secrets.yml. Parameter names are described
in the config/settings.yml in `default` section.
