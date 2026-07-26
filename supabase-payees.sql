create table if not exists payees (
  id text primary key,
  name text default '',
  sort_code text default '',
  account_number text default '',
  updated_at timestamptz default now()
);
alter table payees enable row level security;
drop policy if exists "team can do everything" on payees;
create policy "team can do everything" on payees for all to authenticated using (true) with check (true);
do $$ begin
  begin alter publication supabase_realtime add table payees; exception when duplicate_object then null; end;
end $$;
