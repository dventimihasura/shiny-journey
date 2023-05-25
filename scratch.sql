-- -*- sql-product: postgres; -*-

create table agent (like account including all);

create table agent_region (
  agent_id uuid references agent (id),
  region text unique references region (value)
  );

with
  random_sample as (
    select
      name
      from
	account
     order by random()
     limit (select count(1) from region))
    insert into agent (name) select
			       *
			       from
				 random_sample;

with
  ordered_sample as (
    select
      *,
      row_number() over () ordinal
      from
	agent),
  region as (
    select
      *,
      row_number() over () ordinal
      from
	region
     order by random())
    insert into agent_region select
			       ordered_sample.id,
			       region.value region
			       from
				 region
				 natural join ordered_sample;
