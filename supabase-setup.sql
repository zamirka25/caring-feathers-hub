-- Caring Feathers Finance Hub — shared database setup
-- Paste this whole file into Supabase: SQL Editor -> New query -> Run

create table if not exists homes (
  id text primary key,
  name text not null,
  city text default '',
  manager text default '',
  bank text default '',
  monthly_budget numeric default 0,
  active boolean default true,
  residential boolean default false,
  last_ofsted_date text default '',
  ofsted_rating text default '',
  next_ofsted_date text default '',
  updated_at timestamptz default now()
);

create table if not exists young_people (
  id text primary key,
  initials text default '',
  home text default '',
  council text default '',
  date_in text default '',
  date_out text default '',
  ipa_received boolean default false,
  ipa_date text default '',
  notes text default '',
  updated_at timestamptz default now()
);

create table if not exists bills (
  id text primary key,
  home text not null,
  category text not null,
  vendor text default '',
  bank_account text default '',
  frequency text default 'Monthly',
  amount text default '',
  next_due_date text default '',
  reminder_days int default 7,
  status text default 'Pending',
  notes text default '',
  updated_at timestamptz default now()
);

create table if not exists payments (
  id text primary key,
  bill_id text default '',
  home text default '',
  category text default '',
  paid_date text default '',
  amount text default '',
  method text default '',
  notes text default '',
  updated_at timestamptz default now()
);

-- Security: only signed-in team members can read or write
alter table homes enable row level security;
alter table bills enable row level security;
alter table payments enable row level security;
alter table young_people enable row level security;

drop policy if exists "team can do everything" on homes;
drop policy if exists "team can do everything" on bills;
drop policy if exists "team can do everything" on payments;
drop policy if exists "team can do everything" on young_people;

create policy "team can do everything" on homes for all to authenticated using (true) with check (true);
create policy "team can do everything" on bills for all to authenticated using (true) with check (true);
create policy "team can do everything" on payments for all to authenticated using (true) with check (true);
create policy "team can do everything" on young_people for all to authenticated using (true) with check (true);

-- Live sync: broadcast changes to all connected devices
do $$
begin
  begin
    alter publication supabase_realtime add table homes;
  exception when duplicate_object then null;
  end;
  begin
    alter publication supabase_realtime add table bills;
  exception when duplicate_object then null;
  end;
  begin
    alter publication supabase_realtime add table payments;
  exception when duplicate_object then null;
  end;
  begin
    alter publication supabase_realtime add table young_people;
  exception when duplicate_object then null;
  end;
end $$;
