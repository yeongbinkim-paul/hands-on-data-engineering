CREATE TABLE IF NOT EXISTS public.data_lake_total_visit
(
    date timestamptz not null,
    day character(10) not null,
    total_visit integer not null
);

CREATE INDEX idx_dl_tv ON public.data_lake_total_visit (date, day);
CREATE UNIQUE INDEX udx_dl_tv ON public.data_lake_total_visit (date, day);
