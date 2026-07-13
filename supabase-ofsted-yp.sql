-- Caring Feathers — add Ofsted tracking + Young People
-- Run ONCE on the existing database: Supabase -> SQL Editor -> New query -> paste -> Run
alter table homes add column if not exists residential boolean default false;
alter table homes add column if not exists last_ofsted_date text default '';
alter table homes add column if not exists ofsted_rating text default '';
alter table homes add column if not exists next_ofsted_date text default '';
update homes set residential = true where residential is not true and name ilike '%lodge%';

create table if not exists young_people (
  id text primary key,
  initials text default '', home text default '', council text default '',
  date_in text default '', date_out text default '',
  ipa_received boolean default false, ipa_date text default '',
  notes text default '', updated_at timestamptz default now()
);
alter table young_people add column if not exists ipa_received boolean default false;
alter table young_people add column if not exists ipa_date text default '';
alter table young_people enable row level security;
drop policy if exists "team can do everything" on young_people;
create policy "team can do everything" on young_people for all to authenticated using (true) with check (true);
do $$ begin
  begin alter publication supabase_realtime add table young_people; exception when duplicate_object then null; end;
end $$;
