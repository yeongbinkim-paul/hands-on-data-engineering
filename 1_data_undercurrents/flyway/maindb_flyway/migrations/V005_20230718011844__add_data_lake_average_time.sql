CREATE TABLE IF NOT EXISTS public.data_lake_avg_time
(
    date timestamptz not null,
    day integer not null,
    avg_time character(20) not null
);

CREATE INDEX idx_dl_avg_t ON public.data_lake_avg_time (date, day);
CREATE UNIQUE INDEX udx_dl_avg_t ON public.data_lake_avg_time (date, day);
