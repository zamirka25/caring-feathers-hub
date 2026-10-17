-- Caring Feathers - secure Documents vault (table + private storage bucket + policies)
-- Run ONCE: Supabase -> SQL Editor -> New query -> clear the box -> paste -> Run
create table if not exists documents (
  id text primary key,
  category text default 'Other',
  label text default '',
  month text default '',
  home text default '',
  file_path text default '',
  file_name text default '',
  size bigint default 0,
  updated_at timestamptz default now()
);
alter table documents enable row level security;
drop policy if exists "team can do everything" on documents;
create policy "team can do everything" on documents for all to authenticated using (true) with check (true);
do $$ begin
  begin alter publication supabase_realtime add table documents; exception when duplicate_object then null; end;
end $$;

-- Private storage bucket for the files themselves
insert into storage.buckets (id, name, public) values ('cf-docs','cf-docs', false) on conflict (id) do nothing;
drop policy if exists "cf docs read" on storage.objects;
drop policy if exists "cf docs write" on storage.objects;
drop policy if exists "cf docs update" on storage.objects;
drop policy if exists "cf docs delete" on storage.objects;
create policy "cf docs read" on storage.objects for select to authenticated using (bucket_id = 'cf-docs');
create policy "cf docs write" on storage.objects for insert to authenticated with check (bucket_id = 'cf-docs');
create policy "cf docs update" on storage.objects for update to authenticated using (bucket_id = 'cf-docs');
create policy "cf docs delete" on storage.objects for delete to authenticated using (bucket_id = 'cf-docs');
